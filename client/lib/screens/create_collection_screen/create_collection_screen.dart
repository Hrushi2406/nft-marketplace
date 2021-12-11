import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nfts/core/services/image_picker_service.dart';
import 'package:nfts/core/services/ipfs_service.dart';
import 'package:nfts/core/utils/debouncer.dart';
import 'package:nfts/core/utils/utils.dart';
import 'package:nfts/core/widgets/custom_widgets.dart';
import 'package:nfts/models/collection_metadata.dart';
import 'package:nfts/provider/collection_provider.dart';
import 'package:nfts/provider/wallet_provider.dart';
import 'package:nfts/screens/confirmation_screen/confirmation_screen.dart';
import 'package:nfts/screens/network_confirmation/network_confirmation_screen.dart';
import 'package:nfts/screens/wallet_init_screen/wallet_init_screen.dart';
import 'package:provider/provider.dart';

import '../../locator.dart';

class CreateCollectionScreen extends StatefulWidget {
  const CreateCollectionScreen({Key? key}) : super(key: key);

  @override
  _CreateCollectionScreenState createState() => _CreateCollectionScreenState();
}

class _CreateCollectionScreenState extends State<CreateCollectionScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _symbolController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _twitterUrlController = TextEditingController();
  final TextEditingController _websiteUrlController = TextEditingController();

  String? _pickedImagePath;
  final Debouncer _debouncer = Debouncer(milliseconds: 2000);

  _pickImage() async {
    final image = await ImagePickerService.pickImage();

    if (image != null) {
      _pickedImagePath = image.path;

      setState(() {});

      _debouncer.run(() =>
          Provider.of<CollectionProvider>(context, listen: false)
              .uploadImage(image.path));
    }
  }

  _isImagePicked() {
    if (_pickedImagePath == null) {
      Fluttertoast.showToast(msg: 'Please select a image');

      return false;
    }
    return true;
  }

  _createCollection() {
    if (_formKey.currentState!.validate() && _isImagePicked()) {
      final metadata = CollectionMetaData(
        name: _nameController.text,
        symbol: _symbolController.text,
        description: _descriptionController.text,
        twitterUrl: _twitterUrlController.text,
        websiteUrl: _websiteUrlController.text,
        image: '',
      );

      Provider.of<CollectionProvider>(context, listen: false)
          .uploadMetadata(metadata);

      Provider.of<CollectionProvider>(context, listen: false)
          .getTransactionFee(metadata);

//Navigate to other screen
      Navigation.push(context,
          screen: ConfirmationScreen(
              action: 'Miniting NFT',
              image: _pickedImagePath!,
              title: _nameController.text,
              subtitle:
                  'By ${formatAddress(Provider.of<WalletProvider>(context, listen: false).address.hex)}',
              onConfirmation: () {
                Provider.of<CollectionProvider>(context, listen: false)
                    .createCollection();
                Navigation.popTillNamedAndPush(
                  context,
                  popTill: 'tabs_screen',
                  screen: const NetworkConfirmationScreen(),
                );
              }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: space2x),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomAppBar(),

            SizedBox(height: rh(space1x)),

            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: rf(200),
                  height: rf(200),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(space1x),
                    color: Theme.of(context).colorScheme.surface,
                    image: _pickedImagePath == null
                        ? null
                        : DecorationImage(
                            image: AssetImage(_pickedImagePath!),
                            fit: BoxFit.cover,
                          ),
                  ),
                  child: _pickedImagePath == null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.add),
                            UpperCaseText(
                              ' Add image',
                              style: Theme.of(context).textTheme.headline2,
                            ),
                          ],
                        )
                      : null,
                ),
              ),
            ),

            SizedBox(height: rh(space3x)),

            //INPUT Field
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CustomTextFormField(
                    controller: _nameController,
                    // labelText: 'NAME',
                    labelText: 'Name',
                    validator: validator,
                  ),
                  SizedBox(height: rh(space2x)),
                  CustomTextFormField(
                    controller: _symbolController,
                    // labelText: 'SYMBOL',
                    labelText: 'Symbol',
                    validator: validator,
                  ),
                  SizedBox(height: rh(space2x)),
                  CustomTextFormField(
                    controller: _descriptionController,
                    labelText: 'Description',
                    // labelText: 'DESCRIPTION',
                    validator: validator,
                  ),
                  SizedBox(height: rh(space2x)),
                  CustomTextFormField(
                    controller: _twitterUrlController,
                    // labelText: 'TWITTER URL',
                    labelText: 'Twitter URL',
                    validator: urlValidator,
                    textInputType: TextInputType.url,
                  ),
                  SizedBox(height: rh(space2x)),
                  CustomTextFormField(
                    controller: _websiteUrlController,
                    labelText: 'Website URL',
                    validator: urlValidator,
                    textInputType: TextInputType.url,
                    textInputAction: TextInputAction.done,
                  ),
                  SizedBox(height: rh(space2x)),
                ],
              ),
            ),

            SizedBox(height: rh(space3x)),

            //ACTION BUTTONS
            Consumer<CollectionProvider>(
              builder: (context, provider, child) {
                return Buttons.flexible(
                  width: double.infinity,
                  isLoading: provider.state == CollectionState.loading,
                  context: context,
                  text: 'CREATE COLLECTION',
                  onPressed: _createCollection,
                );
              },
            ),

            SizedBox(height: rh(space3x)),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nfts/core/services/image_picker_service.dart';
import 'package:nfts/core/services/ipfs_service.dart';
import 'package:nfts/core/utils/utils.dart';
import 'package:nfts/core/widgets/custom_widgets.dart';
import 'package:nfts/models/collection_metadata.dart';
import 'package:nfts/provider/collection_provider.dart';
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

  _pickImage() async {
    final image = await ImagePickerService.pickImage();

    if (image != null) {
      _pickedImagePath = image.path;

      setState(() {});
      Provider.of<CollectionProvider>(context, listen: false)
          .uploadImage(image.path);
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
                      ? UpperCaseText(
                          '+ Add image',
                          style: Theme.of(context).textTheme.headline4,
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
                    labelText: 'NAME',
                    validator: validator,
                  ),
                  SizedBox(height: rh(space2x)),
                  CustomTextFormField(
                    controller: _symbolController,
                    labelText: 'SYMBOL',
                    validator: validator,
                  ),
                  SizedBox(height: rh(space2x)),
                  CustomTextFormField(
                    controller: _descriptionController,
                    labelText: 'DESCRIPTION',
                    validator: validator,
                  ),
                  SizedBox(height: rh(space2x)),
                  CustomTextFormField(
                    controller: _twitterUrlController,
                    labelText: 'TWITTER URL',
                    validator: urlValidator,
                    textInputType: TextInputType.url,
                  ),
                  SizedBox(height: rh(space2x)),
                  CustomTextFormField(
                    controller: _websiteUrlController,
                    labelText: 'WEBSITE URL',
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

import 'package:flutter/material.dart';
import 'package:nfts/core/services/image_picker_service.dart';
import 'package:nfts/core/services/wallet_service.dart';

import '../../config.dart';
import '../../core/utils/utils.dart';
import '../../core/widgets/custom_widgets.dart';
import '../tabs_screen/tabs_screen.dart';

class EditUserInfoScreen extends StatefulWidget {
  const EditUserInfoScreen({Key? key}) : super(key: key);

  @override
  _EditUserInfoScreenState createState() => _EditUserInfoScreenState();
}

class _EditUserInfoScreenState extends State<EditUserInfoScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _websiteController = TextEditingController();

  final TextEditingController _twitterController = TextEditingController();

  String? _pickedImagePath;

  _pickImage() async {
    //Pick Image
    final image = await ImagePickerService.pickImage();

    if (image != null) {
      _pickedImagePath = image;

      setState(() {});
    }
  }

  _submit() {
    if (_formKey.currentState!.validate()) {
      Navigation.popAllAndPush(
        context,
        screen: const TabsScreen(),
      );
    }
  }

  _skipForNow() {
    Navigation.popAllAndPush(
      context,
      screen: const TabsScreen(),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _websiteController.dispose();
    _twitterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WalletService.generateRandomAccount();
    WalletService.getPublicAddressFromKey();

    init();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: space2x),
        child: SingleChildScrollView(
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

              //USER ADDRESS INFO
              SizedBox(height: rh(space4x)),
              const DataTile(
                label: 'Public Address',
                value: '0x7E104F0dcB499eBcC8b680C2B83f3f35250445dE',
              ),
              SizedBox(height: rh(space3x)),
              const DataTile(
                label: 'Wallet Balance',
                value: '10 MAT - \$38 ',
              ),
              SizedBox(height: rh(space2x)),

              //INPUT
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
                      controller: _websiteController,
                      labelText: 'WEBSITE URL',
                      validator: validator,
                      textInputType: TextInputType.url,
                    ),
                    SizedBox(height: rh(space2x)),
                    CustomTextFormField(
                      controller: _twitterController,
                      labelText: 'TWITTER URL',
                      validator: validator,
                      textInputType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                    ),
                    SizedBox(height: rh(space2x)),
                  ],
                ),
              ),

              SizedBox(height: rh(space3x)),

              //ACTION BUTTONS
              Buttons.expanded(
                context: context,
                text: 'Enter the world of NFT',
                onPressed: _submit,
              ),
              SizedBox(height: rh(space3x)),

              Center(
                child: Buttons.text(
                  context: context,
                  text: 'Skip For Now',
                  onPressed: _skipForNow,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

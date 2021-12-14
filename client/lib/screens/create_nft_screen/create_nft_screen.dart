import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../../core/services/image_picker_service.dart';
import '../../core/utils/debouncer.dart';
import '../../core/utils/utils.dart';
import '../../core/widgets/custom_widgets.dart';
import '../../models/collection.dart';
import '../../models/nft_metadata.dart';
import '../../provider/nft_provider.dart';
import 'create_listing_screen.dart';
import 'widgets/add_property.dart';
import 'widgets/choose_collections_widget.dart';

class CreateNFTScreen extends StatefulWidget {
  const CreateNFTScreen({Key? key, this.collection}) : super(key: key);

  final Collection? collection;

  @override
  _CreateNFTScreenState createState() => _CreateNFTScreenState();
}

class _CreateNFTScreenState extends State<CreateNFTScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? _pickedImagePath;
  final Debouncer _debouncer = Debouncer(milliseconds: 250);

  List<Map<String, dynamic>> properties = [];
  Collection? _selectedCollection;

  @override
  void initState() {
    super.initState();
    _selectedCollection = widget.collection;
  }

  _pickImage() async {
    final image = await ImagePickerService.pickImage();

    if (image != null) {
      _pickedImagePath = image.path;

      setState(() {});

      _debouncer.run(() => Provider.of<NFTProvider>(context, listen: false)
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

  _checkIsCollectionSelected() {
    if (_selectedCollection == null) {
      Fluttertoast.showToast(msg: 'Please select a collection');

      return false;
    }
    return true;
  }

  _addProperty() {
    showModalBottomSheet(
      context: context,
      enableDrag: true,
      isScrollControlled: true,
      isDismissible: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (_) => AddPropertyWidget(add: (String type, String value) {
        properties.add({'type': type, 'value': value});
        setState(() {});
      }),
    );
  }

  _chooseCollection() {
    showModalBottomSheet(
      context: context,
      enableDrag: true,
      isScrollControlled: true,
      isDismissible: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (_) => ChooseCollectionWidget(
        selectCollection: (Collection collection) {
          _selectedCollection = collection;
          setState(() {});
        },
      ),
    );
  }

  _next() {
    if (_formKey.currentState!.validate() &&
        _isImagePicked() &&
        _checkIsCollectionSelected()) {
      //UPLOAD METADAT
      final nftMetadata = NFTMetadata(
        name: _nameController.text,
        description: _descriptionController.text,
        image: _pickedImagePath!,
        properties: properties,
      );

      Provider.of<NFTProvider>(context, listen: false)
          .uploadMetadata(nftMetadata);

      Navigation.push(
        context,
        screen: CreateNFTListingScreen(
          nftMetadata: nftMetadata,
          collection: _selectedCollection!,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: space2x),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const CustomAppBar(),
              SizedBox(height: rh(space3x)),

              //IMAGE
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
                              image: FileImage(File(_pickedImagePath!)),
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

              GestureDetector(
                onTap: _chooseCollection,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: space2x,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(space1x),
                    border: Border.all(
                      width: 1,
                      color: Colors.black26,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      UpperCaseText(
                        _selectedCollection == null
                            ? 'Choose Collection'
                            : _selectedCollection!.name,
                        style: Theme.of(context).textTheme.headline4!.copyWith(
                              color: Colors.black87,
                            ),
                      ),
                      Icon(
                        Iconsax.arrow_down_1,
                        size: rf(space2x),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: rh(space2x)),
              //INPUT Field
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CustomTextFormField(
                      controller: _nameController,
                      labelText: 'Name',
                      validator: validator,
                    ),
                    SizedBox(height: rh(space2x)),
                    CustomTextFormField(
                      controller: _descriptionController,
                      labelText: 'Description',
                      validator: validator,
                    ),
                    SizedBox(height: rh(space2x)),
                  ],
                ),
              ),

              SizedBox(height: rh(space3x)),

              //PROPERTIED
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  UpperCaseText(
                    'Properties',
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  Buttons.icon(
                    context: context,
                    icon: Iconsax.add,
                    left: rw(space1x),
                    semanticLabel: 'semanticLabekl',
                    onPressed: _addProperty,
                  ),
                ],
              ),

              SizedBox(height: rh(space2x)),

              Wrap(
                spacing: rf(12),
                runSpacing: rf(12),
                children: properties
                    .map<Widget>(
                      (e) => PropertiesChip(
                        label: e['type'],
                        value: e['value'],
                        percent: '',
                        onPressed: () {
                          properties.remove(e);
                          setState(() {});
                        },
                      ),
                    )
                    .toList(),
              ),

              SizedBox(height: rh(space4x)),
              Buttons.flexible(
                width: double.infinity,
                context: context,
                text: 'Next',
                onPressed: _next,
              ),

              SizedBox(height: rh(space6x)),
            ],
          ),
        ),
      ),
    );
  }
}

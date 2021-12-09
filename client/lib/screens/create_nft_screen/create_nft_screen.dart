import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nfts/core/services/image_picker_service.dart';
import 'package:nfts/core/utils/debouncer.dart';
import 'package:nfts/core/utils/utils.dart';
import 'package:nfts/core/widgets/custom_widgets.dart';
import 'package:nfts/screens/create_nft_screen/widgets/add_property.dart';

class CreateNFTScreen extends StatefulWidget {
  const CreateNFTScreen({Key? key}) : super(key: key);

  @override
  _CreateNFTScreenState createState() => _CreateNFTScreenState();
}

class _CreateNFTScreenState extends State<CreateNFTScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _royaltiesController = TextEditingController();

  String? _pickedImagePath;
  final Debouncer _debouncer = Debouncer(milliseconds: 2000);

  List<Map<String, dynamic>> properties = [];

  _pickImage() async {
    final image = await ImagePickerService.pickImage();

    if (image != null) {
      _pickedImagePath = image.path;

      setState(() {});

      // _debouncer.run(() =>
      // Provider.of<CollectionProvider>(context, listen: false)
      // .uploadImage(image.path));
    }
  }

  _isImagePicked() {
    if (_pickedImagePath == null) {
      Fluttertoast.showToast(msg: 'Please select a image');

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
                      controller: _descriptionController,
                      labelText: 'DESCRIPTION',
                      validator: validator,
                    ),
                    SizedBox(height: rh(space2x)),
                    CustomTextFormField(
                      controller: _royaltiesController,
                      labelText: 'ROYALTIES',
                      validator: validator,
                      textInputType: TextInputType.number,
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

              SizedBox(height: rh(space3x)),

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
            ],
          ),
        ),
      ),
    );
  }
}

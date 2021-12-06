import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
//PICKER
  static Future<XFile?> pickImage() async {
    final ImagePicker _picker = ImagePicker();

    try {
      // Pick an image
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
      );

      //Nothing picked
      if (image == null) {
        Fluttertoast.showToast(
          msg: 'No File Selected',
        );
        return null;
      } else {
        //Return Path
        return image;
      }
    } catch (e) {
      debugPrint('Error at image picker: $e');

      return null;
    }
  }
}

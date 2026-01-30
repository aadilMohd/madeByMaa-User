

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';

class SelectImg extends StatefulWidget {
  final Function(
      XFile) onImageSelected;
  const SelectImg({super.key, required this.onImageSelected});

  @override
  State<SelectImg> createState() => _SelectImgState();
}

class _SelectImgState extends State<SelectImg> {
  XFile? _image;

  Future<void> _pickImageFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = XFile(pickedFile.path);
        widget.onImageSelected(_image!);
      });
    } else {
      Get.snackbar('Error', 'No image selected.');
    }
  }

  Future<void> _takePhoto() async {
    final ImagePicker _picker = ImagePicker();
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = XFile(pickedFile.path);
        widget.onImageSelected(_image!);
      });
    } else {
      Get.snackbar('Error', 'No photo taken.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      width: Get.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Image.asset(
              Images.down,
              width: 50,color: Colors.grey,
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: _takePhoto,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    border: Border.all(color: Get.theme.disabledColor, width: 2)),
                child: Center(
                  child: Text(
                    "Take Photo",
                    style: TextStyle(
                        fontSize: Dimensions.fontSizeLarge,
                        color: Colors.grey),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(onTap: _pickImageFromGallery,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    border: Border.all(color: Get.theme.disabledColor, width: 2)),
                child: Center(
                  child: Text(
                    "Choose From Library",
                    style: TextStyle(
                        fontSize: Dimensions.fontSizeLarge,
                        color: Colors.grey),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

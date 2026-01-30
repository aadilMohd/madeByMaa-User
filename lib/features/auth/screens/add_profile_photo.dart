import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:image_compression_flutter/image_compression_flutter.dart';
import 'package:image_cropper/image_cropper.dart';

import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/auth/domain/models/upload_photo_body.dart';
import 'package:stackfood_multivendor/features/auth/screens/phone_screen.dart';
import 'package:stackfood_multivendor/features/auth/screens/select_img.dart';
import 'package:stackfood_multivendor/features/dashboard/domain/repositories/dashboard_repo.dart';
import 'package:stackfood_multivendor/features/dashboard/screens/dashboard_screen.dart';
import '../../../util/dimensions.dart';

class AddProfilePhoto extends StatefulWidget {
  const AddProfilePhoto({
    super.key,
  });

  @override
  State<AddProfilePhoto> createState() => _AddProfilePhotoState();
}

class _AddProfilePhotoState extends State<AddProfilePhoto> {
  XFile? _selectedImage;

  _updateImage(XFile image) async{

    CroppedFile? n = await cropImage(image.path);

    _selectedImage =  XFile(n!.path);
    setState(() {

    });

  }


  Future<CroppedFile?> cropImage(String filePath) async {
    return await ImageCropper().cropImage(
      sourcePath: filePath,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1), // Square aspect ratio (1:1)
      compressQuality: 80, // Compress quality
      compressFormat: ImageCompressFormat.png, // Compress format
      maxHeight: 512, // Max height
      maxWidth: 512, // Max width
      uiSettings: [
        AndroidUiSettings(
          toolbarColor: Get.theme.primaryColor,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          minimumAspectRatio: 1.0,
          aspectRatioLockEnabled: true,
          resetAspectRatioEnabled: true,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.cardColor,
      appBar: AppBar(
  leading: IconButton(onPressed: (){
    Get.offAll(()=>const Phone(exitFromApp: false,backFromThis: true,));
  },icon: const Icon(Icons.arrow_back),),
      ),
      bottomNavigationBar: SizedBox(
        height: 150,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            children: [
              _selectedImage == null
                  ? InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return SelectImg(
                         onImageSelected: _updateImage,
                      );
                    },
                  );


                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                      color: const Color(0xff090018),
                      borderRadius:
                      BorderRadius.circular(Dimensions.radiusSmall)),
                  child: Center(
                    child: Text(
                      "Choose a Photo",
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Get.theme.cardColor,
                          fontWeight: FontWeight.w400,
                          fontSize: Dimensions.fontSizeLarge),
                    ),
                  ),
                ),
              )
                  : InkWell(
                onTap:
                    () {
                  print("----------");
                  save();
                },




                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                      color: const Color(0xff090018),
                      borderRadius:
                      BorderRadius.circular(Dimensions.radiusSmall)),
                  child: Center(
                    child: Text(
                      "Save",
                      style: TextStyle(
                          color: Get.theme.cardColor,
                          fontFamily: 'Poppins',
                          fontSize: Dimensions.fontSizeLarge),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              _selectedImage == null
                  ? InkWell(onTap: (){
                Get.offAll(()=>const DashboardScreen(pageIndex: 0));
              },
                child: Text(
                  "Skip for now",
                  style: TextStyle(color: Get.theme.disabledColor),
                ),
              )
                  : const SizedBox()
            ],
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        children: [
          _selectedImage == null
              ? Text(
            "Add A Profile Picture",
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
                fontSize: Dimensions.fontSizeOverLarge),
          )
              : Text(
            "Crop The Image To Fit",
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
                fontSize: Dimensions.fontSizeOverLarge),
          ),
          const SizedBox(
            height: 10,
          ),
          _selectedImage != null
              ? const SizedBox()
              : Text(
            "Let the users know, It’s you!",
            style: TextStyle(color: Get.theme.disabledColor),
          ),
          const SizedBox(
            height: 50,
          ),
          _selectedImage == null
              ? Column(
            children: [
              Center(
                child: DottedBorder(
                  borderType: BorderType.Circle,
                  dashPattern: const [6],
                  color: Get.theme.disabledColor,
                  strokeWidth: 1,
                  child: const CircleAvatar(
                    radius: 100,
                    backgroundColor: Colors.transparent,
                    child: Icon(
                      Icons.person,
                      size: 180,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Upload Jpg, Png, Jpeg\nMaximum 2 mb",
                textAlign: TextAlign.center,
                style: TextStyle(color: Get.theme.disabledColor,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400),
              ),
            ],
          )
              : SizedBox(
              height: 328,
              child: ClipRRect(
                  child: Image.file(
                    File(_selectedImage!.path),
                    fit: BoxFit.cover,
                  ))),



          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }


  save(){
    UploadPhotoBody uploadPhotoBody=UploadPhotoBody(photo: _selectedImage,userId: Get.find<AuthController>().userId.toString());
    Get.find<AuthController>().uploadPhoto(uploadPhotoBody).then((value){
      if(value.isSuccess){
        showCustomSnackBar(value.message);
        Get.to(()=>const DashboardScreen(pageIndex: 0, ));
      }
    });
  }
}


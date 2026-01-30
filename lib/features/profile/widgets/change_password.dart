import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor/features/profile/widgets/dialogbox_update.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';

import '../../../common/widgets/custom_text_field_widget.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  @override
  Widget build(BuildContext context) {

    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(backgroundColor: Get.theme.primaryColor.withOpacity(0.1),
      bottomNavigationBar: Container(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomInset),  // Adjusts padding based on keyboard height
          child: Column(
            mainAxisSize: MainAxisSize.min,  // Ensures that the content is wrapped properly within the bottom sheet
            children: [
              Center(
                child: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: const CircleAvatar(
                    backgroundColor: Colors.black,
                    child: Icon(Icons.close, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                decoration: BoxDecoration(
                  color: Get.theme.cardColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Change Password",
                        style: TextStyle(
                          fontSize: Dimensions.fontSizeExtraLarge,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Divider(thickness: 2),
                      const SizedBox(height: 20),
                      CustomTextFieldWidget(
                        titleText: 'current_password'.tr,
                        labelText: 'current_password'.tr,
                        hintText: "Enter Current Password",
                        required: true,
                        inputType: TextInputType.visiblePassword,
                      ),
                      const SizedBox(height: 20),
                      CustomTextFieldWidget(
                        titleText: 'new_password'.tr,
                        labelText: 'new_password'.tr,
                        hintText: "Enter New Password",
                        required: true,
                        inputType: TextInputType.visiblePassword,
                      ),
                      const SizedBox(height: 20),
                      CustomTextFieldWidget(
                        // titleText: 'new_password'.tr,
                        labelText: 'retype_password'.tr,
                        hintText: "Retype New Password",
                        required: true,
                        inputType: TextInputType.visiblePassword,
                      ),
                      const SizedBox(height: 50),
                      InkWell(onTap: (){
                        Get.to(()=>DialogBoxUpdate());
                      },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 60),
                          padding: const EdgeInsets.symmetric(vertical: 10),decoration: BoxDecoration(
                          color: const Color(0xff090018),
                          borderRadius: BorderRadius.circular(30),

                        ),child: Center(child: Text("Update",style: TextStyle(color: Get.theme.cardColor,fontSize: Dimensions.fontSizeExtraLarge),),),),
                      ),
                      const SizedBox(height: 50),


                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


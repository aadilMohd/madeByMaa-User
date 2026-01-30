import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({super.key});

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        // alignment: Alignment.bottomLeft,
        insetPadding: EdgeInsets.zero,
        // titlePadding: EdgeInsets.all(0),
        // contentPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        title: Container(
          width: Get.width,
          decoration: const BoxDecoration(color: Colors.transparent),
          child: Column(
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
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                width: Get.width,
                decoration: BoxDecoration(
                    color: Get.theme.cardColor,
                    borderRadius:
                        BorderRadius.circular(Dimensions.radiusExtraLarge)),
                child: Column(
                  children: [
                    Text(
                      "Delete Account",
                      style: TextStyle(
                          color: Colors.red,
                          fontFamily: 'Poppins',
                          fontSize: Dimensions.fontSizeLarge),
                    ),
                    const Divider(),
                    const SizedBox(
                      height: Dimensions.paddingSizeDefault,
                    ),
                    Image.asset(
                      Images.delete2,
                      height: 30,
                    ),
                    const SizedBox(
                      height: Dimensions.paddingSizeDefault,
                    ),
                    const Text(
                      "Are you sure you want to\nDelete Account?",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "You will not able to recover your\naccount again! Be Sure",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Get.theme.disabledColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(onTap: (){
                              Get.back();
                            },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: Dimensions.paddingSizeSmall),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      300,
                                    ),
                                    border: Border.all()),
                                child: Center(
                                  child: Text("No, Keep it",style: TextStyle(fontSize: Dimensions.fontSizeExtraLarge),),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: Dimensions.paddingSizeSmall,
                          ),
                          Expanded(
                            child: InkWell(onTap: (){
                              Get.find<ProfileController>().removeUser();
                            },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: Dimensions.paddingSizeSmall),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      300,
                                    ),
                                    color: const Color(0xffFF440C)),
                                child: Center(
                                  child: Text(
                                    "Delete",
                                    style: TextStyle(color: Get.theme.cardColor,fontSize: Dimensions.fontSizeExtraLarge),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }


}

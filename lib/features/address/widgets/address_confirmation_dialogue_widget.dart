import 'package:flutter/cupertino.dart';
import 'package:stackfood_multivendor/features/location/controllers/location_controller.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class AddressConfirmDialogueWidget extends StatelessWidget {
  final String icon;
  final String? title;
  final String description;
  final Function onYesPressed;
  const AddressConfirmDialogueWidget({super.key, required this.icon, this.title, required this.description, required this.onYesPressed});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge)),
      insetPadding: const EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: PointerInterceptor(
        child: SizedBox(
          width: 500,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text("Delete Address",style: TextStyle(fontWeight: FontWeight.w500,
                  fontSize: Dimensions.fontSizeExtraLarge,color: const Color(0xffFF440C
              )),),
             const Divider(),

              Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                child: Image.asset(Images.delete2, width: 50, height: 50),
              ),

              title != null ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                child: Text(
              'Are you sure you want to\nDelete This Address?', textAlign: TextAlign.center,
                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
                ),
              ) : const SizedBox(),

              // Padding(
              //   padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
              //   child: Text(description, style: robotoRegular.copyWith(color: Theme.of(context).hintColor), textAlign: TextAlign.center),
              // ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GetBuilder<LocationController>(builder: (locationController) {
                  return !locationController.isLoading ?
                  Row(children: [
                    Expanded(
                      child: InkWell(
                        onTap:() => Get.back(),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),

                          decoration: BoxDecoration(border: Border.all(width: 1),borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge)),child: Center(child: Text("No, Keep it",style: TextStyle(fontSize: Dimensions.fontSizeLarge),)),),
                      ),
                    ),
                    SizedBox(width: Dimensions.paddingSizeSmall,),
                    Expanded(
                      child: InkWell(
                        onTap: () => onYesPressed(),

                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),

                          decoration: BoxDecoration(color:  Color(0xffFF440C
                          ),borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge)),child: Center(child: Text("Delete",style: TextStyle(color: Get.theme.cardColor,fontSize: Dimensions.fontSizeLarge),)),),
                      ),
                    ),

                    // Expanded(child: TextButton(
                    //   onPressed: () => onYesPressed(),
                    //   style: TextButton.styleFrom(
                    //     backgroundColor: Theme.of(context).colorScheme.error, minimumSize: const Size(Dimensions.webMaxWidth, 50), padding: EdgeInsets.zero,
                    //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
                    //   ),
                    //   child: Text(
                    //     'delete'.tr, textAlign: TextAlign.center,
                    //     style: robotoBold.copyWith(color: Theme.of(context).cardColor),
                    //   ),
                    // )),
                    // const SizedBox(width: Dimensions.paddingSizeLarge),
                    //
                    // Expanded(child: CustomButtonWidget(
                    //   buttonText:  'cancel'.tr, textColor: Theme.of(context).disabledColor,
                    //   onPressed: () => Get.back(),
                    //   radius: Dimensions.radiusDefault, height: 50, color: Theme.of(context).disabledColor.withOpacity(0.2),
                    // )),

                  ]) : const Center(child: CircularProgressIndicator());
                }),
              ),

            ]),
          ),
        ),
      ),
    );
  }
}

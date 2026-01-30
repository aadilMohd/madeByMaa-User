import 'package:get/get.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';

class ElementWidget extends StatelessWidget {
  final String image;
  final String title;
  final String subTitle;
  final Function() onTap;
  const ElementWidget(
      {super.key,
      required this.image,
      required this.title,
      required this.subTitle,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    bool isDesktop = ResponsiveHelper.isDesktop(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding:
            const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // // Image.asset(image, height: isDesktop ? 70 : 45, width: isDesktop ? 70 : 45, fit: BoxFit.cover),
              // SizedBox(height: isDesktop ? Dimensions.paddingSizeExtraLarge : 0),

              Text(title,
                  style: robotoBold.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: Dimensions.fontSizeExtraLarge,
                      color: Get.theme.disabledColor)),
              SizedBox(
                  height: isDesktop ? Dimensions.paddingSizeExtraLarge : 10),

              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                        vertical: Dimensions.paddingSizeDefault,
                        horizontal: Dimensions.paddingSizeLarge),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Get.theme.primaryColor)),
                    child: Text(
                      subTitle,
                      style: robotoMedium.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: isDesktop
                            ? Dimensions.fontSizeSmall
                            : Dimensions.fontSizeExtraLarge,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  SizedBox(
                    width: Dimensions.paddingSizeSmall,
                  ),
                  Container(
                    padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.black),
                    child: Center(
                      child: Image.asset(image,
                          color: Colors.white,
                          height: isDesktop ? 70 : 25,
                          width: isDesktop ? 70 : 25,
                          fit: BoxFit.cover),
                    ),
                  )
                ],
              )
            ]),
      ),
    );
  }
}

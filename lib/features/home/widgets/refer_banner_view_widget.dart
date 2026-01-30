import 'package:stackfood_multivendor/features/language/controllers/localization_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/helper/price_converter.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReferBannerViewWidget extends StatelessWidget {
  final bool fromTheme1;
  const ReferBannerViewWidget({super.key, this.fromTheme1 = false});

  @override
  Widget build(BuildContext context) {
    double rightValue = (MediaQuery.of(context).size.width*0.7);
    return (Get.find<SplashController>().configModel!.refEarningStatus == 1 )
        ? Container(

      // padding: EdgeInsets.all(ResponsiveHelper.isMobile(context) ? 0 : Dimensions.paddingSizeLarge),
      // height: ResponsiveHelper.isMobile(context) ? 171 : 147,
      width: Get.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        // gradient: LinearGradient(
        //     colors:[
        //   Theme.of(context).colorScheme.tertiaryContainer,
        //   Theme.of(context).colorScheme.tertiary,
        // ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      ),
      child: Stack(
        children: [
          Positioned(
            // right: Get.find<LocalizationController>().isLtr ? null : -rightValue,
            child: ClipRRect(
              child: Image.asset(
                Images.referNow,
                fit: BoxFit.cover,
                // height: ResponsiveHelper.isMobile(context) ? 171 : 147,
                // width: ResponsiveHelper.isMobile(context) ? 400 : 147,
              ),
            ),
          ),

          Positioned(top: 30,left: 30,child:

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Refer your friend &",
                style: TextStyle(color: Get.theme.cardColor,fontSize: Dimensions.fontSizeExtraLarge,fontWeight: FontWeight.w600),),

              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${'earn'.tr} ',
                      style: TextStyle(color: Get.theme.cardColor,fontSize: Dimensions.fontSizeExtraLarge,fontWeight: FontWeight.w600),),


                    TextSpan(
                      text: PriceConverter.convertPrice(Get.find<SplashController>().configModel!.refEarningExchangeRate),
                      style: TextStyle(color: Get.theme.cardColor,fontSize: Dimensions.fontSizeOverLarge,fontWeight: FontWeight.w600),),


                  ],
                ),
              ),

            ],
          ),  ),

          Positioned(
            bottom: 25,left: 30,
            child:  InkWell(
              onTap: ()=> Get.toNamed(RouteHelper.getReferAndEarnRoute()),
              child: Container(
                height: 37,
                width: 150,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xff5A189A),
                      Color(0xff9D56E9),
                      Color(0xff5A189A),
                    ],
                      begin: Alignment.centerLeft,
                    end: Alignment.centerRight

                  )),
                child: Center(child: Text("Refer Now",style: TextStyle(fontWeight: FontWeight.w600,color: Get.theme.cardColor),),),),
            ),),

          // Positioned(
          //   bottom: 25,left: 30,
          //   child:  CustomButtonWidget(buttonText: 'refer_now'.tr, width: ResponsiveHelper.isMobile(context) ? 90 : 120, height: ResponsiveHelper.isMobile(context) ? 35 : 40, isBold: true, fontSize: Dimensions.fontSizeSmall, textColor: Theme.of(context).primaryColor,
          //     radius: Dimensions.radiusSmall, color: Theme.of(context).cardColor,
          //     onPressed: ()=> Get.toNamed(RouteHelper.getReferAndEarnRoute())
          // ),),


          const Row(children: [
    //         Expanded(
    //           child: Row(
    //               children: [
    //
    // //             Flexible(
    // //               child: Column(
    // //                 crossAxisAlignment: CrossAxisAlignment.start,
    // //                 // mainAxisAlignment: MainAxisAlignment.center,
    // //                 children: [
    // //                   Text("Refer your friend &",
    // //                     style: TextStyle(color: Get.theme.cardColor,fontSize: Dimensions.fontSizeExtraLarge,fontWeight: FontWeight.w600),),
    // //
    // //                   RichText(
    // //                     text: TextSpan(
    // //                       children: [
    // //                         TextSpan(
    // //                           text: '${'earn'.tr} ',
    // // style: TextStyle(color: Get.theme.cardColor,fontSize: Dimensions.fontSizeExtraLarge,fontWeight: FontWeight.w600),),
    // //
    // //
    // //                         TextSpan(
    // //                           text: PriceConverter.convertPrice(Get.find<SplashController>().configModel!.refEarningExchangeRate),
    // //                           style: TextStyle(color: Get.theme.cardColor,fontSize: Dimensions.fontSizeOverLarge,fontWeight: FontWeight.w600),),
    // //
    // //
    // //                       ],
    // //                     ),
    // //                   ),
    // //                 ],
    // //               ),
    // //             ),
    //           ]),
    //         ),

            // Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            //   CustomButtonWidget(buttonText: 'refer_now'.tr, width: ResponsiveHelper.isMobile(context) ? 90 : 120, height: ResponsiveHelper.isMobile(context) ? 35 : 40, isBold: true, fontSize: Dimensions.fontSizeSmall, textColor: Theme.of(context).primaryColor,
            //       radius: Dimensions.radiusSmall, color: Theme.of(context).cardColor,
            //       onPressed: ()=> Get.toNamed(RouteHelper.getReferAndEarnRoute())
            //   ),
            // ],
            // ),
            // SizedBox(width: ResponsiveHelper.isMobile(context) ? Dimensions.paddingSizeSmall : 0),
          ],
          ),
        ],
      ),
    ) : const SizedBox();
  }
}
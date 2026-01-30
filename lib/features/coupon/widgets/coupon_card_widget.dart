import 'dart:math';
import 'package:dotted_border/dotted_border.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:stackfood_multivendor/features/coupon/domain/models/coupon_model.dart';
import 'package:stackfood_multivendor/features/language/controllers/localization_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/theme_controller.dart';
import 'package:stackfood_multivendor/helper/date_converter.dart';
import 'package:stackfood_multivendor/helper/price_converter.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

class CouponCardWidget extends StatelessWidget {
  final List<CouponModel>? couponList;
  final List<JustTheController>? toolTipController;
  final int index;

  const CouponCardWidget(
      {super.key,
      required this.index,
      this.couponList,
      this.toolTipController});

  @override
  Widget build(BuildContext context) {
    Color getRandomColor() {
      Random random = Random();
      return Color.fromARGB(
        255,
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256),
      );
    }
    Size size = MediaQuery.of(context).size;
    return Container(

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        ),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
          InkWell(
            onTap: () {
              toolTipController![index].showTooltip();
              Clipboard.setData(ClipboardData(text: couponList![index].code!));

              Future.delayed(const Duration(milliseconds: 750), () {
                toolTipController![index].hideTooltip();
              });
            },
            child: Stack(
              children: [
                Container(
                  height: ResponsiveHelper.isMobilePhone() ? 150 : 150,
                  width: MediaQuery.of(context).size.width / 4,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Get.isDarkMode
                                ? Colors.black.withOpacity(0.3)
                                : Colors.grey,
                            blurRadius: 2,
                            blurStyle: BlurStyle.outer)
                      ],
                      color: getRandomColor(),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Flat",
                          style: TextStyle(color: Get.theme.cardColor),
                        ),

                        (couponList![index].discountType == 'percent') ?Text(

                               '${couponList![index].discount} %',

                          style: robotoBold.copyWith(
                              fontSize: Dimensions.fontSizeOverLarge,
                              color: Theme.of(context).cardColor,
                              fontWeight: FontWeight.bold),
                        ):Row(crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                          Text(

                                '${Get.find<SplashController>().configModel!.currencySymbol} ',

                              style: robotoBold.copyWith(
                                  fontSize: Dimensions.fontSizeLarge,
                                  color: Theme.of(context).cardColor,
                                  fontWeight: FontWeight.bold),
                            ),Text(

                                '${couponList![index].discount}',

                              style: robotoBold.copyWith(
                                  fontSize: Dimensions.fontSizeOverLarge,
                                  color: Theme.of(context).cardColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                         Align(alignment: Alignment.centerRight,
                          child: Text(style: TextStyle(color: Get.theme.cardColor),
                            ' OFF',textAlign: TextAlign.end,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: -15,
                  left: (MediaQuery.of(context).size.width / 4) - 15,
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: Get.theme.disabledColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  bottom: -15,
                  left: (MediaQuery.of(context).size.width / 4) - 15,
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: Get.theme.disabledColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    boxShadow: const [
                 BoxShadow(color: Colors.grey,blurStyle: BlurStyle.outer,spreadRadius: 1,blurRadius: 1)
                    ],
                    color: Theme.of(context).cardColor,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    border: Border.all(color: Colors.grey.withOpacity(0.5))
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: couponList![index].restaurant == null
                              ? Text(
                            couponList![index].couponType == 'store_wise'
                                ? '${'on'.tr} ${couponList![index].data}'
                                : 'on_all_store'.tr,
                            style: robotoRegular.copyWith(
                                color: Get.theme.primaryColor,

                                fontSize: Dimensions.fontSizeExtraSmall),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                              : Text(
                            couponList![index].couponType == 'default'
                                ? '${couponList![index].restaurant!.name}'
                                : '',
                            style: robotoRegular.copyWith(
                              color: Get.theme.primaryColor,
                                fontSize: Dimensions.fontSizeExtraSmall),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // SizedBox(height: 5),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: 25,
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 4.0),
                                        child: Text(
                                          '${couponList![index].title}',
                                          style: robotoBold.copyWith(
                                            fontSize: Dimensions.fontSizeLarge,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        // SizedBox(height: 5),
                        Flexible(
                          child: Text(
   couponList![index].discountType=="amount"?
                            "Save ₹${(couponList![index].maxDiscount)!.toStringAsFixed(0)} on this order!":
                            "Save ${(couponList![index].maxDiscount)!.toStringAsFixed(0)}% on this order!"
                            ,
                            style: robotoBold.copyWith(
                                color: Colors.green, fontSize: Dimensions.fontSizeDefault),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // SizedBox(height: 5),
                        const DottedLine(lineThickness: 0.2, dashLength: 2),
                        // SizedBox(height: 5),
                        Flexible(
                          child: Text(
                            "Maximum discount upto ${(PriceConverter.convertPrice(couponList![index].maxDiscount)).replaceAll(' ', '')} on orders above ${(PriceConverter.convertPrice(couponList![index].minPurchase)).replaceAll(' ', '')}",
                            style: robotoMedium.copyWith(
                              color: Colors.black,
                              fontSize: Dimensions.fontSizeExtraSmall,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${DateConverter.stringToReadableString(couponList![index].startDate!)} ${'-'} ${DateConverter.stringToReadableString(couponList![index].expireDate!)}',
                                style: robotoMedium.copyWith(
                                  color: Colors.black,
                                  fontSize: Dimensions.fontSizeExtraSmall,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  JustTheTooltip(
                                    backgroundColor: Get.find<ThemeController>().darkTheme
                                        ? Theme.of(context).cardColor
                                        : Colors.black87,
                                    controller: toolTipController![index],
                                    preferredDirection: AxisDirection.up,
                                    tailLength: 14,
                                    tailBaseWidth: 20,
                                    triggerMode: TooltipTriggerMode.manual,
                                    content: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        '${'code_copied'.tr} !',
                                        style: robotoRegular.copyWith(
                                            color: Theme.of(context).cardColor),
                                      ),
                                    ),
                                    child: InkWell(
                                      onTap: () async {
                                        toolTipController![index].showTooltip();
                                        Clipboard.setData(
                                            ClipboardData(text: couponList![index].code!));

                                        Future.delayed(const Duration(milliseconds: 750), () {
                                          toolTipController![index].hideTooltip();
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 12),
                                        decoration: BoxDecoration(
                                            color: const Color(0xff090018),
                                            borderRadius: BorderRadius.circular(
                                                Dimensions.radiusSmall)),
                                        child: Text(
                                          'Copy Code',
                                          style: robotoBold.copyWith(
                                            color: Theme.of(context).cardColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5,)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: -15,
                  left: -15,
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(color: Colors.grey,blurStyle: BlurStyle.inner,spreadRadius: 1,blurRadius: 1)
                      ],
                      color: Get.theme.disabledColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  bottom: -15,
                  left:  - 15,
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(color: Colors.grey,blurStyle: BlurStyle.inner,spreadRadius: 1,blurRadius: 1)
                      ],
                      color: Get.theme.disabledColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          )

        ]));
  }
}

class HalfCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height / 2);
    path.arcTo(
      Rect.fromPoints(const Offset(0, 0), Offset(size.width, size.height)),
      3.14,
      -3.14,
      false,
    );
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
// Positioned(
//   top: -15,
//   left: (MediaQuery.of(context).size.width / 4) - 15, child: Container(
//     height: 30,
//     width: 30,
//     decoration: BoxDecoration(
//       color: Get.theme.backgroundColor,
//       shape: BoxShape.circle,
//     ),
//   ),
// ),
// Positioned(
//   bottom: -15,
//   left: (MediaQuery.of(context).size.width / 4) - 15, child: Container(
//     height: 30,
//     width: 30,
//     decoration: BoxDecoration(
//       color: Get.theme.backgroundColor,
//       shape: BoxShape.circle,
//     ),
//   ),
// ),

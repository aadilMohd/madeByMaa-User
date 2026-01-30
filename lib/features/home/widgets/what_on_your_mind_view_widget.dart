import 'package:flutter/cupertino.dart';
import 'package:stackfood_multivendor/common/widgets/custom_ink_well_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/arrow_icon_button_widget.dart';
import 'package:stackfood_multivendor/features/language/controllers/localization_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/category/controllers/category_controller.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class WhatOnYourMindViewWidget extends StatelessWidget {
  const WhatOnYourMindViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    return GetBuilder<CategoryController>(builder: (categoryController) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: EdgeInsets.only(
            top: ResponsiveHelper.isMobile(context)
                ? Dimensions.paddingSizeLarge
                : Dimensions.paddingSizeOverLarge,
            left: Get.find<LocalizationController>().isLtr
                ? Dimensions.paddingSizeExtraSmall
                : 0,
            right: Get.find<LocalizationController>().isLtr
                ? 0
                : Dimensions.paddingSizeExtraSmall,
            // bottom: ResponsiveHelper.isMobile(context)
            //     ? Dimensions.paddingSizeDefault
            //     : Dimensions.paddingSizeOverLarge,
          ),
          child: ResponsiveHelper.isDesktop(context)
              ? Text('choose_your_favorite'.tr,
                  style: robotoMedium.copyWith(
                      fontSize: Dimensions.fontSizeLarge,
                      fontWeight: FontWeight.w600
                  ))
              : Padding(
                  padding: const EdgeInsets.only(
                      left: Dimensions.paddingSizeSmall,
                      right: Dimensions.paddingSizeDefault),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          'choose_your_favorite'.tr,
                          style: robotoBold.copyWith(
                              fontSize: 18,
                              color: const Color(0xff090018),
                             fontFamily: "Poppins",
                               fontWeight: FontWeight.w700
                          )),

                    ],
                  ),
                ),
        ),

        Container(
          height: 280,

          child: categoryController.categoryList != null
              ? GridView.builder(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 2,
                    childAspectRatio: 1.15,



                  ),
                  padding:
                      const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                  itemCount: categoryController.categoryList!.length > 10
                      ? 10
                      : categoryController.categoryList!.length,

                  itemBuilder: (context, index) {
                    if (index == 9 &&
                        categoryController.categoryList!.length > 10) {
                      return InkWell(
                        onTap: () {

                          Get.toNamed(RouteHelper.getCategoryRoute());
                        },
                        borderRadius:
                            BorderRadius.circular(Dimensions.radiusSmall),
                        child: SizedBox(
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: SizedBox(
                                  height: 60,
                                  width: 60,
                                  child: Image.asset(
                                    Images.blueCircle,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                  height: Dimensions.paddingSizeSmall),
                              Text("See All",style: TextStyle(color: Get.theme.primaryColor,fontWeight: FontWeight.w500,fontFamily: "Manrope"),)

                            ],
                          ),
                        ),
                      );
                    }

                    return InkWell(
                      onTap: () =>

                          Get.toNamed(RouteHelper.getCategoryProductRoute(
                        categoryController.categoryList![index].id,
                        categoryController.categoryList![index].name!,

                      )
                          ),
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusSmall),
                      child: SizedBox(
                        child: Column(
                          children: [

                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                // shape: BoxShape.circle,
                              ),
                              child: ClipRRect(
                                 borderRadius: BorderRadius.circular(0),
                                child: CustomImageWidget(
                                  image:
                                      '${Get.find<SplashController>().configModel!.baseUrls!.categoryImageUrl}/${categoryController.categoryList![index].image}',
                                  height: 60,
                                  width: 75,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),

                            const SizedBox(height: Dimensions.paddingSizeSmall),
                            SizedBox(
                              width: 80,
                              child: Text(
                                categoryController.categoryList![index].name!,
                                style: robotoRegular.copyWith(
                                  color: const Color(0xff4A4A4A
                                  ),
                                  fontFamily: "Manrope",

                                  fontSize: Dimensions.fontSizeSmall,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : WebWhatOnYourMindViewShimmer(
                  categoryController: categoryController),
        ),
      ]);
    });
  }
}

class WebWhatOnYourMindViewShimmer extends StatelessWidget {
  final CategoryController categoryController;

  const WebWhatOnYourMindViewShimmer(
      {super.key, required this.categoryController});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ResponsiveHelper.isMobile(context) ? 120 : 170,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 10,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(
                bottom: Dimensions.paddingSizeSmall,
                right: Dimensions.paddingSizeSmall,
                top: Dimensions.paddingSizeSmall),
            child: Container(
              width: ResponsiveHelper.isMobile(context) ? 70 : 108,
              height: ResponsiveHelper.isMobile(context) ? 70 : 100,
              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
              margin: EdgeInsets.only(
                  top: ResponsiveHelper.isMobile(context)
                      ? 0
                      : Dimensions.paddingSizeSmall),
              child: Shimmer(
                duration: const Duration(seconds: 2),
                enabled: categoryController.categoryList == null,
                child: Column(children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(Dimensions.radiusSmall),
                        color: Colors.grey[300]),
                    height: ResponsiveHelper.isMobile(context) ? 70 : 80,
                    width: 70,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  Container(
                      height: ResponsiveHelper.isMobile(context) ? 10 : 15,
                      width: 150,
                      color: Colors.grey[300]),
                ]),
              ),
            ),
          );
        },
      ),
    );
  }
}

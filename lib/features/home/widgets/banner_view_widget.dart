import 'package:stackfood_multivendor/features/home/controllers/home_controller.dart';
import 'package:stackfood_multivendor/features/restaurant/screens/restaurant_screen.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/theme_controller.dart';
import 'package:stackfood_multivendor/features/product/domain/models/basic_campaign_model.dart';
import 'package:stackfood_multivendor/common/models/product_model.dart';
import 'package:stackfood_multivendor/common/models/restaurant_model.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor/common/widgets/product_bottom_sheet_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class BannerViewWidget extends StatelessWidget {
  const BannerViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (homeController) {
      return (homeController.bannerImageList != null &&
              homeController.bannerImageList!.isEmpty)
          ? const SizedBox()
          : Container(
              width: MediaQuery.of(context).size.width,
              height: GetPlatform.isDesktop ? 594 : 200,
              padding:
                  const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
              child: homeController.bannerImageList != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // SizedBox(
                        //   height: 148,
                        //   child: CarouselSlider.builder(
                        //     options: CarouselOptions(
                        //       autoPlay: true,
                        //       enlargeCenterPage: true,
                        //       enlargeFactor: 0.3,
                        //       disableCenter: true,
                        //       viewportFraction: 0.60,
                        //       autoPlayInterval: const Duration(seconds: 7),
                        //       onPageChanged: (index, reason) {
                        //         homeController.setCurrentIndex(index, true);
                        //       },
                        //     ),
                        //     itemCount: homeController.bannerImageList!.isEmpty
                        //         ? 1
                        //         : homeController.bannerImageList!.length,
                        //     itemBuilder: (context, index, _) {
                        //       String? baseUrl =
                        //       homeController.bannerDataList![index]
                        //       is BasicCampaignModel
                        //           ? Get
                        //           .find<SplashController>()
                        //           .configModel!
                        //           .baseUrls!
                        //           .campaignImageUrl
                        //           : Get
                        //           .find<SplashController>()
                        //           .configModel!
                        //           .baseUrls!
                        //           .bannerImageUrl;
                        //       return InkWell(
                        //         onTap: () {
                        //           if (homeController.bannerDataList![index]
                        //           is Product) {
                        //             Product? product =
                        //             homeController.bannerDataList![index];
                        //             ResponsiveHelper.isMobile(context)
                        //                 ? showModalBottomSheet(
                        //               context: context,
                        //               isScrollControlled: true,
                        //               backgroundColor: Colors.transparent,
                        //               builder: (con) =>
                        //                   ProductBottomSheetWidget(
                        //                       product: product),
                        //             )
                        //                 : showDialog(
                        //               context: context,
                        //               builder: (con) =>
                        //                   Dialog(
                        //                       child: ProductBottomSheetWidget(
                        //                           product: product)),
                        //             );
                        //           } else if (homeController.bannerDataList![index]
                        //           is Restaurant) {
                        //             Restaurant restaurant =
                        //             homeController.bannerDataList![index];
                        //             Get.toNamed(
                        //               RouteHelper.getRestaurantRoute(
                        //                   restaurant.id),
                        //               arguments: RestaurantScreen(
                        //                   restaurant: restaurant),
                        //             );
                        //           } else if (homeController.bannerDataList![index]
                        //           is BasicCampaignModel) {
                        //             BasicCampaignModel campaign =
                        //             homeController.bannerDataList![index];
                        //             Get.toNamed(RouteHelper.getBasicCampaignRoute(
                        //                 campaign));
                        //           }
                        //         },
                        //         child: Container(
                        //           decoration: BoxDecoration(
                        //             color: Theme
                        //                 .of(context)
                        //                 .cardColor,
                        //             borderRadius: BorderRadius.circular(
                        //                 Dimensions.radiusSmall),
                        //             boxShadow: [
                        //               BoxShadow(
                        //                   color: Colors.grey.withOpacity(0.1),
                        //                   spreadRadius: 1,
                        //                   blurRadius: 2,
                        //                   offset: const Offset(0, 1))
                        //             ],
                        //           ),
                        //           child: ClipRRect(
                        //             borderRadius: BorderRadius.circular(
                        //                 Dimensions.radiusDefault),
                        //             child: GetBuilder<SplashController>(
                        //               builder: (splashController) {
                        //                 return CustomImageWidget(
                        //                   image:
                        //                   '$baseUrl/${homeController
                        //                       .bannerImageList![index]}',
                        //                   fit: BoxFit.cover,
                        //                 );
                        //               },
                        //             ),
                        //           ),
                        //         ),
                        //       );
                        //     },
                        //   ),
                        // ),

                        SizedBox(
                          height: 160,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: homeController.bannerImageList!.isEmpty
                                ? 1
                                : homeController.bannerImageList!.length,
                            itemBuilder: (context, index) {
                              String? baseUrl =
                                  homeController.bannerDataList![index]
                                          is BasicCampaignModel
                                      ? Get.find<SplashController>()
                                          .configModel!
                                          .baseUrls!
                                          .campaignImageUrl
                                      : Get.find<SplashController>()
                                          .configModel!
                                          .baseUrls!
                                          .bannerImageUrl;
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                ),
                                child: InkWell(
                                  onTap: () {
                                    if (homeController.bannerDataList![index]
                                        is Product) {
                                      Product? product =
                                          homeController.bannerDataList![index];
                                      ResponsiveHelper.isMobile(context)
                                          ? showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              backgroundColor:
                                                  Colors.transparent,
                                              builder: (con) =>
                                                  ProductBottomSheetWidget(
                                                      product: product),
                                            )
                                          : showDialog(
                                              context: context,
                                              builder: (con) => Dialog(
                                                  child:
                                                      ProductBottomSheetWidget(
                                                          product: product)),
                                            );
                                    } else if (homeController
                                        .bannerDataList![index] is Restaurant) {
                                      Restaurant restaurant =
                                          homeController.bannerDataList![index];
                                      Get.toNamed(
                                        RouteHelper.getRestaurantRoute(
                                            restaurant.id),
                                        arguments: RestaurantScreen(
                                             ownerNAme: restaurant.ownerName,
                                            restaurant: restaurant),
                                      );
                                    } else if (homeController
                                            .bannerDataList![index]
                                        is BasicCampaignModel) {
                                      BasicCampaignModel campaign =
                                          homeController.bannerDataList![index];
                                      Get.toNamed(
                                          RouteHelper.getBasicCampaignRoute(
                                              campaign));
                                    }
                                  },
                                  child: Container(
                                    height: 155,
                                    width: 310,
                                    // decoration: BoxDecoration(
                                    //     borderRadius: BorderRadius.circular(
                                    //         Dimensions.radiusDefault),
                                    //   boxShadow: const [
                                    //     BoxShadow(color: Colors.grey,blurRadius: 5,spreadRadius: 3,blurStyle: BlurStyle.inner,)
                                    //   ]
                                    // ),

                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.radiusDefault),
                                      child: GetBuilder<SplashController>(
                                        builder: (splashController) {
                                          return CustomImageWidget(
                                            image:
                                                '$baseUrl/${homeController.bannerImageList![index]}',
                                            fit: BoxFit.cover,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: homeController.bannerImageList!.map((bnr) {
                        //     int index =
                        //         homeController.bannerImageList!.indexOf(bnr);
                        //     int totalBanner =
                        //         homeController.bannerImageList!.length;
                        //     return Padding(
                        //       padding:
                        //           const EdgeInsets.symmetric(horizontal: 3),
                        //       child: index == homeController.currentIndex
                        //           ? Container(
                        //               decoration: BoxDecoration(
                        //                   color: Theme.of(context).primaryColor,
                        //                   borderRadius: BorderRadius.circular(
                        //                       Dimensions.radiusDefault)),
                        //               padding: const EdgeInsets.symmetric(
                        //                   horizontal: 4, vertical: 1),
                        //               child: Text('${(index) + 1}/$totalBanner',
                        //                   style: robotoRegular.copyWith(
                        //                       color: Colors.white,
                        //                       fontSize: 12)),
                        //             )
                        //           : Container(
                        //               height: 4.18,
                        //               width: 5.57,
                        //               decoration: BoxDecoration(
                        //                   color: Theme.of(context)
                        //                       .primaryColor
                        //                       .withOpacity(0.5),
                        //                   borderRadius: BorderRadius.circular(
                        //                       Dimensions.radiusDefault)),
                        //             ),
                        //     );
                        //   }).toList(),
                        // ),
                      ],
                    )
                  : Shimmer(
                      duration: const Duration(seconds: 2),
                      enabled: homeController.bannerImageList == null,
                      child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(Dimensions.radiusSmall),
                            color: Colors.grey[
                                Get.find<ThemeController>().darkTheme
                                    ? 700
                                    : 300],
                          )),
                    ),
            );
    });
  }
}

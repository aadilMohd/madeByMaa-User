import 'dart:math';

import 'package:auto_scroll_text/auto_scroll_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

import 'package:stackfood_multivendor/common/widgets/custom_asset_image_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_favourite_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_ink_well_widget.dart';
import 'package:stackfood_multivendor/features/favourite/controllers/favourite_controller.dart';
import 'package:stackfood_multivendor/features/home/widgets/icon_with_text_row_widget.dart';
import 'package:stackfood_multivendor/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/common/models/restaurant_model.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor/features/restaurant/screens/restaurant_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../corner_banner/banner.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../language/controllers/localization_controller.dart';
import 'package:custom_rating_bar/custom_rating_bar.dart';

class RestaurantsViewWidget extends StatelessWidget {
  final Restaurant? restaurant;
  final List<Restaurant?>? restaurants;

  const RestaurantsViewWidget({super.key, this.restaurants, this.restaurant});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Dimensions.webMaxWidth,
      child: restaurants != null
          ? restaurants!.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: restaurants!.length,
                  // itemCount: restaurants!.length>=6?6:restaurants!.length,
                  physics: const NeverScrollableScrollPhysics(),
                  // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  //   childAspectRatio: 2,
                  //   crossAxisCount: ResponsiveHelper.isMobile(context)
                  //       ? 1
                  //       : ResponsiveHelper.isTab(context)
                  //       ? 3
                  //       : 4,
                  //   mainAxisSpacing: Dimensions.paddingSizeLarge,
                  //   crossAxisSpacing: Dimensions.paddingSizeLarge,
                  //   mainAxisExtent:
                  //   // restaurant!.discount==null&&restaurant!.discount==false?110:
                  //
                  //   150,
                  //
                  // ),
                  padding: EdgeInsets.symmetric(
                      horizontal: !ResponsiveHelper.isDesktop(context)
                          ? Dimensions.paddingSizeDefault
                          : 0),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: RestaurantView(restaurant: restaurants![index]!),
                    );
                  },
                )

              // GridView.builder(
              //             shrinkWrap: true,
              //             itemCount: restaurants!.length,
              //             physics: const NeverScrollableScrollPhysics(),
              //             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //               childAspectRatio: 2,
              //               crossAxisCount: ResponsiveHelper.isMobile(context)
              //                   ? 1
              //                   : ResponsiveHelper.isTab(context)
              //                       ? 3
              //                       : 4,
              //               mainAxisSpacing: Dimensions.paddingSizeLarge,
              //               crossAxisSpacing: Dimensions.paddingSizeLarge,
              //               mainAxisExtent:
              //                // restaurant!.discount==null&&restaurant!.discount==false?110:
              //
              //               150,
              //
              //             ),
              //             padding: EdgeInsets.symmetric(
              //                 horizontal: !ResponsiveHelper.isDesktop(context)
              //                     ? Dimensions.paddingSizeDefault
              //                     : 0),
              //             itemBuilder: (context, index) {
              //               return RestaurantView(restaurant: restaurants![index]!);
              //             },
              //           )

              : Center(
                  child: Padding(
                  padding: const EdgeInsets.only(
                      top: Dimensions.paddingSizeOverLarge),
                  child: Column(
                    children: [
                      const SizedBox(height: 110),
                      const CustomAssetImageWidget(Images.emptyRestaurant,
                          height: 80, width: 80),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                      Text('there_is_no_restaurant'.tr,
                          style: robotoMedium.copyWith(
                              color: Theme.of(context).disabledColor)),
                    ],
                  ),
                ))
          : GridView.builder(
              shrinkWrap: true,
              itemCount: 12,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: ResponsiveHelper.isMobile(context)
                    ? 1
                    : ResponsiveHelper.isTab(context)
                        ? 3
                        : 4,
                mainAxisSpacing: Dimensions.paddingSizeLarge,
                crossAxisSpacing: Dimensions.paddingSizeLarge,
                mainAxisExtent: 230,
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: !ResponsiveHelper.isDesktop(context)
                      ? Dimensions.paddingSizeLarge
                      : 0),
              itemBuilder: (context, index) {
                return const WebRestaurantShimmer();
              },
            ),
    );
  }
}

class RestaurantView extends StatelessWidget {
  final Restaurant restaurant;
  final Function()? onTap;
  final bool isSelected;

  const RestaurantView(
      {super.key,
      required this.restaurant,
      this.onTap,
      this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    final bool ltr = Get.find<LocalizationController>().isLtr;
    double distance = Get.find<RestaurantController>().getRestaurantDistance(
      LatLng(double.parse(restaurant.latitude!),
          double.parse(restaurant.longitude!)),
    );

    bool isAvailable = restaurant.open == 1 && restaurant.active!;

    return CustomInkWellWidget(
      onTap: onTap ??
          () {
            if (restaurant.restaurantStatus == 1) {
              Get.toNamed(RouteHelper.getRestaurantRoute(restaurant.id),
                  arguments: RestaurantScreen(
                      ownerNAme: restaurant.ownerName, restaurant: restaurant));
            } else if (restaurant.restaurantStatus == 0) {
              showCustomSnackBar('restaurant_is_not_available'.tr);
            }
          },
      radius: Dimensions.radiusDefault,
      child: Container(
        padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
        decoration: BoxDecoration(
            color: Get.find<RestaurantController>().isOpenNow(restaurant)
                ? Colors.white
                : const Color(0xffE0E0E0),
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            boxShadow: const [
              BoxShadow(
                  color: Colors.grey, blurRadius: 1, blurStyle: BlurStyle.outer)
            ]),
        child: Column(
          children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Stack(
                children: [
                  Container(
                    width: 88,
                    height: 95,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusSmall),

                    ),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusSmall),
                      child: Stack(clipBehavior: Clip.none, children: [
                        CustomImageWidget(
                            image:
                                '${Get.find<SplashController>().configModel!.baseUrls!.restaurantImageUrl}'
                                '/${restaurant.logo}',
                            fit: BoxFit.cover,
                            height: 150,
                            width: 120
                        ),
                        // DiscountTag(
                        //   discount: Get.find<RestaurantController>()
                        //       .getDiscount(restaurant),
                        //   discountType: Get.find<RestaurantController>()
                        //       .getDiscountType(restaurant),
                        //   freeDelivery: restaurant.freeDelivery,
                        // ),
                        Get.find<RestaurantController>().isOpenNow(restaurant)
                            ? const SizedBox()
                            : Positioned(
                                top: 2,
                                left: 2,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    vertical: 2

                                  ),
                                  decoration: BoxDecoration(
                                      color: const Color(0xffF55E1E),

                                      borderRadius: BorderRadius.circular(
                                          Dimensions.radiusSmall)),
                                  child: Center(
                                    child: Text(
                                      "Closed",
                                      style: TextStyle(
                                          fontSize: Dimensions.fontSizeSmall,
                                          color: Get.theme.cardColor),
                                    ),
                                  ),
                                ),
                              ),

                        // Positioned(
                        //         left: 0,
                        //         child: CornerBanner(
                        //           bannerPosition: ltr
                        //               ? CornerBannerPosition.topLeft
                        //               : CornerBannerPosition.topRight,
                        //           bannerColor: Colors.red,
                        //           // bannerColor: Theme.of(context).errorColor,
                        //           elevation: 5,
                        //           shadowColor: Colors.transparent,
                        //           child: _buildBannerContent(),
                        //         )),
                        Positioned(
                          top: 0,
                          // left: Get.find<LocalizationController>().isLtr
                          //     ? null
                          //     : 15,
                          right: Get.find<LocalizationController>().isLtr
                              ? 0
                              : null,
                          child: GetBuilder<FavouriteController>(
                              builder: (wishController) {
                            bool isWished = wishController.wishRestIdList
                                .contains(restaurant.id);
                            return CustomFavouriteWidget(
                              isWished: isWished,
                              isRestaurant: true,
                              restaurant: restaurant,
                            );
                          }),
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(restaurant.name ?? '',
                            maxLines: 1,
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeLarge,
                                fontWeight: FontWeight.w400)),
                        restaurant.ownerName == null
                            ? const Text("")
                            :
                        Text(
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                "Chef: ${restaurant.ownerName}",
                                style: TextStyle(
                                    color: const Color(0xff7E7E7E),
                                    fontSize: Dimensions.fontSizeSmall),
                              ),
                        const SizedBox(
                          height: Dimensions.paddingSizeLarge,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Text(
                            //   "${restaurant.deliveryTime} delivery",
                            //   style: TextStyle(
                            //       color: Get.theme.disabledColor,
                            //       fontSize: Dimensions.fontSizeSmall),
                            // ),

                            SizedBox(),
                            Row(
                              children: [
                                restaurant.veg == 1
                                    ? Image.asset(
                                        Images.vegImage,
                                        height: 12,
                                      )
                                    : const SizedBox(),
                                const SizedBox(
                                  width: 5,
                                ),
                                restaurant.nonVeg == 1
                                    ? Image.asset(
                                        Images.newNonVeg,
                                        height: 12,
                                      )
                                    : const SizedBox(),
                              ],
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            restaurant.cuisineNames!.isEmpty
                                ? const SizedBox()
                                : Expanded(
                                    child: SizedBox(
                                      height: 20,
                                      width: 140,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        physics: const ScrollPhysics(),
                                        itemCount:
                                            restaurant.cuisineNames!.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  restaurant
                                                      .cuisineNames![index]
                                                      .name!,
                                                  style: TextStyle(
                                                      color: const Color(
                                                          0xff524A61),
                                                      fontSize: Dimensions
                                                          .fontSizeSmall),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                if (index != restaurant
                                                    .cuisineNames!.length - 1)
                                                  const Icon(
                                                        Icons.circle_rounded,
                                                        size: 6,
                                                      )
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                            const SizedBox(width: Dimensions.paddingSizeSmall,),
                            Row(
                              children: [
                                RatingBar(
                                  size: 15,
                                  filledIcon: Icons.star,
                                  emptyIcon: Icons.star_border,
                                  onRatingChanged: (value) =>
                                      debugPrint('$value'),
                                  initialRating: double.parse(restaurant
                                      .ratingCount!
                                      .round()
                                      .toString()),
                                  maxRating: 5,
                                ),
                                Text(
                                  "(${restaurant.ratingCount.toString()})",
                                  style: const TextStyle(color: Colors.orange),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ]),
                ),
              ),
            ]),
            restaurant.discount == null || restaurant.discount == false
                ? const SizedBox()
                : const Divider(),
            restaurant.discount == null || restaurant.discount == false
                ? const SizedBox()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Row(
                      //   children: [
                      //     Image.asset(
                      //       Images.tag,
                      //       height: 14,
                      //     ),
                      //     const SizedBox(width: 10,),
                      //     RichText(
                      //         text: TextSpan(
                      //             style: TextStyle(color: Get.theme.primaryColor),
                      //             children: [
                      //               const TextSpan(text: "Up to Rs."),
                      //               TextSpan(text: " 50 ",style: TextStyle(fontWeight: FontWeight.w500,fontSize: Dimensions.fontSizeLarge)),
                      //               const TextSpan(text: "Off"),
                      //             ]))
                      //   ],
                      // ),

                      DiscountTag(
                        discount: Get.find<RestaurantController>()
                            .getDiscount(restaurant),
                        discountType: Get.find<RestaurantController>()
                            .getDiscountType(restaurant),
                        freeDelivery: restaurant.freeDelivery,
                      ),
                      restaurant.freeDelivery == false
                          ? const SizedBox()
                          : Row(
                              children: [
                                Image.asset(
                                  Images.offer,
                                  height: 10,
                                  width: 10,
                                  color: Get.theme.primaryColor,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Free Delivery",
                                  style:
                                      TextStyle(color: Get.theme.primaryColor),
                                )
                              ],
                            )
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 3.0,
      ),
      child: Material(
        // Material prevents ugly text display when there is no
        // Scaffold above this banner.
        type: MaterialType.transparency,
        color: Colors.transparent,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Store Closed",
                  style: robotoMedium.copyWith(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RestaurantView1 extends StatelessWidget {
  final int? length;
  final Restaurant restaurant;
  final Function()? onTap;
  final bool isSelected;

  const RestaurantView1(
      {super.key,
      required this.restaurant,
      this.onTap,
      this.isSelected = false,  this.length});

  @override
  Widget build(BuildContext context) {
    final bool ltr = Get.find<LocalizationController>().isLtr;
    double distance = Get.find<RestaurantController>().getRestaurantDistance(
      LatLng(double.parse(restaurant.latitude!),
          double.parse(restaurant.longitude!)),
    );

    bool isAvailable = restaurant.open == 1 && restaurant.active!;

    return CustomInkWellWidget(
      onTap: onTap ??
          ()  {
            // if (restaurant.restaurantStatus == 1) {
              Get.toNamed(RouteHelper.getRestaurantRoute(restaurant.id),
                  arguments: RestaurantScreen(
                      ownerNAme: restaurant.ownerName, restaurant: restaurant));
            // } else if (restaurant.restaurantStatus == 0) {
            //   showCustomSnackBar('restaurant_is_not_available'.tr);
            // }
          },
       radius: Dimensions.radiusDefault,
      child: Container(
        width: Get.width,
         padding:  const EdgeInsets.only(
             left: Dimensions.paddingSizeExtraSmall,
         ),
        decoration: BoxDecoration(
            color: Get.theme.cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            boxShadow: const [
              BoxShadow(
                  color: Colors.grey, blurRadius: 1, blurStyle: BlurStyle.outer)
            ]),
        child: Row(children: [
          Stack(
            children: [
              Container(
                width: 88,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  color: Colors.white,
                  // boxShadow: const [
                  //   BoxShadow(
                  //     color: Colors.grey,
                  //     spreadRadius: 2,
                  //     blurRadius: 5,
                  //     offset: Offset(0, 2),
                  //   ),
                  // ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  child: Stack(clipBehavior: Clip.none, children: [
                    CustomImageWidget(
                        image:
                            '${Get.find<SplashController>().configModel!.baseUrls!.restaurantImageUrl}'
                            '/${restaurant.logo}',
                        fit: BoxFit.cover,
                        height: 150,
                        width: 120),
                    // DiscountTag(
                    //   discount: Get.find<RestaurantController>()
                    //       .getDiscount(restaurant),
                    //   discountType: Get.find<RestaurantController>()
                    //       .getDiscountType(restaurant),
                    //   freeDelivery: restaurant.freeDelivery,
                    // ),
                    Get.find<RestaurantController>().isOpenNow(restaurant)
                        ? const SizedBox()
                        : Positioned(
                            top: 2,
                            left: 2,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                              vertical: 2),
                              decoration: BoxDecoration(
                                  color: const Color(0xffF55E1E),
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radiusSmall)),
                              child: Center(
                                child: Text(
                                  "Closed",
                                  style: TextStyle(
                                      fontSize: Dimensions.fontSizeSmall,
                                      color: Get.theme.cardColor),
                                ),
                              ),
                            ),
                          ),

                    // Get.find<RestaurantController>().isOpenNow(restaurant)
                    //     ? const SizedBox()
                    //     :
                    //
                    // Positioned(
                    //         left: 0,
                    //         child: CornerBanner(
                    //           bannerPosition: ltr
                    //               ? CornerBannerPosition.topLeft
                    //               : CornerBannerPosition.topRight,
                    //           bannerColor: Colors.red,
                    //           // bannerColor: Theme.of(context).errorColor,
                    //           elevation: 5,
                    //           shadowColor: Colors.transparent,
                    //           child: _buildBannerContent(),
                    //         )),
                    Positioned(
                      top: 0,
                      // left:
                      //     Get.find<LocalizationController>().isLtr ? null : 15,
                      right:
                          Get.find<LocalizationController>().isLtr ? 0 : null,
                      child: GetBuilder<FavouriteController>(
                          builder: (wishController) {
                        bool isWished = wishController.wishRestIdList
                            .contains(restaurant.id);
                        return CustomFavouriteWidget(
                          isWished: isWished,
                          isRestaurant: true,
                          restaurant: restaurant,
                        );
                      }),
                    ),
                  ]),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(restaurant.name ?? '',
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeLarge,
                            fontWeight: FontWeight.w400)),
                    restaurant.ownerName == null
                        ? const Text("")
                        : Text(
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      "Chef: ${restaurant.ownerName}",
                      style: TextStyle(
                          color: const Color(0xff7E7E7E),
                          fontSize: Dimensions.fontSizeSmall),
                    ),
                    const SizedBox(
                      height: Dimensions.paddingSizeSmall,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(),
                        // Text(
                        //   "${restaurant.deliveryTime} delivery",
                        //   style: TextStyle(
                        //       color: Get.theme.disabledColor,
                        //       fontSize: Dimensions.fontSizeSmall),
                        // ),
                        Row(
                          children: [
                            restaurant.veg == 1
                                ? Image.asset(
                              Images.vegImage,
                              height: 12,
                            )
                                : const SizedBox(),
                            const SizedBox(
                              width: 5,
                            ),
                            restaurant.nonVeg == 1
                                ? Image.asset(
                              Images.newNonVeg,
                              height: 12,
                            )
                                : const SizedBox(),
                          ],
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        (restaurant.cuisineNames==null)
                            ? const SizedBox()
                            : Expanded(
                          child: SizedBox(
                            height: 20,
                            width: 140,
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              itemCount:
                              restaurant.cuisineNames!.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      right: 10.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        restaurant
                                            .cuisineNames![index]
                                            .name!,
                                        style: TextStyle(
                                            color: const Color(
                                                0xff524A61),
                                            fontSize: Dimensions
                                                .fontSizeSmall),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      if (index != restaurant
                                          .cuisineNames!.length - 1)
                                        const Icon(
                                          Icons.circle_rounded,
                                          size: 6,
                                        )
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeSmall,),
                        restaurant
                            .ratingCount==null? const SizedBox():  Row(
                          children: [
                            RatingBar(
                              size: 15,
                              filledIcon: Icons.star,
                              emptyIcon: Icons.star_border,
                              onRatingChanged: (value) =>
                                  debugPrint('$value'),
                              initialRating: double.parse(restaurant
                                  .ratingCount!
                                  .round()
                                  .toString()),
                              maxRating: 5,
                            ),
                            restaurant.ratingCount==null?const SizedBox():    Text(
                              "(${restaurant.ratingCount.toString()})",
                              style: const TextStyle(color: Colors.orange),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ]),
            ),
          ),

        ]),
      ),
    );
  }

  Widget _buildBannerContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 3.0,
      ),
      child: Material(
        // Material prevents ugly text display when there is no
        // Scaffold above this banner.
        type: MaterialType.transparency,
        color: Colors.transparent,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Store Closed",
                  style: robotoMedium.copyWith(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HexagonalContainer extends StatelessWidget {
  final double size;
  final Color color;

  HexagonalContainer({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: size,
            height: size,
            child: CustomPaint(
              painter: HexagonalPainter(color: color),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(size / 4),
          child: ClipRRect(
            borderRadius:
                BorderRadius.circular(8.0), // Adjust border radius as needed
            child: Image.asset(
              Images.scooter,
              fit: BoxFit.fill,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class HexagonalPainter extends CustomPainter {
  final Color color;

  HexagonalPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = color;

    final double halfWidth = size.width / 2;
    final double halfHeight = size.height / 2;
    final double radius = halfWidth;

    final Path path = Path();
    final double angle = pi / 3; // 60 degrees in radians
    final double x0 = halfWidth + radius * cos(0);
    final double y0 = halfHeight + radius * sin(0);
    path.moveTo(x0, y0);

    for (int i = 1; i <= 6; i++) {
      final double x = halfWidth + radius * cos(angle * i);
      final double y = halfHeight + radius * sin(angle * i);
      path.lineTo(x, y);
    }

    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(HexagonalPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class WebRestaurantShimmer extends StatelessWidget {
  const WebRestaurantShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
      ),
      child: Shimmer(
        duration: const Duration(seconds: 2),
        child: Container(
          // height: 172, width: 290,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 93,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(Dimensions.radiusDefault),
                    topRight: Radius.circular(Dimensions.radiusDefault),
                  ),
                ),
              ),
              Positioned(
                top: 60,
                left: 10,
                right: 0,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2),
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.1),
                        border:
                            Border.all(color: Colors.black.withOpacity(0.1)),
                        borderRadius:
                            BorderRadius.circular(Dimensions.radiusSmall),
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeSmall),
                    Container(
                        height: 15,
                        width: 100,
                        color: Colors.black.withOpacity(0.1)),
                    const SizedBox(height: 5),
                    Container(
                        height: 10,
                        width: 130,
                        color: Colors.black.withOpacity(0.1)),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconWithTextRowWidget(
                          icon: Icons.star_border,
                          text: '0.0',
                          color: Colors.black.withOpacity(0.1),
                          style: robotoBold.copyWith(
                              fontSize: Dimensions.fontSizeExtraSmall,
                              color: Colors.black.withOpacity(0.3)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: Dimensions.paddingSizeDefault),
                          child: ImageWithTextRowWidget(
                            widget: Image.asset(Images.deliveryIcon,
                                height: 20,
                                width: 20,
                                color: Colors.black.withOpacity(0.1)),
                            text: 'free'.tr,
                            style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeExtraSmall,
                                color: Colors.black.withOpacity(0.3)),
                          ),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeDefault),
                        IconWithTextRowWidget(
                          icon: Icons.access_time_outlined,
                          text: '10-30 min',
                          color: Colors.black.withOpacity(0.1),
                          style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeExtraSmall,
                              color: Colors.black.withOpacity(0.3)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                top: Dimensions.paddingSizeSmall,
                right: Dimensions.paddingSizeSmall,
                child: Icon(
                  Icons.favorite,
                  size: 20,
                  color: Theme.of(context).cardColor,
                ),
              ),
              Positioned(
                top: 73,
                right: 5,
                child: Container(
                  height: 23,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(Dimensions.radiusDefault),
                        topRight: Radius.circular(Dimensions.radiusDefault)),
                    color: Theme.of(context).cardColor,
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeExtraSmall),
                  child: Center(
                    child: Text('0 ${'km'.tr}',
                        style: robotoMedium.copyWith(
                            fontSize: Dimensions.fontSizeExtraSmall,
                            color: Theme.of(context).disabledColor)),
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

class DiscountTag extends StatelessWidget {
  final double? discount;
  final String? discountType;
  final double fromTop;
  final double? fontSize;
  final bool inLeft;
  final bool? freeDelivery;
  final bool? isFloating;

  const DiscountTag({
    Key? key,
    required this.discount,
    required this.discountType,
    this.fromTop = 10,
    this.fontSize,
    this.freeDelivery = false,
    this.inLeft = true,
    this.isFloating = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isRightSide =
        Get.find<SplashController>().configModel!.currencySymbolDirection ==
            'right';
    String currencySymbol =
        Get.find<SplashController>().configModel!.currencySymbol!;

    return (discount! > 0 || freeDelivery!)
        ? Row(
            children: [
              Image.asset(
                Images.tag,
                height: 14,
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                discount! > 0
                    ? '${(isRightSide || discountType == 'percent') ? '' : currencySymbol}$discount${discountType == 'percent' ? '%' : isRightSide ? currencySymbol : ''} ${'off'.tr}'
                    : 'free_delivery'.tr,
                style: robotoMedium.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontSize: fontSize ??
                      (ResponsiveHelper.isMobile(context) ? 14 : 12),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          )
        : const SizedBox();
  }
}
/*
*    Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(Dimensions.radiusDefault), topRight: Radius.circular(Dimensions.radiusDefault)),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(Dimensions.radiusDefault), topRight: Radius.circular(Dimensions.radiusDefault)),
              child: CustomImageWidget(
                image: '${Get.find<SplashController>().configModel!.baseUrls!.restaurantCoverPhotoUrl}'
                    '/${restaurant.coverPhoto}',
                fit: BoxFit.cover, height: 110, width: double.infinity,
                isRestaurant: true,
              ),
            ),
          ),

          !isAvailable ? Positioned(child: Container(
            height: 110, width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(Dimensions.radiusDefault), topRight: Radius.circular(Dimensions.radiusDefault)),
            ),
          )) : const SizedBox(),

          !isAvailable ? Positioned(top: 10, left: 10, child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error.withOpacity(0.5),
                borderRadius: BorderRadius.circular(Dimensions.radiusLarge)
            ),
            padding: EdgeInsets.symmetric(horizontal: Dimensions.fontSizeExtraLarge, vertical: Dimensions.paddingSizeExtraSmall),
            child: Row(children: [
              Icon(Icons.access_time, size: 12, color: Theme.of(context).cardColor),
              const SizedBox(width: Dimensions.paddingSizeExtraSmall),

              Text('closed_now'.tr, style: robotoMedium.copyWith(color: Theme.of(context).cardColor, fontSize: Dimensions.fontSizeSmall)),
            ]),
          )) : const SizedBox(),

          Positioned(
            top: 70, left: 10, right: 0,
            child: Column(
              children: [
                Container(
                  //padding: const EdgeInsets.all(2.5),
                  height: 70, width: 70,
                  decoration:  BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    border: Border.all(color: Theme.of(context).disabledColor.withOpacity(0.3), width: 2.5),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(3.5),
                    child: CustomImageWidget(
                      image: '${Get.find<SplashController>().configModel!.baseUrls!.restaurantImageUrl}'
                          '/${restaurant.logo}',
                      fit: BoxFit.cover, height: 70, width: 70,
                      isRestaurant: true,
                    ),
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                Text(
                  restaurant.name ?? '',
                  style: robotoBold,
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Text(
                    restaurant.address ?? '',
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                    maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconWithTextRowWidget(
                      icon: Icons.star_border, text: restaurant.avgRating.toString(),
                      style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraSmall),
                    ),
                    restaurant.freeDelivery! ? Padding(
                      padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault),
                      child: ImageWithTextRowWidget(
                        widget: Image.asset(Images.deliveryIcon, height: 20, width: 20),
                        text: 'free'.tr,
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall),
                      ),
                    ) : const SizedBox(),
                    const SizedBox(width: Dimensions.paddingSizeDefault),

                    IconWithTextRowWidget(
                      icon: Icons.access_time_outlined, text: '${restaurant.deliveryTime}',
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall),
                    ),

                  ],
                ),
              ],
            ),
          ),

          Positioned(
            top: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeSmall,
            child: GetBuilder<FavouriteController>(builder: (favouriteController) {
              bool isWished = favouriteController.wishRestIdList.contains(restaurant.id);
              return CustomFavouriteWidget(
                isWished: isWished,
                isRestaurant: true,
                restaurant: restaurant,
              );
            }),
          ),

          Positioned(
            top: 88, right: 15,
            child: Container(
              height: 23,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(Dimensions.radiusDefault), topRight: Radius.circular(Dimensions.radiusDefault)),
                color: Theme.of(context).cardColor,
              ),
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
              child: Center(
                child: Text('${Get.find<RestaurantController>().getRestaurantDistance(
                  LatLng(double.parse(restaurant.latitude!), double.parse(restaurant.longitude!)),
                ).toStringAsFixed(2)} ${'km'.tr}',
                    style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).primaryColor)),
              ),
            ),
          ),
        ],
      ),*/

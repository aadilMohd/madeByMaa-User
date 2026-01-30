import 'package:flutter/cupertino.dart';
import 'package:stackfood_multivendor/common/widgets/custom_favourite_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_ink_well_widget.dart';
import 'package:stackfood_multivendor/corner_banner/rating_bar.dart';
import 'package:stackfood_multivendor/features/home/widgets/arrow_icon_button_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/refer_banner_view_widget.dart';
import 'package:stackfood_multivendor/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/theme_controller.dart';
import 'package:stackfood_multivendor/common/models/restaurant_model.dart';
import 'package:stackfood_multivendor/features/favourite/controllers/favourite_controller.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor/features/restaurant/screens/restaurant_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
// import 'package:custom_rating_bar/custom_rating_bar.dart';

class PopularRestaurantsViewWidget extends StatelessWidget {
  final bool isRecentlyViewed;

  const PopularRestaurantsViewWidget(
      {super.key, this.isRecentlyViewed = false});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RestaurantController>(builder: (restController) {
      List<Restaurant>? restaurantList = isRecentlyViewed
          ? restController.recentlyViewedRestaurantList
          : restController.popularRestaurantList;

      return (restaurantList != null && restaurantList.isEmpty)
          ? const SizedBox()
          : Padding(
              padding: EdgeInsets.symmetric(
                  vertical: ResponsiveHelper.isMobile(context)
                      ? 0
                      : Dimensions.paddingSizeLarge),
              child: SizedBox(
                width: Dimensions.webMaxWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ResponsiveHelper.isDesktop(context)
                        ? Padding(
                            padding: const EdgeInsets.only(
                                bottom: Dimensions.paddingSizeLarge),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    isRecentlyViewed
                                        ? 'recently_viewed_restaurants'.tr
                                        : 'popular_restaurants'.tr,
                                    style: robotoMedium.copyWith(
                                        fontSize: Dimensions.fontSizeLarge,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: Container(
                                      height: 1,
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [
                                            Colors.grey,
                                            Colors.transparent
                                          ],
                                          stops: [
                                            0.2,
                                            0.6
                                          ], // Positions where the colors change
                                        ),
                                      ),
                                    ),
                                  ),
                                  ArrowIconButtonWidget(onTap: () {
                                    Get.toNamed(
                                        RouteHelper.getAllRestaurantRoute(
                                            isRecentlyViewed
                                                ? 'recently_viewed'
                                                : 'popular'));
                                  }),
                                ]),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(
                                Dimensions.paddingSizeDefault),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    isRecentlyViewed
                                        ? 'recently_viewed_restaurants'.tr
                                        : "",
                                    // 'popular_restaurants'.tr,
                                    style: robotoMedium.copyWith(
                                        fontSize: 20,
                                        color: const Color(0xff090018),
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w900),
                                  ),

                                  // SizedBox(width: 5),
                                  // Expanded(
                                  //   child: Container(
                                  //     height: 1,
                                  //     decoration: const BoxDecoration(
                                  //       gradient: LinearGradient(
                                  //         begin: Alignment.centerLeft,
                                  //         end: Alignment.centerRight,
                                  //         colors: [
                                  //           Colors.grey,
                                  //           Colors.transparent
                                  //         ],
                                  //         stops: [
                                  //           0.2,
                                  //           0.6
                                  //         ], // Positions where the colors change
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  // ArrowIconButtonWidget(onTap: () {
                                  //   Get.toNamed(
                                  //       RouteHelper.getAllRestaurantRoute(
                                  //           isRecentlyViewed
                                  //               ? 'recently_viewed'
                                  //               : 'popular'));
                                  // }),
                                ]),
                          ),
                    restaurantList != null
                        ? isRecentlyViewed
                            ? SizedBox(
                                height: 320,
                                child: ListView.builder(
                                  itemCount: restaurantList.length,
                                  scrollDirection: Axis.horizontal,
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16.0, horizontal: 14),
                                      child: InkWell(
                                        onTap: () => Get.toNamed(
                                          RouteHelper.getRestaurantRoute(
                                              restaurantList[index].id),
                                          arguments: RestaurantScreen(
                                              ownerNAme: restaurantList[index]
                                                  .ownerName,
                                              restaurant:
                                                  restaurantList[index]),
                                        ),
                                        child: Container(
                                          width: 194,
                                          decoration: BoxDecoration(
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Colors.grey,
                                                  spreadRadius: 0,
                                                  blurRadius: 6,
                                                  offset: Offset(0,
                                                      4), // Offset on Y-axis for bottom-side shadow
                                                ),
                                              ],
                                              color: Get.theme.cardColor,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimensions
                                                          .radiusExtraLarge)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Stack(
                                                children: [
                                                  Container(
                                                    height: 140,
                                                    width: 200,
                                                    decoration: BoxDecoration(
                                                        // color: Colors.red,
                                                        borderRadius: BorderRadius
                                                            .circular(Dimensions
                                                                .radiusExtraLarge)),
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius
                                                          .circular(Dimensions
                                                              .radiusExtraLarge),
                                                      child: Image.network(
                                                        '${Get.find<SplashController>().configModel!.baseUrls!.restaurantImageUrl}'
                                                        '/${restaurantList[index].logo}',
                                                        fit: BoxFit.cover,
                                                        height: 80,
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: Dimensions
                                                        .paddingSizeSmall2,
                                                    right: Dimensions
                                                        .paddingSizeSmall2,
                                                    child: GetBuilder<
                                                            FavouriteController>(
                                                        builder:
                                                            (favouriteController) {
                                                      bool isWished =
                                                          favouriteController
                                                              .wishRestIdList
                                                              .contains(
                                                                  restaurantList[
                                                                          index]
                                                                      .id);
                                                      return CustomFavouriteWidget(
                                                        isWished: isWished,
                                                        isRestaurant: true,
                                                        restaurant:
                                                            restaurantList[
                                                                index],
                                                      );
                                                    }),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(
                                                    Dimensions
                                                        .paddingSizeDefault),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: 170,
                                                      child: Text(
                                                        restaurantList[index]
                                                            .name
                                                            .toString(),
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            fontSize: Dimensions
                                                                .fontSizeLarge,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    ),
                                                    Text(
                                                      "chef: ${restaurantList[index].ownerName}",
                                                      style: TextStyle(
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          color: const Color(
                                                              0xff524A61),
                                                          fontSize: Dimensions
                                                              .fontSizeSmall,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    const SizedBox(
                                                      height: Dimensions
                                                          .paddingSizeLarge,
                                                    ),
                                                    Row(
                                                      children: [
                                                        // Text(
                                                        //   restaurantList[index]
                                                        //       .deliveryTime
                                                        //       .toString(),
                                                        //   style: TextStyle(
                                                        //       fontWeight:
                                                        //           FontWeight
                                                        //               .w600,
                                                        //       color: const Color(
                                                        //           0xff090018),
                                                        //       fontSize: Dimensions
                                                        //           .fontSizeExtraSmall),
                                                        // ),
                                                        // const SizedBox(
                                                        //   width: Dimensions
                                                        //       .paddingSizeLarge,
                                                        // ),

                                                        RatingBar(
                                                            size: 10,
                                                            rating:
                                                                restaurantList[
                                                                        index]
                                                                    .avgRating,
                                                            ratingCount:
                                                                restaurantList[
                                                                        index]
                                                                    .ratingCount)

                                                        // RatingBar(
                                                        //   size: 12,
                                                        //   filledIcon:
                                                        //       Icons.star,
                                                        //   emptyIcon:
                                                        //       Icons.star_border,
                                                        //   onRatingChanged:
                                                        //       (value) =>
                                                        //           debugPrint(
                                                        //               '$value'),
                                                        //   initialRating:
                                                        //       restaurantList[
                                                        //               index]
                                                        //           .avgRating!
                                                        //           .toDouble(),
                                                        //   maxRating: 5,
                                                        // ),
                                                        // Text(
                                                        //   "(${restaurantList[index].ratingCount.toString()})",
                                                        //   style:
                                                        //       const TextStyle(
                                                        //           color: Colors
                                                        //               .orange),
                                                        // ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: Dimensions
                                                          .paddingSizeSmall,
                                                    ),
                                                    SizedBox(
                                                      width: 150,
                                                      height: 20,
                                                      child: ListView.builder(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        itemCount:
                                                            restaurantList[
                                                                    index]
                                                                .cuisineNames!
                                                                .length,
                                                        itemBuilder:
                                                            (context, indexx) {
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    right: 8.0),
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  restaurantList[
                                                                          index]
                                                                      .cuisineNames![
                                                                          indexx]
                                                                      .name!,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          Dimensions
                                                                              .fontSizeSmall),
                                                                ),
                                                                const SizedBox(
                                                                  width: Dimensions
                                                                      .paddingSizeSmall,
                                                                ),
                                                                if (indexx !=
                                                                    restaurantList[index]
                                                                            .cuisineNames!
                                                                            .length -
                                                                        1)
                                                                  const Icon(
                                                                    Icons
                                                                        .circle_rounded,
                                                                    size: 5,
                                                                    color: Color(
                                                                        0xff524A61),
                                                                  )
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )

                            /// OLD CODE ///

                            // SizedBox(
                            //             height: 185,
                            //             child: ListView.builder(
                            //               itemCount: restaurantList.length,
                            //               padding: EdgeInsets.only(
                            //                   right: ResponsiveHelper.isMobile(context)
                            //                       ? Dimensions.paddingSizeDefault
                            //                       : 0),
                            //               scrollDirection: Axis.horizontal,
                            //               physics: const BouncingScrollPhysics(),
                            //               itemBuilder: (context, index) {
                            //                 bool isAvailable =
                            //                     restaurantList[index].open == 1 &&
                            //                         restaurantList[index].active!;
                            //                 return Padding(
                            //                   padding: EdgeInsets.only(
                            //                       left: (ResponsiveHelper.isDesktop(
                            //                                   context) &&
                            //                               index == 0 &&
                            //                               Get.find<
                            //                                       LocalizationController>()
                            //                                   .isLtr)
                            //                           ? 0
                            //                           : Dimensions.paddingSizeDefault),
                            //                   child: Container(
                            //                     height: 185,
                            //                     width:
                            //                         ResponsiveHelper.isDesktop(context)
                            //                             ? 253
                            //                             : MediaQuery.of(context)
                            //                                     .size
                            //                                     .width *
                            //                                 0.7,
                            //                     decoration: BoxDecoration(
                            //                       color: Theme.of(context).cardColor,
                            //                       borderRadius: BorderRadius.circular(
                            //                           Dimensions.radiusDefault),
                            //                     ),
                            //                     child: CustomInkWellWidget(
                            //                       onTap: () => Get.toNamed(
                            //                         RouteHelper.getRestaurantRoute(
                            //                             restaurantList[index].id),
                            //                         arguments: RestaurantScreen(
                            //                             restaurant:
                            //                                 restaurantList[index]),
                            //                       ),
                            //                       radius: Dimensions.radiusDefault,
                            //                       child: Stack(
                            //                         clipBehavior: Clip.none,
                            //                         children: [
                            //                           Container(
                            //                             height: 95,
                            //                             width:
                            //                                 ResponsiveHelper.isDesktop(
                            //                                         context)
                            //                                     ? 253
                            //                                     : MediaQuery.of(context)
                            //                                             .size
                            //                                             .width *
                            //                                         0.7,
                            //                             decoration: const BoxDecoration(
                            //                               borderRadius: BorderRadius.only(
                            //                                   topLeft: Radius.circular(
                            //                                       Dimensions
                            //                                           .radiusDefault),
                            //                                   topRight: Radius.circular(
                            //                                       Dimensions
                            //                                           .radiusDefault)),
                            //                             ),
                            //                             child: ClipRRect(
                            //                               borderRadius: const BorderRadius
                            //                                   .only(
                            //                                   topLeft: Radius.circular(
                            //                                       Dimensions
                            //                                           .radiusDefault),
                            //                                   topRight: Radius.circular(
                            //                                       Dimensions
                            //                                           .radiusDefault)),
                            //                               child: Stack(
                            //                                 children: [
                            //                                   CustomImageWidget(
                            //                                     image:
                            //                                         '${Get.find<SplashController>().configModel!.baseUrls!.restaurantCoverPhotoUrl}'
                            //                                         '/${restaurantList[index].coverPhoto}',
                            //                                     fit: BoxFit.cover,
                            //                                     height: 95,
                            //                                     width: ResponsiveHelper
                            //                                             .isDesktop(
                            //                                                 context)
                            //                                         ? 253
                            //                                         : MediaQuery.of(
                            //                                                     context)
                            //                                                 .size
                            //                                                 .width *
                            //                                             0.7,
                            //                                     isRestaurant: true,
                            //                                   ),
                            //                                   !isAvailable
                            //                                       ? Positioned(
                            //                                           top: 0,
                            //                                           left: 0,
                            //                                           right: 0,
                            //                                           bottom: 0,
                            //                                           child: Container(
                            //                                             decoration:
                            //                                                 BoxDecoration(
                            //                                               borderRadius: const BorderRadius
                            //                                                   .only(
                            //                                                   topLeft: Radius.circular(
                            //                                                       Dimensions
                            //                                                           .radiusDefault),
                            //                                                   topRight:
                            //                                                       Radius.circular(
                            //                                                           Dimensions.radiusDefault)),
                            //                                               color: Colors
                            //                                                   .black
                            //                                                   .withOpacity(
                            //                                                       0.3),
                            //                                             ),
                            //                                           ),
                            //                                         )
                            //                                       : const SizedBox(),
                            //                                 ],
                            //                               ),
                            //                             ),
                            //                           ),
                            //                           !isAvailable
                            //                               ? Positioned(
                            //                                   top: 30,
                            //                                   left: 60,
                            //                                   child: Container(
                            //                                     decoration: BoxDecoration(
                            //                                         color: Theme.of(
                            //                                                 context)
                            //                                             .colorScheme
                            //                                             .error
                            //                                             .withOpacity(
                            //                                                 0.5),
                            //                                         borderRadius:
                            //                                             BorderRadius.circular(
                            //                                                 Dimensions
                            //                                                     .radiusLarge)),
                            //                                     padding: EdgeInsets.symmetric(
                            //                                         horizontal: Dimensions
                            //                                             .fontSizeExtraLarge,
                            //                                         vertical: Dimensions
                            //                                             .paddingSizeExtraSmall),
                            //                                     child: Row(children: [
                            //                                       Icon(
                            //                                           Icons.access_time,
                            //                                           size: 12,
                            //                                           color: Theme.of(
                            //                                                   context)
                            //                                               .cardColor),
                            //                                       const SizedBox(
                            //                                           width: Dimensions
                            //                                               .paddingSizeExtraSmall),
                            //                                       Text('closed_now'.tr,
                            //                                           style: robotoMedium.copyWith(
                            //                                               color: Theme.of(
                            //                                                       context)
                            //                                                   .cardColor,
                            //                                               fontSize:
                            //                                                   Dimensions
                            //                                                       .fontSizeSmall)),
                            //                                     ]),
                            //                                   ))
                            //                               : const SizedBox(),
                            //                           Positioned(
                            //                             top: 100,
                            //                             left: 85,
                            //                             right: 0,
                            //                             child: Column(
                            //                               crossAxisAlignment:
                            //                                   CrossAxisAlignment.start,
                            //                               children: [
                            //                                 Text(
                            //                                     restaurantList[index]
                            //                                         .name!,
                            //                                     overflow: TextOverflow
                            //                                         .ellipsis,
                            //                                     maxLines: 1,
                            //                                     style: robotoBold),
                            //
                            //                                 // Text(restaurantList[index].address!,
                            //                                 //     overflow: TextOverflow.ellipsis, maxLines: 1,
                            //                                 //     style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),
                            //                               ],
                            //                             ),
                            //                           ),
                            //                           Positioned(
                            //                             bottom: 15,
                            //                             left: 0,
                            //                             right: 0,
                            //                             child: Row(
                            //                               mainAxisAlignment:
                            //                                   MainAxisAlignment.center,
                            //                               children: [
                            //                                 IconWithTextRowWidget(
                            //                                   icon: Icons.star_border,
                            //                                   text:
                            //                                       restaurantList[index]
                            //                                           .avgRating!
                            //                                           .toStringAsFixed(
                            //                                               1),
                            //                                   style: robotoBold.copyWith(
                            //                                       fontSize: Dimensions
                            //                                           .fontSizeSmall),
                            //                                 ),
                            //                                 const SizedBox(
                            //                                     width: Dimensions
                            //                                         .paddingSizeDefault),
                            //                                 restaurantList[index]
                            //                                         .freeDelivery!
                            //                                     ? ImageWithTextRowWidget(
                            //                                         widget: Image.asset(
                            //                                             Images
                            //                                                 .deliveryIcon,
                            //                                             height: 20,
                            //                                             width: 20),
                            //                                         text: 'free'.tr,
                            //                                         style: robotoRegular
                            //                                             .copyWith(
                            //                                                 fontSize:
                            //                                                     Dimensions
                            //                                                         .fontSizeSmall),
                            //                                       )
                            //                                     : const SizedBox(),
                            //                                 restaurantList[index]
                            //                                         .freeDelivery!
                            //                                     ? const SizedBox(
                            //                                         width: Dimensions
                            //                                             .paddingSizeDefault)
                            //                                     : const SizedBox(),
                            //                                 IconWithTextRowWidget(
                            //                                   icon: Icons
                            //                                       .access_time_outlined,
                            //                                   text:
                            //                                       '${restaurantList[index].deliveryTime}',
                            //                                   style: robotoRegular.copyWith(
                            //                                       fontSize: Dimensions
                            //                                           .fontSizeSmall),
                            //                                 ),
                            //                               ],
                            //                             ),
                            //                           ),
                            //                           Positioned(
                            //                             top:
                            //                                 Dimensions.paddingSizeSmall,
                            //                             right:
                            //                                 Dimensions.paddingSizeSmall,
                            //                             child: GetBuilder<
                            //                                     FavouriteController>(
                            //                                 builder:
                            //                                     (favouriteController) {
                            //                               bool isWished =
                            //                                   favouriteController
                            //                                       .wishRestIdList
                            //                                       .contains(
                            //                                           restaurantList[
                            //                                                   index]
                            //                                               .id);
                            //                               return CustomFavouriteWidget(
                            //                                 isWished: isWished,
                            //                                 isRestaurant: true,
                            //                                 restaurant:
                            //                                     restaurantList[index],
                            //                               );
                            //                             }),
                            //                           ),
                            //                           Positioned(
                            //                             top: 73,
                            //                             right: 15,
                            //                             child: Container(
                            //                               height: 23,
                            //                               decoration: BoxDecoration(
                            //                                 borderRadius: const BorderRadius
                            //                                     .only(
                            //                                     topLeft: Radius
                            //                                         .circular(Dimensions
                            //                                             .radiusDefault),
                            //                                     topRight: Radius
                            //                                         .circular(Dimensions
                            //                                             .radiusDefault)),
                            //                                 color: Theme.of(context)
                            //                                     .cardColor,
                            //                               ),
                            //                               padding: const EdgeInsets
                            //                                   .symmetric(
                            //                                   horizontal: Dimensions
                            //                                       .paddingSizeExtraSmall),
                            //                               child: Center(
                            //                                 child: Text(
                            //                                   '${restController.getRestaurantDistance(
                            //                                         LatLng(
                            //                                             double.parse(
                            //                                                 restaurantList[
                            //                                                         index]
                            //                                                     .latitude!),
                            //                                             double.parse(
                            //                                                 restaurantList[
                            //                                                         index]
                            //                                                     .longitude!)),
                            //                                       ).toStringAsFixed(2)} ${'km'.tr}',
                            //                                   style: robotoMedium.copyWith(
                            //                                       fontSize: Dimensions
                            //                                           .fontSizeSmall,
                            //                                       color: Theme.of(
                            //                                               context)
                            //                                           .primaryColor),
                            //                                 ),
                            //                               ),
                            //                             ),
                            //                           ),
                            //                           Positioned(
                            //                             top: 75,
                            //                             left:
                            //                                 Dimensions.paddingSizeSmall,
                            //                             child: Container(
                            //                               height: 65,
                            //                               width: 65,
                            //                               decoration: BoxDecoration(
                            //                                 color: Theme.of(context)
                            //                                     .cardColor,
                            //                                 border: Border.all(
                            //                                     color: Theme.of(context)
                            //                                         .disabledColor
                            //                                         .withOpacity(0.1),
                            //                                     width: 3),
                            //                                 borderRadius:
                            //                                     BorderRadius.circular(
                            //                                         Dimensions
                            //                                             .radiusSmall),
                            //                               ),
                            //                               child: ClipRRect(
                            //                                 borderRadius:
                            //                                     BorderRadius.circular(
                            //                                         Dimensions
                            //                                             .radiusSmall),
                            //                                 child: CustomImageWidget(
                            //                                   image:
                            //                                       '${Get.find<SplashController>().configModel!.baseUrls!.restaurantImageUrl}'
                            //                                       '/${restaurantList[index].logo}',
                            //                                   fit: BoxFit.cover,
                            //                                   height: 65,
                            //                                   width: 65,
                            //                                   isRestaurant: true,
                            //                                 ),
                            //                               ),
                            //                             ),
                            //                           ),
                            //                         ],
                            //                       ),
                            //                     ),
                            //                   ),
                            //                 );
                            //               },
                            //             ),
                            //           )

                            :

                            /// OLD CODE ///

                            Stack(
                                children: [
                                  SizedBox(
                                    height: 580,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.radiusExtraLarge),
                                      child: Image.asset(
                                        Images.paperBg,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    left: 0,
                                    right: 0,
                                    child: Column(
                                      children: [
                                        const ReferBannerViewWidget(),
                                        const SizedBox(
                                          height:
                                              Dimensions.paddingSizeExtraLarge,
                                        ),
                                        Text(
                                          isRecentlyViewed
                                              ? 'recently_viewed_restaurants'.tr
                                              : 'popular_restaurants'.tr,
                                          style: robotoMedium.copyWith(
                                              color: Get.theme.cardColor,
                                              fontSize:
                                                  Dimensions.fontSizeExtraLarge,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom:
                                                    Dimensions.paddingSizeSmall,
                                                right: Dimensions
                                                    .paddingSizeExtraLarge),
                                            child: InkWell(
                                                onTap: () {
                                                  Get.toNamed(RouteHelper
                                                      .getAllRestaurantRoute(
                                                          isRecentlyViewed
                                                              ? 'recently_viewed'
                                                              : 'popular'));
                                                },
                                                child: Text(
                                                  "View all",
                                                  style: TextStyle(
                                                      fontSize: Dimensions
                                                          .fontSizeSmall,
                                                      color:
                                                          Get.theme.cardColor),
                                                )),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 300,
                                          child: ListView.builder(
                                            itemCount: restaurantList.length,
                                            scrollDirection: Axis.horizontal,
                                            physics:
                                                const BouncingScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: InkWell(
                                                  onTap: () {
                                                    Get.toNamed(
                                                      RouteHelper
                                                          .getRestaurantRoute(
                                                              restaurantList[
                                                                      index]
                                                                  .id),
                                                      arguments: RestaurantScreen(
                                                          ownerNAme:
                                                              restaurantList[
                                                                      index]
                                                                  .ownerName,
                                                          restaurant:
                                                              restaurantList[
                                                                  index]),
                                                    );
                                                    print(
                                                        "=-=-=-=-=-${restaurantList[index].ownerName}");
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        left: 10),
                                                    width: 190,
                                                    decoration: BoxDecoration(
                                                        boxShadow: [
                                                          BoxShadow(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.5),
                                                              blurStyle:
                                                                  BlurStyle
                                                                      .outer,
                                                              blurRadius: 4)
                                                        ],
                                                        gradient:
                                                            const LinearGradient(
                                                                colors: [
                                                              Color(0xff9D56E9),
                                                              Color(0xff5C1A9D),
                                                            ],
                                                                begin: Alignment
                                                                    .topCenter,
                                                                end: Alignment
                                                                    .bottomCenter),
                                                        borderRadius: BorderRadius
                                                            .circular(Dimensions
                                                                .radiusExtraLarge)),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Stack(
                                                          children: [
                                                            Container(
                                                              height: 140,
                                                              width: Get.width,
                                                              decoration:
                                                                  BoxDecoration(
                                                                      // color: Colors
                                                                      //     .red,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              Dimensions.radiusExtraLarge)),
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                        Dimensions
                                                                            .radiusExtraLarge),
                                                                child: Image
                                                                    .network(
                                                                  '${Get.find<SplashController>().configModel!.baseUrls!.restaurantImageUrl}'
                                                                  '/${restaurantList[index].logo}',
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  height: 80,
                                                                ),
                                                              ),
                                                            ),
                                                            Positioned(
                                                              top: Dimensions
                                                                  .paddingSizeSmall,
                                                              right: Dimensions
                                                                  .paddingSizeSmall,
                                                              child: GetBuilder<
                                                                      FavouriteController>(
                                                                  builder:
                                                                      (favouriteController) {
                                                                bool isWished = favouriteController
                                                                    .wishRestIdList
                                                                    .contains(
                                                                        restaurantList[index]
                                                                            .id);
                                                                return CustomFavouriteWidget(
                                                                  isWished:
                                                                      isWished,
                                                                  isRestaurant:
                                                                      true,
                                                                  restaurant:
                                                                      restaurantList[
                                                                          index],
                                                                );
                                                              }),
                                                            ),
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets
                                                              .all(Dimensions
                                                                  .paddingSizeDefault),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                restaurantList[
                                                                        index]
                                                                    .name
                                                                    .toString(),
                                                                maxLines: 1,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        Dimensions
                                                                            .fontSizeSmall,
                                                                    color: Get
                                                                        .theme
                                                                        .cardColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                              Text(
                                                                "Chef: ${restaurantList[index].ownerName.toString()}",
                                                                style: TextStyle(
                                                                    color: Get
                                                                        .theme
                                                                        .cardColor,
                                                                    fontSize:
                                                                        Dimensions
                                                                            .fontSizeExtraSmall,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                              ),
                                                              const SizedBox(
                                                                height: Dimensions
                                                                    .paddingSizeSmall,
                                                              ),
                                                              restaurantList[
                                                                          index]
                                                                      .cuisineNames!
                                                                      .isEmpty
                                                                  ? const SizedBox()
                                                                  : Text(
                                                                      "Cuisine",
                                                                      style: TextStyle(
                                                                          color: Get
                                                                              .theme
                                                                              .cardColor,
                                                                          fontSize: Dimensions
                                                                              .fontSizeSmall,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                              SizedBox(
                                                                height: 20,
                                                                child: ListView
                                                                    .builder(
                                                                  scrollDirection:
                                                                      Axis.horizontal,
                                                                  itemCount: restaurantList[
                                                                          index]
                                                                      .cuisineNames!
                                                                      .length,
                                                                  itemBuilder:
                                                                      (context,
                                                                          indexx) {
                                                                    return Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          right:
                                                                              8.0),
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          Text(
                                                                            restaurantList[index].cuisineNames![indexx].name!,
                                                                            style:
                                                                                TextStyle(color: Get.theme.cardColor, fontSize: Dimensions.fontSizeExtraSmall),
                                                                          ),
                                                                          const SizedBox(
                                                                            width:
                                                                                Dimensions.paddingSizeExtraSmall,
                                                                          ),
                                                                          if (indexx !=
                                                                              restaurantList[index].cuisineNames!.length - 1)
                                                                            Icon(
                                                                              Icons.circle_rounded,
                                                                              size: 5,
                                                                              color: Get.theme.cardColor,
                                                                            )
                                                                        ],
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: Dimensions
                                                                    .paddingSizeExtraSmall,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  SizedBox(
                                                                    width: 60,
                                                                    child: Text(
                                                                      maxLines:
                                                                          1,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      restaurantList[
                                                                              index]
                                                                          .deliveryTime
                                                                          .toString(),
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            Dimensions.fontSizeExtraSmall,
                                                                        color: Get
                                                                            .theme
                                                                            .cardColor,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: Dimensions
                                                                        .paddingSizeSmall,
                                                                  ),
                                                                  RatingBar(
                                                                      size: 12,
                                                                      rating: restaurantList[
                                                                              index]
                                                                          .avgRating,
                                                                      ratingCount:
                                                                          restaurantList[index]
                                                                              .ratingCount),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              )

                        //////////////////////////////////////////

                        // SizedBox(
                        //   height: (restaurantList.length == 1)
                        //       ? 175
                        //       : restaurantList.length == 2
                        //       ? 350
                        //       : 525,
                        //   child: GridView.builder(
                        //     physics: const BouncingScrollPhysics(),
                        //     shrinkWrap: true,
                        //     scrollDirection: Axis.horizontal,
                        //     gridDelegate:
                        //     SliverGridDelegateWithFixedCrossAxisCount(
                        //         crossAxisCount:
                        //         (restaurantList.length == 1)
                        //             ? 1
                        //             : restaurantList.length == 2
                        //             ? 2
                        //             : 3,
                        //         crossAxisSpacing: 0,
                        //         mainAxisSpacing:
                        //         Dimensions.paddingSizeDefault,
                        //         mainAxisExtent: MediaQuery
                        //             .of(context)
                        //             .size
                        //             .width),
                        //     padding: const EdgeInsets.only(
                        //       left: Dimensions.paddingSizeDefault,
                        //     ),
                        //     itemCount: restaurantList.length,
                        //     itemBuilder: (context, index) {
                        //       bool isAvailable =
                        //           restaurantList[index].open == 1 &&
                        //               restaurantList[index].active!;
                        //       return RestaurantView(
                        //         restaurant: restaurantList[index],
                        //       );
                        //     },
                        //   ),
                        // )
                        : const PopularRestaurantShimmer(),
                  ],
                ),
              ),
            );
    });
  }
}

class PopularRestaurantShimmer extends StatelessWidget {
  const PopularRestaurantShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 185,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(
              left: ResponsiveHelper.isMobile(context)
                  ? Dimensions.paddingSizeDefault
                  : 0,
              right: ResponsiveHelper.isMobile(context)
                  ? Dimensions.paddingSizeDefault
                  : 0),
          itemCount: 7,
          itemBuilder: (context, index) {
            return Shimmer(
              duration: const Duration(seconds: 2),
              enabled: true,
              child: Container(
                margin: EdgeInsets.only(
                    left: index == 0 ? 0 : Dimensions.paddingSizeDefault),
                height: 185,
                width: 253,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                ),
                child: Stack(clipBehavior: Clip.none, children: [
                  Container(
                    height: 85,
                    width: 253,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(Dimensions.radiusDefault),
                          topRight: Radius.circular(Dimensions.radiusDefault)),
                    ),
                    child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(Dimensions.radiusDefault),
                            topRight:
                                Radius.circular(Dimensions.radiusDefault)),
                        child: Container(
                          height: 85,
                          width: 253,
                          color: Colors.grey[
                              Get.find<ThemeController>().darkTheme
                                  ? 700
                                  : 300],
                        )),
                  ),
                  Positioned(
                    top: 90,
                    left: 75,
                    right: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 15,
                          width: 100,
                          color: Colors.grey[
                              Get.find<ThemeController>().darkTheme
                                  ? 700
                                  : 300],
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),
                        Container(
                          height: 15,
                          width: 200,
                          color: Colors.grey[
                              Get.find<ThemeController>().darkTheme
                                  ? 700
                                  : 300],
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),
                      ],
                    ),
                  ),
                ]),
              ),
            );
          }),
    );
  }
}

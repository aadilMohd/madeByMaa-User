import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:stackfood_multivendor/common/models/product_model.dart';
import 'package:stackfood_multivendor/common/models/restaurant_model.dart';
import 'package:stackfood_multivendor/common/widgets/custom_favourite_widget.dart';
import 'package:stackfood_multivendor/common/widgets/no_data_screen_widget.dart';
import 'package:stackfood_multivendor/common/widgets/product_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor/common/widgets/product_shimmer_widget.dart';
import 'package:stackfood_multivendor/common/widgets/product_widget.dart';
import 'package:stackfood_multivendor/corner_banner/rating_bar.dart';
import 'package:stackfood_multivendor/features/home/controllers/home_controller.dart';
import 'package:stackfood_multivendor/features/home/widgets/theme1/restaurant_widget.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/common/widgets/web_restaurant_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../features/auth/controllers/auth_controller.dart';
import '../../features/favourite/controllers/favourite_controller.dart';
import '../../features/language/controllers/localization_controller.dart';
import '../../features/restaurant/controllers/restaurant_controller.dart';
import '../../features/splash/controllers/splash_controller.dart';
import '../../helper/price_converter.dart';
import '../../helper/route_helper.dart';
import '../../util/images.dart';

import '../../util/styles.dart';
import 'custom_snackbar_widget.dart';

class ProductViewWidget extends StatelessWidget {
  final bool? category;
  final bool? isClientPadding;
  final List<Product?>? products;
  final List<Restaurant?>? restaurants;
  final bool isRestaurant;
  final bool isFav;
  final EdgeInsetsGeometry padding;
  final bool isScrollable;
  final bool? restraName;
  final int shimmerLength;
  final String? noDataText;
  final bool isCampaign;
  final bool inRestaurantPage;
  final bool showTheme1Restaurant;
  final bool? isWebRestaurant;
  final bool? fromFavorite;
  final bool? fromSearch;
  ProductViewWidget(
      {super.key,
      required this.restaurants,
      required this.products,
      required this.isRestaurant,
      this.isScrollable = false,
      this.restraName = false,
      this.shimmerLength = 20,
      this.padding = const EdgeInsets.all(Dimensions.paddingSizeSmall),
      this.noDataText,
      this.isCampaign = false,
      this.inRestaurantPage = false,
      this.showTheme1Restaurant = false,
      this.isWebRestaurant = false,
      this.fromFavorite = false,
      this.fromSearch = false,
      this.isFav = false,
      this.category = false,
      this.isClientPadding = false});

  @override
  Widget build(BuildContext context) {
    bool isNull = true;
    int length = 0;
    if (isRestaurant) {
      isNull = restaurants == null;
      if (!isNull) {
        length = restaurants!.length;
      }
    } else {
      isNull = products == null;
      if (!isNull) {
        length = products!.length;
      }
    }

    return Column(children: [
      !isNull
          ? length > 0
              ? (isFav == true || category != false)
                  ? MasonryGridView.count(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeDefault,
                          vertical: Dimensions.paddingSizeExtraLarge),
                      crossAxisCount: 2,
                      mainAxisSpacing: 30.0,
                      crossAxisSpacing: 15.0,
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: products!.length,
                      // itemCount: 6,
                      itemBuilder: (context, index) {
                        double? price = products![index]!.price;
                        double? discount =
                            (products![index]!.restaurantDiscount == 0)
                                ? products![index]!.discount
                                : products![index]!.restaurantDiscount;
                        String? discountType =
                            (products![index]!.restaurantDiscount == 0)
                                ? products![index]!.discountType
                                : 'percent';

                        double priceWithDiscountForView =
                            PriceConverter.convertWithDiscount(
                                price, discount, discountType)!;
                        double priceWithDiscount =
                            PriceConverter.convertWithDiscount(
                                price, discount, discountType)!;

                        String imagePath = dust(index);
                        Color textColor = dust1(index);

                        return InkWell(
                          onTap: () {
                            if (products![index]!.restaurantStatus == 1) {
                              ResponsiveHelper.isMobile(context)
                                  ? Get.bottomSheet(
                                      elevation: 0,
                                      ProductBottomSheetWidget(
                                          product: products![index],
                                          inRestaurantPage: false,
                                          isCampaign: isCampaign),
                                      backgroundColor: Colors.transparent,
                                      isScrollControlled: true,
                                    )
                                  : Get.dialog(
                                      Dialog(
                                          backgroundColor: Colors.transparent,
                                          child: ProductBottomSheetWidget(
                                              product: products![index],
                                              inRestaurantPage: false)),
                                    );
                            } else {
                              showCustomSnackBar('product_is_not_available'.tr);
                            }
                          },
                          child: Stack(
                            // clipBehavior: Clip.none,
                            children: [
                              Image.asset(
                                imagePath,
                                fit: BoxFit.cover,
                              ),

                              ///free delivery///
                              SizedBox(
                                height: index == 1 ? 120 : 150,
                                width:  Get.width,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                      fit: BoxFit.cover,
                                      // height: index == 1 ? 80 : 150,
                                      // width: index == 1 ? 80 : 200,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                    return const Text("Loading...");
                                  },
                                      '${Get.find<SplashController>().configModel?.baseUrls?.productImageUrl}'
                                      '/${products![index]!.image.toString()}'),
                                ),
                              ),

                              Positioned(
                                bottom: 60,
                                right: 10,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.baseline,
                                          textBaseline: TextBaseline.alphabetic,
                                          // crossAxisAlignment:
                                          // CrossAxisAlignment
                                          //     .end,
                                          children: [
                                            Text(
                                              "₹ ",
                                              style:
                                                  TextStyle(color: textColor),
                                            ),
                                            Text(
                                              priceWithDiscountForView
                                                  .round()
                                                  .toString(),
                                              style: TextStyle(
                                                  color: textColor,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: Dimensions
                                                      .fontSizeOverLarge),
                                            ),
                                          ],
                                        ),
                                        (index == 1 ||
                                                products![index]!.discount == 0)
                                            ? SizedBox()
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.baseline,
                                                textBaseline:
                                                    TextBaseline.alphabetic,
                                                // crossAxisAlignment:
                                                // CrossAxisAlignment
                                                //     .end,
                                                children: [
                                                  Text(
                                                    "₹ ",
                                                    style: TextStyle(
                                                      color: textColor,
                                                      fontSize: Dimensions
                                                          .fontSizeSmall,
                                                    ),
                                                  ),
                                                  Text(
                                                    products![index]!
                                                        .price!
                                                        .round()
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: textColor,
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough,
                                                        decorationColor:
                                                            textColor,
                                                        fontSize: Dimensions
                                                            .fontSizeDefault),
                                                  ),
                                                ],
                                              )
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              Positioned(
                                bottom: 10,
                                left: 10,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    restraName == true
                                        ? SizedBox()
                                        : SizedBox(
                                            width: 100,
                                            child: Text(
                                              products![index]!.restaurantName!,
                                              softWrap: true,
                                              overflow: TextOverflow.ellipsis,
                                              style:
                                                  TextStyle(color: textColor),
                                            ),
                                          ),

                                    // products![index]!.minDeliveryTime == null
                                    //     ? SizedBox()
                                    //     :
                                    // index == 1?Sized:
                                    // SizedBox(
                                    //         width: 100,
                                    //         child: Text(
                                    //           "${products![index]!.maxDeliveryTime} Min Delivery",
                                    //           softWrap: true,
                                    //           overflow: TextOverflow.ellipsis,
                                    //           style: TextStyle(
                                    //               color: textColor,
                                    //               fontSize:
                                    //                   Dimensions.fontSizeSmall),
                                    //         ),
                                    //       ),

                                    Row(
                                      children: [
                                        /// Rating//
                                        RatingBar(
                                            rating: products![index]!.avgRating,
                                            unSeletedStar:
                                                Get.find<HomeController>()
                                                    .unRatedColor!,
                                            starColor:
                                                Get.find<HomeController>()
                                                    .ratedColor!,
                                            size: 14,
                                            ratingCount:
                                                products![index]!.ratingCount)
                                      ],
                                    ),

                                  ],
                                ),
                              ),

                              ///name product
                              Positioned(
                                top: index == 1 ? 130 : 160,
                                left: 10,
                                child: SizedBox(
                                  width: 100,
                                  child: Text(
                                    products![index]!.name!,
                                    maxLines: 2,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: Dimensions.fontSizeLarge,
                                        fontWeight: FontWeight.w600,
                                        color: textColor),
                                  ),
                                ),
                              ),

                              ///favourite
                              // Positioned(
                              //   top: products![index]!.discount != 0 ? 40 : 10,
                              //   left: Get.find<LocalizationController>().isLtr
                              //       ? null
                              //       : 15,
                              //   right: Get.find<LocalizationController>().isLtr
                              //       ? 5
                              //       : null,
                              //   child: GetBuilder<FavouriteController>(
                              //       builder: (wishController) {
                              //     bool isWished = wishController
                              //         .wishProductIdList
                              //         .contains(products![index]!.id);
                              //     return CustomFavouriteWidget(
                              //       isWished: isWished,
                              //       isRestaurant: false,
                              //       product: products![index],
                              //     );
                              //   }),
                              // ),

                              // Positioned(
                              //   top: -12,
                              //   left: 15,
                              //   child: StreamBuilder<Object>(
                              //     stream: null,
                              //     builder: (context, snapshot) {
                              //       return Row(
                              //         mainAxisAlignment:
                              //             MainAxisAlignment.center,
                              //         children: [
                              //           Container(
                              //             padding: const EdgeInsets.symmetric(
                              //                 horizontal: 8, vertical: 5),
                              //             decoration: BoxDecoration(
                              //               color: Get.theme.primaryColor,
                              //               borderRadius: BorderRadius.circular(
                              //                   Dimensions.radiusSmall),
                              //             ),
                              //             child: Row(
                              //               mainAxisAlignment:
                              //                   MainAxisAlignment.center,
                              //               children: [
                              //                 Image.asset(
                              //                   Images.offer,
                              //                   height: 15,
                              //                 ),
                              //                 const SizedBox(width: 5),
                              //                 Text(
                              //                   "Free Delivery",
                              //                   style: TextStyle(
                              //                     fontWeight: FontWeight.w500,
                              //                     fontSize: Dimensions
                              //                         .fontSizeExtraSmall,
                              //                     color: Get.theme.cardColor,
                              //                   ),
                              //                 ),
                              //               ],
                              //             ),
                              //           ),
                              //         ],
                              //       );
                              //     },
                              //   ),
                              // ),

                              ///  offer
                              products![index]!.discount != 0
                                  ?
                                  // Positioned(
                                  //         top: -20,
                                  //         right: -15,
                                  //         child: StreamBuilder<Object>(
                                  //           stream: null,
                                  //           builder: (context, snapshot) {
                                  //             return Stack(
                                  //               children: [
                                  //                 Image.asset(
                                  //                   Images.offer50,
                                  //                   height: 55,
                                  //                 ),
                                  //                 Positioned.fill(
                                  //                     top: 0,
                                  //                     bottom: 0,
                                  //                     child: Center(
                                  //                       child: Column(
                                  //                         mainAxisAlignment:
                                  //                             MainAxisAlignment
                                  //                                 .center,
                                  //                         crossAxisAlignment:
                                  //                             CrossAxisAlignment
                                  //                                 .center,
                                  //                         children: [
                                  //                           (products![index]!
                                  //                                       .discountType ==
                                  //                                   'percent')
                                  //                               ? Row(
                                  //                                   mainAxisAlignment:
                                  //                                       MainAxisAlignment
                                  //                                           .center,
                                  //                                   children: [
                                  //                                     Text(
                                  //                                       '${products![index]!.discount!.round()}',
                                  //                                       style: robotoBold.copyWith(
                                  //                                           fontSize:
                                  //                                               Dimensions
                                  //                                                   .fontSizeExtraLarge,
                                  //                                           color: Theme.of(context)
                                  //                                               .cardColor,
                                  //                                           fontWeight:
                                  //                                               FontWeight.bold),
                                  //                                     ),
                                  //                                     Text(
                                  //                                       "%",
                                  //                                       style: robotoBold.copyWith(
                                  //                                           fontSize:
                                  //                                               Dimensions
                                  //                                                   .fontSizeExtraSmall,
                                  //                                           color: Theme.of(context)
                                  //                                               .cardColor,
                                  //                                           fontWeight:
                                  //                                               FontWeight.bold),
                                  //                                     )
                                  //                                   ],
                                  //                                 )
                                  //                               : Row(
                                  //                                   mainAxisAlignment:
                                  //                                       MainAxisAlignment
                                  //                                           .center,
                                  //                                   crossAxisAlignment:
                                  //                                       CrossAxisAlignment
                                  //                                           .baseline,
                                  //                                   textBaseline:
                                  //                                       TextBaseline
                                  //                                           .alphabetic,
                                  //                                   children: [
                                  //                                     Text(
                                  //                                       '₹',
                                  //                                       style: robotoBold.copyWith(
                                  //                                           fontSize:
                                  //                                               Dimensions
                                  //                                                   .fontSizeExtraSmall,
                                  //                                           color: Theme.of(context)
                                  //                                               .cardColor,
                                  //                                           fontWeight:
                                  //                                               FontWeight.bold),
                                  //                                     ),
                                  //                                     Text(
                                  //                                       '${products![index]!.discount!.round()}',
                                  //                                       style: robotoBold.copyWith(
                                  //                                           fontSize:
                                  //                                               Dimensions
                                  //                                                   .fontSizeExtraLarge,
                                  //                                           color: Theme.of(context)
                                  //                                               .cardColor,
                                  //                                           fontWeight:
                                  //                                               FontWeight.bold),
                                  //                                     ),
                                  //                                   ],
                                  //                                 ),
                                  //                           Text(
                                  //                             style: TextStyle(
                                  //                                 color: Get.theme
                                  //                                     .cardColor,
                                  //                                 fontSize: Dimensions
                                  //                                     .fontSizeExtraSmall),
                                  //                             'off',
                                  //                           )
                                  //                         ],
                                  //                       ),
                                  //                     )),
                                  //               ],
                                  //             );
                                  //           },
                                  //         ),
                                  //       )

                                  Positioned(
                                      top: 20,
                                      right: 0,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Color(
                                              0xffF07701), // background color for the discount tag
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            (products![index]!.discountType ==
                                                    'percent')
                                                ? Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        '${products![index]!.discount!.round()}',
                                                        style:
                                                            robotoBold.copyWith(
                                                          fontSize: Dimensions
                                                              .fontSizeLarge,
                                                          color:
                                                              Theme.of(context)
                                                                  .cardColor,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        '%',
                                                        style:
                                                            robotoBold.copyWith(
                                                          fontSize: Dimensions
                                                              .fontSizeSmall,
                                                          color:
                                                              Theme.of(context)
                                                                  .cardColor,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        '₹',
                                                        style:
                                                            robotoBold.copyWith(
                                                          fontSize: Dimensions
                                                              .fontSizeSmall,
                                                          color:
                                                              Theme.of(context)
                                                                  .cardColor,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        '${products![index]!.discount!.round()}',
                                                        style:
                                                            robotoBold.copyWith(
                                                          fontSize: Dimensions
                                                              .fontSizeLarge,
                                                          color:
                                                              Theme.of(context)
                                                                  .cardColor,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                            Text(
                                              'off',
                                              style: TextStyle(
                                                color:
                                                    Theme.of(context).cardColor,
                                                fontSize:
                                                    Dimensions.fontSizeSmall,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                        );
                      },
                    )
                  : GridView.builder(
                      key: UniqueKey(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: Dimensions.paddingSizeLarge,
                        mainAxisSpacing: ResponsiveHelper.isDesktop(context) &&
                                !isWebRestaurant!
                            ? Dimensions.paddingSizeLarge
                            : isWebRestaurant!
                                ? Dimensions.paddingSizeLarge
                                : 20,
                        childAspectRatio: ResponsiveHelper.isDesktop(context) &&
                                !isWebRestaurant!
                            ? 3
                            : isWebRestaurant!
                                ? 1.5
                                : showTheme1Restaurant
                                    ? 1.9
                                    : 3.5,
                        mainAxisExtent: ResponsiveHelper.isDesktop(context) &&
                                !isWebRestaurant!
                            ? 142
                            : isWebRestaurant!
                                ? 280
                                : showTheme1Restaurant
                                    ? 200
                                    : (isRestaurant == true)
                                        ? 110
                                        : 140,
                        crossAxisCount: ResponsiveHelper.isMobile(context) &&
                                !isWebRestaurant!
                            ? 1
                            : isWebRestaurant!
                                ? 4
                                : 3,
                      ),
                      physics: isScrollable
                          ? const BouncingScrollPhysics()
                          : const NeverScrollableScrollPhysics(),
                      shrinkWrap: isScrollable ? false : true,
                      itemCount: length,
                      padding: padding,
                      itemBuilder: (context, index) {
                        return showTheme1Restaurant
                            ? RestaurantWidget(
                                restaurant: restaurants![index],
                                index: index,
                                inStore: inRestaurantPage)
                            : isWebRestaurant!
                                ? WebRestaurantWidget(
                                    restaurant: restaurants![index])
                                : ProductWidget1(
                                    isRestaurant: isRestaurant,
                                    product:
                                        isRestaurant ? null : products![index],
                                    restaurant: isRestaurant
                                        ? restaurants![index]
                                        : null,
                                    index: index,
                                    length: length,
                                    isCampaign: isCampaign,
                                  );
                      },
                    )
              : NoDataScreen(
                  isEmptyRestaurant: isRestaurant ? true : false,
                  isEmptyWishlist: fromFavorite! ? true : false,
                  isEmptySearchFood: fromSearch! ? true : false,
                  title: noDataText ??
                      (isRestaurant
                          ? 'there_is_no_restaurant'.tr
                          : 'there_is_no_food'.tr),
                )
          : GridView.builder(
              key: UniqueKey(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: Dimensions.paddingSizeLarge,

                mainAxisSpacing: ResponsiveHelper.isDesktop(context)
                    ? Dimensions.paddingSizeLarge
                    : 0.01,

                //childAspectRatio: ResponsiveHelper.isDesktop(context) && !isWebRestaurant! ? 3 : isWebRestaurant! ? 1.5 : showTheme1Restaurant ? 1.9 : 3.3,
                mainAxisExtent:
                    ResponsiveHelper.isDesktop(context) && !isWebRestaurant!
                        ? 140
                        : isWebRestaurant!
                            ? 280
                            : showTheme1Restaurant
                                ? 250
                                : 122,
                crossAxisCount:
                    ResponsiveHelper.isMobile(context) && !isWebRestaurant!
                        ? 1
                        : isWebRestaurant!
                            ? 4
                            : 3,
              ),
              physics: isScrollable
                  ? const BouncingScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
              shrinkWrap: isScrollable ? false : true,
              itemCount: shimmerLength,
              padding: padding,
              itemBuilder: (context, index) {
                return showTheme1Restaurant
                    ? RestaurantShimmer(isEnable: isNull)
                    : isWebRestaurant!
                        ? const WebRestaurantShimmer()
                        : ProductShimmer(
                            isEnabled: isNull,
                            isRestaurant: isRestaurant,
                            hasDivider: index != shimmerLength - 1);
              },
            ),
    ]);
  }

  String dust(int index) {
    if (index == 0) {
      return 'assets/image/bg1.png';
    }
    if (index == 1) {
      return 'assets/image/small bg.png';
    }
    if (index == 2) {
      return 'assets/image/bg1.png';
    }
    if (shouldPrint(index - 3)) {
      return 'assets/image/bg2.png';
    } else {
      return 'assets/image/bg1.png';
    }
  }

  Color dust1(int index) {
    if (index == 0) {
      Get.find<HomeController>().ratedColor = const Color(0xFFFF9C11);
      Get.find<HomeController>().unRatedColor = Colors.grey;
      return Colors.white;
    }
    if (index == 1) {
      Get.find<HomeController>().ratedColor = Colors.black;
      Get.find<HomeController>().unRatedColor = Colors.grey;
      return const Color(0xFF090018);
    }
    if (index == 2) {
      Get.find<HomeController>().ratedColor = const Color(0xFFFF9C11);
      Get.find<HomeController>().unRatedColor = Colors.grey;
      return Colors.white;
    }
    if (shouldPrint(index - 3)) {
      Get.find<HomeController>().ratedColor = Colors.black;
      Get.find<HomeController>().unRatedColor = Colors.grey;
      return const Color(0xFF090018);
    } else {
      Get.find<HomeController>().ratedColor = const Color(0xFFFF9C11);
      Get.find<HomeController>().unRatedColor = Colors.grey;
      return Colors.white;
    }
  }

  bool shouldPrint(int index) {
    return index % 4 < 2;
  }
}

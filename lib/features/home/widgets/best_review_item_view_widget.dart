import 'dart:math';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:stackfood_multivendor/features/home/widgets/arrow_icon_button_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/item_card_widget.dart';
import 'package:stackfood_multivendor/features/language/controllers/localization_controller.dart';
import 'package:stackfood_multivendor/features/review/controllers/review_controller.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/widgets/custom_favourite_widget.dart';
import '../../../common/widgets/product_bottom_sheet_widget.dart';
import '../../../corner_banner/rating_bar.dart';
import '../../../helper/price_converter.dart';
import '../../../util/images.dart';
import '../../favourite/controllers/favourite_controller.dart';
import '../../splash/controllers/splash_controller.dart';

class BestReviewItemViewWidget extends StatefulWidget {
  final bool isPopular;

  // final Restaurant restaurant;

  const BestReviewItemViewWidget({
    super.key,
    required this.isPopular,
    // required this.restaurant
  });

  @override
  State<BestReviewItemViewWidget> createState() =>
      _BestReviewItemViewWidgetState();
}

class _BestReviewItemViewWidgetState extends State<BestReviewItemViewWidget> {
  final List<String> images = [
    Images.categoryBg1,
    Images.categoryBg2,
  ];
  final Random random = Random();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReviewController>(builder: (reviewController) {
      return (reviewController.reviewedProductList != null &&
              reviewController.reviewedProductList!.isEmpty)
          ? const SizedBox()
          : Padding(
              padding: EdgeInsets.symmetric(
                  vertical: ResponsiveHelper.isMobile(context)
                      ? Dimensions.paddingSizeDefault
                      : Dimensions.paddingSizeLarge),
              child: SizedBox(
                height: ResponsiveHelper.isMobile(context) ? 340 : 355,
                width: Dimensions.webMaxWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveHelper.isMobile(context)
                              ? Dimensions.paddingSizeDefault
                              : 0),
                      child: Row(
                        children: [
                          Text('best_reviewed_food'.tr,
                              style: robotoBold.copyWith(
                                  fontSize: Dimensions.fontSizeLarge,
                                  fontWeight: FontWeight.w600)),
                          const Spacer(),
                          ArrowIconButtonWidget(
                            onTap: () => Get.toNamed(
                                RouteHelper.getPopularFoodRoute(
                                    widget.isPopular)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeDefault),
                    reviewController.reviewedProductList != null
                        ? Expanded(
                            child: SizedBox(
                              height: ResponsiveHelper.isMobile(context)
                                  ? 240
                                  : 255,
                              child: ListView.builder(
                                itemCount: reviewController
                                    .reviewedProductList!.length,
                                padding: EdgeInsets.only(
                                    right: ResponsiveHelper.isMobile(context)
                                        ? Dimensions.paddingSizeDefault
                                        : 0),
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        left: (ResponsiveHelper.isDesktop(
                                                    context) &&
                                                index == 0 &&
                                                Get.find<
                                                        LocalizationController>()
                                                    .isLtr)
                                            ? 0
                                            : Dimensions.paddingSizeDefault),
                                    child: ItemCardWidget(
                                      isBestItem: true,
                                      product: reviewController
                                          .reviewedProductList![index],
                                      width: ResponsiveHelper.isDesktop(context)
                                          ? 200
                                          : MediaQuery.of(context).size.width *
                                              0.53,
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                        : const ItemCardShimmer(isPopularNearbyItem: false),
                  ],
                ),
              ),
            );
    });
  }
}

class BestReviewItemViewWidget1 extends StatelessWidget {
  final bool isPopular;

  const BestReviewItemViewWidget1({super.key, required this.isPopular});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReviewController>(builder: (reviewController) {

      return (reviewController.reviewedProductList != null &&
              reviewController.reviewedProductList!.isEmpty)
          ? const SizedBox()
          : Padding(
              padding: EdgeInsets.symmetric(
                  vertical: ResponsiveHelper.isMobile(context)
                      ? Dimensions.paddingSizeDefault
                      : Dimensions.paddingSizeLarge),
              child: SizedBox(
                // height: ResponsiveHelper.isMobile(context) ? 340 : 355, width: Dimensions.webMaxWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveHelper.isMobile(context)
                              ? Dimensions.paddingSizeDefault
                              : 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('best_reviewed_food'.tr,
                              style: robotoBold.copyWith(
                                  fontSize: 18,
                                  // color: const Color(0xff090018),
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w700)),

                          // const Spacer(),
                          // const SizedBox(width: 5),
                          // Expanded(
                          //   child: Container(
                          //     height: 1,
                          //     decoration: const BoxDecoration(
                          //       gradient: LinearGradient(
                          //         begin: Alignment.centerLeft,
                          //         end: Alignment.centerRight,
                          //         colors: [Colors.grey, Colors.transparent],
                          //         stops: [
                          //           0.2,
                          //           0.6
                          //         ], // Positions where the colors change
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          // ArrowIconButtonWidget(
                          //   onTap: () => Get.toNamed(
                          //       RouteHelper.getPopularFoodRoute(isPopular)),
                          // ),
                        ],
                      ),
                    ),
                    const SizedBox(
                        height: Dimensions.paddingSizeExtraOverLarge),
                    reviewController.reviewedProductList != null
                        ?
                        // Expanded(
                        //   child: SizedBox(
                        //     height: ResponsiveHelper.isMobile(context) ? 240 : 255,
                        //     child: ListView.builder(
                        //       itemCount: reviewController.reviewedProductList!.length,
                        //       padding: EdgeInsets.only(right: ResponsiveHelper.isMobile(context) ? Dimensions.paddingSizeDefault : 0),
                        //       scrollDirection: Axis.horizontal,
                        //       physics: const BouncingScrollPhysics(),
                        //       itemBuilder: (context, index) {
                        //         return Padding(
                        //           padding: EdgeInsets.only(
                        //               left: (ResponsiveHelper.isDesktop (context) && index == 0 && Get.find<LocalizationController>().isLtr) ? 0 : Dimensions.paddingSizeDefault),
                        //           child: ItemCardWidget1(
                        //             isBestItem: true,
                        //             product: reviewController.reviewedProductList![index],
                        //             width: ResponsiveHelper.isDesktop (context) ? 200 : MediaQuery.of(context).size.width * 0.53,
                        //           ),
                        //         );
                        //       },
                        //     ),
                        //   ),
                        // )

                        Stack(
                            children: [
                              MasonryGridView.count(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: Dimensions.paddingSizeDefault),
                                crossAxisCount: 2,
                                mainAxisSpacing: 30.0,
                                crossAxisSpacing: 15.0,
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemCount: reviewController
                                            .reviewedProductList!.length >=
                                        8
                                    ? 8
                                    : reviewController
                                        .reviewedProductList!.length,
                                itemBuilder: (context, index) {


                                  double? foodPrice = reviewController
                                      .reviewedProductList![index].price;

                                  double sum=foodPrice! - double.parse(reviewController
                                      .reviewedProductList![index].discount.toString());

                                  double percentSum=(reviewController
                                      .reviewedProductList![index].discount!/100)*foodPrice;
                                  double percentSum2=foodPrice-percentSum;



                                  String imagePath;
                                  Color textColor;
                                  Color textColor2;
                                  Color starColor;


                                  if (index == 1) {
                                    imagePath = 'assets/image/small bg.png';
                                    textColor = Colors.black;
                                    textColor2 = const Color(0xff524A61);
                                    starColor = const Color(0xff090018);
                                  } else if (index == 2 ||
                                      index == 0 ||
                                      index == 5 ||
                                      index == 6) {
                                    imagePath = 'assets/image/bg1.png';


                                    textColor = Get.theme.cardColor;
                                    textColor2 = const Color(0xffE0E0E0);
                                    starColor = const Color(0xffFF9C11);
                                  } else {
                                    imagePath = (index % 2 == 0)
                                        ? 'assets/image/bg2.png'
                                        : 'assets/image/bg2.png';
                                    textColor = Colors.black;
                                    textColor2 = const Color(0xff524A61);
                                    starColor = const Color(0xff090018);
                                  }



                                  return InkWell(
                                    onTap: () {
                                      ResponsiveHelper.isMobile(context)
                                          ? Get.bottomSheet(
                                              ProductBottomSheetWidget(
                                                  product: reviewController
                                                          .reviewedProductList![
                                                      index],
                                                  isCampaign: false),
                                              backgroundColor:
                                                  Colors.transparent,
                                              isScrollControlled: true,
                                            )
                                          : Get.dialog(
                                              Dialog(
                                                  child: ProductBottomSheetWidget(
                                                      product: reviewController
                                                              .reviewedProductList![
                                                          index],
                                                      isCampaign: false)),
                                            );
                                    },
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Image.asset(
                                          imagePath,
                                          fit: BoxFit.cover,
                                        ),

                                        ///free delivery///

                                        Positioned(
                                          top: -20,
                                          bottom: 0,
                                          right: 0,
                                          left: -10,
                                          child: Center(
                                            child: Image.network(
                                                height: 120,
                                                width: 120,
                                                '${Get.find<SplashController>().configModel?.baseUrls?.productImageUrl}'
                                                '/${reviewController.reviewedProductList![index].image.toString()}'),
                                          ),
                                        ),

                                        Positioned(
                                          bottom: 50,
                                          right: 10,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .baseline,
                                                    textBaseline:
                                                        TextBaseline.alphabetic,
                                                    // crossAxisAlignment:
                                                    // CrossAxisAlignment
                                                    //     .end,
                                                    children: [
                                                      Text(
                                                        "₹ ",
                                                        style: TextStyle(
                                                            color: textColor),
                                                      ),
                                                      Text(
                                                        (reviewController.reviewedProductList![index].discountType=='percent'
                                                            ?percentSum2
                                                            :sum).round().toString(),
                                                        style: TextStyle(
                                                            color: textColor,
                                                            fontSize: Dimensions
                                                                .fontSizeExtraLarge),
                                                      ),
                                                    ],
                                                  ),
                                                 ( index == 1|| reviewController.reviewedProductList![index].discount==0)?const SizedBox():       Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .baseline,
                                                    textBaseline:
                                                        TextBaseline.alphabetic,
                                                    // crossAxisAlignment:
                                                    // CrossAxisAlignment
                                                    //     .end,
                                                    children: [
                                                      Text(
                                                        "₹ ",
                                                        style: TextStyle(
                                                          color: textColor2,
                                                          fontSize: Dimensions
                                                              .fontSizeSmall,
                                                        ),
                                                      ),
                                                      Text(
                                                        reviewController
                                                            .reviewedProductList![
                                                                index]
                                                            .price!
                                                            .round()
                                                            .toString(),
                                                        style: TextStyle(
                                                            color: textColor2,
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough,
                                                            decorationColor:
                                                                textColor2,
                                                            fontSize: Dimensions
                                                                .fontSizeDefault),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),

                                        Positioned(
                                          bottom: 10,
                                          left: 10,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 100,
                                                child: Text(
                                                  reviewController
                                                      .reviewedProductList![
                                                          index]
                                                      .restaurantName!,
                                                  softWrap: true,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: textColor),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 100,
                                                child: Text(
                                                  "${reviewController.reviewedProductList![index].deliveryTime} delivery",
                                                  softWrap: true,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: textColor),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  // Text(
                                                  //   reviewController
                                                  //       .reviewedProductList![index].,
                                                  //   style:
                                                  //   TextStyle(
                                                  //     color: Get
                                                  //         .theme
                                                  //         .cardColor,
                                                  //   ),
                                                  // ),
                                                  RatingBar(unSeletedStar: starColor,
                                                    rating: reviewController
                                                        .reviewedProductList![
                                                            index]
                                                        .avgRating,
                                                    starColor: starColor,
                                                    ratingCount: reviewController
                                                        .reviewedProductList![
                                                            index]
                                                        .ratingCount,
                                                    size: 14,
                                                  )

                                                  //
                                                  // RatingBar(
                                                  //   emptyColor: starColor,
                                                  //   size: 15,
                                                  //   filledIcon:
                                                  //   Icons
                                                  //       .star,                                                    emptyIcon: Icons
                                                  //       .star_border,
                                                  //   onRatingChanged:
                                                  //       (value) =>
                                                  //       debugPrint('$value'),
                                                  //   initialRating: reviewController.reviewedProductList![index]
                                                  //       .ratingCount!
                                                  //       .toDouble(),
                                                  //   maxRating:
                                                  //   5,
                                                  // ),
                                                  //
                                                  // Text(
                                                  //   "(${reviewController.reviewedProductList![index].ratingCount})",
                                                  //   style: const TextStyle(
                                                  //       color: Colors
                                                  //           .orange),
                                                  // ),
                                                ],
                                              ),

                                              // RatingBarIndicator(
                                              //   rating: double.parse(
                                              //       "0.0"),
                                              //   itemBuilder: (context,
                                              //           index) =>
                                              //       const Icon(
                                              //     Icons.star,
                                              //     color: Colors.amber,
                                              //   ),
                                              //   itemCount: int.parse(
                                              //       campaignController
                                              //           .itemCampaignList![
                                              //               index]
                                              //           .avgRating
                                              //           .toString()),
                                              //   itemSize: 20.0,
                                              //   direction:
                                              //       Axis.horizontal,
                                              // ),
                                            ],
                                          ),
                                        ),

                                        Positioned(
                                          top: Dimensions
                                              .paddingSizeDefault,
                                          left: 10,
                                          child: SizedBox(
                                            width: 100,
                                            child: Text(
                                              maxLines: 2,
                                              reviewController
                                                  .reviewedProductList![index]
                                                  .name!,
                                              softWrap: true,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize:
                                                      Dimensions.fontSizeLarge,
                                                  fontWeight: FontWeight.w600,
                                                  color: textColor),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: reviewController
                                                      .reviewedProductList![
                                                          index]
                                                      .discount ==
                                                  0
                                              ? Dimensions.paddingSizeSmall
                                              : 40,
                                          right: Dimensions.paddingSizeSmall,
                                          child:
                                              GetBuilder<FavouriteController>(
                                                  builder:
                                                      (favouriteController) {
                                            bool isWished = favouriteController
                                                .wishRestIdList
                                                .contains(reviewController
                                                    .reviewedProductList![index]
                                                    .id);
                                            return CustomFavouriteWidget(
                                              isWished: favouriteController
                                                  .wishProductIdList
                                                  .contains(reviewController
                                                      .reviewedProductList![
                                                          index]
                                                      .id),
                                              product: reviewController
                                                  .reviewedProductList![index],
                                              isRestaurant: false,
                                            );
                                          }),
                                        ),

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
                                        //             padding: const EdgeInsets
                                        //                 .symmetric(
                                        //                 horizontal: 8,
                                        //                 vertical: 5),
                                        //             decoration: BoxDecoration(
                                        //               color: Get
                                        //                   .theme.primaryColor,
                                        //               borderRadius:
                                        //                   BorderRadius.circular(
                                        //                       Dimensions
                                        //                           .radiusSmall),
                                        //             ),
                                        //             child: Row(
                                        //               mainAxisAlignment:
                                        //                   MainAxisAlignment
                                        //                       .center,
                                        //               children: [
                                        //                 Image.asset(
                                        //                   Images.offer,
                                        //                   height: 15,
                                        //                 ),
                                        //                 const SizedBox(
                                        //                     width: 5),
                                        //                 Text(
                                        //                   "Free Delivery",
                                        //                   style: TextStyle(
                                        //                     fontWeight:
                                        //                         FontWeight.w500,
                                        //                     fontSize: Dimensions
                                        //                         .fontSizeExtraSmall,
                                        //                     color: Get.theme
                                        //                         .cardColor,
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
                                        reviewController
                                                    .reviewedProductList![index]
                                                    .discount !=
                                                0
                                            ? Positioned(
                                                top: -20,
                                                right: -15,
                                                child: StreamBuilder<Object>(
                                                  stream: null,
                                                  builder: (context, snapshot) {
                                                    return Stack(
                                                      children: [
                                                        Image.asset(
                                                          Images.offer50,
                                                          height: 55,
                                                        ),
                                                        Positioned.fill(
                                                            top: 0,
                                                            bottom: 0,
                                                            child: Center(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  (reviewController
                                                                              .reviewedProductList![index]
                                                                              .discountType ==
                                                                          'percent')
                                                                      ? Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Text(
                                                                              '${reviewController.reviewedProductList![index].discount!.round()}',
                                                                              style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).cardColor, fontWeight: FontWeight.bold),
                                                                            ),
                                                                            Text(
                                                                              "%",
                                                                              style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).cardColor, fontWeight: FontWeight.bold),
                                                                            )
                                                                          ],
                                                                        )
                                                                      : Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.baseline,
                                                                          textBaseline:
                                                                              TextBaseline.alphabetic,
                                                                          children: [
                                                                            Text(
                                                                              '₹',
                                                                              style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).cardColor, fontWeight: FontWeight.bold),
                                                                            ),
                                                                            Text(
                                                                              '${reviewController.reviewedProductList![index].discount!.round()}',
                                                                              style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).cardColor, fontWeight: FontWeight.bold),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                  Text(
                                                                    style: TextStyle(
                                                                        color: Get
                                                                            .theme
                                                                            .cardColor,
                                                                        fontSize:
                                                                            Dimensions.fontSizeExtraSmall),
                                                                    'off',
                                                                  )
                                                                ],
                                                              ),
                                                            )),
                                                      ],
                                                    );
                                                  },
                                                ),
                                              )
                                            : const SizedBox(),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              reviewController.reviewedProductList!.length >= 8
                                  ? Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () => Get.toNamed(
                                        RouteHelper.getPopularFoodRoute(
                                            isPopular)),
                                    child: Container(
                                      width: 185,
                                      decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                          BorderRadius.circular(
                                              Dimensions
                                                  .radiusDefault)),
                                      alignment: Alignment.center,
                                       padding: const EdgeInsets.all(6.0),
                                      margin: const EdgeInsets.only(
                                          right: 10.0),
                                      child: Text(
                                        'View all',
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: Get.theme.cardColor,
                                        ),
                                      ),
                                    ),
                                  ))
                                  : SizedBox()
                            ],
                          )
                        : const ItemCardShimmer(isPopularNearbyItem: false),
                  ],
                ),
              ),
            );
    });
  }
}

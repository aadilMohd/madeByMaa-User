import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:stackfood_multivendor/features/restaurant/controllers/super_category_controller.dart';
import 'package:universal_html/html.dart' as html;
import 'package:share_plus/share_plus.dart';
import 'package:stackfood_multivendor/corner_banner/rating_bar.dart';
import 'package:stackfood_multivendor/features/cart/controllers/cart_controller.dart';
import 'package:stackfood_multivendor/features/coupon/controllers/coupon_controller.dart';
import 'package:stackfood_multivendor/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor/common/models/restaurant_model.dart';
import 'package:stackfood_multivendor/features/category/controllers/category_controller.dart';
import 'package:stackfood_multivendor/features/restaurant/widgets/restaurant_screen_shimmer_widget.dart';
import 'package:stackfood_multivendor/helper/date_converter.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/bottom_cart_widget.dart';
import 'package:stackfood_multivendor/common/widgets/paginated_list_view_widget.dart';
import 'package:stackfood_multivendor/common/widgets/product_view_widget.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common/widgets/custom_favourite_widget.dart';
import '../../../common/widgets/custom_snackbar_widget.dart';
import '../../../util/app_constants.dart';
import '../../favourite/controllers/favourite_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../splash/controllers/splash_controller.dart';

class RestaurantScreen extends StatefulWidget {
  final Restaurant? restaurant;
  final String slug;
  final String? ownerNAme;

  const RestaurantScreen(
      {super.key, required this.restaurant, this.slug = '', this.ownerNAme});

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  final ScrollController scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  String selectedButton = 'all';

  int _currentIndexPage = 0;

  final _controller = PageController();
  int? selectedSuperCategoryId;
  String? selectedSuperCategoryName;

  @override
  void initState() {
    print("---====---=${widget.restaurant!.ownerName}");
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<SuperCategoryController>().getSuperCategory();
      // Get.find<SuperCategoryController>().getFoodAndCategory(
      //     categoryId: "",
      //     int.parse(currentCategoryId[0].toString()),
      //     widget.restaurant!.id!,
      //     1);
      Get.find<SuperCategoryController>().getFoodAndCategory(
        int.parse(currentCategoryId[0].toString()),
        widget.restaurant!.id!,
        1,
        categoryId: "",
      );
    });

    _searchController.addListener(() {
      setState(() {});
    });
    _initDataCall();
    updateCurrentCategories();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      updateCurrentCategories();
    });

    print("-0-0-0$currentCategoryId");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Get.find<SuperCategoryController>().getFoodAndCategory(
      //     categoryId: "",
      //     widget.restaurant!.id!,
      //     int.parse(currentCategoryId[0].toString()),
      //     1);

      Get.find<SuperCategoryController>().getFoodAndCategory(
        int.parse(currentCategoryId[0].toString()),
        widget.restaurant!.id!,
        1,
        categoryId: "",
      );
    });

    selectedSuperCategoryId = currentCategoryId[0];
    selectedSuperCategoryName = currentCategoryNames[0];
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();

    scrollController.dispose();
    currentCategoryId.clear();
    selectedSuperCategoryId = null;
    selectedSuperCategoryName = null;
  }

  Future<void> _initDataCall() async {
    if (Get.find<RestaurantController>().isSearching) {
      Get.find<RestaurantController>().changeSearchStatus(isUpdate: false);
    }
    await Get.find<RestaurantController>().getRestaurantDetails(
        Restaurant(id: widget.restaurant!.id),
        slug: widget.slug);
    if (Get.find<CategoryController>().categoryList == null) {
      Get.find<CategoryController>().getCategoryList(true);
    }
    Get.find<CouponController>().getRestaurantCouponList(
        restaurantId: widget.restaurant!.id ??
            Get.find<RestaurantController>().restaurant!.id!);
    Get.find<RestaurantController>().getRestaurantRecommendedItemList(
        widget.restaurant!.id ??
            Get.find<RestaurantController>().restaurant!.id!,
        false);
    Get.find<RestaurantController>().getRestaurantProductList(
        widget.restaurant!.id ??
            Get.find<RestaurantController>().restaurant!.id!,
        Get.find<RestaurantController>().foodOffset,
        'all',
        false);

    print("ppppp=p=p=p=p=p=p${Get.find<RestaurantController>().foodOffset}");
  }

  Future<void> loadData(bool reload) async {
    Get.find<RestaurantController>().categoryIndex1(-2);

    Get.find<RestaurantController>().getRestaurantProductList(
        widget.restaurant!.id ??
            Get.find<RestaurantController>().restaurant!.id!,
        1,
        'popular',
        false);
  }

  List<String> currentCategoryNames = [];
  List<int> currentCategoryId = [];
  void updateCurrentCategories() {
    DateTime currentTime = DateTime.now(); // ✅ no need to re-parse

    List<String> matches = [];
    List<int> matches2 = [];
    int? currentIndex; // store the index of the first matching category

    final categories = Get.find<SuperCategoryController>().getSuperCategoryList;

    for (int i = 0; i < categories.length; i++) {
      var category = categories[i];

      DateTime start =
          DateFormat("yyyy-MM-dd HH:mm:ss").parse(category.startTime!);
      DateTime end = DateFormat("yyyy-MM-dd HH:mm:ss").parse(category.endTime!);

      if (currentTime.isAfter(start) && currentTime.isBefore(end)) {
        matches.add(category.name!);
        matches2.add(int.parse(category.id.toString()));

        // Save the index of the first matching category
        currentIndex ??= i;
      }
    }

    setState(() {
      currentCategoryNames = matches;
      currentCategoryId = matches2;
      // currentCategoryIndex = currentIndex; // you can use this in your UI
    });
  }

  // void updateCurrentCategories() {
  //   DateTime now = DateTime.now();
  //   String currentTimeStr = DateFormat.Hms().format(now);
  //   DateTime currentTime = DateFormat.Hms().parse(currentTimeStr);
  //
  //   List<String> matches = [];
  //   List<int> matches2 = [];
  //
  //   for (var category
  //       in Get.find<SuperCategoryController>().getSuperCategoryList) {
  //     // DateTime start = DateFormat.Hms().parse(category.startTime!);
  //     // DateTime end = DateFormat.Hms().parse(category.endTime!);
  //
  //     DateTime start =
  //         DateFormat("yyyy-MM-dd HH:mm:ss").parse(category.startTime!);
  //     DateTime end = DateFormat("yyyy-MM-dd HH:mm:ss").parse(category.endTime!);
  //
  //     if (currentTime.isAfter(start) && currentTime.isBefore(end)) {
  //       matches.add(category.name!);
  //       matches2.add(int.parse(category.id.toString()));
  //     }
  //   }
  //
  //   setState(() {
  //     currentCategoryNames = matches;
  //     currentCategoryId = matches2;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = ResponsiveHelper.isDesktop(context);
    return Scaffold(
        // appBar: isDesktop ? const WebMenuBar() : null,
        //   endDrawer: const MenuDrawerWidget(), endDrawerEnableOpenDragGesture: false,
        //   // backgroundColor: Colors.red,
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: const Color(0xffFFEACC),
        ),
        body: GetBuilder<RestaurantController>(builder: (restController) {
          return GetBuilder<SuperCategoryController>(
            builder: (superCategoryController) {
              return GetBuilder<CouponController>(builder: (couponController) {
                return GetBuilder<CategoryController>(
                    builder: (categoryController) {
                  final Map<String, int> categoryMap = {
                    for (var item
                        in superCategoryController.getSuperCategoryList)
                      item.name!: item.id!
                  };
                  Restaurant? restaurant;
                  if (restController.restaurant != null &&
                      restController.restaurant!.name != null &&
                      categoryController.categoryList != null) {
                    restaurant = restController.restaurant;
                  }
                  restController.setCategoryList();
                  bool hasCoupon = (couponController.couponList != null &&
                      couponController.couponList!.isNotEmpty);

                  return (restController.restaurant != null &&
                          restController.restaurant!.name != null &&
                          categoryController.categoryList != null)
                      ? ListView(
                          children: [
                            Container(
                                padding: const EdgeInsets.only(
                                    top: Dimensions.paddingSizeSmall,
                                    left: Dimensions.paddingSizeSmall,
                                    right: Dimensions.paddingSizeSmall2,
                                    bottom:
                                        Dimensions.paddingSizeExtraOverLarge),
                                decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                      Color(0xffFFEACC),
                                      Colors.white
                                    ])),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        icon: const Icon(
                                            Icons.arrow_back_outlined)),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Chef: ${restaurant!.ownerName!}",
                                            style: const TextStyle(
                                                color: Color(0xff7E7E7E)),
                                          ),
                                          const SizedBox(
                                            height: Dimensions.paddingSizeSmall,
                                          ),
                                          Text(
                                            restaurant.name!,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize:
                                                    Dimensions.fontSizeLarge,
                                                letterSpacing: 1),
                                          ),
                                          const SizedBox(
                                            height: Dimensions.paddingSizeSmall,
                                          ),
                                          SizedBox(
                                            height: 20,

                                            // width: restaurant.cuisineNames!.length == 1
                                            //     ? 50
                                            //     : restaurant.cuisineNames!.length == 2
                                            //     ? 180
                                            //     : Get.width,

                                            child: Align(
                                              alignment: Alignment.center,
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    const AlwaysScrollableScrollPhysics(),
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: restaurant
                                                    .cuisineNames!.length,
                                                itemBuilder: (context, index) {
                                                  return Row(
                                                    children: [
                                                      Text(
                                                        restaurant!
                                                            .cuisineNames![
                                                                index]
                                                            .name!,
                                                        style: TextStyle(
                                                            fontSize: Dimensions
                                                                .fontSizeSmall,
                                                            color: const Color(
                                                                0xff524A61)),
                                                      ),
                                                      if (index !=
                                                          restaurant
                                                                  .cuisineNames!
                                                                  .length -
                                                              1)
                                                        const Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      8.0),
                                                          child: Icon(
                                                            Icons
                                                                .circle_rounded,
                                                            size: 5,
                                                          ),
                                                        )
                                                    ],
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: Dimensions.paddingSizeSmall,
                                          ),
                                          SizedBox(
                                            width: 150,
                                            child: CarouselSlider(
                                              items: [
                                                RatingBar(
                                                  starColor:
                                                      Get.theme.primaryColor,
                                                  rating: restaurant.avgRating,
                                                  ratingCount:
                                                      restaurant.ratingCount,
                                                  size: 15,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "min order ",
                                                      style: TextStyle(
                                                          color: Get
                                                              .theme.hintColor,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: Dimensions
                                                              .fontSizeSmall),
                                                    ),
                                                    Text(
                                                      "₹ ${restaurant.minimumOrder}",
                                                      style: TextStyle(
                                                          color: Get.theme
                                                              .primaryColor,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                              options: CarouselOptions(
                                                autoPlay: true,
                                                autoPlayInterval:
                                                    const Duration(seconds: 3),
                                                autoPlayAnimationDuration:
                                                    const Duration(
                                                        milliseconds: 800),
                                                height: 30,
                                                enableInfiniteScroll: true,
                                                scrollPhysics:
                                                    const NeverScrollableScrollPhysics(),
                                                viewportFraction: 1.0,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        GetBuilder<FavouriteController>(
                                            builder: (favouriteController) {
                                          bool isWished = favouriteController
                                              .wishRestIdList
                                              .contains(restaurant!.id);
                                          return CustomFavouriteWidget(
                                            restra: true,
                                            isWished: isWished,
                                            isRestaurant: true,
                                            restaurant: restaurant,
                                            size: 24,
                                          );
                                        }),
                                        const SizedBox(
                                          height: Dimensions.paddingSizeSmall,
                                        ),
                                        // InkWell(
                                        //   onTap: () {
                                        //     if (isDesktop) {
                                        //       String? hostname =
                                        //           html.window.location.hostname;
                                        //       String protocol =
                                        //           html.window.location.protocol;
                                        //       String shareUrl =
                                        //           '$protocol//$hostname${restController.filteringUrl(restaurant!.slug ?? '')}';
                                        //
                                        //       Clipboard.setData(ClipboardData(
                                        //           text: shareUrl));
                                        //       showCustomSnackBar(
                                        //           'restaurant_url_copied'.tr,
                                        //           isError: false);
                                        //     } else {
                                        //       String shareUrl =
                                        //           "https://play.google.com/store/apps/details?id=com.madebymaa.food";
                                        //       // '${AppConstants.baseUrl}${restController.filteringUrl(restaurant!.slug ?? '')}';
                                        //       Share.share(shareUrl);
                                        //     }
                                        //   },
                                        //   child: const Icon(
                                        //     Icons.share,
                                        //     size: 20,
                                        //   ),
                                        // ),
                                        InkWell(
                                          onTap: () {
                                            if (isDesktop) {
                                              String? hostname =
                                                  html.window.location.hostname;
                                              String protocol =
                                                  html.window.location.protocol;
                                              String shareUrl =
                                                  '$protocol//$hostname${restController.filteringUrl(restaurant!.slug ?? '')}';

                                              // 👇 Open link in a new tab
                                              html.window
                                                  .open(shareUrl, '_blank');
                                            } else {
                                              String shareUrl =
                                                  "https://play.google.com/store/apps/details?id=com.madebymaa.food&pcampaignid=web_share";
                                              Share.share(shareUrl);
                                            }
                                          },
                                          child: const Icon(
                                            Icons.share,
                                            size: 20,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                )),

                            ///old code///
                            // couponController.couponList!.isEmpty
                            //     ? const SizedBox()
                            //     : Padding(
                            //         padding:
                            //             const EdgeInsets.symmetric(horizontal: 8.0),
                            //         child: SizedBox(
                            //           height: isDesktop ? 110 : 85,
                            //           width: double.infinity,
                            //           child: CarouselSlider.builder(
                            //             options: CarouselOptions(
                            //               autoPlay: true,
                            //               enlargeCenterPage: true,
                            //               disableCenter: true,
                            //               viewportFraction: 1,
                            //               autoPlayInterval:
                            //                   const Duration(seconds: 7),
                            //               onPageChanged: (index, reason) {
                            //                 couponController.setCurrentIndex(
                            //                     index, true);
                            //               },
                            //             ),
                            //             itemCount:
                            //                 couponController.couponList!.length,
                            //             itemBuilder: (context, index, _) {
                            //               return couponController
                            //                       .couponList!.isEmpty
                            //                   ? const SizedBox()
                            //                   : Container(
                            //                       decoration: BoxDecoration(
                            //                         borderRadius:
                            //                             BorderRadius.circular(
                            //                                 Dimensions
                            //                                     .radiusExtraLarge),
                            //                         color: Theme.of(context)
                            //                             .primaryColor
                            //                             .withOpacity(0.07),
                            //                       ),
                            //                       padding: const EdgeInsets.all(
                            //                           Dimensions.paddingSizeSmall),
                            //                       margin: const EdgeInsets.only(
                            //                           right: Dimensions
                            //                               .paddingSizeDefault),
                            //                       child: Row(children: [
                            //                         Expanded(
                            //                             child: Column(
                            //                                 crossAxisAlignment:
                            //                                     CrossAxisAlignment
                            //                                         .start,
                            //                                 mainAxisAlignment:
                            //                                     MainAxisAlignment
                            //                                         .center,
                            //                                 children: [
                            //                               Row(children: [
                            //                                 Flexible(
                            //                                   child: Text(
                            //                                     '"${couponController.couponList![index].title!}"',
                            //                                     maxLines: 1,
                            //                                     style: robotoMedium.copyWith(
                            //                                         fontSize: Dimensions
                            //                                             .fontSizeDefault,
                            //                                         overflow:
                            //                                             TextOverflow
                            //                                                 .ellipsis,
                            //                                         color: Theme.of(
                            //                                                 context)
                            //                                             .textTheme
                            //                                             .bodyLarge!
                            //                                             .color),
                            //                                   ),
                            //                                 ),
                            //                                 InkWell(
                            //                                   onTap: () {
                            //                                     Clipboard.setData(
                            //                                         ClipboardData(
                            //                                             text: couponController
                            //                                                 .couponList![
                            //                                                     index]
                            //                                                 .code!));
                            //                                     showCustomSnackBar(
                            //                                         'coupon_code_copied'
                            //                                             .tr,
                            //                                         isError: false);
                            //                                   },
                            //                                   child: Icon(
                            //                                       Icons
                            //                                           .copy_rounded,
                            //                                       size: 16,
                            //                                       color: Theme.of(
                            //                                               context)
                            //                                           .primaryColor),
                            //                                 ),
                            //                               ]),
                            //                               const SizedBox(
                            //                                   height: Dimensions
                            //                                       .paddingSizeExtraSmall),
                            //                               Text(
                            //                                 '${DateConverter.stringToReadableString(couponController.couponList![index].startDate!)} ${'to'.tr} ${DateConverter.stringToReadableString(couponController.couponList![index].expireDate!)}',
                            //                                 style: robotoMedium.copyWith(
                            //                                     color: Theme.of(
                            //                                             context)
                            //                                         .disabledColor,
                            //                                     fontSize: Dimensions
                            //                                         .fontSizeExtraSmall),
                            //                                 maxLines: 2,
                            //                                 overflow: TextOverflow
                            //                                     .ellipsis,
                            //                               ),
                            //                               Row(children: [
                            //                                 Text(
                            //                                   '${'min_purchase'.tr} ',
                            //                                   style: robotoRegular.copyWith(
                            //                                       color: Theme.of(
                            //                                               context)
                            //                                           .disabledColor,
                            //                                       fontSize: Dimensions
                            //                                           .fontSizeSmall),
                            //                                   maxLines: 1,
                            //                                   overflow: TextOverflow
                            //                                       .ellipsis,
                            //                                 ),
                            //                                 const SizedBox(
                            //                                     width: Dimensions
                            //                                         .paddingSizeExtraSmall),
                            //                                 Text(
                            //                                   PriceConverter.convertPrice(
                            //                                       couponController
                            //                                           .couponList![
                            //                                               index]
                            //                                           .minPurchase),
                            //                                   style: robotoMedium.copyWith(
                            //                                       color: Theme.of(
                            //                                               context)
                            //                                           .disabledColor,
                            //                                       fontSize: Dimensions
                            //                                           .fontSizeSmall),
                            //                                   maxLines: 1,
                            //                                   overflow: TextOverflow
                            //                                       .ellipsis,
                            //                                   textDirection:
                            //                                       TextDirection.ltr,
                            //                                 ),
                            //                               ]),
                            //                             ])),
                            //                         Image.asset(
                            //                             Images.restaurantCoupon,
                            //                             height: 55,
                            //                             width: 55),
                            //                       ]),
                            //                     );
                            //             },
                            //           ),
                            //         ),
                            //       ),

                            /// New code //
                            // couponController.couponList!.isEmpty
                            //     ? const SizedBox()
                            //     : Padding(
                            //         padding:
                            //             const EdgeInsets.symmetric(horizontal: 8.0),
                            //         child: SizedBox(
                            //           height: isDesktop ? 110 : 85,
                            //           width: 300,
                            //           child: ListView.builder(
                            //             scrollDirection: Axis.horizontal,
                            //             physics: const ScrollPhysics(),
                            //             shrinkWrap: true,
                            //             itemCount:
                            //                 couponController.couponList!.length,
                            //             itemBuilder: (context, index) {
                            //               return couponController
                            //                       .couponList!.isEmpty
                            //                   ? const SizedBox()
                            //                   : Padding(
                            //                       padding: const EdgeInsets.only(
                            //                           right: 10.0),
                            //                       child: SizedBox(
                            //                         height: 50,
                            //                         width: 330,
                            //                         child: Row(
                            //                           children: [
                            //                             Stack(
                            //                               children: [
                            //                                 Container(
                            //                                   padding: const EdgeInsets
                            //                                       .symmetric(
                            //                                       horizontal: Dimensions
                            //                                           .paddingSizeExtraSmall),
                            //                                   width: 58,
                            //                                   height: 80,
                            //                                   decoration: BoxDecoration(
                            //                                       color: const Color(
                            //                                           0xffFFAE3D),
                            //                                       borderRadius:
                            //                                           BorderRadius.circular(
                            //                                               Dimensions
                            //                                                   .radiusLarge)),
                            //                                   child: Column(
                            //                                     crossAxisAlignment:
                            //                                         CrossAxisAlignment
                            //                                             .start,
                            //                                     mainAxisAlignment:
                            //                                         MainAxisAlignment
                            //                                             .center,
                            //                                     children: [
                            //                                       Text(
                            //                                         "Flat",
                            //                                         style: TextStyle(
                            //                                             color: Get
                            //                                                 .theme
                            //                                                 .cardColor,
                            //                                             fontSize:
                            //                                                 Dimensions
                            //                                                     .fontSizeExtraSmall),
                            //                                       ),
                            //                                       (couponController
                            //                                                   .couponList![
                            //                                                       index]
                            //                                                   .discountType ==
                            //                                               'percent')
                            //                                           ? Text(
                            //                                               '${couponController.couponList![index].discount} %',
                            //                                               style: robotoBold.copyWith(
                            //                                                   fontSize: Dimensions
                            //                                                       .fontSizeSmall,
                            //                                                   color: Theme.of(context)
                            //                                                       .cardColor,
                            //                                                   fontWeight:
                            //                                                       FontWeight.bold),
                            //                                             )
                            //                                           : Row(
                            //                                               crossAxisAlignment:
                            //                                                   CrossAxisAlignment
                            //                                                       .end,
                            //                                               children: [
                            //                                                 Text(
                            //                                                   '${Get.find<SplashController>().configModel!.currencySymbol} ',
                            //                                                   style: robotoBold.copyWith(
                            //                                                       fontSize: Dimensions.fontSizeExtraSmall,
                            //                                                       color: Theme.of(context).cardColor,
                            //                                                       fontWeight: FontWeight.bold),
                            //                                                 ),
                            //                                                 Text(
                            //                                                   '${couponController.couponList![index].discount}',
                            //                                                   style: robotoBold.copyWith(
                            //                                                       fontSize: Dimensions.fontSizeSmall,
                            //                                                       color: Theme.of(context).cardColor,
                            //                                                       fontWeight: FontWeight.bold),
                            //                                                 ),
                            //                                               ],
                            //                                             ),
                            //                                       Align(
                            //                                         alignment: Alignment
                            //                                             .centerRight,
                            //                                         child: Text(
                            //                                           style: TextStyle(
                            //                                               color: Get
                            //                                                   .theme
                            //                                                   .cardColor),
                            //                                           ' OFF',
                            //                                           textAlign:
                            //                                               TextAlign
                            //                                                   .end,
                            //                                         ),
                            //                                       )
                            //                                     ],
                            //                                   ),
                            //                                 ),
                            //                                 Positioned(
                            //                                   right: -12,
                            //                                   top: -12,
                            //                                   child: Container(
                            //                                     height: 25,
                            //                                     width: 25,
                            //                                     decoration: BoxDecoration(
                            //                                         shape: BoxShape
                            //                                             .circle,
                            //                                         color: Get.theme
                            //                                             .cardColor),
                            //                                   ),
                            //                                 ),
                            //                                 Positioned(
                            //                                   right: -12,
                            //                                   bottom: -12,
                            //                                   child: Container(
                            //                                     height: 25,
                            //                                     width: 25,
                            //                                     decoration: BoxDecoration(
                            //                                         shape: BoxShape
                            //                                             .circle,
                            //                                         color: Get.theme
                            //                                             .cardColor),
                            //                                   ),
                            //                                 ),
                            //                               ],
                            //                             ),
                            //                             Expanded(
                            //                               child: Container(
                            //                                 padding:
                            //                                     const EdgeInsets
                            //                                         .symmetric(
                            //                                   horizontal: Dimensions
                            //                                       .paddingSizeSmall,
                            //                                   vertical: Dimensions
                            //                                       .paddingSizeExtraSmall,
                            //                                 ),
                            //                                 height: 80,
                            //                                 decoration: BoxDecoration(
                            //                                     color: Colors
                            //                                         .transparent,
                            //                                     borderRadius:
                            //                                         BorderRadius.circular(
                            //                                             Dimensions
                            //                                                 .radiusDefault),
                            //                                     border: Border.all(
                            //                                         color: const Color(
                            //                                             0xff090018))),
                            //                                 child: Column(
                            //                                   crossAxisAlignment:
                            //                                       CrossAxisAlignment
                            //                                           .start,
                            //                                   children: [
                            //                                     Text(
                            //                                       couponController
                            //                                           .couponList![
                            //                                               index]
                            //                                           .title!,
                            //                                       style: TextStyle(
                            //                                           fontWeight:
                            //                                               FontWeight
                            //                                                   .w600,
                            //                                           color: Get
                            //                                               .theme
                            //                                               .primaryColor),
                            //                                     ),
                            //                                     const DottedLine(
                            //                                       direction: Axis
                            //                                           .horizontal,
                            //                                       alignment:
                            //                                           WrapAlignment
                            //                                               .center,
                            //                                       lineLength: double
                            //                                           .infinity,
                            //                                       lineThickness:
                            //                                           1.0,
                            //                                       dashLength: 4.0,
                            //                                       dashColor: Color(
                            //                                           0xffE0E0E0),
                            //                                       // dashGradient: [Colors.red, Colors.blue],
                            //                                       dashRadius: 0.0,
                            //                                       dashGapLength:
                            //                                           4.0,
                            //                                       dashGapColor: Colors
                            //                                           .transparent,
                            //                                       // dashGapGradient: [Colors.red, Colors.blue],
                            //                                       dashGapRadius:
                            //                                           0.0,
                            //                                     ),
                            //                                     Row(
                            //                                       children: [
                            //                                         Expanded(
                            //                                           child: Column(
                            //                                             crossAxisAlignment:
                            //                                                 CrossAxisAlignment
                            //                                                     .start,
                            //                                             children: [
                            //                                               Text(
                            //                                                 '${DateConverter.stringToReadableString(couponController.couponList![index].startDate!)} ${'to'.tr} ${DateConverter.stringToReadableString(couponController.couponList![index].expireDate!)}',
                            //                                                 style: robotoMedium.copyWith(
                            //                                                     color:
                            //                                                         Theme.of(context).disabledColor,
                            //                                                     fontSize: Dimensions.fontSizeExtraSmall),
                            //                                                 maxLines:
                            //                                                     2,
                            //                                                 overflow:
                            //                                                     TextOverflow.ellipsis,
                            //                                               ),
                            //                                               Text(
                            //                                                 '${'min_purchase'.tr} ',
                            //                                                 style: robotoRegular.copyWith(
                            //                                                     color:
                            //                                                         Theme.of(context).disabledColor,
                            //                                                     fontSize: Dimensions.fontSizeExtraSmall),
                            //                                                 maxLines:
                            //                                                     1,
                            //                                                 overflow:
                            //                                                     TextOverflow.ellipsis,
                            //                                               ),
                            //                                             ],
                            //                                           ),
                            //                                         ),
                            //                                         InkWell(
                            //                                           onTap: () {
                            //                                             Clipboard.setData(ClipboardData(
                            //                                                 text: couponController
                            //                                                     .couponList![index]
                            //                                                     .code!));
                            //                                             showCustomSnackBar(
                            //                                                 'coupon_code_copied'
                            //                                                     .tr,
                            //                                                 isError:
                            //                                                     false);
                            //                                           },
                            //                                           child:
                            //                                               Container(
                            //                                             margin: const EdgeInsets
                            //                                                 .only(
                            //                                                 top: Dimensions
                            //                                                     .paddingSizeExtraSmall),
                            //                                             padding:
                            //                                                 const EdgeInsets
                            //                                                     .symmetric(
                            //                                               horizontal:
                            //                                                   Dimensions
                            //                                                       .paddingSizeSmall,
                            //                                               vertical:
                            //                                                   8,
                            //                                             ),
                            //                                             decoration: BoxDecoration(
                            //                                                 color: Colors
                            //                                                     .black,
                            //                                                 borderRadius:
                            //                                                     BorderRadius.circular(Dimensions.radiusDefault)),
                            //                                             child:
                            //                                                 Center(
                            //                                               child:
                            //                                                   Text(
                            //                                                 "Copy Code",
                            //                                                 style: TextStyle(
                            //                                                     color:
                            //                                                         Get.theme.cardColor,
                            //                                                     fontWeight: FontWeight.w600),
                            //                                               ),
                            //                                             ),
                            //                                           ),
                            //                                         )
                            //                                       ],
                            //                                     )
                            //                                   ],
                            //                                 ),
                            //                               ),
                            //                             )
                            //                           ],
                            //                         ),
                            //                       ),
                            //                     );
                            //               // Container(
                            //               //   decoration: BoxDecoration(
                            //               //     borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
                            //               //     color: Theme.of(context).primaryColor.withOpacity(0.07),
                            //               //   ),
                            //               //   padding: const EdgeInsets.all(Dimensions.paddingSizeSmall ),
                            //               //   margin: const EdgeInsets.only(right: Dimensions.paddingSizeDefault),
                            //               //   child: Row(children: [
                            //               //     Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                            //               //
                            //               //       Row(children: [
                            //               //         Flexible(
                            //               //           child: Text(
                            //               //             '"${couponController.couponList![index].title!}"', maxLines: 1,
                            //               //             style: robotoMedium.copyWith(
                            //               //                 fontSize: Dimensions.fontSizeDefault ,
                            //               //                 overflow: TextOverflow.ellipsis,
                            //               //                 color: Theme.of(context).textTheme.bodyLarge!.color),
                            //               //           ),
                            //               //         ),
                            //               //
                            //               //         InkWell(
                            //               //           onTap: () {
                            //               //             Clipboard.setData(ClipboardData(text: couponController.couponList![index].code!));
                            //               //             showCustomSnackBar('coupon_code_copied'.tr, isError: false);
                            //               //           },
                            //               //           child: Icon(Icons.copy_rounded, size: 16 , color: Theme.of(context).primaryColor),
                            //               //         ),
                            //               //       ]),
                            //               //       const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                            //               //
                            //               //       Text(
                            //               //         '${DateConverter.stringToReadableString(couponController.couponList![index].startDate!)} ${'to'.tr} ${DateConverter.stringToReadableString(couponController.couponList![index].expireDate!)}',
                            //               //         style: robotoMedium.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeExtraSmall),
                            //               //         maxLines: 2, overflow: TextOverflow.ellipsis,
                            //               //       ),
                            //               //
                            //               //       Row(children: [
                            //               //         Text(
                            //               //           '${'min_purchase'.tr} ',
                            //               //           style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall ),
                            //               //           maxLines: 1, overflow: TextOverflow.ellipsis,
                            //               //         ),
                            //               //         const SizedBox(width: Dimensions.paddingSizeExtraSmall ),
                            //               //
                            //               //         Text(
                            //               //           PriceConverter.convertPrice(couponController.couponList![index].minPurchase),
                            //               //           style: robotoMedium.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall ),
                            //               //           maxLines: 1, overflow: TextOverflow.ellipsis, textDirection: TextDirection.ltr,
                            //               //         ),
                            //               //       ]),
                            //               //     ])),
                            //               //
                            //               //     Image.asset(Images.restaurantCoupon, height: 55 , width: 55),
                            //               //   ]),
                            //               // );
                            //             },
                            //           ),
                            //         ),
                            //       ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: couponController.couponList!.map((bnr) {
                            //     int index =
                            //         couponController.couponList!.indexOf(bnr);
                            //     return couponController.couponList!.isEmpty
                            //         ? const SizedBox()
                            //         : TabPageSelectorIndicator(
                            //             backgroundColor:
                            //                 index == couponController.currentIndex
                            //                     ? Theme.of(context).primaryColor
                            //                     : Theme.of(context)
                            //                         .primaryColor
                            //                         .withOpacity(0.5),
                            //             borderColor: Theme.of(context)
                            //                 .colorScheme
                            //                 .background,
                            //             size: index == couponController.currentIndex
                            //                 ? 7
                            //                 : 5,
                            //           );
                            //   }).toList(),
                            // ),

                            couponController.couponList!.isEmpty
                                ? const SizedBox()
                                : SizedBox(
                                    height: 120,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 0.0, right: 0),
                                      child: PageView.builder(
                                        controller: _controller,
                                        onPageChanged: (index) {
                                          setState(() {
                                            _currentIndexPage = index;
                                          });
                                        },
                                        physics: const ScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        itemCount:
                                            couponController.couponList!.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20, right: 10.0),
                                            child: SizedBox(
                                              height: 50,
                                              width: 330,
                                              child: Row(
                                                children: [
                                                  Stack(
                                                    children: [
                                                      Container(
                                                        padding: const EdgeInsets
                                                            .symmetric(
                                                            horizontal: Dimensions
                                                                .paddingSizeExtraSmall),
                                                        width: 58,
                                                        height: 80,
                                                        decoration: BoxDecoration(
                                                            color: const Color(
                                                                0xffFFAE3D),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    Dimensions
                                                                        .radiusLarge)),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              "Flat",
                                                              style: TextStyle(
                                                                  color: Get
                                                                      .theme
                                                                      .cardColor,
                                                                  fontSize:
                                                                      Dimensions
                                                                          .fontSizeExtraSmall),
                                                            ),
                                                            (couponController
                                                                        .couponList![
                                                                            index]
                                                                        .discountType ==
                                                                    'percent')
                                                                ? Text(
                                                                    '${couponController.couponList![index].discount} %',
                                                                    style: robotoBold.copyWith(
                                                                        fontSize:
                                                                            Dimensions
                                                                                .fontSizeSmall,
                                                                        color: Theme.of(context)
                                                                            .cardColor,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  )
                                                                : Row(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Text(
                                                                        '${Get.find<SplashController>().configModel!.currencySymbol} ',
                                                                        style: robotoBold.copyWith(
                                                                            fontSize:
                                                                                Dimensions.fontSizeExtraSmall,
                                                                            color: Theme.of(context).cardColor,
                                                                            fontWeight: FontWeight.bold),
                                                                      ),
                                                                      Text(
                                                                        '${couponController.couponList![index].discount}',
                                                                        style: robotoBold.copyWith(
                                                                            fontSize:
                                                                                Dimensions.fontSizeSmall,
                                                                            color: Theme.of(context).cardColor,
                                                                            fontWeight: FontWeight.bold),
                                                                      ),
                                                                    ],
                                                                  ),
                                                            Align(
                                                              alignment: Alignment
                                                                  .centerRight,
                                                              child: Text(
                                                                style: TextStyle(
                                                                    color: Get
                                                                        .theme
                                                                        .cardColor),
                                                                ' OFF',
                                                                textAlign:
                                                                    TextAlign
                                                                        .end,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      Positioned(
                                                        right: -12,
                                                        top: -12,
                                                        child: Container(
                                                          height: 25,
                                                          width: 25,
                                                          decoration:
                                                              BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: Get
                                                                      .theme
                                                                      .cardColor),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        right: -12,
                                                        bottom: -12,
                                                        child: Container(
                                                          height: 25,
                                                          width: 25,
                                                          decoration:
                                                              BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: Get
                                                                      .theme
                                                                      .cardColor),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: Dimensions
                                                            .paddingSizeSmall,
                                                        vertical: Dimensions
                                                            .paddingSizeExtraSmall,
                                                      ),
                                                      height: 80,
                                                      decoration: BoxDecoration(
                                                          color: Colors
                                                              .transparent,
                                                          borderRadius: BorderRadius
                                                              .circular(Dimensions
                                                                  .radiusDefault),
                                                          border: Border.all(
                                                              color: const Color(
                                                                  0xff090018))),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            couponController
                                                                .couponList![
                                                                    index]
                                                                .title!,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Get.theme
                                                                    .primaryColor),
                                                          ),
                                                          const DottedLine(
                                                            direction:
                                                                Axis.horizontal,
                                                            alignment:
                                                                WrapAlignment
                                                                    .center,
                                                            lineLength:
                                                                double.infinity,
                                                            lineThickness: 1.0,
                                                            dashLength: 4.0,
                                                            dashColor: Color(
                                                                0xffE0E0E0),
                                                            // dashGradient: [Colors.red, Colors.blue],
                                                            dashRadius: 0.0,
                                                            dashGapLength: 4.0,
                                                            dashGapColor: Colors
                                                                .transparent,
                                                            // dashGapGradient: [Colors.red, Colors.blue],
                                                            dashGapRadius: 0.0,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      '${DateConverter.stringToReadableString(couponController.couponList![index].startDate!)} ${'to'.tr} ${DateConverter.stringToReadableString(couponController.couponList![index].expireDate!)}',
                                                                      style: robotoMedium.copyWith(
                                                                          color: Theme.of(context)
                                                                              .disabledColor,
                                                                          fontSize:
                                                                              Dimensions.fontSizeExtraSmall),
                                                                      maxLines:
                                                                          2,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                    Text(
                                                                      '${'min_purchase'.tr} ',
                                                                      style: robotoRegular.copyWith(
                                                                          color: Theme.of(context)
                                                                              .disabledColor,
                                                                          fontSize:
                                                                              Dimensions.fontSizeExtraSmall),
                                                                      maxLines:
                                                                          1,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              InkWell(
                                                                onTap: () {
                                                                  Clipboard.setData(ClipboardData(
                                                                      text: couponController
                                                                          .couponList![
                                                                              index]
                                                                          .code!));
                                                                  showCustomSnackBar(
                                                                      'coupon_code_copied'
                                                                          .tr,
                                                                      isError:
                                                                          false);
                                                                },
                                                                child:
                                                                    Container(
                                                                  margin: const EdgeInsets
                                                                      .only(
                                                                      top: Dimensions
                                                                          .paddingSizeExtraSmall),
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .symmetric(
                                                                    horizontal:
                                                                        Dimensions
                                                                            .paddingSizeSmall,
                                                                    vertical: 8,
                                                                  ),
                                                                  decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .black,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              Dimensions.radiusDefault)),
                                                                  child: Center(
                                                                    child: Text(
                                                                      "Copy Code",
                                                                      style: TextStyle(
                                                                          color: Get
                                                                              .theme
                                                                              .cardColor,
                                                                          fontSize: Dimensions
                                                                              .fontSizeSmall,
                                                                          fontWeight:
                                                                              FontWeight.w600),
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),

                            couponController.couponList!.isEmpty
                                ? const SizedBox()
                                : Center(
                                    child: DotsIndicator(
                                      dotsCount:
                                          couponController.couponList!.length,
                                      position: _currentIndexPage,
                                      decorator: DotsDecorator(
                                        color: const Color(0xffE0E0E0),
                                        spacing: const EdgeInsets.symmetric(
                                            horizontal: 3.0),
                                        activeColor: Get.theme.hintColor,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        size: const Size(4.0, 4.0),
                                        activeSize: const Size(6.0, 6.0),
                                        activeShape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                      ),
                                    ),
                                  ),

                            const SizedBox(
                              height: Dimensions.paddingSizeSmall,
                            ),
                            Container(
                              height: 50,
                              padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingSizeDefault,
                                // vertical: Dimensions.paddingSizeSmall
                              ),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.paddingSizeDefault),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radiusDefault),
                                  border: Border.all(
                                      color: Get.theme.primaryColor
                                          .withOpacity(0.4),
                                      width: 0.8)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Mom Chef Offers in ",
                                          style: TextStyle(
                                            color: const Color(0xff524A61),
                                            fontSize: Dimensions.fontSizeSmall,
                                          ),
                                        ),
                                        if (restaurant.veg == 1)
                                          TextSpan(
                                            text: "Veg ",
                                            style: TextStyle(
                                              color: Colors.green,
                                              fontSize:
                                                  Dimensions.fontSizeSmall,
                                            ),
                                          ),
                                        if (restaurant.veg == 1 &&
                                            restaurant.nonVeg == 1)
                                          TextSpan(
                                            text: "& ",
                                            style: TextStyle(
                                              color: const Color(0xff524A61),
                                              fontSize:
                                                  Dimensions.fontSizeSmall,
                                            ),
                                          ),
                                        if (restaurant.nonVeg == 1)
                                          TextSpan(
                                            text: "Non-Veg ",
                                            style: TextStyle(
                                              color: const Color(0xffFF7E2E),
                                              fontSize:
                                                  Dimensions.fontSizeSmall,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  (restaurant.nonVeg == 1 &&
                                          restaurant.veg == 1)
                                      ? SizedBox(
                                          width: 76,
                                          height: 26,
                                          child: Stack(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: selectedButton ==
                                                          'non-veg'
                                                      ? Colors.red
                                                      : (selectedButton ==
                                                              "veg")
                                                          ? Colors.green
                                                          : const Color(
                                                              0xffE0E0E0),
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                              ),

                                              // Sliding selection indicator
                                              AnimatedAlign(
                                                duration: const Duration(
                                                    milliseconds: 300),
                                                alignment: selectedButton ==
                                                        'non-veg'
                                                    ? Alignment.centerLeft
                                                    : (selectedButton == 'veg'
                                                        ? Alignment.centerRight
                                                        : Alignment.center),
                                                child: Container(
                                                  width: 25,
                                                  height: 25,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    shape: BoxShape.circle,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.3),
                                                        offset:
                                                            const Offset(0, 4),
                                                        blurRadius: 8,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),

                                              // Buttons in a row
                                              Center(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    // Non-Veg Button
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          selectedButton =
                                                              'non-veg';
                                                          restController
                                                              .setNonVeg();
                                                          restController
                                                              .getRestaurantProductList(
                                                                  restController
                                                                      .restaurant!
                                                                      .id,
                                                                  1,
                                                                  "non_veg",
                                                                  true);
                                                        });
                                                      },
                                                      child: Image.asset(
                                                        Images.newNonVeg,
                                                        height: 12,
                                                        width: 12,
                                                        color: selectedButton ==
                                                                'non-veg'
                                                            ? null
                                                            : const Color(
                                                                0xffA7A7A7),
                                                      ),
                                                    ),

                                                    // All Button
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          selectedButton =
                                                              'all';
                                                          restController
                                                              .getRestaurantProductList(
                                                                  restController
                                                                      .restaurant!
                                                                      .id,
                                                                  1,
                                                                  "all",
                                                                  true);
                                                        });
                                                      },
                                                      child: const Text(
                                                        'All',
                                                        style: TextStyle(
                                                          fontSize: Dimensions
                                                              .paddingSizeSmall,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),

                                                    // Veg Button
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          restController
                                                              .setVeg();

                                                          selectedButton =
                                                              'veg';
                                                          restController
                                                              .getRestaurantProductList(
                                                                  restController
                                                                      .restaurant!
                                                                      .id,
                                                                  1,
                                                                  "veg",
                                                                  true);
                                                        });
                                                      },
                                                      child: Image.asset(
                                                        Images.vegImage,
                                                        height: 12,
                                                        width: 12,
                                                        color: selectedButton ==
                                                                'veg'
                                                            ? null
                                                            : Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : restaurant.veg == 1
                                          ? Image.asset(
                                              Images.vegImage,
                                              height: 20,
                                              width: 20,
                                            )
                                          : Image.asset(
                                              Images.nonVegImage,
                                              height: 20,
                                              width: 20,
                                            ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: Dimensions.paddingSizeDefault,
                            ),
                            // restaurant.discount != null
                            //     ? Container(
                            //         width: context.width,
                            //         margin: const EdgeInsets.symmetric(
                            //             vertical: Dimensions.paddingSizeSmall,
                            //             horizontal: Dimensions.paddingSizeLarge),
                            //         decoration: BoxDecoration(
                            //             borderRadius: BorderRadius.circular(
                            //                 Dimensions.radiusSmall),
                            //             color: Theme.of(context).primaryColor),
                            //         padding: const EdgeInsets.all(
                            //             Dimensions.paddingSizeSmall),
                            //         child: Column(
                            //             mainAxisAlignment: MainAxisAlignment.center,
                            //             children: [
                            //               Text(
                            //                 restaurant.discount!.discountType ==
                            //                         'percent'
                            //                     ? '${restaurant.discount!.discount}% ${'off'.tr}'
                            //                     : '${PriceConverter.convertPrice(restaurant.discount!.discount)} ${'off'.tr}',
                            //                 style: robotoMedium.copyWith(
                            //                     fontSize: Dimensions.fontSizeLarge,
                            //                     color: Theme.of(context).cardColor),
                            //               ),
                            //               Text(
                            //                 restaurant.discount!.discountType ==
                            //                         'percent'
                            //                     ? '${'enjoy'.tr} ${restaurant.discount!.discount}% ${'off_on_all_categories'.tr}'
                            //                     : '${'enjoy'.tr} ${PriceConverter.convertPrice(restaurant.discount!.discount)}'
                            //                         ' ${'off_on_all_categories'.tr}',
                            //                 style: robotoMedium.copyWith(
                            //                     fontSize: Dimensions.fontSizeSmall,
                            //                     color: Theme.of(context).cardColor),
                            //               ),
                            //               SizedBox(
                            //                   height: (restaurant.discount!
                            //                                   .minPurchase !=
                            //                               0 ||
                            //                           restaurant.discount!
                            //                                   .maxDiscount !=
                            //                               0)
                            //                       ? 5
                            //                       : 0),
                            //               restaurant.discount!.minPurchase != 0
                            //                   ? Text(
                            //                       '[ ${'minimum_purchase'.tr}: ${PriceConverter.convertPrice(restaurant.discount!.minPurchase)} ]',
                            //                       style: robotoRegular.copyWith(
                            //                           fontSize: Dimensions
                            //                               .fontSizeExtraSmall,
                            //                           color: Theme.of(context)
                            //                               .cardColor),
                            //                     )
                            //                   : const SizedBox(),
                            //               restaurant.discount!.maxDiscount != 0
                            //                   ? Text(
                            //                       '[ ${'maximum_discount'.tr}: ${PriceConverter.convertPrice(restaurant.discount!.maxDiscount)} ]',
                            //                       style: robotoRegular.copyWith(
                            //                           fontSize: Dimensions
                            //                               .fontSizeExtraSmall,
                            //                           color: Theme.of(context)
                            //                               .cardColor),
                            //                     )
                            //                   : const SizedBox(),
                            //               Text(
                            //                 '[ ${'daily_time'.tr}: ${DateConverter.convertTimeToTime(restaurant.discount!.startTime!)} '
                            //                 '- ${DateConverter.convertTimeToTime(restaurant.discount!.endTime!)} ]',
                            //                 style: robotoRegular.copyWith(
                            //                     fontSize:
                            //                         Dimensions.fontSizeExtraSmall,
                            //                     color: Theme.of(context).cardColor),
                            //               ),
                            //             ]),
                            //       )
                            //     : const SizedBox(),
                            // const SizedBox(
                            //   height: Dimensions.paddingSizeSmall,
                            // ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: Dimensions.paddingSizeDefault),
                              decoration: BoxDecoration(
                                color: Get.theme.cardColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    // offset: const Offset(0, 2),
                                    blurRadius: 5.0,
                                    spreadRadius: 0.0,
                                  ),
                                ],
                                borderRadius: const BorderRadius.only(
                                    bottomRight:
                                        Radius.circular(Dimensions.radiusLarge),
                                    bottomLeft: Radius.circular(
                                        Dimensions.radiusLarge)),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    height: 42,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 40),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.3),
                                            offset: const Offset(0, 6),
                                            blurRadius: 2.0,
                                            spreadRadius: 0.0,
                                            blurStyle: BlurStyle.outer),
                                      ],
                                    ),
                                    child: TextField(
                                      controller: _searchController,
                                      style: robotoRegular.copyWith(
                                          fontSize: Dimensions.fontSizeLarge),
                                      textInputAction: TextInputAction.search,
                                      cursorColor:
                                          Theme.of(context).primaryColor,
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      decoration: InputDecoration(
                                        hintText:
                                            "What are you looking for...?",
                                        hintStyle: robotoRegular.copyWith(
                                            fontSize: Dimensions.fontSizeSmall,
                                            color: Theme.of(context).hintColor),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 0,
                                                horizontal: Dimensions
                                                    .paddingSizeSmall),
                                        border: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        prefixIcon: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 8, 0, 0),
                                          child: IconButton(
                                            icon: Icon(Icons.search,
                                                color:
                                                    Theme.of(context).hintColor,
                                                size: 22),
                                            onPressed: () {
                                              Get.find<RestaurantController>()
                                                  .getRestaurantSearchProductList(
                                                _searchController.text.trim(),
                                                restaurant!.id.toString(),
                                                Get.find<RestaurantController>()
                                                    .foodOffset,
                                                Get.find<RestaurantController>()
                                                    .searchType,
                                              );
                                            },
                                          ),
                                        ),
                                        suffixIcon: _searchController
                                                .text.isNotEmpty
                                            ? IconButton(
                                                icon: Icon(Icons.clear,
                                                    color: Theme.of(context)
                                                        .hintColor),
                                                onPressed: () {
                                                  setState(() {
                                                    _searchController.clear();
                                                    Get.find<
                                                            RestaurantController>()
                                                        .changeSearchStatus(
                                                            isUpdate: false);

                                                    Get.find<
                                                            RestaurantController>()
                                                        .getRestaurantProductList(
                                                            widget.restaurant!
                                                                    .id ??
                                                                Get.find<
                                                                        RestaurantController>()
                                                                    .restaurant!
                                                                    .id!,
                                                            Get.find<
                                                                    RestaurantController>()
                                                                .foodOffset,
                                                            'all',
                                                            false);
                                                  });
                                                },
                                              )
                                            : null,
                                      ),
                                      onEditingComplete: () {
                                        Get.find<RestaurantController>()
                                            .getRestaurantSearchProductList(
                                          _searchController.text.trim(),
                                          restaurant!.id.toString(),
                                          Get.find<RestaurantController>()
                                              .foodOffset,
                                          Get.find<RestaurantController>()
                                              .searchType,
                                        );
                                      },
                                      onChanged: (value) {
                                        if (value.isEmpty) {
                                          setState(() {
                                            _searchController.clear();
                                            Get.find<RestaurantController>()
                                                .getRestaurantProductList(
                                                    widget.restaurant!.id ??
                                                        Get.find<
                                                                RestaurantController>()
                                                            .restaurant!
                                                            .id!,
                                                    Get.find<
                                                            RestaurantController>()
                                                        .foodOffset,
                                                    'all',
                                                    false);
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    height: Dimensions.paddingSizeSmall,
                                  ),
                                  const Divider(),
                                  SizedBox(
                                    width: Get.width - 10,
                                    child: Row(
                                      children: [
                                        Row(
                                          children: [
                                            InkWell(
                                              onTap: () {},
                                              child: Container(
                                                height: 35,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          Dimensions
                                                              .radiusDefault),
                                                  border: Border.all(
                                                      color: Colors.black),
                                                  color: Colors.black,
                                                ),
                                                child:

                                                    // PopupMenuButton<String>(
                                                    //   onSelected: (newValue) {
                                                    //     setState(() {
                                                    //       restController
                                                    //           .setCategoryIndex(0);
                                                    //
                                                    //       selectedSuperCategoryName =
                                                    //           newValue;
                                                    //       selectedSuperCategoryId =
                                                    //           categoryMap[
                                                    //               newValue]!;
                                                    //       Get.find<
                                                    //               SuperCategoryController>()
                                                    //           .getFoodAndCategory(
                                                    //         categoryId: "",
                                                    //         selectedSuperCategoryId!,
                                                    //         restaurant!.id!,
                                                    //         1,
                                                    //       );
                                                    //     });
                                                    //   },
                                                    //   itemBuilder: (context) =>
                                                    //       categoryMap.keys
                                                    //           .map((name) {
                                                    //     return PopupMenuItem<
                                                    //         String>(
                                                    //       value: name,
                                                    //       child: Text(
                                                    //         name,
                                                    //         style: const TextStyle(
                                                    //             color:
                                                    //                 Colors.black),
                                                    //       ),
                                                    //     );
                                                    //   }).toList(),
                                                    //   child: Row(
                                                    //     mainAxisAlignment:
                                                    //         MainAxisAlignment
                                                    //             .spaceBetween,
                                                    //     children: [
                                                    //       Text(
                                                    //         selectedSuperCategoryName ??
                                                    //             "Select a category",
                                                    //         style: const TextStyle(
                                                    //             color:
                                                    //                 Colors.white),
                                                    //       ),
                                                    //       const Icon(
                                                    //           Icons.arrow_drop_down,
                                                    //           color: Colors.white),
                                                    //     ],
                                                    //   ),
                                                    // ),

                                                    PopupMenuButton<String>(
                                                  offset: const Offset(0,
                                                      40), // 👈 moves the popup 40px down (below the box)
                                                  onSelected: (newValue) {
                                                    setState(() {
                                                      restController
                                                          .setCategoryIndex(0);
                                                      selectedSuperCategoryName =
                                                          newValue;
                                                      selectedSuperCategoryId =
                                                          categoryMap[
                                                              newValue]!;
                                                      Get.find<
                                                              SuperCategoryController>()
                                                          .getFoodAndCategory(
                                                        categoryId: "",
                                                        selectedSuperCategoryId!,
                                                        restaurant!.id!,
                                                        1,
                                                      );
                                                    });
                                                  },
                                                  itemBuilder: (context) =>
                                                      categoryMap.keys
                                                          .map((name) {
                                                    return PopupMenuItem<
                                                        String>(
                                                      value: name,
                                                      child: Text(
                                                        name,
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    );
                                                  }).toList(),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        selectedSuperCategoryName ??
                                                            "Select a category",
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      const Icon(
                                                          Icons.arrow_drop_down,
                                                          color: Colors.white),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            )
                                          ],
                                        ),
                                        Expanded(
                                          child: SizedBox(
                                            height: 45,
                                            width: Get.width,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: restController
                                                  .categoryList!.length,
                                              padding: const EdgeInsets.only(
                                                  left: 0),
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                var categoryIndex = index;

                                                // "All" button at index 0
                                                if (index == 0) {
                                                  return InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        restController
                                                            .setCategoryIndex(
                                                                0); // select "All"
                                                        superCategoryController
                                                            .getFoodAndCategory(
                                                          selectedSuperCategoryId!,
                                                          restaurant!.id!,
                                                          1,
                                                          categoryId:
                                                              "", // empty for all categories
                                                        );
                                                      });
                                                    },
                                                    child: Center(
                                                      child: Container(
                                                        height: 35,
                                                        padding: const EdgeInsets
                                                            .symmetric(
                                                            horizontal: Dimensions
                                                                .paddingSizeSmall),
                                                        margin: const EdgeInsets
                                                            .only(
                                                            right: Dimensions
                                                                .paddingSizeSmall),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius: BorderRadius
                                                              .circular(Dimensions
                                                                  .radiusDefault),
                                                          border: Border.all(
                                                            color: restController
                                                                        .categoryIndex ==
                                                                    0
                                                                ? Colors
                                                                    .transparent
                                                                : Colors.black,
                                                          ),
                                                          color: restController
                                                                      .categoryIndex ==
                                                                  0
                                                              ? Colors.black
                                                              : Colors
                                                                  .transparent,
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            "All",
                                                            style: restController
                                                                        .categoryIndex ==
                                                                    0
                                                                ? robotoBold
                                                                    .copyWith(
                                                                    fontSize:
                                                                        Dimensions
                                                                            .fontSizeExtraSmall,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .cardColor,
                                                                  )
                                                                : robotoBold
                                                                    .copyWith(
                                                                    fontSize:
                                                                        Dimensions
                                                                            .fontSizeSmall,
                                                                  ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }

                                                // Other category buttons
                                                return InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      Get.find<
                                                              SuperCategoryController>()
                                                          .getFoodAndCategory(
                                                        selectedSuperCategoryId!,
                                                        restaurant!.id!,
                                                        1,
                                                        categoryId: restController
                                                            .categoryList![
                                                                categoryIndex]
                                                            .id
                                                            .toString(),
                                                      );
                                                      superCategoryController
                                                              .getFoodAndCategoryPage =
                                                          null;
                                                      restController
                                                          .setCategoryIndex(
                                                              categoryIndex);
                                                    });
                                                  },
                                                  child: Center(
                                                    child: Container(
                                                      height: 35,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: Dimensions
                                                              .paddingSizeSmall),
                                                      margin: const EdgeInsets
                                                          .only(
                                                          right: Dimensions
                                                              .paddingSizeSmall),
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius
                                                            .circular(Dimensions
                                                                .radiusDefault),
                                                        border: Border.all(
                                                          color: categoryIndex ==
                                                                  restController
                                                                      .categoryIndex
                                                              ? Colors
                                                                  .transparent
                                                              : Colors.black,
                                                        ),
                                                        color: categoryIndex ==
                                                                restController
                                                                    .categoryIndex
                                                            ? Colors.black
                                                            : Colors
                                                                .transparent,
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          restController
                                                              .categoryList![
                                                                  categoryIndex]
                                                              .name!,
                                                          style: categoryIndex ==
                                                                  restController
                                                                      .categoryIndex
                                                              ? robotoBold
                                                                  .copyWith(
                                                                  fontSize:
                                                                      Dimensions
                                                                          .fontSizeExtraSmall,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .cardColor,
                                                                )
                                                              : robotoBold
                                                                  .copyWith(
                                                                  fontSize:
                                                                      Dimensions
                                                                          .fontSizeSmall,
                                                                ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            ///Category type food ///

                            superCategoryController.getFoodAndCategoryPage ==
                                    null
                                ? const SizedBox()
                                : PaginatedListViewWidget(
                                    scrollController: scrollController,
                                    onPaginate: (int? offset) {
                                      if (restController.isSearching) {
                                        restController
                                            .getRestaurantSearchProductList(
                                          restController.searchText,
                                          Get.find<RestaurantController>()
                                              .restaurant!
                                              .id
                                              .toString(),
                                          offset!,
                                          restController.type,
                                        );
                                      } else {
                                        restController.getRestaurantProductList(
                                            Get.find<RestaurantController>()
                                                .restaurant!
                                                .id,
                                            offset!,
                                            restController.type,
                                            false);
                                      }
                                    },
                                    totalSize: restController.isSearching
                                        ? restController
                                            .restaurantSearchProductModel
                                            ?.totalSize
                                        : restController.restaurantProducts !=
                                                null
                                            ? restController.foodPageSize
                                            : null,
                                    offset: restController.isSearching
                                        ? restController
                                            .restaurantSearchProductModel
                                            ?.offset
                                        : restController.restaurantProducts !=
                                                null
                                            ? restController.foodPageOffset
                                            : null,
                                    productView: ProductViewWidget(
                                      restraName: true,
                                      isRestaurant: false,
                                      isFav: true,
                                      restaurants: null,
                                      products: superCategoryController
                                          .getFoodAndCategoryPage!
                                          .items!
                                          .products,
                                      inRestaurantPage: true,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: Dimensions.paddingSizeSmall,
                                        vertical: Dimensions.paddingSizeLarge,
                                      ),
                                    ),
                                  ),

                            /* MasonryGridView.count(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal:
                                            Dimensions.paddingSizeDefault,
                                        vertical:
                                            Dimensions.paddingSizeExtraLarge),
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 30.0,
                                    crossAxisSpacing: 15.0,
                                    shrinkWrap: true,
                                    physics: const ScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    itemCount: superCategoryController
                                        .getFoodAndCategoryPage!
                                        .items!
                                        .products!
                                        .length,
                                    // itemCount: 6,
                                    itemBuilder: (context, index) {
                                      double? price = double.parse(
                                          superCategoryController
                                              .getFoodAndCategoryPage!
                                              .items!
                                              .products![index]
                                              .price
                                              .toString());
                                      double? discount = double.parse(
                                          ((superCategoryController
                                                          .getFoodAndCategoryPage!
                                                          .items!
                                                          .products![index]
                                                          .restaurantDiscount ==
                                                      0)
                                                  ? superCategoryController
                                                      .getFoodAndCategoryPage!
                                                      .items!
                                                      .products![index]
                                                      .discount
                                                  : double.parse(
                                                      superCategoryController
                                                          .getFoodAndCategoryPage!
                                                          .items!
                                                          .products![index]
                                                          .restaurantDiscount
                                                          .toString()))
                                              .toString());
                                      String? discountType =
                                          (superCategoryController
                                                      .getFoodAndCategoryPage!
                                                      .items!
                                                      .products![index]
                                                      .restaurantDiscount ==
                                                  0)
                                              ? superCategoryController
                                                  .getFoodAndCategoryPage!
                                                  .items!
                                                  .products![index]
                                                  .discountType
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
                                          // if (superCategoryController
                                          //         .getFoodAndCategoryPage!
                                          //         .items!
                                          //         .products![index]
                                          //         .restaurantStatus ==
                                          //     1) {
                                          //   ResponsiveHelper.isMobile(context)
                                          //       ? Get.bottomSheet(elevation: 0,
                                          //     ProductBottomSheetWidget(
                                          //         product: superCategoryController.getFoodAndCategoryPage!.items!.products,
                                          //         inRestaurantPage: false,
                                          //         isCampaign: false),
                                          //
                                          //     backgroundColor: Colors.transparent,
                                          //     isScrollControlled: true,
                                          //   )
                                          //       : Get.dialog(
                                          //     Dialog(backgroundColor: Colors.transparent,
                                          //         child: ProductBottomSheetWidget(
                                          //             product: superCategoryController.getFoodAndCategoryPage!.items!.products![index],
                                          //             inRestaurantPage: false)),
                                          //   );
                                          // } else {
                                          //   showCustomSnackBar(
                                          //       'product_is_not_available'.tr);
                                          // }
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
                                                    height:
                                                        index == 1 ? 80 : 120,
                                                    width:
                                                        index == 1 ? 80 : 120,
                                                    errorBuilder: (context,
                                                        error, stackTrace) {
                                                  return const Text(
                                                      "Loading...");
                                                },
                                                    '${Get.find<SplashController>().configModel?.baseUrls?.productImageUrl}'
                                                    '/${superCategoryController.getFoodAndCategoryPage!.items!.products![index].image.toString()}'),
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
                                                            TextBaseline
                                                                .alphabetic,
                                                        // crossAxisAlignment:
                                                        // CrossAxisAlignment
                                                        //     .end,
                                                        children: [
                                                          Text(
                                                            "₹ ",
                                                            style: TextStyle(
                                                                color:
                                                                    textColor),
                                                          ),
                                                          Text(
                                                            priceWithDiscountForView
                                                                .round()
                                                                .toString(),
                                                            style: TextStyle(
                                                                color:
                                                                    textColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: Dimensions
                                                                    .fontSizeOverLarge),
                                                          ),
                                                        ],
                                                      ),
                                                      (index == 1 ||
                                                              superCategoryController
                                                                      .getFoodAndCategoryPage!
                                                                      .items!
                                                                      .products![
                                                                          index]
                                                                      .discount ==
                                                                  0)
                                                          ? const SizedBox()
                                                          : Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .baseline,
                                                              textBaseline:
                                                                  TextBaseline
                                                                      .alphabetic,
                                                              // crossAxisAlignment:
                                                              // CrossAxisAlignment
                                                              //     .end,
                                                              children: [
                                                                Text(
                                                                  "₹ ",
                                                                  style:
                                                                      TextStyle(
                                                                    color:
                                                                        textColor,
                                                                    fontSize:
                                                                        Dimensions
                                                                            .fontSizeSmall,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  superCategoryController
                                                                      .getFoodAndCategoryPage!
                                                                      .items!
                                                                      .products![
                                                                          index]!
                                                                      .price!
                                                                      .round()
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      color:
                                                                          textColor,
                                                                      decoration:
                                                                          TextDecoration
                                                                              .lineThrough,
                                                                      decorationColor:
                                                                          textColor,
                                                                      fontSize:
                                                                          Dimensions
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
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: 100,
                                                    child: Text(
                                                      superCategoryController
                                                          .getFoodAndCategoryPage!
                                                          .items!
                                                          .products![index]
                                                          .restaurantName!,
                                                      softWrap: true,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          color: textColor),
                                                    ),
                                                  ),

                                                  superCategoryController
                                                              .getFoodAndCategoryPage!
                                                              .items!
                                                              .products![index]!
                                                              .minDeliveryTime ==
                                                          null
                                                      ? const SizedBox()
                                                      : SizedBox(
                                                          width: 100,
                                                          child: Text(
                                                            "${superCategoryController.getFoodAndCategoryPage!.items!.products![index].maxDeliveryTime} Min Delivery",
                                                            softWrap: true,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                color:
                                                                    textColor,
                                                                fontSize: Dimensions
                                                                    .fontSizeSmall),
                                                          ),
                                                        ),

                                                  // Row(
                                                  //   children: [
                                                  //     // Text(
                                                  //     //  products[index],
                                                  //     //   style:
                                                  //     //   TextStyle(
                                                  //     //     color: Get
                                                  //     //         .theme
                                                  //     //         .cardColor,
                                                  //     //   ),
                                                  //     // ),
                                                  //
                                                  //     /// Rating//
                                                  //     RatingBar(
                                                  //         rating: superCategoryController.getFoodAndCategoryPage!.items!.products![index].avgRating,
                                                  //         unSeletedStar:  Get.find<HomeController>().unRatedColor!,
                                                  //         starColor: Get.find<HomeController>().ratedColor!,
                                                  //
                                                  //         size: 14,                 ratingCount: superCategoryController.getFoodAndCategoryPage!.items!.products![index]!.ratingCount)
                                                  //
                                                  //   ],
                                                  // ),

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
                                              top: 5,
                                              left: 10,
                                              child: SizedBox(
                                                width: 100,
                                                child: Text(
                                                  superCategoryController
                                                      .getFoodAndCategoryPage!
                                                      .items!
                                                      .products![index]!
                                                      .name!,
                                                  maxLines: 2,
                                                  softWrap: true,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: Dimensions
                                                          .fontSizeLarge,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: textColor),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: superCategoryController
                                                          .getFoodAndCategoryPage!
                                                          .items!
                                                          .products![index]
                                                          .discount !=
                                                      0
                                                  ? 40
                                                  : 10,
                                              left: Get.find<
                                                          LocalizationController>()
                                                      .isLtr
                                                  ? null
                                                  : 15,
                                              right: Get.find<
                                                          LocalizationController>()
                                                      .isLtr
                                                  ? 5
                                                  : null,
                                              child: GetBuilder<
                                                      FavouriteController>(
                                                  builder: (wishController) {
                                                bool isWished = wishController
                                                    .wishProductIdList
                                                    .contains(
                                                        superCategoryController
                                                            .getFoodAndCategoryPage!
                                                            .items!
                                                            .products![index]
                                                            .id);
                                                return CustomFavouriteWidget(
                                                  isWished: isWished,

                                                  isRestaurant: false,
                                                  // product: superCategoryController.getFoodAndCategoryPage!.items!.products,
                                                );
                                              }),
                                            ),

                                            ///  offer
                                            superCategoryController
                                                        .getFoodAndCategoryPage!
                                                        .items!
                                                        .products![index]
                                                        .discount !=
                                                    0
                                                ? Positioned(
                                                    top: -20,
                                                    right: -15,
                                                    child:
                                                        StreamBuilder<Object>(
                                                      stream: null,
                                                      builder:
                                                          (context, snapshot) {
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
                                                                      (superCategoryController.getFoodAndCategoryPage!.items!.products![index]!.discountType ==
                                                                              'percent')
                                                                          ? Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                Text(
                                                                                  '${superCategoryController.getFoodAndCategoryPage!.items!.products![index]!.discount!.round()}',
                                                                                  style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).cardColor, fontWeight: FontWeight.bold),
                                                                                ),
                                                                                Text(
                                                                                  "%",
                                                                                  style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).cardColor, fontWeight: FontWeight.bold),
                                                                                )
                                                                              ],
                                                                            )
                                                                          : Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              crossAxisAlignment: CrossAxisAlignment.baseline,
                                                                              textBaseline: TextBaseline.alphabetic,
                                                                              children: [
                                                                                Text(
                                                                                  '₹',
                                                                                  style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).cardColor, fontWeight: FontWeight.bold),
                                                                                ),
                                                                                Text(
                                                                                  '${superCategoryController.getFoodAndCategoryPage!.items!.products![index]!.discount!.round()}',
                                                                                  style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).cardColor, fontWeight: FontWeight.bold),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                      Text(
                                                                        style: TextStyle(
                                                                            color:
                                                                                Get.theme.cardColor,
                                                                            fontSize: Dimensions.fontSizeExtraSmall),
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
*/

                            const SizedBox(
                              height: Dimensions.paddingSizeSmall,
                            ),

                            // selectedSuperCategoryName != null
                            //     ? const SizedBox()
                            //     : PaginatedListViewWidget(
                            //         scrollController: scrollController,
                            //         onPaginate: (int? offset) {
                            //           if (restController.isSearching) {
                            //             restController
                            //                 .getRestaurantSearchProductList(
                            //               restController.searchText,
                            //               Get.find<RestaurantController>()
                            //                   .restaurant!
                            //                   .id
                            //                   .toString(),
                            //               offset!,
                            //               restController.type,
                            //             );
                            //           } else {
                            //             restController.getRestaurantProductList(
                            //                 Get.find<RestaurantController>()
                            //                     .restaurant!
                            //                     .id,
                            //                 offset!,
                            //                 restController.type,
                            //                 false);
                            //           }
                            //         },
                            //         totalSize: restController.isSearching
                            //             ? restController
                            //                 .restaurantSearchProductModel
                            //                 ?.totalSize
                            //             : restController.restaurantProducts !=
                            //                     null
                            //                 ? restController.foodPageSize
                            //                 : null,
                            //         offset: restController.isSearching
                            //             ? restController
                            //                 .restaurantSearchProductModel
                            //                 ?.offset
                            //             : restController.restaurantProducts !=
                            //                     null
                            //                 ? restController.foodPageOffset
                            //                 : null,
                            //         productView: ProductViewWidget(
                            //           restraName: true,
                            //           isRestaurant: false,
                            //           isFav: true,
                            //           restaurants: null,
                            //           products: restController.isSearching
                            //               ? restController
                            //                   .restaurantSearchProductModel
                            //                   ?.products
                            //               : restController
                            //                       .categoryList!.isNotEmpty
                            //                   ? restController
                            //                       .restaurantProducts
                            //                   : null,
                            //           inRestaurantPage: true,
                            //           padding: const EdgeInsets.symmetric(
                            //             horizontal: Dimensions.paddingSizeSmall,
                            //             vertical: Dimensions.paddingSizeLarge,
                            //           ),
                            //         ),
                            //       ),

                            const SizedBox(
                              height: Dimensions.paddingSizeExtraOverLarge,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.paddingSizeDefault),
                              child: Text(
                                "Love from, \n${restaurant.name}",
                                style: const TextStyle(
                                    letterSpacing: 0.5,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 44,
                                    color: Color(0xffA7A7A7)),
                              ),
                            ),
                            const SizedBox(
                              height: Dimensions.paddingSizeExtraOverLarge,
                            ),
                          ],
                        )
                      : const RestaurantScreenShimmerWidget();
                });
              });
            },
          );
        }),
        bottomNavigationBar:
            GetBuilder<CartController>(builder: (cartController) {
          return cartController.cartList.isNotEmpty && !isDesktop
              ? BottomCartWidget(
                  restaurantId:
                      cartController.cartList[0].product!.restaurantId!)
              : const SizedBox();
        }));
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

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;
  double height;

  SliverDelegate({required this.child, this.height = 100});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != height ||
        oldDelegate.minExtent != height ||
        child != oldDelegate.child;
  }
}

import 'dart:async';

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:stackfood_multivendor/features/cart/controllers/cart_controller.dart';
import 'package:stackfood_multivendor/features/product/controllers/campaign_controller.dart';
import 'package:stackfood_multivendor/features/home/controllers/home_controller.dart';
import 'package:stackfood_multivendor/features/home/screens/web_home_screen.dart';
import 'package:stackfood_multivendor/features/home/widgets/all_restaurants_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/banner_view_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/best_review_item_view_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/popular_restaurants_view_widget.dart';
import 'package:stackfood_multivendor/features/home/screens/theme1_home_screen.dart';
import 'package:stackfood_multivendor/features/home/widgets/what_on_your_mind_view_widget.dart';
import 'package:stackfood_multivendor/features/language/controllers/localization_controller.dart';
import 'package:stackfood_multivendor/features/order/controllers/order_controller.dart';
import 'package:stackfood_multivendor/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor/features/notification/controllers/notification_controller.dart';
import 'package:stackfood_multivendor/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/splash/domain/models/config_model.dart';
import 'package:stackfood_multivendor/features/address/controllers/address_controller.dart';
import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/category/controllers/category_controller.dart';
import 'package:stackfood_multivendor/features/cuisine/controllers/cuisine_controller.dart';
import 'package:stackfood_multivendor/features/product/controllers/product_controller.dart';
import 'package:stackfood_multivendor/features/review/controllers/review_controller.dart';
import 'package:stackfood_multivendor/helper/address_helper.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/footer_view_widget.dart';
import 'package:stackfood_multivendor/common/widgets/web_menu_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/widgets/custom_favourite_widget.dart';
import '../../../common/widgets/custom_snackbar_widget.dart';
import '../../../common/widgets/product_bottom_sheet_widget.dart';
import '../../../corner_banner/rating_bar.dart';
import '../../../helper/auth_helper.dart';
import '../../../helper/price_converter.dart';
import '../../favourite/controllers/favourite_controller.dart';
import '../../menu/screens/menu_screen.dart';
import '../../restaurant/controllers/super_category_controller.dart';
import '../widgets/cuisine_view_widget.dart';
import '../widgets/enjoy_off_banner_view_widget.dart';
import '../widgets/new_on_madebymaa.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static Future<void> loadData(bool reload) async {
    Get.find<HomeController>().getBannerList(reload);
    Get.find<CategoryController>().getCategoryList(reload);
    Get.find<CuisineController>().getCuisineList();
    if (Get.find<SplashController>().configModel!.popularRestaurant == 1) {
      Get.find<RestaurantController>()
          .getPopularRestaurantList(reload, 'all', false);
    }
    Get.find<CampaignController>().getItemCampaignList(reload);
    if (Get.find<SplashController>().configModel!.popularFood == 1) {
      Get.find<ProductController>().getPopularProductList(reload, 'all', false);
    }
    if (Get.find<SplashController>().configModel!.newRestaurant == 1) {
      Get.find<RestaurantController>()
          .getLatestRestaurantList(reload, 'all', false);
    }
    if (Get.find<SplashController>().configModel!.mostReviewedFoods == 1) {
      Get.find<ReviewController>().getReviewedProductList(reload, 'all', false);
    }
    Get.find<RestaurantController>().getRestaurantList(1, reload, isSix: true);

    if (Get.find<AuthController>().isLoggedIn()) {
      Get.find<RestaurantController>()
          .getRecentlyViewedRestaurantList(reload, 'all', false);
      Get.find<RestaurantController>().getOrderAgainRestaurantList(reload);
      Get.find<ProfileController>().getUserInfo();
      Get.find<NotificationController>().getNotificationList(reload);
      Get.find<OrderController>().getRunningOrders(1, notify: false);
      Get.find<AddressController>().getAddressList();
    }
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ConfigModel? _configModel = Get.find<SplashController>().configModel;
  bool _isLogin = false;
  int _currentIndexPage = 0;

  final _controller = PageController();

  ScrollController _scrollController = ScrollController();
  RxDouble _previousScrollOffset = 0.0.obs;

  bool showMenuIcon = true;
  bool showSearch = false;

  @override
  void initState() {
    super.initState();
    _scheduleRebuild();

    _isLogin = Get.find<AuthController>().isLoggedIn();
    Get.find<SuperCategoryController>().getSuperCategory();
    HomeScreen.loadData(false);
    _scrollController.addListener(_handleScroll);
    // updateCurrentCategories(); // Initial check
    // Timer.periodic(const Duration(seconds: 1), (timer) {
    //   // updateCurrentCategories(); // Update every second
    // });
    // currentCategoryId.isEmpty
    //     ? null
    //     : Get.find<SuperCategoryController>()
    //         .getFoodAndCategory(int.parse(currentCategoryId[0].toString()), 1);

    // print(
    //     "pp--==${int.parse(Get.find<SuperCategoryController>().getFoodAndCategoryPage.toString())}");
  }

  void _scheduleRebuild() {
    final now = DateTime.now();
    final sixAM = DateTime(now.year, now.month, now.day, 6);

    if (now.isBefore(sixAM)) {
      Timer(sixAM.difference(now), () {
        setState(() {});
      });
    }
  }

  bool isNightTime() {
    final now = DateTime.now();
    final hour = now.hour;

    // 12 AM (0) se 6 AM (5:59)
    return hour >= 0 && hour < 6;
  }

  void _handleScroll() {
    double scrollPosition = _scrollController.position.pixels;
    print("Scroll position: $scrollPosition"); // Debug print

    if (scrollPosition > 100 && showMenuIcon) {
      setState(() {
        showMenuIcon = false;
      });
    } else if (scrollPosition <= 100 && !showMenuIcon) {
      setState(() {
        showMenuIcon = true;
      });
    }

    if (scrollPosition > 300 && showSearch) {
      setState(() {
        showSearch = false;
      });
    } else if (scrollPosition <= 300 && !showSearch) {
      setState(() {
        showSearch = true;
      });
    }
  }

  void _scrollListener() {
    if (_scrollController.offset > _previousScrollOffset.value) {
      print("AppBar is collapsing (scrolling up)");
    } else if (_scrollController.offset < _previousScrollOffset.value) {
      print("AppBar is expanding (scrolling down)");
    }
    _previousScrollOffset.value = _scrollController.offset;

    print("dattaa ${_previousScrollOffset.toString()}");
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  List<String> currentCategoryNames = [];
  List<int> currentCategoryId = [];

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
  //     DateTime start = DateFormat.Hms().parse(category.startTime!);
  //     DateTime end = DateFormat.Hms().parse(category.endTime!);
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
    double scrollPoint = 0.0;

    if (isNightTime()) {
      return PopScope(
        canPop: false, // ❌ back disabled
        child: Scaffold(
          body: Center(
            child: Image.asset(
              Images.homeTimeImage, // 👈 apni image ka path
              // fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),
      );
    }

    return GetBuilder<ReviewController>(
      builder: (reviewController) {
        return GetBuilder<ProductController>(
          builder: (productController) {
            return GetBuilder<CampaignController>(
              builder: (campaignController) {
                return GetBuilder<ProfileController>(
                  builder: (profileController) {
                    return GetBuilder<CartController>(
                      builder: (cartController) {
                        return GetBuilder<LocalizationController>(
                            builder: (localizationController) {
                          return GetBuilder<SuperCategoryController>(
                            builder: (superCategoryController) {
                              return Scaffold(
                                appBar: ResponsiveHelper.isDesktop(context)
                                    ? const WebMenuBar()
                                    : null,
                                // endDrawer: const MenuDrawerWidget(),
                                // endDrawerEnableOpenDragGesture: false,
                                backgroundColor: Colors.transparent,
                                body: SafeArea(
                                  top: (Get.find<SplashController>()
                                          .configModel!
                                          .theme ==
                                      2),
                                  child: RefreshIndicator(
                                    onRefresh: () async {
                                      await Get.find<HomeController>()
                                          .getBannerList(true);
                                      await Get.find<CategoryController>()
                                          .getCategoryList(true);
                                      await Get.find<CuisineController>()
                                          .getCuisineList();
                                      await Get.find<RestaurantController>()
                                          .getPopularRestaurantList(
                                              true, 'all', false);
                                      await Get.find<CampaignController>()
                                          .getItemCampaignList(true);
                                      await Get.find<ProductController>()
                                          .getPopularProductList(
                                              true, 'all', false);
                                      await Get.find<RestaurantController>()
                                          .getLatestRestaurantList(
                                              true, 'all', false);
                                      await Get.find<ReviewController>()
                                          .getReviewedProductList(
                                              true, 'all', false);
                                      await Get.find<RestaurantController>()
                                          .getRestaurantList(1, true,
                                              isSix: true);
                                      if (Get.find<AuthController>()
                                          .isLoggedIn()) {
                                        await Get.find<ProfileController>()
                                            .getUserInfo();
                                        await Get.find<NotificationController>()
                                            .getNotificationList(true);
                                        await Get.find<RestaurantController>()
                                            .getRecentlyViewedRestaurantList(
                                                true, 'all', false);
                                        await Get.find<RestaurantController>()
                                            .getOrderAgainRestaurantList(true);
                                      }
                                    },
                                    child: ResponsiveHelper.isDesktop(context)
                                        ? WebHomeScreen(
                                            scrollController: _scrollController,
                                          )
                                        : (Get.find<SplashController>()
                                                    .configModel!
                                                    .theme ==
                                                2)
                                            ? Theme1HomeScreen(
                                                scrollController:
                                                    _scrollController,
                                              )
                                            : CustomScrollView(
                                                shrinkWrap: true,
                                                controller: _scrollController,
                                                physics:
                                                    const AlwaysScrollableScrollPhysics(),
                                                slivers: [
                                                  ///Pratham appbar ///

                                                  SliverAppBar(
                                                    snap: false,
                                                    pinned: true,
                                                    floating: false,
                                                    flexibleSpace:
                                                        FlexibleSpaceBar(
                                                      centerTitle: true,
                                                      titlePadding:
                                                          const EdgeInsets.only(
                                                        bottom: 210.0,
                                                        left: 60,
                                                        right: 60,
                                                      ),
                                                      title: InkWell(
                                                          onTap: () => Get
                                                              .toNamed(RouteHelper
                                                                  .getSearchRoute()),
                                                          child: Container(
                                                              height: 30,
                                                              transform: Matrix4
                                                                  .translationValues(
                                                                      0, -3, 0),
                                                              decoration:
                                                                  BoxDecoration(
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.5),
                                                                    spreadRadius:
                                                                        0,
                                                                    blurRadius:
                                                                        1,
                                                                    offset:
                                                                        const Offset(
                                                                            0,
                                                                            1.5),
                                                                  ),
                                                                ],
                                                                color: Theme.of(
                                                                        context)
                                                                    .cardColor,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25),
                                                              ),
                                                              child: Row(
                                                                  children: [
                                                                    const SizedBox(
                                                                      width: Dimensions
                                                                          .paddingSizeDefault,
                                                                    ),
                                                                    Image.asset(
                                                                        Images
                                                                            .search2,
                                                                        width:
                                                                            12,
                                                                        height:
                                                                            12),
                                                                    const SizedBox(
                                                                        width: Dimensions
                                                                            .paddingSizeSmall),
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        'are_you_hungry'
                                                                            .tr,
                                                                        style: robotoRegular
                                                                            .copyWith(
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                          fontSize:
                                                                              8,
                                                                          color:
                                                                              const Color(0xffA7A7A7),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ]))),
                                                      background: Stack(
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .only(
                                                              bottomLeft: Radius
                                                                  .circular(
                                                                      Dimensions
                                                                          .radiusDefault),
                                                              bottomRight: Radius
                                                                  .circular(
                                                                      Dimensions
                                                                          .radiusDefault),
                                                            ),
                                                            child: Image.asset(
                                                              Images.appBarBg,
                                                              fit: BoxFit.cover,
                                                              width: Get.width,
                                                              height: 330,
                                                            ),
                                                          ),
                                                          const Positioned(
                                                              top: 240,
                                                              left: 0,
                                                              right: 0,
                                                              child: Center(
                                                                  child:
                                                                      BannerViewWidget()))
                                                        ],
                                                      ),
                                                    ),
                                                    centerTitle: true,
                                                    shadowColor: Colors.grey,
                                                    title: showSearch
                                                        ? const Text("")
                                                        : InkWell(
                                                            onTap: () => Get
                                                                .toNamed(RouteHelper
                                                                    .getSearchRoute()),
                                                            child: Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            40,
                                                                        right:
                                                                            40),
                                                                height: 40,
                                                                transform: Matrix4
                                                                    .translationValues(
                                                                        0,
                                                                        -3,
                                                                        0),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      color: Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                              0.5),
                                                                      spreadRadius:
                                                                          0,
                                                                      blurRadius:
                                                                          1,
                                                                      offset:
                                                                          const Offset(
                                                                              0,
                                                                              1.5),
                                                                    ),
                                                                  ],
                                                                  color: Theme.of(
                                                                          context)
                                                                      .cardColor,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              25),
                                                                ),
                                                                child: Row(
                                                                    children: [
                                                                      const SizedBox(
                                                                        width: Dimensions
                                                                            .paddingSizeDefault,
                                                                      ),
                                                                      Image.asset(
                                                                          Images
                                                                              .search2,
                                                                          width:
                                                                              14,
                                                                          height:
                                                                              14),
                                                                      const SizedBox(
                                                                          width:
                                                                              Dimensions.paddingSizeSmall),
                                                                      Expanded(
                                                                        child:
                                                                            Text(
                                                                          'are_you_hungry'
                                                                              .tr,
                                                                          style:
                                                                              robotoRegular.copyWith(
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            fontSize:
                                                                                Dimensions.fontSizeDefault,
                                                                            color:
                                                                                const Color(0xffA7A7A7),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ]))),
                                                    expandedHeight: 400,
                                                    surfaceTintColor:
                                                        Colors.white,
                                                    toolbarHeight: 75,
                                                    leadingWidth: !showMenuIcon
                                                        ? 20
                                                        : Get.width,
                                                    leading: showMenuIcon
                                                        ? AuthHelper
                                                                .isLoggedIn()
                                                            ? Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        right:
                                                                            16.0,
                                                                        left:
                                                                            16.0,
                                                                        top:
                                                                            16.0),
                                                                child: Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        Get.to(() =>
                                                                            const MenuScreen());
                                                                      },
                                                                      child: Container(
                                                                          height: 40,
                                                                          width: 40,
                                                                          decoration: BoxDecoration(
                                                                            color:
                                                                                Get.theme.cardColor,
                                                                            border:
                                                                                Border.all(),
                                                                            shape:
                                                                                BoxShape.circle,
                                                                          ),
                                                                          child: Get.find<ProfileController>().userInfoModel!.image == null
                                                                              ? const Icon(Icons.person, size: 30)
                                                                              : ClipRRect(
                                                                                  borderRadius: BorderRadius.circular(100),
                                                                                  child: Image.network(
                                                                                    '${Get.find<SplashController>().configModel!.baseUrls!.customerImageUrl}'
                                                                                    '/${(profileController.userInfoModel != null) ? profileController.userInfoModel!.image : ''}',
                                                                                    fit: BoxFit.cover,
                                                                                  ),
                                                                                )),
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 15,
                                                                    ),
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          "Hi, ${Get.find<ProfileController>().userInfoModel!.fName}",
                                                                          style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: Dimensions.fontSizeLarge),
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              Dimensions.paddingSizeExtraSmall,
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              Get.width / 1.5,
                                                                          child:
                                                                              InkWell(
                                                                            onTap: () =>
                                                                                Get.toNamed(RouteHelper.getAccessLocationRoute('home')),
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                SizedBox(
                                                                                  width: 100,
                                                                                  child: Text(
                                                                                    maxLines: 1,
                                                                                    AddressHelper.getAddressFromSharedPref()!.address!,
                                                                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: Dimensions.fontSizeSmall),
                                                                                  ),
                                                                                ),
                                                                                const Icon(
                                                                                  Icons.keyboard_arrow_down_rounded,
                                                                                  color: Colors.black,
                                                                                  size: 20,
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                    InkWell(
                                                                      child: GetBuilder<
                                                                              NotificationController>(
                                                                          builder:
                                                                              (notificationController) {
                                                                        return Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            // color: Theme.of(
                                                                            //     context)
                                                                            //     .cardColor
                                                                            //     .withOpacity(0.9),
                                                                            borderRadius:
                                                                                BorderRadius.circular(Dimensions.radiusDefault),
                                                                          ),
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              Dimensions.paddingSizeExtraSmall),
                                                                          child:
                                                                              Stack(children: [
                                                                            Image.asset(
                                                                              Images.notificationIcon,
                                                                              height: 24,
                                                                            ),
                                                                            notificationController.hasNotification
                                                                                ? Positioned(
                                                                                    top: 0,
                                                                                    right: 0,
                                                                                    child: Container(
                                                                                      height: 10,
                                                                                      width: 10,
                                                                                      decoration: BoxDecoration(
                                                                                        color: Theme.of(context).primaryColor,
                                                                                        shape: BoxShape.circle,
                                                                                        border: Border.all(width: 1, color: Theme.of(context).cardColor),
                                                                                      ),
                                                                                    ))
                                                                                : const SizedBox(),
                                                                          ]),
                                                                        );
                                                                      }),
                                                                      onTap: () =>
                                                                          Get.toNamed(
                                                                              RouteHelper.getNotificationRoute()),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            : Padding(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        16.0),
                                                                child: Row(
                                                                  children: [
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        Get.to(() =>
                                                                            const MenuScreen());
                                                                      },
                                                                      child: Container(
                                                                          height: 50,
                                                                          width: 50,
                                                                          decoration: BoxDecoration(
                                                                            color:
                                                                                Get.theme.cardColor,
                                                                            border:
                                                                                Border.all(),
                                                                            shape:
                                                                                BoxShape.circle,
                                                                          ),
                                                                          child: ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(100),
                                                                            child:
                                                                                Image.network(
                                                                              "https://t4.ftcdn.net/jpg/00/65/77/27/360_F_65772719_A1UV5kLi5nCEWI0BNLLiFaBPEkUbv5Fv.jpg",
                                                                              fit: BoxFit.cover,
                                                                            ),
                                                                          )),
                                                                    )
                                                                  ],
                                                                ),
                                                              )
                                                        : IconButton(
                                                            icon: const Icon(
                                                              Icons.menu,
                                                              color:
                                                                  Colors.white,
                                                              size: 0,
                                                            ),
                                                            tooltip: 'Menu',
                                                            onPressed: () {},
                                                          ),
                                                  ),
                                                  SliverToBoxAdapter(
                                                    child: Center(
                                                        child: SizedBox(
                                                      width: Dimensions
                                                          .webMaxWidth,
                                                      child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            // const BannerViewWidget(),

                                                            // const BadWeatherWidget(),

                                                            const WhatOnYourMindViewWidget(),

                                                            // const TodayTrendsViewWidget(),

                                                            // const LocationBannerViewWidget(),

                                                            (campaignController
                                                                        .itemCampaignList!
                                                                        .isEmpty ||
                                                                    campaignController
                                                                            .itemCampaignList ==
                                                                        null)
                                                                ? const SizedBox()
                                                                : Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child: Text(
                                                                        'trending_now'
                                                                            .tr,
                                                                        style: robotoBold.copyWith(
                                                                            fontSize:
                                                                                18,
                                                                            color: const Color(
                                                                                0xff090018),
                                                                            fontFamily:
                                                                                "Poppins",
                                                                            fontWeight:
                                                                                FontWeight.w700))),

                                                            SizedBox(
                                                              height: campaignController
                                                                      .itemCampaignList!
                                                                      .isEmpty
                                                                  ? 0
                                                                  : 20,
                                                            ),

                                                            campaignController
                                                                    .itemCampaignList!
                                                                    .isEmpty
                                                                ? const SizedBox()
                                                                : MasonryGridView
                                                                    .count(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                            Dimensions
                                                                                .paddingSizeDefault,
                                                                        vertical:
                                                                            Dimensions.paddingSizeExtraLarge),
                                                                    crossAxisCount:
                                                                        2,
                                                                    mainAxisSpacing:
                                                                        30.0,
                                                                    crossAxisSpacing:
                                                                        15.0,
                                                                    shrinkWrap:
                                                                        true,
                                                                    physics:
                                                                        const ScrollPhysics(),
                                                                    scrollDirection:
                                                                        Axis.vertical,
                                                                    itemCount: campaignController.itemCampaignList!.length >=
                                                                            8
                                                                        ? 8
                                                                        : campaignController
                                                                            .itemCampaignList!
                                                                            .length,
                                                                    itemBuilder:
                                                                        (context,
                                                                            index) {
                                                                      double?
                                                                          foodPrice =
                                                                          campaignController
                                                                              .itemCampaignList![index]
                                                                              .price;

                                                                      double sum = foodPrice! -
                                                                          double.parse(campaignController
                                                                              .itemCampaignList![index]
                                                                              .discount
                                                                              .toString());

                                                                      double
                                                                          percentSum =
                                                                          (campaignController.itemCampaignList![index].discount! / 100) *
                                                                              foodPrice;
                                                                      double
                                                                          percentSum2 =
                                                                          foodPrice -
                                                                              percentSum;

                                                                      String
                                                                          imagePath;
                                                                      Color
                                                                          textColor;
                                                                      Color
                                                                          textColor2;
                                                                      Color
                                                                          starColor;

                                                                      if (index ==
                                                                          1) {
                                                                        imagePath =
                                                                            'assets/image/small bg.png';
                                                                        textColor =
                                                                            Colors.black;
                                                                        textColor2 =
                                                                            const Color(0xff524A61);
                                                                        starColor =
                                                                            const Color(0xff090018);
                                                                      } else if (index == 2 ||
                                                                          index ==
                                                                              0 ||
                                                                          index ==
                                                                              5 ||
                                                                          index ==
                                                                              6) {
                                                                        imagePath =
                                                                            'assets/image/bg1.png';

                                                                        textColor = Get
                                                                            .theme
                                                                            .cardColor;
                                                                        textColor2 =
                                                                            const Color(0xffE0E0E0);
                                                                        starColor =
                                                                            const Color(0xffFF9C11);
                                                                      } else {
                                                                        imagePath = (index % 2 ==
                                                                                0)
                                                                            ? 'assets/image/bg2.png'
                                                                            : 'assets/image/bg2.png';
                                                                        textColor =
                                                                            Colors.black;
                                                                        textColor2 =
                                                                            const Color(0xff524A61);
                                                                        starColor =
                                                                            const Color(0xff090018);
                                                                      }

                                                                      double?
                                                                          price =
                                                                          campaignController
                                                                              .itemCampaignList![index]
                                                                              .price;
                                                                      double? discount = (campaignController.itemCampaignList![index].discount ==
                                                                              0)
                                                                          ? campaignController
                                                                              .itemCampaignList![
                                                                                  index]
                                                                              .price
                                                                          : campaignController
                                                                              .itemCampaignList![index]
                                                                              .price;
                                                                      String? discountType = (campaignController.itemCampaignList![index].discount ==
                                                                              0)
                                                                          ? campaignController
                                                                              .itemCampaignList![index]
                                                                              .discountType
                                                                          : 'percent';

                                                                      double priceWithDiscountForView = PriceConverter.convertWithDiscount(
                                                                          price,
                                                                          discount,
                                                                          discountType)!;
                                                                      double priceWithDiscount = PriceConverter.convertWithDiscount(
                                                                          price,
                                                                          discount,
                                                                          discountType)!;

                                                                      return InkWell(
                                                                        onTap:
                                                                            () {
                                                                          if (true) {
                                                                            ResponsiveHelper.isMobile(context)
                                                                                ? Get.bottomSheet(
                                                                                    ProductBottomSheetWidget(product: campaignController.itemCampaignList![index], isCampaign: true),
                                                                                    backgroundColor: null,
                                                                                    isScrollControlled: true,
                                                                                  )
                                                                                : Get.dialog(
                                                                                    Dialog(child: ProductBottomSheetWidget(product: campaignController.itemCampaignList![index], isCampaign: true)),
                                                                                  );
                                                                          }
                                                                        },
                                                                        child:
                                                                            Stack(
                                                                          clipBehavior:
                                                                              Clip.none,
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
                                                                                    '${Get.find<SplashController>().configModel?.baseUrls?.campaignImageUrl}'
                                                                                    '/${campaignController.itemCampaignList![index].image.toString()}'),
                                                                              ),
                                                                            ),
                                                                            Positioned(
                                                                              bottom: 50,
                                                                              right: 10,
                                                                              child: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                                                    children: [
                                                                                      Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                                        crossAxisAlignment: CrossAxisAlignment.baseline,
                                                                                        textBaseline: TextBaseline.alphabetic,
                                                                                        // crossAxisAlignment:
                                                                                        // CrossAxisAlignment
                                                                                        //     .end,
                                                                                        children: [
                                                                                          Text(
                                                                                            "₹ ",
                                                                                            style: TextStyle(color: textColor),
                                                                                          ),
                                                                                          Text(
                                                                                            (campaignController.itemCampaignList![index].discountType == 'percent' ? percentSum2 : sum).round().toString(),
                                                                                            // campaignController.itemCampaignList![index].price!.round().toString(),
                                                                                            style: TextStyle(color: textColor, fontSize: Dimensions.fontSizeExtraLarge, fontWeight: FontWeight.w500),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      (index == 1 || campaignController.itemCampaignList![index].discount == 0)
                                                                                          ? const SizedBox()
                                                                                          : Row(
                                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                                              crossAxisAlignment: CrossAxisAlignment.baseline,
                                                                                              textBaseline: TextBaseline.alphabetic,
                                                                                              children: [
                                                                                                Text(
                                                                                                  "₹ ",
                                                                                                  style: TextStyle(
                                                                                                    color: textColor2,
                                                                                                    fontSize: Dimensions.fontSizeSmall,
                                                                                                  ),
                                                                                                ),
                                                                                                Text(
                                                                                                  campaignController.itemCampaignList![index].price!.round().toString(),
                                                                                                  style: TextStyle(color: textColor2, decoration: TextDecoration.lineThrough, decorationColor: textColor2, fontSize: Dimensions.fontSizeDefault),
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
                                                                                  SizedBox(
                                                                                    width: 100,
                                                                                    child: Text(
                                                                                      campaignController.itemCampaignList![index].restaurantName!,
                                                                                      softWrap: true,
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                      style: TextStyle(color: textColor),
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: 100,
                                                                                    child: Text(
                                                                                      "${campaignController.itemCampaignList![index].deliveryTime} Delivery",
                                                                                      softWrap: true,
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                      style: TextStyle(color: textColor, fontSize: Dimensions.paddingSizeSmall, fontFamily: "Poppins"),
                                                                                    ),
                                                                                  ),
                                                                                  Row(
                                                                                    children: [
                                                                                      RatingBar(
                                                                                        unSeletedStar: starColor,
                                                                                        rating: campaignController.itemCampaignList![index].avgRating,
                                                                                        starColor: starColor,
                                                                                        ratingCount: campaignController.itemCampaignList![index].ratingCount,
                                                                                        size: 14,
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),

                                                                            Positioned(
                                                                              top: Dimensions.paddingSizeDefault,
                                                                              left: 10,
                                                                              child: SizedBox(
                                                                                width: 100,
                                                                                child: Text(
                                                                                  maxLines: 2,
                                                                                  campaignController.itemCampaignList![index].name!,
                                                                                  softWrap: true,
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  style: TextStyle(fontFamily: "Poppins", fontSize: Dimensions.fontSizeLarge, fontWeight: FontWeight.w600, color: textColor),
                                                                                ),
                                                                              ),
                                                                            ),

                                                                            ///  offer
                                                                            campaignController.itemCampaignList![index].discount != 0
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
                                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                    children: [
                                                                                                      (campaignController.itemCampaignList![index]!.discountType == 'percent')
                                                                                                          ? Row(
                                                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                                                              children: [
                                                                                                                Text(
                                                                                                                  '${campaignController.itemCampaignList![index]!.discount!.round()}',
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
                                                                                                                  '${campaignController.itemCampaignList![index]!.discount!.round()}',
                                                                                                                  style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).cardColor, fontWeight: FontWeight.bold),
                                                                                                                ),
                                                                                                              ],
                                                                                                            ),
                                                                                                      Text(
                                                                                                        style: TextStyle(color: Get.theme.cardColor, fontSize: Dimensions.fontSizeExtraSmall),
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

                                                            /// This is recently mom chef ///

                                                            _isLogin
                                                                ? const PopularRestaurantsViewWidget(
                                                                    isRecentlyViewed:
                                                                        true)
                                                                : const SizedBox(),

                                                            productController
                                                                        .popularProductList ==
                                                                    null
                                                                ? const SizedBox()
                                                                : const SizedBox(
                                                                    height: 20,
                                                                  ),

                                                            productController
                                                                        .popularProductList !=
                                                                    null
                                                                ? productController
                                                                            .popularProductList!
                                                                            .length >=
                                                                        6
                                                                    ? const Center(
                                                                        child:
                                                                            Text(
                                                                        "POPULAR FOOD",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                18,
                                                                            color: Color(
                                                                                0xff090018),
                                                                            fontFamily:
                                                                                "Poppins",
                                                                            fontWeight:
                                                                                FontWeight.w700),
                                                                      ))
                                                                    : const SizedBox()
                                                                : const SizedBox(),

                                                            productController
                                                                        .popularProductList !=
                                                                    null
                                                                ? productController
                                                                            .popularProductList!
                                                                            .length >=
                                                                        6
                                                                    ? Align(
                                                                        alignment:
                                                                            Alignment
                                                                                .centerRight,
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .symmetric(
                                                                              horizontal: 12.0),
                                                                          child:
                                                                              InkWell(
                                                                            onTap:
                                                                                () {
                                                                              Get.toNamed(RouteHelper.getPopularFoodRoute(true));
                                                                            },
                                                                            child:
                                                                                Text(
                                                                              "View all",
                                                                              style: TextStyle(fontSize: Dimensions.fontSizeSmall),
                                                                              textAlign: TextAlign.right,
                                                                            ),
                                                                          ),
                                                                        ))
                                                                    : const SizedBox()
                                                                : const SizedBox(),
                                                            productController
                                                                        .popularProductList !=
                                                                    null
                                                                ? productController
                                                                            .popularProductList!
                                                                            .length >=
                                                                        6
                                                                    ? SizedBox(
                                                                        height:
                                                                            350,
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                18.0,
                                                                          ),
                                                                          child:
                                                                              PageView(
                                                                            controller:
                                                                                _controller,
                                                                            onPageChanged:
                                                                                (index) {
                                                                              setState(() {
                                                                                _currentIndexPage = index;
                                                                              });
                                                                            },
                                                                            children: [
                                                                              productController.popularProductList!.length >= 1
                                                                                  ? ListView.builder(
                                                                                      physics: const NeverScrollableScrollPhysics(),
                                                                                      itemCount: productController.popularProductList!.length == 1 ? 1 : 2,
                                                                                      itemBuilder: (context, index) {
                                                                                        double? price = productController.popularProductList![index].price;
                                                                                        double? discount = (productController.popularProductList![index].restaurantDiscount == 0) ? productController.popularProductList![index].discount : productController.popularProductList![index].restaurantDiscount;
                                                                                        String? discountType = (productController.popularProductList![index].restaurantDiscount == 0) ? productController.popularProductList![index].discountType : 'percent';

                                                                                        double priceWithDiscountForView = PriceConverter.convertWithDiscount(price, discount, discountType)!;
                                                                                        double priceWithDiscount = PriceConverter.convertWithDiscount(price, discount, discountType)!;
                                                                                        return Padding(
                                                                                          padding: const EdgeInsets.only(bottom: 40.0, right: 10),
                                                                                          child: Column(
                                                                                            children: [
                                                                                              InkWell(
                                                                                                onTap: () {
                                                                                                  if (productController.popularProductList![index].restaurantStatus == 1) {
                                                                                                    ResponsiveHelper.isMobile(context)
                                                                                                        ? Get.bottomSheet(
                                                                                                            ProductBottomSheetWidget(
                                                                                                              product: productController.popularProductList![index],
                                                                                                            ),
                                                                                                            backgroundColor: Colors.transparent,
                                                                                                            isScrollControlled: true,
                                                                                                          )
                                                                                                        : Get.dialog(
                                                                                                            Dialog(child: ProductBottomSheetWidget(product: productController.popularProductList![index])),
                                                                                                          );
                                                                                                  } else {
                                                                                                    showCustomSnackBar('product_is_not_available'.tr);
                                                                                                  }
                                                                                                },
                                                                                                child: Row(
                                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                  children: [
                                                                                                    Stack(
                                                                                                      clipBehavior: Clip.none,
                                                                                                      children: [
                                                                                                        Container(
                                                                                                          height: 120,
                                                                                                          width: 128,
                                                                                                          decoration: BoxDecoration(
                                                                                                            border: Border.all(color: const Color(0xffE0E0E0)),
                                                                                                            borderRadius: BorderRadius.circular(
                                                                                                              Dimensions.paddingSizeDefault,
                                                                                                            ),
                                                                                                          ),
                                                                                                          child: Center(
                                                                                                            child: Image.network(
                                                                                                              '${Get.find<SplashController>().configModel?.baseUrls?.productImageUrl}'
                                                                                                              '/${productController.popularProductList![index].image}',
                                                                                                              height: 72,
                                                                                                              width: 89,
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                        Positioned(
                                                                                                            right: 5,
                                                                                                            top: 5,
                                                                                                            child: GetBuilder<FavouriteController>(builder: (favouriteController) {
                                                                                                              bool isWished = favouriteController.wishProductIdList.contains(productController.popularProductList![index].id);
                                                                                                              return CustomFavouriteWidget(
                                                                                                                product: productController.popularProductList![index],
                                                                                                                isRestaurant: false,
                                                                                                                isWished: isWished,
                                                                                                              );
                                                                                                            })),
                                                                                                        reviewController.reviewedProductList![index].discount == 0
                                                                                                            ? const SizedBox()
                                                                                                            : Positioned(
                                                                                                                top: -20,
                                                                                                                left: 0,
                                                                                                                child: Stack(
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
                                                                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                                            children: [
                                                                                                                              (reviewController.reviewedProductList![index].discountType == 'percent')
                                                                                                                                  ? Row(
                                                                                                                                      mainAxisAlignment: MainAxisAlignment.center,
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
                                                                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                                                                      crossAxisAlignment: CrossAxisAlignment.baseline,
                                                                                                                                      textBaseline: TextBaseline.alphabetic,
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
                                                                                                                                style: TextStyle(color: Get.theme.cardColor, fontSize: Dimensions.fontSizeExtraSmall),
                                                                                                                                'off',
                                                                                                                              )
                                                                                                                            ],
                                                                                                                          ),
                                                                                                                        )),
                                                                                                                  ],
                                                                                                                ),
                                                                                                              ),
                                                                                                      ],
                                                                                                    ),
                                                                                                    const SizedBox(
                                                                                                      width: 20,
                                                                                                    ),
                                                                                                    Expanded(
                                                                                                      child: Column(
                                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                        children: [
                                                                                                          Text(
                                                                                                            productController.popularProductList![index].name.toString(),
                                                                                                            style: TextStyle(fontSize: Dimensions.fontSizeDefault, fontWeight: FontWeight.w600),
                                                                                                          ),
                                                                                                          Text(
                                                                                                            productController.popularProductList![index].restaurantName.toString(),
                                                                                                            maxLines: 1,
                                                                                                            style: TextStyle(fontSize: Dimensions.fontSizeSmall, fontWeight: FontWeight.w400, color: const Color(0xff524A61)),
                                                                                                          ),
                                                                                                          const SizedBox(
                                                                                                            height: 20,
                                                                                                          ),
                                                                                                          // Text("30 Min Delivery"),
                                                                                                          Text(
                                                                                                            "${productController.popularProductList![index].deliveryTime} delivery",
                                                                                                            style: TextStyle(fontSize: Dimensions.fontSizeSmall, color: const Color(0xff090018)),
                                                                                                          ),
                                                                                                          RatingBar(size: 12, rating: productController.popularProductList![index].avgRating, ratingCount: productController.popularProductList![index].ratingCount)
                                                                                                        ],
                                                                                                      ),
                                                                                                    ),
                                                                                                    Column(
                                                                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                                                                      children: [
                                                                                                        SizedBox(
                                                                                                          height: productController.popularProductList![index].discount == 0 ? 55 : Dimensions.paddingSizeExtraOverLarge,
                                                                                                        ),
                                                                                                        Row(
                                                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                                                          crossAxisAlignment: CrossAxisAlignment.baseline,
                                                                                                          textBaseline: TextBaseline.alphabetic,
                                                                                                          children: [
                                                                                                            Text(
                                                                                                              '₹',
                                                                                                              style: robotoBold.copyWith(
                                                                                                                fontSize: Dimensions.fontSizeExtraSmall,
                                                                                                                fontWeight: FontWeight.bold,
                                                                                                              ),
                                                                                                            ),
                                                                                                            Text(
                                                                                                              priceWithDiscount.round().toString(),
                                                                                                              style: robotoBold.copyWith(
                                                                                                                fontSize: Dimensions.fontSizeExtraLarge,
                                                                                                                fontWeight: FontWeight.bold,
                                                                                                              ),
                                                                                                            ),
                                                                                                          ],
                                                                                                        ),
                                                                                                        Row(
                                                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                                                          crossAxisAlignment: CrossAxisAlignment.baseline,
                                                                                                          textBaseline: TextBaseline.alphabetic,
                                                                                                          children: [
                                                                                                            productController.popularProductList![index].discount == 0
                                                                                                                ? const SizedBox()
                                                                                                                : Text(
                                                                                                                    '₹',
                                                                                                                    style: robotoBold.copyWith(
                                                                                                                      fontSize: Dimensions.fontSizeExtraSmall,
                                                                                                                      color: Get.theme.disabledColor,
                                                                                                                      fontWeight: FontWeight.bold,
                                                                                                                    ),
                                                                                                                  ),
                                                                                                            productController.popularProductList![index].discount == 0
                                                                                                                ? const SizedBox()
                                                                                                                : Text(
                                                                                                                    productController.popularProductList![index].price.toString(),
                                                                                                                    style: robotoBold.copyWith(
                                                                                                                      decoration: TextDecoration.lineThrough,
                                                                                                                      color: Get.theme.disabledColor,
                                                                                                                      fontSize: Dimensions.fontSizeLarge,
                                                                                                                      fontWeight: FontWeight.bold,
                                                                                                                    ),
                                                                                                                  ),
                                                                                                          ],
                                                                                                        ),
                                                                                                        const SizedBox(
                                                                                                          height: 5,
                                                                                                        ),
                                                                                                        Container(
                                                                                                          height: 32,
                                                                                                          width: 32,
                                                                                                          // padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                                                                                          decoration: BoxDecoration(
                                                                                                            color: Get.theme.cardColor,
                                                                                                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                                                                                            boxShadow: const [
                                                                                                              BoxShadow(
                                                                                                                color: Colors.grey,
                                                                                                                spreadRadius: 0,
                                                                                                                blurRadius: 6,
                                                                                                                offset: Offset(0, 4), // Offset on Y-axis for bottom-side shadow
                                                                                                              ),
                                                                                                            ],
                                                                                                          ),
                                                                                                          child: const Center(
                                                                                                            child: Icon(Icons.add),
                                                                                                          ),
                                                                                                        )
                                                                                                      ],
                                                                                                    )
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        );
                                                                                      },
                                                                                    )
                                                                                  : const SizedBox(),
                                                                              productController.popularProductList!.length >= 3
                                                                                  ? ListView.builder(
                                                                                      physics: const NeverScrollableScrollPhysics(),
                                                                                      itemCount: (productController.popularProductList!.length < 4 && productController.popularProductList!.length == 3) ? 1 : 2,
                                                                                      itemBuilder: (context, index) {
                                                                                        double? price = productController.popularProductList![index + 2].price;
                                                                                        double? discount = (productController.popularProductList![index + 2].restaurantDiscount == 0) ? productController.popularProductList![index + 2].discount : productController.popularProductList![index + 2].restaurantDiscount;
                                                                                        String? discountType = (productController.popularProductList![index + 2].restaurantDiscount == 0) ? productController.popularProductList![index + 2].discountType : 'percent';

                                                                                        double priceWithDiscountForView = PriceConverter.convertWithDiscount(price, discount, discountType)!;
                                                                                        double priceWithDiscount = PriceConverter.convertWithDiscount(price, discount, discountType)!;
                                                                                        return Padding(
                                                                                          padding: const EdgeInsets.only(bottom: 40.0, right: 10),
                                                                                          child: Column(
                                                                                            children: [
                                                                                              InkWell(
                                                                                                onTap: () {
                                                                                                  if (productController.popularProductList![index + 2].restaurantStatus == 1) {
                                                                                                    ResponsiveHelper.isMobile(context)
                                                                                                        ? Get.bottomSheet(
                                                                                                            ProductBottomSheetWidget(
                                                                                                              product: productController.popularProductList![index + 2],
                                                                                                            ),
                                                                                                            backgroundColor: Colors.transparent,
                                                                                                            isScrollControlled: true,
                                                                                                          )
                                                                                                        : Get.dialog(
                                                                                                            Dialog(child: ProductBottomSheetWidget(product: productController.popularProductList![index + 2])),
                                                                                                          );
                                                                                                  } else {
                                                                                                    showCustomSnackBar('product_is_not_available'.tr);
                                                                                                  }
                                                                                                },
                                                                                                child: Row(
                                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                  children: [
                                                                                                    Stack(
                                                                                                      clipBehavior: Clip.none,
                                                                                                      children: [
                                                                                                        Container(
                                                                                                          height: 120,
                                                                                                          width: 128,
                                                                                                          decoration: BoxDecoration(
                                                                                                            border: Border.all(color: const Color(0xffE0E0E0)),
                                                                                                            borderRadius: BorderRadius.circular(
                                                                                                              Dimensions.paddingSizeDefault,
                                                                                                            ),
                                                                                                          ),
                                                                                                          child: Center(
                                                                                                            child: Image.network(
                                                                                                              '${Get.find<SplashController>().configModel?.baseUrls?.productImageUrl}'
                                                                                                              '/${productController.popularProductList![index + 2].image}',
                                                                                                              height: 72,
                                                                                                              width: 89,
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                        Positioned(
                                                                                                            right: 5,
                                                                                                            top: 5,
                                                                                                            child: GetBuilder<FavouriteController>(builder: (favouriteController) {
                                                                                                              bool isWished = favouriteController.wishProductIdList.contains(productController.popularProductList![index + 2].id);
                                                                                                              return CustomFavouriteWidget(
                                                                                                                product: productController.popularProductList![index + 2],
                                                                                                                isRestaurant: false,
                                                                                                                isWished: isWished,
                                                                                                              );
                                                                                                            })),
                                                                                                        reviewController.reviewedProductList![index + 2].discount == 0
                                                                                                            ? const SizedBox()
                                                                                                            : Positioned(
                                                                                                                top: -20,
                                                                                                                left: 0,
                                                                                                                child: Stack(
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
                                                                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                                            children: [
                                                                                                                              (reviewController.reviewedProductList![index + 2].discountType == 'percent')
                                                                                                                                  ? Row(
                                                                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                                                                      children: [
                                                                                                                                        Text(
                                                                                                                                          '${reviewController.reviewedProductList![index + 2].discount!.round()}',
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
                                                                                                                                          '${reviewController.reviewedProductList![index + 2].discount!.round()}',
                                                                                                                                          style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).cardColor, fontWeight: FontWeight.bold),
                                                                                                                                        ),
                                                                                                                                      ],
                                                                                                                                    ),
                                                                                                                              Text(
                                                                                                                                style: TextStyle(color: Get.theme.cardColor, fontSize: Dimensions.fontSizeExtraSmall),
                                                                                                                                'off',
                                                                                                                              )
                                                                                                                            ],
                                                                                                                          ),
                                                                                                                        )),
                                                                                                                  ],
                                                                                                                ),
                                                                                                              ),
                                                                                                      ],
                                                                                                    ),
                                                                                                    const SizedBox(
                                                                                                      width: 20,
                                                                                                    ),
                                                                                                    Expanded(
                                                                                                      child: Column(
                                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                        children: [
                                                                                                          Text(
                                                                                                            productController.popularProductList![index + 2].name.toString(),
                                                                                                            style: TextStyle(fontSize: Dimensions.fontSizeDefault, fontWeight: FontWeight.w600),
                                                                                                          ),
                                                                                                          Text(
                                                                                                            productController.popularProductList![index + 2].restaurantName.toString(),
                                                                                                            maxLines: 1,
                                                                                                            style: TextStyle(fontSize: Dimensions.fontSizeSmall, fontWeight: FontWeight.w400, color: const Color(0xff524A61)),
                                                                                                          ),
                                                                                                          const SizedBox(
                                                                                                            height: 20,
                                                                                                          ),
                                                                                                          // Text("30 Min Delivery"),
                                                                                                          Text(
                                                                                                            "${productController.popularProductList![index + 2].deliveryTime} delivery",
                                                                                                            style: TextStyle(fontSize: Dimensions.fontSizeSmall, color: const Color(0xff090018)),
                                                                                                          ),
                                                                                                          RatingBar(size: 12, rating: productController.popularProductList![index + 2].avgRating, ratingCount: productController.popularProductList![index + 2].ratingCount)
                                                                                                        ],
                                                                                                      ),
                                                                                                    ),
                                                                                                    Column(
                                                                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                                                                      children: [
                                                                                                        SizedBox(
                                                                                                          height: productController.popularProductList![index + 2].discount == 0 ? 55 : Dimensions.paddingSizeExtraOverLarge,
                                                                                                        ),
                                                                                                        Row(
                                                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                                                          crossAxisAlignment: CrossAxisAlignment.baseline,
                                                                                                          textBaseline: TextBaseline.alphabetic,
                                                                                                          children: [
                                                                                                            Text(
                                                                                                              '₹',
                                                                                                              style: robotoBold.copyWith(
                                                                                                                fontSize: Dimensions.fontSizeExtraSmall,
                                                                                                                fontWeight: FontWeight.bold,
                                                                                                              ),
                                                                                                            ),
                                                                                                            Text(
                                                                                                              priceWithDiscount.round().toString(),
                                                                                                              style: robotoBold.copyWith(
                                                                                                                fontSize: Dimensions.fontSizeExtraLarge,
                                                                                                                fontWeight: FontWeight.bold,
                                                                                                              ),
                                                                                                            ),
                                                                                                          ],
                                                                                                        ),
                                                                                                        Row(
                                                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                                                          crossAxisAlignment: CrossAxisAlignment.baseline,
                                                                                                          textBaseline: TextBaseline.alphabetic,
                                                                                                          children: [
                                                                                                            productController.popularProductList![index + 2].discount == 0
                                                                                                                ? const SizedBox()
                                                                                                                : Text(
                                                                                                                    '₹',
                                                                                                                    style: robotoBold.copyWith(
                                                                                                                      fontSize: Dimensions.fontSizeExtraSmall,
                                                                                                                      color: Get.theme.disabledColor,
                                                                                                                      fontWeight: FontWeight.bold,
                                                                                                                    ),
                                                                                                                  ),
                                                                                                            productController.popularProductList![index + 2].discount == 0
                                                                                                                ? const SizedBox()
                                                                                                                : Text(
                                                                                                                    productController.popularProductList![index + 2].price.toString(),
                                                                                                                    style: robotoBold.copyWith(
                                                                                                                      decoration: TextDecoration.lineThrough,
                                                                                                                      color: Get.theme.disabledColor,
                                                                                                                      fontSize: Dimensions.fontSizeLarge,
                                                                                                                      fontWeight: FontWeight.bold,
                                                                                                                    ),
                                                                                                                  ),
                                                                                                          ],
                                                                                                        ),
                                                                                                        const SizedBox(
                                                                                                          height: 5,
                                                                                                        ),
                                                                                                        Container(
                                                                                                          height: 32,
                                                                                                          width: 32,
                                                                                                          // padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                                                                                          decoration: BoxDecoration(
                                                                                                            color: Get.theme.cardColor,
                                                                                                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                                                                                            boxShadow: const [
                                                                                                              BoxShadow(
                                                                                                                color: Colors.grey,
                                                                                                                spreadRadius: 0,
                                                                                                                blurRadius: 6,
                                                                                                                offset: Offset(0, 4), // Offset on Y-axis for bottom-side shadow
                                                                                                              ),
                                                                                                            ],
                                                                                                          ),
                                                                                                          child: const Center(
                                                                                                            child: Icon(Icons.add),
                                                                                                          ),
                                                                                                        )
                                                                                                      ],
                                                                                                    )
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        );
                                                                                      },
                                                                                    )
                                                                                  : const SizedBox(),
                                                                              productController.popularProductList!.length >= 5
                                                                                  ? ListView.builder(
                                                                                      physics: const NeverScrollableScrollPhysics(),
                                                                                      itemCount: (productController.popularProductList!.length < 6 && productController.popularProductList!.length == 5) ? 1 : 2,
                                                                                      itemBuilder: (context, index) {
                                                                                        double? price = productController.popularProductList![index + 4].price;
                                                                                        double? discount = (productController.popularProductList![index + 4].restaurantDiscount == 0) ? productController.popularProductList![index + 4].discount : productController.popularProductList![index + 4].restaurantDiscount;
                                                                                        String? discountType = (productController.popularProductList![index + 4].restaurantDiscount == 0) ? productController.popularProductList![index + 4].discountType : 'percent';

                                                                                        double priceWithDiscountForView = PriceConverter.convertWithDiscount(price, discount, discountType)!;
                                                                                        double priceWithDiscount = PriceConverter.convertWithDiscount(price, discount, discountType)!;
                                                                                        return Padding(
                                                                                          padding: const EdgeInsets.only(bottom: 40.0, right: 10),
                                                                                          child: Column(
                                                                                            children: [
                                                                                              InkWell(
                                                                                                onTap: () {
                                                                                                  if (productController.popularProductList![index + 4].restaurantStatus == 1) {
                                                                                                    ResponsiveHelper.isMobile(context)
                                                                                                        ? Get.bottomSheet(
                                                                                                            ProductBottomSheetWidget(
                                                                                                              product: productController.popularProductList![index + 4],
                                                                                                            ),
                                                                                                            backgroundColor: Colors.transparent,
                                                                                                            isScrollControlled: true,
                                                                                                          )
                                                                                                        : Get.dialog(
                                                                                                            Dialog(child: ProductBottomSheetWidget(product: productController.popularProductList![index + 4])),
                                                                                                          );
                                                                                                  } else {
                                                                                                    showCustomSnackBar('product_is_not_available'.tr);
                                                                                                  }
                                                                                                },
                                                                                                child: Row(
                                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                  children: [
                                                                                                    Stack(
                                                                                                      clipBehavior: Clip.none,
                                                                                                      children: [
                                                                                                        Container(
                                                                                                          height: 120,
                                                                                                          width: 128,
                                                                                                          decoration: BoxDecoration(
                                                                                                            border: Border.all(color: const Color(0xffE0E0E0)),
                                                                                                            borderRadius: BorderRadius.circular(
                                                                                                              Dimensions.paddingSizeDefault,
                                                                                                            ),
                                                                                                          ),
                                                                                                          child: Center(
                                                                                                            child: Image.network(
                                                                                                              '${Get.find<SplashController>().configModel?.baseUrls?.productImageUrl}'
                                                                                                              '/${productController.popularProductList![index + 4].image}',
                                                                                                              height: 72,
                                                                                                              width: 89,
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                        Positioned(
                                                                                                            right: 5,
                                                                                                            top: 5,
                                                                                                            child: GetBuilder<FavouriteController>(builder: (favouriteController) {
                                                                                                              bool isWished = favouriteController.wishProductIdList.contains(productController.popularProductList![index + 4].id);
                                                                                                              return CustomFavouriteWidget(
                                                                                                                product: productController.popularProductList![index + 4],
                                                                                                                isRestaurant: false,
                                                                                                                isWished: isWished,
                                                                                                              );
                                                                                                            })),
                                                                                                        reviewController.reviewedProductList![index + 4].discount == 0
                                                                                                            ? const SizedBox()
                                                                                                            : Positioned(
                                                                                                                top: -20,
                                                                                                                left: 0,
                                                                                                                child: Stack(
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
                                                                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                                            children: [
                                                                                                                              (reviewController.reviewedProductList![index + 4].discountType == 'percent')
                                                                                                                                  ? Row(
                                                                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                                                                      children: [
                                                                                                                                        Text(
                                                                                                                                          '${reviewController.reviewedProductList![index + 4].discount!.round()}',
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
                                                                                                                                          '${reviewController.reviewedProductList![index + 4].discount!.round()}',
                                                                                                                                          style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).cardColor, fontWeight: FontWeight.bold),
                                                                                                                                        ),
                                                                                                                                      ],
                                                                                                                                    ),
                                                                                                                              Text(
                                                                                                                                style: TextStyle(color: Get.theme.cardColor, fontSize: Dimensions.fontSizeExtraSmall),
                                                                                                                                'off',
                                                                                                                              )
                                                                                                                            ],
                                                                                                                          ),
                                                                                                                        )),
                                                                                                                  ],
                                                                                                                ),
                                                                                                              ),
                                                                                                      ],
                                                                                                    ),
                                                                                                    const SizedBox(
                                                                                                      width: 20,
                                                                                                    ),
                                                                                                    Expanded(
                                                                                                      child: Column(
                                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                        children: [
                                                                                                          Text(
                                                                                                            productController.popularProductList![index + 4].name.toString(),
                                                                                                            style: TextStyle(fontSize: Dimensions.fontSizeDefault, fontWeight: FontWeight.w600),
                                                                                                          ),
                                                                                                          Text(
                                                                                                            productController.popularProductList![index + 4].restaurantName.toString(),
                                                                                                            maxLines: 1,
                                                                                                            style: TextStyle(fontSize: Dimensions.fontSizeSmall, fontWeight: FontWeight.w400, color: const Color(0xff524A61)),
                                                                                                          ),
                                                                                                          const SizedBox(
                                                                                                            height: 20,
                                                                                                          ),
                                                                                                          // Text("30 Min Delivery"),
                                                                                                          Text(
                                                                                                            "${productController.popularProductList![index + 4].deliveryTime} delivery",
                                                                                                            style: TextStyle(fontSize: Dimensions.fontSizeSmall, color: const Color(0xff090018)),
                                                                                                          ),
                                                                                                          RatingBar(size: 12, rating: productController.popularProductList![index + 2].avgRating, ratingCount: productController.popularProductList![index + 4].ratingCount)
                                                                                                        ],
                                                                                                      ),
                                                                                                    ),
                                                                                                    Column(
                                                                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                                                                      children: [
                                                                                                        SizedBox(
                                                                                                          height: productController.popularProductList![index + 4].discount == 0 ? 55 : Dimensions.paddingSizeExtraOverLarge,
                                                                                                        ),
                                                                                                        Row(
                                                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                                                          crossAxisAlignment: CrossAxisAlignment.baseline,
                                                                                                          textBaseline: TextBaseline.alphabetic,
                                                                                                          children: [
                                                                                                            Text(
                                                                                                              '₹',
                                                                                                              style: robotoBold.copyWith(
                                                                                                                fontSize: Dimensions.fontSizeExtraSmall,
                                                                                                                fontWeight: FontWeight.bold,
                                                                                                              ),
                                                                                                            ),
                                                                                                            Text(
                                                                                                              priceWithDiscount.round().toString(),
                                                                                                              style: robotoBold.copyWith(
                                                                                                                fontSize: Dimensions.fontSizeExtraLarge,
                                                                                                                fontWeight: FontWeight.bold,
                                                                                                              ),
                                                                                                            ),
                                                                                                          ],
                                                                                                        ),
                                                                                                        Row(
                                                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                                                          crossAxisAlignment: CrossAxisAlignment.baseline,
                                                                                                          textBaseline: TextBaseline.alphabetic,
                                                                                                          children: [
                                                                                                            productController.popularProductList![index + 4].discount == 0
                                                                                                                ? const SizedBox()
                                                                                                                : Text(
                                                                                                                    '₹',
                                                                                                                    style: robotoBold.copyWith(
                                                                                                                      fontSize: Dimensions.fontSizeExtraSmall,
                                                                                                                      color: Get.theme.disabledColor,
                                                                                                                      fontWeight: FontWeight.bold,
                                                                                                                    ),
                                                                                                                  ),
                                                                                                            productController.popularProductList![index + 4].discount == 0
                                                                                                                ? const SizedBox()
                                                                                                                : Text(
                                                                                                                    productController.popularProductList![index + 4].price.toString(),
                                                                                                                    style: robotoBold.copyWith(
                                                                                                                      decoration: TextDecoration.lineThrough,
                                                                                                                      color: Get.theme.disabledColor,
                                                                                                                      fontSize: Dimensions.fontSizeLarge,
                                                                                                                      fontWeight: FontWeight.bold,
                                                                                                                    ),
                                                                                                                  ),
                                                                                                          ],
                                                                                                        ),
                                                                                                        const SizedBox(
                                                                                                          height: 5,
                                                                                                        ),
                                                                                                        Container(
                                                                                                          height: 32,
                                                                                                          width: 32,
                                                                                                          // padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                                                                                          decoration: BoxDecoration(
                                                                                                            color: Get.theme.cardColor,
                                                                                                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                                                                                            boxShadow: const [
                                                                                                              BoxShadow(
                                                                                                                color: Colors.grey,
                                                                                                                spreadRadius: 0,
                                                                                                                blurRadius: 6,
                                                                                                                offset: Offset(0, 4), // Offset on Y-axis for bottom-side shadow
                                                                                                              ),
                                                                                                            ],
                                                                                                          ),
                                                                                                          child: const Center(
                                                                                                            child: Icon(Icons.add),
                                                                                                          ),
                                                                                                        )
                                                                                                      ],
                                                                                                    )
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        );
                                                                                      },
                                                                                    )
                                                                                  : const SizedBox(),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : const SizedBox()
                                                                : const SizedBox(),

                                                            productController
                                                                        .popularProductList !=
                                                                    null
                                                                ? SizedBox(
                                                                    height: productController.popularProductList!.length >=
                                                                            6
                                                                        ? Dimensions
                                                                            .paddingSizeSmall
                                                                        : 0,
                                                                  )
                                                                : const SizedBox(),
                                                            productController
                                                                        .popularProductList !=
                                                                    null
                                                                ? productController
                                                                            .popularProductList!
                                                                            .length >=
                                                                        6
                                                                    ? Center(
                                                                        child:
                                                                            DotsIndicator(
                                                                          dotsCount:
                                                                              3,
                                                                          position:
                                                                              _currentIndexPage,
                                                                          decorator:
                                                                              DotsDecorator(
                                                                            spacing:
                                                                                const EdgeInsets.symmetric(horizontal: 3.0),
                                                                            activeColor:
                                                                                Colors.black,
                                                                            shape:
                                                                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                            size:
                                                                                const Size(20.0, 6.0),
                                                                            activeSize:
                                                                                const Size(35.0, 6.0),
                                                                            activeShape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(5.0),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : const SizedBox()
                                                                : const SizedBox(),

                                                            SizedBox(
                                                                height:
                                                                    _configModel!.mostReviewedFoods ==
                                                                            1
                                                                        ? 35
                                                                        : 0),

                                                            _configModel.mostReviewedFoods ==
                                                                    1
                                                                ? const BestReviewItemViewWidget1(
                                                                    isPopular:
                                                                        false)
                                                                : const SizedBox(),

                                                            // _configModel.mostReviewedFoods == 1 ?  const BestReviewItemViewWidget1(isPopular: false) : const SizedBox(),

                                                            ///Popular mom chef ///
                                                            _configModel.popularRestaurant ==
                                                                    1
                                                                ? const PopularRestaurantsViewWidget()
                                                                : const SizedBox(),

                                                            const CuisineViewWidget(),

                                                            /// New On MadebyMaa ///

                                                            _configModel.popularFood ==
                                                                    1
                                                                ? const NewOnMadeByMaaWidget(
                                                                    isLatest:
                                                                        true,
                                                                  )
                                                                : const SizedBox(),

                                                            const PromotionalBannerViewWidget(),
                                                          ]),
                                                    )),
                                                  ),

                                                  SliverToBoxAdapter(
                                                      child: Center(
                                                          child:
                                                              FooterViewWidget(
                                                    child: Padding(
                                                      padding: ResponsiveHelper
                                                              .isDesktop(
                                                                  context)
                                                          ? EdgeInsets.zero
                                                          : const EdgeInsets
                                                              .only(
                                                              bottom: Dimensions
                                                                  .paddingSizeOverLarge,
                                                              top: 30),
                                                      child: AllRestaurantsWidget(
                                                          scrollController:
                                                              _scrollController),
                                                    ),
                                                  ))),
                                                ],
                                              ),
                                  ),
                                ),
                              );
                            },
                          );
                        });
                      },
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;
  double height;

  SliverDelegate({required this.child, this.height = 50});

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

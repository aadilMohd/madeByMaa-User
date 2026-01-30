import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:stackfood_multivendor/features/MealByMaa/Screens/meal_by_maa.dart';
import 'package:stackfood_multivendor/features/NearByMaa/screens/near_by_maa.dart';
import 'package:stackfood_multivendor/features/cart/screens/cart_screen.dart';
import 'package:stackfood_multivendor/features/checkout/widgets/congratulation_dialogue.dart';
import 'package:stackfood_multivendor/features/dashboard/widgets/registration_success_bottom_sheet.dart';
import 'package:stackfood_multivendor/features/dashboard/widgets/welcome_dialog.dart';
import 'package:stackfood_multivendor/features/home/screens/home_screen.dart';
import 'package:stackfood_multivendor/features/order/controllers/order_controller.dart';
import 'package:stackfood_multivendor/features/order/screens/order_screen.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/order/domain/models/order_model.dart';
import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/dashboard/controllers/dashboard_controller.dart';
import 'package:stackfood_multivendor/features/dashboard/widgets/address_bottom_sheet.dart';
import 'package:stackfood_multivendor/features/dashboard/widgets/bottom_nav_item.dart';
import 'package:stackfood_multivendor/features/dashboard/widgets/running_order_view_widget.dart';
import 'package:stackfood_multivendor/features/loyalty/controllers/loyalty_controller.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/common/widgets/custom_dialog_widget.dart';
import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/models/restaurant_model.dart';
import '../../../util/images.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../restaurant/controllers/restaurant_controller.dart';

class DashboardScreen extends StatefulWidget {
  final int pageIndex;
  final bool fromSplash;

  const DashboardScreen(
      {super.key, required this.pageIndex, this.fromSplash = false});

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  PageController? _pageController;
  int _pageIndex = 0;
  late List<Widget> _screens;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
  bool _canExit = GetPlatform.isWeb ? true : false;
  late bool _isLogin;
  bool active = false;

  @override
  void initState() {
    super.initState();

    _isLogin = Get.find<AuthController>().isLoggedIn();

    _showRegistrationSuccessBottomSheet();
    _showWelcomeDialog();

    if (_isLogin) {
      if (Get.find<SplashController>().configModel!.loyaltyPointStatus == 1 &&
          Get.find<LoyaltyController>().getEarningPint().isNotEmpty &&
          !ResponsiveHelper.isDesktop(Get.context)) {
        Future.delayed(const Duration(seconds: 1),
            () => showAnimatedDialog(context, const CongratulationDialogue()));
      }
      _suggestAddressBottomSheet();
      Get.find<OrderController>().getRunningOrders(1, notify: false);
    }

    _pageIndex = widget.pageIndex;

    _pageController = PageController(initialPage: widget.pageIndex);

    _screens = [
      const HomeScreen(),
      NearByMaa(),
      // const FavouriteScreen(),
      const OrderScreen(),
      MealByMaa(),

      const CartScreen(fromNav: true),
      // const MenuScreen()
    ];

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {});
    });
  }

  _showRegistrationSuccessBottomSheet() {
    bool canShowBottomSheet =
        Get.find<DashboardController>().getRegistrationSuccessfulSharedPref();
    if (canShowBottomSheet) {
      Future.delayed(const Duration(seconds: 1), () {
        ResponsiveHelper.isDesktop(context)
            ? Get.dialog(const Dialog(child: RegistrationSuccessBottomSheet()))
                .then((value) {
                Get.find<DashboardController>()
                    .saveRegistrationSuccessfulSharedPref(false);
                Get.find<DashboardController>()
                    .saveIsRestaurantRegistrationSharedPref(false);
                setState(() {});
              })
            : showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (con) => const RegistrationSuccessBottomSheet(),
              ).then((value) {
                Get.find<DashboardController>()
                    .saveRegistrationSuccessfulSharedPref(false);
                Get.find<DashboardController>()
                    .saveIsRestaurantRegistrationSharedPref(false);
                setState(() {});
              });
      });
    }
  }

  _showWelcomeDialog() {
    bool canShowWelcome = !Get.find<DashboardController>().getWelcomeIntroStatus();
    if (canShowWelcome) {
      Future.delayed(const Duration(seconds: 1), () {
        showAnimatedDialog(context, const WelcomeDialog());
        Get.find<DashboardController>().saveWelcomeIntroStatus(true);
      });
    }
  }

  Future<void> _suggestAddressBottomSheet() async {
    active = await Get.find<DashboardController>().checkLocationActive();
    if (widget.fromSplash &&
        Get.find<DashboardController>().showLocationSuggestion &&
        active) {
      Future.delayed(const Duration(seconds: 1), () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (con) => const AddressBottomSheet(),
        ).then((value) {
          Get.find<DashboardController>().hideSuggestedLocation();
          setState(() {});
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    bool keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    return PopScope(
      canPop: Navigator.canPop(context),
      onPopInvoked: (val) {
        debugPrint('$_canExit');
        if (_pageIndex != 0) {
          _setPage(0);
        } else {
          if (_canExit) {
            if (GetPlatform.isAndroid) {
              SystemNavigator.pop();
            } else if (GetPlatform.isIOS) {
              exit(0);
            }
          }
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('back_press_again_to_exit'.tr,
                style: const TextStyle(color: Colors.white)),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.black,
            duration: const Duration(seconds: 2),
            margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          ));
          _canExit = true;

          Timer(const Duration(seconds: 2), () {
            _canExit = false;
          });
        }
      },
      child: Scaffold(
        key: _scaffoldKey,

        // floatingActionButton: GetBuilder<OrderController>(builder: (orderController) {
        //     return ResponsiveHelper.isDesktop(context) || keyboardVisible ? const SizedBox() :
        //     (orderController.showBottomSheet && orderController.runningOrderList != null && orderController.runningOrderList!.isNotEmpty && _isLogin)
        //     ? const SizedBox.shrink() : FloatingActionButton(
        //       elevation: 5,
        //       backgroundColor: _pageIndex == 2 ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
        //       onPressed: () {
        //         // _setPage(2);
        //         Get.toNamed(RouteHelper.getCartRoute());
        //       },
        //       child: CartWidget(color: _pageIndex == 2 ? Theme.of(context).cardColor : Theme.of(context).disabledColor, size: 30),
        //     );
        //   }
        // ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

        body: Stack(
          children: [
            GetBuilder<OrderController>(builder: (orderController) {
              List<OrderModel> runningOrder =
                  orderController.runningOrderList != null
                      ? orderController.runningOrderList!
                      : [];

              List<OrderModel> reversOrder = List.from(runningOrder.reversed);
              return ExpandableBottomSheet(
                background: PageView.builder(
                  controller: _pageController,
                  itemCount: _screens.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return _screens[index];
                  },
                ),
                persistentContentHeight: 100,
                onIsContractedCallback: () {
                  if (!orderController.showOneOrder) {
                    orderController.showOrders();
                  }
                },
                onIsExtendedCallback: () {
                  if (orderController.showOneOrder) {
                    orderController.showOrders();
                  }
                },
                enableToggle: true,
                expandableContent: (ResponsiveHelper.isDesktop(context) ||
                        !_isLogin ||
                        orderController.runningOrderList == null ||
                        orderController.runningOrderList!.isEmpty ||
                        !orderController.showBottomSheet)
                    ? const SizedBox()
                    : Dismissible(
                        key: UniqueKey(),
                        onDismissed: (direction) {
                          if (orderController.showBottomSheet) {
                            orderController.showRunningOrders();
                          }
                        },
                        child: RunningOrderViewWidget(
                            reversOrder: reversOrder,
                            onMoreClick: () {
                              if (orderController.showBottomSheet) {
                                orderController.showRunningOrders();
                              }
                              _setPage(3);
                            }),
                      ),
              );
            }),
            Align(
                alignment: Alignment.bottomCenter,
                child: Theme(
                  data: Theme.of(context).copyWith(canvasColor: Colors.white),
                  child: ResponsiveHelper.isDesktop(context)
                      ? const SizedBox()
                      : GetBuilder<OrderController>(builder: (orderController) {
                          return (orderController.showBottomSheet &&
                                  (orderController.runningOrderList != null &&
                                      orderController
                                          .runningOrderList!.isNotEmpty &&
                                      _isLogin))
                              ? const SizedBox()
                              : Padding(
                                  padding: const EdgeInsets.only(
                                    left: 16.0,
                                    right: 16.0,
                                    bottom: 20.0,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.radiusExtraLarge),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.3),
                                          spreadRadius: 5,
                                          blurRadius: 8,
                                          offset: Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Container(
                                        color: Colors.white,
                                        height: 70,
                                        child: Row(
                                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            BottomNavItem(
                                              title: 'home'.tr,
                                              selectedIcon:
                                                  Images.homeDashboard,
                                              unSelectedIcon:
                                                  Images.homeDashboard,
                                              isSelected: _pageIndex == 0,
                                              onTap: () async {
                                                Get.find<RestaurantController>()
                                                    .resetForHome();
                                                await Get.find<
                                                        RestaurantController>()
                                                    .getRestaurantList(1, false,
                                                        isSix: true);
                                                _setPage(0);
                                              },
                                            ),
                                            BottomNavItem(
                                              title: 'near_by_maa'.tr,
                                              selectedIcon:
                                                  Images.locationDashboard,
                                              unSelectedIcon:
                                                  Images.locationDashboard,
                                              isSelected: _pageIndex == 1,
                                              onTap: () => _setPage(1),
                                            ),
                                            BottomNavItem(
                                              title: 'orders'.tr,
                                              selectedIcon:
                                                  Images.orderDashboard,
                                              unSelectedIcon:
                                                  Images.orderDashboard,
                                              isSelected: _pageIndex == 2,
                                              onTap: () => _setPage(2),
                                            ),
                                            BottomNavItem(
                                              title: 'meal_by_maa'.tr,
                                              selectedIcon:
                                                  Images.spoonDashBoard,
                                              unSelectedIcon:
                                                  Images.spoonDashBoard,
                                              isSelected: _pageIndex == 3,
                                              onTap: () => _setPage(3),
                                            ),
                                            BottomNavItem(
                                              cart: true,
                                              title: 'cart'.tr,
                                              selectedIcon:
                                                  Images.cartDashboard,
                                              unSelectedIcon:
                                                  Images.cartDashboard,
                                              isSelected: _pageIndex == 4,
                                              onTap: () => _setPage(4),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                        }),
                ))
          ],
        ),
      ),
    );
  }

  void _setPage(int pageIndex) async {
    setState(() {
      _pageController!.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
    });
  }
}

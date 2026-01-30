import 'package:flutter/cupertino.dart';
import 'package:stackfood_multivendor/features/order/controllers/order_controller.dart';
import 'package:stackfood_multivendor/features/order/widgets/guest_track_order_input_view_widget.dart';
import 'package:stackfood_multivendor/features/order/widgets/order_view_widget.dart';
import 'package:stackfood_multivendor/helper/auth_helper.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/menu_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  OrderScreenState createState() => OrderScreenState();
}

class OrderScreenState extends State<OrderScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, initialIndex: 0, vsync: this);
    initCall();
  }

  void initCall() {
    if (AuthHelper.isLoggedIn()) {
      Get.find<OrderController>().getRunningOrders(1, notify: false);
      Get.find<OrderController>()
          .getRunningSubscriptionOrders(1, notify: false);
      Get.find<OrderController>().getHistoryOrders(1, notify: false);
      // Get.find<OrderController>().getSubscriptions(1, notify: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = AuthHelper.isLoggedIn();
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: true,
      //   leading: IconButton(
      //     onPressed: () {
      //       Get.back();
      //     },
      //     icon: const Icon(Icons.arrow_back_outlined),
      //   ),
      //   centerTitle: true,
      //   title: Text('orders'.tr,style:  TextStyle(fontWeight: FontWeight.w600,fontSize: Dimensions.fontSizeExtraLarge),),
      //   flexibleSpace: Container(
      //     decoration: BoxDecoration(
      //       gradient: LinearGradient(
      //         colors: [
      //           const Color(0xfffa9b66).withOpacity(0.5),
      //           Colors.white
      //         ], // Define your gradient colors here
      //         begin: Alignment.topCenter,
      //         end: Alignment.bottomCenter,
      //       ),
      //     ),
      //   ),
      // ),
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: const Color(0xffFFEACC),
      ),
      // appBar: CustomAppBarWidget(
      //     title: 'orders'.tr,
      //     isBackButtonExist: ResponsiveHelper.isDesktop(context)),
      // endDrawer: const MenuDrawerWidget(),
      endDrawerEnableOpenDragGesture: false,
      body: isLoggedIn
          ? GetBuilder<OrderController>(
              builder: (orderController) {
                return Column(children: [
                  Container(
                     height: 40,
                      padding: const EdgeInsets.only(
                          left: Dimensions.paddingSizeSmall,
                          right: Dimensions.paddingSizeSmall,),
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xffFFEACC), Colors.white])),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // InkWell(
                          //   onTap: () {
                          //     Get.back();
                          //   },
                          //   child: const Icon(Icons.arrow_back_outlined),
                          // ),
                          Expanded(
                          child: Align(
                              alignment: Alignment.topCenter,
                              child: Text('orders'.tr,style:  TextStyle(fontWeight: FontWeight.w600,fontSize: Dimensions.fontSizeExtraLarge),)),
                        )
                      ],),
                  ),


                  Container(
                    color: ResponsiveHelper.isDesktop(context)
                        ? Theme.of(context).primaryColor.withOpacity(0.1)
                        : Colors.transparent,
                    child: Column(
                      children: [
                        ResponsiveHelper.isDesktop(context)
                            ? Center(
                                child: Padding(
                                padding: const EdgeInsets.only(
                                    top: Dimensions.paddingSizeSmall),
                                child:
                                    Text('my_orders'.tr, style: robotoMedium),
                              ))
                            : const SizedBox(),
                        Center(
                          child: SizedBox(
                            width: Dimensions.webMaxWidth,
                            child: Align(
                              alignment: ResponsiveHelper.isDesktop(context)
                                  ? Alignment.centerLeft
                                  : Alignment.center,
                              child: Container(
                                height: 60,
                                width: ResponsiveHelper.isDesktop(context)
                                    ? 350
                                    : Dimensions.webMaxWidth,
                                color: ResponsiveHelper.isDesktop(context)
                                    ? Colors.transparent
                                    : Theme.of(context).cardColor,
                                child: TabBar(
                                  onTap: (int n){
                                    setState(() {

                                    });
                                  },
                                  controller: _tabController,
                                  indicatorColor:Colors.transparent,
                                  // indicatorWeight: 3,
                                  labelColor: Color(0xff090018),
                                  unselectedLabelColor:
                                      Theme.of(context).disabledColor,
                                  unselectedLabelStyle: robotoRegular.copyWith(
                                      color: Theme.of(context).disabledColor,
                                      fontSize: Dimensions.fontSizeSmall),
                                  labelStyle: robotoBold.copyWith(
                                      fontSize: Dimensions.fontSizeSmall,
                                      color: Color(0xff090018)),
                                  tabs: [
                                    Tab(
                                      child: SizedBox(
                                        height: 120,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            _tabController?.index == 0
                                                ? const Icon(
                                                    Icons.arrow_drop_down)
                                                : const SizedBox(),
                                            Text(
                                              'in_processing'.tr,
                                              style: TextStyle(
                                                  fontSize:
                                                      Dimensions.fontSizeDefault),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Tab(
                                      child: SizedBox(
                                        height: 120,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            _tabController?.index == 1
                                                ? const Icon(
                                                    Icons.arrow_drop_down)
                                                : const SizedBox(),
                                            Text(
                                              'subscription'.tr,
                                              style: TextStyle(
                                                  fontSize:
                                                      Dimensions.fontSizeDefault),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Tab(
                                      child: SizedBox(
                                        height: 120,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            _tabController?.index == 2
                                                ? const Icon(
                                                    Icons.arrow_drop_down)
                                                : const SizedBox(),
                                            Text(
                                              'history'.tr,
                                              style: TextStyle(
                                                  fontSize:
                                                      Dimensions.fontSizeDefault),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                    controller: _tabController,
                    children: const [
                      OrderViewWidget(isRunning: true),
                      OrderViewWidget(isRunning: false, isSubscription: true),
                      OrderViewWidget(isRunning: false),
                    ],
                  )),
                ]);
              },
            )
          : const GuestTrackOrderInputViewWidget(),
    );
  }
}

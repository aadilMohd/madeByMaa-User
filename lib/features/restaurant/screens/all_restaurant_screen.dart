import 'package:flutter/cupertino.dart';
import 'package:stackfood_multivendor/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor/util/app_constants.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/footer_view_widget.dart';
import 'package:stackfood_multivendor/common/widgets/menu_drawer_widget.dart';
import 'package:stackfood_multivendor/common/widgets/product_view_widget.dart';
import 'package:stackfood_multivendor/common/widgets/web_page_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../helper/route_helper.dart';
import '../../../util/images.dart';

class AllRestaurantScreen extends StatefulWidget {
  final bool isPopular;
  final bool isRecentlyViewed;
  final bool isOrderAgain;

  const AllRestaurantScreen(
      {super.key,
      required this.isPopular,
      required this.isRecentlyViewed,
      required this.isOrderAgain});

  @override
  State<AllRestaurantScreen> createState() => _AllRestaurantScreenState();
}

class _AllRestaurantScreenState extends State<AllRestaurantScreen> {
  final ScrollController scrollController = ScrollController();
  String selectedButton = 'all';

  @override
  void initState() {
    super.initState();

    if (widget.isPopular) {
      Get.find<RestaurantController>()
          .getPopularRestaurantList(false, 'all', false);
    } else if (widget.isRecentlyViewed) {
      Get.find<RestaurantController>()
          .getRecentlyViewedRestaurantList(false, 'all', false);
    } else if (widget.isOrderAgain) {
      Get.find<RestaurantController>().getOrderAgainRestaurantList(false);
    } else {
      Get.find<RestaurantController>()
          .getLatestRestaurantList(false, 'all', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RestaurantController>(builder: (restController) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xffFFEACC),
          toolbarHeight: 0,
        ),

        // appBar: AppBar(
        //   automaticallyImplyLeading: true,
        //   leading: IconButton(
        //     onPressed: () {
        //       Get.back();
        //     },
        //     icon: const Icon(Icons.arrow_back_outlined),
        //   ),
        //   centerTitle: true,
        //   title: Text(
        //     widget.isPopular
        //         ? 'popular_restaurants'.tr
        //         : widget.isRecentlyViewed
        //             ? 'recently_viewed_restaurants'.tr
        //             : widget.isOrderAgain
        //                 ? 'order_again'.tr
        //                 : '${'new_on'.tr} ${AppConstants.appName}',
        //   ),
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

        // appBar: CustomAppBarWidget(
        //   title: widget.isPopular ? 'popular_restaurants'.tr : widget.isRecentlyViewed
        //       ? 'recently_viewed_restaurants'.tr : widget.isOrderAgain ? 'order_again'.tr
        //       : '${'new_on'.tr} ${AppConstants.appName}',
        //   type: restController.type,
        //   onVegFilterTap: widget.isOrderAgain ? null : (String type) {
        //     print("ll $type");
        //     if(widget.isPopular) {
        //       restController.getPopularRestaurantList(true, type, true);
        //     }else {
        //       if(widget.isRecentlyViewed){
        //         restController.getRecentlyViewedRestaurantList(true, type, true);
        //       }else{
        //         restController.getLatestRestaurantList(true, type, true);
        //       }
        //     }
        //   },
        // ),

        // endDrawer: const MenuDrawerWidget(), endDrawerEnableOpenDragGesture: false,
        body: RefreshIndicator(
          onRefresh: () async {
            if (widget.isPopular) {
              await Get.find<RestaurantController>().getPopularRestaurantList(
                true,
                Get.find<RestaurantController>().type,
                false,
              );
            } else if (widget.isRecentlyViewed) {
              Get.find<RestaurantController>().getRecentlyViewedRestaurantList(
                  true, Get.find<RestaurantController>().type, false);
            } else if (widget.isOrderAgain) {
              Get.find<RestaurantController>()
                  .getOrderAgainRestaurantList(false);
            } else {
              await Get.find<RestaurantController>().getLatestRestaurantList(
                  true, Get.find<RestaurantController>().type, false);
            }
          },
          child: SingleChildScrollView(
              controller: scrollController,
              child: FooterViewWidget(
                child: Column(
                  children: [
                    WebScreenTitleWidget(title: 'restaurants'.tr),
                    Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(
                              Dimensions.paddingSizeDefault),
                          decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [Color(0xffFFEACC), Colors.white],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter)),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Get.back();
                                      // Navigator.pop(context);
                                    },
                                    child:
                                        const Icon(Icons.arrow_back_outlined),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () => Get.toNamed(
                                            RouteHelper.getSearchRoute()),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 30),
                                          height: 42,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Get.theme.cardColor,
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                spreadRadius: 0,
                                                blurRadius: 1,
                                                offset: const Offset(0, 1.5),
                                              ),

                                              // BoxShadow(
                                              //     color: Colors.black.withOpacity(0.3),
                                              //     offset: const Offset(0, 2),
                                              //     blurRadius: 10.0,
                                              //     spreadRadius: 0.0,
                                              //     blurStyle: BlurStyle.inner),
                                            ],
                                          ),
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                Images.search2,
                                                height: 14,
                                                width: 14,
                                              ),
                                              const SizedBox(
                                                width: Dimensions
                                                    .paddingSizeDefault,
                                              ),
                                              const Text(
                                                "Search Mom Chef",
                                                style: TextStyle(
                                                    color: Color(0xffA7A7A7)),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: Dimensions.paddingSizeSmall,
                                    ),
                                    SizedBox(
                                      width: 88,
                                      height: 27,
                                      child: Stack(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: selectedButton == 'non-veg'
                                                  ? Colors.red
                                                  : (selectedButton == "veg")
                                                      ? Colors.green
                                                      : Color(0xffE0E0E0),
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                          ),

                                          // Sliding selection indicator
                                          AnimatedAlign(
                                            duration: const Duration(
                                                milliseconds: 300),
                                            alignment:
                                                selectedButton == 'non-veg'
                                                    ? Alignment.centerLeft
                                                    : (selectedButton == 'veg'
                                                        ? Alignment.centerRight
                                                        : Alignment.center),
                                            child: Container(
                                              width: 27,
                                              height: 27,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.3),
                                                    offset: const Offset(0, 4),
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
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                // Non-Veg Button
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedButton =
                                                          'non-veg';
                                                      restController
                                                          .setNonVeg();

                                                      if (widget.isPopular) {
                                                        restController
                                                            .getPopularRestaurantList(
                                                                true,
                                                                "non_veg",
                                                                true);
                                                      } else {
                                                        if (widget
                                                            .isRecentlyViewed) {
                                                          restController
                                                              .getRecentlyViewedRestaurantList(
                                                                  true,
                                                                  "non_veg",
                                                                  true);
                                                        } else {
                                                          restController
                                                              .getLatestRestaurantList(
                                                                  true,
                                                                  "non_veg",
                                                                  true);
                                                        }
                                                      }
                                                    });
                                                  },
                                                  child: Image.asset(
                                                    Images.newNonVeg,
                                                    height: 16,
                                                    color: selectedButton ==
                                                            'non-veg'
                                                        ? null
                                                        : Color(0xffA7A7A7),
                                                  ),
                                                ),

                                                // All Button
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedButton = 'all';
                                                      if (widget.isPopular) {
                                                        restController
                                                            .getPopularRestaurantList(
                                                                true,
                                                                "all",
                                                                true);
                                                      } else {
                                                        if (widget
                                                            .isRecentlyViewed) {
                                                          restController
                                                              .getRecentlyViewedRestaurantList(
                                                                  true,
                                                                  "all",
                                                                  true);
                                                        } else {
                                                          restController
                                                              .getLatestRestaurantList(
                                                                  true,
                                                                  "all",
                                                                  true);
                                                        }
                                                      }
                                                    });
                                                  },
                                                  child: const Text(
                                                    'All',
                                                    style: TextStyle(
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
                                                      restController.setVeg();

                                                      selectedButton = 'veg';
                                                      if (widget.isPopular) {
                                                        restController
                                                            .getPopularRestaurantList(
                                                                true,
                                                                "veg",
                                                                true);
                                                      } else {
                                                        if (widget
                                                            .isRecentlyViewed) {
                                                          restController
                                                              .getRecentlyViewedRestaurantList(
                                                                  true,
                                                                  "veg",
                                                                  true);
                                                        } else {
                                                          restController
                                                              .getLatestRestaurantList(
                                                                  true,
                                                                  "veg",
                                                                  true);
                                                        }
                                                      }
                                                    });
                                                  },
                                                  child: Image.asset(
                                                    Images.vegImage,
                                                    height: 16,
                                                    color:
                                                        selectedButton == 'veg'
                                                            ? null
                                                            : Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          top: 10,
                          child: Center(
                            child: Text(
                              widget.isPopular
                                  ? 'popular_restaurants'.tr
                                  : widget.isRecentlyViewed
                                      ? 'recently_viewed_restaurants'.tr
                                      : widget.isOrderAgain
                                          ? 'order_again'.tr
                                          : '${'new_on'.tr} ${AppConstants.appName}',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: Dimensions.fontSizeExtraLarge,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),

                    // Container(
                    //   padding: const EdgeInsets.symmetric(
                    //       horizontal: Dimensions.paddingSizeDefault,
                    //       vertical: Dimensions.paddingSizeSmall),
                    //   decoration: const BoxDecoration(
                    //     color: Colors.white,
                    //     // boxShadow: [
                    //     //   BoxShadow(
                    //     //     color: Colors.black.withOpacity(0.3),
                    //     //     offset: const Offset(0, 4),
                    //     //     blurRadius: 6.0,
                    //     //     spreadRadius: 0.0,
                    //     //   ),
                    //     // ],
                    //   ),
                    //   child:  Row(
                    //     children: [
                    //       Expanded(
                    //         child: InkWell(
                    //           onTap: () =>
                    //               Get.toNamed(RouteHelper.getSearchRoute()),
                    //           child: Container(
                    //             padding: const EdgeInsets.symmetric(
                    //                 horizontal: 16),
                    //             height: 40,
                    //             width: double.infinity,
                    //             decoration: BoxDecoration(
                    //               color: Get.theme.cardColor,
                    //               borderRadius: BorderRadius.circular(30),
                    //               boxShadow: [
                    //                 BoxShadow(
                    //                     color: Colors.black.withOpacity(0.3),
                    //                     offset: const Offset(0, 1),
                    //                     blurRadius: 1.0,
                    //                     spreadRadius: 1.0,
                    //                     blurStyle: BlurStyle.outer),
                    //               ],
                    //             ),
                    //             child: Row(
                    //               children: [
                    //                 Image.asset(
                    //                   Images.search2,
                    //                   height: 14,
                    //                   width: 14,
                    //                 ),
                    //                 const SizedBox(
                    //                   width: Dimensions.paddingSizeDefault,
                    //                 ),
                    //                 const Text(
                    //                   "Search Mom Chef",
                    //                   style:
                    //                   TextStyle(color: Color(0xffA7A7A7)),
                    //                 )
                    //               ],
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //
                    //       // Expanded(
                    //       //   child: InkWell(
                    //       //     onTap: () => Get.toNamed(
                    //       //         RouteHelper
                    //       //             .getSearchRoute()),
                    //       //     child: Container(
                    //       //       height: 50,
                    //       //       width: double.infinity,
                    //       //       decoration: BoxDecoration(
                    //       //         borderRadius: BorderRadius.circular(30),
                    //       //         boxShadow: [
                    //       //           BoxShadow(
                    //       //             color: Colors.black.withOpacity(0.3),
                    //       //             offset: const Offset(0, 4),
                    //       //             blurRadius: 6.0,
                    //       //             spreadRadius: 0.0,
                    //       //           ),
                    //       //         ],
                    //       //       ),
                    //       //       child: TextFormField(readOnly: true,
                    //       //         decoration: InputDecoration(
                    //       //           hintText: 'Search Mom Chef',
                    //       //           prefixIcon: const Icon(Icons.search),
                    //       //           contentPadding: const EdgeInsets.symmetric(
                    //       //               vertical: 15, horizontal: 20),
                    //       //           border: OutlineInputBorder(
                    //       //             borderRadius: BorderRadius.circular(30),
                    //       //             borderSide: BorderSide.none,
                    //       //           ),
                    //       //           filled: true,
                    //       //           fillColor: Colors.white,
                    //       //         ),
                    //       //       ),
                    //       //     ),
                    //       //   ),
                    //       // ),
                    //
                    //       const SizedBox(
                    //         width: Dimensions.paddingSizeSmall,
                    //       ),
                    //
                    //       SizedBox(
                    //         width: 110,
                    //         height: 35,
                    //         child: Stack(
                    //           children: [
                    //
                    //             Container(
                    //               decoration: BoxDecoration(
                    //                 color: selectedButton == 'non-veg'
                    //                     ? Colors.red
                    //                     : (selectedButton == "veg") ? Colors.green : Color(0xffE0E0E0),
                    //                 borderRadius: BorderRadius.circular(30),
                    //               ),
                    //             ),
                    //
                    //             // Sliding selection indicator
                    //             AnimatedAlign(
                    //               duration: const Duration(milliseconds: 300),
                    //               alignment: selectedButton == 'non-veg'
                    //                   ? Alignment.centerLeft
                    //                   : (selectedButton == 'veg' ? Alignment.centerRight : Alignment.center),
                    //               child: Container(
                    //                 width: 35,
                    //                 height: 35,
                    //                 decoration: BoxDecoration(
                    //                   color: Colors.white,
                    //                   shape: BoxShape.circle,
                    //                   boxShadow: [
                    //                     BoxShadow(
                    //                       color: Colors.black.withOpacity(0.3),
                    //                       offset: const Offset(0, 4),
                    //                       blurRadius: 8,
                    //                     ),
                    //                   ],
                    //                 ),
                    //               ),
                    //             ),
                    //
                    //             // Buttons in a row
                    //             Center(
                    //               child: Row(
                    //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //                 children: [
                    //                   // Non-Veg Button
                    //                   InkWell(
                    //                     onTap: () {
                    //                       setState(() {
                    //                         selectedButton = 'non-veg';
                    //                         restController.setNonVeg();
                    //
                    //                         if(widget.isPopular) {
                    //                           restController.getPopularRestaurantList(true, "non_veg", true);
                    //                         }else {
                    //                           if(widget.isRecentlyViewed){
                    //                             restController.getRecentlyViewedRestaurantList(true, "non_veg", true);
                    //                           }else{
                    //                             restController.getLatestRestaurantList(true, "non_veg", true);
                    //                           }
                    //                         }
                    //
                    //                       });
                    //                     },
                    //                     child: Image.asset(
                    //                       Images.newNonVeg,
                    //                       height: 16,
                    //                       color: selectedButton == 'non-veg' ? null : Color(0xffA7A7A7),
                    //                     ),
                    //                   ),
                    //
                    //                   // All Button
                    //                   InkWell(
                    //                     onTap: () {
                    //                       setState(() {
                    //                         selectedButton = 'all';
                    //                         if(widget.isPopular) {
                    //                           restController.getPopularRestaurantList(true, "all", true);
                    //                         }else {
                    //                           if(widget.isRecentlyViewed){
                    //                             restController.getRecentlyViewedRestaurantList(true, "all", true);
                    //                           }else{
                    //                             restController.getLatestRestaurantList(true, "all", true);
                    //                           }
                    //                         }
                    //                       });
                    //                     },
                    //                     child: const Text(
                    //                       'All',
                    //                       style: TextStyle(
                    //                         color: Colors.black,
                    //                         fontWeight: FontWeight.bold,
                    //                       ),
                    //                     ),
                    //                   ),
                    //
                    //                   // Veg Button
                    //                   InkWell(
                    //                     onTap: () {
                    //                       setState(() {
                    //                         restController.setVeg();
                    //
                    //                         selectedButton = 'veg';
                    //                         if(widget.isPopular) {
                    //                           restController.getPopularRestaurantList(true, "veg", true);
                    //                         }else {
                    //                           if(widget.isRecentlyViewed){
                    //                             restController.getRecentlyViewedRestaurantList(true, "veg", true);
                    //                           }else{
                    //                             restController.getLatestRestaurantList(true, "veg", true);
                    //                           }
                    //                         }
                    //                       });
                    //                     },
                    //                     child: Image.asset(
                    //                       Images.vegImage,
                    //                       height: 16,
                    //                       color: selectedButton == 'veg' ? null : Colors.grey,
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //
                    //     ],
                    //   ),
                    // ),

                    // const AllRestaurantFilterWidget(),

                    Center(
                        child: SizedBox(
                      width: Dimensions.webMaxWidth,
                      child: ProductViewWidget(
                        isRestaurant: true,
                        products: null,
                        noDataText: 'no_restaurant_available'.tr,
                        restaurants: widget.isPopular
                            ? restController.popularRestaurantList
                            : widget.isRecentlyViewed
                                ? restController.recentlyViewedRestaurantList
                                : widget.isOrderAgain
                                    ? restController.orderAgainRestaurantList
                                    : restController.latestRestaurantList,
                      ),
                    )),

                    const SizedBox(
                      height: Dimensions.paddingSizeDefault,
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeSmall),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "with_love_from_maa".tr,
                            style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 40,
                                color: Color(0xffA7A7A7)),
                          )),
                    ),

                    const SizedBox(
                      height: Dimensions.paddingSizeDefault,
                    ),
                  ],
                ),
              )),
        ),
      );
    });
  }
}

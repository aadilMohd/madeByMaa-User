import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:stackfood_multivendor/features/dashboard/screens/dashboard_screen.dart';
import 'package:stackfood_multivendor/features/home/screens/home_screen.dart';
import 'package:stackfood_multivendor/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor/features/product/controllers/product_controller.dart';
import 'package:stackfood_multivendor/features/review/controllers/review_controller.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/footer_view_widget.dart';
import 'package:stackfood_multivendor/common/widgets/menu_drawer_widget.dart';
import 'package:stackfood_multivendor/common/widgets/product_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../helper/route_helper.dart';
import '../../../util/images.dart';

class PopularFoodScreen extends StatefulWidget {
  final bool isPopular;
  final bool fromIsRestaurantFood;
  final int? restaurantId;
  const PopularFoodScreen({super.key, required this.isPopular, required this.fromIsRestaurantFood, this.restaurantId});

  @override
  State<PopularFoodScreen> createState() => _PopularFoodScreenState();
}

class _PopularFoodScreenState extends State<PopularFoodScreen> {
  final ScrollController scrollController = ScrollController();
  String selectedButton = 'all';

  @override
  void initState() {
    super.initState();

    if(widget.isPopular) {
      Get.find<ProductController>().getPopularProductList(true, Get.find<ProductController>().popularType, false);
    } else if(widget.fromIsRestaurantFood) {
      Get.find<RestaurantController>().getRestaurantRecommendedItemList(widget.restaurantId, false);
    } else {
      Get.find<ReviewController>().getReviewedProductList(true, Get.find<ReviewController>().reviewType, false);
    }
  }
  @override
  Widget build(BuildContext context) {

    return GetBuilder<RestaurantController>(builder: (restaurantController) {
      return GetBuilder<ProductController>(builder: (productController) {
        return GetBuilder<ReviewController>(builder: (reviewController) {
          return Scaffold(

            // appBar: CustomAppBarWidget(
            //   title: widget.isPopular ? widget.fromIsRestaurantFood? 'popular_in_this_restaurant'.tr : 'popular_foods_nearby'.tr : 'best_reviewed_food'.tr,
            //   showCart: true,
            //   type: widget.isPopular ? productController.popularType : reviewController.reviewType,
            //   onVegFilterTap: widget.fromIsRestaurantFood ? null : (String type) {
            //     if(widget.isPopular) {
            //       productController.getPopularProductList(true, type, true);
            //     }else {
            //       reviewController.getReviewedProductList(true, type, true);
            //     }
            //   },
            // ),

            appBar: AppBar(backgroundColor: const Color(0xffFFEACC),toolbarHeight: 0,),
            endDrawer: const MenuDrawerWidget(), endDrawerEnableOpenDragGesture: false,
            body: SingleChildScrollView(controller: scrollController,
                child: Column(
                  children: [

                    Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                          decoration: const BoxDecoration(
                              gradient: LinearGradient(colors: [
                                Color(0xffFFEACC),
                                Colors.white
                              ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter)
                          ),child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                      
                            SizedBox(height: 40,),

                            Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () =>
                                        Get.toNamed(RouteHelper.getSearchRoute()),
                                    child:Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20
                                  ),
                                  height: 42,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Get.theme.cardColor,
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors
                                            .grey
                                            .withOpacity(
                                            0.5),
                                        spreadRadius: 0,
                                        blurRadius: 1,
                                        offset:
                                        const Offset(
                                            0, 1.5),
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
                                        width: Dimensions.paddingSizeDefault,
                                      ),
                                      const Text(
                                        "Search Mom Chef",
                                        style:
                                            TextStyle(color: Color(0xffA7A7A7)),
                                      )
                                    ],
                                  ),
                                ),
                                  ),
                                ),



                                const SizedBox(
                                  width: Dimensions.paddingSizeDefault,
                                ),


                                SizedBox(
                                  width: 88,
                                  height: 28,
                                  child: Stack(
                                    children: [

                                      Container(
                                        decoration: BoxDecoration(
                                          color: selectedButton == 'non-veg'
                                              ? Colors.red
                                              : (selectedButton == "veg") ? Colors.green : Color(0xffE0E0E0),
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                      ),

                                      // Sliding selection indicator
                                      AnimatedAlign(
                                        duration: const Duration(milliseconds: 300),
                                        alignment: selectedButton == 'non-veg'
                                            ? Alignment.centerLeft
                                            : (selectedButton == 'veg' ? Alignment.centerRight : Alignment.center),
                                        child: Container(
                                          width: 29,
                                          height: 29,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.3),
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
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            // Non-Veg Button
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  selectedButton = 'non-veg';
                                                  restaurantController.setNonVeg();

                                                  if(widget.isPopular) {
                                                    productController.getPopularProductList(true, "non_veg", true);
                                                  }else {
                                                    reviewController.getReviewedProductList(true, "non_veg", true);
                                                  }

                                                });
                                              },
                                              child: Image.asset(
                                                Images.newNonVeg,
                                                height: 16,
                                                color: selectedButton == 'non-veg' ? null : Color(0xffA7A7A7),
                                              ),
                                            ),

                                            // All Button
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  selectedButton = 'all';
                                                        if(widget.isPopular) {
                                          productController.getPopularProductList(true, "all", true);
                                        }else {
                                          reviewController.getReviewedProductList(true, "all", true);
                                        }
                                                });
                                              },
                                              child:  Text(
                                                'All',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: Dimensions.fontSizeSmall,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),

                                            // Veg Button
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  restaurantController.setVeg();

                                                  selectedButton = 'veg';
                                                  if(widget.isPopular) {
                                                    productController.getPopularProductList(true, "veg", true);
                                                  }else {
                                                    reviewController.getReviewedProductList(true, "veg", true);
                                                  }
                                                });
                                              },
                                              child: Image.asset(
                                                Images.vegImage,
                                                height: 16,
                                                color: selectedButton == 'veg' ? null : Colors.grey,
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
                          ],
                        ),),
                        Positioned(
                          right:0,
left: 0,
                          top: 10,
                          child:
                        Center(
                          child: Text(
                            widget.isPopular
                                ? widget.fromIsRestaurantFood
                                ? 'popular_in_this_restaurant'.tr
                                : "POPULAR FOOD"
                                : 'best_reviewed_food'.tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: Dimensions.fontSizeExtraLarge,
                            ),
                          ),
                        ),
                        ),
                        Positioned(
                          top: 10,

                          left: 20,
                          child:       GestureDetector(
                            onTap: () {
                              // Use `Navigator.pop(context)` or `Get.back()` based on your navigation method
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.arrow_back)
                        ),)
                      ],
                    ),
                    const SizedBox(height: Dimensions.paddingSizeSmall,),

                    FooterViewWidget(
                      child: Center(child: SizedBox(
                        width: Dimensions.webMaxWidth,
                        child: GetBuilder<ProductController>(builder: (productController) {
                          return GetBuilder<RestaurantController>(
                              builder: (restaurantController) {

                                return ProductViewWidget(
                                  isRestaurant: false, restaurants: null,
                                  products: widget.isPopular ? productController.popularProductList : widget.fromIsRestaurantFood ? restaurantController.recommendedProductModel?.products : reviewController.reviewedProductList,
                                );
                              }
                          );
                        }),
                      )),

                    ),

                    const SizedBox(height: Dimensions.paddingSizeDefault,),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text('with_love_from_maa'.tr,style: const TextStyle(fontSize: 40,fontWeight: FontWeight.w900,color: Color(0xffA7A7A7)),)),
                    ),

                    const SizedBox(height: 50,)
                  ],
                )),
          );
        });
      });
    },);
  }
}

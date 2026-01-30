import 'package:flutter/cupertino.dart';
import 'package:stackfood_multivendor/common/models/product_model.dart';
import 'package:stackfood_multivendor/common/models/restaurant_model.dart';
import 'package:stackfood_multivendor/common/widgets/product_view_widget.dart';
import 'package:stackfood_multivendor/features/category/controllers/category_controller.dart';
import 'package:stackfood_multivendor/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/cart_widget.dart';
import 'package:stackfood_multivendor/common/widgets/footer_view_widget.dart';
import 'package:stackfood_multivendor/common/widgets/menu_drawer_widget.dart';
import 'package:stackfood_multivendor/common/widgets/veg_filter_widget.dart';
import 'package:stackfood_multivendor/common/widgets/web_menu_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../util/images.dart';

class CategoryProductScreen extends StatefulWidget {
  final String? categoryID;
  final String categoryName;

  const CategoryProductScreen(
      {super.key, required this.categoryID, required this.categoryName});

  @override
  CategoryProductScreenState createState() => CategoryProductScreenState();
}

class CategoryProductScreenState extends State<CategoryProductScreen>
    with TickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();
  final ScrollController restaurantScrollController = ScrollController();
  TabController? _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    Get.find<CategoryController>().getSubCategoryList(widget.categoryID);
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          Get.find<CategoryController>().categoryProductList != null &&
          !Get.find<CategoryController>().isLoading) {
        int pageSize = (Get.find<CategoryController>().pageSize! / 10).ceil();
        if (Get.find<CategoryController>().offset < pageSize) {
          debugPrint('end of the page');
          Get.find<CategoryController>().showBottomLoader();
          Get.find<CategoryController>().getCategoryProductList(
            Get.find<CategoryController>().subCategoryIndex == 0
                ? widget.categoryID
                : Get.find<CategoryController>()
                    .subCategoryList![
                        Get.find<CategoryController>().subCategoryIndex]
                    .id
                    .toString(),
            Get.find<CategoryController>().offset + 1,
            Get.find<CategoryController>().type,
            false,
          );
        }
      }
    });
    restaurantScrollController.addListener(() {
      if (restaurantScrollController.position.pixels ==
              restaurantScrollController.position.maxScrollExtent &&
          Get.find<CategoryController>().categoryRestaurantList != null &&
          !Get.find<CategoryController>().isLoading) {
        int pageSize =
            (Get.find<CategoryController>().restaurantPageSize! / 10).ceil();
        if (Get.find<CategoryController>().offset < pageSize) {
          debugPrint('end of the page');
          Get.find<CategoryController>().showBottomLoader();
          Get.find<CategoryController>().getCategoryRestaurantList(
            Get.find<CategoryController>().subCategoryIndex == 0
                ? widget.categoryID
                : Get.find<CategoryController>()
                    .subCategoryList![
                        Get.find<CategoryController>().subCategoryIndex]
                    .id
                    .toString(),
            Get.find<CategoryController>().offset + 1,
            Get.find<CategoryController>().type,
            false,
          );
        }
      }
    });
  }

  String selectedButton = 'all';



  @override
  Widget build(BuildContext context) {
    return GetBuilder<RestaurantController>(builder: (restaurantController) {
      return GetBuilder<CategoryController>(builder: (catController) {
        List<Product>? products;
        List<Restaurant>? restaurants;
        if (catController.categoryProductList != null &&
            catController.searchProductList != null) {
          products = [];
          if (catController.isSearching) {
            products.addAll(catController.searchProductList!);
          } else {
            products.addAll(catController.categoryProductList!);
          }
        }
        if (catController.categoryRestaurantList != null &&
            catController.searchRestaurantList != null) {
          restaurants = [];
          if (catController.isSearching) {
            restaurants.addAll(catController.searchRestaurantList!);
          } else {
            restaurants.addAll(catController.categoryRestaurantList!);
          }
        }

        return PopScope(
          canPop: Navigator.canPop(context),
          onPopInvoked: (val) async {
            if (catController.isSearching) {
              catController.toggleSearch();
            } else {}
          },
          child: Scaffold(
            // appBar: ResponsiveHelper.isDesktop(context)
            //     ? const WebMenuBar()
            //     :
            // AppBar(
            //   automaticallyImplyLeading: true,
            //
            //   leading: IconButton(
            //     onPressed: () {
            //       Get.back();
            //     },
            //     icon: const Icon(Icons.arrow_back_outlined),
            //   ),
            //   centerTitle: true,
            //   title: Text(widget.categoryName,style:  TextStyle(fontWeight: FontWeight.w600,fontSize: Dimensions.fontSizeExtraLarge),),
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

            // AppBar(
            //         title: catController.isSearching
            //             ? TextField(
            //                 autofocus: true,
            //                 textInputAction: TextInputAction.search,
            //                 decoration: const InputDecoration(
            //                   hintText: 'Search...',
            //                   border: InputBorder.none,
            //                 ),
            //                 style: robotoRegular.copyWith(
            //                     fontSize: Dimensions.fontSizeLarge),
            //                 onSubmitted: (String query) =>
            //                     catController.searchData(
            //                   query,
            //                   catController.subCategoryIndex == 0
            //                       ? widget.categoryID
            //                       : catController
            //                           .subCategoryList![
            //                               catController.subCategoryIndex]
            //                           .id
            //                           .toString(),
            //                   catController.type,
            //                 ),
            //               )
            //             : Text(widget.categoryName,
            //                 style: robotoRegular.copyWith(
            //                   fontSize: Dimensions.fontSizeLarge,
            //                   color: Theme.of(context).textTheme.bodyLarge!.color,
            //                 )),
            //         centerTitle: true,
            //         leading: IconButton(
            //           icon: const Icon(Icons.arrow_back_ios),
            //           color: Theme.of(context).textTheme.bodyLarge!.color,
            //           onPressed: () {
            //             if (catController.isSearching) {
            //               catController.toggleSearch();
            //             } else {
            //               Get.back();
            //             }
            //           },
            //         ),
            //         backgroundColor: Theme.of(context).cardColor,
            //         elevation: 0,
            //         actions: [
            //           IconButton(
            //             onPressed: () => catController.toggleSearch(),
            //             icon: Icon(
            //               catController.isSearching
            //                   ? Icons.close_sharp
            //                   : Icons.search,
            //               color: Theme.of(context).textTheme.bodyLarge!.color,
            //             ),
            //           ),
            //           IconButton(
            //             onPressed: () => Get.toNamed(RouteHelper.getCartRoute()),
            //             icon: CartWidget(
            //                 color: Theme.of(context).textTheme.bodyLarge!.color,
            //                 size: 25),
            //           ),

            ///
            //           VegFilterWidget(
            //               type: catController.type,
            //               fromAppBar: true,
            //               onSelected: (String type) {
            //                 if (catController.isSearching) {
            //                   catController.searchData(
            //                     catController.subCategoryIndex == 0
            //                         ? widget.categoryID
            //                         : catController
            //                             .subCategoryList![
            //                                 catController.subCategoryIndex]
            //                             .id
            //                             .toString(),
            //                     '1',
            //                     type,
            //                   );
            //                 } else {
            //                   if (catController.isRestaurant) {
            //                     catController.getCategoryRestaurantList(
            //                       catController.subCategoryIndex == 0
            //                           ? widget.categoryID
            //                           : catController
            //                               .subCategoryList![
            //                                   catController.subCategoryIndex]
            //                               .id
            //                               .toString(),
            //                       1,
            //                       type,
            //                       true,
            //                     );
            //                   } else {
            //                     catController.getCategoryProductList(
            //                       catController.subCategoryIndex == 0
            //                           ? widget.categoryID
            //                           : catController
            //                               .subCategoryList![
            //                                   catController.subCategoryIndex]
            //                               .id
            //                               .toString(),
            //                       1,
            //                       type,
            //                       true,
            //                     );
            //                   }
            //                 }
            //
            //               }),
                  //   ],
                  // ),

            // endDrawer: const MenuDrawerWidget(),


            appBar: AppBar(
              toolbarHeight: 0,
              backgroundColor: const Color(0xffFFEACC),
            ),
            endDrawerEnableOpenDragGesture: false,
            body: Column(children: [

              Container(
                // height: 60,
                padding: const EdgeInsets.only(
                  left: Dimensions.paddingSizeSmall,
                  right: Dimensions.paddingSizeSmall,),
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xffFFEACC), Colors.white])),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: const Icon(Icons.arrow_back_outlined),
                        ),
                        Expanded(
                          child: Align(
                              alignment: Alignment.topCenter,
                              child: Text(widget.categoryName,style:  TextStyle(fontWeight: FontWeight.w600,fontSize: Dimensions.fontSizeExtraLarge),)),
                        )
                      ],),
                    Container(
                      height: 100,
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeDefault,
                          vertical: Dimensions.paddingSizeExtraSmall),

                      child: Row(
                        children: [
                          Expanded(
                            child:Container(
                              height: 40,
                              width: 250,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,

                                borderRadius: BorderRadius.circular(30),
                                boxShadow:  [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    blurStyle: BlurStyle.inner,
                                    spreadRadius: 1,
                                    blurRadius: 3,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center, // Center the Row's contents
                                children: [
                                  Image.asset(Images.search2, height: 16),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: TextField(
                                      decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.only(bottom: 5),
                                        border: InputBorder.none,
                                        hintText: 'Search Mom Chef',hintStyle: TextStyle(fontSize: Dimensions.fontSizeDefault,color: Get.theme.hintColor)

                                      ),
                                      onSubmitted: (String query) => catController.searchData(
                                        query,
                                        catController.subCategoryIndex == 0
                                            ? widget.categoryID
                                            : catController.subCategoryList![catController.subCategoryIndex].id.toString(),
                                        catController.type,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          ),

                          const SizedBox(width: 20,),

                          ///Filter ///


                          // SizedBox(
                          //   width: 110,
                          //   height: 35,
                          //   child: Stack(
                          //     children: [
                          //
                          //       Container(
                          //         decoration: BoxDecoration(
                          //           color: selectedButton == 'non-veg'
                          //               ? Colors.red
                          //               : (selectedButton == "veg") ? Colors.green : Color(0xffE0E0E0),
                          //           borderRadius: BorderRadius.circular(30),
                          //         ),
                          //       ),
                          //
                          //       // Sliding selection indicator
                          //       AnimatedAlign(
                          //         duration: const Duration(milliseconds: 300),
                          //         alignment: selectedButton == 'non-veg'
                          //             ? Alignment.centerLeft
                          //             : (selectedButton == 'veg' ? Alignment.centerRight : Alignment.center),
                          //         child: Container(
                          //           width: 35,
                          //           height: 35,
                          //           decoration: BoxDecoration(
                          //             color: Colors.white,
                          //             shape: BoxShape.circle,
                          //             boxShadow: [
                          //               BoxShadow(
                          //                 color: Colors.black.withOpacity(0.3),
                          //                 offset: const Offset(0, 4),
                          //                 blurRadius: 8,
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //       ),
                          //
                          //       // Buttons in a row
                          //       Center(
                          //         child: Row(
                          //           mainAxisAlignment: MainAxisAlignment.spaceAround,
                          //           children: [
                          //             // Non-Veg Button
                          //             InkWell(
                          //               onTap: () {
                          //                 setState(() {
                          //                   selectedButton = 'non-veg';
                          //                   restaurantController.setNonVeg();
                          //                   if (catController.isSearching) {
                          //                     catController.searchData(
                          //                       catController.subCategoryIndex == 0
                          //                           ? widget.categoryID
                          //                           : catController
                          //                           .subCategoryList![
                          //                       catController.subCategoryIndex]
                          //                           .id
                          //                           .toString(),
                          //                       '1',
                          //                       'non_veg',
                          //                     );
                          //                   }
                          //                   else {
                          //                     if (catController.isRestaurant) {
                          //                       catController.getCategoryRestaurantList(
                          //                         catController.subCategoryIndex == 0
                          //                             ? widget.categoryID
                          //                             : catController
                          //                             .subCategoryList![
                          //                         catController.subCategoryIndex]
                          //                             .id
                          //                             .toString(),
                          //                         1,
                          //                         'non_veg',
                          //                         true,
                          //                       );
                          //                     } else {
                          //                       catController.getCategoryProductList(
                          //                         catController.subCategoryIndex == 0
                          //                             ? widget.categoryID
                          //                             : catController
                          //                             .subCategoryList![
                          //                         catController.subCategoryIndex]
                          //                             .id
                          //                             .toString(),
                          //                         1,
                          //                         'non_veg',
                          //                         true,
                          //                       );
                          //                     }
                          //                   }
                          //                 });
                          //               },
                          //               child: Image.asset(
                          //                 Images.newNonVeg,
                          //                 height: 16,
                          //                 color: selectedButton == 'non-veg' ? null : Color(0xffA7A7A7),
                          //               ),
                          //             ),
                          //
                          //             // All Button
                          //             InkWell(
                          //               onTap: () {
                          //                 setState(() {
                          //                   selectedButton = 'all';
                          //                   restaurantController.setRestaurantType('all');
                          //
                          //                   if (catController.isSearching) {
                          //                     catController.searchData(
                          //                       catController.subCategoryIndex == 0
                          //                           ? widget.categoryID
                          //                           : catController
                          //                           .subCategoryList![
                          //                       catController.subCategoryIndex]
                          //                           .id
                          //                           .toString(),
                          //                       '1',
                          //                       'all',
                          //                     );
                          //                   }
                          //                   else {
                          //                     if (catController.isRestaurant) {
                          //                       catController.getCategoryRestaurantList(
                          //                         catController.subCategoryIndex == 0
                          //                             ? widget.categoryID
                          //                             : catController
                          //                             .subCategoryList![
                          //                         catController.subCategoryIndex]
                          //                             .id
                          //                             .toString(),
                          //                         1,
                          //                         'all',
                          //                         true,
                          //                       );
                          //                     } else {
                          //                       catController.getCategoryProductList(
                          //                         catController.subCategoryIndex == 0
                          //                             ? widget.categoryID
                          //                             : catController
                          //                             .subCategoryList![
                          //                         catController.subCategoryIndex]
                          //                             .id
                          //                             .toString(),
                          //                         1,
                          //                         'all',
                          //                         true,
                          //                       );
                          //                     }
                          //                   }
                          //                 });
                          //               },
                          //               child: const Text(
                          //                 'All',
                          //                 style: TextStyle(
                          //                   color: Colors.black,
                          //                   fontWeight: FontWeight.bold,
                          //                 ),
                          //               ),
                          //             ),
                          //
                          //             // Veg Button
                          //             InkWell(
                          //               onTap: () {
                          //                 setState(() {
                          //                   restaurantController.setVeg();
                          //
                          //                   selectedButton = 'veg';
                          //                   if (catController.isSearching) {
                          //                     catController.searchData(
                          //                       catController.subCategoryIndex == 0
                          //                           ? widget.categoryID
                          //                           : catController
                          //                           .subCategoryList![
                          //                       catController.subCategoryIndex]
                          //                           .id
                          //                           .toString(),
                          //                       '1',
                          //                       'veg',
                          //                     );
                          //                   }
                          //                   else {
                          //                     if (catController.isRestaurant) {
                          //                       catController.getCategoryRestaurantList(
                          //                         catController.subCategoryIndex == 0
                          //                             ? widget.categoryID
                          //                             : catController
                          //                             .subCategoryList![
                          //                         catController.subCategoryIndex]
                          //                             .id
                          //                             .toString(),
                          //                         1,
                          //                         'veg',
                          //                         true,
                          //                       );
                          //                     } else {
                          //                       catController.getCategoryProductList(
                          //                         catController.subCategoryIndex == 0
                          //                             ? widget.categoryID
                          //                             : catController
                          //                             .subCategoryList![
                          //                         catController.subCategoryIndex]
                          //                             .id
                          //                             .toString(),
                          //                         1,
                          //                         'veg',
                          //                         true,
                          //                       );
                          //                     }
                          //                   }
                          //                 });
                          //               },
                          //               child: Image.asset(
                          //                 Images.vegImage,
                          //                 height: 16,
                          //                 color: selectedButton == 'veg' ? null :  Color(0xffA7A7A7),
                          //               ),
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),


                          ///NEw
                          SizedBox(
                            width: 85,
                            height: 29,
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: selectedButton == 'non-veg'
                                        ? Colors.red
                                        : (selectedButton == "veg")
                                        ? Colors.green
                                        : const Color(0xffE0E0E0),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),

                                // Sliding selection indicator
                                AnimatedAlign(
                                  duration:
                                  const Duration(milliseconds: 300),
                                  alignment: selectedButton == 'non-veg'
                                      ? Alignment.centerLeft
                                      : (selectedButton == 'veg'
                                      ? Alignment.centerRight
                                      : Alignment.center),
                                  child: Container(
                                    width: 29,
                                    height: 29,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                          Colors.black.withOpacity(0.3),
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
                                            selectedButton = 'non-veg';
                                            restaurantController.setNonVeg();
                                            if (catController.isSearching) {
                                              catController.searchData(
                                                catController.subCategoryIndex == 0
                                                    ? widget.categoryID
                                                    : catController
                                                    .subCategoryList![
                                                catController.subCategoryIndex]
                                                    .id
                                                    .toString(),
                                                '1',
                                                'non_veg',
                                              );
                                            }
                                            else {
                                              if (catController.isRestaurant) {
                                                catController.getCategoryRestaurantList(
                                                  catController.subCategoryIndex == 0
                                                      ? widget.categoryID
                                                      : catController
                                                      .subCategoryList![
                                                  catController.subCategoryIndex]
                                                      .id
                                                      .toString(),
                                                  1,
                                                  'non_veg',
                                                  true,
                                                );
                                              } else {
                                                catController.getCategoryProductList(
                                                  catController.subCategoryIndex == 0
                                                      ? widget.categoryID
                                                      : catController
                                                      .subCategoryList![
                                                  catController.subCategoryIndex]
                                                      .id
                                                      .toString(),
                                                  1,
                                                  'non_veg',
                                                  true,
                                                );
                                              }
                                            }
                                          });
                                        },

                                        child: Image.asset(
                                          Images.newNonVeg,
                                          height: 12,
                                          color: selectedButton == 'non-veg'
                                              ? null
                                              : const Color(0xffA7A7A7),
                                        ),
                                      ),

                                      // All Button
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            selectedButton = 'all';
                                            restaurantController.setRestaurantType('all');

                                            if (catController.isSearching) {
                                              catController.searchData(
                                                catController.subCategoryIndex == 0
                                                    ? widget.categoryID
                                                    : catController
                                                    .subCategoryList![
                                                catController.subCategoryIndex]
                                                    .id
                                                    .toString(),
                                                '1',
                                                'all',
                                              );
                                            }
                                            else {
                                              if (catController.isRestaurant) {
                                                catController.getCategoryRestaurantList(
                                                  catController.subCategoryIndex == 0
                                                      ? widget.categoryID
                                                      : catController
                                                      .subCategoryList![
                                                  catController.subCategoryIndex]
                                                      .id
                                                      .toString(),
                                                  1,
                                                  'all',
                                                  true,
                                                );
                                              } else {
                                                catController.getCategoryProductList(
                                                  catController.subCategoryIndex == 0
                                                      ? widget.categoryID
                                                      : catController
                                                      .subCategoryList![
                                                  catController.subCategoryIndex]
                                                      .id
                                                      .toString(),
                                                  1,
                                                  'all',
                                                  true,
                                                );
                                              }
                                            }
                                          });
                                        },

                                        child: const Text(
                                          'All',
                                          style: TextStyle(
                                            fontSize: Dimensions.paddingSizeSmall,
                                            color: Colors.black,
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
                                            if (catController.isSearching) {
                                              catController.searchData(
                                                catController.subCategoryIndex == 0
                                                    ? widget.categoryID
                                                    : catController
                                                    .subCategoryList![
                                                catController.subCategoryIndex]
                                                    .id
                                                    .toString(),
                                                '1',
                                                'veg',
                                              );
                                            }
                                            else {
                                              if (catController.isRestaurant) {
                                                catController.getCategoryRestaurantList(
                                                  catController.subCategoryIndex == 0
                                                      ? widget.categoryID
                                                      : catController
                                                      .subCategoryList![
                                                  catController.subCategoryIndex]
                                                      .id
                                                      .toString(),
                                                  1,
                                                  'veg',
                                                  true,
                                                );
                                              } else {
                                                catController.getCategoryProductList(
                                                  catController.subCategoryIndex == 0
                                                      ? widget.categoryID
                                                      : catController
                                                      .subCategoryList![
                                                  catController.subCategoryIndex]
                                                      .id
                                                      .toString(),
                                                  1,
                                                  'veg',
                                                  true,
                                                );
                                              }
                                            }
                                          });
                                        },

                                        child: Image.asset(
                                          Images.vegImage,
                                          height: 12,
                                          color: selectedButton == 'veg'
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






              (catController.subCategoryList != null &&
                  !catController.isSearching)
                  ? Center(
                  child: Container(
                    height: 40,
                    width: Dimensions.webMaxWidth,
                    color: Theme.of(context).cardColor,
                    padding: const EdgeInsets.symmetric(
                        vertical: Dimensions.paddingSizeExtraSmall),
                    margin: const EdgeInsets.symmetric(
                        vertical: Dimensions.paddingSizeExtraSmall),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: catController.subCategoryList!.length,
                      padding: const EdgeInsets.only(
                          left: Dimensions.paddingSizeSmall),
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () => catController.setSubCategoryIndex(
                              index, widget.categoryID),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingSizeSmall,
                                vertical: Dimensions.paddingSizeExtraSmall),
                            margin: const EdgeInsets.only(
                                right: Dimensions.paddingSizeSmall),
                            decoration: BoxDecoration(
                              border: Border.all(color: index != catController.subCategoryIndex
                                  ? const Color(0xff090018)
                                  : Colors.transparent,),
                              borderRadius:
                              BorderRadius.circular(Dimensions.radiusDefault),
                              color: index == catController.subCategoryIndex
                                  ? const Color(0xff090018)
                              // Theme.of(context)
                              //         .primaryColor
                              //         .withOpacity(0.1)
                                  : Colors.transparent,
                            ),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    catController.subCategoryList![index].name!,
                                    style: index ==
                                        catController.subCategoryIndex
                                        ? robotoMedium.copyWith(
                                        fontSize: Dimensions.fontSizeSmall,
                                        color:Theme.of(context).cardColor)
                                        : robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeSmall),
                                  ),
                                ]),
                          ),
                        );
                      },
                    ),
                  ))
                  : const SizedBox(),





              Center(
                  child: Container(
                    height: 50,
                    width: Dimensions.webMaxWidth,
                    color: Theme.of(context).cardColor,
                    child: Align(
                      alignment: ResponsiveHelper.isDesktop(context)
                          ? Alignment.centerLeft
                          : Alignment.center,
                      child: Container(
                        width: ResponsiveHelper.isDesktop(context)
                            ? 350
                            : Dimensions.webMaxWidth,
                        color: ResponsiveHelper.isDesktop(context)
                            ? Colors.transparent
                            : Theme.of(context).cardColor,
                        child: TabBar(
                          controller: _tabController,
                          indicatorColor: Colors.transparent,
                          // indicatorWeight: 0,
                          labelColor: const Color(0xff090018),
                          unselectedLabelColor: Theme.of(context).disabledColor,
                          unselectedLabelStyle: robotoRegular.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).disabledColor,
                              fontSize: Dimensions.fontSizeSmall),
                          labelStyle: robotoBold.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color: Theme.of(context).primaryColor),
                          tabs: [
                            Tab(
                              child: SizedBox(
                                height: 50,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    _tabController?.index != 0
                                        ? const SizedBox()
                                        : const Icon(Icons.arrow_drop_down),

                                    Text(
                                      'food'.tr,
                                      style:
                                      TextStyle(fontSize: Dimensions.fontSizeDefault,),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Tab(
                              child: SizedBox(height: 50,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    _tabController?.index != 1
                                        ? const SizedBox()
                                        : const Icon(Icons.arrow_drop_down),

                                    Text(
                                      'restaurants'.tr,
                                      style:
                                      TextStyle(fontSize: Dimensions.fontSizeDefault),
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),


              Expanded(
                  child: NotificationListener(
                    onNotification: (dynamic scrollNotification) {
                      if (scrollNotification is ScrollEndNotification) {
                        if ((_tabController!.index == 1 &&
                            !catController.isRestaurant) ||
                            _tabController!.index == 0 &&
                                catController.isRestaurant) {
                          catController.setRestaurant(_tabController!.index == 1);
                          if (catController.isSearching) {
                            catController.searchData(
                              catController.searchText,
                              catController.subCategoryIndex == 0
                                  ? widget.categoryID
                                  : catController
                                  .subCategoryList![
                              catController.subCategoryIndex]
                                  .id
                                  .toString(),
                              catController.type,
                            );
                          } else {
                            if (_tabController!.index == 1) {
                              catController.getCategoryRestaurantList(
                                catController.subCategoryIndex == 0
                                    ? widget.categoryID
                                    : catController
                                    .subCategoryList![
                                catController.subCategoryIndex]
                                    .id
                                    .toString(),
                                1,
                                catController.type,
                                false,
                              );
                            } else {
                              catController.getCategoryProductList(
                                catController.subCategoryIndex == 0
                                    ? widget.categoryID
                                    : catController
                                    .subCategoryList![
                                catController.subCategoryIndex]
                                    .id
                                    .toString(),
                                1,
                                catController.type,
                                false,
                              );
                            }
                          }
                        }
                      }
                      return false;
                    },
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        SingleChildScrollView(
                          controller: scrollController,
                          child: FooterViewWidget(
                            child: Center(
                              child: SizedBox(
                                width: Dimensions.webMaxWidth,
                                child: Column(
                                  children: [
                                    ProductViewWidget(
                                      category: true,
                                      isRestaurant: false,
                                      products: products,
                                      restaurants: null,
                                      noDataText: 'no_category_food_found'.tr,
                                    ),
                                    catController.isLoading
                                        ? Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(
                                            Dimensions.paddingSizeSmall),
                                        child: CircularProgressIndicator(
                                            valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Theme.of(context)
                                                    .primaryColor)),
                                      ),
                                    )
                                        : const SizedBox(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SingleChildScrollView(
                          controller: restaurantScrollController,
                          child: FooterViewWidget(
                            child: Center(
                              child: SizedBox(
                                width: Dimensions.webMaxWidth,
                                child: Column(
                                  children: [
                                    ProductViewWidget(
                                      isRestaurant: true,
                                      products: null,
                                      restaurants: restaurants,
                                      noDataText: 'no_category_restaurant_found'.tr,
                                    ),
                                    catController.isLoading
                                        ? Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(
                                            Dimensions.paddingSizeSmall),
                                        child: CircularProgressIndicator(
                                            valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Theme.of(context)
                                                    .primaryColor)),
                                      ),
                                    )
                                        : const SizedBox(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ]),
          ),
        );
      });
    },);
  }
}

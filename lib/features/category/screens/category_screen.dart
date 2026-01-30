import 'dart:math';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/category/controllers/category_controller.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/common/widgets/footer_view_widget.dart';
import 'package:stackfood_multivendor/common/widgets/no_data_screen_widget.dart';
import 'package:stackfood_multivendor/common/widgets/web_page_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final ScrollController scrollController = ScrollController();
  final List<String> images = [
    Images.categoryBg1,
    Images.categoryBg2,
  ];
  final Random random = Random();

  @override
  void initState() {
    super.initState();

    Get.find<CategoryController>().getCategoryList(false);
  }

  String selectedButton = 'all';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Get.theme.cardColor,
        appBar: AppBar(
          title: Text(
            'Choose Your Favorite'.tr,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          // elevation: 4.0,
          // shadowColor: Colors.black,
        ),

        // endDrawer: const MenuDrawerWidget(),
        endDrawerEnableOpenDragGesture: false,
        body: GetBuilder<CategoryController>(
          builder: (categoryController) {
            return SafeArea(
              child: SingleChildScrollView(
                controller: scrollController,
                child: FooterViewWidget(
                    child: Column(
                  children: [
                    WebScreenTitleWidget(title: 'categories'.tr),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeDefault,
                          vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            offset: const Offset(0, 4),
                            blurRadius: 6.0,
                            spreadRadius: 0.0,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () =>
                                  Get.toNamed(RouteHelper.getSearchRoute()),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                height: 40,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Get.theme.cardColor,
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.5),
                                        offset: const Offset(0, 2),
                                        blurRadius: 2.0,
                                        spreadRadius: 1.0,
                                        blurStyle: BlurStyle.outer),
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

                          // const SizedBox(
                          //   width: Dimensions.paddingSizeSmall,
                          // ),
                          //
                          // SizedBox(
                          //   width: 90,
                          //   height: 27,
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
                          //           width: 27,
                          //           height: 27,
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
                          //
                          //                   // restaurantController.setNonVeg();
                          //
                          //                   // categoryController.getCategoryList(categoryController.res!.id, 1, "non_veg", true);
                          //
                          //
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
                          //                   // restaurantController.resetAll();
                          //
                          //
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
                          //
                          //                   selectedButton = 'veg';
                          //
                          //                   // restaurantController.setVeg();
                          //
                          //                   //  restaurantController.getRestaurantProductList(restaurantController.restaurant!.id, 1, "veg", true);
                          //
                          //                 });
                          //               },
                          //               child: Image.asset(
                          //                 Images.vegImage,
                          //                 height: 16,
                          //                 color: selectedButton == 'veg' ? null : Colors.grey,
                          //               ),
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    Center(
                        child: SizedBox(
                      width: Dimensions.webMaxWidth,
                      child: GetBuilder<CategoryController>(
                          builder: (catController) {
                        return catController.categoryList != null
                            ? catController.categoryList!.isNotEmpty
                                ? MasonryGridView.count(
                                    padding: const EdgeInsets.all(
                                        Dimensions.paddingSizeDefault),
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 15.0,
                                    crossAxisSpacing: 15.0,
                                    shrinkWrap: true,
                                    physics: const ScrollPhysics(),
                                    itemCount:
                                        catController.categoryList!.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      String imagePath = dust(index);

                                      Color textColor =
                                          (imagePath == Images.categoryBg1)
                                              ? Colors.white
                                              : Colors.black;

                                      return InkWell(
                                        onTap: () => Get.toNamed(
                                            RouteHelper.getCategoryProductRoute(
                                          catController.categoryList![index].id,
                                          catController
                                              .categoryList![index].name!,
                                        )),
                                        child: SizedBox(
                                          height: index == 1 ? 145 : 180,
                                          width: 165,
                                          child: Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        Dimensions.radiusLarge),
                                                child: Image.asset(
                                                  imagePath,
                                                  width: 180,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              Center(
                                                  child: SizedBox(
                                                      height: 100,
                                                      child: Image.network(
                                                        '${Get.find<SplashController>().configModel!.baseUrls!.categoryImageUrl}/${catController.categoryList![index].image}',
                                                        errorBuilder: (context,
                                                            error, stackTrace) {
                                                          return Center(
                                                              child: Text(
                                                            "Loading",
                                                            style: TextStyle(
                                                                fontSize: Dimensions
                                                                    .fontSizeDefault),
                                                          ));
                                                        },
                                                      ))),
                                              Positioned(
                                                  top: Dimensions
                                                      .paddingSizeSmall,
                                                  left: Dimensions
                                                      .paddingSizeSmall,
                                                  child: SizedBox(
                                                    width: 160,
                                                    child: Text(
                                                      catController
                                                          .categoryList![index]
                                                          .name!,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          color: textColor,
                                                          fontSize: Dimensions
                                                              .fontSizeLarge,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ))
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  )

                                ///Old code //
                                ///
                                // GridView.builder(
                                //   physics: const NeverScrollableScrollPhysics(),
                                //   shrinkWrap: true,
                                //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                //     crossAxisCount: ResponsiveHelper.isDesktop(context) ? 6 : ResponsiveHelper.isTab(context) ? 4 : 2,
                                //     childAspectRatio: (1/1),
                                //     mainAxisSpacing: Dimensions.paddingSizeSmall,
                                //     crossAxisSpacing: Dimensions.paddingSizeSmall,
                                //   ),
                                //   padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                //   itemCount: catController.categoryList!.length,
                                //   itemBuilder: (context, index) {
                                //     return InkWell(
                                //       onTap: () => Get.toNamed(RouteHelper.getCategoryProductRoute(
                                //         catController.categoryList![index].id, catController.categoryList![index].name!,
                                //       )),
                                //       child: Container(
                                //         decoration: BoxDecoration(
                                //           color: Theme.of(context).cardColor,
                                //           borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                //           boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200]!, blurRadius: 5, spreadRadius: 1)],
                                //         ),
                                //         alignment: Alignment.center,
                                //         child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                //
                                //           ClipRRect(
                                //             borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                //             child: CustomImageWidget(
                                //               height: 50, width: 50, fit: BoxFit.cover,
                                //               image: '${Get.find<SplashController>().configModel!.baseUrls!.categoryImageUrl}/${catController.categoryList![index].image}',
                                //             ),
                                //           ),
                                //           const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                                //
                                //           Text(
                                //             catController.categoryList![index].name!, textAlign: TextAlign.center,
                                //             style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                                //             maxLines: 2, overflow: TextOverflow.ellipsis,
                                //           ),
                                //
                                //         ]),
                                //       ),
                                //     );
                                //   },
                                // )

                                : NoDataScreen(title: 'no_category_found'.tr)
                            : const Center(child: CircularProgressIndicator());
                      }),
                    )),
                    const SizedBox(
                      height: 50,
                    ),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'with_love_from_maa'.tr,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 40,
                                color: Get.theme.disabledColor),
                          ),
                        )),
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                )),
              ),
            );
          },
        ));
  }

  String dust(int index) {
    if (index == 0) {
      return 'assets/image/categorybg1.png';
    }
    if (index == 1) {
      return 'assets/image/categorybg2.png';
    }
    if (index == 2) {
      return 'assets/image/categorybg1.png';
    }
    if (shouldPrint(index - 3)) {
      return 'assets/image/categorybg2.png';
    } else {
      return 'assets/image/categorybg1.png';
    }
  }

  bool shouldPrint(int index) {
    return index % 4 < 2;
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import '../../../common/widgets/paginated_list_view_widget.dart';
import '../../../helper/route_helper.dart';
import '../../cuisine/controllers/cuisine_controller.dart';
import '../../home/widgets/all_restaurant_filter_widget.dart';
import '../../home/widgets/all_restaurants_widget.dart';
import '../../home/widgets/restaurants_view_widget.dart';
import '../../restaurant/controllers/restaurant_controller.dart';

class NearByMaa extends StatefulWidget {
  const NearByMaa({super.key});

  @override
  State<NearByMaa> createState() => _NearByMaaState();
}

class _NearByMaaState extends State<NearByMaa> {
  String selectedButton = 'all';
  final ScrollController _scrollController = ScrollController();

  // String? selectedValue;
  // List<String> selectedCuisines = [];

  int page = 1;

  // final RefreshController _refreshController =
  // RefreshController(initialRefresh: false);
  //

  void _onRefresh() async {
    loadData();
    //  _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    loadMoreData();
    //_refreshController.loadComplete();
  }

  loadData() async {
    page = 1;
    await Get.find<RestaurantController>().getRestaurantList(page, false);
  }

  loadMoreData() async {
    page += 1;
    await Get.find<RestaurantController>()
        .getRestaurantList(page, true)
        .then((value) {
      Get.find<RestaurantController>().update();
    });
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
    return hour >= 0 && hour < 6;
  }

  @override
  void initState() {
    _scheduleRebuild();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData();

      Get.find<CuisineController>().getCuisineList();
      Get.find<RestaurantController>().setcuisine(0);
      super.initState();
    });
  }

  @override
  Widget build(BuildContext context) {
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

    return Scaffold(body: GetBuilder<CuisineController>(
      builder: (cuisineController) {
        return GetBuilder<RestaurantController>(
          builder: (restaurantController) {
            return RefreshIndicator(
              onRefresh: () async {
                await restaurantController.getRestaurantList(1, false);
                Get.find<RestaurantController>().restaurantList!;
              },
              // return SmartRefresher(
              // enablePullDown: true,
              // enablePullUp: true,
              // header: const WaterDropHeader(),
              // controller: _refreshController,
              // onRefresh: _onRefresh,
              // onLoading: _onLoading,

              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(18),
                              bottomLeft: Radius.circular(18),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                offset: const Offset(0, 2),
                                blurRadius: 0.5,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              bottomLeft:
                                  Radius.circular(Dimensions.radiusExtraLarge),
                              bottomRight:
                                  Radius.circular(Dimensions.radiusExtraLarge),
                            ),
                            child: Image.asset(Images.appBarBg2),
                          ),
                        ),
                        Positioned(
                          top: 70,
                          right: 0,
                          left: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "all_mom_chefs_near_you".tr,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xff524A61),
                                  fontSize: Dimensions.fontSizeLarge,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 110,
                          left: 20,
                          right: 20,
                          child: Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () =>
                                      Get.toNamed(RouteHelper.getSearchRoute()),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    height: 42,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Get.theme.cardColor,
                                      borderRadius: BorderRadius.circular(30),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
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
                                          width: Dimensions.paddingSizeDefault,
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
                                width: 76,
                                height: 26,
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
                                        width: 26,
                                        height: 26,
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

                                                restaurantController
                                                    .setNonVeg();

                                                //      restaurantController.getRestaurantProductList(restaurantController.restaurant!.id, 1, "non_veg", true);
                                              });
                                            },
                                            child: Image.asset(
                                              Images.newNonVeg,
                                              height: 12,
                                              width: 12,
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
                                                restaurantController.resetAll();
                                              });
                                            },
                                            child: Text(
                                              'All',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize:
                                                    Dimensions.fontSizeSmall,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),

                                          // Veg Button
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                selectedButton = 'veg';

                                                restaurantController.setVeg();

                                                //  restaurantController.getRestaurantProductList(restaurantController.restaurant!.id, 1, "veg", true);
                                              });
                                            },
                                            child: Image.asset(
                                              Images.vegImage,
                                              height: 12,
                                              width: 12,
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
                    const SizedBox(
                      height: 10,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Container(
                        //   height: 30,width: 100,
                        //   margin: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 5),
                        //   padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 0),
                        //
                        //   decoration: BoxDecoration(
                        //
                        //     border: Border.all(color: Colors.black),
                        //
                        //     borderRadius:
                        //         BorderRadius.circular(8.0),
                        //   ),
                        //   child: DropdownButton<String>(
                        //     // value: selectedValue,
                        //     hint: const Text('Cuisine',style: TextStyle(color: Colors.black),),
                        //
                        //     onChanged: (String? newValue) {
                        //       setState(() {
                        //         selectedValue = newValue;
                        //       });
                        //     },
                        //     items: cuisineController.cuisineModel?.cuisines
                        //             ?.map<DropdownMenuItem<String>>((value) {
                        //           return DropdownMenuItem<String>(
                        //             value: value.name,
                        //             child: Row(
                        //               children: [
                        //                 Checkbox(
                        //                   value: selectedCuisines.contains(value.name),
                        //                   onChanged: (bool? isChecked) {
                        //                     setState(() {
                        //                       if (isChecked == true) {
                        //                         selectedCuisines.add(value.name!);
                        //                       } else {
                        //                         selectedCuisines.remove(value.name);
                        //                       }
                        //                     });
                        //                   },
                        //                 ),
                        //                 Text(value.name!),
                        //               ],
                        //             ),
                        //           );
                        //         }).toList() ??
                        //         [],
                        //
                        //     isExpanded: true,
                        //
                        //     underline:
                        //         const SizedBox(),
                        //   ),
                        // ),
                        Expanded(
                            child: AllRestaurantFilterWidget(
                          nearByMaa: false,
                        )),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeDefault),
                      child: Column(
                        children: [
                          Divider(),
                        ],
                      ),
                    ),
                    PaginatedListViewWidget(
                      scrollController: _scrollController,
                      totalSize:
                          restaurantController.restaurantModel?.totalSize,
                      offset: restaurantController.restaurantModel?.offset,
                      onPaginate: (int? offset) async {
                        // print("0000000000 99999 $offset");
                        await restaurantController.getRestaurantList(
                            offset!, false);
                      },
                      productView: RestaurantsViewWidget(
                          restaurants: restaurantController
                              .restaurantModel?.restaurants),
                    ),
                    const SizedBox(
                      height: Dimensions.paddingSizeExtraLarge,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeDefault),
                        child: Text(
                          "with_love_from_maa".tr,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 40,
                              color: Color(0xffA7A7A7)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 100,
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    ));
  }

  var value = 0;
}

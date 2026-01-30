import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:stackfood_multivendor/features/cuisine/controllers/cuisine_controller.dart';
import 'package:stackfood_multivendor/features/home/widgets/filter_view_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/restaurant_filter_button_widget.dart';
import 'package:stackfood_multivendor/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllRestaurantFilterWidget extends StatefulWidget {
  final bool? nearByMaa;

  const AllRestaurantFilterWidget({
    super.key,
    this.nearByMaa,
  });

  @override
  State<AllRestaurantFilterWidget> createState() =>
      _AllRestaurantFilterWidgetState();
}

class _AllRestaurantFilterWidgetState extends State<AllRestaurantFilterWidget> {
  String? selectedValue;

  //List<String> selectedCuisines = [];
  RxString selectedCuisines = "".obs;
  var selectedCuisinesid;

  @override
  void initState() {
    Get.find<CuisineController>().getCuisineList();

    Get.find<RestaurantController>().setcuisine(0);
    print("lllpppp ${Get.find<RestaurantController>().cuisine}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CuisineController>(
      builder: (cuisineController) {
        return GetBuilder<RestaurantController>(
            builder: (restaurantController) {
          return Center(
            child: ResponsiveHelper.isDesktop(context)
                ? Container(
                    height: 70,
                    width: Dimensions.webMaxWidth,
                    color: Theme.of(context).colorScheme.background,
                    child: Row(
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('all_restaurants'.tr,
                                  style: robotoBold.copyWith(
                                      fontSize: Dimensions.fontSizeLarge,
                                      fontWeight: FontWeight.w600)),
                              Text(
                                '${restaurantController.restaurantModel != null ? restaurantController.restaurantModel!.totalSize : 0} ${'restaurants_near_you'.tr}',
                                style: robotoRegular.copyWith(
                                    color: Theme.of(context).disabledColor,
                                    fontSize: Dimensions.fontSizeSmall),
                              ),
                            ]),
                        const Expanded(child: SizedBox()),
                        filter(context, restaurantController),
                        const SizedBox(width: Dimensions.paddingSizeSmall),
                      ],
                    ))
                : Container(
                    transform: Matrix4.translationValues(0, -2, 0),
                    color: Theme.of(context).colorScheme.background,
                    padding: const EdgeInsets.symmetric(
                        // horizontal: Dimensions.paddingSizeDefault,
                         vertical: Dimensions.paddingSizeExtraSmall
                    ),
                    child: Column(children: [
                      // Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      //   // Text('all_restaurants'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                      //   // Flexible(
                      //   //   child: Text(
                      //   //     '${restaurantController.restaurantModel != null ? restaurantController.restaurantModel!.totalSize : 0} ${'restaurants_near_you'.tr}',
                      //   //     maxLines: 1, overflow: TextOverflow.ellipsis,
                      //   //     style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
                      //   //   ),
                      //   // ),
                      // ]),
                      // const SizedBox(height: Dimensions.paddingSizeSmall),

                      filter(context, restaurantController),
                    ]),
                  ),
          );
        });
      },
    );
  }

  Widget filter(
      BuildContext context, RestaurantController restaurantController) {
    return GetBuilder<CuisineController>(
      builder: (cuisineController) {
        return SizedBox(
          height: ResponsiveHelper.isDesktop(context) ? 40 : 30,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [
              widget.nearByMaa != true
                  ? Container(
                      height: 35,
                      width: 100,
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      margin: const EdgeInsets.only(left: 12.0),
                      decoration: BoxDecoration(
                        color: selectedCuisines.value.isEmpty
                            ? null
                            : Colors.black,
                        border: Border.all(color: Colors.black),
                        borderRadius:
                            BorderRadius.circular(Dimensions.radiusDefault),
                      ),
                      child: PopupMenuButton<String>(
                        position: PopupMenuPosition.under,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        tooltip: 'Select Cuisines',
                        shadowColor: Colors.grey,
                        offset: const Offset(-15, 10),
                        elevation: 5,
                        enabled: true,
                        iconColor: selectedCuisines.value.isEmpty
                            ? null
                            : Colors.white,
                        itemBuilder: (BuildContext context) {
                          return [
                            PopupMenuItem<String>(
                              enabled: false,
                              height: 0,
                              padding: EdgeInsets.zero,
                              child: Container(
                                width: 190,
                                constraints: BoxConstraints(
                                  maxHeight: 275,
                                  maxWidth:
                                      190, // Set the maximum height and width for the scrollable list
                                ),
                                child: Scrollbar(
                                  radius: Radius.circular(10),
                                  thickness: 8,
                                  thumbVisibility: true,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: cuisineController
                                          .cuisineModel!.cuisines!
                                          .map((value) {
                                        return StatefulBuilder(
                                          builder: (BuildContext context,
                                              StateSetter setState) {
                                            return GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  selectedCuisines.value =
                                                      value.name!;
                                                  selectedCuisinesid =
                                                      value.id!;
                                                  restaurantController
                                                      .setcuisine(value.id!);
                                                  print(
                                                      "kkkk ${restaurantController.cuisine}");
                                                });
                                                Navigator.pop(
                                                    context); // Close the popup after selection
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 2.0),
                                                // Adjust space between items
                                                child: Row(
                                                  children: [
                                                    Checkbox(
                                                      visualDensity:
                                                          VisualDensity.compact,
                                                      // Compact the checkbox to reduce space
                                                      value: selectedCuisines
                                                              .value ==
                                                          value.name,
                                                      onChanged:
                                                          (bool? isChecked) {
                                                        setState(() {
                                                          selectedCuisines
                                                                  .value =
                                                              value.name!;
                                                          selectedCuisinesid =
                                                              value.id!;
                                                          restaurantController
                                                              .setcuisine(
                                                                  value.id!);
                                                          //cuisine
                                                        });
                                                        Navigator.pop(
                                                            context); // Close the popup after selection
                                                      },
                                                    ),
                                                    Text(
                                                      value.name!,
                                                      style: robotoRegular
                                                          .copyWith(
                                                        fontSize: Dimensions
                                                            .fontSizeDefault,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: const Color(
                                                            0xff090018),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ];
                        },
                        child: Obx(() => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    maxLines: 1,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    selectedCuisines.value.isEmpty
                                        ? 'Cuisine'
                                        : selectedCuisines.value,
                                    style: robotoRegular.copyWith(
                                      fontSize: Dimensions.fontSizeSmall,
                                      fontWeight: FontWeight.w400,
                                      color: selectedCuisines.value.isEmpty
                                          ? const Color(0xff090018)
                                          : Colors.white,
                                    ),
                                  ),
                                ),
                                const Icon(Icons.arrow_drop_down),
                              ],
                            )),
                      ),
                    )
                  : const SizedBox(),

              widget.nearByMaa == true
                  ? ResponsiveHelper.isDesktop(context)
                      ? const SizedBox()
                      : const FilterViewWidget()
                  : SizedBox(),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              RestaurantsFilterButtonWidget(
                image: AssetImage(Images.star),
                buttonText: 'top_rated'.tr,
                onTap: () => restaurantController.setTopRated(),
                isSelected: restaurantController.topRated == 1,
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              RestaurantsFilterButtonWidget(
                image: AssetImage(Images.discount),
                buttonText: 'Discounts'.tr,
                onTap: () {
                  restaurantController.setDiscount();
                  print("kkadj ${restaurantController.discount}");
                },
                isSelected: restaurantController.discount == 1,
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              // RestaurantsFilterButtonWidget(
              //   buttonText: 'veg'.tr,
              //   onTap: () => restaurantController.setVeg(),
              //   isSelected: restaurantController.veg == 1,
              // ),
              // const SizedBox(width: Dimensions.paddingSizeSmall),
              //
              // RestaurantsFilterButtonWidget(
              //   buttonText: 'non_veg'.tr,
              //   onTap: () => restaurantController.setNonVeg(),
              //   isSelected: restaurantController.nonVeg == 1,
              // ),
              // const SizedBox(width: Dimensions.paddingSizeSmall),

              RestaurantsFilterButtonWidget(
                image: AssetImage(Images.popular),
                buttonText: 'popular'.tr,
                onTap: () {
                  restaurantController.setPopular();
                  print("kkadj ${restaurantController.popular}");
                },
                isSelected: restaurantController.popular == 1,
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),
              RestaurantsFilterButtonWidget(
                image: AssetImage(Images.latest),
                buttonText: 'latest'.tr,
                onTap: () => restaurantController.setLatest(),
                isSelected: restaurantController.latest == 1,
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              ResponsiveHelper.isDesktop(context)
                  ? const FilterViewWidget()
                  : const SizedBox(),
            ],
          ),
        );
      },
    );
  }
}

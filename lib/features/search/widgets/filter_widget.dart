import 'package:flutter/cupertino.dart';
import 'package:stackfood_multivendor/common/widgets/custom_dropdown_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_ink_well_widget.dart';
import 'package:stackfood_multivendor/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor/features/search/controllers/search_controller.dart'
    as search;
import 'package:stackfood_multivendor/features/search/widgets/custom_check_box_widget.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../util/images.dart';

class FilterWidget extends StatefulWidget {
  final double? maxValue;
  final bool isRestaurant;
  const FilterWidget(
      {super.key, required this.maxValue, required this.isRestaurant});

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  String selectedButton = 'all';

  List<bool?> _isChecked = List.generate(3, (_) => false);

  final List<String> _names = ["Low to High", "High to Low", "Price Range"];
  List<bool?> _isChecked2 = List.generate(2, (_) => false);

  final List<String> schedule = ["Today", "After Today"];
  bool isSelectPriceRange = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 600,
      child: ListView(
        children: [
          CustomInkWellWidget(
            onTap: () => Navigator.of(context).pop(),
            radius: Dimensions.radiusDefault,
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
              child: Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  decoration: const BoxDecoration(
                      color: Colors.black, shape: BoxShape.circle),
                  child: Icon(Icons.close, color: Theme.of(context).cardColor)),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            width: 600,
            constraints: BoxConstraints(
                maxHeight: context.height * 0.9,
                minHeight: context.height * 0.6),
            decoration: ResponsiveHelper.isMobile(context)
                ? BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(Dimensions.radiusLarge),
                        topRight: Radius.circular(Dimensions.radiusLarge)),
                  )
                : null,
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: GetBuilder<search.SearchController>(
                builder: (searchController) {
              List<DropdownItem<int>> sortList =
                  _generateDropDownSortList(searchController.sortList, context);
              List<DropdownItem<int>> priceSortList =
                  _generateDropDownPriceSortList(
                      searchController.priceSortList, context);

              return ListView(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('Filter Your Results',
                          style: robotoBold.copyWith(
                              fontSize: Dimensions.fontSizeExtraLarge)),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),
                    Container(
                      padding:
                          const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      margin: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeDefault),
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(Dimensions.radiusDefault),
                          border: Border.all(
                              color: Get.theme.primaryColor.withOpacity(0.4),
                              width: 0.8)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                  text: "Filter your items in ",
                                  style: TextStyle(
                                      color: const Color(0xff524A61),
                                      fontSize: Dimensions.fontSizeSmall)),
                              TextSpan(
                                  text: "Veg ",
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontSize: Dimensions.fontSizeSmall)),
                              TextSpan(
                                  text: "& ",
                                  style: TextStyle(
                                      color: const Color(0xff524A61),
                                      fontSize: Dimensions.fontSizeSmall)),
                              TextSpan(
                                  text: "Non-Veg ",
                                  style: TextStyle(
                                      color: Colors.orange,
                                      fontSize: Dimensions.fontSizeSmall)),
                            ]),
                          ),
                          SizedBox(
                            width: 100,
                            height: 30,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceAround, // Space buttons evenly
                                children: [
                                  // Non-Veg button
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedButton = 'non-veg';

                                        if(widget.isRestaurant) {
                                          searchController.toggleResNonVeg();
                                        } else {
                                          searchController.toggleNonVeg();
                                        }
                                      });


                                    },
                                    child: Container(
                                      decoration: selectedButton == 'non-veg'
                                          ? BoxDecoration(
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
                                            )
                                          : null,
                                      padding: selectedButton == 'non-veg'
                                          ? const EdgeInsets.all(10.0)
                                          : EdgeInsets.zero,
                                      child: Image.asset(
                                        Images.newNonVeg,
                                        height: 15,
                                        color: selectedButton == 'non-veg'
                                            ? null
                                            : Colors.grey,
                                      ),
                                    ),
                                  ),

                                  // "All" button
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedButton = 'all';
                                        Get.find<RestaurantController>().getRestaurantProductList(Get.find<RestaurantController>().restaurant!.id, 1, "all", true);
                                      });
                                    },
                                    child: Container(
                                      decoration: selectedButton == 'all'
                                          ? BoxDecoration(
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
                                            )
                                          : null,
                                      padding: const EdgeInsets.all(5.0),
                                      child: const Text(
                                        'All',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Veg button
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedButton = 'veg';
                                        if(widget.isRestaurant) {
                                          searchController.toggleResVeg();
                                        } else {
                                          searchController.toggleVeg();
                                        }
                                      });
                                    },
                                    child: Container(
                                      decoration: selectedButton == 'veg'
                                          ? BoxDecoration(
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
                                            )
                                          : null,
                                      padding: selectedButton == 'veg'
                                          ? const EdgeInsets.all(10.0)
                                          : EdgeInsets.zero,
                                      child: Image.asset(
                                        Images.vegImage,
                                        height: 15,
                                        color: selectedButton == 'veg'
                                            ? null
                                            : Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SingleChildScrollView(
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Pricing',
                                style: robotoMedium.copyWith(
                                    fontSize: Dimensions.fontSizeLarge)),
                            const Divider(),

                            ListView.builder(
                              shrinkWrap:
                                  true, // Ensures it doesn't take up more space than needed
                              physics:
                                  const ScrollPhysics(), // Enable scrolling
                              itemCount: _names.length, // Number of items
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          if(index==2){
                                            isSelectPriceRange = true;
                                          }else{
                                            isSelectPriceRange = false;
                                          }

                                          setState(() {
                                            for (int i = 0;
                                                i < _isChecked.length;
                                                i++) {
                                              if (i == index) {
                                                _isChecked[i] = !_isChecked[i]!;
                                              } else {
                                                _isChecked[i] = false;
                                              }
                                            }
                                          });
                                                    if(widget.isRestaurant) {
                                                      searchController.setRestSortIndex(-1);
                                                      searchController.setRestPriceSortIndex(index);
                                                    } else {
                                                      searchController.setSortIndex(-1);
                                                      searchController.setPriceSortIndex(index);
                                                    }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: const Color(0xff524A61),
                                                width: 2),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          padding: const EdgeInsets.all(3),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: _isChecked[index]!
                                                  ? const Color(0xff524A61)
                                                  : Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                            ),
                                            width: 15,
                                            height: 15,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                          width:
                                              10), // Adjust the width between the checkbox and text
                                      Text(
                                        _names[index],
                                        style: TextStyle(
                                            fontSize: Dimensions.fontSizeLarge),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            // Align(alignment: Alignment.centerLeft, child: Text('price'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge))),

                            isSelectPriceRange?  Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 14.0),
                              child: RangeSlider(
                                values: RangeValues(searchController.lowerValue,
                                    searchController.upperValue),
                                max: widget.maxValue!.toInt().toDouble(),
                                min: 0,
                                divisions: widget.maxValue!.toInt(),
                                activeColor: Theme.of(context).primaryColor,
                                inactiveColor: Theme.of(context)
                                    .disabledColor
                                    .withOpacity(0.5),
                                labels: RangeLabels(
                                    searchController.lowerValue.toString(),
                                    searchController.upperValue.toString()),
                                onChanged: (RangeValues rangeValues) {
                                  searchController.setLowerAndUpperValue(
                                      rangeValues.start, rangeValues.end);
                                },
                              ),
                            ):const SizedBox(),

                            // Text('sort_by'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
                            // const SizedBox(height: Dimensions.paddingSizeSmall),
                            //
                            // Row(children: [
                            //   Expanded(
                            //     child: Container(
                            //       decoration: BoxDecoration(
                            //         borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            //         color: Theme.of(context).cardColor,
                            //         border: Border.all(color: (!widget.isRestaurant && searchController.priceSortIndex == -1) || (widget.isRestaurant && searchController.restaurantPriceSortIndex == -1)
                            //             ? Theme.of(context).disabledColor : Theme.of(context).primaryColor, width: 1),
                            //       ),
                            //       child: CustomDropdown<int>(
                            //         onChange: (int? value, int index) {
                            //           if(widget.isRestaurant) {
                            //             searchController.setRestSortIndex(-1);
                            //             searchController.setRestPriceSortIndex(index);
                            //           } else {
                            //             searchController.setSortIndex(-1);
                            //             searchController.setPriceSortIndex(index);
                            //           }
                            //         },
                            //         dropdownButtonStyle: DropdownButtonStyle(
                            //           height: 45,
                            //           padding: const EdgeInsets.symmetric(
                            //             vertical: Dimensions.paddingSizeExtraSmall,
                            //             horizontal: Dimensions.paddingSizeExtraSmall,
                            //           ),
                            //           primaryColor: Theme.of(context).textTheme.bodyLarge!.color,
                            //         ),
                            //         dropdownStyle: DropdownStyle(
                            //           elevation: 10,
                            //           borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            //           padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                            //         ),
                            //         items: priceSortList,
                            //         child: Text(
                            //           !widget.isRestaurant
                            //               ? searchController.priceSortIndex == -1 ? 'select_price_sort'.tr : searchController.priceSortList[searchController.priceSortIndex]
                            //               : searchController.restaurantPriceSortIndex == -1 ? 'select_price_sort'.tr : searchController.priceSortList[searchController.restaurantPriceSortIndex],
                            //           style: robotoRegular.copyWith(color: Theme.of(context).disabledColor),
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            //   const SizedBox(width: Dimensions.paddingSizeSmall),
                            //
                            //   Expanded(
                            //     child: Container(
                            //       decoration: BoxDecoration(
                            //         borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            //         color: Theme.of(context).cardColor,
                            //         border: Border.all(color: searchController.sortIndex == -1 || (widget.isRestaurant && searchController.restaurantSortIndex == -1)
                            //             ? Theme.of(context).disabledColor : Theme.of(context).primaryColor, width: 1),
                            //       ),
                            //       child: CustomDropdown<int>(
                            //         onChange: (int? value, int index) {
                            //           if(widget.isRestaurant) {
                            //             searchController.setRestPriceSortIndex(-1);
                            //             searchController.setRestSortIndex(index);
                            //           } else {
                            //             searchController.setPriceSortIndex(-1);
                            //             searchController.setSortIndex(index);
                            //           }
                            //         },
                            //         dropdownButtonStyle: DropdownButtonStyle(
                            //           height: 45,
                            //           padding: const EdgeInsets.symmetric(
                            //             vertical: Dimensions.paddingSizeExtraSmall,
                            //             horizontal: Dimensions.paddingSizeExtraSmall,
                            //           ),
                            //           primaryColor: Theme.of(context).textTheme.bodyLarge!.color,
                            //         ),
                            //         dropdownStyle: DropdownStyle(
                            //           elevation: 10,
                            //           borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            //           padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                            //         ),
                            //         items: sortList,
                            //         child: Text(
                            //           !widget.isRestaurant ?
                            //           searchController.sortIndex == -1 ? 'select_letter_sort'.tr : searchController.sortList[searchController.sortIndex]
                            //           : searchController.restaurantSortIndex == -1 ? 'select_letter_sort'.tr : searchController.sortList[searchController.restaurantSortIndex],
                            //           style: robotoRegular.copyWith(color: Theme.of(context).disabledColor),
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            //
                            //
                            // ]),

                            // const SizedBox(height: Dimensions.paddingSizeSmall),

                            // GridView.builder(
                            //   itemCount: searchController.sortList.length,
                            //   physics: const NeverScrollableScrollPhysics(),
                            //   shrinkWrap: true,
                            //   padding: EdgeInsets.zero,
                            //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            //     crossAxisCount: ResponsiveHelper.isDesktop(context) ? 4 : ResponsiveHelper.isTab(context) ? 3 : 2,
                            //     childAspectRatio: ResponsiveHelper.isDesktop(context) ? 3 : ResponsiveHelper.isTab(context) ? 3.5 : 4,
                            //     crossAxisSpacing: 10, mainAxisSpacing: 10,
                            //   ),
                            //   itemBuilder: (context, index) {
                            //     return InkWell(
                            //       onTap: () {
                            //         if(isRestaurant) {
                            //           searchController.setRestSortIndex(index);
                            //         } else {
                            //           searchController.setSortIndex(index);
                            //         }
                            //       },
                            //       child: Container(
                            //         alignment: Alignment.center,
                            //         decoration: BoxDecoration(
                            //           border: Border.all(color: (isRestaurant ? searchController.restaurantSortIndex == index : searchController.sortIndex == index) ? Colors.transparent
                            //               : Theme.of(context).disabledColor),
                            //           borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            //           color: (isRestaurant ? searchController.restaurantSortIndex == index : searchController.sortIndex == index) ? Theme.of(context).primaryColor
                            //               : Theme.of(context).cardColor,
                            //         ),
                            //         child: Row(
                            //           children: [
                            //             Expanded(
                            //               child: Text(
                            //                 searchController.sortList[index],
                            //                 textAlign: TextAlign.center,
                            //                 style: robotoMedium.copyWith(
                            //                   color: (isRestaurant ? searchController.restaurantSortIndex == index : searchController.sortIndex == index) ? Colors.white : Theme.of(context).hintColor,
                            //                 ),
                            //                 maxLines: 1,
                            //                 overflow: TextOverflow.ellipsis,
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //       ),
                            //     );
                            //   },
                            // ),
                            const SizedBox(height: Dimensions.paddingSizeLarge),

                            Text('More Specific',
                                style: robotoMedium.copyWith(
                                    fontSize: Dimensions.fontSizeLarge)),
                            const Divider(),
                            const SizedBox(height: Dimensions.paddingSizeSmall),

                            // Get.find<SplashController>().configModel!.toggleVegNonVeg! ? CustomCheckBoxWidget(
                            //   title: 'veg'.tr,
                            //   value: widget.isRestaurant ? searchController.restaurantVeg : searchController.veg,
                            //   onClick: () {
                            //     if(widget.isRestaurant) {
                            //       searchController.toggleResVeg();
                            //     } else {
                            //       searchController.toggleVeg();
                            //     }
                            //   },
                            // ) : const SizedBox(),
                            // Get.find<SplashController>().configModel!.toggleVegNonVeg! ? CustomCheckBoxWidget(
                            //   title: 'non_veg'.tr,
                            //   value: widget.isRestaurant ? searchController.restaurantNonVeg : searchController.nonVeg,
                            //   onClick: () {
                            //     if(widget.isRestaurant) {
                            //       searchController.toggleResNonVeg();
                            //     } else {
                            //       searchController.toggleNonVeg();
                            //     }
                            //   },
                            // ) : const SizedBox(),

                            CustomCheckBoxWidget(
                              title: widget.isRestaurant
                                  ? 'currently_opened_restaurants'.tr
                                  : 'currently_available_foods'.tr,
                              value: widget.isRestaurant
                                  ? searchController.isAvailableRestaurant
                                  : searchController.isAvailableFoods,
                              onClick: () {
                                if (widget.isRestaurant) {
                                  searchController.toggleAvailableRestaurant();
                                } else {
                                  searchController.toggleAvailableFoods();
                                }
                              },
                            ),

                            CustomCheckBoxWidget(
                              title: widget.isRestaurant
                                  ? 'discounted_restaurants'.tr
                                  : 'discounted_foods'.tr,
                              value: widget.isRestaurant
                                  ? searchController.isDiscountedRestaurant
                                  : searchController.isDiscountedFoods,
                              onClick: () {
                                if (widget.isRestaurant) {
                                  searchController.toggleDiscountedRestaurant();
                                } else {
                                  searchController.toggleDiscountedFoods();
                                }
                              },
                            ),
                            const SizedBox(height: Dimensions.paddingSizeLarge),
                            Text('Schedule Your Delivery',
                                style: robotoMedium.copyWith(
                                    fontSize: Dimensions.fontSizeLarge)),
                            const Divider(),
                            const SizedBox(height: Dimensions.paddingSizeSmall),
                            ListView.builder(
                              shrinkWrap:
                                  true, // Ensures it doesn't take up more space than needed
                              physics:
                                  const ScrollPhysics(), // Enable scrolling
                              itemCount: schedule.length, // Number of items
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            for (int i = 0; i < _isChecked2.length; i++) {
                                              if (i == index) {_isChecked2[i] = !_isChecked2[i]!;
                                              } else {
                                                _isChecked2[i] = false;
                                              }

                                            }
                                          });
                                          searchController.setordertype(index);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: const Color(0xff524A61),
                                                width: 2),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          padding: const EdgeInsets.all(3),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: _isChecked2[index]!
                                                  ? const Color(0xff524A61)
                                                  : Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                            ),
                                            width: 15,
                                            height: 15,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                          child: Text(
                                        schedule[index],
                                        style: TextStyle(
                                            fontSize: Dimensions.fontSizeLarge),
                                      )),
                                      Icon(
                                        Icons.calendar_month,
                                        color: Color(0xffA7A7A7),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),

                            widget.isRestaurant
                                ? const SizedBox()
                                : const Column(children: [
                                    SizedBox(
                                        height: Dimensions.paddingSizeSmall),
                                  ]),

                            // Text('rating'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
                            // Container(
                            //   height: 30, alignment: Alignment.center,
                            //   child: ListView.builder(
                            //     itemCount: 5,
                            //     shrinkWrap: true,
                            //     scrollDirection: Axis.horizontal,
                            //     padding: EdgeInsets.zero,
                            //     itemBuilder: (context, index) {
                            //       return Padding(
                            //         padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
                            //         child: InkWell(
                            //           onTap: () {
                            //             if(widget.isRestaurant) {
                            //               searchController.setRestaurantRating(index + 1);
                            //             } else {
                            //               searchController.setRating(index + 1);
                            //             }
                            //           },
                            //           child: Icon(
                            //             (widget.isRestaurant ? searchController.restaurantRating < (index + 1) : searchController.rating < (index + 1)) ? Icons.star_border : Icons.star,
                            //             size: 34,
                            //             color: (widget.isRestaurant ? searchController.restaurantRating < (index + 1) : searchController.rating < (index + 1)) ? Theme.of(context).disabledColor
                            //                 : Theme.of(context).primaryColor,
                            //           ),
                            //         ),
                            //       );
                            //     },
                            //   ),
                            // ),
                          ]),
                    ),
                    const SizedBox(height: 30),

                    SafeArea(
                      child: Row(children: [
                        Expanded(
                            flex: 1,
                            child:  CustomButtonWidget(
                              color: Theme.of(context).disabledColor.withOpacity(0.5),
                              textColor: Theme.of(context).textTheme.bodyLarge!.color,
                              onPressed: () {
                                if(widget.isRestaurant) {
                                  searchController.resetRestaurantFilter();
                                } else {
                                  searchController.resetFilter();
                                }
                                selectedButton == 'all';
                              },

                              buttonText: 'reset'.tr,
                            )),
                        const SizedBox(width: Dimensions.paddingSizeSmall),

                        Expanded(
                          flex: 2,
                          child: CustomButtonWidget(
                            buttonText: 'apply'.tr,
                            onPressed: () {
                              if(widget.isRestaurant) {
                                searchController.sortRestSearchList();
                              }else {
                                searchController.sortFoodSearchList();
                              }
                              Get.back();
                            },
                          ),
                        ),
                      ],
                      ),
                    ),
                  ]);
            }),
          ),
        ],
      ),
    );
  }

  List<DropdownItem<int>> _generateDropDownSortList(
      List<String?> sortList, BuildContext context) {
    List<DropdownItem<int>> generateDmTypeList = [];
    for (int index = 0; index < sortList.length; index++) {
      generateDmTypeList.add(DropdownItem<int>(
          value: index,
          child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${sortList[index]}',
                style: robotoRegular.copyWith(
                    color: Theme.of(context).textTheme.bodyMedium!.color),
              ),
            ),
          )));
    }
    return generateDmTypeList;
  }

  List<DropdownItem<int>> _generateDropDownPriceSortList(
      List<String?> priceSortList, BuildContext context) {
    List<DropdownItem<int>> generateDmTypeList = [];
    for (int index = 0; index < priceSortList.length; index++) {
      generateDmTypeList.add(DropdownItem<int>(
          value: index,
          child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${priceSortList[index]}',
                style: robotoRegular.copyWith(
                    color: Theme.of(context).textTheme.bodyMedium!.color),
              ),
            ),
          )));
    }
    return generateDmTypeList;
  }
}

import 'package:stackfood_multivendor/features/home/widgets/restaurants_card_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/restaurants_view_widget.dart';
import 'package:stackfood_multivendor/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/app_constants.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/features/restaurant/screens/restaurant_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewOnStackFoodViewWidget extends StatelessWidget {
  final bool isLatest;

  const NewOnStackFoodViewWidget({super.key, required this.isLatest});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RestaurantController>(builder: (restController) {
      return (restController.latestRestaurantList != null &&
              restController.latestRestaurantList!.isEmpty)
          ? const SizedBox()
          : Padding(
              padding: EdgeInsets.symmetric(
                  vertical: ResponsiveHelper.isMobile(context)
                      ? Dimensions.paddingSizeDefault
                      : Dimensions.paddingSizeLarge),
              child: Container(
                width: Dimensions.webMaxWidth,
                // color: Theme.of(context).primaryColor.withOpacity(0.1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('${'new_on'.tr} ${AppConstants.appName}',
                                style: robotoBold.copyWith(
                                    fontSize: Dimensions.fontSizeExtraLarge,
                                    fontWeight: FontWeight.w600)),
                            // SizedBox(width:5),
                            // Expanded(
                            //   child: Container(
                            //     height: 1,
                            //     decoration: const BoxDecoration(
                            //       gradient: LinearGradient(
                            //         begin: Alignment.centerLeft,
                            //         end: Alignment.centerRight,
                            //         colors: [Colors.grey,Colors.transparent],
                            //         stops: [0.2, 0.6], // Positions where the colors change
                            //
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            // ArrowIconButtonWidget(
                            //   onTap: () => Get.toNamed(RouteHelper.getAllRestaurantRoute(isLatest ? 'latest' : '')),
                            // ),
                          ]),
                    ),
                    Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: InkWell(
                              onTap: () => Get.toNamed(
                                  RouteHelper.getAllRestaurantRoute(
                                      isLatest ? 'latest' : '')),
                              child: Text(
                                "View all",
                                style: TextStyle(
                                    fontSize: Dimensions.fontSizeLarge),
                              )),
                        )),
                    restController.latestRestaurantList != null
                        ? SizedBox(
                            height:
                                restController.latestRestaurantList?.length == 1
                                    ? 190
                                    : 550,
                            child: GridView.builder(
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(

// mainAxisSpacing: 5,
                                      crossAxisCount: restController
                                                  .latestRestaurantList
                                                  ?.length ==
                                              1
                                          ? 1
                                          : 3,
                                      mainAxisExtent: 400,),
                              itemCount:
                                  restController.latestRestaurantList?.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(
                                       Dimensions.paddingSizeDefault),
                                  child: InkWell(
                                    onTap: () {
                                      Get.toNamed(
                                        RouteHelper.getRestaurantRoute(
                                            restController
                                                .latestRestaurantList![index]
                                                .id),
                                        arguments: RestaurantScreen(
                                            restaurant: restController
                                                .latestRestaurantList![index]),
                                      );
                                    },
                                    child: RestaurantView(
                                      restaurant: restController
                                          .latestRestaurantList![index],
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : const RestaurantsCardShimmer(isNewOnStackFood: false),
                  ],
                ),
              ),
            );
    });
  }
}

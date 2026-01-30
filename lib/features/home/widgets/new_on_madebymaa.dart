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

class NewOnMadeByMaaWidget extends StatefulWidget {
  final bool isLatest;

  const NewOnMadeByMaaWidget({super.key, required this.isLatest});

  @override
  State<NewOnMadeByMaaWidget> createState() => _NewOnMadeByMaaWidgetState();
}

class _NewOnMadeByMaaWidgetState extends State<NewOnMadeByMaaWidget> {

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RestaurantController>(builder: (restController) {
      return (restController.latestRestaurantList == null ||
          restController.latestRestaurantList!.isNotEmpty)
          ? const SizedBox()
          : Padding(
        padding: EdgeInsets.only(

            bottom: ResponsiveHelper.isMobile(context)
                ? Dimensions.paddingSizeDefault
                : Dimensions.paddingSizeLarge),
        child: SizedBox(
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
                     ( restController.latestRestaurantList!.isEmpty||restController.latestRestaurantList==null)?SizedBox():   Text('${'new_on'.tr} ${AppConstants.appName}',
                          style: robotoBold.copyWith(
                              fontSize: 18,
                              color: const Color(0xff090018),
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w700)),
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
                    ]
                ),
              ),
              restController.latestRestaurantList!.isEmpty?SizedBox():     Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0,bottom: 10),
                    child: InkWell(
                        onTap: () => Get.toNamed(
                            RouteHelper.getAllRestaurantRoute(
                                widget.isLatest ? 'latest' : '')),
                        child: Text(
                          "View all",
                          style: TextStyle(
                              fontSize: Dimensions.fontSizeSmall),
                        )),
                  )),

             ( restController.latestRestaurantList != null||restController.latestRestaurantList!.isNotEmpty)
                  ? SizedBox(
                height:
                restController.latestRestaurantList?.length == 1
                    ? 120
                    :
                restController.latestRestaurantList?.length == 2?240:
                390,
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(



                    crossAxisCount: restController.latestRestaurantList?.length == 1
                        ? 1
                        : restController.latestRestaurantList?.length == 2?2:3,


                    mainAxisExtent:
                    restController.latestRestaurantList?.length == 1
                        ? Get.width
                        :restController.latestRestaurantList?.length == 2
                        ?Get.width
                        :restController.latestRestaurantList?.length == 3?Get.width:360),
                  itemCount:
                  restController.latestRestaurantList?.length,

                  itemBuilder: (context, index) {
                    return Padding(
                      padding:  const EdgeInsets.symmetric(vertical: 10,horizontal:
                          Dimensions.paddingSizeDefault),
                      child: InkWell(
                        onTap: () {
                          Get.toNamed(
                            RouteHelper.getRestaurantRoute(
                                restController
                                    .latestRestaurantList![index]
                                    .id),
                            arguments: RestaurantScreen(
                                ownerNAme: restController
                                .latestRestaurantList![index]
                                .ownerName,
                                restaurant: restController
                                    .latestRestaurantList![index]),
                          );
                        },
                        child: RestaurantView1(length: restController.latestRestaurantList!.length,
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



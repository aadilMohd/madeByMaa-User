import 'package:flutter/cupertino.dart';
import 'package:stackfood_multivendor/features/NearByMaa/screens/near_by_maa.dart';
import 'package:stackfood_multivendor/features/dashboard/screens/dashboard_screen.dart';
import 'package:stackfood_multivendor/features/home/widgets/restaurants_view_widget.dart';
import 'package:stackfood_multivendor/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor/common/widgets/paginated_list_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';

import '../../AllMomChef/all_mom_chef.dart';

class AllRestaurantsWidget extends StatelessWidget {
  final ScrollController scrollController;

  const AllRestaurantsWidget({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RestaurantController>(builder: (restaurantController) {
      return Column(
        children: [
          restaurantController.restaurantModel?.totalSize.toString() != "0"?   Text(
            "all_mom_chef".tr,
            style: const TextStyle(
                fontSize: 18,
                color: Color(0xff090018),
                fontFamily: "Poppins",
                fontWeight: FontWeight.w700),
          ):const SizedBox(),
          const SizedBox(
            height: 30,
          ),
          restaurantController.restaurantModel?.totalSize.toString() != "0"
              ? PaginatedListViewWidget(
                  scrollController: scrollController,
                  totalSize: restaurantController.restaurantModel?.totalSize,
                  offset: restaurantController.restaurantModel?.offset,
                  onPaginate: (int? offset) async { if(offset==1){
                    print("00000000 9999999 $offset");
                    await restaurantController
                      .getRestaurantList(1, false,isSix: true);}},
                  productView: RestaurantsViewWidget(
                      restaurants:
                          restaurantController.restaurantModel?.restaurants),
                )
              : const SizedBox(),

          const SizedBox(
            height: 10,
          ),
          restaurantController.restaurantModel?.totalSize.toString() != "0"
              ? InkWell(onTap: (){
                Get.offAll(const DashboardScreen(pageIndex: 1));
                // Get.to(()=>const DashboardScreen(pageIndex: 1));


          },
                child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                        color: Get.theme.primaryColor.withOpacity(0.1),
                        borderRadius:
                            BorderRadius.circular(Dimensions.radiusDefault)),
                    child: const Center(
                      child: Text(
                        "View all",
                        style: TextStyle(
                          fontFamily: "Poppins",
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
              )
              : const SizedBox(),

                 const SizedBox(
            height: 50,
          ),

          Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'with_love_from_maa'.tr,
                  // textWidthBasis: TextWidthBasis.longestLine,

                  style: const TextStyle(
                    fontFamily: "Poppins",
                      fontWeight: FontWeight.w900,

                      fontSize: 40,
                      color: Color(0xffA7A7A7
                      )),
                ),
              )),
          const SizedBox(
            height: 80,
          ),
        ],
      );
    });
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor/features/home/widgets/all_restaurant_filter_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/filter_view_widget.dart';
import 'package:stackfood_multivendor/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';

import '../../common/widgets/paginated_list_view_widget.dart';
import '../../helper/address_helper.dart';
import '../../helper/auth_helper.dart';
import '../../helper/route_helper.dart';
import '../home/widgets/restaurants_view_widget.dart';
import '../notification/controllers/notification_controller.dart';
import '../splash/controllers/splash_controller.dart';

class AllMomChef extends StatefulWidget {
  const AllMomChef({super.key});

  @override
  State<AllMomChef> createState() => _AllMomChefState();
}

class _AllMomChefState extends State<AllMomChef> {
  String selectedButton = 'all';
  final ScrollController _scrollController = ScrollController();


  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(builder: (profileController) {
      return GetBuilder<RestaurantController>(builder: (restaurantController) {
        return Scaffold(
          appBar: AppBar(backgroundColor: Get.theme.primaryColor,toolbarHeight: 0,),
          body: ListView(
            children: [
              Container(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                decoration: BoxDecoration(
                    color: Get.theme.primaryColor,
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(Dimensions.radiusLarge),
                      bottomLeft: Radius.circular(Dimensions.radiusLarge),
                    )),
                child:  AuthHelper
                    .isLoggedIn()
                    ? Row(
                  crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
                  children: [
                    Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Get.theme.cardColor,
                          border: Border.all(),
                          shape: BoxShape.circle,
                        ),
                        child: Get.find<ProfileController>().userInfoModel!.image == null
                            ? const Icon(Icons.person, size: 30)
                            : ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.network(
                            '${Get.find<SplashController>().configModel!.baseUrls!.customerImageUrl}'
                                '/${(profileController.userInfoModel != null) ? profileController.userInfoModel!.image : ''}',
                            fit: BoxFit.cover,
                          ),
                        )),
                    const SizedBox(
                      width:
                      15,
                    ),
                    Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hi, ${Get.find<ProfileController>().userInfoModel!.fName}",
                          style: TextStyle(fontFamily: "Poppins",color: Get.theme.cardColor,
                              fontWeight: FontWeight.bold, fontSize: Dimensions.fontSizeLarge),
                        ),
                        SizedBox(
                          width: Get.width / 1.5,
                          child: Text(
                            AddressHelper.getAddressFromSharedPref()!.address!,
                            style: TextStyle( fontFamily:"Poppins",color: Get.theme.cardColor,
                                fontWeight: FontWeight.w400, fontSize: Dimensions.fontSizeDefault),
                          ),
                        )
                      ],
                    ),
                    InkWell(
                      child:
                      GetBuilder<NotificationController>(builder: (notificationController) {
                        return Container(
                          decoration: BoxDecoration(
                            // color: Theme.of(
                            //     context)
                            //     .cardColor
                            //     .withOpacity(0.9),
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          ),
                          padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                          child: Stack(children: [
                            Image.asset(
                              Images.notificationIcon,
                              height: 24,
                              color: Get.theme.cardColor,
                            ),
                            notificationController.hasNotification
                                ? Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  height: 10,
                                  width: 10,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    shape: BoxShape.circle,
                                    border: Border.all(width: 1, color: Theme.of(context).cardColor),
                                  ),
                                ))
                                : const SizedBox(),
                          ]),
                        );
                      }),
                      onTap: () =>
                          Get.toNamed(RouteHelper.getNotificationRoute()),
                    ),
                  ],
                )
                    : Row(
                  children: [
                    Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Get.theme.cardColor,
                          border: Border.all(),
                          shape: BoxShape.circle,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.network(
                            "https://t4.ftcdn.net/jpg/00/65/77/27/360_F_65772719_A1UV5kLi5nCEWI0BNLLiFaBPEkUbv5Fv.jpg",
                            fit: BoxFit.cover,
                          ),
                        ))
                  ],
                ),

              ),

              Container(
                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault,
                    horizontal:
                    Dimensions.paddingSizeSmall),
                decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(color: Colors.grey,blurStyle: BlurStyle.outer,offset: Offset(4, 0),spreadRadius: 2,blurRadius: 2)
                    ],
                    // color: Get.theme.primaryColor,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(Dimensions.radiusLarge),
                      bottomLeft: Radius.circular(Dimensions.radiusLarge),
                    )),child:
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () =>
                          Get.toNamed(RouteHelper.getSearchRoute()),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Get.theme.cardColor,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                offset: const Offset(0, 1),
                                blurRadius: 1.0,
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
                              style: TextStyle(color: Color(0xffA7A7A7)),
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
                    width: 110,
                    height: 35,
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
                            width: 35,
                            height: 35,
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
                                  });
                                },
                                child: const Text(
                                  'All',
                                  style: TextStyle(
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
              ),
              const AllRestaurantFilterWidget(),
              PaginatedListViewWidget(
                scrollController: _scrollController,
                totalSize: restaurantController.restaurantModel?.totalSize,
                offset: restaurantController.restaurantModel?.offset,
                onPaginate: (int? offset) async => await restaurantController
                    .getRestaurantList(offset!, false),
                productView: RestaurantsViewWidget(
                    restaurants:
                    restaurantController.restaurantModel?.restaurants),
              ),


            ],
          ),
        );
      },);
    },);
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor/common/widgets/veg_filter_widget.dart';
import 'package:stackfood_multivendor/features/cuisine/controllers/cuisine_controller.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';

import '../../../helper/responsive_helper.dart';
import '../../../helper/route_helper.dart';
import '../../splash/controllers/splash_controller.dart';
import 'cuisine_card_widget.dart';

class CuisineBottomSheet extends StatefulWidget {
  const CuisineBottomSheet({super.key});

  @override
  State<CuisineBottomSheet> createState() => _CuisineBottomSheetState();
}

class _CuisineBottomSheetState extends State<CuisineBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {

    return GetBuilder<CuisineController>(builder: (cuisineController) {
      return SizedBox(
        height: Get.height/1.3,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                  decoration:
                  const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.black),
                  child: Center(
                    child: InkWell(onTap: () {
                      Get.back();
                    },
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20,),

            Expanded(
              child: Container(
                width: Get.width,
                decoration: BoxDecoration(color: Get.theme.cardColor,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(Dimensions.radiusLarge),
                        topRight: Radius.circular(Dimensions.radiusLarge))
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 16),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(Dimensions.radiusLarge),
                            topRight: Radius.circular(Dimensions.radiusLarge)),
                        color: Get.theme.cardColor,
                        boxShadow:  [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 1,
                            spreadRadius: 1,
                            offset: Offset(0, 1),
                          )
                        ],),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(
                              'Cuisines', style: TextStyle(fontSize: Dimensions
                                .fontSizeExtraLarge, fontWeight: FontWeight.w600),),
                          ),
                          const SizedBox(height: 20,),
                          InkWell(
                            onTap:()=>
                                                    Get.toNamed(
                                                        RouteHelper
                                                            .getSearchRoute()),
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 50),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    offset: const Offset(0, 2),
                                    blurRadius: 1.0,
                                    spreadRadius: 0.0,
                                  ),
                                ],
                              ),
                              child: TextField(
                                onTap:()=>
                                    Get.toNamed(
                                        RouteHelper
                                            .getSearchRoute()),
                                readOnly: true,
                                controller: _searchController,

                                decoration: InputDecoration(
                                  // prefixIcon: Padding(
                                  //   padding: const EdgeInsets.only(left: 12, right: 8), // Adjust padding if needed
                                  //   child: Image.asset(
                                  //     Images.search2,
                                  //     height: 16,
                                  //
                                  //   ),
                                  // ),
                                  prefixIcon: IconButton(onPressed: (){
                                    // Get.find<C>().getRestaurantSearchProductList(
                                    //   _searchController.text.trim(), restaurant!.id.toString(), 1, Get.find<RestaurantController>().searchType,
                                    // );

                                  },icon: const Icon(Icons.search_sharp),color: Color(0xffA7A7A7),),
                                  hintText: 'Search your favorite cuisine',
                                  hintStyle: TextStyle(color: Get.theme.hintColor,fontSize: 12),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, // Reduce vertical padding
                                    horizontal: 15,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                              ),

                            ),
                          ),

                          const SizedBox(height: 20,),

                        ],

                      ),),
                    const SizedBox(height: 20,),

                    Container(height:Get.height/2,
                      child: GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: ResponsiveHelper.isMobile(context) ? 4 : ResponsiveHelper.isDesktop(context) ? 8 : 6,
                            mainAxisSpacing: Dimensions.paddingSizeDefault,
                            crossAxisSpacing: ResponsiveHelper.isDesktop(context) ? 35 : Dimensions.paddingSizeDefault,
                            childAspectRatio: 0.8,
                          ),
                          shrinkWrap: true,
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount: cuisineController.cuisineModel!.cuisines!.length,
                          scrollDirection: Axis.vertical,

                          itemBuilder: (context, index){
                            return InkWell(
                              hoverColor: Colors.transparent,
                              onTap: (){
                                Get.toNamed(RouteHelper.getCuisineRestaurantRoute(cuisineController.cuisineModel!.cuisines![index].id, cuisineController.cuisineModel!.cuisines![index].name));
                              },
                              child: SizedBox(
                                height: 130,
                                child: CuisineCardWidget(
                                  image: '${Get.find<SplashController>().configModel!.baseUrls!.cuisineImageUrl}/${cuisineController.cuisineModel!.cuisines![index].image}',
                                  name: cuisineController.cuisineModel!.cuisines![index].name!,
                                  fromCuisinesPage: true,
                                ),
                              ),
                            );
                          }),
                    )


                  ],
                ),),
            )
          ],
        ),
      );
    },);
  }
}

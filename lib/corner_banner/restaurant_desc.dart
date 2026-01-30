import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor/features/favourite/controllers/favourite_controller.dart';
import 'package:stackfood_multivendor/features/restaurant/controllers/restaurant_controller.dart';
import 'package:universal_html/html.dart' as html;

import '../common/models/restaurant_model.dart';
import '../common/widgets/custom_snackbar_widget.dart';
import '../features/address/domain/models/address_model.dart';
import '../features/auth/controllers/auth_controller.dart';
import '../features/splash/controllers/splash_controller.dart';
import '../helper/price_converter.dart';
import '../helper/responsive_helper.dart';
import '../helper/route_helper.dart';
import '../util/dimensions.dart';
import '../util/images.dart';
import '../util/styles.dart';

class StoreDescriptionView extends StatelessWidget {
  final Restaurant? store;

  const StoreDescriptionView({Key? key, required this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isAvailable = Get.find<RestaurantController>()
        .isRestaurantOpenNow(store!.active!, store!.schedules);
    Color? textColor =
        ResponsiveHelper.isDesktop(context) ? Colors.white : null;
    // Module? moduleData;
    // for(ZoneData zData in Get.find<LocationController>().getUserAddress()!.zoneData!) {
    //   for(Modules m in zData.modules!) {
    //     if(m.id == Get.find<SplashController>().module!.id) {
    //       moduleData = m as Module?;
    //       break;
    //     }
    //   }
    // }
    return Column(children: [
      ResponsiveHelper.isDesktop(context)
          ? Row(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                child: Stack(children: [
                  CustomImageWidget(
                    image:
                        '${Get.find<SplashController>().configModel!.baseUrls!.restaurantImageUrl}/${store!.logo}',
                    height: ResponsiveHelper.isDesktop(context) ? 140 : 60,
                    width: ResponsiveHelper.isDesktop(context) ? 140 : 70,
                    fit: BoxFit.cover,
                  ),
                  isAvailable
                      ? const SizedBox()
                      : Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 30,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(
                                  bottom:
                                      Radius.circular(Dimensions.radiusSmall)),
                              color: Colors.black.withOpacity(0.6),
                            ),
                            child: Text(
                              'closed_now'.tr,
                              textAlign: TextAlign.center,
                              style: robotoRegular.copyWith(
                                  color: Colors.white,
                                  fontSize: Dimensions.fontSizeSmall),
                            ),
                          ),
                        ),
                ]),
              ),
              const SizedBox(width: Dimensions.paddingSizeDefault),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Row(children: [
                      Expanded(
                          child: Text(
                        store!.name!,
                        style: robotoMedium.copyWith(
                            fontSize: Dimensions.fontSizeLarge,
                            color: textColor),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )),
                      const SizedBox(width: Dimensions.paddingSizeSmall),

                      // ResponsiveHelper.isDesktop(context) ? InkWell(
                      //   onTap: () => Get.toNamed(RouteHelper.getSearchStoreItemRoute(store!.id)),
                      //   child: ResponsiveHelper.isDesktop(context) ? Container(
                      //     padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      //     decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusDefault), color: Theme.of(context).primaryColor),
                      //     child: const Center(child: Icon(Icons.search, color: Colors.white)),
                      //   ) : Icon(Icons.search, color: Theme.of(context).primaryColor),
                      // ) : const SizedBox(),
                      // const SizedBox(width: Dimensions.paddingSizeSmall),
                      GetBuilder<FavouriteController>(
                          builder: (wishController) {
                        bool isWished =
                            wishController.wishRestIdList.contains(store!.id);
                        return InkWell(
                          onTap: () {
                            if (Get.find<AuthController>().isLoggedIn()) {
                              isWished
                                  ? wishController.removeFromFavouriteList(
                                      store!.id, true)
                                  : wishController.addToFavouriteList(
                                      null, store, true);
                            } else {
                              showCustomSnackBar('you_are_not_logged_in'.tr);
                            }
                          },
                          child: ResponsiveHelper.isDesktop(context)
                              ? Container(
                                  padding: const EdgeInsets.all(
                                      Dimensions.paddingSizeExtraSmall),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.radiusSmall),
                                      border: Border.all(color: Colors.white)),
                                  child: Center(
                                    child: Row(
                                      children: [
                                        Icon(
                                            isWished
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: Colors.white,
                                            size: 14),
                                        const SizedBox(
                                            width: Dimensions
                                                .paddingSizeExtraSmall),
                                        Text('wish_list'.tr,
                                            style: robotoRegular.copyWith(
                                                fontWeight: FontWeight.w200,
                                                color: Colors.white,
                                                fontSize:
                                                    Dimensions.fontSizeSmall)),
                                      ],
                                    ),
                                  ),
                                )
                              : Icon(
                                  isWished
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isWished
                                      ? Theme.of(context).primaryColor
                                      : Theme.of(context).disabledColor,
                                ),
                        );
                      }),
                    ]),
                    const SizedBox(height: Dimensions.paddingSizeDefault),
                    Row(children: [
                      Expanded(
                        child: Text(
                          store!.address ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color: Theme.of(context).disabledColor),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (store!.slug != null && store!.slug!.isNotEmpty) {
                            String? hostname = html.window.location.hostname;
                            String protocol = html.window.location.protocol;
                            String shareUrl =
                                '$protocol//$hostname${Get.find<RestaurantController>().filteringUrl(store!.slug ?? '')}';

                            Clipboard.setData(ClipboardData(text: shareUrl));
                            showCustomSnackBar('store_url_copied'.tr,
                                isError: false);
                          } else {
                            showCustomSnackBar(
                                'you_can_not_copy_url_as_no_slug_available_for_the_store'
                                    .tr);
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.5),
                            borderRadius:
                                BorderRadius.circular(Dimensions.radiusDefault),
                          ),
                          padding: const EdgeInsets.all(
                              Dimensions.paddingSizeExtraSmall),
                          child: const Icon(Icons.share,
                              size: 24, color: Colors.white),
                        ),
                      ),
                    ]),
                    SizedBox(
                        height: ResponsiveHelper.isDesktop(context)
                            ? Dimensions.paddingSizeSmall
                            : 0),
                    Row(children: [
                      Text('minimum_order_amount'.tr,
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeExtraSmall,
                            color: Theme.of(context).disabledColor,
                          )),
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                      Text(
                        PriceConverter.convertPrice(store!.minimumOrder),
                        textDirection: TextDirection.ltr,
                        style: robotoMedium.copyWith(
                            fontSize: Dimensions.fontSizeExtraSmall,
                            color: Theme.of(context).primaryColor),
                      ),
                    ]),
                  ])),
            ])
          : const SizedBox(),
      SizedBox(
          height: ResponsiveHelper.isDesktop(context)
              ? 30
              : Dimensions.paddingSizeSmall),
      ResponsiveHelper.isDesktop(context)
          ? IntrinsicHeight(
              child: Row(children: [
                const Expanded(child: SizedBox()),
                InkWell(
                  onTap: () => Get.toNamed(
                      RouteHelper.getRestaurantReviewRoute(store!.id)),
                  child: Column(children: [
                    Row(children: [
                      Icon(Icons.star,
                          color: Theme.of(context).primaryColor, size: 20),
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                      Text(
                        store!.avgRating!.toStringAsFixed(1),
                        style: robotoMedium.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: textColor),
                      ),
                    ]),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                    Text(
                      '${store!.ratingCount} + ${'ratings'.tr}',
                      style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall, color: textColor),
                    ),
                  ]),
                ),
                const Expanded(child: SizedBox()),
                const VerticalDivider(color: Colors.white, thickness: 1),
                const Expanded(child: SizedBox()),
                InkWell(
                  onTap: () => Get.toNamed(RouteHelper.getMapRoute(
                    AddressModel(
                      id: store!.id,
                      address: store!.address,
                      latitude: store!.latitude,
                      longitude: store!.longitude,
                      contactPersonNumber: '',
                      contactPersonName: '',
                      addressType: '',
                    ),
                    'store',
                  )),
                  child: Column(children: [
                    // Icon(Icons.location_on, color: Theme.of(context).primaryColor, size: 20),
                    Image.asset(Images.restaurantLocationIcon,
                        height: 20, width: 20),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                    Text('location'.tr,
                        style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: textColor)),
                  ]),
                ),
                const Expanded(child: SizedBox()),
                const VerticalDivider(color: Colors.white, thickness: 1),
                const Expanded(child: SizedBox()),
                Column(children: [
                  Image.asset(Images.restaurantDeliveryTimeIcon,
                      height: 20, width: 20),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  Text(store!.deliveryTime!,
                      style: robotoMedium.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          color: textColor)),
                ]),
                (store!.delivery! && store!.freeDelivery!)
                    ? const Expanded(child: SizedBox())
                    : const SizedBox(),
                (store!.delivery! && store!.freeDelivery!)
                    ? const VerticalDivider(color: Colors.white, thickness: 1)
                    : const SizedBox(),
                (store!.delivery! && store!.freeDelivery!)
                    ? const Expanded(child: SizedBox())
                    : const SizedBox(),
                (store!.delivery! && store!.freeDelivery!)
                    ? Column(children: [
                        Icon(Icons.money_off,
                            color: Theme.of(context).primaryColor, size: 20),
                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                        Text('free_delivery'.tr,
                            style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                color: textColor)),
                      ])
                    : const SizedBox(),
                const Expanded(child: SizedBox()),
              ]),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: InkWell(
                    onTap: () => Get.toNamed(
                        RouteHelper.getRestaurantReviewRoute(store!.id)),
                    child: Column(children: [
                      Container(
                        height: 37,
                        width: 80,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8)),
                          color: Colors.green.shade500,
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.star,
                                      color: Theme.of(context).cardColor,
                                      size: 20),
                                  const SizedBox(
                                      width: Dimensions.paddingSizeExtraSmall),
                                  FittedBox(
                                    child: Text(
                                      store!.avgRating!.toStringAsFixed(1),
                                      style: robotoMedium.copyWith(
                                          fontSize: Dimensions.fontSizeLarge,
                                          color: Theme.of(context).cardColor),
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                      ),
                      Container(
                        height: 43,
                        width: 80,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey, // Shadow color
                              offset:
                                  Offset(0, 2), // Offset in x and y directions
                              blurRadius: 6, // Blur radius
                              spreadRadius: 2, // Spread radius
                            ),
                          ],
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                FittedBox(
                                  child: Text(
                                    '${store!.ratingCount} +',
                                    style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeSmall,
                                        color: Colors.black),
                                  ),
                                ),
                                Text(
                                  'ratings'.tr,
                                  style: robotoRegular.copyWith(
                                      fontSize: Dimensions.fontSizeSmall,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.black12),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15))),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              onTap: () {},
                              // onTap: () => Get.toNamed(RouteHelper.getMapRoute(
                              //     AddressModel(
                              //       id: store!.id,
                              //       address: store!.address,
                              //       latitude: store!.latitude,
                              //       longitude: store!.longitude,
                              //       contactPersonNumber: '',
                              //       contactPersonName: '',
                              //       addressType: '',
                              //     ),
                              //     'store',
                              //   )),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Column(children: [
                                  Icon(Icons.location_on_outlined,
                                      color: Theme.of(context).primaryColor,
                                      size: 20),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text("Location",
                                      style: robotoRegular.copyWith(
                                          fontSize: Dimensions.fontSizeSmall,
                                          color: textColor)),
                                ]),
                              ),
                            ),
                            Container(
                              width: 1,
                              height:
                                  40, // Adjust the width of the line as needed
                              color: Colors.black, // Set the color of the line
                            ),
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Column(children: [
                                Icon(Icons.money,
                                    color: Theme.of(context).primaryColor,
                                    size: 20),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    FittedBox(
                                      child: Text(
                                        "Min Order : ",
                                        style: robotoRegular.copyWith(
                                          fontSize: Dimensions.fontSizeSmall,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    FittedBox(
                                      child: Text(
                                        PriceConverter.convertPrice(
                                            store!.minimumOrder),
                                        textDirection: TextDirection.ltr,
                                        style: robotoMedium.copyWith(
                                            fontSize: Dimensions.fontSizeSmall,
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                    ),
                                  ],
                                ),
                              ]),
                            ),
                            Container(
                              width: 1,
                              height:
                                  40, // Adjust the width of the line as needed
                              color: Colors.black, // Set the color of the line
                            ),
                            Column(children: [
                              SizedBox(
                                  height: ResponsiveHelper.isDesktop(context)
                                      ? Dimensions.paddingSizeExtraSmall
                                      : 0),
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Column(children: [
                                  Icon(Icons.delivery_dining,
                                      color: Theme.of(context).primaryColor,
                                      size: 20),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    store!.deliveryTime!
                                        .replaceAll(" min", " Mints"),
                                    style: robotoMedium.copyWith(
                                        fontSize: Dimensions.fontSizeSmall,
                                        color: textColor),
                                  ),
                                ]),
                                //  const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                // Text('delivery_time'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: textColor)),
                              )
                            ]),
                          ]),
                    ),
                  ),
                ),
              ],
            ),
    ]);
  }
}

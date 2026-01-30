import 'package:stackfood_multivendor/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor/features/cart/controllers/cart_controller.dart';
import 'package:stackfood_multivendor/features/coupon/controllers/coupon_controller.dart';
import 'package:stackfood_multivendor/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/helper/price_converter.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../helper/auth_helper.dart';
import '../domain/models/cart_model.dart';

class CheckoutButtonWidget extends StatelessWidget {
  final CartController cartController;
  final List<bool> availableList;
  final bool isRestaurantOpen;
  const CheckoutButtonWidget(
      {super.key,
      required this.cartController,
      required this.availableList,
      required this.isRestaurantOpen});

  @override
  Widget build(BuildContext context) {
    double percentage = 0;
    bool isDesktop = ResponsiveHelper.isDesktop(context);

    return Container(
      width: Dimensions.webMaxWidth,
      padding: const EdgeInsets.symmetric(
        vertical: Dimensions.paddingSizeSmall,
        // horizontal: Dimensions.paddingSizeDefault
      ),
      decoration: isDesktop
          ? null
          : BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
      child: SafeArea(
        child:
            GetBuilder<RestaurantController>(builder: (restaurantController) {
          if (Get.find<RestaurantController>().restaurant != null &&
              Get.find<RestaurantController>().restaurant!.freeDelivery !=
                  null &&
              !Get.find<RestaurantController>().restaurant!.freeDelivery! &&
              Get.find<SplashController>().configModel!.freeDeliveryOver !=
                  null) {
            percentage = cartController.subTotal /
                Get.find<SplashController>().configModel!.freeDeliveryOver!;
          }
          return Column(mainAxisSize: MainAxisSize.min, children: [
            (restaurantController.restaurant != null &&
                    restaurantController.restaurant!.freeDelivery != null &&
                    !restaurantController.restaurant!.freeDelivery! &&
                    Get.find<SplashController>()
                            .configModel!
                            .freeDeliveryOver !=
                        null &&
                    percentage < 1)
                ? Padding(
                    padding: EdgeInsets.only(
                        bottom: isDesktop ? Dimensions.paddingSizeLarge : 0),
                    child: Column(children: [
                      Row(children: [
                        Image.asset(Images.percentTag, height: 20, width: 20),
                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                        PriceConverter.convertAnimationPrice(
                          Get.find<SplashController>()
                                  .configModel!
                                  .freeDeliveryOver! -
                              cartController.subTotal,
                          textStyle: robotoMedium.copyWith(
                              color: Theme.of(context).primaryColor),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                        Text('more_for_free_delivery'.tr,
                            style: robotoMedium.copyWith(
                                color: Theme.of(context).disabledColor)),
                      ]),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                      LinearProgressIndicator(
                        backgroundColor:
                            Theme.of(context).primaryColor.withOpacity(0.2),
                        value: percentage,
                      ),
                    ]),
                  )
                : const SizedBox(),
            !isDesktop
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: Dimensions.paddingSizeSmall),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('subtotal'.tr,
                            style: robotoMedium.copyWith(
                                color: Theme.of(context).primaryColor)),
                        PriceConverter.convertAnimationPrice(
                            cartController.subTotal,
                            textStyle: robotoRegular.copyWith(
                                color: Theme.of(context).primaryColor)),
                      ],
                    ),
                  )
                : const SizedBox(),
            GetBuilder<CartController>(builder: (cartController) {
              return CustomButtonWidget(
                color: Colors.black,
                radius: 10,
                buttonText: 'proceed_to_checkout'.tr,
                textColor: Colors.white,
                onPressed: cartController.isLoading
                    ? null
                    : () async {
                        //print("ff ${cartController.cartList[2].availablefoodtime}");

                        if (AuthHelper.isLoggedIn()) {
                          if (Get.find<CartController>().time != null) {
                            String? unavailableProductName =
                                getFirstUnavailableProduct(
                                    cartController.cartList);
                            if (unavailableProductName != null) {
                              showCustomSnackBar(
                                  'one_or_more_product_unavailable'.tr);
                            } else {
                              _processToCheckoutButtonPressed(
                                  restaurantController);
                            }
                          } else {
                            showCustomSnackBar(
                                'Please Select a Preference Time');
                          }
                          //   _processToCheckoutButtonPressed(restaurantController);
                        } else {
                          showCustomSnackBar(
                            'Please Login',
                            showToaster: true,
                          );
                          await Get.toNamed(
                              RouteHelper.getSignInRoute(Get.currentRoute));
                        }
                      },
              );
            }),
            SizedBox(height: isDesktop ? Dimensions.paddingSizeExtraLarge : 0),
          ]);
        }),
      ),
    );
  }

  getFirstUnavailableProduct(products) {
    for (int i = 0; i < products.length; i++) {
      CartModel cartItem = products[i];
      if (cartItem.availablefoodtime == false) {
        // If false, return the product
        return cartItem.product!.name;
      }
    }

    // Return null if no product with available_food_time false is found
    return null;
  }

  void _processToCheckoutButtonPressed(
      RestaurantController restaurantController) {
    if (!cartController.cartList.first.product!.scheduleOrder! &&
        cartController.availableList.contains(false)) {
      showCustomSnackBar('one_or_more_product_unavailable'.tr);
    } else if (restaurantController.restaurant?.freeDelivery == null ||
        restaurantController.restaurant?.cutlery == null) {
      showCustomSnackBar('restaurant_is_unavailable'.tr);
    } /* else if(!isRestaurantOpen) {
      showCustomSnackBar('restaurant_is_close_now'.tr);
    } */
    else {
      Get.find<CouponController>().removeCouponData(false);
      Get.toNamed(RouteHelper.getCheckoutRoute('cart'));
    }
  }
}

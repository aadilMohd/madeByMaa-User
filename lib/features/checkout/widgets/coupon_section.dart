import 'package:lottie/lottie.dart';
import 'package:stackfood_multivendor/features/checkout/controllers/checkout_controller.dart';
import 'package:stackfood_multivendor/features/checkout/widgets/coupon_bottom_sheet.dart';
import 'package:stackfood_multivendor/features/coupon/controllers/coupon_controller.dart';
import 'package:stackfood_multivendor/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/custom_snackbar_widget.dart';
import '../../../helper/price_converter.dart';
import '../../language/controllers/localization_controller.dart';
class CouponSection extends StatefulWidget {
  final CheckoutController checkoutController;
  final double price;
  final double discount;
  final double addOns;
  final double deliveryCharge;
  final double charge;
  final double total;
  const CouponSection({super.key, required this.checkoutController, required this.price, required this.discount, required this.addOns, required this.deliveryCharge, required this.total, required this.charge});

  @override
  State<CouponSection> createState() => _CouponSectionState();
}

class _CouponSectionState extends State<CouponSection>with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);
    _animationController.addStatusListener((status) async{
      if(status == AnimationStatus.completed){
        Navigator.pop(context);
        //  Get.back();
        _animationController.reset();
      }
    });
  }
  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    bool isDesktop = ResponsiveHelper.isDesktop(context);
    double totalPrice = widget.total;


    return GetBuilder<CouponController>(
      builder: (couponController) {
        int? restid=Get.find<RestaurantController>().restaurant!.id;

        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withOpacity(0.05), blurRadius: 10)],
          ),
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
          child: Column(children: [

            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(
                children: [
                  Text('promo_code'.tr, style: robotoMedium),
                  SizedBox(width: 5,),
                  Image.asset(Images.discountOfferIcon,height: 15,width: 15,)
                ],
              ),
              InkWell(
                onTap: () {

                  if(ResponsiveHelper.isDesktop(context)){
                    Get.dialog(Dialog(child:
                    CouponBottomSheet(checkoutController: widget.checkoutController, price: widget.price, discount: widget.discount, addOns: widget.addOns, deliveryCharge: widget.deliveryCharge, charge: widget.charge, total: widget.total),
                    )).then((value) {
                      if(value != null) {
                        widget.checkoutController.couponController.text = value.toString();
                      }
                    });
                  }else{
                    showModalBottomSheet(
                      context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
                      builder: (con) =>
                          CouponBottomSheet(checkoutController: widget.checkoutController, price: widget.price, discount: widget.discount, addOns: widget.addOns, deliveryCharge: widget.deliveryCharge, charge: widget.charge, total: widget.total),
                    ).then((value) async {
                      if(value != null){
                        if(value != null) {
                          widget.checkoutController.couponController.text = value.toString();
                        }
                        if(widget.checkoutController.couponController.text.isNotEmpty){
                          if(Get.find<CouponController>().discount! < 1 && !Get.find<CouponController>().freeDelivery) {
                            if(widget.checkoutController.couponController.text.isNotEmpty && !Get.find<CouponController>().isLoading) {
                              Get.find<CouponController>().applyCoupon(widget.checkoutController.couponController.text, (widget.price-widget.discount)+widget.addOns, widget.deliveryCharge,
                                  widget.charge, totalPrice, Get.find<RestaurantController>().restaurant!.id ?? -1, hideBottomSheet: true).then((discount) {
                                if (discount! > 0) {
                                  widget.checkoutController.couponController.text = 'coupon_applied'.tr;
                                  showCouponAppliedDialog('Coupon', PriceConverter.convertPrice(discount));

                                  /* showCustomSnackBar(
                                    '${'you_got_discount_of'.tr} ${PriceConverter.convertPrice(discount)}',
                                    isError: false,
                                  );*/
                                  if(widget.checkoutController.isPartialPay || widget.checkoutController.paymentMethodIndex == 1) {
                                    totalPrice = totalPrice - discount;
                                    widget.checkoutController.checkBalanceStatus(totalPrice);
                                  }
                                }
                              });
                            } else if(widget.checkoutController.couponController.text.isEmpty) {
                              showCustomSnackBar('enter_a_coupon_code'.tr);
                            }
                          } else {
                            Get.find<CouponController>().removeCouponData(true);
                            widget.checkoutController.couponController.text = '';
                          }
                        }

                      }

                    });
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(children: [
                    Text('add_voucher'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor)),
                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                    Icon(Icons.add, size: 20, color: Theme.of(context).primaryColor),
                  ]),
                ),
              )
            ]),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                border: Border.all(color: Theme.of(context).primaryColor, width: 0.2),
              ),
              padding: const EdgeInsets.only(left: 5),
              child: Row(children: [
                Expanded(
                  child: SizedBox(
                    height: 45,
                    child: TextField(
                      controller: widget.checkoutController.couponController,
                      style: robotoRegular.copyWith(height: ResponsiveHelper.isMobile(context) ? null : 2),
                      decoration: InputDecoration(
                        hintText: 'enter_promo_code'.tr,
                        hintStyle: robotoRegular.copyWith(color: Theme.of(context).hintColor),
                        isDense: true,
                        filled: true,
                        enabled: couponController.discount == 0,
                        fillColor: Theme.of(context).cardColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(Get.find<LocalizationController>().isLtr ? 10 : 0),
                            right: Radius.circular(Get.find<LocalizationController>().isLtr ? 0 : 10),
                          ),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all( 15),
                          child: Image.asset(Images.couponIcon, height: 10, width: 20, color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    if(widget.checkoutController.couponController.text.isNotEmpty){
                      if(Get.find<CouponController>().discount! < 1 && !Get.find<CouponController>().freeDelivery) {
                        if(widget.checkoutController.couponController.text.isNotEmpty && !Get.find<CouponController>().isLoading) {
                          Get.find<CouponController>().applyCoupon(widget.checkoutController.couponController.text, (widget.price-widget.discount)+widget.addOns, widget.deliveryCharge,
                              widget.charge, totalPrice, Get.find<RestaurantController>().restaurant!.id ?? -1, hideBottomSheet: true).then((discount) {
                            if (discount! > 0) {
                              widget.checkoutController.couponController.text = 'coupon_applied'.tr;

                              showCouponAppliedDialog('Coupon', PriceConverter.convertPrice(discount));
                              /* showCustomSnackBar(
                                '${'you_got_discount_of'.tr} ${PriceConverter.convertPrice(discount)}',
                                isError: false,
                              );*/
                              if(widget.checkoutController.isPartialPay || widget.checkoutController.paymentMethodIndex == 1) {
                                totalPrice = totalPrice - discount;
                                widget.checkoutController.checkBalanceStatus(totalPrice);
                              }
                            }
                          });
                        } else if(widget.checkoutController.couponController.text.isEmpty) {
                          showCustomSnackBar('enter_a_coupon_code'.tr);
                        }
                      } else {
                        totalPrice = totalPrice + couponController.discount!;
                        Get.find<CouponController>().removeCouponData(true);
                        widget.checkoutController.couponController.text = '';
                        if(widget.checkoutController.isPartialPay || widget.checkoutController.paymentMethodIndex == 1){
                          widget.checkoutController.checkBalanceStatus(totalPrice);
                        }
                      }
                    }
                  },
                  child: Container(
                    height: 45, width: (couponController.discount! <= 0 && !couponController.freeDelivery) ? 100 : 50,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                    decoration: BoxDecoration(
                      color: (couponController.discount! <= 0 && !couponController.freeDelivery) ? Theme.of(context).primaryColor : Colors.transparent,
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    ),
                    child: (couponController.discount! <= 0 && !couponController.freeDelivery) ? !couponController.isLoading ? Text(
                      'apply'.tr,
                      style: robotoMedium.copyWith(color: Theme.of(context).cardColor),
                    ) : const SizedBox(
                      height: 30, width: 30,
                      child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                    )
                        : Icon(Icons.clear, color: Theme.of(context).colorScheme.error),
                  ),
                ),
              ]),
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),

          ]),
        );

        /* return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 1))],
          ),
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          margin: EdgeInsets.symmetric(horizontal: isDesktop ? Dimensions.paddingSizeLarge : Dimensions.paddingSizeDefault),
          child: (couponController.discount! <= 0 && !couponController.freeDelivery) ? Row(children: [
            Expanded(
              child: Row(children: [
                Image.asset(Images.couponIcon1, height: 20, width: 20),
                const SizedBox(width: Dimensions.paddingSizeSmall),
                Text('add_coupon'.tr, style: robotoRegular),
              ]),
            ),

            InkWell(
              onTap: () {
                if(ResponsiveHelper.isDesktop(context)){
                  Get.dialog(Dialog(child: CouponBottomSheet(checkoutController: widget.checkoutController, price: widget.price, discount: widget.discount, addOns: widget.addOns, deliveryCharge: widget.deliveryCharge, charge: widget.charge, total: widget.total))).then((value) {
                    if(value != null) {
                      widget.checkoutController.couponController.text = value.toString();
                    }
                  });
                }else{
                  Get.bottomSheet(
                    CouponBottomSheet(checkoutController: widget.checkoutController, price: widget.price, discount: widget.discount, addOns: widget.addOns, deliveryCharge: widget.deliveryCharge, charge: widget.charge, total: widget.total),
                    backgroundColor: Colors.transparent, isScrollControlled: true,
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(children: [
                  Text('add'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                  const Icon(Icons.add, size: 20),
                ]),
              ),
            ),
          ]) : Column(children: [
            Row(children: [
              const Icon(Icons.check_circle_rounded, size: 16, color: Colors.green),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              Text('${'coupon_applied'.tr}!', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
            ]),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                border: Border.all(color: Theme.of(context).disabledColor, width: 0.6),
              ),
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
              child: Row(
                children: [
                  Expanded(
                    child: Row(children: [
                      Image.asset(Images.couponIcon1, height: 20, width: 20),
                      const SizedBox(width: Dimensions.paddingSizeSmall),
                      Text(widget.checkoutController.couponController.text, style: robotoRegular),
                    ]),
                  ),

                  InkWell(
                  onTap: () {
                    couponController.removeCouponData(true);
                    widget.checkoutController.couponController.text = '';
                    if(widget.checkoutController.isPartialPay || widget.checkoutController.paymentMethodIndex == 1){
                      widget.checkoutController.checkBalanceStatus((widget.total + widget.charge));
                    }
                  },
                    child: SizedBox(height: 50, width: 50, child: Icon(Icons.clear, color: Theme.of(context).colorScheme.error)),
                  )
                ],
              ),
            )
          ]),
        );*/
      },
    );
  }
  void showCouponAppliedDialog(String code, String savedAmount) => showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                child: Column(
                  mainAxisSize : MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                        'assets/animation/done.json',
                        width: 100,
                        height: 100,
                        repeat: false,
                        controller: _animationController,
                        onLoaded: (composition){
                          _animationController.duration = const Duration(milliseconds: 5000); // Set duration to 5 seconds (5000 milliseconds)
                          _animationController.forward();
                        }
                    ),
                    const SizedBox(height: Dimensions.paddingSizeSmall,),
                    Text(
                      '$code applied',
                      style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeSmall,),
                    Text(
                      'You saved $savedAmount',
                      style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeOverLarge),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeSmall,),
                    Text(
                      'with this coupon code',
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge,),
                    Text(
                      'Woohoo! Thanks',
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Colors.deepOrangeAccent),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                child: Lottie.asset(
                  'assets/animation/confetti.json',
                  repeat: false,
                  animate: true,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      )
  );

}

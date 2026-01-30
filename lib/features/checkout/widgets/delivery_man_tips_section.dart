import 'dart:async';

import 'package:lottie/lottie.dart';
import 'package:stackfood_multivendor/features/checkout/controllers/checkout_controller.dart';
import 'package:stackfood_multivendor/features/checkout/widgets/tips_widget.dart';
import 'package:stackfood_multivendor/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/helper/price_converter.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/app_constants.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
class DeliveryManTipsSection extends StatefulWidget {
  final bool takeAway;
  final JustTheController tooltipController3;
  final CheckoutController checkoutController;
  final double totalPrice;
  final Function(double x) onTotalChange;
  const DeliveryManTipsSection({super.key, required this.takeAway, required this.tooltipController3, required this.checkoutController, required this.totalPrice, required this.onTotalChange});

  @override
  State<DeliveryManTipsSection> createState() => _DeliveryManTipsSectionState();
}

class _DeliveryManTipsSectionState extends State<DeliveryManTipsSection> {
  bool canCheckSmall = false;
  bool isConfettiVisible = false;
  late Timer _timer;

  void _showConfetti() {
    setState(() {
      isConfettiVisible = true;
    });

    _timer = Timer(const Duration(seconds: 5), () {
      setState(() {
        isConfettiVisible = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer(Duration.zero, () {});
  }
  @override
  void dispose(){
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    double total = widget.totalPrice;
    bool isDesktop = ResponsiveHelper.isDesktop(context);
    return Stack(
      children: [
        Column(
          children: [
            (!widget.checkoutController.subscriptionOrder && !widget.takeAway && Get.find<SplashController>().configModel!.dmTipsStatus == 1) ? 
            Padding(
              padding: const EdgeInsets.only(left: 8.0,right: 8),
              child: Container(
                decoration:  BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.red.shade50.withOpacity(0.5)
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top:10,bottom: 10,left: 12),
                  child: Column(
                    children: [
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Thank you for generous tips for your future\n orders.They'll be passed on to your delivery partner\n as soon as the orders are delivered.", style: robotoRegular.copyWith(color: Colors.black),maxLines: 3,)),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      SizedBox(
                        height: (widget.checkoutController.selectedTips == AppConstants.tips.length-1) && widget.checkoutController.canShowTipsField
                            ? 0 : ResponsiveHelper.isDesktop(context) ? 80 : 60,
                        child: (widget.checkoutController.selectedTips == AppConstants.tips.length-1) && widget.checkoutController.canShowTipsField
                            ? const SizedBox() : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: AppConstants.tips.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                TipsWidget(
                                  index: index,
                                  title: AppConstants.tips[index] == '0' ? 'not_now'.tr : (index != AppConstants.tips.length -1) ? PriceConverter.convertPrice(double.parse(AppConstants.tips[index].toString()), forDM: true) : AppConstants.tips[index].tr,
                                  isSelected: widget.checkoutController.selectedTips == index,
                                  isSuggested: index != 0 && AppConstants.tips[index] == widget.checkoutController.mostDmTipAmount.toString(),
                                  onTap: () {
                                    _showConfetti();
                                    total = total - widget.checkoutController.tips;
                                    widget.checkoutController.updateTips(index);
                                    if(widget.checkoutController.selectedTips != AppConstants.tips.length-1) {
                                      widget.checkoutController.addTips(double.parse(AppConstants.tips[index]));
                                    }
                                    if(widget.checkoutController.selectedTips == AppConstants.tips.length-1) {
                                      widget.checkoutController.showTipsField();
                                    }
                                    widget.checkoutController.tipController.text = widget.checkoutController.tips.toString();
                                    if(widget.checkoutController.isPartialPay || widget.checkoutController.paymentMethodIndex == 1) {
                                      widget.checkoutController.checkBalanceStatus(total, extraCharge: widget.checkoutController.tips);
                                    }
                                  },
                                )                              ],
                            );
                          },
                        ),
                      ),
                      SizedBox(height: (widget.checkoutController.selectedTips == AppConstants.tips.length-1) && widget.checkoutController.canShowTipsField ? Dimensions.paddingSizeExtraSmall : 0),
                      widget.checkoutController.selectedTips == AppConstants.tips.length-1 ? const SizedBox() :
                      ListTile(
                        onTap: () => widget.checkoutController.toggleDmTipSave(),
                        leading: Checkbox(
                          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                          activeColor: Theme.of(context).primaryColor,
                          value: widget.checkoutController.isDmTipSave,
                          onChanged: (bool? isChecked) => widget.checkoutController.toggleDmTipSave(),
                        ),
                        title: Padding(
                          padding: const EdgeInsets.only(right: 55.0),
                          child: Text('save_for_later'.tr, style: robotoBold.copyWith(color: Theme.of(context).primaryColor)),
                        ),
                        contentPadding: EdgeInsets.zero,
                        visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                        dense: true,
                        horizontalTitleGap: 0,
                      ),
                      SizedBox(height: widget.checkoutController.selectedTips == AppConstants.tips.length-1 ? Dimensions.paddingSizeDefault : 0),
        
                      widget.checkoutController.selectedTips == AppConstants.tips.length-1 ? Row(children: [
                        Expanded(
                          child: CustomTextFieldWidget(
                            titleText: 'enter_amount'.tr,
                            controller: widget.checkoutController.tipController,
                            inputAction: TextInputAction.done,
                            inputType: TextInputType.number,
                            onSubmit: (value) async {
                              if(value.isNotEmpty){
                                try{
                                  if(double.parse(value) >= 0){
                                    if(Get.find<AuthController>().isLoggedIn()) {
                                      total = total - widget.checkoutController.tips;
                                      await widget.checkoutController.addTips(double.parse(value));
                                      total = total + widget.checkoutController.tips;
                                      widget.onTotalChange(total);
                                      if(Get.find<ProfileController>().userInfoModel!.walletBalance! < total && widget.checkoutController.paymentMethodIndex == 1){
                                        widget.checkoutController.checkBalanceStatus(total);
                                        canCheckSmall = true;
                                      } else if(Get.find<ProfileController>().userInfoModel!.walletBalance! > total && canCheckSmall && widget.checkoutController.isPartialPay){
                                        widget.checkoutController.checkBalanceStatus(total);
                                      }
                                    } else {
                                      widget.checkoutController.addTips(double.parse(value));
                                    }

                                  }else{
                                    showCustomSnackBar('tips_can_not_be_negative'.tr);
                                  }
                                } catch(e) {
                                  showCustomSnackBar('invalid_input'.tr);
                                  widget.checkoutController.addTips(0.0);
                                  widget.checkoutController.tipController.text = widget.checkoutController.tipController.text.substring(0, widget.checkoutController.tipController.text.length-1);
                                  widget.checkoutController.tipController.selection = TextSelection.collapsed(offset: widget.checkoutController.tipController.text.length);
                                }
                              }else{
                                widget.checkoutController.addTips(0.0);
                              }
                            },

                            onChanged: (String value) async {
                              if(value.isNotEmpty){
                                try{
                                  if(double.parse(value) >= 0){
                                    if(Get.find<AuthController>().isLoggedIn()) {
                                      total = total - widget.checkoutController.tips;
                                      await widget.checkoutController.addTips(double.parse(value));
                                      total = total + widget.checkoutController.tips;
                                      widget.onTotalChange(total);
                                      if(Get.find<ProfileController>().userInfoModel!.walletBalance! < total && widget.checkoutController.paymentMethodIndex == 1){
                                        widget.checkoutController.checkBalanceStatus(total);
                                        canCheckSmall = true;
                                      } else if(Get.find<ProfileController>().userInfoModel!.walletBalance! > total && canCheckSmall && widget.checkoutController.isPartialPay){
                                        widget.checkoutController.checkBalanceStatus(total);
                                      }
                                    } else {
                                      widget.checkoutController.addTips(double.parse(value));
                                    }

                                  }else{
                                    showCustomSnackBar('tips_can_not_be_negative'.tr);
                                  }
                                } catch(e){
                                  showCustomSnackBar('invalid_input'.tr);
                                  widget.checkoutController.addTips(0.0);
                                  widget.checkoutController.tipController.text = widget.checkoutController.tipController.text.substring(0, widget.checkoutController.tipController.text.length-1);
                                  widget.checkoutController.tipController.selection = TextSelection.collapsed(offset: widget.checkoutController.tipController.text.length);
                                }
                              }else{
                                widget.checkoutController.addTips(0.0);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeSmall),
        
                        InkWell(
                          onTap: () {
                            widget.checkoutController.updateTips(0);
                            widget.checkoutController.showTipsField();
                            if(widget.checkoutController.isPartialPay) {
                              widget.checkoutController.changePartialPayment();
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).primaryColor.withOpacity(0.5),
                            ),
                            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                            child: const Icon(Icons.clear),
                          ),
                        ),
                      ]) : const SizedBox(),
        
                    ],
                  ),
                ),
              ),
            ):SizedBox.shrink(),
        
        
            SizedBox(height: (!widget.takeAway && Get.find<SplashController>().configModel!.dmTipsStatus == 1)
                ? Dimensions.paddingSizeSmall : 0),
          ],
        ),
        if (isConfettiVisible)
          Positioned(
            left: 0,
            bottom: -40,
            right: 0,
            child: Lottie.asset(
              'assets/animation/c.json',
              repeat: false,
              animate: true,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return const SizedBox();
              },
            ),
          ),
      ],
    );
  }
}

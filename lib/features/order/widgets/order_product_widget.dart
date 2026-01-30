import 'package:dotted_line/dotted_line.dart';
import 'package:stackfood_multivendor/common/widgets/custom_asset_image_widget.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/order/domain/models/order_details_model.dart';
import 'package:stackfood_multivendor/features/order/domain/models/order_model.dart';
import 'package:stackfood_multivendor/common/models/product_model.dart';
import 'package:stackfood_multivendor/helper/price_converter.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderProductWidget extends StatelessWidget {
  final OrderModel order;
  final OrderDetailsModel orderDetails;
  const OrderProductWidget({super.key, required this.order, required this.orderDetails});
  
  @override
  Widget build(BuildContext context) {
    String addOnText = '';
    for (var addOn in orderDetails.addOns!) {
      addOnText = '$addOnText${(addOnText.isEmpty) ? '' : ',  '}${addOn.name} (${addOn.quantity})';
    }

    String? variationText = '';
    if(orderDetails.variation!.isNotEmpty) {
      for(Variation variation in orderDetails.variation!) {
        variationText = '${variationText!}${variationText.isNotEmpty ? ', ' : ''}${variation.name} (';
        for(VariationValue value in variation.variationValues!) {
          variationText = '${variationText!}${variationText.endsWith('(') ? '' : ', '}${value.level}';
        }
        variationText = '${variationText!})';
      }
    }else if(orderDetails.oldVariation!.isNotEmpty) {
      List<String> variationTypes = orderDetails.oldVariation![0].type!.split('-');
      if(variationTypes.length == orderDetails.foodDetails!.choiceOptions!.length) {
        int index = 0;
        for (var choice in orderDetails.foodDetails!.choiceOptions!) {
          variationText = '${variationText!}${(index == 0) ? '' : ',  '}${choice.title} - ${variationTypes[index]}';
          index = index + 1;
        }
      }else {
        variationText = orderDetails.oldVariation![0].type;
      }
    }
    
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      ),
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeLarge),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          orderDetails.foodDetails!.image != null && orderDetails.foodDetails!.image!.isNotEmpty ?
          Padding(
            padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              child: CustomImageWidget(
                height: 80, width: 80, fit: BoxFit.cover,
                image: '${orderDetails.itemCampaignId != null ? Get.find<SplashController>().configModel!.baseUrls!.campaignImageUrl
                    : Get.find<SplashController>().configModel!.baseUrls!.productImageUrl}/'
                    '${orderDetails.foodDetails!.image}',
                isFood: true,
              ),
            ),
          ) : const SizedBox.shrink(),

          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Expanded(child: Text(
                  orderDetails.foodDetails!.name!,
                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                  maxLines: 2, overflow: TextOverflow.ellipsis,
                )),

                Text(
                  "₹"+PriceConverter.convertPrice(orderDetails.price),
                  style:  robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge), textDirection: TextDirection.ltr,
                )

              ]),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),
              Text('${'Qty'.tr}: ${orderDetails.quantity}', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),

              // Row(children: [
              //
              //   // Expanded(child: Text(
              //   //   PriceConverter.convertPrice(orderDetails.price),
              //   //   style: robotoMedium, textDirection: TextDirection.ltr,
              //   // )),
              //
              //   Get.find<SplashController>().configModel!.toggleVegNonVeg! ? CustomAssetImageWidget(
              //     orderDetails.foodDetails!.veg == 0 ? Images.nonVegImage : Images.vegImage,
              //     height: 11, width: 11,
              //   ) : const SizedBox(),
              //
              //   SizedBox(width: orderDetails.foodDetails!.isRestaurantHalalActive! && orderDetails.foodDetails!.isHalalFood! ? Dimensions.paddingSizeExtraSmall : 0),
              //
              //   orderDetails.foodDetails!.isRestaurantHalalActive! && orderDetails.foodDetails!.isHalalFood! ? const CustomAssetImageWidget(
              //    Images.halalIcon, height: 13, width: 13) : const SizedBox(),
              //
              // ]),

            ]),
          ),
        ]),

        addOnText.isNotEmpty ?
        Padding(
          padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
          child: Row(children: [
            const SizedBox(width: 60),
            Text('${'addons'.tr}: ', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
            Flexible(child: Text(
                addOnText,
                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor,
            ))),
          ]),
        ) : const SizedBox(),

        variationText != '' ? (orderDetails.foodDetails!.variations != null && orderDetails.foodDetails!.variations!.isNotEmpty) ? Padding(
          padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
          child: Row(children: [
            const SizedBox(width: 60),
            Text('${'variations'.tr}: ', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
            Flexible(child: Text(
                variationText!,
                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor,
            ))),
          ]),
        ) : const SizedBox() : const SizedBox(),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            const DottedLine(
              direction: Axis.horizontal,
              alignment: WrapAlignment.center,
              lineLength: double.infinity,
              lineThickness: 1.0,
              dashLength: 4.0,
              dashColor: Color(0xffA7A7A7),
              // dashGradient: [Colors.red, Colors.blue],
              dashRadius: 0.0,
              dashGapLength: 4.0,
              dashGapColor: Colors.transparent,
              // dashGapGradient: [Colors.red, Colors.blue],
              dashGapRadius: 0.0,
            ),
     // const Divider(height: Dimensions.paddingSizeLarge),
        const SizedBox(height: Dimensions.paddingSizeSmall),
      ]),
    );
  }
}

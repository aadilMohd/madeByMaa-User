import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/util/images.dart';

class WelcomeDialog extends StatelessWidget {
  const WelcomeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge)),
      insetPadding: const EdgeInsets.all(20),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      backgroundColor: Get.theme.primaryColor,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 24, vertical: 40),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: Dimensions.paddingSizeLarge),
                Text(
                  "Our mom-chefs prepare every order from scratch with the freshest ingredients.",
                  // textAlign: TextAlign.center,
                  style: robotoBold.copyWith(
                      fontSize: 16, color: Theme.of(context).cardColor),
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),
                Text("Placing a pre-order helps them:",
                  textAlign: TextAlign.left,
                  style: robotoMedium.copyWith(
                      fontSize: 14, color: Theme.of(context).cardColor),
                ),
                Text("• Plan and shop precisely, reducing waste.",
                  textAlign: TextAlign.left,
                  style: robotoMedium.copyWith(
                      fontSize: 14, color: Theme.of(context).cardColor),
                ),
                Text("• Cook your meal with care and attention.",
                  textAlign: TextAlign.left,
                  style: robotoMedium.copyWith(
                      fontSize: 14, color: Theme.of(context).cardColor),
                ),
                Text(
                  "• Ensure you get the fresh, highest quality, hygiene, and authentic taste.",
                  textAlign: TextAlign.left,
                  style: robotoMedium.copyWith(
                      fontSize: 14, color: Theme.of(context).cardColor),
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraOverLarge),
              ],
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.close),
              color: Theme.of(context).cardColor,
            ),
          ),
        ],
      ),
    );
  }
}

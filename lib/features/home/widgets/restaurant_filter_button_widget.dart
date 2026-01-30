import 'package:get/get.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';

class RestaurantsFilterButtonWidget extends StatelessWidget {
  const RestaurantsFilterButtonWidget({super.key, this.isSelected, this.onTap, required this.buttonText, this.image});

  final bool? isSelected;
  final void Function()? onTap;
  final String buttonText;
  final ImageProvider<Object>? image;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 35,
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          color:isSelected == true ?
          Color(0xff090018):
          Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          border: Border.all(color: isSelected == true ? Theme.of(context).primaryColor.withOpacity(0.3) : Color(0xff000000)),
        ),
        child:  Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (image != null)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Image(
                  image: image!,
                  height: 20,
                  width: 20,color: isSelected==true?Colors.white:Color(0xff090018),
                ),
              ),
            Center(child: Text(buttonText, style: robotoRegular.copyWith( fontSize: Dimensions.fontSizeSmall,
                fontWeight: isSelected == true ? FontWeight.w500 : FontWeight.w400,
                color:isSelected==true?Colors.white:Color(0xff090018),))),
          ],
        ),
      ),
    );
  }
}

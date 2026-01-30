
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../util/app_constants.dart';

class ProfileButtonWidget extends StatelessWidget {
  final IconData? icon;
  final String title;
  final bool? isButtonActive;
  final Function onTap;
  final Color? color;
  final String? iconImage;
  final bool isThemeSwitchButton;

  const ProfileButtonWidget(
      {super.key,
      this.icon,
      required this.title,
      required this.onTap,
      this.isButtonActive,
      this.color,
      this.iconImage,
      this.isThemeSwitchButton = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap as void Function()?,
      child: Container(
        height: isThemeSwitchButton ? 30 : 30,
        padding: EdgeInsets.symmetric(
          horizontal: isThemeSwitchButton ? 0 : 0,
          vertical: 0,
          // isButtonActive != null
          //     ? Dimensions.paddingSizeExtraSmall
          //     : Dimensions.paddingSizeDefault,
        ),
        decoration: BoxDecoration(
          // color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          // border: ResponsiveHelper.isDesktop(context) || isThemeSwitchButton
          //     ? null
          //     : Border.all(
          //         color: Theme.of(context).primaryColor.withOpacity(0.1),
          //         width: 1.5),
          // boxShadow: [
          //   BoxShadow(
          //       color: Theme.of(context).primaryColor.withOpacity(0.05),
          //       spreadRadius: 0,
          //       blurRadius: 4)
          // ],
        ),
        child: Row(children: [
          iconImage != null
              ? Image.asset(iconImage!, height: 25, width: 25)
              : Icon(icon,
                  size: isThemeSwitchButton ? 20 : 20,
                  color:
                      color ?? Theme.of(context).textTheme.bodyMedium!.color),
          const SizedBox(width: Dimensions.paddingSizeSmall),
          Expanded(child: Text(title, style: TextStyle(
            fontFamily: AppConstants.fontFamily,
            fontWeight: FontWeight.w400,
            color: const Color(0xff524A61),
            fontSize: Dimensions.fontSizeDefault,))),
          isButtonActive != null
              ?SizedBox(height: 25,width: 50,
                child: Stack(
                            alignment: Alignment.center,
                  children: [
                    Container(height: 17,width: 34,
                                decoration: BoxDecoration(color: isButtonActive==true?const Color(0xff007AFFF).withOpacity(0.4):Color(0xffDBDBDB),borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge)),
                              ),
                    isButtonActive==false?Positioned(left: 0,
                      child: Container(height: 25,width: 25,
                        decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge)),
                      ),
                    ):Positioned(right: 0,
                      child: Container(height: 25,width: 25,

                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(color: Colors.grey,blurStyle: BlurStyle.outer,blurRadius: 2,)
                            ],
                            color: Color(0xff007AFFF),borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge)),
                      ),
                    ),

                  ],
                ),
              )





          // Center(
          //   child: Container(
          //     height: 25,padding: EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeSmall2),
          //     width: 70, // Adjust width based on the desired aspect ratio
          //     child:     Transform.scale(
          //       scale: 0.9,
          //       child: GFToggle(
          //         onChanged: (bool? value) => onTap(),
          //         value: isButtonActive!,boxShape: BoxShape.circle,
          //         enabledThumbColor: isButtonActive==true?
          //         const Color(0xff007AFFF):
          //         Colors.white,
          //         disabledText: "",
          //         enabledText: "",
          //         enabledTrackColor:  const Color(0xff007AFFF).withOpacity(0.4),
          //         type: GFToggleType.android, // Android type is generally more compact
          //         borderRadius: BorderRadius.circular(12),
          //       ),
          //     ),
          //   ),
          // )


          // CupertinoSwitch(
          //         value: isButtonActive!,
          //         activeColor: Theme.of(context).primaryColor,
          //         onChanged: (bool? value) => onTap(),
          //         trackColor: Theme.of(context).primaryColor.withOpacity(0.5),
          //       )
              : const SizedBox()
        ]),
      ),
    );
  }
}

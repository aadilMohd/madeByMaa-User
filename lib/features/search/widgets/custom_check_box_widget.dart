import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';

class CustomCheckBoxWidget extends StatelessWidget {
  final String title;
  final bool value;
  final Function onClick;
  const CustomCheckBoxWidget(
      {super.key,
      required this.title,
      required this.value,
      required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
      child: InkWell(
        onTap: onClick as void Function()?,
        child: Row(children: [
          GestureDetector(
            onTap: () {
              onClick();
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xff524A61), width: 2),
                borderRadius: BorderRadius.circular(6),
              ),
              padding: const EdgeInsets.all(3),
              child: Container(
                decoration: BoxDecoration(
                  color: value ? const Color(0xff524A61) : Colors.transparent,
                  borderRadius: BorderRadius.circular(2),
                ),
                width: 15,
                height: 15,
              ),
            ),
          ),
          // SizedBox(
          //   height: 24,
          //   width: 24,
          //   child: Checkbox(
          //     splashRadius: 1.2,
          //     // fillColor: MaterialStatePropertyAll(Colors.grey),
          //     // checkColor: Colors.grey,
          //
          //     value: value,
          //     onChanged: (bool? isActive) => onClick(),
          //     materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          //
          //     side: BorderSide(color: Colors.black),
          //     activeColor: Theme.of(context).primaryColor,
          //     // activeColor: Colors.grey,
          //   ),
          // ),
          const SizedBox(width: Dimensions.paddingSizeExtraSmall),
          Text(title, style: robotoRegular),
        ]),
      ),
    );
  }
}

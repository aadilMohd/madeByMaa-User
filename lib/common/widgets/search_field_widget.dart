import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';

class SearchFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final IconData? suffixIcon;
  final IconData? prefixIcon;
  final Function iconPressed;
  final Function? onSubmit;
  final Function? onChanged;
  final Function()? onTap;
  const SearchFieldWidget({super.key, required this.controller, required this.hint,  this.suffixIcon, required this.iconPressed,
    this.onSubmit, this.onChanged, this.onTap, this.prefixIcon});

  @override
  State<SearchFieldWidget> createState() => _SearchFieldWidgetState();
}

class _SearchFieldWidgetState extends State<SearchFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return

      Container(
        height: 40,
      margin: EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault,Dimensions.paddingSizeSmall,Dimensions.paddingSizeDefault,0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 2,
            blurStyle: BlurStyle.outer,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: widget.controller,
        textInputAction: TextInputAction.search,
        onTap: widget.onTap,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            // borderRadius: BorderRadius.circular(
            //     ResponsiveHelper.isDesktop(context) ? Dimensions.radiusSmall : 60),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            // borderRadius: BorderRadius.circular(
            //     ResponsiveHelper.isDesktop(context) ? Dimensions.radiusSmall : 60),
            borderSide: BorderSide.none,
          ),
          hintText: widget.hint,
          hintStyle: robotoRegular.copyWith(
            fontSize: Dimensions.fontSizeSmall,
            color: Theme.of(context).disabledColor,
          ),
          border: OutlineInputBorder(
            // borderRadius: BorderRadius.circular(
            //     ResponsiveHelper.isDesktop(context) ? Dimensions.radiusSmall : 60),
            borderSide: BorderSide.none,
          ),
          // filled: true,
          // fillColor: Theme.of(context).cardColor,
          contentPadding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          suffixIcon: IconButton(
            onPressed: widget.iconPressed as void Function()?,
            icon: Icon(widget.suffixIcon, color: Theme.of(context).hintColor, size: 25),
          ),
          prefixIcon: IconButton(
            onPressed: widget.iconPressed as void Function()?,
            icon: Icon(widget.prefixIcon, color: Theme.of(context).hintColor, size: 25),
          ),
        ),
        onSubmitted: widget.onSubmit as void Function(String)?,
        onChanged: widget.onChanged as void Function(String)?,
      ),
    );

  }
}

import 'package:flutter/cupertino.dart';
import 'package:stackfood_multivendor/features/address/domain/models/address_model.dart';
import 'package:stackfood_multivendor/features/location/controllers/location_controller.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressCardWidget extends StatelessWidget {
  final AddressModel? address;
  final bool fromAddress;
  final bool fromCheckout;
  final Function? onRemovePressed;
  final Function? onEditPressed;
  final Function? onTap;
  final bool isSelected;
  final bool fromDashBoard;
  const AddressCardWidget({super.key, required this.address, required this.fromAddress, this.onRemovePressed, this.onEditPressed,
    this.onTap, this.fromCheckout = false, this.isSelected = false, this.fromDashBoard = false});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.only(bottom: fromCheckout ? 0 : Dimensions.paddingSizeSmall),
      child: InkWell(
        onTap: onTap as void Function()?,
        child: Container(
          padding: EdgeInsets.all(ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeDefault : Dimensions.paddingSizeSmall),
          decoration: fromDashBoard ? BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            border: Border.all(color: isSelected ? Theme.of(context).primaryColor : Colors.transparent, width: isSelected ? 1 : 1),
          ) : fromCheckout ? const BoxDecoration() : BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            border: Border.all(color: isSelected ? Theme.of(context).primaryColor : Colors.grey, width: isSelected ? 1 : 1),
          ),
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Container(margin: EdgeInsets.only(left: Dimensions.paddingSizeLarge),
                    padding: EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeSmall,vertical: Dimensions.paddingSizeExtraSmall),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall),color: Color(0xff3A3346
                    )),
                    child: Row(
                      children: [
                        // Icon(
                        //   address?.addressType == 'home'?  Icons.home_outlined : address
                        //         ?.addressType == 'office'
                        //        ? Icons.shopping_bag_outlined
                        //          : Icons.menu,
                        //
                        //  color: Colors.white,size: 18,),

                        Image.asset(
                          address?.addressType == 'home'
                              ? Images.home2
                              : address
                              ?.addressType == 'office'
                              ? Images.bag2
                              : Images.otherIcon,
                          height: ResponsiveHelper.isDesktop(context) ? 25 : 16, width: ResponsiveHelper.isDesktop(context) ? 25 : 16,
                        ),
                        const SizedBox(width: Dimensions.paddingSizeSmall,),
                        Text(address?.addressType?.tr ?? '', maxLines: 2,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      fromAddress ? IconButton(
                        icon: Icon(CupertinoIcons.delete,
                            color: Theme.of(context).colorScheme.error,
                            size: ResponsiveHelper.isDesktop(context) ? 25 : 20),
                        onPressed: onRemovePressed as void Function()?,
                      ) : const SizedBox(),

                      fromAddress ?  InkWell(
                          onTap:onEditPressed as void Function()?,
                          child: Text("Change",style: TextStyle(color: Color(0xff007AFF),fontWeight: FontWeight.w500,fontSize: Dimensions.fontSizeLarge),)): const SizedBox(),




                    ],
                  )


                ],
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.start, children: [

                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                    Row(mainAxisSize: MainAxisSize.min, children: [
                     const Icon(Icons.location_on_outlined,color: Color(0xff524A61
                      ),),


                      const SizedBox(width: Dimensions.paddingSizeSmall),

                      Flexible(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(address?.address!=null?Get.find<LocationController>().getCityName(address?.address??"",3):address?.addressType?.tr ?? '', style: robotoMedium),
                          // Text(address?.addressType?.tr ?? '', style: robotoMedium),


                        ]),
                      ),


                    ]),
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: Text(
                        address?.address ?? '',
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                        maxLines: 2, overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ]),
                ),



              ]),
            ],
          ),
        ),
      ),
    );
  }
}
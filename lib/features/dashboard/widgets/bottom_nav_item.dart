import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../../common/models/restaurant_model.dart';
import '../../../util/dimensions.dart';
import '../../../util/styles.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../restaurant/controllers/restaurant_controller.dart';

class BottomNavItem extends StatefulWidget {
  final String selectedIcon;
  final String unSelectedIcon;
  final String title;
  final bool cart;
  final Function? onTap;
  final bool isSelected;
  const BottomNavItem({super.key, this.onTap, this.isSelected = false, required this.title, required this.selectedIcon, required this.unSelectedIcon,  this.cart = false});

  @override
  State<BottomNavItem> createState() => _BottomNavItemState();
}



class _BottomNavItemState extends State<BottomNavItem> {
  @override
  void initState() {
    super.initState();

  initCall();}



  Future<void> initCall() async {
    Get.find<RestaurantController>().makeEmptyRestaurant(willUpdate: false);
    await Get.find<CartController>().getCartDataOnline();
    if(Get.find<CartController>().cartList.isNotEmpty){
      await Get.find<RestaurantController>().getRestaurantDetails(Restaurant(id: Get.find<CartController>().cartList[0].product!.restaurantId, name: null), fromCart: true);
      Get.find<CartController>().calculationCart();
      if(Get.find<CartController>().addCutlery){
        Get.find<CartController>().updateCutlery(isUpdate: false);
      }
      Get.find<CartController>().setAvailableIndex(-1, isUpdate: false);
      Get.find<RestaurantController>().getCartRestaurantSuggestedItemList(Get.find<CartController>().cartList[0].product!.restaurantId);
    }
  }

  @override
  Widget build(BuildContext context) {

    return GetBuilder<CartController>(builder: (cartController) {
      return  Expanded(
        child: InkWell(
          onTap: widget.onTap as void Function()?,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

            Stack(
              children: [
                Image.asset(
                  widget.isSelected ? widget.selectedIcon : widget.unSelectedIcon, height: 23, width: 23,
                  color: widget.isSelected ? Theme.of(context).primaryColor : const Color(0xffA7A7A7),
                  fit: BoxFit.fill,
                ),
                widget.cart==false?SizedBox():   Positioned(
                    top: 0,right: 0,
                    child:cartController.cartList.length==0?SizedBox(): CircleAvatar(child: Text(cartController.cartList.length.toString(),style: TextStyle(color: Colors.white,fontSize: 6),),backgroundColor: Colors.red,radius: 6,))
              ],
            ),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall,),

            // SizedBox(height: isSelected ? Dimensions.paddingSizeExtraSmall : Dimensions.paddingSizeSmall),

            Flexible(
              child: Text(maxLines: 1,
                widget.title,
                style: robotoRegular.copyWith(fontWeight: widget.isSelected?FontWeight.bold:null,color: widget.isSelected ? Theme.of(context).primaryColor : const Color(0xffA7A7A7), fontSize: Dimensions.paddingSizeSmall2),
              ),
            ),

          ]),
        ),
      );
    },);
  }
}

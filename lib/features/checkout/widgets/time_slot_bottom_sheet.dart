
import 'dart:convert';
import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:stackfood_multivendor/features/checkout/controllers/checkout_controller.dart';
import 'package:stackfood_multivendor/features/checkout/domain/models/date_month_body_model.dart';
import 'package:stackfood_multivendor/features/checkout/widgets/slot_widget.dart';
import 'package:stackfood_multivendor/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/common/models/restaurant_model.dart';
import 'package:stackfood_multivendor/helper/date_converter.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../cart/controllers/cart_controller.dart';

class TimeSlotBottomSheet extends StatefulWidget {
  final bool tomorrowClosed;
  final bool todayClosed;
  final Restaurant restaurant;
  const TimeSlotBottomSheet({super.key, required this.tomorrowClosed, required this.todayClosed, required this.restaurant});

  @override
  State<TimeSlotBottomSheet> createState() => _TimeSlotBottomSheetState();
}

class _TimeSlotBottomSheetState extends State<TimeSlotBottomSheet> {
  bool _instanceOrder = false;
  @override
  void initState() {
    super.initState();
    _instanceOrder = (Get.find<SplashController>().configModel!.instantOrder! && widget.restaurant.instantOrder!);
    Get.find<CheckoutController>().initCheckoutData(Get.find<CartController>().cartList![0].product!.restaurantId);
    // Get.find<CheckoutController>().setCustomDate(null, false, canUpdate: false);
    // Get.find<CheckoutController>().getAvailableTimes(Get.find<CartController>().cartList[0].product!.id!);
    log("*************${jsonEncode(Get.find<CartController>().cartList)}");
    print("*************${jsonEncode(Get.find<CartController>().cartList)}");
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = ResponsiveHelper.isDesktop(context);
    bool isRestaurantSelfDeliveryOn = widget.restaurant.selfDeliverySystem == 1;

    return Container(
      width: context.width,
      margin: EdgeInsets.only(top: GetPlatform.isWeb ? 0 : 30),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: ResponsiveHelper.isMobile(context) ? const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusExtraLarge))
            : const BorderRadius.all(Radius.circular(Dimensions.radiusExtraLarge)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            !ResponsiveHelper.isDesktop(context) ? Align(
              alignment: Alignment.center,
              child: InkWell(
                onTap: ()=> Get.back(),
                child: Container(
                  height: 4, width: 35,
                  margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                  decoration: BoxDecoration(color: Theme.of(context).disabledColor, borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ) : const SizedBox(),

            Flexible(
              child: SingleChildScrollView(
                padding: isDesktop ? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeLarge),
                child: GetBuilder<CheckoutController>(
                    builder: (checkoutController) {
                      return GetBuilder<RestaurantController>(
                        builder: (restaurantController) {
                          return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [

                            SizedBox(
                              width: isDesktop ? 300 : double.infinity,
                              child: Row(children: [
                                Expanded(
                                  child: tobView(context:context, title: 'today'.tr, isSelected: checkoutController.selectedDateSlot == 0, onTap: (){
                                    checkoutController.updateDateSlot(0, DateTime.now(), _instanceOrder);
                                  }),
                                ),

                                Expanded(
                                  child: tobView(context:context, title: 'tomorrow'.tr, isSelected: checkoutController.selectedDateSlot == 1, onTap: (){
                                    checkoutController.updateDateSlot(1, DateTime.now().add(const Duration(days: 1)), true);
                                  }),
                                ),

                               (isRestaurantSelfDeliveryOn ? widget.restaurant.customerDateOrderStatus! :
                               Get.find<SplashController>().configModel!.customerDateOrderStatus!) ?
                               Expanded(
                                  child: tobView(context:context, title: 'custom_date'.tr, isSelected: checkoutController.selectedDateSlot == 2,
                                      onTap: (){
                                    print("55 ${DateTime.now()} ${_instanceOrder}");
                                    checkoutController.updateDateSlot(2, DateTime.now(), _instanceOrder);
                                    checkoutController.setCustomDate(null, _instanceOrder, canUpdate: false);
                                    checkoutController.setDateCloseRestaurant(restaurantController.isRestaurantClosed(
                                      DateTime.now(), checkoutController.restaurant!.active!,
                                      checkoutController.restaurant!.schedules,
                                    ));
                                    print("55 ${jsonEncode(checkoutController.restaurant!.schedules)}");
                                  }),
                                ) : const SizedBox(),
                              ]),
                            ),
                            SizedBox(height: isDesktop ? Dimensions.paddingSizeSmall : Dimensions.paddingSizeLarge),

                            checkoutController.selectedDateSlot == 2 ?
                            Column(children: [
                              Center(child: Text('set_date_and_time'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge))),
                              const SizedBox(height: Dimensions.paddingSizeLarge),

                              SfDateRangePicker(
                                initialSelectedDate: DateTime.now(),
                                selectionShape: DateRangePickerSelectionShape.rectangle,
                                onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                                  DateTime selectedDate = DateConverter.dateTimeStringToDate(args.value.toString());
                                  checkoutController.setDateCloseRestaurant(restaurantController.isRestaurantClosed(
                                    selectedDate, checkoutController.restaurant!.active!,
                                    checkoutController.restaurant!.schedules,
                                  ));
                                  checkoutController.updateDateSlot(2, selectedDate, _instanceOrder, fromCustomDate: true);
                                  checkoutController.setCustomDate(selectedDate, _instanceOrder && DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).isAtSameMomentAs(checkoutController.selectedCustomDate ?? DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)));

                                  print("lllll333 ${selectedDate}");
                                  String dayName = DateFormat('EEEE').format(selectedDate);
                                  String date = DateFormat('dd/MM/yyyy').format(selectedDate);
                                  Get.find<CartController>().day="${ dayName}";
                                  Get.find<CartController>().date="${ date}";
                                  Get.find<CartController>().time="";
                                    Get.find<CartController>().getCartDataOnline();

                                },
                                showNavigationArrow: true,
                                selectableDayPredicate: (DateTime val) {
                                  print("lllll ${val}");
                                 return _canSelectDate(duration: isRestaurantSelfDeliveryOn ? widget.restaurant.customerOrderDate! : Get.find<SplashController>().configModel!.customerOrderDate!, value: val);
                                }
                              ),

                              Builder(
                                builder: (context) {
                                  return SizedBox(
                                    height: 50,
                                    child: (checkoutController.selectedDateSlot == 2 && checkoutController.customDateRestaurantClose)
                                    ? Center(child: Text('restaurant_is_closed'.tr )) : ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: checkoutController.timeSlots!.length,
                                        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                                        itemBuilder: (context, index) {
                                      String time = (index == 0 && checkoutController.selectedDateSlot == 2
                                          && restaurantController.isRestaurantOpenNow(checkoutController.restaurant!.active!, checkoutController.restaurant!.schedules)
                                          && DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).isAtSameMomentAs(checkoutController.selectedCustomDate ?? DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day))
                                          ? _instanceOrder
                                          ? 'now'.tr : 'not_available'.tr : '${DateConverter.dateToTimeOnly(checkoutController.timeSlots![index].startTime!)} '
                                          '- ${DateConverter.dateToTimeOnly(checkoutController.timeSlots![index].endTime!)}');
                                      return SlotWidget(
                                        title: time, fromCustomDate: true,
                                        isSelected: checkoutController.selectedTimeSlot == index,
                                        onTap: () {
                                          checkoutController.updateTimeSlot(index, time != 'Not Available');
                                          checkoutController.setPreferenceTimeForView(time, time != 'Not Available');
                                          checkoutController.showHideTimeSlot();
                                          print("lll $time");
                                          Get.find<CartController>().time= '${DateConverter.dateToTimeOnly(checkoutController.timeSlots![index].startTime!)} '
                                              '- ${DateConverter.dateToTimeOnly(checkoutController.timeSlots![index].endTime!)}';

                                          // Get.find<CartController>().day
                                        },
                                      );
                                    }),
                                  );
                                }
                              ),

                              const Padding(
                                padding: EdgeInsets.only(top: Dimensions.paddingSizeLarge),
                                child: Divider(),
                              ),

                            ]) :
                            ((checkoutController.selectedDateSlot == 0 && widget.todayClosed) || (checkoutController.selectedDateSlot == 1 && widget.tomorrowClosed))
                              ? Center(child: Text('restaurant_is_closed'.tr ))
                                :
                            //     (checkoutController.availableTimes != null)
                            //    ?

                            checkoutController.timeSlots!.isNotEmpty ?

                                /// today & tomorrow slot
                            GridView.builder(
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: isDesktop ? 5 : 3,
                                  mainAxisSpacing: Dimensions.paddingSizeSmall,
                                  crossAxisSpacing: Dimensions.paddingSizeExtraSmall,
                                  childAspectRatio: isDesktop ? 3.5 : 3
                                ),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: checkoutController.timeSlots!.length,
                                itemBuilder: (context, index){
                                  String time = (index == 0 && checkoutController.selectedDateSlot == 0
                                      && restaurantController.isRestaurantOpenNow(checkoutController.restaurant!.active!, checkoutController.restaurant!.schedules)
                                      ? _instanceOrder
                                      ? 'now'.tr : 'not_available'.tr :
                                  '${DateConverter.dateToTimeOnly(checkoutController.timeSlots![index].startTime!)} '
                                      '- ${DateConverter.dateToTimeOnly(checkoutController.timeSlots![index].endTime!)}');

                                  return SlotWidget(
                                    title: time,
                                    isSelected: checkoutController.selectedTimeSlot == index,
                                    onTap: () async{
                                      checkoutController.updateTimeSlot(index, time != 'Not Available');
                                      checkoutController.setPreferenceTimeForView(time, time != 'Not Available');
                                      checkoutController.showHideTimeSlot();
                                       print("jlkjlj  $time $index");
                                      Get.find<CartController>().time= '${DateConverter.dateToTimeOnly(checkoutController.timeSlots![index].startTime!)} '
                                          '- ${DateConverter.dateToTimeOnly(checkoutController.timeSlots![index].endTime!)}';

                                 var dattee=   checkoutController.selectedDateSlot == 0?
                                 DateTime.now():

                                      DateTime.now() .add(Duration(days: 1));

                                      String dayName = DateFormat('EEEE').format(dattee);
                                      String date = DateFormat('dd/MM/yyyy').format(dattee);
                                      print("dfdf $date");
                                      Get.find<CartController>().day="${ dayName}";
                                      Get.find<CartController>().date="${ date}";
                                      print("jlkjlj  ${ Get.find<CartController>().day} ${ Get.find<CartController>().time}");
                                     await  Get.find<CartController>().getCartDataOnline();
                                      },
                                  );
                            })
                                : Center(child: Text('no_slot_available'.tr))
                            //     :
                            // const Center(child: CircularProgressIndicator())
                            ,

                          ]);
                        }
                      );
                    }
                ),
              ),
            ),

           !isDesktop ? GetBuilder<CheckoutController>(builder: (checkoutController) {
               return GetBuilder<RestaurantController>(builder: (restaurantController) {
                   return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge, vertical: Dimensions.paddingSizeSmall),
                      child: Row(children: [
                        Expanded(
                          child: CustomButtonWidget(
                            buttonText: 'cancel'.tr,
                            color: Theme.of(context).disabledColor,
                            onPressed: () => Get.back(),
                          ),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeSmall),
                        Expanded(
                          child: CustomButtonWidget(
                            buttonText: 'schedule'.tr,
                            onPressed: () {
                              print("lll selectedTimeSlot ${checkoutController.selectedTimeSlot} ${checkoutController.selectedDateSlot}");
                       //        if((checkoutController.selectedTimeSlot == 0 || checkoutController.selectedTimeSlot == 1) && (checkoutController.selectedDateSlot == 0 || checkoutController.selectedDateSlot == 1))
                       //        {
                       // print("lll 5655");
                       //
                       //
                       //        }

                              if(checkoutController.timeSlots != null ) {
                                print("lll s");
                                String time = (checkoutController.selectedTimeSlot == 0 && checkoutController.selectedDateSlot == 0
                                    && restaurantController.isRestaurantOpenNow(restaurantController.restaurant!.active!, restaurantController.restaurant!.schedules)
                                    ? _instanceOrder
                                    ? 'now'.tr : 'not_available'.tr : '${DateConverter.dateToTimeOnly(checkoutController.timeSlots![checkoutController.selectedTimeSlot!].startTime!)} '
                                    '- ${DateConverter.dateToTimeOnly(checkoutController.timeSlots![checkoutController.selectedTimeSlot!].endTime!)}');
                                print("lll s $time");
                                checkoutController.setPreferenceTimeForView(time, time != 'Not Available');

                                print("lll see ${checkoutController.preferableTime}");
                                Get.back();
                              }
                              else
                                //if((checkoutController.selectedTimeSlot == 0 || checkoutController.selectedTimeSlot == 1) && checkoutController.selectedDateSlot == 2)
                              {
                                print("lll see95 ${checkoutController.preferableTime}");
                                String time = (checkoutController.selectedTimeSlot == 0 && checkoutController.selectedDateSlot == 2
                                    && restaurantController.isRestaurantOpenNow(restaurantController.restaurant!.active!, restaurantController.restaurant!.schedules)
                                    && DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).isAtSameMomentAs(checkoutController.selectedCustomDate ?? DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day))
                                    ? _instanceOrder
                                    ? 'now'.tr : 'not_available'.tr : '${DateConverter.dateToTimeOnly(checkoutController.timeSlots![checkoutController.selectedTimeSlot!].startTime!)} '
                                    '- ${DateConverter.dateToTimeOnly(checkoutController.timeSlots![checkoutController.selectedTimeSlot!].endTime!)}');

                                checkoutController.setPreferenceTimeForView(time, time != 'Not Available');
                                print("lll see9 ${checkoutController.preferableTime}");
                                Get.back();
                              }
                              print("lll 55");
                       //        Get.back();
                            },
                          ),
                        ),
                      ]),
                    );
                 });
             }) : const SizedBox(),
          ]),
      ),
    );
  }

  Widget tobView({required BuildContext context, required String title, required bool isSelected, required Function() onTap}){
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Text(title, style: isSelected ? robotoBold.copyWith(color: Theme.of(context).primaryColor) : robotoMedium),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Divider(color: isSelected ? Theme.of(context).primaryColor : ResponsiveHelper.isDesktop(context) ? Colors.transparent : Theme.of(context).disabledColor, thickness: isSelected ? 2 : 0.7),
        ],
      ),
    );
  }

  bool _canSelectDate({required int duration, required DateTime value}) {
    List<DateMonthBodyModel> date = [];
    for(int i=0; i<duration; i++){
      date.add(DateMonthBodyModel(date: DateTime.now().add(Duration(days: i)).day, month: DateTime.now().add(Duration(days: i)).month));
    }
    bool status = false;
    for(int i=0; i<date.length; i++){
      if(date[i].month == value.month && date[i].date == value.day){
        status = true;
        break;
      } else {
        status = false;
      }
    }
    return status;
  }
}





///Sagar///

// import 'dart:convert';
//
// import 'package:intl/intl.dart';
// import 'package:stackfood_multivendor/features/checkout/controllers/checkout_controller.dart';
// import 'package:stackfood_multivendor/features/checkout/domain/models/date_month_body_model.dart';
// import 'package:stackfood_multivendor/features/checkout/widgets/slot_widget.dart';
// import 'package:stackfood_multivendor/features/restaurant/controllers/restaurant_controller.dart';
// import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
// import 'package:stackfood_multivendor/common/models/restaurant_model.dart';
// import 'package:stackfood_multivendor/helper/date_converter.dart';
// import 'package:stackfood_multivendor/helper/responsive_helper.dart';
// import 'package:stackfood_multivendor/util/dimensions.dart';
// import 'package:stackfood_multivendor/util/styles.dart';
// import 'package:stackfood_multivendor/common/widgets/custom_button_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:syncfusion_flutter_datepicker/datepicker.dart';
//
// import '../../cart/controllers/cart_controller.dart';
//
// class TimeSlotBottomSheet extends StatefulWidget {
//   final bool tomorrowClosed;
//   final bool todayClosed;
//   final Restaurant restaurant;
//   const TimeSlotBottomSheet({super.key, required this.tomorrowClosed, required this.todayClosed, required this.restaurant});
//
//   @override
//   State<TimeSlotBottomSheet> createState() => _TimeSlotBottomSheetState();
// }
//
// class _TimeSlotBottomSheetState extends State<TimeSlotBottomSheet> {
//   bool _instanceOrder = false;
//   @override
//   void initState() {
//     super.initState();
//     _instanceOrder = (Get.find<SplashController>().configModel!.instantOrder! && widget.restaurant.instantOrder!);
//     // Get.find<CheckoutController>().setCustomDate(null, false, canUpdate: false);
//     Get.find<CheckoutController>().getAvailableTimes(Get.find<CartController>().cartList[0].product!.id!).then((value){
//         Future.delayed(const Duration(milliseconds: 400)).then((value) => setState(() {Get.find<CheckoutController>().assignData(null);}));
//     });
//     print("*************${jsonEncode(Get.find<CartController>().cartList)}");
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     bool isDesktop = ResponsiveHelper.isDesktop(context);
//     bool isRestaurantSelfDeliveryOn = widget.restaurant.selfDeliverySystem == 1;
//
//     return Container(
//       width: context.width,
//       margin: EdgeInsets.only(top: GetPlatform.isWeb ? 0 : 30),
//       decoration: BoxDecoration(
//         color: Theme.of(context).cardColor,
//         borderRadius: ResponsiveHelper.isMobile(context) ? const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusExtraLarge))
//             : const BorderRadius.all(Radius.circular(Dimensions.radiusExtraLarge)),
//       ),
//       child: SafeArea(
//         child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//
//               !ResponsiveHelper.isDesktop(context) ? Align(
//                 alignment: Alignment.center,
//                 child: InkWell(
//                   onTap: ()=> Get.back(),
//                   child: Container(
//                     height: 4, width: 35,
//                     margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
//                     decoration: BoxDecoration(color: Theme.of(context).disabledColor, borderRadius: BorderRadius.circular(10)),
//                   ),
//                 ),
//               ) : const SizedBox(),
//
//               Flexible(
//                 child: SingleChildScrollView(
//                   padding: isDesktop ? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeLarge),
//                   child: GetBuilder<CheckoutController>(
//                       builder: (checkoutController) {
//                         return GetBuilder<RestaurantController>(
//                             builder: (restaurantController) {
//                               return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
//
//                                 SizedBox(
//                                   width: isDesktop ? 300 : double.infinity,
//                                   child: Row(children: [
//                                     Expanded(
//                                       child: tobView(context:context, title: 'today'.tr, isSelected: checkoutController.selectedDateSlot == 0, onTap: (){
//                                         checkoutController.updateDateSlot(0, DateTime.now(), _instanceOrder);
//                                         checkoutController.assignData(null);
//                                       }),
//                                     ),
//
//                                     Expanded(
//                                       child: tobView(context:context, title: 'tomorrow'.tr, isSelected: checkoutController.selectedDateSlot == 1, onTap: (){
//                                         checkoutController.updateDateSlot(1, DateTime.now().add(const Duration(days: 1)), true);
//                                         checkoutController.assignData(null);
//                                       }),
//                                     ),
//
//                                     (isRestaurantSelfDeliveryOn ? widget.restaurant.customerDateOrderStatus! : Get.find<SplashController>().configModel!.customerDateOrderStatus!) ? Expanded(
//                                       child: tobView(context:context, title: 'custom_date'.tr, isSelected: checkoutController.selectedDateSlot == 2, onTap: (){
//                                         checkoutController.updateDateSlot(2, DateTime.now(), _instanceOrder);
//                                         //checkoutController.assignData(DateTime.now().toString());
//                                         checkoutController.setCustomDate(null, _instanceOrder, canUpdate: false);
//                                         checkoutController.setDateCloseRestaurant(restaurantController.isRestaurantClosed(
//                                           DateTime.now(), checkoutController.restaurant!.active!,
//                                           checkoutController.restaurant!.schedules,
//                                         ));
//                                       }),
//                                     ) : const SizedBox(),
//                                   ]),
//                                 ),
//                                 SizedBox(height: isDesktop ? Dimensions.paddingSizeSmall : Dimensions.paddingSizeLarge),
//
//                                 checkoutController.selectedDateSlot == 2 ? Column(children: [
//                                   Center(child: Text('set_date_and_time'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge))),
//                                   const SizedBox(height: Dimensions.paddingSizeLarge),
//
//                                   SfDateRangePicker(
//                                       initialSelectedDate: DateTime.now(),
//                                       selectionShape: DateRangePickerSelectionShape.rectangle,
//                                       onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
//
//                                         DateTime selectedDate = DateConverter.dateTimeStringToDate(args.value.toString());
//
//                                         print(selectedDate);
//                                         checkoutController.assignData(selectedDate.toLocal().toString());
//                                         checkoutController.setDateCloseRestaurant(restaurantController.isRestaurantClosed(
//                                           selectedDate, checkoutController.restaurant!.active!,
//                                           checkoutController.restaurant!.schedules,
//                                         ));
//                                         checkoutController.updateDateSlot(2, selectedDate, _instanceOrder, fromCustomDate: true);
//                                         checkoutController.setCustomDate(selectedDate, _instanceOrder && DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).isAtSameMomentAs(checkoutController.selectedCustomDate ?? DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)));
//
//                                       },
//                                       showNavigationArrow: true,
//                                       selectableDayPredicate: (DateTime val) {
//                                         return _canSelectDate(duration: isRestaurantSelfDeliveryOn ? widget.restaurant.customerOrderDate! : Get.find<SplashController>().configModel!.customerOrderDate!, value: val);
//                                       }
//                                   ),
//
//                                   Builder(
//                                       builder: (context) {
//                                         return SizedBox(
//                                           height: 50,
//                                           child: (checkoutController.selectedDateSlot == 2 && checkoutController.customDateRestaurantClose)
//                                               ? Center(child: Text('restaurant_is_closed'.tr )) : ListView.builder(
//                                               scrollDirection: Axis.horizontal,
//                                               itemCount: checkoutController.list!.length,
//                                               padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
//                                               itemBuilder: (context, index) {
//                                                 // String time = (index == 0 && checkoutController.selectedDateSlot == 2
//                                                 //     && restaurantController.isRestaurantOpenNow(checkoutController.restaurant!.active!, checkoutController.restaurant!.schedules)
//                                                 //     && DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).isAtSameMomentAs(checkoutController.selectedCustomDate ?? DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day))
//                                                 //     ? _instanceOrder
//                                                 //     ? 'now'.tr : 'not_available'.tr :
//                                                 String time = '${DateConverter.dateToTimeOnly(parseTimeToDates(checkoutController.list![index].start!))} '
//                                                     '- ${DateConverter.dateToTimeOnly(parseTimeToDates(checkoutController.list![index].end!))}';
//                                                 return SlotWidget(
//                                                   title: time, fromCustomDate: true,
//                                                   isSelected: checkoutController.selectedTimeSlot == index,
//                                                   onTap: () {
//                                                     checkoutController.updateTimeSlot(index, time != 'Not Available');
//                                                     checkoutController.setPreferenceTimeForView(time, time != 'Not Available');
//                                                     checkoutController.showHideTimeSlot();
//                                                   },
//                                                 );
//                                               }),
//                                         );
//                                       }
//                                   ),
//
//                                   const Padding(
//                                     padding: EdgeInsets.only(top: Dimensions.paddingSizeLarge),
//                                     child: Divider(),
//                                   ),
//
//                                 ]) : ((checkoutController.selectedDateSlot == 0 && widget.todayClosed) || (checkoutController.selectedDateSlot == 1 && widget.tomorrowClosed))
//                                     ? Center(child: Text('restaurant_is_closed'.tr ))
//                                     // : (checkoutController.availableTimes != null)
//                                     // ? checkoutController.timeSlots!.isNotEmpty ?
//                                     : (checkoutController.isAvailableTimeNull == false)
//                                     ? checkoutController.list!.isNotEmpty ?
//                                 GridView.builder(
//                                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                                         crossAxisCount: isDesktop ? 5 : 3,
//                                         mainAxisSpacing: Dimensions.paddingSizeSmall,
//                                         crossAxisSpacing: Dimensions.paddingSizeExtraSmall,
//                                         childAspectRatio: isDesktop ? 3.5 : 3
//                                     ),
//                                     shrinkWrap: true,
//                                     physics: const NeverScrollableScrollPhysics(),
//                                     itemCount: checkoutController.list!.length,
//                                     itemBuilder: (context, index){
//                                        // String time =(index == 0 && checkoutController.selectedDateSlot == 0
//                                        //    && restaurantController.isRestaurantOpenNow(checkoutController.restaurant!.active!, checkoutController.restaurant!.schedules)
//                                        //    ? _instanceOrder
//                                        //    ? 'now'.tr : 'not_available'.tr :
//                                       String time =  '${DateConverter.dateToTimeOnly(parseTimeToDates(checkoutController.list![index].start!.toString()))} '
//                                           '- ${DateConverter.dateToTimeOnly(parseTimeToDates(checkoutController.list![index].end!.toString()))}';
//
//                                       print("instant timee ${_instanceOrder}");
//                                       return SlotWidget(
//                                         title: time,
//                                         //title: parseAndFormatTimeForView(checkoutController.list![index].start!,checkoutController.list![index].start!),
//                                         isSelected: checkoutController.selectedTimeSlot == index,
//                                         onTap: () {
//                                           checkoutController.updateTimeSlot(index, time != 'Not Available');
//                                           checkoutController.setPreferenceTimeForView(time, time != 'Not Available');
//                                           checkoutController.showHideTimeSlot();
//                                         },
//                                       );
//                                     })
//                                     : Center(child: Text('no_slot_available'.tr)): const Center(child: CircularProgressIndicator()),
//
//                               ]);
//                             }
//                         );
//                       }
//                   ),
//                 ),
//               ),
//
//               !isDesktop ? GetBuilder<CheckoutController>(builder: (checkoutController) {
//                 return GetBuilder<RestaurantController>(builder: (restaurantController) {
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge, vertical: Dimensions.paddingSizeSmall),
//                     child: Row(children: [
//                       Expanded(
//                         child: CustomButtonWidget(
//                           buttonText: 'cancel'.tr,
//                           color: Theme.of(context).disabledColor,
//                           onPressed: () => Get.back(),
//                         ),
//                       ),
//                       const SizedBox(width: Dimensions.paddingSizeSmall),
//                       Expanded(
//                         child: CustomButtonWidget(
//                           buttonText: 'schedule'.tr,
//                           onPressed: () {
//                             // if((checkoutController.selectedTimeSlot == 0 || checkoutController.selectedTimeSlot == 1) && (checkoutController.selectedDateSlot == 0 || checkoutController.selectedDateSlot == 1)){
//                             //   if(checkoutController.timeSlots != null ) {
//                             //     String time = (checkoutController.selectedTimeSlot == 0 && checkoutController.selectedDateSlot == 0
//                             //         && restaurantController.isRestaurantOpenNow(restaurantController.restaurant!.active!, restaurantController.restaurant!.schedules)
//                             //         ? _instanceOrder
//                             //         ? 'now'.tr : 'not_available'.tr : '${DateConverter.dateToTimeOnly(checkoutController.timeSlots![checkoutController.selectedTimeSlot!].startTime!)} '
//                             //         '- ${DateConverter.dateToTimeOnly(checkoutController.timeSlots![checkoutController.selectedTimeSlot!].endTime!)}');
//                             //
//                             //     checkoutController.setPreferenceTimeForView(time, time != 'Not Available');
//                             //
//                             //   }
//                             // }
//                             // else if((checkoutController.selectedTimeSlot == 0 || checkoutController.selectedTimeSlot == 1) && checkoutController.selectedDateSlot == 2) {
//                             //   String time = (checkoutController.selectedTimeSlot == 0 && checkoutController.selectedDateSlot == 2
//                             //       && restaurantController.isRestaurantOpenNow(restaurantController.restaurant!.active!, restaurantController.restaurant!.schedules)
//                             //       && DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).isAtSameMomentAs(checkoutController.selectedCustomDate ?? DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day))
//                             //       ? _instanceOrder
//                             //       ? 'now'.tr : 'not_available'.tr : '${DateConverter.dateToTimeOnly(checkoutController.timeSlots![checkoutController.selectedTimeSlot!].startTime!)} '
//                             //       '- ${DateConverter.dateToTimeOnly(checkoutController.timeSlots![checkoutController.selectedTimeSlot!].endTime!)}');
//                             //
//                             //   checkoutController.setPreferenceTimeForView(time, time != 'Not Available');
//                             // }
//                             Get.back();
//                           },
//                         ),
//                       ),
//                     ]),
//                   );
//                 });
//               }) : const SizedBox(),
//             ]),
//       ),
//     );
//   }
//
//   Widget tobView({required BuildContext context, required String title, required bool isSelected, required Function() onTap}){
//     return InkWell(
//       onTap: onTap,
//       child: Column(
//         children: [
//           Text(title, style: isSelected ? robotoBold.copyWith(color: Theme.of(context).primaryColor) : robotoMedium),
//           const SizedBox(height: Dimensions.paddingSizeSmall),
//
//           Divider(color: isSelected ? Theme.of(context).primaryColor : ResponsiveHelper.isDesktop(context) ? Colors.transparent : Theme.of(context).disabledColor, thickness: isSelected ? 2 : 0.7),
//         ],
//       ),
//     );
//   }
//
//   bool _canSelectDate({required int duration, required DateTime value}) {
//     List<DateMonthBodyModel> date = [];
//     for(int i=0; i<duration; i++){
//       date.add(DateMonthBodyModel(date: DateTime.now().add(Duration(days: i)).day, month: DateTime.now().add(Duration(days: i)).month));
//     }
//     bool status = false;
//     for(int i=0; i<date.length; i++){
//       if(date[i].month == value.month && date[i].date == value.day){
//         status = true;
//         break;
//       } else {
//         status = false;
//       }
//     }
//     return status;
//   }
//   DateTime parseTimeToDates(String time) {
//     DateTime now = DateTime.now();
//     String dateStr = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
//     DateTime startDate = DateTime.parse("$dateStr ${formatTime(time)}");
//     return startDate;
//   }
//
//   String formatTime(String time) {
//     List<String> parts = time.split(":");
//     int hour = int.parse(parts[0]);
//     int minute = int.parse(parts[1]);
//     int second = int.parse(parts[2]);
//
//     if (hour < 10) {
//       return "0$hour:${minute.toString().padLeft(2, '0')}:${second.toString().padLeft(2, '0')}";
//     }
//     return "${hour % 24}:${minute.toString().padLeft(2, '0')}:${second.toString().padLeft(2, '0')}";
//   }
//   String  parseAndFormatTimeForView(String startTime, String endTime) {
//     String formattedStartTime = DateFormat('hh:mm a').format(parseTimeToDates(startTime));
//     String formattedEndTime = DateFormat('hh:mm a').format(parseTimeToDates(endTime));
//     return "$formattedStartTime - $formattedEndTime";
//   }
// }







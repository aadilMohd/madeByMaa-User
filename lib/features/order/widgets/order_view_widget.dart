import 'package:stackfood_multivendor/features/order/controllers/order_controller.dart';
import 'package:stackfood_multivendor/features/order/screens/order_details_screen.dart';
import 'package:stackfood_multivendor/features/order/widgets/order_shimmer_widget.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/order/domain/models/order_model.dart';
import 'package:stackfood_multivendor/helper/date_converter.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor/common/widgets/footer_view_widget.dart';
import 'package:stackfood_multivendor/common/widgets/no_data_screen_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderViewWidget extends StatelessWidget {
  final bool isRunning;
  final bool isSubscription;
  const OrderViewWidget({super.key, required this.isRunning, this.isSubscription = false});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: GetBuilder<OrderController>(builder: (orderController) {
        List<OrderModel>? orderList;
        bool paginate = false;
        int pageSize = 1;
        int offset = 1;
        if(orderController.runningOrderList != null && orderController.historyOrderList != null) {
          orderList = isSubscription ? orderController.runningSubscriptionOrderList : isRunning ? orderController.runningOrderList : orderController.historyOrderList;
          paginate = isSubscription ? orderController.runningSubscriptionPaginate : isRunning ? orderController.runningPaginate : orderController.historyPaginate;
          pageSize = isSubscription ? (orderController.runningSubscriptionPageSize!/100).ceil() : isRunning ? (orderController.runningPageSize!/100).ceil() : (orderController.historyPageSize!/100).ceil();
          offset = isSubscription ? orderController.runningSubscriptionOffset : isRunning ? orderController.runningOffset : orderController.historyOffset;
        }
        scrollController.addListener(() {
          if (scrollController.position.pixels == scrollController.position.maxScrollExtent && orderList != null && !paginate) {
            if (offset < pageSize) {
              Get.find<OrderController>().setOffset(offset + 1, isRunning, isSubscription);
              debugPrint('end of the page');
              Get.find<OrderController>().showBottomLoader(isRunning, isSubscription);
              if(isRunning) {
                Get.find<OrderController>().getRunningOrders(offset+1);
              } else if(isSubscription){
                Get.find<OrderController>().getRunningSubscriptionOrders(offset+1);
              }
              else {
                Get.find<OrderController>().getHistoryOrders(offset+1);
              }
            }
          }
        });

        return orderList != null ? orderList.isNotEmpty ? RefreshIndicator(
          onRefresh: () async {
            if(isRunning) {
              await orderController.getRunningOrders(1);
            }else {
              await orderController.getHistoryOrders(1);
            }
          },
          child: SingleChildScrollView(
            controller: scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Center(child: FooterViewWidget(
              child: SizedBox(
                width: Dimensions.webMaxWidth,
                child: Column(
                  children: [
                    GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeLarge : Dimensions.paddingSizeLarge,
                        mainAxisSpacing: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeSmall : 0,
                        crossAxisCount: ResponsiveHelper.isMobile(context) ? 1 : 2,
                        mainAxisExtent: ResponsiveHelper.isDesktop(context) ? 130 : 110,
                      ),
                      padding: ResponsiveHelper.isDesktop(context) ? const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge) : const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      itemCount: orderList.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {

                        return Padding(
                          padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                          child: InkWell(
                            onTap: () {
                              Get.toNamed(
                                RouteHelper.getOrderDetailsRoute(orderList![index].id),
                                arguments: OrderDetailsScreen(orderId: orderList[index].id, orderModel: orderList[index],addloguuid:orderList[index].addloggsdetails !=null? orderList[index].addloggsdetails!.addloggorderid:null,),
                              );
                            },
                            hoverColor: Colors.transparent,
                            child: Container(
                               padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 1, blurRadius: 2, offset: const Offset(0, 0))],
                              ),
                              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,

                                    children: [

                                  Container(
                                    // padding: const EdgeInsets.all(1),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                      child: CustomImageWidget(
                                        image: '${Get.find<SplashController>().configModel!.baseUrls!.restaurantImageUrl}'
                                            '/${orderList![index].restaurant != null ? orderList[index].restaurant!.logo : ''}',
                                        height: 90, width: 90, fit: BoxFit.cover, isRestaurant: true,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: Dimensions.paddingSizeSmall),

                                  Expanded(
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [

                                      Text('${'order'.tr} # ${orderList[index].id}', style: robotoBold),
                                      Text('${orderList[index].restaurant!.name}',style: TextStyle(color: Get.theme.hintColor,fontSize: Dimensions.fontSizeSmall),),
                                      const SizedBox(height: Dimensions.paddingSizeDefault),


                                      Text(
                                        DateConverter.dateTimeStringToDateTimeToLines(orderList[index].createdAt!),
                                        style: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall),
                                      ),

                                    ]),
                                  ),
                                  const SizedBox(width: Dimensions.paddingSizeSmall),

                                Row(crossAxisAlignment: CrossAxisAlignment.end, mainAxisAlignment: MainAxisAlignment.center, children: [

                                    isRunning || isSubscription ? Column(crossAxisAlignment: CrossAxisAlignment.end, children: [

                                      (orderList[index].restaurant!.veg==1 && orderList[index].restaurant!.nonVeg==1)?Row(
                                        children: [
                                          Image.asset(Images.vegImage,height: 12,),
                                          SizedBox(width: Dimensions.paddingSizeSmall,),
                                          Image.asset(Images.nonVegImage,height: 12,)
                                        ],
                                      )       :orderList[index].restaurant!.veg==1 ?  Image.asset(Images.vegImage,height: 12,):Image.asset(Images.nonVegImage,height: 12,),
                                      const SizedBox(height: Dimensions.paddingSizeSmall),


                                      // Container(
                                      //   padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                                      //   margin: EdgeInsets.only(bottom: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeOverLarge : Dimensions.paddingSizeDefault),
                                      //   decoration: BoxDecoration(
                                      //     borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                      //     color: orderList[index].orderStatus == 'pending' || orderList[index].orderStatus == 'processing' ? Colors.blue.withOpacity(0.15) : orderList[index].orderStatus == 'accepted'
                                      //         || orderList[index].orderStatus == 'confirmed' ? Colors.green.withOpacity(0.15) : Theme.of(context).primaryColor.withOpacity(0.15),
                                      //   ),
                                      //   child: Text(orderList[index].orderStatus!.tr, style: robotoMedium.copyWith(
                                      //     fontSize: Dimensions.fontSizeExtraSmall, color: orderList[index].orderStatus == 'pending' || orderList[index].orderStatus == 'processing' ? Colors.blue : orderList[index].orderStatus == 'accepted'
                                      //       || orderList[index].orderStatus == 'confirmed' ? Colors.green : Theme.of(context).primaryColor,
                                      //   )),
                                      // ),

                                      InkWell(
                                        onTap: (){

                                          Get.toNamed(
                                            RouteHelper.getOrderDetailsRoute(orderList![index].id),
                                            arguments: OrderDetailsScreen(orderId: orderList[index].id, orderModel: orderList[index]),
                                          );
                                        },
                                        // onTap: () => Get.toNamed(RouteHelper.getOrderTrackingRoute(orderList![index].id, null)),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: 7),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                            color: Theme.of(context).primaryColor,
                                            border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                                          ),
                                          child: Text('track_order'.tr, style: robotoMedium.copyWith(
                                            fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).cardColor,
                                          )),
                                        ),
                                      ),
                                    ]) : Column(crossAxisAlignment: CrossAxisAlignment.end, children: [

                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                                        margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeOverLarge),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                          color: orderList[index].orderStatus == 'delivered' ? Colors.green.withOpacity(0.15) : Colors.red.withOpacity(0.15),
                                        ),
                                        child: Text(orderList[index].orderStatus!.tr, style: robotoMedium.copyWith(
                                          fontSize: Dimensions.fontSizeExtraSmall, color: orderList[index].orderStatus == 'delivered' ? Colors.green : Colors.red,
                                        )),
                                      ),

                                      Text(
                                        '${orderList[index].detailsCount} ${orderList[index].detailsCount! > 1 ? 'items'.tr : 'item'.tr}',
                                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                                      ),

                                    ]),
                                  ]),

                                ]),

                              ]),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 80,),
                    paginate ? const Center(child: Padding(
                      padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                      child: CircularProgressIndicator(),
                    )) : const SizedBox(),
                  ],
                ),
              ),
            )),
          ),
        ) : SingleChildScrollView(child: FooterViewWidget(child: NoDataScreen(title: 'no_order_yet'.tr, isEmptyOrder: true))) : OrderShimmerWidget(orderController: orderController);
      }),
    );
  }
}

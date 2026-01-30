import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:stackfood_multivendor/common/widgets/customizable_space_bar_widget.dart';
import 'package:stackfood_multivendor/features/product/controllers/campaign_controller.dart';
import 'package:stackfood_multivendor/features/product/domain/models/basic_campaign_model.dart';
import 'package:stackfood_multivendor/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor/features/restaurant/screens/web_campaign_screen.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/helper/date_converter.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor/common/widgets/footer_view_widget.dart';
import 'package:stackfood_multivendor/common/widgets/menu_drawer_widget.dart';
import 'package:stackfood_multivendor/common/widgets/product_view_widget.dart';
import 'package:stackfood_multivendor/common/widgets/web_menu_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CampaignScreen extends StatefulWidget {
  final BasicCampaignModel campaign;

  const CampaignScreen({super.key, required this.campaign});

  @override
  State<CampaignScreen> createState() => _CampaignScreenState();
}

class _CampaignScreenState extends State<CampaignScreen> {
  final ScrollController _scrollController = ScrollController();
  String selectedButton = 'all';

  @override
  void initState() {
    super.initState();

    Get.find<CampaignController>().getBasicCampaignDetails(widget.campaign.id);
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = ResponsiveHelper.isDesktop(context);

    return Scaffold(
        appBar: isDesktop ? const WebMenuBar() : null,
        endDrawer: const MenuDrawerWidget(),
        endDrawerEnableOpenDragGesture: false,
        backgroundColor: Theme.of(context).cardColor,
        body: GetBuilder<RestaurantController>(
          builder: (restController) {
            return GetBuilder<CampaignController>(
                builder: (campaignController) {
              if (campaignController.isNull) {
                SizedBox();
              }

              return isDesktop
                  ? WebCampaignScreen(campaignController: campaignController)
                  :

                  /// Old code
                  CustomScrollView(
                      controller: _scrollController,
                      slivers: [
                        SliverAppBar(
                          expandedHeight: 320,
                          toolbarHeight: 90,
                          pinned: true,
                          floating: false,
                          backgroundColor: Theme.of(context).cardColor,
                          leading: InkWell(
                            onTap: () => Get.back(),
                            child: const Icon(Icons.arrow_back_outlined,
                                color: Colors.black, size: 30),
                          ),
                          flexibleSpace: FlexibleSpaceBar(
                            centerTitle: true,
                            titlePadding: EdgeInsets.zero,
                            expandedTitleScale: 1.1,
                            // title: CustomizableSpaceBarWidget(
                            //   builder: (context, scrollingRate) {
                            //     return campaignController.campaign != null ? Container(
                            //       width: double.infinity,
                            //       margin: EdgeInsets.only(left: 15 - (15 * scrollingRate), right: 15 - (15 * scrollingRate), bottom: 15 - (15 * scrollingRate)),
                            //       decoration: BoxDecoration(
                            //         color: Theme.of(context).cardColor,
                            //         borderRadius: BorderRadius.circular(scrollingRate < 0.8 ? Dimensions.radiusLarge : 0),
                            //         boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 1))],
                            //       ),
                            //       child: Column(mainAxisSize: MainAxisSize.min, children: [
                            //
                            //         Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                            //
                            //           Expanded(
                            //             child: Padding(
                            //               padding: EdgeInsets.only(
                            //                 top: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeDefault,
                            //                 left: scrollingRate < 0.8 ? Dimensions.paddingSizeDefault : 70, right: Dimensions.paddingSizeDefault,
                            //               ),
                            //               child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            //
                            //                 Row(children: [
                            //
                            //                   Container(
                            //                     padding: const EdgeInsets.all(2),
                            //                     margin: EdgeInsets.zero,
                            //                     decoration: BoxDecoration(
                            //                       color: Theme.of(context).primaryColor.withOpacity(0.5),
                            //                       borderRadius: BorderRadius.circular(50),
                            //                     ),
                            //                     child: ClipRRect(
                            //                       borderRadius: BorderRadius.circular(50),
                            //                       child: CustomImageWidget(
                            //                         image: '${Get.find<SplashController>().configModel!.baseUrls!.campaignImageUrl}/${campaignController.campaign!.image}',
                            //                         height: 50, width: 50, fit: BoxFit.cover,
                            //                         isFood: true,
                            //                       ),
                            //                     ),
                            //                   ),
                            //                   const SizedBox(width: Dimensions.paddingSizeSmall),
                            //
                            //                   Expanded(
                            //                     child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                            //
                            //                       Text(
                            //                         campaignController.campaign!.title ?? '', style: robotoBold,
                            //                         maxLines: 1, overflow: TextOverflow.ellipsis,
                            //                       ),
                            //
                            //                       Text(
                            //                         campaignController.campaign!.description ?? '', maxLines: isDesktop ? 1 : 2, overflow: TextOverflow.ellipsis,
                            //                         style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                            //                       ),
                            //
                            //                     ]),
                            //                   ),
                            //
                            //                 ]),
                            //                 const SizedBox(height: Dimensions.paddingSizeSmall),
                            //
                            //                 scrollingRate < 0.8 ? campaignController.campaign!.startTime != null ? Row(children: [
                            //                   Icon(Icons.access_time_filled, size: 20, color: Theme.of(context).disabledColor),
                            //                   const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                            //
                            //                   Text('${'daily'.tr} - ', style: robotoRegular.copyWith(
                            //                     fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor,
                            //                   )),
                            //
                            //                   Text(
                            //                     '${DateConverter.convertTimeToTime(campaignController.campaign!.startTime!)}'
                            //                         ' ${'to'.tr} ${DateConverter.convertTimeToTime(campaignController.campaign!.endTime!)}',
                            //                     style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).primaryColor),
                            //                   ),
                            //
                            //                 ]): const SizedBox() : const SizedBox(),
                            //
                            //               ]),
                            //             ),
                            //           ),
                            //
                            //           Container(
                            //             padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                            //             margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                            //             decoration: BoxDecoration(
                            //               color: scrollingRate < 0.8 ? Theme.of(context).primaryColor.withOpacity(0.1) : Colors.transparent,
                            //               borderRadius: const BorderRadius.only(
                            //                 bottomLeft: Radius.circular(Dimensions.radiusSmall),
                            //                 bottomRight: Radius.circular(Dimensions.radiusSmall),
                            //               ),
                            //             ),
                            //             child: Column(children: [
                            //               scrollingRate < 0.8 ? Text(
                            //                 'end_date'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                            //               ) : const SizedBox(),
                            //               const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                            //
                            //               Container(
                            //                 decoration: const BoxDecoration(
                            //                   borderRadius: BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
                            //                   image: DecorationImage(
                            //                     image: AssetImage(Images.calender),
                            //                     fit: BoxFit.cover,
                            //                   ),
                            //                 ),
                            //                 child: Container(
                            //                   padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                            //                   margin: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
                            //                   decoration: const BoxDecoration(
                            //                     borderRadius: BorderRadius.only(
                            //                       bottomLeft: Radius.circular(Dimensions.radiusSmall),
                            //                       bottomRight: Radius.circular(Dimensions.radiusSmall),
                            //                     ),
                            //                   ),
                            //                   child: Column(children: [
                            //
                            //                     const SizedBox(height: Dimensions.paddingSizeSmall),
                            //
                            //                     Text(
                            //                       DateConverter.stringToLocalDateDayOnly(campaignController.campaign!.availableDateEnds!),
                            //                       style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge), textAlign: TextAlign.center,
                            //                     ),
                            //
                            //                     Text(
                            //                       DateConverter.stringToLocalDateMonthAndYearOnly(campaignController.campaign!.availableDateEnds!),
                            //                       style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                            //                     ),
                            //
                            //                   ]),
                            //                 ),
                            //
                            //               ),
                            //
                            //             ]),
                            //           ),
                            //
                            //         ]),
                            //
                            //       ]),
                            //     ) : const SizedBox();
                            //   },
                            //
                            // ),

                            // title: SizedBox(height: 100,
                            //   child: ListView(scrollDirection: Axis.horizontal,children: [
                            //                  Container(
                            //    width:297,height: 71,
                            //    decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall),color: Get.theme.primaryColor.withOpacity(0.2)),)
                            //   ],),
                            // ),
                            background: Stack(
                              children: [
                                Image.asset(Images.campaignBg),
                                Positioned(
                                  top: 80,
                                  left: 0,
                                  right: 0,
                                  child: Center(
                                    child: Container(
                                      width: 295,
                                      height: 148,
                                      margin: const EdgeInsets.only(bottom: 90),
                                      padding: EdgeInsets.zero,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.radiusLarge),
                                        child: CustomImageWidget(
                                          fit: BoxFit.cover,
                                          placeholder: Images.restaurantCover,
                                          image:
                                              '${Get.find<SplashController>().configModel!.baseUrls!.campaignImageUrl}/${widget.campaign.image}',
                                          isRestaurant: true,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 20,
                                  child: SizedBox(
                                    height: 85,
                                    width: Get.width,
                                    child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      padding: const EdgeInsets.only(
                                          left: 18, right: 30),
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(
                                              Dimensions.paddingSizeSmall),
                                          width: 297,
                                          height: 71,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color:
                                                      Get.theme.primaryColor),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimensions.radiusLarge),
                                              color: Get.theme.primaryColor
                                                  .withOpacity(0.05)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Image.asset(
                                                    Images.speaker,
                                                    height: 20,
                                                    width: 20,
                                                  ),
                                                  const SizedBox(
                                                    width: Dimensions
                                                        .paddingSizeExtraSmall,
                                                  ),
                                                  Text(
                                                    widget.campaign.title
                                                        .toString(),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: Get
                                                            .theme.primaryColor,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(
                                                height: Dimensions
                                                    .paddingSizeExtraSmall,
                                              ),
                                              Text(
                                                widget.campaign.description
                                                    .toString(),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: Dimensions
                                                        .fontSizeSmall),
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          width: Dimensions.paddingSizeSmall,
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(
                                              Dimensions.paddingSizeSmall),
                                          width: 297,
                                          height: 71,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color:
                                                      const Color(0xffFF9C5F)),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimensions.radiusLarge),
                                              color: Get.theme.primaryColor
                                                  .withOpacity(0.05)),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                  child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Image.asset(
                                                        Images.clock,
                                                        height: 12,
                                                        width: 12,
                                                      ),
                                                      const SizedBox(
                                                        width: Dimensions
                                                            .paddingSizeExtraSmall,
                                                      ),
                                                      Text(
                                                        'daily'.tr,
                                                        style: const TextStyle(
                                                            color: Color(
                                                                0xff090018)),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: Dimensions
                                                        .paddingSizeSmall2,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Image.asset(
                                                        Images.calendarMonth,
                                                        height: 12,
                                                        width: 12,
                                                      ),
                                                      const SizedBox(
                                                        width: Dimensions
                                                            .paddingSizeExtraSmall,
                                                      ),
                                                      const Text(
                                                        'Ending',
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xff090018)),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )),
                                              campaignController.campaign ==
                                                      null
                                                  ? const SizedBox()
                                                  : Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                              maxLines: 1,
                                                              '${DateConverter.convertTimeToTime(campaignController.campaign!.startTime!)}'
                                                              ' ${'to'.tr} ${DateConverter.convertTimeToTime(campaignController.campaign!.endTime!)}',
                                                              style: TextStyle(
                                                                  color: const Color(
                                                                      0xff090018),
                                                                  fontSize:
                                                                      Dimensions
                                                                          .fontSizeSmall)),
                                                          const SizedBox(
                                                            height: Dimensions
                                                                .paddingSizeDefault,
                                                          ),
                                                          Text(
                                                            DateConverter.stringToLocalDateMonthAndYearOnly(
                                                                campaignController
                                                                    .campaign!
                                                                    .availableDateEnds!),
                                                            style: robotoMedium.copyWith(
                                                                fontSize: Dimensions
                                                                    .fontSizeSmall,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: const Color(
                                                                    0xffFF7E2E)),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          actions: const [SizedBox()],
                        ),
                        SliverToBoxAdapter(
                            child: FooterViewWidget(
                          minHeight: 0.4,
                          child: Center(
                              child: Container(
                            width: Dimensions.webMaxWidth,
                            padding: const EdgeInsets.all(
                                Dimensions.paddingSizeSmall),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(
                                      Dimensions.radiusExtraLarge)),
                            ),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ProductViewWidget(
                                    isRestaurant: true,
                                    products: null,
                                    restaurants: campaignController
                                        .campaign?.restaurants,
                                  ),
                                  const SizedBox(
                                    height: Dimensions.paddingSizeExtraLarge,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal:
                                            Dimensions.paddingSizeDefault),
                                    child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          'with_love_from_maa'.tr,
                                          style: const TextStyle(
                                              fontSize: 40,
                                              fontWeight: FontWeight.w900,
                                              color: Color(0xffA7A7A7)),
                                        )),
                                  ),
                                  const SizedBox(
                                    height: 50,
                                  )
                                ]),
                          )),
                        )),
                      ],
                    );

              /// New Code ///
              // ListView(
              //
              //   children: [
              //    Image.asset(Images.campaignBg)
              //
              //   ],
              // );
            });
          },
        ));
  }
}

import 'package:flutter/cupertino.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/refer%20and%20earn/controllers/refer_and_earn_controller.dart';
import 'package:stackfood_multivendor/features/refer%20and%20earn/widgets/bottom_sheet_view_widget.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/theme_controller.dart';
import 'package:stackfood_multivendor/helper/price_converter.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/footer_view_widget.dart';
import 'package:stackfood_multivendor/common/widgets/menu_drawer_widget.dart';
import 'package:stackfood_multivendor/common/widgets/not_logged_in_screen.dart';
import 'package:stackfood_multivendor/common/widgets/web_page_title_widget.dart';
import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:share_plus/share_plus.dart';

import '../../../util/app_constants.dart';

class ReferAndEarnScreen extends StatefulWidget {
  const ReferAndEarnScreen({super.key});

  @override
  State<ReferAndEarnScreen> createState() => _ReferAndEarnScreenState();
}

class _ReferAndEarnScreenState extends State<ReferAndEarnScreen> {
  final ScrollController scrollController = ScrollController();
  final JustTheController tooltipController = JustTheController();

  @override
  void initState() {
    super.initState();

    _initCall();
  }

  void _initCall() {
    Get.find<ReferAndEarnController>().getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = ResponsiveHelper.isDesktop(context);
    bool isLoggedIn = Get.find<AuthController>().isLoggedIn();

    return Scaffold(
      appBar: CustomAppBarWidget(title: 'refer_and_earn'.tr),
      endDrawer: const MenuDrawerWidget(),
      endDrawerEnableOpenDragGesture: false,
      body:
          // ExpandableBottomSheet(
          //   background:
          isLoggedIn
              ? SingleChildScrollView(
                  controller: scrollController,
                  padding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 0 : Dimensions.paddingSizeLarge),
                  child: Column(children: [
                    WebScreenTitleWidget(title: 'refer_and_earn'.tr),
                    FooterViewWidget(
                      child: Center(
                        child: SizedBox(
                          width: Dimensions.webMaxWidth,
                          child: GetBuilder<ReferAndEarnController>(
                              builder: (referAndEarnController) {
                            return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                      height: isDesktop
                                          ? Dimensions.paddingSizeExtraOverLarge
                                          : Dimensions.paddingSizeOverLarge),

                                  const SizedBox(height: 60),

                                  Text(
                                      isDesktop
                                          ? 'invite_friends_and_earn_money_on_Every_Referral'
                                              .tr
                                          : 'invite_friends_and_business'.tr,
                                      style: robotoBold.copyWith(
                                          fontSize: isDesktop
                                              ? Dimensions.fontSizeLarge
                                              : Dimensions.fontSizeOverLarge),
                                      textAlign: TextAlign.center),
                                  const SizedBox(
                                      height: Dimensions.paddingSizeExtraSmall),
                                  Image.asset(
                                    Images.doodleArrow,
                                    width: 47,
                                    height: 54,
                                  ),

                                  isDesktop
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                              Text(
                                                '${'one_referral'.tr}= ',
                                                style: robotoBold.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeSmall,
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                              ),
                                              Text(
                                                PriceConverter.convertPrice(
                                                    Get.find<SplashController>()
                                                                .configModel !=
                                                            null
                                                        ? Get.find<
                                                                SplashController>()
                                                            .configModel!
                                                            .refEarningExchangeRate!
                                                            .toDouble()
                                                        : 0.0),
                                                style: robotoBold.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeSmall,
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                                textDirection:
                                                    TextDirection.ltr,
                                              ),
                                            ])
                                      : const SizedBox(),
                                  // isDesktop ?  const SizedBox(height: 40) : const SizedBox(),

                                  isDesktop
                                      ? const SizedBox()
                                      : const SizedBox(height: 20),

                                  isDesktop
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 250),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text('your_personal_code'.tr,
                                                style: robotoRegular.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeSmall),
                                                textAlign: TextAlign.start),
                                          ),
                                        )
                                      : const SizedBox(),

                                  isDesktop
                                      ? const SizedBox()
                                      : Text('your_personal_code'.tr,
                                          style: robotoRegular.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeSmall,
                                              color:
                                                  Theme.of(context).hintColor),
                                          textAlign: TextAlign.center),
                                  const SizedBox(
                                      height: Dimensions.paddingSizeDefault),

                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: isDesktop
                                            ? 250
                                            : Dimensions.paddingSizeDefault),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              Dimensions
                                                  .paddingSizeExtraOverLarge),
                                          border: Border.all(
                                              color: Colors.black, width: 2)),
                                      height: 50,
                                      child: (referAndEarnController
                                                  .userInfoModel !=
                                              null)
                                          ? Row(children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .only(
                                                      left: Dimensions
                                                          .paddingSizeLarge,
                                                      right: Dimensions
                                                          .paddingSizeLarge),
                                                  child: Text(
                                                    referAndEarnController
                                                                .userInfoModel !=
                                                            null
                                                        ? referAndEarnController
                                                                .userInfoModel!
                                                                .refCode ??
                                                            ''
                                                        : '',
                                                    style: TextStyle(
                                                        fontSize: Dimensions
                                                            .fontSizeLarge,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                              ),
                                              JustTheTooltip(
                                                backgroundColor:
                                                    Get.find<ThemeController>()
                                                            .darkTheme
                                                        ? Colors.white
                                                        : Colors.black87,
                                                controller: tooltipController,
                                                preferredDirection:
                                                    AxisDirection.up,
                                                tailLength: 14,
                                                tailBaseWidth: 20,
                                                content: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text('copied'.tr,
                                                      style: robotoRegular
                                                          .copyWith(
                                                              color: Colors
                                                                  .white)),
                                                ),
                                                child: InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  onTap: () {
                                                    if (referAndEarnController
                                                        .userInfoModel!
                                                        .refCode!
                                                        .isNotEmpty) {
                                                      tooltipController
                                                          .showTooltip();
                                                      Clipboard.setData(
                                                          ClipboardData(
                                                              text:
                                                                  '${referAndEarnController.userInfoModel != null ? referAndEarnController.userInfoModel!.refCode : ''}'));
                                                    }

                                                    Future.delayed(
                                                        const Duration(
                                                            seconds: 2), () {
                                                      tooltipController
                                                          .hideTooltip();
                                                    });
                                                  },
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                        color: Colors.black,
                                                        borderRadius: BorderRadius
                                                            .circular(isDesktop
                                                                ? Dimensions
                                                                    .radiusDefault
                                                                : 50)),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: Dimensions
                                                            .paddingSizeExtraOverLarge),
                                                    margin:
                                                        const EdgeInsets.all(2),
                                                    child: Text('copy'.tr,
                                                        style: robotoRegular.copyWith(
                                                            color: Theme.of(
                                                                    context)
                                                                .cardColor,
                                                            fontSize: Dimensions
                                                                .fontSizeLarge)),
                                                  ),
                                                ),
                                              ),
                                            ])
                                          : const CircularProgressIndicator(),
                                    ),
                                  ),
                                  SizedBox(
                                      height: isDesktop
                                          ? Dimensions.paddingSizeOverLarge
                                          : Dimensions.paddingSizeSmall),

                                  isDesktop
                                      ? const SizedBox()
                                      : Text(
                                          "Copy Your Code & Share It. Simple!",
                                          style: robotoRegular.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeSmall),
                                          textAlign: TextAlign.center),

                                  SizedBox(
                                      height: isDesktop
                                          ? Dimensions.paddingSizeOverLarge
                                          : Dimensions.paddingSizeLarge),

                                  // Text('or_share'.tr , style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall), textAlign: TextAlign.center),
                                  const SizedBox(
                                      height: Dimensions.paddingSizeLarge),

                                  InkWell(
                                      onTap: () => Share.share(
                                          '${'this_is_my_refer_code'.tr}: ${referAndEarnController.userInfoModel!.refCode}'),
                                      child: Image.asset(
                                        Images.shareImg,
                                        height: 35,
                                      )),

                                  SizedBox(
                                    height: 80,
                                  ),
                                  Container(
                                    width: Get.width,
                                    padding: EdgeInsets.all(
                                        Dimensions.paddingSizeSmall),
                                    decoration: BoxDecoration(
                                        color: Color(0xffFBF8FF),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                            color: Get.theme.primaryColor)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('how_it_works'.tr,
                                            style: robotoMedium.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeLarge,
                                                fontWeight: FontWeight.w600),
                                            textAlign: TextAlign.center),
                                        SizedBox(height: 10,),
                                        Row(
                                          children: [
                                            Text(
                                              "Step-1",
                                              style: TextStyle(
                                                  fontSize:
                                                      Dimensions.fontSizeSmall,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(width: 12,),
                                            Expanded(
                                              child: Text(
                                                "Share referral code to your Friends & Businesses",
                                                style: TextStyle(
                                                  color: Color(0xff524A61),

                                                    fontSize:
                                                        Dimensions.fontSizeSmall,),
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(height: 8,),
                                        Row(
                                          children: [
                                            Text(
                                              "Step-2",
                                              style: TextStyle(
                                                  fontSize:
                                                  Dimensions.fontSizeSmall,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(width: 12,),

                                            Expanded(
                                              child: Text(
                                                "They will register madeByMaa with special offer",
                                                style: TextStyle(
                                                  color: Color(0xff524A61),

                                                  fontSize:
                                                  Dimensions.fontSizeSmall,),
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(height: 8,),
                                        Row(
                                          children: [
                                            Text(
                                              "Step-3",
                                              style: TextStyle(
                                                  fontSize:
                                                  Dimensions.fontSizeSmall,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(width: 12,),

                                            Expanded(
                                              child: Text(
                                                "You just made your earnings! Simple.",
                                                style: TextStyle(
                                                  color: Color(0xff524A61),
                                                  fontSize:
                                                  Dimensions.fontSizeSmall,),
                                              ),
                                            )
                                          ],
                                        ),


                                      ],
                                    ),
                                  ),



                                  isDesktop
                                      ? const Padding(
                                          padding: EdgeInsets.only(
                                            top:
                                                Dimensions.paddingSizeOverLarge,
                                            bottom: Dimensions
                                                .paddingSizeExtraLarge,
                                            left: 100,
                                            right: 100,
                                          ),
                                          child: BottomSheetViewWidget(),
                                        )
                                      : const SizedBox(),
                                ]);
                          }),
                        ),
                      ),
                    ),
                  ]),
                )
              : NotLoggedInScreen(callBack: (value) {
                  _initCall();
                  setState(() {});
                }),

      // persistentContentHeight: isDesktop ? 0 : 60,
      // expandableContent: isDesktop || !isLoggedIn ? const SizedBox() : const BottomSheetViewWidget(),

      // ),
    );
  }
}

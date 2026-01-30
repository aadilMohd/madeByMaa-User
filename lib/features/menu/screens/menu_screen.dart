import 'package:stackfood_multivendor/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/auth/screens/phone_screen.dart';
import 'package:stackfood_multivendor/features/cart/controllers/cart_controller.dart';
import 'package:stackfood_multivendor/features/favourite/screens/favourite_screen.dart';
import 'package:stackfood_multivendor/features/language/controllers/localization_controller.dart';
import 'package:stackfood_multivendor/features/language/widgets/language_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor/features/menu/widgets/portion_widget.dart';
import 'package:stackfood_multivendor/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor/features/profile/widgets/profile_button_widget.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/theme_controller.dart';
import 'package:stackfood_multivendor/features/auth/screens/sign_in_screen.dart';
import 'package:stackfood_multivendor/features/favourite/controllers/favourite_controller.dart';
import 'package:stackfood_multivendor/helper/auth_helper.dart';
import 'package:stackfood_multivendor/helper/price_converter.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/confirmation_dialog_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../util/app_constants.dart';
import '../../order/controllers/order_controller.dart';


class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  void initState() {
    super.initState();

    _initCall();
  }
  void _initCall() {
    if (Get.find<AuthController>().isLoggedIn() &&
        Get.find<ProfileController>().userInfoModel == null) {
      Get.find<ProfileController>().getUserInfo();
    }
    if (Get.find<AuthController>().isLoggedIn() &&
        Get.find<OrderController>().runningOrderList == null) {
      Get.find<OrderController>().getRunningOrders(1, notify: false, limit: 5);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Get.theme.cardColor,
        shadowColor: Theme.of(context).disabledColor.withOpacity(0.5),
        elevation: 2,
        backgroundColor: Get.theme.cardColor,
        centerTitle: true,
        title: const Text("My Profile"),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_outlined),
        ),
      ),
      body: GetBuilder<ProfileController>(builder: (profileController) {
        final bool isLoggedIn = Get.find<AuthController>().isLoggedIn();

        return Column(children: [
          Expanded(
              child: SingleChildScrollView(
            child: Ink(
              color: Get.find<ThemeController>().darkTheme
                  ? Theme.of(context).colorScheme.background
                  : Theme.of(context).cardColor,
              padding: const EdgeInsets.only(top: Dimensions.paddingSizeLarge),
              child: Column(children: [
                /// Profile ///
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Stack(
                    children: [
                      SizedBox(
                        height: isLoggedIn?350:240,
                        width: Get.width,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              12),
                          child: Image.asset(
                            Images.profileBg2,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,bottom: 0,
                        right: 0,left: 0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          isLoggedIn?  Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10.0,top: 10),
                                  child: InkWell(

                                      onTap: (){
                                        Get.toNamed(RouteHelper.getUpdateProfileRoute());

                                      },
                                      child: Text("Edit",style: TextStyle(color: Get.theme.cardColor,fontSize: Dimensions.fontSizeLarge,fontWeight: FontWeight.w500),)),
                                )):SizedBox(),

                            Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(1),
                              child: ClipOval(
                                child: CustomImageWidget(
                                  placeholder: isLoggedIn
                                      ? Images.profilePlaceholder
                                      : Images.guestIcon,
                                  image:
                                      '${Get.find<SplashController>().configModel!.baseUrls!.customerImageUrl}'
                                      '/${(profileController.userInfoModel != null && isLoggedIn) ? profileController.userInfoModel!.image : ''}',
                                  height: 127,
                                  width: 127,
                                  fit: BoxFit.cover,
                                  imageColor: isLoggedIn
                                      ? Theme.of(context).hintColor
                                      : null,
                                ),
                              ),
                            ),
                            const SizedBox(
                                width: Dimensions.paddingSizeDefault),
                            Column(
                              children: [
                                SizedBox(height: Dimensions.paddingSizeSmall,),
                                isLoggedIn &&
                                        profileController.userInfoModel ==
                                            null
                                    ? Shimmer(
                                        duration: const Duration(seconds: 2),
                                        enabled: true,
                                        child: Container(
                                          height: 16,
                                          width: 200,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[
                                                Get.find<ThemeController>()
                                                        .darkTheme
                                                    ? 700
                                                    : 200],
                                            borderRadius:
                                                BorderRadius.circular(
                                                    Dimensions.radiusSmall),
                                          ),
                                        ),
                                      )
                                    : Text(
                                        isLoggedIn
                                            ? '${profileController.userInfoModel?.fName} ${profileController.userInfoModel?.lName}'
                                            : 'guest_user'.tr,
                                        style: robotoBold.copyWith(
                                            fontSize:
                                                Dimensions.fontSizeExtraLarge,
                                            color:
                                                Theme.of(context).cardColor),
                                      ),
                                SizedBox(height: Dimensions.paddingSizeSmall,),

                                isLoggedIn &&
                                        profileController.userInfoModel !=
                                            null
                                    ? Text(
                                        profileController
                                            .userInfoModel!.phone!,
                                        style: robotoMedium.copyWith(
                                            fontSize:
                                                Dimensions.fontSizeSmall,
                                            color:
                                                Theme.of(context).cardColor),
                                      )
                                    : InkWell(
                                        onTap: () async {
                                          if (!ResponsiveHelper.isDesktop(
                                              context)) {
                                            Get.toNamed(RouteHelper
                                                    .getSignInRoute(
                                                        Get.currentRoute))
                                                ?.then((value) {
                                              if (AuthHelper.isLoggedIn()) {
                                                profileController
                                                    .getUserInfo();
                                              }
                                            });
                                          } else {
                                            Get.dialog(const SignInScreen(
                                                    exitFromApp: true,
                                                    backFromThis: true))
                                                .then((value) {
                                              if (AuthHelper.isLoggedIn()) {
                                                profileController
                                                    .getUserInfo();
                                              }
                                            });
                                          }
                                        },
                                        child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'login_to_view_all_feature'.tr,
                                              style: robotoMedium.copyWith(decoration: TextDecoration.underline,decorationColor: Theme.of(context).cardColor,
                                                  fontSize:
                                                      Dimensions.fontSizeSmall,
                                                  color: Theme.of(context)
                                                      .cardColor),
                                            ),SizedBox(width: 5,),
                                            Icon(Icons.arrow_forward, size: 15,color:Theme.of(context).cardColor,)
                                          ],
                                        ),
                                      ),
                                const SizedBox(height: 10,),
                                isLoggedIn?
                                Container(padding: const EdgeInsets.symmetric(vertical: 5),
                                  margin: const EdgeInsets.symmetric(horizontal: 16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                  color: const Color(0xff8138C2)

                                ),child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                         children: [
                                           Row(mainAxisAlignment: MainAxisAlignment.center,
                                             children: [
                                              Image.asset(Images.option,height: 16,width: 16,),
                                               const SizedBox(width: 15,),
                                               Text("Total Orders",style: TextStyle(color: Color(0xffE0E0E0),fontSize: Dimensions.fontSizeLarge),)
                                             ],
                                           ),
                                           const SizedBox(height: 5,),
                                           Text(profileController.userInfoModel!.orderCount.toString(),style: TextStyle(color: Get.theme.cardColor,fontWeight: FontWeight.w500,fontSize: Dimensions.fontSizeOverLarge),),
                                         ],
                                      ),
                                    ),
                                    const SizedBox(height: 80,child: VerticalDivider(thickness: 2),),
                                    Expanded(
                                      child: Column(



                                        children: [

                                          Row(mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Image.asset(Images.profileWallet,height: 16,width: 16,),
                                              const SizedBox(width: 15,),
                                              Text("Wallet",style: TextStyle(color:Color(0xffE0E0E0),fontSize: Dimensions.fontSizeLarge),)
                                            ],
                                          ),
                                          const SizedBox(height: 5,),

                                          Text("₹${profileController.userInfoModel!.walletBalance}",style: TextStyle(color: Get.theme.cardColor,fontWeight: FontWeight.w500,fontSize: Dimensions.fontSizeOverLarge),),
                                        ],
                                      ),
                                    ),



                                  ],
                                ),)
                                    :
                                SizedBox(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20,),


                isLoggedIn
                    ? GetBuilder<AuthController>(
                    builder: (authController) {
                      return Container(
                        margin:const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeDefault),
                        padding: const EdgeInsets.symmetric(
                          vertical: Dimensions.paddingSizeSmall,
                            horizontal:
                            Dimensions.paddingSizeDefault),
                        decoration: BoxDecoration(color: Get.theme.primaryColor.withOpacity(0.05),borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),

                        child: ProfileButtonWidget(
                          icon: Icons.notifications_none_outlined,
                          color: Color(0xff524A61)
                          ,
                          title: 'notification'.tr,

                          isButtonActive:
                          authController
                              .notification,
                          onTap: () {
                            authController
                                .setNotificationActive(
                                !authController
                                    .notification);
                          },
                        ),
                      );
                    })
                    : const SizedBox(),

                // Container(
                //   margin:const EdgeInsets.all(Dimensions.paddingSizeDefault),
                //   padding: const EdgeInsets.symmetric(
                //       vertical: Dimensions.paddingSizeSmall,
                //       horizontal:
                //       Dimensions.paddingSizeDefault),
                //   decoration: BoxDecoration(color: Get.theme.primaryColor.withOpacity(0.05),borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
                //   child: ProfileButtonWidget(
                //     icon: Icons.tonality,
                //     title: 'dark_mode'.tr,
                //     isButtonActive: Get.isDarkMode,
                //     isThemeSwitchButton: true,
                //     onTap: () {
                //       Get.find<ThemeController>().toggleTheme();
                //     },
                //   ),
                // ),

                /// General ///

                SizedBox(height: 30,),

                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeExtraLarge),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      'general'.tr,
                      style: robotoMedium.copyWith(
                        fontWeight: FontWeight.w400,

                          fontSize: Dimensions.fontSizeSmall,
                          color:Color(0xff524A61)
        ),
                    ),
                    const Divider(

                    ),
                    // PortionWidget(
                    //     icon: Images.profileIcon,
                    //     title: 'profile'.tr,
                    //     route: RouteHelper.getProfileRoute()),
                    PortionWidget(
                        icon: Images.distance,
                        title: 'address'.tr,
                        route: RouteHelper.getAddressRoute()),
                    PortionWidget(
                        icon: Images.translate,
                        title: 'language'.tr,
                        onTap: () => _manageLanguageFunctionality(),
                        route: ''),
                    PortionWidget(
                        icon: Images.favorite,
                        title: 'favorite'.tr,
                        route: '',

                    onTap:(){
                      Get.to(()=>const FavouriteScreen());

                    } ),

                  ]),
                ),

                const SizedBox(height: 20,),

                /// Personal Activity ///

                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeExtraLarge),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      'promotional_activity'.tr,
                      style: robotoMedium.copyWith(
                          fontWeight: FontWeight.w400,

                          fontSize: Dimensions.fontSizeSmall,
                          color:const Color(0xff524A61)
                      ),
                    ),
                    const Divider(

                    ),
                    PortionWidget(
                        icon: Images.coupon5,
                        title: 'coupon'.tr,
                        route:
                            RouteHelper.getCouponRoute(fromCheckout: false)),
                    (Get.find<SplashController>()
                                .configModel!
                                .loyaltyPointStatus ==
                            1)
                        ? PortionWidget(
                            icon: Images.pointIcon,
                            title: 'loyalty_points'.tr,
                            route: RouteHelper.getLoyaltyRoute(),
                            hideDivider: Get.find<SplashController>()
                                        .configModel!
                                        .customerWalletStatus ==
                                    1
                                ? false
                                : true,
                            suffix: !isLoggedIn
                                ? null
                                : '${profileController.userInfoModel?.loyaltyPoint != null ? Get.find<ProfileController>().userInfoModel!.loyaltyPoint.toString() : '0'} ${'points'.tr}',
                          )
                        : const SizedBox(),
                    (Get.find<SplashController>()
                                .configModel!
                                .customerWalletStatus ==
                            1)
                        ? PortionWidget(
                            icon: Images.profileWallet,
                            title: 'my_wallet'.tr,
                            hideDivider: true,
                            route: RouteHelper.getWalletRoute(),
                            suffix: !isLoggedIn
                                ? null
                                : PriceConverter.convertPrice(
                                    profileController.userInfoModel != null
                                        ? Get.find<ProfileController>()
                                            .userInfoModel!
                                            .walletBalance
                                        : 0),
                          )
                        : const SizedBox()
                  ]),
                ),

                const SizedBox(height: 30,),

                ///App Setting ///

                // Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                //   Padding(
                //     padding: const EdgeInsets.symmetric(
                //         horizontal: Dimensions.paddingSizeDefault),
                //     child: Text(
                //       "App Settings",
                //       style: robotoMedium.copyWith(
                //           fontSize: Dimensions.fontSizeDefault,
                //           color:
                //               Theme.of(context).primaryColor.withOpacity(0.5)),
                //     ),
                //   ),
                //   Container(
                //     decoration: BoxDecoration(
                //       color: Theme.of(context).cardColor,
                //       borderRadius:
                //           BorderRadius.circular(Dimensions.radiusDefault),
                //       boxShadow: const [
                //         BoxShadow(
                //             color: Colors.black12,
                //             spreadRadius: 1,
                //             blurRadius: 5)
                //       ],
                //     ),
                //     padding: const EdgeInsets.symmetric(
                //         horizontal: Dimensions.paddingSizeLarge,
                //         vertical: Dimensions.paddingSizeDefault),
                //     margin: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                //     child: Column(
                //         mainAxisAlignment: MainAxisAlignment.start,
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Container(
                //             child: Row(
                //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //               children: [
                //                 Text(
                //                   "App Version :",
                //                   style: robotoRegular,
                //                 ),
                //                 Text(
                //                   "1.0.0",
                //                   style: robotoRegular,
                //                 ),
                //               ],
                //             ),
                //           ),
                //           const SizedBox(
                //             height: 10,
                //           ),
                //           Container(
                //             child: Padding(
                //               padding: const EdgeInsets.only(top: 8.0),
                //               child: FittedBox(
                //                 child: Row(
                //                   mainAxisAlignment: MainAxisAlignment.start,
                //                   children: [
                //                     Text(
                //                         'Developed By : Alab Technology Pvt.Ltd Care with ',
                //                         style: robotoRegular),
                //                     const SizedBox(
                //                       width: 5,
                //                     ),
                //                     const Icon(
                //                       Icons.favorite,
                //                       size: 20,
                //                       color: Colors.pink,
                //                       shadows: [
                //                         Shadow(
                //                             color: Colors.white,
                //                             offset: Offset(0, 2),
                //                             blurRadius: 0),
                //                       ],
                //                     )
                //                   ],
                //                 ),
                //               ),
                //             ),
                //           ),
                //         ]),
                //   )
                // ]),
                /// Earning ///

                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeExtraLarge),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      'earnings'.tr,
                      style: robotoMedium.copyWith(
                          fontWeight: FontWeight.w400,

                          fontSize: Dimensions.fontSizeSmall,
                          color:Color(0xff524A61)
                      ),
                    ),
                    const Divider(

                    ),
                    (Get.find<SplashController>()
                                .configModel!
                                .refEarningStatus ==
                            1)
                        ? PortionWidget(
                            icon: Images.money1,
                            title: 'refer_and_earn'.tr,
                            route: RouteHelper.getReferAndEarnRoute(),
                          )
                        : const SizedBox(),
                    (Get.find<SplashController>()
                                .configModel!
                                .toggleDmRegistration! &&
                            !ResponsiveHelper.isDesktop(context))
                        ? PortionWidget(
                            icon: Images.cycle,
                            title: 'join_as_a_delivery_man'.tr,
                            route:
                                RouteHelper.getDeliverymanRegistrationRoute(),
                          )
                        : const SizedBox(),
                    (Get.find<SplashController>()
                                .configModel!
                                .toggleRestaurantRegistration! &&
                            !ResponsiveHelper.isDesktop(context))
                        ? PortionWidget(
                            icon: Images.store,
                            title: 'Join_as_a_mom_chef'.tr,
                            hideDivider: true,
                            route:
                                RouteHelper.getRestaurantRegistrationRoute(),
                          )
                        : const SizedBox()
                  ]),
                ),
                const SizedBox(height: 30,),


                /// Help And Support ///

                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeExtraLarge),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      'support'.tr,
                      style: robotoMedium.copyWith(
                          fontWeight: FontWeight.w400,

                          fontSize: Dimensions.fontSizeSmall,
                          color:Color(0xff524A61)
                      ),
                    ),
                    const Divider(

                    ),
                    PortionWidget(
                        icon: Images.liveChat,
                        title: 'live_chat'.tr,
                        route: RouteHelper.getConversationRoute()),
                    PortionWidget(
                        icon: Images.helpSupport,
                        title: 'help_and_support'.tr,
                        route: RouteHelper.getSupportRoute()),
                    const SizedBox(height: 30,),

                    Text(
                      'policy_of_madeByMaa'.tr,
                      style: robotoMedium.copyWith(
                          fontWeight: FontWeight.w400,

                          fontSize: Dimensions.fontSizeSmall,
                          color:Color(0xff524A61)),
                    ),
                    const Divider(

                    ),

                    (Get.find<SplashController>()
                        .configModel!
                        .cancellationPolicyStatus ==
                        1)
                        ?  InkWell(
                      onTap: (){
                        Get.toNamed(RouteHelper.getHtmlRoute(
                            'cancellation-policy'),);
                      },
                      child: Row(children: [


                        Expanded(child: Text('cancellation_policy'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault,color: Get.theme.disabledColor))),


                      ]),
                    ):const SizedBox(),
                    const SizedBox(height: 20,),

                    InkWell(
                      onTap: (){
                        Get.toNamed(RouteHelper.getHtmlRoute(
                            'about-us'),);
                      },
                      child: Row(children: [


                        Expanded(child: Text( 'about_us'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault,color: Get.theme.disabledColor))),


                      ]),
                    ),
                    const SizedBox(height: 20,),

                    InkWell(
                      onTap: (){
                        Get.toNamed(RouteHelper.getHtmlRoute(
                            'terms-and-condition'),);
                      },
                      child: Row(children: [


                        Expanded(child: Text( 'terms_conditions'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault,color: Get.theme.disabledColor))),


                      ]),
                    ),

                    const SizedBox(height: 20,),

                    InkWell(
                      onTap: (){
                        Get.toNamed(RouteHelper.getHtmlRoute(
                            'privacy-policy'),);
                      },
                      child: Row(children: [


                        Expanded(child: Text( 'privacy_policy'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault,color: Get.theme.disabledColor))),


                      ]),
                    ),
                    const SizedBox(height: 20,),
                    // CustomButtonWidget(
                    //   buttonText: "Login",
                    //   onPressed: () {
                    //     Get.to(() =>  Phone(backFromThis: true,exitFromApp: false,));
                    //   },
                    // ),
                    // const SizedBox(height: 20,),

                    InkWell(
                      onTap: () async {
                        if (Get.find<AuthController>().isLoggedIn()) {
                          Get.dialog(
                              ConfirmationDialogWidget(
                                  icon: Images.support,
                                  description: 'are_you_sure_to_logout'.tr,
                                  isLogOut: true,
                                  onYesPressed: () async {
                                    Get.find<ProfileController>()
                                        .setForceFullyUserEmpty();
                                    Get.find<AuthController>().socialLogout();
                                    Get.find<CartController>().clearCartList();
                                    Get.find<FavouriteController>()
                                        .removeFavourites();
                                    await Get.find<AuthController>()
                                        .clearSharedData();
print("ppp 423234");
                                   // Get.offAllNamed(RouteHelper.getInitialRoute());
                                    Get.offAllNamed(RouteHelper.getSignInRoute(Get.currentRoute));
                                  }),
                              useSafeArea: false);
                        } else {
                          Get.find<FavouriteController>().removeFavourites();
                          await Get.toNamed(
                              RouteHelper.getSignInRoute(Get.currentRoute));
                          if (AuthHelper.isLoggedIn()) {
                            profileController.getUserInfo();
                          }
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: Dimensions.paddingSizeSmall),
                        child: Row(
                            children: [
                              const Icon(Icons.login,
                                  size: 20, color: Colors.red),
                              const SizedBox(
                                  width: Dimensions.paddingSizeExtraSmall),
                              Text(
                                  Get.find<AuthController>().isLoggedIn()
                                      ? 'logout'.tr
                                      : 'sign_in'.tr,
                                  style: TextStyle( fontFamily: AppConstants.fontFamily,
                                    fontWeight: FontWeight.w500,color: Colors.red,
                                    fontSize: Dimensions.fontSizeLarge,))
                            ]),
                      ),
                    ),


                    // PortionWidget(
                    //     icon: Images.aboutIcon,
                    //     title: 'about_us'.tr,
                    //     route: RouteHelper.getHtmlRoute('about-us')),
                    // PortionWidget(
                    //     icon: Images.termsIcon,
                    //     title: 'terms_conditions'.tr,
                    //     route:
                    //         RouteHelper.getHtmlRoute('terms-and-condition')),
                    // PortionWidget(
                    //     icon: Images.privacyIcon,
                    //     title: 'privacy_policy'.tr,
                    //     route: RouteHelper.getHtmlRoute('privacy-policy')),
                    // (Get.find<SplashController>()
                    //             .configModel!
                    //             .refundPolicyStatus ==
                    //         1)
                    //     ? PortionWidget(
                    //         icon: Images.refundIcon,
                    //         title: 'refund_policy'.tr,
                    //         route: RouteHelper.getHtmlRoute('refund-policy'),
                    //       )
                    //     : const SizedBox(),
                    // (Get.find<SplashController>()
                    //             .configModel!
                    //             .cancellationPolicyStatus ==
                    //         1)
                    //     ? PortionWidget(
                    //         icon: Images.cancelationIcon,
                    //         title: 'cancellation_policy'.tr,
                    //         route: RouteHelper.getHtmlRoute(
                    //             'cancellation-policy'),
                    //       )
                    //     : const SizedBox(),
                    // (Get.find<SplashController>()
                    //             .configModel!
                    //             .shippingPolicyStatus ==
                    //         1)
                    //     ? PortionWidget(
                    //         icon: Images.shippingIcon,
                    //         title: 'shipping_policy'.tr,
                    //         hideDivider: true,
                    //         route:
                    //             RouteHelper.getHtmlRoute('shipping-policy'),
                    //       )
                    //     : const SizedBox()
                  ]),
                ),
                // const SizedBox(height: 20,),


                const SizedBox(height: Dimensions.paddingSizeOverLarge)
              ]),
            ),
          )),
        ]);
      }),
    );
  }

  _manageLanguageFunctionality() {
    Get.find<LocalizationController>().saveCacheLanguage(null);
    Get.find<LocalizationController>().searchSelectedLanguage();

    showModalBottomSheet(
      isScrollControlled: true,
      useRootNavigator: true,
      context: Get.context!,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Dimensions.radiusExtraLarge),
            topRight: Radius.circular(Dimensions.radiusExtraLarge)),
      ),
      builder: (context) {
        return ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8),
          child: const LanguageBottomSheetWidget(),
        );
      },
    ).then((value) => Get.find<LocalizationController>().setLanguage(
        Get.find<LocalizationController>().getCacheLocaleFromSharedPref()));
  }
}

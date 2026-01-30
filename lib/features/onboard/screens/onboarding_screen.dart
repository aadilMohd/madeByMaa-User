import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor/common/widgets/custom_asset_image_widget.dart';
import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/onboard/controllers/onboard_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/helper/address_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';

class OnBoardingScreen extends StatelessWidget {
  OnBoardingScreen({super.key});

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    Get.find<OnBoardingController>().getOnBoardingList();
    return GetBuilder<OnBoardingController>(builder: (onBoardingController) {
      return Scaffold(
        backgroundColor: Colors.white,
bottomNavigationBar: SizedBox(
  height:onBoardingController.selectedIndex == 2?150: 120,

  child: Column(mainAxisAlignment: MainAxisAlignment.end,
    children: [
      onBoardingController.selectedIndex != 2
          ? SizedBox()
          : InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          if (onBoardingController.selectedIndex !=
              2) {
            _pageController.nextPage(
                duration: const Duration(seconds: 1),
                curve: Curves.ease);
          } else {
            _configureToRouteInitialPage();
          }
        },
        child: Image.asset(Images.getStarted,height: 50,),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeOverLarge),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            onBoardingController.selectedIndex == 2
                ? const SizedBox()
                : InkWell(
              onTap: () {
                _configureToRouteInitialPage();

              },
              child: Padding(
                padding: const EdgeInsets.all(
                    Dimensions.paddingSizeSmall),
                child: Text('skip'.tr,
                    style: robotoBold.copyWith(
                        color:Color(0xffA7A7A7
                        ),
                        fontSize:
                        Dimensions.fontSizeExtraLarge)),
              ),
            ),
            onBoardingController.selectedIndex == 2
                ? SizedBox()
                : InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                if (onBoardingController.selectedIndex !=
                    2) {
                  _pageController.nextPage(
                      duration: const Duration(seconds: 1),
                      curve: Curves.ease);
                } else {
                  _configureToRouteInitialPage();
                }
              },
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  // color: Theme.of(context).primaryColor,
                  border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.arrow_forward,
                    size: 30,
                    color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        ),
      ),
      Container(
        padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.paddingSizeDefault,
            vertical: Dimensions.paddingSizeExtraLarge
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _pageIndicators(
              onBoardingController, context),
        ),
      ),
    ],
  ),
),
        body: onBoardingController.onBoardingList != null
            ? ListView(
            padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
            physics: NeverScrollableScrollPhysics(),
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child:PageView(controller: _pageController,
                          onPageChanged: (index) {
                            onBoardingController.changeSelectIndex(index);
                          },
                        children: [
                          Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 200,),
                              Image.asset(Images.onboarding),
                              SizedBox(height: 80,),

                              Image.asset(Images.onboardingText,height: 104,),
                            ],
                          ),

                               ////////

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Image.asset(Images.onboarding2),
                              SizedBox(height: 100,),
                              Text("300+",style: TextStyle(fontSize: 50,color: Get.theme.primaryColor,fontWeight: FontWeight.w700
                              ),),

                              Image.asset(Images.onboardingText2,height: 100,),
                            ],
                          ),
                          ////////////////
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 80,),

                              Center(child: Text("All are FSSAI registered kitchen",style: TextStyle(fontSize: Dimensions.fontSizeLarge),)),
                              SizedBox(height: 10,),
                              Image.asset(Images.onboarding3),
                              SizedBox(height: 40,),

                              Image.asset(Images.onboardingText3,height: 100,),
                              Text("Guaranteed Quality, Premium Ingredients...\nStrict Hygiene Standards",style: TextStyle(fontSize: Dimensions.fontSizeLarge,color: Color(0xff524A61
                              )),)
                            ],
                          ),
                        ],
                      )

                      // PageView.builder(
                      //   controller: _pageController,
                      //   itemCount: onBoardingController.onBoardingList!.length,
                      //   itemBuilder: (context, index) {
                      //     return
                      //       Column(
                      //         mainAxisAlignment: MainAxisAlignment.start,
                      //         children: [
                      //           Stack(
                      //               alignment: Alignment.bottomCenter,
                      //               children: [
                      //                 SizedBox(
                      //                   height:
                      //                       MediaQuery.of(context).size.height *
                      //                           0.55,
                      //                   width:
                      //                       MediaQuery.of(context).size.width,
                      //                   child: CustomAssetImageWidget(
                      //                     onBoardingController
                      //                         .onBoardingList![index]
                      //                         .frameImageUrl,
                      //                     width:
                      //                         MediaQuery.of(context).size.width,
                      //                     fit: BoxFit.fill,
                      //                     color: Theme.of(context).primaryColor,
                      //                   ),
                      //                 ),
                      //                 Positioned(
                      //                   bottom: 120,
                      //                   child: CustomAssetImageWidget(
                      //                     onBoardingController
                      //                         .onBoardingList![index].imageUrl,
                      //                     width: MediaQuery.of(context)
                      //                             .size
                      //                             .width *
                      //                         0.60,
                      //                     fit: BoxFit.fill,
                      //                   ),
                      //                 ),
                      //               ]),
                      //           Text(
                      //             onBoardingController
                      //                 .onBoardingList![index].title,
                      //             style: robotoBold.copyWith(
                      //                 fontSize: Dimensions.fontSizeExtraLarge),
                      //             textAlign: TextAlign.center,
                      //           ),
                      //           const SizedBox(
                      //               height: Dimensions.paddingSizeSmall),
                      //           SizedBox(
                      //             width:
                      //                 MediaQuery.of(context).size.width * 0.75,
                      //             child: Text(
                      //               onBoardingController
                      //                   .onBoardingList![index].description,
                      //               style: robotoRegular.copyWith(
                      //                   color: Theme.of(context).disabledColor),
                      //               textAlign: TextAlign.center,
                      //             ),
                      //           ),
                      //         ]);
                      //   },
                      //   onPageChanged: (index) {
                      //     onBoardingController.changeSelectIndex(index);
                      //   },
                      // ),
                    ),
                    SizedBox(height: 20,),

                  ])
            : const Center(child: CircularProgressIndicator()),
      );
    });
  }

  List<Widget> _pageIndicators(
      OnBoardingController onBoardingController, BuildContext context) {
    List<Container> indicators = [];

    for (int i = 0; i < onBoardingController.onBoardingList!.length; i++) {
      indicators.add(
        Container(
          width: i == onBoardingController.selectedIndex ? 10 : 7,
          height: i == onBoardingController.selectedIndex ? 10 : 7,
          margin: const EdgeInsets.only(right: 5),
          decoration: BoxDecoration(
            color: i == onBoardingController.selectedIndex
                ? Colors.black
            :Color(0xffE0E0E0
            ),
            
                // : Theme.of(context).primaryColor.withOpacity(0.40),
            borderRadius: i == onBoardingController.selectedIndex
                ? BorderRadius.circular(50)
                : BorderRadius.circular(25),
          ),
        ),
      );
    }
    return indicators;
  }

  void _configureToRouteInitialPage() async {
    Get.find<SplashController>().disableIntro();
    await Get.find<AuthController>().guestLogin();
    if (AddressHelper.getAddressFromSharedPref() != null) {
      if(!Get.find<AuthController>().isLoggedIn()){
        Get.offNamed(RouteHelper.signIn);
      }
      else{
      Get.offNamed(RouteHelper.getInitialRoute(fromSplash: true));}

    } else {

      Get.find<SplashController>()
          .navigateToLocationScreen('splash', offNamed: true);
    }
  }
}

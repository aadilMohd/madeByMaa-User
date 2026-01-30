import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/favourite/controllers/favourite_controller.dart';
import 'package:stackfood_multivendor/features/favourite/widgets/fav_item_view_widget.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/not_logged_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../helper/responsive_helper.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  FavouriteScreenState createState() => FavouriteScreenState();
}

class FavouriteScreenState extends State<FavouriteScreen> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    _initCall();
  }

  void _initCall(){
    if(Get.find<AuthController>().isLoggedIn()) {
      Get.find<FavouriteController>().getFavouriteList(fromFavScreen: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: CustomAppBarWidget(title: 'favourite'.tr, isBackButtonExist: true),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              centerTitle: true,
              title: Text('favourite'.tr,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
              elevation: 3,shadowColor: Colors.grey,
              surfaceTintColor: Get.theme.cardColor,
            ),

            // Container(
            //   height: 2,
            //   decoration: BoxDecoration(
            //     boxShadow: [
            //       BoxShadow(
            //         color: Colors.black.withOpacity(0.25),
            //         spreadRadius: 0,
            //         blurRadius: 1,
            //         offset: const Offset(0, 1),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
      // endDrawer: const MenuDrawerWidget(), endDrawerEnableOpenDragGesture: false,
      body: Get.find<AuthController>().isLoggedIn()
          ? SafeArea(
          child:
      Column(
          children: [

            Center(
              child: SizedBox(
                width: Dimensions.webMaxWidth,
                child: Align(
                  alignment: ResponsiveHelper.isDesktop(context)
                      ? Alignment.centerLeft
                      : Alignment.center,
                  child: Container(
                    height: 60,
                    width: ResponsiveHelper.isDesktop(context)
                        ? 350
                        : Dimensions.webMaxWidth,
                    color: ResponsiveHelper.isDesktop(context)
                        ? Colors.transparent
                        : Theme.of(context).cardColor,
                    child: TabBar(
                      physics: const NeverScrollableScrollPhysics(),
                      onTap: (int n){
                        setState(() {

                        });
                      },
                      controller: _tabController,
                      indicatorColor:Colors.transparent,
                      // indicatorWeight: 3,
                      labelColor: const Color(0xff090018
                      ),
                      unselectedLabelColor:
                      Theme.of(context).disabledColor,
                      unselectedLabelStyle: robotoRegular.copyWith(
                          color: Theme.of(context).disabledColor,
                          fontSize: Dimensions.fontSizeSmall),
                      labelStyle: robotoBold.copyWith(
                        fontWeight: FontWeight.w500,
                          fontSize: Dimensions.fontSizeSmall,
                          color: Theme.of(context).primaryColor),
                      tabs: [
                        Tab(
                          child: SizedBox(
                            height: 50,
                            child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.end,
                              children: [
                                _tabController?.index == 0
                                    ? const Icon(
                                    Icons.arrow_drop_down)
                                    : const SizedBox(),
                                Text(
                                  'food'.tr,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                      fontSize:
                                      Dimensions.fontSizeDefault),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Tab(
                          child: SizedBox(
                            height: 50,
                            child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.end,
                              children: [
                                _tabController?.index == 1
                                    ? const Icon(
                                    Icons.arrow_drop_down)
                                    : const SizedBox(),
                                Text(
                                  'restaurant'.tr,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize:
                                      Dimensions.fontSizeDefault),
                                ),
                              ],
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ),



        Expanded(child: TabBarView(physics: const NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: const [
            FavItemViewWidget(isRestaurant: false, isFav: true,),
            FavItemViewWidget(isRestaurant: true, isFav: false,),
          ],
        )),

      ]))
          : NotLoggedInScreen(callBack: (value){
        _initCall();
        setState(() {});
      }),
    );
  }
}

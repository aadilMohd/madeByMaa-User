import 'package:stackfood_multivendor/features/search/controllers/search_controller.dart' as search;
import 'package:stackfood_multivendor/features/search/widgets/item_view_widget.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchResultWidget extends StatefulWidget {
  final String searchText;
  const SearchResultWidget({super.key, required this.searchText});

  @override
  SearchResultWidgetState createState() => SearchResultWidgetState();
}

class SearchResultWidgetState extends State<SearchResultWidget> with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

      GetBuilder<search.SearchController>(builder: (searchController) {
        bool isNull = true;
        int length = 0;
        if(searchController.isRestaurant) {
          isNull = searchController.searchRestList == null;
          if(!isNull) {
            length = searchController.searchRestList!.length;
          }
        }else {
          isNull = searchController.searchProductList == null;
          if(!isNull) {
            length = searchController.searchProductList!.length;
          }
        }
        return isNull ? const SizedBox() : Center(child: SizedBox(width: Dimensions.webMaxWidth, child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: Row(children: [
            Text(
              length.toString(),
              style: robotoBold.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeSmall),
            ),
            const SizedBox(width: Dimensions.paddingSizeExtraSmall),
            Text(
              'results_found'.tr,
              style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
            ),
            const SizedBox(width: Dimensions.paddingSizeExtraSmall),

            Text(
              '"${widget.searchText}"',
              style: robotoBold.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: Dimensions.fontSizeSmall),
            ),
          ]),
        )));
      }),

      Center(child: Container(
        width: Dimensions.webMaxWidth,
        color: Theme.of(context).cardColor,
        child: Align(
          alignment: ResponsiveHelper.isDesktop(context) ? Alignment.centerLeft : Alignment.center,
          child: Container(
            width: ResponsiveHelper.isDesktop(context) ? 250 : Dimensions.webMaxWidth,
            color: ResponsiveHelper.isDesktop(context) ? Colors.transparent : Theme.of(context).cardColor,
            child: TabBar(
              controller: _tabController,
              indicatorColor:Colors.transparent,

              indicatorWeight: 0.1,
              labelColor: const Color(0xff090018),
              unselectedLabelColor: Theme.of(context).disabledColor,
              unselectedLabelStyle: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
              labelStyle: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
              tabs: [
                Tab(
                  child: SizedBox(
                    height: 80,
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.end,
                      children: [
                        _tabController!.index == 0
                            ? const Icon(
                            Icons.arrow_drop_down)
                            : const SizedBox(),
                        Text(
                          'food'.tr,
                          style: TextStyle(
                              fontSize:
                              Dimensions.fontSizeDefault),
                        ),
                      ],
                    ),
                  ),
                ),
                Tab(
                  child: SizedBox(
                    height: 80,
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.end,
                      children: [
                        _tabController!.index == 1
                            ? const Icon(
                            Icons.arrow_drop_down)
                            : const SizedBox(),
                        Text(
                          'restaurants'.tr,
                          style: TextStyle(
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
      )),


      Expanded(child: NotificationListener(
        onNotification: (dynamic scrollNotification) {
          if (scrollNotification is ScrollEndNotification) {
            Get.find<search.SearchController>().setRestaurant(_tabController!.index == 1);
            Get.find<search.SearchController>().searchData(widget.searchText);
          }
          return false;
        },
        child: TabBarView(
          controller: _tabController,
          children: const [
            ItemViewWidget(isRestaurant: false),
            ItemViewWidget(isRestaurant: true),
          ],
        ),
      )),

    ]);
  }
}

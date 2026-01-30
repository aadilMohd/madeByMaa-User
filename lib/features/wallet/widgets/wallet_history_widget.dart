import 'package:stackfood_multivendor/features/wallet/domain/models/wallet_filter_body_model.dart';
import 'package:stackfood_multivendor/features/wallet/controllers/wallet_controller.dart';
import 'package:stackfood_multivendor/features/wallet/widgets/history_cart_widget.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/no_data_screen_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class WalletHistoryWidget extends StatelessWidget {
  const WalletHistoryWidget({super.key});

  List<PopupMenuEntry> _generateFilteredMethod(
      BuildContext context,
      List<WalletFilterBodyModel>? walletFilterList,
      WalletController walletController) {
    List<PopupMenuEntry> entryList = [];
    for (int i = 0; i < walletFilterList!.length; i++) {
      entryList.add(PopupMenuItem<int>(
          value: i,
          child: Text(
            walletFilterList[i].title!.tr,
            style: robotoMedium.copyWith(
              color: walletFilterList[i].value == walletController.type
                  ? Theme.of(context).textTheme.bodyMedium!.color
                  : Theme.of(context).disabledColor,
            ),
          )));
    }
    return entryList;
  }

  String _setUpFilteredName(List<WalletFilterBodyModel>? walletFilterList,
      WalletController walletController) {
    String filterName = '';
    for (int i = 0; i < walletController.walletFilterList.length; i++) {
      if (walletController.walletFilterList[i].value == walletController.type) {
        filterName = walletController.walletFilterList[i].title!.tr;
      } else if (walletController.type == 'all') {
        filterName = '';
      }
    }
    return filterName;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WalletController>(builder: (walletController) {
      List<PopupMenuEntry> entryList = _generateFilteredMethod(
          context, walletController.walletFilterList, walletController);
      String filterName = _setUpFilteredName(
          walletController.walletFilterList, walletController);

      return Column(children: [
        Padding(
          padding: EdgeInsets.only(
              top: ResponsiveHelper.isDesktop(context)
                  ? Dimensions.paddingSizeExtraSmall
                  : Dimensions.paddingSizeExtraLarge),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                'wallet_history'.tr,
                style: robotoMedium.copyWith(
                    fontSize: Dimensions.fontSizeLarge,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff524A61)),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              Row(
                children: [
                  PopupMenuButton<dynamic>(
                    offset: const Offset(-20, 20),
                    itemBuilder: (BuildContext context) => entryList,
                    onSelected: (dynamic value) {
                      walletController.setWalletFilerType(
                          walletController.walletFilterList[value].value!);
                      walletController.getWalletTransactionList(
                          '1', false, walletController.type);
                    },
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(Dimensions.radiusDefault)),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      decoration: BoxDecoration(boxShadow:  [
                        BoxShadow(color: Colors.grey.withOpacity(0.5),blurStyle: BlurStyle.inner,offset: Offset(0, 3),blurRadius: 10,spreadRadius: 1)
                      ],
                          color: const Color(0xfff090018),
                          borderRadius:
                              BorderRadius.circular(Dimensions.radiusDefault)),
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.paddingSizeExtraSmall,
                              vertical: 2),
                          child: Image.asset(
                            Images.filter,
                            color: Theme.of(context).cardColor,
                            height: 16,
                          )),
                    ),
                  ),
                  SizedBox(width: Dimensions.paddingSizeSmall),
                  filterName.isEmpty
                      ? Container(
                          padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                          decoration: BoxDecoration(
                              color: Color(0xfff090018),
                              borderRadius: BorderRadius.circular(
                                  Dimensions.radiusDefault)),
                          child: Text(
                            "All Transactions",
                            style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                color: Theme.of(context).cardColor),
                          ),
                        )
                      : Container(
                          padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                          decoration: BoxDecoration(
                              color: Color(0xfff090018),
                              borderRadius: BorderRadius.circular(
                                  Dimensions.radiusDefault)),
                          child: Text(
                            filterName,
                            style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                color: Theme.of(context).cardColor),
                          ),
                        ),
                ],
              ),
            ]),
          ]),
        ),
        walletController.transactionList != null
            ? walletController.transactionList!.isNotEmpty
                ? GridView.builder(
                    key: UniqueKey(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 50,
                      mainAxisSpacing: ResponsiveHelper.isDesktop(context)
                          ? Dimensions.paddingSizeSmall
                          : 0.01,
                      childAspectRatio:
                          ResponsiveHelper.isDesktop(context) ? 7 : 4.45,
                      crossAxisCount:
                          ResponsiveHelper.isMobile(context) ? 1 : 1,
                    ),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: walletController.transactionList!.length,
                    padding: EdgeInsets.only(
                        top: ResponsiveHelper.isDesktop(context) ? 28 : 15),
                    itemBuilder: (context, index) {
                      return HistoryCartWidget(
                          index: index, data: walletController.transactionList);
                    },
                  )
                : NoDataScreen(
                    title: 'no_transaction_yet'.tr, isEmptyTransaction: true)
            : WalletShimmer(walletController: walletController),
        walletController.isLoading
            ? const Center(
                child: Padding(
                padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: CircularProgressIndicator(),
              ))
            : const SizedBox(),
      ]);
    });
  }
}

class WalletShimmer extends StatelessWidget {
  final WalletController walletController;

  const WalletShimmer({super.key, required this.walletController});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      key: UniqueKey(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 50,
        mainAxisSpacing: ResponsiveHelper.isDesktop(context)
            ? Dimensions.paddingSizeLarge
            : 0.01,
        childAspectRatio: ResponsiveHelper.isDesktop(context) ? 5 : 4.1,
        crossAxisCount: ResponsiveHelper.isMobile(context) ? 1 : 1,
      ),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 10,
      padding:
          EdgeInsets.only(top: ResponsiveHelper.isDesktop(context) ? 28 : 25),
      itemBuilder: (context, index) {
        return Padding(
          padding:
              const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
          child: Shimmer(
            duration: const Duration(seconds: 2),
            enabled: walletController.transactionList == null,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              height: 10,
                              width: 50,
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(2))),
                          const SizedBox(height: 10),
                          Container(
                              height: 10,
                              width: 70,
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(2))),
                        ]),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                              height: 10,
                              width: 50,
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(2))),
                          const SizedBox(height: 10),
                          Container(
                              height: 10,
                              width: 70,
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(2))),
                        ]),
                  ],
                ),
                Padding(
                    padding:
                        const EdgeInsets.only(top: Dimensions.paddingSizeLarge),
                    child: Divider(color: Theme.of(context).disabledColor)),
              ],
            ),
          ),
        );
      },
    );
  }
}

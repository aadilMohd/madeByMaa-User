import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:stackfood_multivendor/common/models/restaurant_model.dart';
import 'package:stackfood_multivendor/common/widgets/custom_favourite_widget.dart';

import 'package:stackfood_multivendor/common/widgets/discount_tag_without_image_widget.dart';
import 'package:stackfood_multivendor/common/widgets/quantity_button_widget.dart';
import 'package:stackfood_multivendor/common/widgets/rating_bar_widget.dart';
import 'package:stackfood_multivendor/corner_banner/rating_bar.dart';
import 'package:stackfood_multivendor/features/cart/controllers/cart_controller.dart';
import 'package:stackfood_multivendor/features/checkout/screens/checkout_screen.dart';
import 'package:stackfood_multivendor/features/restaurant/screens/restaurant_screen.dart';
import 'package:stackfood_multivendor/features/review/controllers/review_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/checkout/domain/models/place_order_body_model.dart';
import 'package:stackfood_multivendor/features/cart/domain/models/cart_model.dart';
import 'package:stackfood_multivendor/common/models/product_model.dart';
import 'package:stackfood_multivendor/features/favourite/controllers/favourite_controller.dart';
import 'package:stackfood_multivendor/features/product/controllers/product_controller.dart';
import 'package:stackfood_multivendor/helper/cart_helper.dart';
import 'package:stackfood_multivendor/helper/date_converter.dart';
import 'package:stackfood_multivendor/helper/price_converter.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/cart_snackbar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/confirmation_dialog_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../features/favourite/widgets/fav_item_view_widget.dart';
import '../../features/restaurant/controllers/restaurant_controller.dart';
import '../../features/restaurant/controllers/super_category_controller.dart';
import '../../features/review/domain/repositories/review_repository.dart';

class ProductBottomSheetWidget extends StatefulWidget {
  final Product? product;
  final bool isCampaign;
  final CartModel? cart;
  final int? cartIndex;
  final bool inRestaurantPage;

  const ProductBottomSheetWidget(
      {super.key,
      required this.product,
      this.isCampaign = false,
      this.cart,
      this.cartIndex,
      this.inRestaurantPage = false});

  @override
  State<ProductBottomSheetWidget> createState() =>
      _ProductBottomSheetWidgetState();
}

class _ProductBottomSheetWidgetState extends State<ProductBottomSheetWidget>
    with SingleTickerProviderStateMixin {
  JustTheController tooTipController = JustTheController();

  TabController? _tabController;

  List name = ["hello", "knknk", "nknknk", "knknk"];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Get.find<SuperCategoryController>().getSuperCategory();
    });

    Get.find<ProductController>().initData(widget.product, widget.cart);
    Get.find<ReviewController>()
        .getFoodReviewedList(widget.product!.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReviewController>(
      builder: (reviewController) {
        return Container(
          height: Get.height * 0.77,
          // height: 680,
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.black),
                  child: Center(
                    child: Icon(
                      Icons.close,
                      color: Get.theme.cardColor,
                    ),
                  ),
                ),
              ),
              Container(
                height: Get.height * 0.68,
                // height: Get.height/1.5+10,
                width: 550,
                margin: EdgeInsets.only(top: GetPlatform.isWeb ? 0 : 30),
                decoration: BoxDecoration(
                  color: const Color(0xffFBF8FF),
                  borderRadius: ResponsiveHelper.isMobile(context)
                      ? const BorderRadius.vertical(
                          top: Radius.circular(Dimensions.radiusExtraLarge))
                      : const BorderRadius.all(
                          Radius.circular(Dimensions.radiusExtraLarge)),
                ),
                child:
                    GetBuilder<ProductController>(builder: (productController) {
                  List<String> ingredients = widget.product!.ingredients == null
                      ? []
                      : widget.product!.ingredients!.split(',');
                  double price = widget.product!.price!;
                  double? discount = (widget.isCampaign ||
                          widget.product!.restaurantDiscount == 0)
                      ? widget.product!.discount
                      : widget.product!.restaurantDiscount;
                  String? discountType = (widget.isCampaign ||
                          widget.product!.restaurantDiscount == 0)
                      ? widget.product!.discountType
                      : 'percent';
                  double variationPrice =
                      _getVariationPrice(widget.product!, productController);
                  double variationPriceWithDiscount =
                      _getVariationPriceWithDiscount(widget.product!,
                          productController, discount, discountType);
                  double priceWithDiscountForView =
                      PriceConverter.convertWithDiscount(
                          price, discount, discountType)!;
                  double priceWithDiscount = PriceConverter.convertWithDiscount(
                      price, discount, discountType)!;

                  double addonsCost =
                      _getAddonCost(widget.product!, productController);
                  List<AddOn> addOnIdList =
                      _getAddonIdList(widget.product!, productController);
                  List<AddOns> addOnsList =
                      _getAddonList(widget.product!, productController);

                  debugPrint(
                      '===total : $addonsCost + (($variationPriceWithDiscount + $price) , $discount , $discountType ) * ${productController.quantity}');
                  double priceWithAddonsVariationWithDiscount = addonsCost +
                      (PriceConverter.convertWithDiscount(
                              variationPrice + price, discount, discountType)! *
                          productController.quantity!);
                  double priceWithAddonsVariation =
                      ((price + variationPrice) * productController.quantity!) +
                          addonsCost;
                  double priceWithVariation = price + variationPrice;
                  bool isAvailable = DateConverter.isAvailable(
                      widget.product!.availableTimeStarts,
                      widget.product!.availableTimeEnds);

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: ListView(children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Get.theme.cardColor,
                                borderRadius: BorderRadius.circular(
                                    Dimensions.radiusExtraLarge
                                    // bottomRight: Radius.circular(Dimensions.radiusDefault),
                                    // bottomLeft: Radius.circular(Dimensions.radiusDefault),

                                    )),
                            child: Column(
                              children: [
                                ///Product
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.radiusDefault),
                                      child: Image.asset(
                                        Images.foodBg,
                                        height: 250,
                                        width: Get.width,
                                        fit: BoxFit.cover,
                                      ),

                                      // CustomImageWidget(
                                      //   image: Image.asset(Images.foodBg),
                                      //   // image: '${widget.isCampaign ? Get.find<SplashController>().configModel!.baseUrls!.campaignImageUrl
                                      //   //     : Get.find<SplashController>().configModel!.baseUrls!.productImageUrl}/${widget.product!.image}',
                                      //   width: ResponsiveHelper.isMobile(context) ? Get.width : 140,
                                      //   height: ResponsiveHelper.isMobile(context) ? 216 : 140,
                                      //   fit: BoxFit.cover,
                                      // ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      left: 0,
                                      bottom: 0,
                                      top: 0,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                Dimensions.radiusSmall),
                                            child: CustomImageWidget(
                                              image:
                                                  '${widget.isCampaign ? Get.find<SplashController>().configModel!.baseUrls!.campaignImageUrl : Get.find<SplashController>().configModel!.baseUrls!.productImageUrl}/${widget.product!.image}',
                                              width: ResponsiveHelper.isMobile(
                                                      context)
                                                  ? Get.width
                                                  : 140,
                                              height: ResponsiveHelper.isMobile(
                                                      context)
                                                  ? 250
                                                  : 140,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),

                                Padding(
                                  padding: const EdgeInsets.all(
                                      Dimensions.paddingSizeDefault),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Image.asset(
                                                widget.product!.veg == 1
                                                    ? Images.vegImage
                                                    : Images.newNonVeg,
                                                height: 16,
                                                width: 16,
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color:
                                                        Get.theme.primaryColor),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      Dimensions
                                                          .paddingSizeExtraSmall),
                                                  child: Row(
                                                    children: [
                                                      widget.product!
                                                                  .instantorder ==
                                                              true
                                                          ? Image.asset(
                                                              "assets/image/thunder.png",
                                                              scale: 10,
                                                            )
                                                          : const SizedBox(),
                                                      SizedBox(
                                                        width: widget.product!
                                                                    .instantorder ==
                                                                true
                                                            ? 5
                                                            : 0,
                                                      ),
                                                      widget.product!
                                                                  .instantorder ==
                                                              true
                                                          ? const Text(
                                                              "Instant Delivery",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            )
                                                          : const Text(
                                                              "Pre Order",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          widget.product!.superCategories ==
                                                  null
                                              ? SizedBox()
                                              : Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      const Text(
                                                        "Available at",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.green,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 30,
                                                        child: ListView.builder(
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          reverse: true,
                                                          itemCount: widget
                                                              .product!
                                                              .superCategories!
                                                              .length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return Text(
                                                              "${widget.product!.superCategories![index].name}, ",
                                                              style: const TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .green),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: Dimensions.paddingSizeSmall,
                                      ),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: 250,
                                                    child: Text(
                                                        widget.product!.name ??
                                                            '',
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: robotoBold.copyWith(
                                                            fontSize: Dimensions
                                                                .fontSizeLarge,
                                                            color:
                                                                Colors.black)),
                                                  ),
                                                  Text(
                                                    "${widget.product!.maxDeliveryTime} min" ??
                                                        '',
                                                    style: robotoBold.copyWith(
                                                        color: const Color(
                                                            0xff524A61),
                                                        fontSize: Dimensions
                                                            .fontSizeSmall),
                                                  ),

                                                  // Row(
                                                  //   children: [
                                                  //     // Text(
                                                  //     //   widget.product!.name ?? '',
                                                  //     //   style: robotoBold.copyWith(
                                                  //     //       fontSize: Dimensions
                                                  //     //           .fontSizeLarge),
                                                  //     //   maxLines: 2,
                                                  //     //   overflow:
                                                  //     //       TextOverflow.ellipsis,
                                                  //     // ),
                                                  //     const SizedBox(width: Dimensions.paddingSizeSmall,),
                                                  //     Text(
                                                  //       widget.product!.maxDeliveryTime.toString()+" min" ?? '',
                                                  //       style: robotoBold.copyWith(color: const Color(0xff524A61),
                                                  //           fontSize: Dimensions
                                                  //               .fontSizeSmall),
                                                  //       maxLines: 2,
                                                  //       overflow:
                                                  //           TextOverflow.ellipsis,
                                                  //     ),
                                                  //   ],
                                                  // ),

                                                  InkWell(
                                                    onTap: () {
                                                      if (widget
                                                          .inRestaurantPage) {
                                                        Get.back();
                                                      } else {
                                                        Get.offNamed(RouteHelper
                                                            .getRestaurantRoute(
                                                                widget.product!
                                                                    .restaurantId));
                                                      }
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(0, 5, 5, 5),
                                                      child: Text(
                                                        widget.product!
                                                                .restaurantName ??
                                                            '',
                                                        style: robotoRegular.copyWith(
                                                            fontSize: Dimensions
                                                                .fontSizeSmall,
                                                            color: const Color(
                                                                0xff524A61)),
                                                      ),
                                                    ),
                                                  ),
                                                  RatingBar(
                                                      size: 14,
                                                      rating: widget
                                                          .product!.avgRating,
                                                      ratingCount: widget
                                                          .product!
                                                          .ratingCount),

                                                  // RatingBarWidget(
                                                  //
                                                  //     rating: widget
                                                  //         .product!.avgRating,
                                                  //     size: 15,
                                                  //     ratingCount: widget
                                                  //         .product!
                                                  //         .ratingCount),
                                                  const SizedBox(
                                                      height: Dimensions
                                                          .paddingSizeExtraSmall),

                                                  // Wrap(children: [
                                                  //   price > priceWithDiscountForView ? Text(
                                                  //     PriceConverter.convertPrice(price), textDirection: TextDirection.ltr,
                                                  //     style: robotoMedium.copyWith(color: Theme.of(context).disabledColor, decoration: TextDecoration.lineThrough),
                                                  //   ) : const SizedBox(),
                                                  //   const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                                  //
                                                  //   (widget.product!.image != null && widget.product!.image!.isNotEmpty)? const SizedBox.shrink()
                                                  //       : DiscountTagWithoutImageWidget(discount: discount, discountType: discountType),
                                                  //   //
                                                  //   // Text(
                                                  //   //   PriceConverter.convertPrice(priceWithDiscountForView),
                                                  //   //   textDirection: TextDirection.ltr,
                                                  //   //   style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                                                  //   // ),
                                                  //
                                                  // ]),
                                                ]),
                                            Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  widget.isCampaign
                                                      ? const SizedBox(
                                                          height: 25)
                                                      : GetBuilder<
                                                              FavouriteController>(
                                                          builder:
                                                              (favouriteController) {
                                                          return Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              // Container(
                                                              //   decoration: BoxDecoration(
                                                              //     borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                                              //     color: Theme.of(context).primaryColor.withOpacity(0.05),
                                                              //   ),
                                                              //   padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                                              //   margin: EdgeInsets.only(top: GetPlatform.isAndroid ? 0 : Dimensions.paddingSizeLarge),
                                                              //   child: CustomFavouriteWidget(
                                                              //     isWished: favouriteController.wishProductIdList.contains(widget.product!.id),
                                                              //     product: widget.product, isRestaurant: false,
                                                              //   ),
                                                              // ),
                                                              Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .baseline,
                                                                textBaseline:
                                                                    TextBaseline
                                                                        .alphabetic,
                                                                children: [
                                                                  Text(
                                                                    "₹",
                                                                    textDirection:
                                                                        TextDirection
                                                                            .ltr,
                                                                    style: robotoMedium.copyWith(
                                                                        fontSize:
                                                                            Dimensions
                                                                                .fontSizeSmall,
                                                                        color: const Color(
                                                                            0xffF55E1E)),
                                                                  ),
                                                                  Text(
                                                                    PriceConverter
                                                                        .convertPrice(
                                                                            priceWithDiscountForView),
                                                                    textDirection:
                                                                        TextDirection
                                                                            .ltr,
                                                                    style: robotoMedium.copyWith(
                                                                        fontSize:
                                                                            Dimensions
                                                                                .fontSizeOverLarge,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: const Color(
                                                                            0xffF55E1E)),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  widget.product!
                                                                              .discount ==
                                                                          0
                                                                      ? const SizedBox()
                                                                      : const Text(
                                                                          "₹"),
                                                                  Wrap(
                                                                      children: [
                                                                        price > priceWithDiscountForView
                                                                            ? Text(
                                                                                PriceConverter.convertPrice(price),
                                                                                textDirection: TextDirection.ltr,
                                                                                style: robotoMedium.copyWith(color: Theme.of(context).disabledColor, decoration: TextDecoration.lineThrough),
                                                                              )
                                                                            : const SizedBox(),
                                                                        const SizedBox(
                                                                            width:
                                                                                Dimensions.paddingSizeExtraSmall),
                                                                        (widget.product!.image != null &&
                                                                                widget.product!.image!.isNotEmpty)
                                                                            ? const SizedBox.shrink()
                                                                            : DiscountTagWithoutImageWidget(discount: discount, discountType: discountType),
                                                                      ]),
                                                                ],
                                                              ),
                                                            ],
                                                          );
                                                        }),

                                                  // SizedBox(height: widget.product!.isRestaurantHalalActive! && widget.product!.isHalalFood! ? 30 : 20),

                                                  // widget.product!.isRestaurantHalalActive! && widget.product!.isHalalFood! ? Padding(
                                                  //   padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                                  //   child: CustomToolTip(
                                                  //     message: 'this_is_a_halal_food'.tr,
                                                  //     preferredDirection: AxisDirection.up,
                                                  //     tooltipController: tooTipController,
                                                  //     child: Image.asset(Images.halalIcon, height: 35, width: 35),
                                                  //   ),
                                                  // ) : const SizedBox(),
                                                ]),
                                          ]),
                                      const Divider(),
                                      const SizedBox(
                                          height:
                                              Dimensions.paddingSizeDefault),
                                      (widget.product!.description != null &&
                                              widget.product!.description!
                                                  .isNotEmpty)
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text('About Food',
                                                          style: TextStyle(
                                                              color: const Color(
                                                                  0xff524A61),
                                                              fontSize: Dimensions
                                                                  .fontSizeSmall)),

                                                      // (Get.find<SplashController>().configModel!.toggleVegNonVeg!) ? Container(
                                                      //   padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall, horizontal: Dimensions.paddingSizeSmall),
                                                      //   decoration: BoxDecoration(
                                                      //     borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
                                                      //     color: Theme.of(context).cardColor,
                                                      //     boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 10, spreadRadius: 1)],
                                                      //   ),
                                                      //   child: Row(children: [
                                                      //     Image.asset(widget.product!.veg == 1 ? Images.vegLogo : Images.nonVegLogo, height: 20, width: 20),
                                                      //     const SizedBox(width: Dimensions.paddingSizeSmall),
                                                      //
                                                      //     Text(widget.product!.veg == 1 ? 'veg'.tr : 'non_veg'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault)),
                                                      //   ]),
                                                      // ) : const SizedBox(),
                                                    ]),
                                                const SizedBox(
                                                    height: Dimensions
                                                        .paddingSizeExtraSmall),
                                                Text(
                                                    widget.product!
                                                            .description ??
                                                        '',
                                                    style: TextStyle(
                                                        color: const Color(
                                                            0xff7E7E7E),
                                                        fontSize: Dimensions
                                                            .fontSizeSmall),
                                                    textAlign:
                                                        TextAlign.justify),
                                                const SizedBox(
                                                    height: Dimensions
                                                        .paddingSizeLarge),
                                              ],
                                            )
                                          : const SizedBox(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          /// Variation
                          widget.product!.variations != null
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: widget.product!.variations!.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  // padding: EdgeInsets.only(
                                  //     bottom: ( widget.product!.variations != null && widget.product!.variations!.isNotEmpty) ? Dimensions.paddingSizeLarge : 0,
                                  // left: ( widget.product!.variations != null && widget.product!.variations!.isNotEmpty) ? Dimensions.paddingSizeLarge : 12,
                                  //   right:  ( widget.product!.variations != null && widget.product!.variations!.isNotEmpty) ? Dimensions.paddingSizeLarge : 12
                                  //
                                  // ),

                                  itemBuilder: (context, index) {
                                    int selectedCount = 0;
                                    if (widget.product!.variations![index]
                                        .required!) {
                                      for (var value in productController
                                          .selectedVariations[index]) {
                                        if (value == true) {
                                          selectedCount++;
                                        }
                                      }
                                    }
                                    return Container(
                                      padding: const EdgeInsets.all(
                                          Dimensions.paddingSizeSmall),

                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            const BoxShadow(
                                                color: Colors.grey,
                                                blurStyle: BlurStyle.outer,
                                                spreadRadius: 2,
                                                blurRadius: 1)
                                          ],
                                          color: Get.theme.cardColor,
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.radiusDefault)),

                                      // padding: EdgeInsets.all(widget.product!.variations![index].required! ? (widget.product!.variations![index].multiSelect! ? widget.product!.variations![index].min! : 1) <= selectedCount
                                      //     ? Dimensions.paddingSizeSmall : Dimensions.paddingSizeSmall : 0),
                                      // margin: EdgeInsets.only(bottom: index != widget.product!.variations!.length - 1 ? Dimensions.paddingSizeDefault : 0),
                                      // decoration: BoxDecoration(
                                      //     color: widget.product!.variations![index].required! ? (widget.product!.variations![index].multiSelect! ? widget.product!.variations![index].min! : 1) <= selectedCount
                                      //         ? Theme.of(context).primaryColor.withOpacity(0.05) :Theme.of(context).disabledColor.withOpacity(0.05) : Get.theme.cardColor,
                                      //     border: Border.all(color: widget.product!.variations![index].required! ? (widget.product!.variations![index].multiSelect! ? widget.product!.variations![index].min! : 1) <= selectedCount
                                      //         ? Theme.of(context).primaryColor.withOpacity(0.3) : Theme.of(context).disabledColor.withOpacity(0.3) : Colors.transparent, width: 1),
                                      //     borderRadius: BorderRadius.circular(Dimensions.radiusDefault)
                                      // ),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                                // mainAxisAlignment:
                                                //     MainAxisAlignment
                                                //         .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                      widget
                                                          .product!
                                                          .variations![index]
                                                          .name!,
                                                      style: robotoBold.copyWith(
                                                          fontSize: Dimensions
                                                              .fontSizeLarge)),
                                                  Container(
                                                    // decoration: BoxDecoration(
                                                    //   color: widget
                                                    //           .product!
                                                    //           .variations![
                                                    //               index]
                                                    //           .required!
                                                    //       ? (widget
                                                    //                       .product!
                                                    //                       .variations![
                                                    //                           index]
                                                    //                       .multiSelect!
                                                    //                   ? widget
                                                    //                       .product!
                                                    //                       .variations![
                                                    //                           index]
                                                    //                       .min!
                                                    //                   : 1) >
                                                    //               selectedCount
                                                    //           ? Theme.of(
                                                    //                   context)
                                                    //               .colorScheme
                                                    //               .error
                                                    //               .withOpacity(
                                                    //                   0.1)
                                                    //           : Theme.of(
                                                    //                   context)
                                                    //               .primaryColor
                                                    //               .withOpacity(
                                                    //                   0.1)
                                                    //       : Theme.of(context)
                                                    //           .disabledColor
                                                    //           .withOpacity(0.2),
                                                    //   borderRadius:
                                                    //       BorderRadius.circular(
                                                    //           Dimensions
                                                    //               .radiusSmall),
                                                    // ),
                                                    padding: const EdgeInsets
                                                        .all(Dimensions
                                                            .paddingSizeExtraSmall),
                                                    child: Text(
                                                      '(${widget.product!.variations![index].required! ? (widget.product!.variations![index].multiSelect! ? widget.product!.variations![index].min! : 1) <= selectedCount ? 'completed'.tr : 'required'.tr : 'optional'.tr})',
                                                      style: robotoRegular
                                                          .copyWith(
                                                        color: widget
                                                                .product!
                                                                .variations![
                                                                    index]
                                                                .required!
                                                            ? (widget
                                                                            .product!
                                                                            .variations![
                                                                                index]
                                                                            .multiSelect!
                                                                        ? widget
                                                                            .product!
                                                                            .variations![
                                                                                index]
                                                                            .min!
                                                                        : 1) <=
                                                                    selectedCount
                                                                ? Theme.of(
                                                                        context)
                                                                    .primaryColor
                                                                : Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .error
                                                            : Theme.of(context)
                                                                .hintColor,
                                                        fontSize: Dimensions
                                                            .fontSizeSmall,
                                                      ),
                                                    ),
                                                  ),
                                                ]),
                                            const SizedBox(
                                                height: Dimensions
                                                    .paddingSizeExtraSmall),
                                            Row(children: [
                                              widget.product!.variations![index]
                                                      .multiSelect!
                                                  ? Text(
                                                      '${'select_minimum'.tr} ${'${widget.product!.variations![index].min}'
                                                          ' ${'and_up_to'.tr} ${widget.product!.variations![index].max} ${'options'.tr}'}',
                                                      style: robotoMedium.copyWith(
                                                          fontSize: Dimensions
                                                              .fontSizeExtraSmall,
                                                          color: Theme.of(
                                                                  context)
                                                              .disabledColor),
                                                    )
                                                  : Text(
                                                      'select_one'.tr,
                                                      style: robotoMedium.copyWith(
                                                          fontSize: Dimensions
                                                              .fontSizeExtraSmall,
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColor),
                                                    ),
                                            ]),
                                            SizedBox(
                                                height: widget
                                                        .product!
                                                        .variations![index]
                                                        .multiSelect!
                                                    ? Dimensions
                                                        .paddingSizeExtraSmall
                                                    : 0),
                                            ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              padding: EdgeInsets.zero,
                                              itemCount: productController
                                                      .collapseVariation[index]
                                                  ? widget
                                                              .product!
                                                              .variations![
                                                                  index]
                                                              .variationValues!
                                                              .length >
                                                          4
                                                      ? 5
                                                      : widget
                                                          .product!
                                                          .variations![index]
                                                          .variationValues!
                                                          .length
                                                  : widget
                                                      .product!
                                                      .variations![index]
                                                      .variationValues!
                                                      .length,
                                              itemBuilder: (context, i) {
                                                if (i == 4 &&
                                                    productController
                                                            .collapseVariation[
                                                        index]) {
                                                  return Padding(
                                                    padding: const EdgeInsets
                                                        .all(Dimensions
                                                            .paddingSizeExtraSmall),
                                                    child: InkWell(
                                                      onTap: () => productController
                                                          .showMoreSpecificSection(
                                                              index),
                                                      child: Row(children: [
                                                        Icon(Icons.expand_more,
                                                            size: 18,
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor),
                                                        const SizedBox(
                                                            width: Dimensions
                                                                .paddingSizeExtraSmall),
                                                        Text(
                                                          '${'view'.tr} ${widget.product!.variations![index].variationValues!.length - 4} ${'more_option'.tr}',
                                                          style: robotoMedium.copyWith(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor),
                                                        ),
                                                      ]),
                                                    ),
                                                  );
                                                } else {
                                                  return Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        vertical: ResponsiveHelper
                                                                .isDesktop(
                                                                    context)
                                                            ? Dimensions
                                                                .paddingSizeExtraSmall
                                                            : 0),
                                                    child: InkWell(
                                                      onTap: () {
                                                        productController
                                                            .setCartVariationIndex(
                                                                index,
                                                                i,
                                                                widget.product,
                                                                widget
                                                                    .product!
                                                                    .variations![
                                                                        index]
                                                                    .multiSelect!);
                                                        productController
                                                            .setExistInCartForBottomSheet(
                                                                widget.product!,
                                                                productController
                                                                    .selectedVariations);
                                                      },
                                                      child: Row(children: [
                                                        Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              widget
                                                                      .product!
                                                                      .variations![
                                                                          index]
                                                                      .multiSelect!
                                                                  ? Checkbox(
                                                                      value: productController
                                                                              .selectedVariations[
                                                                          index][i],
                                                                      activeColor:
                                                                          Theme.of(context)
                                                                              .primaryColor,
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(Dimensions.radiusSmall)),
                                                                      onChanged:
                                                                          (bool?
                                                                              newValue) {
                                                                        productController.setCartVariationIndex(
                                                                            index,
                                                                            i,
                                                                            widget.product,
                                                                            widget.product!.variations![index].multiSelect!);
                                                                        productController.setExistInCartForBottomSheet(
                                                                            widget.product!,
                                                                            productController.selectedVariations);
                                                                      },
                                                                      visualDensity: const VisualDensity(
                                                                          horizontal:
                                                                              -3,
                                                                          vertical:
                                                                              -3),
                                                                      side: BorderSide(
                                                                          width:
                                                                              2,
                                                                          color:
                                                                              Theme.of(context).hintColor),
                                                                    )
                                                                  : Radio(
                                                                      value: i,
                                                                      groupValue: productController
                                                                          .selectedVariations[
                                                                              index]
                                                                          .indexOf(
                                                                              true),
                                                                      onChanged:
                                                                          (dynamic
                                                                              value) {
                                                                        productController.setCartVariationIndex(
                                                                            index,
                                                                            i,
                                                                            widget.product,
                                                                            widget.product!.variations![index].multiSelect!);
                                                                        productController.setExistInCartForBottomSheet(
                                                                            widget.product!,
                                                                            productController.selectedVariations);
                                                                      },
                                                                      activeColor:
                                                                          Theme.of(context)
                                                                              .primaryColor,
                                                                      toggleable:
                                                                          false,
                                                                      visualDensity: const VisualDensity(
                                                                          horizontal:
                                                                              -3,
                                                                          vertical:
                                                                              -3),
                                                                    ),
                                                              Text(
                                                                widget
                                                                    .product!
                                                                    .variations![
                                                                        index]
                                                                    .variationValues![
                                                                        i]
                                                                    .level!
                                                                    .trim(),
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: productController
                                                                            .selectedVariations[index]
                                                                        [i]!
                                                                    ? robotoMedium
                                                                    : robotoRegular
                                                                        .copyWith(
                                                                            color:
                                                                                Theme.of(context).hintColor),
                                                              ),
                                                            ]),
                                                        const Spacer(),
                                                        (price > priceWithDiscount) &&
                                                                (discountType ==
                                                                    'percent')
                                                            ? Text(
                                                                PriceConverter.convertPrice(widget
                                                                    .product!
                                                                    .variations![
                                                                        index]
                                                                    .variationValues![
                                                                        i]
                                                                    .optionPrice),
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                textDirection:
                                                                    TextDirection
                                                                        .ltr,
                                                                style: robotoRegular.copyWith(
                                                                    fontSize:
                                                                        Dimensions
                                                                            .fontSizeExtraSmall,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .disabledColor,
                                                                    decoration:
                                                                        TextDecoration
                                                                            .lineThrough),
                                                              )
                                                            : const SizedBox(),
                                                        SizedBox(
                                                            width: price >
                                                                    priceWithDiscount
                                                                ? Dimensions
                                                                    .paddingSizeExtraSmall
                                                                : 0),
                                                        Text(
                                                          '+${PriceConverter.convertPrice(widget.product!.variations![index].variationValues![i].optionPrice, discount: discount, discountType: discountType, isVariation: true)}',
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textDirection:
                                                              TextDirection.ltr,
                                                          style: productController
                                                                      .selectedVariations[
                                                                  index][i]!
                                                              ? robotoMedium.copyWith(
                                                                  fontSize: Dimensions
                                                                      .fontSizeExtraSmall)
                                                              : robotoRegular.copyWith(
                                                                  fontSize:
                                                                      Dimensions
                                                                          .fontSizeExtraSmall,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .disabledColor),
                                                        )
                                                      ]),
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                          ]),
                                    );
                                  },
                                )
                              : const SizedBox(),

                          SizedBox(
                              height: (widget.product!.variations != null &&
                                      widget.product!.variations!.isNotEmpty)
                                  ? 20
                                  : 0),

                          widget.product!.addOns!.isNotEmpty
                              ? Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        const BoxShadow(
                                            color: Colors.grey,
                                            blurStyle: BlurStyle.outer,
                                            spreadRadius: 2,
                                            blurRadius: 1)
                                      ],
                                      color: Get.theme.cardColor,
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.radiusDefault)),
                                  // margin: const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeSmall),

                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: Dimensions
                                                  .paddingSizeExtraSmall),
                                          child: Row(children: [
                                            Text('addons'.tr,
                                                style: robotoBold.copyWith(
                                                    color:
                                                        const Color(0xff524A61),
                                                    fontSize: Dimensions
                                                        .fontSizeLarge)),
                                            Text(
                                              "(${'optional'.tr})",
                                              style: robotoRegular.copyWith(
                                                  color: Theme.of(context)
                                                      .hintColor,
                                                  fontSize:
                                                      Dimensions.fontSizeSmall),
                                            ),
                                          ]),
                                        ),
                                        const SizedBox(
                                            height: Dimensions
                                                .paddingSizeExtraSmall),
                                        ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          padding: EdgeInsets.zero,
                                          itemCount:
                                              widget.product!.addOns!.length,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              onTap: () {
                                                if (!productController
                                                    .addOnActiveList[index]) {
                                                  productController.addAddOn(
                                                      true, index);
                                                } else if (productController
                                                        .addOnQtyList[index] ==
                                                    1) {
                                                  productController.addAddOn(
                                                      false, index);
                                                }
                                              },
                                              child: Row(children: [
                                                Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Checkbox(
                                                        value: productController
                                                                .addOnActiveList[
                                                            index],
                                                        activeColor:
                                                            Theme.of(context)
                                                                .primaryColor,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    Dimensions
                                                                        .radiusSmall)),
                                                        onChanged:
                                                            (bool? newValue) {
                                                          if (!productController
                                                                  .addOnActiveList[
                                                              index]) {
                                                            productController
                                                                .addAddOn(true,
                                                                    index);
                                                          } else if (productController
                                                                      .addOnQtyList[
                                                                  index] ==
                                                              1) {
                                                            productController
                                                                .addAddOn(false,
                                                                    index);
                                                          }
                                                        },
                                                        visualDensity:
                                                            const VisualDensity(
                                                                horizontal: -3,
                                                                vertical: -3),
                                                        side: BorderSide(
                                                            width: 2,
                                                            color: Theme.of(
                                                                    context)
                                                                .hintColor),
                                                      ),
                                                      Text(
                                                        widget
                                                            .product!
                                                            .addOns![index]
                                                            .name!,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: productController
                                                                    .addOnActiveList[
                                                                index]
                                                            ? robotoMedium
                                                            : robotoRegular.copyWith(
                                                                color: Theme.of(
                                                                        context)
                                                                    .hintColor),
                                                      ),
                                                    ]),
                                                const Spacer(),
                                                Text(
                                                  widget.product!.addOns![index]
                                                              .price! >
                                                          0
                                                      ? PriceConverter
                                                          .convertPrice(widget
                                                              .product!
                                                              .addOns![index]
                                                              .price)
                                                      : 'free'.tr,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textDirection:
                                                      TextDirection.ltr,
                                                  style: productController
                                                              .addOnActiveList[
                                                          index]
                                                      ? robotoMedium.copyWith(
                                                          fontSize: Dimensions
                                                              .fontSizeSmall)
                                                      : robotoRegular.copyWith(
                                                          fontSize: Dimensions
                                                              .fontSizeSmall,
                                                          color: Theme.of(
                                                                  context)
                                                              .disabledColor),
                                                ),
                                                productController
                                                        .addOnActiveList[index]
                                                    ? Container(
                                                        height: 25,
                                                        width: 90,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    Dimensions
                                                                        .radiusSmall),
                                                            color: Theme.of(
                                                                    context)
                                                                .cardColor),
                                                        child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Expanded(
                                                                child: InkWell(
                                                                  onTap: () {
                                                                    if (productController
                                                                            .addOnQtyList[index]! >
                                                                        1) {
                                                                      productController.setAddOnQuantity(
                                                                          false,
                                                                          index);
                                                                    } else {
                                                                      productController.addAddOn(
                                                                          false,
                                                                          index);
                                                                    }
                                                                  },
                                                                  child: Center(
                                                                      child:
                                                                          Icon(
                                                                    (productController.addOnQtyList[
                                                                                index]! >
                                                                            1)
                                                                        ? Icons
                                                                            .remove
                                                                        : CupertinoIcons
                                                                            .delete,
                                                                    size: 18,
                                                                    color: (productController.addOnQtyList[index]! >
                                                                            1)
                                                                        ? Theme.of(context)
                                                                            .primaryColor
                                                                        : Theme.of(context)
                                                                            .colorScheme
                                                                            .error,
                                                                  )),
                                                                ),
                                                              ),
                                                              Text(
                                                                productController
                                                                    .addOnQtyList[
                                                                        index]
                                                                    .toString(),
                                                                style: robotoMedium
                                                                    .copyWith(
                                                                        fontSize:
                                                                            Dimensions.fontSizeDefault),
                                                              ),
                                                              Expanded(
                                                                child: InkWell(
                                                                  onTap: () => productController
                                                                      .setAddOnQuantity(
                                                                          true,
                                                                          index),
                                                                  child: Center(
                                                                      child: Icon(
                                                                          Icons
                                                                              .add,
                                                                          size:
                                                                              18,
                                                                          color:
                                                                              Theme.of(context).primaryColor)),
                                                                ),
                                                              ),
                                                            ]),
                                                      )
                                                    : const SizedBox(),
                                              ]),
                                            );
                                          },
                                        ),
                                        const SizedBox(
                                            height: Dimensions
                                                .paddingSizeExtraSmall),
                                      ],
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                          SizedBox(
                              height: (widget.product!.variations != null &&
                                      widget.product!.variations!.isNotEmpty)
                                  ? 20
                                  : 0),

                          TabBar(
                              onTap: (int n) {
                                setState(() {});
                              },
                              indicatorColor: const Color(0xff090018),
//tabAlignment: TabAlignment.fill,
                              // padding: const EdgeInsets.symmetric(horizontal: 20),
                              labelPadding:
                                  const EdgeInsets.symmetric(horizontal: 50),
                              dividerColor: Get.theme.hintColor,
                              unselectedLabelColor: Get.theme.hintColor,
                              // isScrollable: true,
                              labelColor: const Color(0xff090018),
                              indicatorSize: TabBarIndicatorSize.tab,
                              automaticIndicatorColorAdjustment: true,
                              indicator: const UnderlineTabIndicator(
                                  borderSide: BorderSide(
                                      color: Color(0xff090018), width: 2),
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(
                                          Dimensions.radiusSmall),
                                      topLeft: Radius.circular(
                                          Dimensions.radiusSmall)),
                                  insets: EdgeInsets.symmetric(
                                    // horizontal: 50,
                                    vertical: 1,
                                  )),
                              //automaticIndicatorColorAdjustment: false,
                              physics: const AlwaysScrollableScrollPhysics(),
                              controller: _tabController,
                              // Use custom controller

                              tabs: [
                                Tab(
                                  child: Center(
                                    child: Row(
                                      children: [
                                        Text(
                                          "Reviews",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize:
                                                  Dimensions.fontSizeDefault),
                                        ),
                                        reviewController.foodReviewList == null
                                            ? const SizedBox()
                                            : Text(
                                                " (${reviewController.foodReviewList!.length})",
                                                style: TextStyle(
                                                    color: Get.theme.hintColor),
                                              )
                                      ],
                                    ),
                                  ),
                                ),
                                Tab(
                                  child: Center(
                                    child: Text(
                                      "Ingredients",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: Dimensions.fontSizeDefault),
                                    ),
                                  ),
                                )
                              ]),

                          SizedBox(
                            height: 500,
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                (reviewController.foodReviewList == null ||
                                        reviewController
                                            .foodReviewList!.isEmpty)
                                    ? const SizedBox()
                                    : ListView.builder(
                                        itemCount: reviewController
                                            .foodReviewList!.length,
                                        itemBuilder: (context, index) {
                                          return Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              //  '${Get.find<SplashController>().configModel!.baseUrls!.customerImageUrl}'
                                              CircleAvatar(
                                                radius: 35,
                                                backgroundImage: NetworkImage(
                                                    "${Get.find<SplashController>().configModel!.baseUrls!.customerImageUrl}/${reviewController.foodReviewList![index].customer!.image.toString()}"),
                                              ),
                                              const SizedBox(
                                                width: Dimensions
                                                    .paddingSizeDefault,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      reviewController
                                                          .foodReviewList![
                                                              index]
                                                          .customer!
                                                          .fName
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                    const SizedBox(
                                                      height: Dimensions
                                                          .paddingSizeSmall,
                                                    ),
                                                    RatingBar(
                                                      rating: reviewController
                                                          .foodReviewList![
                                                              index]
                                                          .rating!
                                                          .toDouble(),
                                                      ratingCount:
                                                          reviewController
                                                              .foodReviewList![
                                                                  index]
                                                              .rating,
                                                      size: 15,
                                                    ),
                                                    const SizedBox(
                                                      height: Dimensions
                                                          .paddingSizeSmall,
                                                    ),
                                                    reviewController
                                                                .foodReviewList![
                                                                    index]
                                                                .createdAt ==
                                                            null
                                                        ? const SizedBox()
                                                        : Text(
                                                            reviewController
                                                                .foodReviewList![
                                                                    index]
                                                                .createdAt,
                                                            style: TextStyle(
                                                                fontSize: Dimensions
                                                                    .fontSizeSmall,
                                                                color: const Color(
                                                                    0xffA7A7A7)),
                                                          ),
                                                    const SizedBox(
                                                      height: Dimensions
                                                          .paddingSizeSmall,
                                                    ),
                                                    Text(
                                                      reviewController
                                                          .foodReviewList![
                                                              index]
                                                          .comment!,
                                                      style: const TextStyle(
                                                          color: Color(
                                                              0xff7E7E7E)),
                                                    ),
                                                    const Divider()
                                                  ],
                                                ),
                                              )
                                            ],
                                          );
                                        },
                                        physics: const ScrollPhysics(),
                                        padding: const EdgeInsets.all(
                                            Dimensions.paddingSizeDefault),
                                      ),
                                (ingredients == null && ingredients.isEmpty)
                                    ? const Center(
                                        child: Text("Not Found"),
                                      )
                                    : GridView.builder(
                                        itemCount: ingredients.length,
                                        itemBuilder: (context, index) {
                                          return Text(
                                              "${index + 1}.${ingredients[index]}");
                                        },
                                        physics: const ScrollPhysics(),
                                        padding: const EdgeInsets.all(
                                            Dimensions.paddingSizeDefault),
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                childAspectRatio: 6),
                                      )
                              ],
                            ),
                          ),
                        ]),
                      ),

                      ///Bottom side..
                      Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(
                                    ResponsiveHelper.isDesktop(context)
                                        ? Dimensions.radiusExtraLarge
                                        : 0)),
                            boxShadow: ResponsiveHelper.isDesktop(context)
                                ? null
                                : [
                                    BoxShadow(
                                        color: Colors.grey[300]!,
                                        blurRadius: 10)
                                  ]),
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeDefault,
                            vertical: Dimensions.paddingSizeDefault),
                        child: SafeArea(
                          child: Column(
                            children: [
                              // Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              //   Text('${'total_amount'.tr}:', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor)),
                              //   const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                              //
                              //   Row(children: [
                              //     (priceWithAddonsVariation > priceWithAddonsVariationWithDiscount) ?
                              //     PriceConverter.convertAnimationPrice(
                              //       priceWithAddonsVariation,
                              //       textStyle: robotoMedium.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall, decoration: TextDecoration.lineThrough),
                              //     ) : const SizedBox(),
                              //     const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                              //
                              //     PriceConverter.convertAnimationPrice(
                              //       priceWithAddonsVariationWithDiscount,
                              //       textStyle: robotoBold.copyWith(color: Theme.of(context).primaryColor),
                              //     ),
                              //
                              //   ]),
                              // ]),
                              // const SizedBox(height: Dimensions.paddingSizeSmall),

                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: Dimensions.paddingSizeSmall,
                                        horizontal:
                                            Dimensions.paddingSizeDefault),
                                    decoration: BoxDecoration(
                                        color: Get.theme.primaryColor
                                            .withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(
                                          Dimensions.radiusDefault,
                                        ),
                                        border: Border.all(
                                            color: Get.theme.primaryColor)),
                                    child: Row(children: [
                                      QuantityButton(
                                        onTap: () {
                                          if (productController.quantity! > 1) {
                                            productController.setQuantity(false,
                                                widget.product!.quantityLimit);
                                          }
                                        },
                                        isIncrement: false,
                                      ),
                                      const SizedBox(
                                        width: Dimensions.paddingSizeSmall,
                                      ),

                                      AnimatedFlipCounter(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        value: productController.quantity!
                                            .toDouble(),
                                        textStyle: robotoMedium.copyWith(
                                            fontSize: Dimensions.fontSizeLarge),
                                      ),
                                      const SizedBox(
                                        width: Dimensions.paddingSizeSmall,
                                      ),

                                      // Text(productController.quantity.toString(), style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
                                      QuantityButton(
                                        onTap: () =>
                                            productController.setQuantity(true,
                                                widget.product!.quantityLimit),
                                        isIncrement: true,
                                      ),
                                    ]),
                                  ),
                                  const SizedBox(
                                      width: Dimensions.paddingSizeSmall),
                                  Expanded(
                                    child: GetBuilder<CartController>(
                                        builder: (cartController) {
                                      return CustomButtonWidget(
                                        radius: Dimensions.paddingSizeDefault,
                                        width:
                                            ResponsiveHelper.isDesktop(context)
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2.0
                                                : null,
                                        isLoading: cartController.isLoading,
                                        buttonText: (!widget
                                                    .product!.scheduleOrder! &&
                                                !isAvailable)
                                            ? 'not_available_now'.tr
                                            : widget.isCampaign
                                                ? 'order_now'.tr
                                                : (widget.cart != null ||
                                                        productController
                                                                .cartIndex !=
                                                            -1)
                                                    ? 'update_in_cart'.tr
                                                    : ("${'add_to_cart'.tr}     ₹ $priceWithAddonsVariationWithDiscount"),
                                        onPressed:
                                            (!widget.product!.scheduleOrder! &&
                                                    !isAvailable)
                                                ? null
                                                : () async {
                                                    _onButtonPressed(
                                                        productController,
                                                        cartController,
                                                        priceWithVariation,
                                                        priceWithDiscount,
                                                        price,
                                                        discount,
                                                        discountType,
                                                        addOnIdList,
                                                        addOnsList,
                                                        priceWithAddonsVariation);
                                                  },
                                      );
                                    }),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onButtonPressed(
    ProductController productController,
    CartController cartController,
    double priceWithVariation,
    double priceWithDiscount,
    double price,
    double? discount,
    String? discountType,
    List<AddOn> addOnIdList,
    List<AddOns> addOnsList,
    double priceWithAddonsVariation,
  ) async {
    _processVariationWarning(productController);

    if (productController.canAddToCartProduct) {
      CartModel cartModel = CartModel(
          null,
          priceWithVariation,
          priceWithDiscount,
          (price -
              PriceConverter.convertWithDiscount(
                  price, discount, discountType)!),
          productController.quantity,
          addOnIdList,
          addOnsList,
          widget.isCampaign,
          widget.product,
          productController.selectedVariations,
          widget.product!.quantityLimit,
          false);

      OnlineCart onlineCart = await _processOnlineCart(productController,
          cartController, addOnIdList, addOnsList, priceWithAddonsVariation);

      debugPrint('-------checkout cart body : ${onlineCart.toJson()}');
      debugPrint('-------checkout cart : ${cartModel.toJson()}');

      if (widget.isCampaign) {
        Get.back();
        Get.toNamed(RouteHelper.getCheckoutRoute('campaign'),
            arguments: CheckoutScreen(
              fromCart: false,
              cartList: [cartModel],
            ));
      } else {
        await _executeActions(
            cartController, productController, cartModel, onlineCart);
      }
    }
  }

  void _processVariationWarning(ProductController productController) {
    if (widget.product!.variations != null) {
      for (int index = 0; index < widget.product!.variations!.length; index++) {
        if (!widget.product!.variations![index].multiSelect! &&
            widget.product!.variations![index].required! &&
            !productController.selectedVariations[index].contains(true)) {
          _showUpperCartSnackBar(
              '${'choose_a_variation_from'.tr} ${widget.product!.variations![index].name}');
          productController.changeCanAddToCartProduct(false);
          return;
        } else if (widget.product!.variations![index].multiSelect! &&
            (widget.product!.variations![index].required! ||
                productController.selectedVariations[index].contains(true)) &&
            widget.product!.variations![index].min! >
                productController.selectedVariationLength(
                    productController.selectedVariations, index)) {
          _showUpperCartSnackBar(
              '${'you_need_to_select_minimum'.tr} ${widget.product!.variations![index].min} '
              '${'to_maximum'.tr} ${widget.product!.variations![index].max} ${'options_from'.tr} ${widget.product!.variations![index].name} ${'variation'.tr}');
          productController.changeCanAddToCartProduct(false);
          return;
        } else {
          productController.changeCanAddToCartProduct(true);
        }
      }
    }
  }

  void _showUpperCartSnackBar(String message) {
    Get.showSnackbar(GetSnackBar(
      backgroundColor: Colors.red,
      message: message,
      duration: const Duration(seconds: 3),
      maxWidth: Dimensions.webMaxWidth,
      snackStyle: SnackStyle.FLOATING,
      margin: const EdgeInsets.only(
          left: Dimensions.paddingSizeSmall,
          right: Dimensions.paddingSizeSmall,
          bottom: 100),
      borderRadius: 10,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
    ));
  }

  Future<OnlineCart> _processOnlineCart(
      ProductController productController,
      CartController cartController,
      List<AddOn> addOnIdList,
      List<AddOns> addOnsList,
      double priceWithAddonsVariation) async {
    List<OrderVariation> variations = CartHelper.getSelectedVariations(
      productVariations: widget.product!.variations,
      selectedVariations: productController.selectedVariations,
    );
    List<int?> listOfAddOnId =
        CartHelper.getSelectedAddonIds(addOnIdList: addOnIdList);
    List<int?> listOfAddOnQty =
        CartHelper.getSelectedAddonQtnList(addOnIdList: addOnIdList);

    OnlineCart onlineCart = OnlineCart(
        (widget.cart != null || productController.cartIndex != -1)
            ? widget.cart?.id ??
                cartController.cartList[productController.cartIndex].id
            : null,
        widget.isCampaign ? null : widget.product!.id,
        widget.isCampaign ? widget.product!.id : null,
        priceWithAddonsVariation.toString(),
        variations,
        productController.quantity,
        listOfAddOnId,
        addOnsList,
        listOfAddOnQty,
        'Food');
    return onlineCart;
  }

  Future<void> _executeActions(
      CartController cartController,
      ProductController productController,
      CartModel cartModel,
      OnlineCart onlineCart) async {
    if (cartController
        .existAnotherRestaurantProduct(cartModel.product!.restaurantId)) {
      Get.dialog(
          ConfirmationDialogWidget(
            icon: Images.warning,
            title: 'are_you_sure_to_reset'.tr,
            description: 'if_you_continue'.tr,
            onYesPressed: () {
              Get.back();
              cartController.clearCartOnline().then((success) async {
                if (success) {
                  await cartController.addToCartOnline(onlineCart);
                  Get.back();
                  showCartSnackBarWidget();
                }
              });
            },
          ),
          barrierDismissible: false);
    } else {
      if (widget.cart != null || productController.cartIndex != -1) {
        await cartController.updateCartOnline(onlineCart);
      } else {
        await cartController.addToCartOnline(onlineCart);
      }
      Get.back();
      showCartSnackBarWidget();
    }
  }

  double _getVariationPriceWithDiscount(
      Product product,
      ProductController productController,
      double? discount,
      String? discountType) {
    double variationPrice = 0;
    if (product.variations != null) {
      for (int index = 0; index < product.variations!.length; index++) {
        for (int i = 0;
            i < product.variations![index].variationValues!.length;
            i++) {
          if (productController.selectedVariations[index].isNotEmpty &&
              productController.selectedVariations[index][i]!) {
            variationPrice += PriceConverter.convertWithDiscount(
                product.variations![index].variationValues![i].optionPrice!,
                discount,
                discountType)!;
          }
        }
      }
    }
    return variationPrice;
  }

  double _getVariationPrice(
      Product product, ProductController productController) {
    double variationPrice = 0;
    if (product.variations != null) {
      for (int index = 0; index < product.variations!.length; index++) {
        for (int i = 0;
            i < product.variations![index].variationValues!.length;
            i++) {
          if (productController.selectedVariations[index].isNotEmpty &&
              productController.selectedVariations[index][i]!) {
            variationPrice += PriceConverter.convertWithDiscount(
                product.variations![index].variationValues![i].optionPrice!,
                0,
                'none')!;
          }
        }
      }
    }
    return variationPrice;
  }

  double _getAddonCost(Product product, ProductController productController) {
    double addonsCost = 0;

    for (int index = 0; index < product.addOns!.length; index++) {
      if (productController.addOnActiveList[index]) {
        addonsCost = addonsCost +
            (product.addOns![index].price! *
                productController.addOnQtyList[index]!);
      }
    }

    return addonsCost;
  }

  List<AddOn> _getAddonIdList(
      Product product, ProductController productController) {
    List<AddOn> addOnIdList = [];
    for (int index = 0; index < product.addOns!.length; index++) {
      if (productController.addOnActiveList[index]) {
        addOnIdList.add(AddOn(
            id: product.addOns![index].id,
            quantity: productController.addOnQtyList[index]));
      }
    }

    return addOnIdList;
  }

  List<AddOns> _getAddonList(
      Product product, ProductController productController) {
    List<AddOns> addOnsList = [];
    for (int index = 0; index < product.addOns!.length; index++) {
      if (productController.addOnActiveList[index]) {
        addOnsList.add(product.addOns![index]);
      }
    }

    return addOnsList;
  }
}

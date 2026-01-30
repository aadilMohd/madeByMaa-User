import 'package:stackfood_multivendor/common/widgets/custom_asset_image_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_favourite_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_ink_well_widget.dart';
import 'package:stackfood_multivendor/common/widgets/not_available_widget.dart';
import 'package:stackfood_multivendor/common/widgets/product_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor/features/cart/controllers/cart_controller.dart';
import 'package:stackfood_multivendor/features/home/widgets/overflow_container_widget.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/cart/domain/models/cart_model.dart';
import 'package:stackfood_multivendor/features/splash/domain/models/config_model.dart';
import 'package:stackfood_multivendor/common/models/product_model.dart';
import 'package:stackfood_multivendor/common/models/restaurant_model.dart';
import 'package:stackfood_multivendor/features/favourite/controllers/favourite_controller.dart';
import 'package:stackfood_multivendor/features/product/controllers/product_controller.dart';
import 'package:stackfood_multivendor/helper/date_converter.dart';
import 'package:stackfood_multivendor/helper/price_converter.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/discount_tag_widget.dart';
import 'package:stackfood_multivendor/common/widgets/discount_tag_without_image_widget.dart';
import 'package:stackfood_multivendor/features/restaurant/screens/restaurant_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../corner_banner/banner.dart';
import '../../corner_banner/corner_discount_tag.dart';
import '../../corner_banner/rating_bar.dart';
import '../../features/auth/controllers/auth_controller.dart';
import '../../features/home/widgets/restaurants_view_widget.dart';
import '../../features/language/controllers/localization_controller.dart';

class ProductWidget extends StatelessWidget {
  final Product? product;
  final Restaurant? restaurant;
  final bool isRestaurant;
  final int index;
  final int? length;
  final bool inRestaurant;
  final bool isCampaign;
  final bool fromCartSuggestion;

  const ProductWidget(
      {super.key,
      required this.product,
      required this.isRestaurant,
      required this.restaurant,
      required this.index,
      required this.length,
      this.inRestaurant = false,
      this.isCampaign = false,
      this.fromCartSuggestion = false});

  @override
  Widget build(BuildContext context) {
    BaseUrls? baseUrls = Get.find<SplashController>().configModel!.baseUrls;
    bool desktop = ResponsiveHelper.isDesktop(context);
    double? discount;
    String? discountType;
    bool isAvailable;
    String? image;
    double price = 0;
    double discountPrice = 0;
    if (isRestaurant) {
      image = restaurant!.logo;
      discount =
          restaurant!.discount != null ? restaurant!.discount!.discount : 0;
      discountType = restaurant!.discount != null
          ? restaurant!.discount!.discountType
          : 'percent';
      // bool _isClosedToday = Get.find<RestaurantController>().isRestaurantClosed(true, restaurant.active, restaurant.offDay);
      // _isAvailable = DateConverter.isAvailable(restaurant.openingTime, restaurant.closeingTime) && restaurant.active && !_isClosedToday;
      isAvailable = restaurant!.open == 1 && restaurant!.active!;
    } else {
      image = product!.image;
      discount = (product!.restaurantDiscount == 0 || isCampaign)
          ? product!.discount
          : product!.restaurantDiscount;
      discountType = (product!.restaurantDiscount == 0 || isCampaign)
          ? product!.discountType
          : 'percent';
      isAvailable = DateConverter.isAvailable(
          product!.availableTimeStarts, product!.availableTimeEnds);
      price = product!.price!;
      discountPrice =
          PriceConverter.convertWithDiscount(price, discount, discountType)!;
    }

    return Padding(
      padding:
          EdgeInsets.only(bottom: desktop ? 0 : Dimensions.paddingSizeSmall),
      child: Container(
        margin: desktop
            ? null
            : const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 1))
          ],
        ),
        child: CustomInkWellWidget(
          onTap: () {
            if (isRestaurant) {
              if (restaurant != null && restaurant!.restaurantStatus == 1) {
                Get.toNamed(RouteHelper.getRestaurantRoute(restaurant!.id),
                    arguments: RestaurantScreen(restaurant: restaurant));
              } else if (restaurant!.restaurantStatus == 0) {
                showCustomSnackBar('restaurant_is_not_available'.tr);
              }
            } else {
              if (product!.restaurantStatus == 1) {
                ResponsiveHelper.isMobile(context)
                    ? Get.bottomSheet(
                        ProductBottomSheetWidget(
                            product: product,
                            inRestaurantPage: inRestaurant,
                            isCampaign: isCampaign),
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                      )
                    : Get.dialog(
                        Dialog(
                            child: ProductBottomSheetWidget(
                                product: product,
                                inRestaurantPage: inRestaurant)),
                      );
              } else {
                showCustomSnackBar('product_is_not_available'.tr);
              }
            }
          },
          radius: Dimensions.radiusDefault,
          child: Padding(
            padding: desktop
                ? EdgeInsets.all(fromCartSuggestion
                    ? Dimensions.paddingSizeExtraSmall
                    : Dimensions.paddingSizeSmall)
                : const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeSmall,
                    vertical: Dimensions.paddingSizeExtraSmall),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Expanded(
                  child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: desktop ? 0 : Dimensions.paddingSizeExtraSmall),
                child: Row(children: [
                  ((image != null && image.isNotEmpty) || isRestaurant)
                      ? Stack(clipBehavior: Clip.none, children: [
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(Dimensions.radiusDefault),
                            child: CustomImageWidget(
                              image:
                                  '${isCampaign ? baseUrls!.campaignImageUrl : isRestaurant ? baseUrls!.restaurantImageUrl : baseUrls!.productImageUrl}'
                                  '/${isRestaurant ? restaurant!.logo : product!.image}',
                              height: desktop
                                  ? 120
                                  : length == null
                                      ? 100
                                      : 110,
                              width: desktop ? 120 : 110,
                              fit: BoxFit.cover,
                              isFood: !isRestaurant,
                              isRestaurant: isRestaurant,
                            ),
                          ),
                          DiscountTagWidget(
                            discount: discount,
                            discountType: discountType,
                            freeDelivery:
                                isRestaurant ? restaurant!.freeDelivery : false,
                            fromTop: Dimensions.paddingSizeExtraSmall,
                            fromLeft: -7,
                            paddingVertical:
                                ResponsiveHelper.isDesktop(context) ? 5 : 10,
                          ),
                          isAvailable
                              ? const SizedBox()
                              : NotAvailableWidget(isRestaurant: isRestaurant),
                        ])
                      : const SizedBox.shrink(),
                  const SizedBox(width: Dimensions.paddingSizeSmall),
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Text(
                                    isRestaurant
                                        ? restaurant!.name!
                                        : product!.name!,
                                    style: robotoMedium,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(
                                    width: Dimensions.paddingSizeExtraSmall),
                                (!isRestaurant &&
                                        Get.find<SplashController>()
                                            .configModel!
                                            .toggleVegNonVeg!)
                                    ? Image.asset(
                                        product != null && product!.veg == 0
                                            ? Images.nonVegImage
                                            : Images.vegImage,
                                        height: 10,
                                        width: 10,
                                        fit: BoxFit.contain)
                                    : const SizedBox(),
                                SizedBox(
                                    width: !isRestaurant &&
                                            product!.isRestaurantHalalActive! &&
                                            product!.isHalalFood!
                                        ? 5
                                        : 0),
                                !isRestaurant &&
                                        product!.isRestaurantHalalActive! &&
                                        product!.isHalalFood!
                                    ? const CustomAssetImageWidget(
                                        Images.halalIcon,
                                        height: 13,
                                        width: 13)
                                    : const SizedBox(),
                                const SizedBox(
                                    width: Dimensions.paddingSizeLarge),
                              ]),

                          const SizedBox(
                              height: Dimensions.paddingSizeExtraSmall),

                          !isRestaurant
                              ? Text(
                                  isRestaurant
                                      ? ''
                                      : product!.restaurantName ?? '',
                                  style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeExtraSmall,
                                    color: Theme.of(context).disabledColor,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )
                              : const SizedBox(),

                          isRestaurant
                              ? Row(children: [
                                  Icon(Icons.star,
                                      size: 16,
                                      color: Theme.of(context).primaryColor),
                                  const SizedBox(
                                      width: Dimensions.paddingSizeExtraSmall),
                                  Text(
                                      isRestaurant
                                          ? restaurant!.avgRating!
                                              .toStringAsFixed(1)
                                          : product!.avgRating!
                                              .toStringAsFixed(1),
                                      style: robotoMedium),
                                  const SizedBox(
                                      width: Dimensions.paddingSizeExtraSmall),
                                  Text(
                                      '(${isRestaurant ? restaurant!.ratingCount! > 25 ? '25+' : restaurant!.ratingCount : product!.ratingCount! > 25 ? '25+' : product!.ratingCount})',
                                      style: robotoRegular.copyWith(
                                          fontSize: Dimensions.fontSizeSmall,
                                          color:
                                              Theme.of(context).disabledColor)),
                                ])
                              : const SizedBox(),

                          const SizedBox(
                              height: Dimensions.paddingSizeExtraSmall),
                          // SizedBox(height: (desktop || isRestaurant) ? 5 : 0),

                          // !isRestaurant ? RatingBar(
                          //   rating: isRestaurant ? restaurant!.avgRating : product!.avgRating, size: desktop ? 15 : 12,
                          //   ratingCount: isRestaurant ? restaurant!.ratingCount : product!.ratingCount,
                          // ) : const SizedBox(),
                          !isRestaurant
                              ? Row(children: [
                                  Icon(Icons.star,
                                      size: 16,
                                      color: Theme.of(context).primaryColor),
                                  const SizedBox(
                                      width: Dimensions.paddingSizeExtraSmall),
                                  Text(product!.avgRating!.toStringAsFixed(1),
                                      style: robotoMedium),
                                  const SizedBox(
                                      width: Dimensions.paddingSizeExtraSmall),
                                  Text('(${product!.ratingCount})',
                                      style: robotoRegular.copyWith(
                                          fontSize: Dimensions.fontSizeSmall,
                                          color:
                                              Theme.of(context).disabledColor)),
                                ])
                              : const SizedBox(),

                          SizedBox(
                              height: (!isRestaurant && desktop)
                                  ? Dimensions.paddingSizeExtraSmall
                                  : 0),

                          isRestaurant
                              ? Row(
                                  children: [
                                    Text(
                                      'start_from'.tr,
                                      style: robotoRegular.copyWith(
                                          fontSize:
                                              Dimensions.fontSizeExtraSmall,
                                          color:
                                              Theme.of(context).disabledColor),
                                    ),
                                    const SizedBox(
                                        width:
                                            Dimensions.paddingSizeExtraSmall),
                                    Text(
                                      PriceConverter.convertPrice(
                                          restaurant!.minimumOrder!),
                                      style: robotoRegular.copyWith(
                                          fontSize: Dimensions.fontSizeSmall,
                                          fontWeight: FontWeight.w700,
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .color),
                                    ),
                                  ],
                                )
                              : Wrap(children: [
                                  discount! > 0
                                      ? Text(
                                          PriceConverter.convertPrice(
                                              product!.price),
                                          textDirection: TextDirection.ltr,
                                          style: robotoMedium.copyWith(
                                            fontSize:
                                                Dimensions.fontSizeExtraSmall,
                                            color:
                                                Theme.of(context).disabledColor,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        )
                                      : const SizedBox(),
                                  SizedBox(
                                      width: discount > 0
                                          ? Dimensions.paddingSizeExtraSmall
                                          : 0),
                                  Text(
                                    PriceConverter.convertPrice(product!.price,
                                        discount: discount,
                                        discountType: discountType),
                                    style: robotoMedium.copyWith(
                                        fontSize: Dimensions.fontSizeSmall,
                                        color: Theme.of(context).primaryColor),
                                    textDirection: TextDirection.ltr,
                                  ),
                                  const SizedBox(
                                      width: Dimensions.paddingSizeExtraSmall),
                                  (image != null && image.isNotEmpty)
                                      ? const SizedBox.shrink()
                                      : DiscountTagWithoutImageWidget(
                                          discount: discount,
                                          discountType: discountType,
                                          freeDelivery: isRestaurant
                                              ? restaurant!.freeDelivery
                                              : false),
                                ]),

                          const SizedBox(
                              height: Dimensions.paddingSizeExtraSmall),

                          restaurant?.foods != null &&
                                  restaurant!.foods!.isNotEmpty
                              ? isRestaurant
                                  ? SizedBox(
                                      width: double.infinity,
                                      child: Stack(children: [
                                        OverFlowContainerWidget(
                                            image:
                                                restaurant?.foods![0].image ??
                                                    ''),
                                        restaurant!.foods!.length > 1
                                            ? Positioned(
                                                left: 22,
                                                bottom: 0,
                                                child: OverFlowContainerWidget(
                                                    image: restaurant!
                                                            .foods![1].image ??
                                                        ''),
                                              )
                                            : const SizedBox(),
                                        restaurant!.foods!.length > 2
                                            ? Positioned(
                                                left: 42,
                                                bottom: 0,
                                                child: OverFlowContainerWidget(
                                                    image: restaurant!
                                                            .foods![2].image ??
                                                        ''),
                                              )
                                            : const SizedBox(),
                                        restaurant!.foods!.length > 4
                                            ? Positioned(
                                                left: 82,
                                                bottom: 0,
                                                child: Container(
                                                  padding: const EdgeInsets.all(
                                                      Dimensions
                                                          .paddingSizeExtraSmall),
                                                  height: 30,
                                                  width: 80,
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .primaryColor
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        '${restaurant!.foodsCount! > 11 ? '12 +' : restaurant!.foodsCount!} ',
                                                        style: robotoBold.copyWith(
                                                            fontSize: Dimensions
                                                                .fontSizeSmall,
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor),
                                                      ),
                                                      Text('products'.tr,
                                                          style: robotoRegular.copyWith(
                                                              fontSize: 10,
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor)),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : const SizedBox(),
                                        restaurant!.foods!.length > 3
                                            ? Positioned(
                                                left: 62,
                                                bottom: 0,
                                                child: OverFlowContainerWidget(
                                                    image: restaurant!
                                                            .foods![3].image ??
                                                        ''),
                                              )
                                            : const SizedBox(),
                                      ]),
                                    )
                                  : const SizedBox()
                              : const SizedBox(),
                        ]),
                  ),
                  Column(
                      mainAxisAlignment: isRestaurant
                          ? MainAxisAlignment.start
                          : MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        fromCartSuggestion
                            ? const SizedBox()
                            : GetBuilder<FavouriteController>(
                                builder: (favouriteController) {
                                bool isWished = isRestaurant
                                    ? favouriteController.wishRestIdList
                                        .contains(restaurant!.id)
                                    : favouriteController.wishProductIdList
                                        .contains(product!.id);
                                return CustomFavouriteWidget(
                                  isWished: isWished,
                                  isRestaurant: isRestaurant,
                                  restaurant: restaurant,
                                  product: product,
                                );
                              }),
                        !isRestaurant
                            ? GetBuilder<CartController>(
                                builder: (cartController) {
                                int cartQty =
                                    cartController.cartQuantity(product!.id!);
                                int cartIndex = cartController.isExistInCart(
                                    product!.id, null);
                                CartModel cartModel = CartModel(
                                    null,
                                    price,
                                    discountPrice,
                                    (price - discountPrice),
                                    1,
                                    [],
                                    [],
                                    false,
                                    product,
                                    [],
                                    product?.quantityLimit,
                                    false);
                                return cartQty != 0
                                    ? Container(
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.radiusExtraLarge),
                                        ),
                                        child: Row(children: [
                                          InkWell(
                                            onTap: cartController.isLoading
                                                ? null
                                                : () {
                                                    if (cartController
                                                            .cartList[cartIndex]
                                                            .quantity! >
                                                        1) {
                                                      cartController
                                                          .setQuantity(
                                                              false, cartModel,
                                                              cartIndex:
                                                                  cartIndex);
                                                    } else {
                                                      cartController
                                                          .removeFromCart(
                                                              cartIndex);
                                                    }
                                                  },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color:
                                                    Theme.of(context).cardColor,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                              ),
                                              padding: const EdgeInsets.all(
                                                  Dimensions
                                                      .paddingSizeExtraSmall),
                                              child: Icon(
                                                Icons.remove,
                                                size: 16,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: Dimensions
                                                    .paddingSizeSmall),
                                            child: Text(
                                              cartQty.toString(),
                                              style: robotoMedium.copyWith(
                                                  fontSize:
                                                      Dimensions.fontSizeSmall,
                                                  color: Theme.of(context)
                                                      .cardColor),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: cartController.isLoading
                                                ? null
                                                : () {
                                                    cartController.setQuantity(
                                                        true, cartModel,
                                                        cartIndex: cartIndex);
                                                  },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color:
                                                    Theme.of(context).cardColor,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                              ),
                                              padding: const EdgeInsets.all(
                                                  Dimensions
                                                      .paddingSizeExtraSmall),
                                              child: Icon(
                                                Icons.add,
                                                size: 16,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                          ),
                                        ]),
                                      )
                                    : InkWell(
                                        onTap: () =>
                                            Get.find<ProductController>()
                                                .productDirectlyAddToCart(
                                                    product, context),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).cardColor,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.1),
                                                  spreadRadius: 1,
                                                  blurRadius: 10,
                                                  offset: const Offset(0, 1))
                                            ],
                                          ),
                                          child: Icon(Icons.add,
                                              size: desktop ? 30 : 25,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        ),
                                      );
                              })
                            : const SizedBox(),
                      ]),
                ]),
              )),
            ]),
          ),
        ),
      ),
    );
  }
}

class ProductWidget1 extends StatelessWidget {
  final Product? product;
  final Restaurant? restaurant;
  final bool isRestaurant;
  final int index;
  final int? length;
  final bool inrestaurant;
  final bool isCampaign;
  final bool isFeatured;
  final bool fromCartSuggestion;
  final double? imageHeight;
  final double? imageWidth;
  final bool? isCornerTag;

  const ProductWidget1(
      {super.key,
      required this.product,
      required this.isRestaurant,
      required this.restaurant,
      required this.index,
      required this.length,
      this.inrestaurant = false,
      this.isCampaign = false,
      this.isFeatured = false,
      this.fromCartSuggestion = false,
      this.imageHeight,
      this.imageWidth,
      this.isCornerTag = false});

  @override
  Widget build(BuildContext context) {
    // BaseUrls? baseUrls = Get.find<SplashController>().configModel!.baseUrls;
    // bool desktop = ResponsiveHelper.isDesktop(context);
    // double? discount;
    // String? discountType;
    // bool isAvailable;
    // String? image;
    // double price = 0;
    // double discountPrice = 0;
    // if (isRestaurant) {
    //   discount =
    //       restaurant!.discount != null ? restaurant!.discount!.discount : 0;
    //   discountType = restaurant!.discount != null
    //       ? restaurant!.discount!.discountType
    //       : 'percent';
    //   isAvailable = restaurant!.open == 1 && restaurant!.active!;
    // } else {
    //   discount = (product!.restaurantDiscount == 0 || isCampaign)
    //       ? product!.discount
    //       : product!.restaurantDiscount;
    //   discountType = (product!.restaurantDiscount == 0 || isCampaign)
    //       ? product!.discountType
    //       : 'percent';
    //   isAvailable = DateConverter.isAvailable(
    //       product!.availableTimeStarts, product!.availableTimeEnds);
    // }

    double? price = isRestaurant == true ? 0 : product!.price;
    double? discount = isRestaurant == true
        ? 0
        : (product!.restaurantDiscount == 0)
            ? product!.discount
            : product!.restaurantDiscount;
    String? discountType = isRestaurant == true
        ? "percent"
        : (product!.restaurantDiscount == 0)
            ? product!.discountType
            : 'percent';

    double priceWithDiscountForView =
        PriceConverter.convertWithDiscount(price, discount, discountType)!;
    double priceWithDiscount =
        PriceConverter.convertWithDiscount(price, discount, discountType)!;

    return InkWell(
      onTap: () {
        if (isRestaurant) {
          if (restaurant != null && restaurant!.restaurantStatus == 1) {
            Get.toNamed(RouteHelper.getRestaurantRoute(restaurant!.id),
                arguments: RestaurantScreen(restaurant: restaurant));
          } else if (restaurant!.restaurantStatus == 0) {
            showCustomSnackBar('restaurant_is_not_available'.tr);
          }
        } else {
          if (product!.restaurantStatus == 1) {
            ResponsiveHelper.isMobile(context)
                ? Get.bottomSheet(
                    ProductBottomSheetWidget(
                        product: product,
                        inRestaurantPage: inrestaurant,
                        isCampaign: isCampaign),
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                  )
                : Get.dialog(
                    Dialog(
                        child: ProductBottomSheetWidget(
                            product: product, inRestaurantPage: inrestaurant)),
                  );
          } else {
            showCustomSnackBar('product_is_not_available'.tr);
          }
        }
      },
      child: isRestaurant
          ? RestaurantView1(
              restaurant: restaurant!,
            )
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    // Allow overflow outside the container
                    children: [
                      Container(
                        height: 120,
                        width: 128,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(
                            Dimensions.paddingSizeDefault,
                          ),
                        ),
                        child: Center(
                          child: product!.image == null
                              ? SizedBox()
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radiusDefault),
                                  child: Image.network(
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Text("Loading..");
                                    },
                                    '${Get.find<SplashController>().configModel!.baseUrls!.productImageUrl}'
                                    '/${isRestaurant ? restaurant!.name! : product!.image!}',
                                    height: 120,
                                    width: 128,
                                  ),
                                ),
                        ),
                      ),
                      Positioned(
                          right: 5,
                          top: 5,
                          child: GetBuilder<FavouriteController>(
                              builder: (favouriteController) {
                            bool isWished = favouriteController
                                .wishProductIdList
                                .contains(product!.id);
                            return CustomFavouriteWidget(
                              product: product,
                              isRestaurant: false,
                              isWished: isWished,
                            );
                          })),

                      product!.discount == 0
                          ? const SizedBox()
                          : Positioned(
                              top: -20,
                              left: 0,
                              child: Stack(
                                children: [
                                  Image.asset(
                                    Images.offer50,
                                    height: 55,
                                  ),
                                  Positioned.fill(
                                      top: 0,
                                      bottom: 0,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            (product!.discountType == 'percent')
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        '${product!.discount!.round()}',
                                                        style: robotoBold.copyWith(
                                                            fontSize: Dimensions
                                                                .fontSizeExtraLarge,
                                                            color: Theme.of(
                                                                    context)
                                                                .cardColor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        "%",
                                                        style: robotoBold.copyWith(
                                                            fontSize: Dimensions
                                                                .fontSizeExtraSmall,
                                                            color: Theme.of(
                                                                    context)
                                                                .cardColor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    ],
                                                  )
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .baseline,
                                                    textBaseline:
                                                        TextBaseline.alphabetic,
                                                    children: [
                                                      Text(
                                                        'Rs',
                                                        style: robotoBold.copyWith(
                                                            fontSize: Dimensions
                                                                .fontSizeExtraSmall,
                                                            color: Theme.of(
                                                                    context)
                                                                .cardColor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        '${product!.discount!.round()}',
                                                        style: robotoBold.copyWith(
                                                            fontSize: Dimensions
                                                                .fontSizeExtraLarge,
                                                            color: Theme.of(
                                                                    context)
                                                                .cardColor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  ),
                                            Text(
                                              style: TextStyle(
                                                  color: Get.theme.cardColor,
                                                  fontSize: Dimensions
                                                      .fontSizeExtraSmall),
                                              'off',
                                            )
                                          ],
                                        ),
                                      )),
                                ],
                              ),
                            ),
                      // Positioned(
                      //   bottom: -10,
                      //   left: 15,
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       Container(
                      //         padding: const EdgeInsets.symmetric(
                      //             horizontal: 8, vertical: 5),
                      //         decoration: BoxDecoration(
                      //           color: Get.theme.primaryColor,
                      //           borderRadius: BorderRadius.circular(
                      //               Dimensions.radiusSmall),
                      //         ),
                      //         child: Row(
                      //           mainAxisAlignment: MainAxisAlignment.center,
                      //           children: [
                      //             Image.asset(
                      //               Images.offer,
                      //               height: 15,
                      //             ),
                      //             const SizedBox(width: 5),
                      //             Text(
                      //               "Free Delivery",
                      //               style: TextStyle(
                      //                 fontWeight: FontWeight.w500,
                      //                 fontSize: Dimensions.fontSizeExtraSmall,
                      //                 color: Get.theme.cardColor,
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isRestaurant ? restaurant!.name! : product!.name!,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: Dimensions.fontSizeDefault,
                              color: const Color(0xff090018)),
                        ),
                        Text(
                          isRestaurant
                              ? restaurant!.name!
                              : product!.restaurantName!,
                          style: TextStyle(
                              fontSize: Dimensions.fontSizeSmall,
                              color: const Color(0xff524A61)),
                        ),

                        // product!.ownerName==null?SizedBox():     Text(
                        //
                        //     "Chef${product!.ownerName!}"
                        //      ,
                        //   style: TextStyle(fontSize: Dimensions.fontSizeDefault),
                        // ),

                        const SizedBox(
                          height: 20,
                        ),
                        product!.deliveryTime == null
                            ? const SizedBox()
                            : Text(
                                "${product!.deliveryTime!} delivery",
                                style: TextStyle(
                                    fontSize: Dimensions.fontSizeExtraSmall,
                                    color: const Color(0xff090018),
                                    fontWeight: FontWeight.w600),
                              ),
                        RatingBar(
                          size: 14,
                          rating: product!.avgRating,
                          ratingCount: product!.ratingCount,
                        )
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '₹  ',
                            style: robotoBold.copyWith(
                              fontSize: Dimensions.fontSizeExtraSmall,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            priceWithDiscountForView.round().toString(),
                            style: robotoBold.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      product!.discount == 0
                          ? const SizedBox()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  'Rs ',
                                  style: robotoBold.copyWith(
                                    fontSize: Dimensions.fontSizeExtraSmall,
                                    color: const Color(0xffA7A7A7),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  product!.price.toString(),
                                  style: robotoBold.copyWith(
                                    // color:
                                    decorationColor: const Color(0xffA7A7A7),
                                    decoration: TextDecoration.lineThrough,
                                    color: const Color(0xffA7A7A7),

                                    fontSize: Dimensions.fontSizeDefault,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        padding:
                            const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        decoration: BoxDecoration(
                          color: Get.theme.cardColor,
                          borderRadius:
                              BorderRadius.circular(Dimensions.radiusDefault),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              spreadRadius: 0,
                              blurRadius: 6,
                              offset: Offset(0,
                                  4), // Offset on Y-axis for bottom-side shadow
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(Icons.add),
                        ),
                      ),
                      const SizedBox(
                        height: Dimensions.paddingSizeSmall,
                      ),
                    ],
                  )
                ],
              ),
            ),

      // Stack(
      //   children: [
      //     Container(
      //
      //       padding: ResponsiveHelper.isDesktop(context) ? EdgeInsets.all(fromCartSuggestion ? Dimensions.paddingSizeExtraSmall : Dimensions.paddingSizeSmall) : const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
      //       margin: ResponsiveHelper.isDesktop(context) ? null : const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
      //       decoration: BoxDecoration(
      //           border: Border(
      //             bottom: BorderSide(
      //               color: Theme.of(context).hintColor.withOpacity(0.1), // Specify your desired color
      //               width: 1.0,
      //             ),)),
      //       child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      //
      //         Expanded(child: Padding(
      //           padding: EdgeInsets.symmetric(vertical: desktop ? 0 : Dimensions.paddingSizeExtraSmall),
      //           child: Row(children: [
      //
      //             Expanded(
      //               child: Padding(
      //                 padding: const EdgeInsets.only(left: 4.0,right:4,top: 4 ),
      //                 child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      //                   Text(
      //                     isRestaurant ? restaurant!.name! : product!.name!,
      //                     style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge*1.1,fontWeight: FontWeight.bold),
      //                     maxLines: desktop ? 2 : 2, overflow: TextOverflow.ellipsis,
      //                   ),
      //                   const SizedBox(width: Dimensions.paddingSizeExtraSmall),
      //                   Row(children: [
      //                     Text(
      //                       PriceConverter.convertPrice(product!.price, discount: discount, discountType: discountType),
      //                       style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge), textDirection: TextDirection.ltr,
      //                     ),
      //                     SizedBox(width: discount! > 0 ? Dimensions.paddingSizeExtraSmall : 0),
      //
      //                     discount > 0 ? Text(
      //                       PriceConverter.convertPrice(product!.price),
      //                       style: robotoBold.copyWith(
      //                         fontSize: Dimensions.fontSizeLarge,
      //                         color: Theme.of(context).disabledColor,
      //                         decoration: TextDecoration.lineThrough,
      //                       ), textDirection: TextDirection.ltr,
      //                     ) : const SizedBox(),
      //                   ]),
      //
      //
      //                   SizedBox(height: (!isRestaurant && desktop) ? Dimensions.paddingSizeExtraSmall : 0),
      //
      //                   RatingBar(
      //                     rating: isRestaurant ? restaurant!.avgRating : product!.avgRating, size: desktop ? 15 : 12,
      //                     ratingCount: isRestaurant ? restaurant!.ratingCount : product!.ratingCount,
      //                   ) ,
      //                   SizedBox(height: ((desktop || isRestaurant) && (isRestaurant ? restaurant!.address != null : product!.restaurantName != null)) ? 5 : 0),
      //
      //                   FittedBox(
      //                     child: Row(mainAxisAlignment: isRestaurant ? MainAxisAlignment.start : MainAxisAlignment.start, children: [
      //
      //                       const SizedBox(),
      //
      //                       fromCartSuggestion ? Container(
      //                         decoration: BoxDecoration(
      //                           color: Theme.of(context).primaryColor,
      //                           shape: BoxShape.circle,
      //                         ),
      //                         padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
      //                         child: Icon(Icons.add, color: Theme.of(context).cardColor, size: 12),
      //                       ) : GetBuilder<FavouriteController>(builder: (wishController) {
      //                         bool isWished = isRestaurant ? wishController.wishRestIdList.contains(restaurant!.id)
      //                             : wishController.wishProductIdList.contains(product!.id);
      //                         return InkWell(
      //                           onTap: !wishController.isDisable ? () {
      //                             if(Get.find<AuthController>().isLoggedIn()) {
      //                               isWished ? wishController.removeFromFavouriteList(isRestaurant ? restaurant!.id : product!.id, isRestaurant)
      //                                   : wishController.addToFavouriteList(product, restaurant, isRestaurant);
      //                             }else {
      //                               showCustomSnackBar('you_are_not_logged_in'.tr);
      //                             }
      //                           } : null,
      //                           child: Padding(
      //                             padding: EdgeInsets.symmetric(vertical: desktop ? Dimensions.paddingSizeSmall : 0),
      //                             child: Container(
      //                               decoration: BoxDecoration(border: Border.all(width: 1,color: Theme.of(context).disabledColor),
      //                                   borderRadius: BorderRadius.circular(50)),
      //                               child: Padding(
      //                                 padding: const EdgeInsets.all(4.0),
      //                                 child: Icon(
      //                                   isWished ? Icons.favorite : Icons.favorite_border,  size: desktop ? 30 : 15,
      //                                   color: isWished ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
      //                                 ),
      //                               ),
      //                             ),
      //                           ),
      //                         );
      //                       }),
      //                       const SizedBox(width: 20,),
      //                       (!isRestaurant && Get.find<SplashController>().configModel!.toggleVegNonVeg!)
      //                           ? Image.asset(product != null && product!.veg == 0 ? Images.nonVegImage : Images.vegImage,
      //                           height: 20, width: 20, fit: BoxFit.contain) : const SizedBox(),
      //                       const SizedBox(width: 20,),
      //                     ]),
      //                   ),
      //                 ]),
      //               ),
      //             ),
      //
      //             const SizedBox(width: Dimensions.paddingSizeSmall),
      //             Column(
      //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //               children: [
      //                 Stack(children: [
      //                   Padding(
      //                     padding: const EdgeInsets.only(right: 8.0),
      //                     child: ClipRRect(
      //                       borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      //                       child: CustomImageWidget(
      //                         image: '${isCampaign ? baseUrls!.campaignImageUrl : isRestaurant ? baseUrls!.restaurantImageUrl
      //                             : baseUrls!.productImageUrl}'
      //                             '/${isRestaurant ? restaurant != null ? restaurant!.logo : '' : product!.image}',
      //                         height: imageHeight ?? (desktop ? 120 : length == null ? 100 : isRestaurant?120:110), width: imageWidth ?? (desktop ? 120 : 135), fit: BoxFit.cover,
      //                       ),
      //                     ),
      //                   ),
      //                   (isRestaurant || isCornerTag!) ? DiscountTag(
      //                     discount: discount, discountType: discountType,
      //                     freeDelivery: isRestaurant ? restaurant!.freeDelivery : false,
      //                   ) : const SizedBox(),
      //
      //                   SizedBox(width: !isRestaurant && product!.isRestaurantHalalActive! && product!.isHalalFood! ? 5 : 0),
      //
      //                   !isRestaurant && product!.isRestaurantHalalActive! && product!.isHalalFood! ? const CustomAssetImageWidget(
      //                       Images.halalIcon, height: 13, width: 13) : const SizedBox(),
      //
      //                   const SizedBox(width: Dimensions.paddingSizeLarge),
      //
      //                   //isAvailable ? const SizedBox() : NotAvailableWidget(isRestaurant: isRestaurant),
      //                 ]),
      //               ],
      //             ),
      //           ]),
      //         )),
      //       ]),
      //     ),
      //
      //     !isRestaurant ?
      //     Positioned(
      //       bottom: 12,right: 36,
      //       child: Column(
      //         children: [
      //           Container(
      //             width: imageWidth ?? (desktop ? 120 : 98) ,
      //             decoration: BoxDecoration(
      //               color: Theme.of(context).cardColor,
      //               borderRadius: BorderRadius.circular(8),
      //               boxShadow: [
      //                 BoxShadow(
      //                   color: Colors.grey.withOpacity(0.5), // Shadow color
      //                   spreadRadius: 5, // Spread radius
      //                   blurRadius: 7, // Blur radius
      //                   offset: Offset(0, 3), // Offset in x and y directions
      //                 ),
      //               ],
      //             ),
      //             child: Center(
      //               child: Padding(
      //                 padding: const EdgeInsets.only(top: 8.0,bottom: 8),
      //                 child:
      //                 Row(
      //                   mainAxisAlignment: MainAxisAlignment.spaceAround,
      //                   children: [
      //                     Text("ADD",style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge,fontWeight: FontWeight.bold,color:Colors.green.shade500 ),
      //                     ),
      //                     Icon(Icons.add,color:Colors.green.shade500,size: 20,),
      //                   ],
      //                 ),
      //               ),
      //             ),
      //           ),
      //
      //           SizedBox(height: 2,),
      //           product!.variations != null&& product!.variations !.isNotEmpty?Text("Customisable",style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall*0.7,fontWeight: FontWeight.normal,color: Colors.grey ),
      //           ):SizedBox(
      //             height: 10,
      //           ),
      //         ],
      //       ),
      //     ):Container(),
      //
      //
      //
      //     (!isRestaurant && isCornerTag! == false && isAvailable) ?
      //     Positioned(
      //         right: ltr ? 0 : null, left: ltr ? null : 0,
      //         child: CornerDiscountTag(
      //           bannerPosition: ltr ? CornerBannerPosition.topRight : CornerBannerPosition.topLeft,
      //           elevation: 0,
      //           discount: discount, discountType: discountType,
      //           freeDelivery: isRestaurant ? restaurant!.freeDelivery : false,
      //         )) : const SizedBox(),
      //     isAvailable ? const SizedBox():
      //     Positioned(
      //         right: ltr ? 0 : null, left: ltr ? null : 0,
      //         child:CornerBanner(
      //           bannerPosition: ltr ? CornerBannerPosition.topRight : CornerBannerPosition.topLeft,
      //           // bannerColor:Theme.of(context).errorColor,
      //           bannerColor: Colors.red,
      //           elevation: 5,
      //           shadowColor: Colors.transparent,
      //           child: isRestaurant?_buildBannerContent1():_buildBannerContent(),
      //         )
      //     ) ,
      //
      //   ],
      // ),
    );
  }

  Widget _buildBannerContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 3.0,
      ),
      child: Material(
        type: MaterialType.transparency,
        color: Colors.transparent,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "product Unavailable",
                  style: robotoMedium.copyWith(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerContent1() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 3.0,
      ),
      child: Material(
        // Material prevents ugly text display when there is no
        // Scaffold above this banner.
        type: MaterialType.transparency,
        color: Colors.transparent,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "restaurant Closed",
                  style: robotoMedium.copyWith(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

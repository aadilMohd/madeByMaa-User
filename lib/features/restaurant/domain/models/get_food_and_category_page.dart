// To parse this JSON data, do
//
//     final getFoodAndCategoryPage = getFoodAndCategoryPageFromJson(jsonString);

import 'dart:convert';

import '../../../../common/models/product_model.dart';

GetFoodAndCategoryPage getFoodAndCategoryPageFromJson(String str) =>
    GetFoodAndCategoryPage.fromJson(json.decode(str));

String getFoodAndCategoryPageToJson(GetFoodAndCategoryPage data) =>
    json.encode(data.toJson());

class GetFoodAndCategoryPage {
  List<Category>? categories;
  Items? items;

  GetFoodAndCategoryPage({
    this.categories,
    this.items,
  });

  factory GetFoodAndCategoryPage.fromJson(Map<String, dynamic> json) =>
      GetFoodAndCategoryPage(
        categories: json["categories"] == null
            ? []
            : List<Category>.from(
                json["categories"]!.map((x) => Category.fromJson(x))),
        items: json["items"] == null ? null : Items.fromJson(json["items"]),
      );

  Map<String, dynamic> toJson() => {
        "categories": categories == null
            ? []
            : List<dynamic>.from(categories!.map((x) => x.toJson())),
        "items": items?.toJson(),
      };
}

class Category {
  int? id;
  String? name;
  String? image;
  int? parentId;
  int? position;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? priority;
  String? slug;
  List<Translation>? translations;

  Category({
    this.id,
    this.name,
    this.image,
    this.parentId,
    this.position,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.priority,
    this.slug,
    this.translations,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        parentId: json["parent_id"],
        position: json["position"],
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        priority: json["priority"],
        slug: json["slug"],
        translations: json["translations"] == null
            ? []
            : List<Translation>.from(
                json["translations"]!.map((x) => Translation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "parent_id": parentId,
        "position": position,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "priority": priority,
        "slug": slug,
        "translations": translations == null
            ? []
            : List<dynamic>.from(translations!.map((x) => x.toJson())),
      };
}

class Translation {
  int? id;
  String? translationableType;
  int? translationableId;
  String? locale;
  String? key;
  String? value;
  dynamic createdAt;
  dynamic updatedAt;

  Translation({
    this.id,
    this.translationableType,
    this.translationableId,
    this.locale,
    this.key,
    this.value,
    this.createdAt,
    this.updatedAt,
  });

  factory Translation.fromJson(Map<String, dynamic> json) => Translation(
        id: json["id"],
        translationableType: json["translationable_type"],
        translationableId: json["translationable_id"],
        locale: json["locale"],
        key: json["key"],
        value: json["value"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "translationable_type": translationableType,
        "translationable_id": translationableId,
        "locale": locale,
        "key": key,
        "value": value,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class Items {
  int? totalSize;
  String? limit;
  String? offset;
  List<Product>? products;

  Items({
    this.totalSize,
    this.limit,
    this.offset,
    this.products,
  });

  factory Items.fromJson(Map<String, dynamic> json) => Items(
        totalSize: json["total_size"],
        limit: json["limit"].toString(),
        offset: json["offset"],
        products: json["products"] == null
            ? []
            : List<Product>.from(
                json["products"]!.map((x) => Product.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_size": totalSize,
        "limit": limit,
        "offset": offset,
        "products": products == null
            ? []
            : List<dynamic>.from(products!.map((x) => x.toJson())),
      };
}

class CategoryId {
  String? id;
  int? position;

  CategoryId({
    this.id,
    this.position,
  });

  factory CategoryId.fromJson(Map<String, dynamic> json) => CategoryId(
        id: json["id"],
        position: json["position"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "position": position,
      };
}

class Cuisine {
  int? id;
  String? name;
  String? image;

  Cuisine({
    this.id,
    this.name,
    this.image,
  });

  factory Cuisine.fromJson(Map<String, dynamic> json) => Cuisine(
        id: json["id"],
        name: json["name"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
      };
}

class Tag {
  int? id;
  String? tag;
  DateTime? createdAt;
  DateTime? updatedAt;
  Pivot? pivot;

  Tag({
    this.id,
    this.tag,
    this.createdAt,
    this.updatedAt,
    this.pivot,
  });

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
        id: json["id"],
        tag: json["tag"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        pivot: json["pivot"] == null ? null : Pivot.fromJson(json["pivot"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tag": tag,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "pivot": pivot?.toJson(),
      };
}

class Pivot {
  int? foodId;
  int? tagId;

  Pivot({
    this.foodId,
    this.tagId,
  });

  factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
        foodId: json["food_id"],
        tagId: json["tag_id"],
      );

  Map<String, dynamic> toJson() => {
        "food_id": foodId,
        "tag_id": tagId,
      };
}

// class Product {
//   int? id;
//   String? name;
//   String? description;
//   dynamic ingredients;
//   String? image;
//   int? categoryId;
//   List<CategoryId>? categoryIds;
//   List<dynamic>? variations;
//   List<dynamic>? addOns;
//   String? attributes;
//   dynamic choiceOptions;
//   int? price;
//   int? tax;
//   String? taxType;
//   int? discount;
//   String? discountType;
//   dynamic availableTimeStarts;
//   dynamic availableTimeEnds;
//   int? veg;
//   int? status;
//   int? restaurantId;
//   DateTime? createdAt;
//   DateTime? updatedAt;
//   int? orderCount;
//   int? avgRating;
//   int? ratingCount;
//   int? recommended;
//   String? slug;
//   int? maximumCartQuantity;
//   int? isHalal;
//   bool? scheduleOrders;
//   bool? instantOrder;
//   List<Tag>? tags;
//   String? restaurantName;
//   int? restaurantStatus;
//   int? restaurantDiscount;
//   dynamic restaurantOpeningTime;
//   dynamic restaurantClosingTime;
//   bool? scheduleOrder;
//   int? minDeliveryTime;
//   int? maxDeliveryTime;
//   int? freeDelivery;
//   int? halalTagStatus;
//   List<Cuisine>? cuisines;
//   List<dynamic>? translations;
//
//   Product({
//     this.id,
//     this.name,
//     this.description,
//     this.ingredients,
//     this.image,
//     this.categoryId,
//     this.categoryIds,
//     this.variations,
//     this.addOns,
//     this.attributes,
//     this.choiceOptions,
//     this.price,
//     this.tax,
//     this.taxType,
//     this.discount,
//     this.discountType,
//     this.availableTimeStarts,
//     this.availableTimeEnds,
//     this.veg,
//     this.status,
//     this.restaurantId,
//     this.createdAt,
//     this.updatedAt,
//     this.orderCount,
//     this.avgRating,
//     this.ratingCount,
//     this.recommended,
//     this.slug,
//     this.maximumCartQuantity,
//     this.isHalal,
//     this.scheduleOrders,
//     this.instantOrder,
//     this.tags,
//     this.restaurantName,
//     this.restaurantStatus,
//     this.restaurantDiscount,
//     this.restaurantOpeningTime,
//     this.restaurantClosingTime,
//     this.scheduleOrder,
//     this.minDeliveryTime,
//     this.maxDeliveryTime,
//     this.freeDelivery,
//     this.halalTagStatus,
//     this.cuisines,
//     this.translations,
//   });
//
//   factory Product.fromJson(Map<String, dynamic> json) => Product(
//         id: json["id"],
//         name: json["name"],
//         description: json["description"],
//         ingredients: json["ingredients"],
//         image: json["image"],
//         categoryId: json["category_id"],
//         categoryIds: json["category_ids"] == null
//             ? []
//             : List<CategoryId>.from(
//                 json["category_ids"]!.map((x) => CategoryId.fromJson(x))),
//         variations: json["variations"] == null
//             ? []
//             : List<dynamic>.from(json["variations"]!.map((x) => x)),
//         addOns: json["add_ons"] == null
//             ? []
//             : List<dynamic>.from(json["add_ons"]!.map((x) => x)),
//         attributes: json["attributes"],
//         choiceOptions: json["choice_options"],
//         price: json["price"],
//         tax: json["tax"],
//         taxType: json["tax_type"],
//         discount: json["discount"],
//         discountType: json["discount_type"],
//         availableTimeStarts: json["available_time_starts"],
//         availableTimeEnds: json["available_time_ends"],
//         veg: json["veg"],
//         status: json["status"],
//         restaurantId: json["restaurant_id"],
//         createdAt: json["created_at"] == null
//             ? null
//             : DateTime.parse(json["created_at"]),
//         updatedAt: json["updated_at"] == null
//             ? null
//             : DateTime.parse(json["updated_at"]),
//         orderCount: json["order_count"],
//         avgRating: json["avg_rating"],
//         ratingCount: json["rating_count"],
//         recommended: json["recommended"],
//         slug: json["slug"],
//         maximumCartQuantity: json["maximum_cart_quantity"],
//         isHalal: json["is_halal"],
//         scheduleOrders: json["schedule_orders"],
//         instantOrder: json["instant_order"],
//         tags: json["tags"] == null
//             ? []
//             : List<Tag>.from(json["tags"]!.map((x) => Tag.fromJson(x))),
//         restaurantName: json["restaurant_name"],
//         restaurantStatus: json["restaurant_status"],
//         restaurantDiscount: json["restaurant_discount"],
//         restaurantOpeningTime: json["restaurant_opening_time"],
//         restaurantClosingTime: json["restaurant_closing_time"],
//         scheduleOrder: json["schedule_order"],
//         minDeliveryTime: json["min_delivery_time"],
//         maxDeliveryTime: json["max_delivery_time"],
//         freeDelivery: json["free_delivery"],
//         halalTagStatus: json["halal_tag_status"],
//         cuisines: json["cuisines"] == null
//             ? []
//             : List<Cuisine>.from(
//                 json["cuisines"]!.map((x) => Cuisine.fromJson(x))),
//         translations: json["translations"] == null
//             ? []
//             : List<dynamic>.from(json["translations"]!.map((x) => x)),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "description": description,
//         "ingredients": ingredients,
//         "image": image,
//         "category_id": categoryId,
//         "category_ids": categoryIds == null
//             ? []
//             : List<dynamic>.from(categoryIds!.map((x) => x.toJson())),
//         "variations": variations == null
//             ? []
//             : List<dynamic>.from(variations!.map((x) => x)),
//         "add_ons":
//             addOns == null ? [] : List<dynamic>.from(addOns!.map((x) => x)),
//         "attributes": attributes,
//         "choice_options": choiceOptions,
//         "price": price,
//         "tax": tax,
//         "tax_type": taxType,
//         "discount": discount,
//         "discount_type": discountType,
//         "available_time_starts": availableTimeStarts,
//         "available_time_ends": availableTimeEnds,
//         "veg": veg,
//         "status": status,
//         "restaurant_id": restaurantId,
//         "created_at": createdAt?.toIso8601String(),
//         "updated_at": updatedAt?.toIso8601String(),
//         "order_count": orderCount,
//         "avg_rating": avgRating,
//         "rating_count": ratingCount,
//         "recommended": recommended,
//         "slug": slug,
//         "maximum_cart_quantity": maximumCartQuantity,
//         "is_halal": isHalal,
//         "schedule_orders": scheduleOrders,
//         "instant_order": instantOrder,
//         "tags": tags == null
//             ? []
//             : List<dynamic>.from(tags!.map((x) => x.toJson())),
//         "restaurant_name": restaurantName,
//         "restaurant_status": restaurantStatus,
//         "restaurant_discount": restaurantDiscount,
//         "restaurant_opening_time": restaurantOpeningTime,
//         "restaurant_closing_time": restaurantClosingTime,
//         "schedule_order": scheduleOrder,
//         "min_delivery_time": minDeliveryTime,
//         "max_delivery_time": maxDeliveryTime,
//         "free_delivery": freeDelivery,
//         "halal_tag_status": halalTagStatus,
//         "cuisines": cuisines == null
//             ? []
//             : List<dynamic>.from(cuisines!.map((x) => x.toJson())),
//         "translations": translations == null
//             ? []
//             : List<dynamic>.from(translations!.map((x) => x)),
//       };
// }

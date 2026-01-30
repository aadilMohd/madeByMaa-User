

import 'dart:convert';

List<FoodReviewedModel> foodReviewedModelFromJson(String str) => List<FoodReviewedModel>.from(json.decode(str).map((x) => FoodReviewedModel.fromJson(x)));

String foodReviewedModelToJson(List<FoodReviewedModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
//FoodReviewedModel
class FoodReviewedModel {
  int? id;
  int? foodId;
  int? userId;
  String? comment;
  dynamic attachment;
  int? rating;
  int? orderId;
  dynamic createdAt;
  dynamic updatedAt;
  int? itemCampaignId;
  int? status;
  String? foodName;
  Customer? customer;

  FoodReviewedModel({
    this.id,
    this.foodId,
    this.userId,
    this.comment,
    this.attachment,
    this.rating,
    this.orderId,
    this.createdAt,
    this.updatedAt,
    this.itemCampaignId,
    this.status,
    this.foodName,
    this.customer,
  });

  factory FoodReviewedModel.fromJson(Map<String, dynamic> json) => FoodReviewedModel(
    id: json["id"],
    foodId: json["food_id"],
    userId: json["user_id"],
    comment: json["comment"],
    attachment: json["attachment"],
    rating: json["rating"],
    orderId: json["order_id"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    itemCampaignId: json["item_campaign_id"],
    status: json["status"],
    foodName: json["food_name"],
    customer: json["customer"] == null ? null : Customer.fromJson(json["customer"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "food_id": foodId,
    "user_id": userId,
    "comment": comment,
    "attachment": attachment,
    "rating": rating,
    "order_id": orderId,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "item_campaign_id": itemCampaignId,
    "status": status,
    "food_name": foodName,
    "customer": customer?.toJson(),
  };
}

class Customer {
  int? id;
  String? fName;
  String? lName;
  String? phone;
  String? email;
  String? image;
  int? isPhoneVerified;
  dynamic emailVerifiedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? cmFirebaseToken;
  int? status;
  int? orderCount;
  dynamic loginMedium;
  dynamic socialId;
  int? zoneId;
  int? walletBalance;
  int? loyaltyPoint;
  String? refCode;
  dynamic refBy;
  dynamic tempToken;
  String? currentLanguageKey;

  Customer({
    this.id,
    this.fName,
    this.lName,
    this.phone,
    this.email,
    this.image,
    this.isPhoneVerified,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.cmFirebaseToken,
    this.status,
    this.orderCount,
    this.loginMedium,
    this.socialId,
    this.zoneId,
    this.walletBalance,
    this.loyaltyPoint,
    this.refCode,
    this.refBy,
    this.tempToken,
    this.currentLanguageKey,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    id: json["id"],
    fName: json["f_name"],
    lName: json["l_name"],
    phone: json["phone"],
    email: json["email"],
    image: json["image"],
    isPhoneVerified: json["is_phone_verified"],
    emailVerifiedAt: json["email_verified_at"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    cmFirebaseToken: json["cm_firebase_token"],
    status: json["status"],
    orderCount: json["order_count"],
    loginMedium: json["login_medium"],
    socialId: json["social_id"],
    zoneId: json["zone_id"],
    walletBalance: json["wallet_balance"],
    loyaltyPoint: json["loyalty_point"],
    refCode: json["ref_code"],
    refBy: json["ref_by"],
    tempToken: json["temp_token"],
    currentLanguageKey: json["current_language_key"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "f_name": fName,
    "l_name": lName,
    "phone": phone,
    "email": email,
    "image": image,
    "is_phone_verified": isPhoneVerified,
    "email_verified_at": emailVerifiedAt,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "cm_firebase_token": cmFirebaseToken,
    "status": status,
    "order_count": orderCount,
    "login_medium": loginMedium,
    "social_id": socialId,
    "zone_id": zoneId,
    "wallet_balance": walletBalance,
    "loyalty_point": loyaltyPoint,
    "ref_code": refCode,
    "ref_by": refBy,
    "temp_token": tempToken,
    "current_language_key": currentLanguageKey,
  };
}

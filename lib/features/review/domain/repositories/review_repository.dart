import 'package:stackfood_multivendor/common/models/food_reviewed_model.dart';
import 'package:stackfood_multivendor/common/models/product_model.dart';
import 'package:stackfood_multivendor/common/models/response_model.dart';
import 'package:stackfood_multivendor/common/models/review_model.dart';
import 'package:stackfood_multivendor/api/api_client.dart';
import 'package:stackfood_multivendor/features/product/domain/models/review_body_model.dart';
import 'package:stackfood_multivendor/features/review/domain/repositories/review_repository_interface.dart';
import 'package:stackfood_multivendor/util/app_constants.dart';
import 'package:get/get.dart';

class ReviewRepository implements ReviewRepositoryInterface {
  final ApiClient apiClient;
  ReviewRepository({required this.apiClient});

  @override
  Future<ResponseModel> submitReview(ReviewBodyModel reviewBody, bool isProduct) async {
    if(isProduct) {
      return _submitReview(reviewBody);
    } else {
      return _submitDeliveryManReview(reviewBody);
    }
  }

  @override
  Future<List<Product>?> getList({int? offset, String? type}) async {
    List<Product>? reviewedProductList;
    Response response = await apiClient.getData('${AppConstants.reviewedProductUri}?type=$type');
    if (response.statusCode == 200) {
      reviewedProductList = [];
      reviewedProductList.addAll(ProductModel.fromJson(response.body).products!);
    }
    return reviewedProductList;
  }


  List<FoodReviewedModel>? foodReview;
  @override
  Future<List<FoodReviewedModel>?> getFoodReviewListttt(String? foodId) async {
    try {
      Response response = await apiClient.getData('${AppConstants.foodReviews}$foodId');
      if (response.statusCode == 200) {
        print("Response: ${response.body.toString()}");
        foodReview = [];

        // Check if the response body is a list and then parse each item.
        List<dynamic> responseData = response.body;
        foodReview = responseData.map((json) => FoodReviewedModel.fromJson(json)).toList();

        print("Parsed Reviews: $foodReview");
      } else {
        print("Failed to load reviews");
      }
    } catch (e, stacktrace) {
      print("============================ww $stacktrace");
      print("============================ee $e");
    }
    return foodReview;
  }

  Future<ResponseModel> _submitReview(ReviewBodyModel reviewBody) async {
    Response response = await apiClient.postData(AppConstants.reviewUri, reviewBody.toJson(), handleError: false);
    if (response.statusCode == 200) {
      return ResponseModel(true, 'review_submitted_successfully'.tr);
    } else {
      return ResponseModel(false, response.statusText);
    }
  }

  Future<ResponseModel> _submitDeliveryManReview(ReviewBodyModel reviewBody) async {
    Response response = await apiClient.postData(AppConstants.deliveryManReviewUri, reviewBody.toJson(), handleError: false);
    if (response.statusCode == 200) {
      return ResponseModel(true, 'review_submitted_successfully'.tr);
    } else {
      return ResponseModel(false, response.statusText);
    }
  }

  @override
  Future<List<ReviewModel>?> getRestaurantReviewList(String? restaurantID) async {
    List<ReviewModel>? restaurantReviewList;
    Response response = await apiClient.getData('${AppConstants.restaurantReviewUri}?restaurant_id=$restaurantID');
    if (response.statusCode == 200) {
      restaurantReviewList = [];
      response.body.forEach((review) => restaurantReviewList!.add(ReviewModel.fromJson(review)));
    }
    return restaurantReviewList;
  }

  @override
  Future add(value) {
    throw UnimplementedError();
  }

  @override
  Future delete(int? id) {
    throw UnimplementedError();
  }

  @override
  Future get(String? id) {
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body, int? id) {
    throw UnimplementedError();
  }


  
}
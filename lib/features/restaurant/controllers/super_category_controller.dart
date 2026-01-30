import 'dart:convert';
import 'dart:developer';

import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:stackfood_multivendor/api/api_checker2.dart';
import 'package:stackfood_multivendor/features/restaurant/domain/models/super_category_model.dart';

import '../../../api/api_checker.dart';
import '../../../common/models/response_model.dart';
import '../../../common/models/response_model2.dart';
import '../../../common/models/restaurant_model.dart';
import '../domain/models/get_food_and_category_page.dart';
import '../domain/repositories/super_category_repo.dart';

class SuperCategoryController extends GetxController implements GetxService {
  final SuperCategoryRepo superCategoryRepo;
  SuperCategoryController({required this.superCategoryRepo});

  List<SuperCategoryModel> getSuperCategoryList = [];

  GetFoodAndCategoryPage? getFoodAndCategoryPage;

  Future<ResponseModel2> getSuperCategory() async {
    // isLoading = true;
    update();
    Response response = await superCategoryRepo.superCategory();
    log(jsonEncode(response.body));
    log(jsonEncode(response.statusCode));
    log("-=-=-=${response.body}");

    ResponseModel2 responseModel2 = await checkResponseModel(response);
    // showCustomSnackBar(
    //   responseModel2.message,
    // );
    log(jsonEncode(response.statusCode));
    if (responseModel2.isSuccess) {
      getSuperCategoryList =
          superCategoryModelFromJson(jsonEncode(responseModel2.data));
    }
    // isLoading = false;
    update();
    return responseModel2;
  }

  Future<ResponseModel2> getFoodAndCategory(
    int superCategoryId,
    int restaurantId,
    int offset, {
    String? categoryId,
  }) async {
    getFoodAndCategoryPage == null;

    update();
    Response response = await superCategoryRepo.getFoodAndCategory(
      restaurantId,
      categoryId!,
      offset,
      superCategoryId,
    );
    ResponseModel2 responseModel2 = await checkResponseModel(response);
    log(jsonEncode(response.statusCode));
    // if (!more) {
    getFoodAndCategoryPage == null;
    // }

    if (responseModel2.isSuccess) {
      print("=-=-=-=-${responseModel2.data}");
      try {
        getFoodAndCategoryPage =
            getFoodAndCategoryPageFromJson(jsonEncode(responseModel2.data));
      } catch (e, stracktrace) {
        log("pratham mm ${stracktrace}");
      }
    }
    // isLoading = false;
    update();
    return responseModel2;
  }
}

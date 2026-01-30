import 'package:get/get_connect/http/src/response/response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../api/api_client.dart';
import '../../../../util/app_constants.dart';

class SuperCategoryRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  SuperCategoryRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> superCategory() async {
    return await apiClient.getData(AppConstants.getSuperCategoryUri);
  }

  Future<Response> getFoodAndCategory(int restaurantId, String? categoryId,
      int offset, int superCategoryId) async {
    return await apiClient.getData(
        "${AppConstants.getFoodAndCategoryBySuperCategoryUri}?restaurant_id=$restaurantId&super_category_id=$superCategoryId&offset=$offset&category_id=$categoryId");
  }
}

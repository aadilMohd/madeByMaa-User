import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';

import '../common/models/response_model2.dart';
import '../common/widgets/custom_snackbar_widget.dart';
import '../features/auth/controllers/auth_controller.dart';
import '../features/splash/screens/splash_screen.dart';

Future<ResponseModel2> checkResponseModel(Response response) async {
  log(response.statusCode.toString());
  log(response.statusText.toString());
  log(json.encode(response.body));
  if (response.statusCode == 401) {
    // await Get.find<AuthController>().clearSharedData();
    // Get.offAll(() => const SplashScreen());
    showCustomSnackBar('Auth Failed', isError: true);
    return ResponseModel2(false, 'Unauthorized', null);
  }
  if (response.statusCode == 200 || response.statusCode == 201) {
    if (response.body['status'] == true) {
      return ResponseModel2(response.body['status'],
          response.body['message'] ?? '', response.body['data']);
    } else {
      return ResponseModel2(
          response.body['status'], response.body['message'] ?? '', null);
    }
  } else {
    if (!response.body.toString().startsWith('{')) {
      showCustomSnackBar('Internal Server Error :${response.statusCode}',
          isError: true);
      return ResponseModel2(false, 'Internal Server Error', null);
    } else {
      return ResponseModel2(
          response.body['status'], response.body['message'], null);
    }
  }
}

import 'package:stackfood_multivendor/common/models/response_model.dart';
import 'package:stackfood_multivendor/features/auth/domain/models/signup_body_model.dart';
import 'package:stackfood_multivendor/features/auth/domain/models/social_log_in_body_model.dart';

import '../models/upload_photo_body.dart';

abstract class AuthServiceInterface{

  Future<ResponseModel> registration(SignUpBodyModel signUpModel, bool isCustomerVerificationOn);
  Future<ResponseModel> registration1(SignUpBodyModel signUpModel,);
  Future<ResponseModel> login({String? phone, String? password, bool customerVerification = false, bool alreadyInApp = false});
  Future<ResponseModel> login1({String? phone});
  Future<ResponseModel> uploadPhoto(UploadPhotoBody uploadPhotoBody);
  Future<ResponseModel> loginOtp({String? phone,String?otp});
  String getUserCountryCode();
  String getUserNumber();
  String getUserPassword();
  void saveUserNumberAndPassword(String number, String password, String countryCode);
  Future<bool> clearUserNumberAndPassword();
  Future<ResponseModel> guestLogin();
  Future<void> loginWithSocialMedia(SocialLogInBodyModel socialLogInModel, {bool isCustomerVerificationOn = false});
  Future<void> registerWithSocialMedia(SocialLogInBodyModel socialLogInModel, {bool isCustomerVerificationOn = false});
  Future<void> updateToken();
  void saveDmTipIndex(String i);
  String getDmTipIndex();
  bool isLoggedIn();
  String getGuestId();
  bool isGuestLoggedIn();
  Future<void> socialLogout();
  Future<bool> clearSharedData({bool removeToken = true});
  bool setNotificationActive(bool isActive);
  bool isNotificationActive();
  String getUserToken();
  Future<void> saveGuestNumber(String number);
  String getGuestNumber();
}
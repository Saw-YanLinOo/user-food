

import 'package:user/data/model/body/signup_body.dart';

import '../../../../data/model/response/response_model.dart';

abstract class AuthServiceInterface{

  Future<ResponseModel> registration(SignUpBody signUpModel, bool isCustomerVerificationOn);
  Future<ResponseModel> login({String? phone, String? password, bool customerVerification = false, bool alreadyInApp = false});
  String getUserCountryCode();
  String getUserNumber();
  String getUserPassword();
  void saveUserNumberAndPassword(String number, String password, String countryCode);
  Future<bool> clearUserNumberAndPassword();
  Future<ResponseModel> guestLogin();
  // Future<void> loginWithSocialMedia(SocialLogInBodyModel socialLogInModel, {bool isCustomerVerificationOn = false});
  // Future<void> registerWithSocialMedia(SocialLogInBodyModel socialLogInModel, {bool isCustomerVerificationOn = false});
  Future<void> updateToken();
  void saveDmTipIndex(String i);
  String getDmTipIndex();
  bool isLoggedIn();
  String getGuestId();
  bool isGuestLoggedIn();
  Future<void> socialLogout();
  bool clearSharedData();
  bool setNotificationActive(bool isActive);
  bool isNotificationActive();
  String getUserToken();
  Future<void> saveGuestNumber(String number);
  String getGuestNumber();
}
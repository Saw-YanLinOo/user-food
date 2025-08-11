
import 'package:get/get_connect/http/src/response/response.dart';

import '../../interface/repo_interface.dart';
import '../model/response/response_model.dart';

abstract class AuthRepoInterface<SignUpModel> extends RepositoryInterface<SignUpModel>{

  Future<bool> saveUserToken(String token, {bool alreadyInApp = false});
  Future<Response> updateToken({String notificationDeviceToken = ''});
  Future<bool> clearGuestId();
  String getUserCountryCode();
  String getUserNumber();
  String getUserPassword();
  String getGuestId();
  Future<Response> registration(SignUpModel signUpModel);
  Future<Response> login({String? phone, String? password});
  Future<void> saveUserNumberAndPassword(String number, String password, String countryCode);
  Future<bool> clearUserNumberAndPassword();
  Future<ResponseModel> guestLogin();
  Future<bool> saveGuestId(String id);
  bool isGuestLoggedIn();
  // Future<Response> loginWithSocialMedia(SocialLogInBodyModel socialLogInModel);
  // Future<Response> registerWithSocialMedia(SocialLogInBodyModel socialLogInModel);
  Future<bool> saveDmTipIndex(String index);
  String getDmTipIndex();
  bool isLoggedIn();
  bool clearSharedData();
  bool isNotificationActive();
  void setNotificationActive(bool isActive);
  String getUserToken();
  Future<bool> saveGuestContactNumber(String number);
  String getGuestContactNumber();
}
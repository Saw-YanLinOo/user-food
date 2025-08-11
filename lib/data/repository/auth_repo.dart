import 'dart:async';
import 'dart:convert';

import 'package:user/controller/location_controller.dart';
import 'package:user/data/api/api_client.dart';
import 'package:user/data/model/body/business_plan_body.dart';
import 'package:user/data/model/body/delivery_man_body.dart';
import 'package:user/data/model/body/restaurant_body.dart';
import 'package:user/data/model/body/signup_body.dart';
import 'package:user/data/model/body/social_log_in_body.dart';
import 'package:user/data/model/response/address_model.dart';
import 'package:user/data/model/response/response_model.dart';
import 'package:user/util/app_constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_repo_interface.dart';

class AuthRepo implements AuthRepoInterface<SignUpBody> {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  AuthRepo({required this.apiClient, required this.sharedPreferences});

  @override
  Future<Response> registration(SignUpBody signUpBody) async {
    return await apiClient.postData(
        AppConstants.registerUri, signUpBody.toJson());
  }

  @override
  Future<Response> login({String? phone, String? password}) async {
    return await apiClient.postData(
        AppConstants.loginUri, {"phone": phone, "password": password});
  }

  Future<Response> loginWithSocialMedia(SocialLogInBody socialLogInBody) async {
    return await apiClient.postData(
        AppConstants.socialLoginUri, socialLogInBody.toJson());
  }

  Future<Response> registerWithSocialMedia(
      SocialLogInBody socialLogInBody) async {
    return await apiClient.postData(
        AppConstants.socialRegisterUri, socialLogInBody.toJson());
  }

  Future<bool> saveEarningPoint(String point) async {
    return await sharedPreferences.setString(AppConstants.earnPoint, point);
  }

  String getEarningPint() {
    return sharedPreferences.getString(AppConstants.earnPoint) ?? "";
  }

  @override
  Future<Response> updateToken({String notificationDeviceToken = ''}) async {
    String? deviceToken;
    if (notificationDeviceToken.isEmpty) {
      if (GetPlatform.isIOS && !GetPlatform.isWeb) {
        FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);
        NotificationSettings settings =
            await FirebaseMessaging.instance.requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,
        );
        if (settings.authorizationStatus == AuthorizationStatus.authorized) {
          deviceToken = await _saveDeviceToken();
        }
      } else {
        deviceToken = await _saveDeviceToken();
      }
      if (!GetPlatform.isWeb) {
        FirebaseMessaging.instance.subscribeToTopic(AppConstants.topic);
      }
    }
    return await apiClient.postData(AppConstants.tokenUri, {
      "_method": "put",
      "cm_firebase_token": notificationDeviceToken.isNotEmpty
          ? notificationDeviceToken
          : deviceToken
    });
  }

  Future<String?> _saveDeviceToken() async {
    String? deviceToken = '@';
    if (!GetPlatform.isWeb) {
      try {
        deviceToken = (await FirebaseMessaging.instance.getToken())!;
      } catch (_) {}
    }
    if (deviceToken != null) {
      debugPrint('--------Device Token---------- $deviceToken');
    }
    return deviceToken;
  }

  Future<Response> forgetPassword(String? phone) async {
    return await apiClient
        .postData(AppConstants.forgetPasswordUri, {"phone": phone});
  }

  Future<Response> verifyToken(String? phone, String token) async {
    return await apiClient.postData(
        AppConstants.verifyTokenUri, {"phone": phone, "reset_token": token});
  }

  Future<Response> resetPassword(String? resetToken, String number,
      String password, String confirmPassword) async {
    return await apiClient.postData(
      AppConstants.resetPasswordUri,
      {
        "_method": "put",
        "reset_token": resetToken,
        "phone": number,
        "password": password,
        "confirm_password": confirmPassword
      },
    );
  }

  Future<Response> checkEmail(String email) async {
    return await apiClient
        .postData(AppConstants.checkEmailUri, {"email": email});
  }

  Future<Response> verifyEmail(String email, String token) async {
    return await apiClient.postData(
        AppConstants.verifyEmailUri, {"email": email, "token": token});
  }

  Future<Response> updateZone() async {
    return await apiClient.getData(AppConstants.updateZoneUri);
  }

  Future<Response> verifyPhone(String? phone, String otp) async {
    return await apiClient
        .postData(AppConstants.verifyPhoneUri, {"phone": phone, "otp": otp});
  }

  // for  user token
  @override
  Future<bool> saveUserToken(String token, {bool alreadyInApp = false}) async {
    apiClient.token = token;
    if (alreadyInApp) {
      AddressModel? addressModel = AddressModel.fromJson(
          jsonDecode(sharedPreferences.getString(AppConstants.userAddress)!));
      apiClient.updateHeader(
        token,
        addressModel.zoneIds,
        sharedPreferences.getString(AppConstants.languageCode),
        addressModel.latitude,
        addressModel.longitude,
      );
    } else {
      apiClient.updateHeader(token, null,
          sharedPreferences.getString(AppConstants.languageCode), null, null);
    }

    return await sharedPreferences.setString(AppConstants.token, token);
  }

  @override
  String getUserToken() {
    return sharedPreferences.getString(AppConstants.token) ?? "";
  }

  @override
  bool isLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.token);
  }

  @override
  bool clearSharedData() {
    if (!GetPlatform.isWeb) {
      FirebaseMessaging.instance.unsubscribeFromTopic(AppConstants.topic);
      apiClient.postData(
          AppConstants.tokenUri, {"_method": "put", "cm_firebase_token": '@'});
    }
    sharedPreferences.remove(AppConstants.token);

    sharedPreferences.setStringList(AppConstants.cartList, []);
    sharedPreferences.remove(AppConstants.userAddress);
    apiClient.token = null;
    apiClient.updateHeader(null, null, null, null, null);
    return true;
  }

  // for  Remember Email
  @override
  Future<void> saveUserNumberAndPassword(
      String number, String password, String countryCode) async {
    try {
      await sharedPreferences.setString(AppConstants.userPassword, password);
      await sharedPreferences.setString(AppConstants.userNumber, number);
      await sharedPreferences.setString(
          AppConstants.userCountryCode, countryCode);
    } catch (e) {
      rethrow;
    }
  }

  @override
  String getUserNumber() {
    return sharedPreferences.getString(AppConstants.userNumber) ?? "";
  }

  @override
  String getUserCountryCode() {
    return sharedPreferences.getString(AppConstants.userCountryCode) ?? "";
  }

  @override
  String getUserPassword() {
    return sharedPreferences.getString(AppConstants.userPassword) ?? "";
  }

  @override
  bool isNotificationActive() {
    return sharedPreferences.getBool(AppConstants.notification) ?? true;
  }

  @override
  void setNotificationActive(bool isActive) {
    if (isActive) {
      updateToken();
    } else {
      if (!GetPlatform.isWeb) {
        updateToken(notificationDeviceToken: '@');
        FirebaseMessaging.instance.unsubscribeFromTopic(AppConstants.topic);
        if (isLoggedIn()) {
          FirebaseMessaging.instance.unsubscribeFromTopic(
              'zone_${Get.find<LocationController>().getUserAddress()!.zoneId}_customer');
        }
      }
    }
    sharedPreferences.setBool(AppConstants.notification, isActive);
  }

  @override
  Future<bool> clearUserNumberAndPassword() async {
    await sharedPreferences.remove(AppConstants.userPassword);
    await sharedPreferences.remove(AppConstants.userCountryCode);
    return await sharedPreferences.remove(AppConstants.userNumber);
  }

  bool clearSharedAddress() {
    sharedPreferences.remove(AppConstants.userAddress);
    return true;
  }

  Future<Response> getZoneList() async {
    return await apiClient.getData(AppConstants.zoneListUri);
  }

  Future<Response> registerRestaurant(
      RestaurantBody restaurant, XFile? logo, XFile? cover) async {
    return apiClient.postMultipartData(
      AppConstants.restaurantRegisterUri,
      restaurant.toJson(),
      [MultipartBody('logo', logo), MultipartBody('cover_photo', cover)],
    );
  }

  Future<Response> getPackageList() async {
    return await apiClient.getData(AppConstants.restaurantPackagesUri);
  }

  Future<Response> setUpBusinessPlan(BusinessPlanBody businessPlanBody) async {
    return await apiClient.postData(
        AppConstants.businessPlanUri, businessPlanBody.toJson());
  }

  Future<Response> registerDeliveryMan(
      DeliveryManBody deliveryManBody, List<MultipartBody> multiParts) async {
    return apiClient.postMultipartData(
        AppConstants.dmRegisterUri, deliveryManBody.toJson(), multiParts);
  }

  Future<Response> getVehicleList() async {
    return await apiClient.getData(AppConstants.vehiclesUri);
  }

  @override
  Future<bool> saveDmTipIndex(String index) async {
    return await sharedPreferences.setString(AppConstants.dmTipIndex, index);
  }

  @override
  String getDmTipIndex() {
    return sharedPreferences.getString(AppConstants.dmTipIndex) ?? "";
  }

  @override
  Future<bool> clearGuestId() async {
    return await sharedPreferences.remove(AppConstants.guestId);
  }

  @override
  bool isGuestLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.guestId);
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
  String getGuestContactNumber() {
    return sharedPreferences.getString(AppConstants.guestNumber) ?? "";
  }

  @override
  String getGuestId() {
    return sharedPreferences.getString(AppConstants.guestId) ?? "";
  }

  @override
  Future getList({int? offset}) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> guestLogin() async {
    Response response = await apiClient.postData(AppConstants.guestLoginUri, {},
        handleError: false);
    if (response.statusCode == 200) {
      saveGuestId(response.body['guest_id'].toString());
      return ResponseModel(true, '${response.body['guest_id']}');
    } else {
      return ResponseModel(false, response.statusText);
    }
  }

  @override
  Future<bool> saveGuestId(String id) async {
    return await sharedPreferences.setString(AppConstants.guestId, id);
  }

  @override
  Future update(Map<String, dynamic> body, int? id) {
    throw UnimplementedError();
  }

  @override
  Future<Response> add(SignUpBody signUpModel) async {
    throw UnimplementedError();
  }

  @override
  Future<bool> saveGuestContactNumber(String number) async {
    return await sharedPreferences.setString(AppConstants.guestNumber, number);
  }
}

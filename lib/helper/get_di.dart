
import 'dart:convert';

import 'package:user/controller/auth_controller.dart';
import 'package:user/controller/banner_controller.dart';
import 'package:user/controller/campaign_controller.dart';
import 'package:user/controller/cart_controller.dart';
import 'package:user/controller/category_controller.dart';
import 'package:user/controller/chat_controller.dart';
import 'package:user/controller/coupon_controller.dart';
import 'package:user/controller/cuisine_controller.dart';
import 'package:user/controller/localization_controller.dart';
import 'package:user/controller/location_controller.dart';
import 'package:user/controller/notification_controller.dart';
import 'package:user/controller/onboarding_controller.dart';
import 'package:user/controller/order_controller.dart';
import 'package:user/controller/product_controller.dart';
import 'package:user/controller/restaurant_controller.dart';
import 'package:user/controller/search_controller.dart';
import 'package:user/controller/splash_controller.dart';
import 'package:user/controller/theme_controller.dart';
import 'package:user/controller/user_controller.dart';
import 'package:user/controller/wallet_controller.dart';
import 'package:user/controller/wishlist_controller.dart';
import 'package:user/data/repository/auth_repo.dart';
import 'package:user/data/repository/banner_repo.dart';
import 'package:user/data/repository/campaign_repo.dart';
import 'package:user/data/repository/cart_repo.dart';
import 'package:user/data/repository/category_repo.dart';
import 'package:user/data/repository/chat_repo.dart';
import 'package:user/data/repository/coupon_repo.dart';
import 'package:user/data/repository/cuisine_repo.dart';
import 'package:user/data/repository/language_repo.dart';
import 'package:user/data/repository/location_repo.dart';
import 'package:user/data/repository/notification_repo.dart';
import 'package:user/data/repository/onboarding_repo.dart';
import 'package:user/data/repository/order_repo.dart';
import 'package:user/data/repository/product_repo.dart';
import 'package:user/data/repository/restaurant_repo.dart';
import 'package:user/data/repository/search_repo.dart';
import 'package:user/data/repository/splash_repo.dart';
import 'package:user/data/api/api_client.dart';
import 'package:user/data/repository/user_repo.dart';
import 'package:user/data/repository/wallet_repo.dart';
import 'package:user/data/repository/wishlist_repo.dart';
import 'package:user/util/app_constants.dart';
import 'package:user/data/model/response/language_model.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

import '../data/repository/auth_repo_interface.dart';
import '../view/screens/auth/service/auth_repo_interface.dart';
import '../view/screens/auth/service/auth_service.dart';

Future<Map<String, Map<String, String>>> init() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);
  Get.lazyPut(() => ApiClient(appBaseUrl: AppConstants.baseUrl, sharedPreferences: Get.find()));

  // Repository
  Get.lazyPut(() => SplashRepo(sharedPreferences: Get.find(), apiClient: Get.find()));
  Get.lazyPut(() => LanguageRepo());
  Get.lazyPut(() => OnBoardingRepo());
  Get.lazyPut(() => AuthRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => LocationRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => UserRepo(apiClient: Get.find()));
  Get.lazyPut(() => BannerRepo(apiClient: Get.find()));
  Get.lazyPut(() => CategoryRepo(apiClient: Get.find()));
  Get.lazyPut(() => RestaurantRepo(sharedPreferences: Get.find(), apiClient: Get.find()));
  Get.lazyPut(() => WishListRepo(apiClient: Get.find()));
  Get.lazyPut(() => ProductRepo(apiClient: Get.find()));
  Get.lazyPut(() => CartRepo(sharedPreferences: Get.find()));
  Get.lazyPut(() => SearchRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => CouponRepo(apiClient: Get.find()));
  Get.lazyPut(() => OrderRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => NotificationRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => CampaignRepo(apiClient: Get.find()));
  Get.lazyPut(() => WalletRepo(apiClient: Get.find()));
  Get.lazyPut(() => ChatRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => CuisineRepo(apiClient: Get.find()));

  // Controller
  Get.lazyPut(() => ThemeController(sharedPreferences: Get.find()));
  Get.lazyPut(() => SplashController(splashRepo: Get.find()));
  Get.lazyPut(() => LocalizationController(sharedPreferences: Get.find(), apiClient: Get.find()));
  Get.lazyPut(() => OnBoardingController(onboardingRepo: Get.find()));
  Get.lazyPut(() => AuthController(authRepo: Get.find(), authServiceInterface: Get.find()));
  Get.lazyPut(() => LocationController(locationRepo: Get.find()));
  Get.lazyPut(() => UserController(userRepo: Get.find()));
  Get.lazyPut(() => BannerController(bannerRepo: Get.find()));
  Get.lazyPut(() => CategoryController(categoryRepo: Get.find()));
  Get.lazyPut(() => ProductController(productRepo: Get.find()));
  Get.lazyPut(() => CartController(cartRepo: Get.find()));
  Get.lazyPut(() => RestaurantController(restaurantRepo: Get.find()));
  Get.lazyPut(() => WishListController(wishListRepo: Get.find(), productRepo: Get.find()));
  Get.lazyPut(() => SearchController(searchRepo: Get.find()));
  Get.lazyPut(() => CouponController(couponRepo: Get.find()));
  Get.lazyPut(() => OrderController(orderRepo: Get.find()));
  Get.lazyPut(() => NotificationController(notificationRepo: Get.find()));
  Get.lazyPut(() => CampaignController(campaignRepo: Get.find()));
  Get.lazyPut(() => WalletController(walletRepo: Get.find()));
  Get.lazyPut(() => ChatController(chatRepo: Get.find()));
  Get.lazyPut(() => CuisineController(cuisineRepo: Get.find()));
  AuthRepoInterface authRepoInterface = AuthRepo(apiClient: Get.find(), sharedPreferences: Get.find());
  Get.lazyPut(() => authRepoInterface);
  AuthServiceInterface authServiceInterface = AuthService(authRepoInterface: Get.find());
  Get.lazyPut(() => authServiceInterface);

  // Retrieving localized data
  Map<String, Map<String, String>> languages = {};
  for(LanguageModel languageModel in AppConstants.languages) {
    String jsonStringValues =  await rootBundle.loadString('assets/language/${languageModel.languageCode}.json');
    Map<String, dynamic> mappedJson = jsonDecode(jsonStringValues);
    Map<String, String> json = {};
    mappedJson.forEach((key, value) {
      json[key] = value.toString();
    });
    languages['${languageModel.languageCode}_${languageModel.countryCode}'] = json;
  }
  return languages;
}

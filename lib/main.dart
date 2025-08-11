
import 'dart:io';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:user/controller/auth_controller.dart';
import 'package:user/controller/cart_controller.dart';
import 'package:user/controller/localization_controller.dart';
import 'package:user/controller/splash_controller.dart';
import 'package:user/controller/theme_controller.dart';
import 'package:user/controller/wishlist_controller.dart';
import 'package:user/data/model/body/deep_link_body.dart';
import 'package:user/data/model/body/notification_body.dart';
import 'package:user/helper/notification_helper.dart';
import 'package:user/helper/responsive_helper.dart';
import 'package:user/helper/route_helper.dart';
import 'package:user/theme/dark_theme.dart';
import 'package:user/theme/light_theme.dart';
import 'package:user/util/app_constants.dart';
import 'package:user/util/messages.dart';
import 'package:user/view/base/cookies_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import 'firebase_options.dart';
import 'helper/get_di.dart' as di;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  if (ResponsiveHelper.isMobilePhone()) {
    HttpOverrides.global = MyHttpOverrides();
  }
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();

  DeepLinkBody? linkBody;
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  Map<String, Map<String, String>> languages = await di.init();

  NotificationBody? body;
  try {
    if (GetPlatform.isMobile) {
      final RemoteMessage? remoteMessage =
          await FirebaseMessaging.instance.getInitialMessage();
      if (remoteMessage != null) {
        
        body = NotificationHelper.convertNotification(remoteMessage.data);
      }else{
       
      }
      await NotificationHelper.initialize(flutterLocalNotificationsPlugin);
      FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
    }
  } catch (_) {}

  runApp(MyApp(languages: languages, body: body, linkBody: linkBody));
}

class MyApp extends StatelessWidget {
  final Map<String, Map<String, String>>? languages;
  final NotificationBody? body;
  final DeepLinkBody? linkBody;
  const MyApp(
      {super.key,
      required this.languages,
      required this.body,
      required this.linkBody});

  void _route() {
    Get.find<SplashController>().getConfigData().then((bool isSuccess) async {
      if (isSuccess) {
        if (Get.find<AuthController>().isLoggedIn()) {
          Get.find<AuthController>().updateToken();
          await Get.find<WishListController>().getWishList();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (GetPlatform.isWeb) {
      Get.find<SplashController>().initSharedData();
      Get.find<CartController>().getCartData();
      _route();
    }

    return ScreenUtilInit(
        designSize: const Size(360, 690),
    minTextAdapt: true,
    splitScreenMode: true,
    builder: (_, child) {

         return GetBuilder<ThemeController>(builder: (themeController)
     {
      return GetBuilder<LocalizationController>(builder: (localizeController) {
        return GetBuilder<SplashController>(builder: (splashController) {
          return (GetPlatform.isWeb && splashController.configModel == null)
              ? const SizedBox()
              : GetMaterialApp(
                  title: AppConstants.appName,
                  debugShowCheckedModeBanner: false,
                  navigatorKey: Get.key,
                  scrollBehavior: const MaterialScrollBehavior().copyWith(
                    dragDevices: {
                      PointerDeviceKind.mouse,
                      PointerDeviceKind.touch
                    },
                  ),
                  theme: themeController.darkTheme ? dark : light,
                  locale: localizeController.locale,
                  translations: Messages(languages: languages),
                  fallbackLocale: Locale(
                      AppConstants.languages[0].languageCode!,
                      AppConstants.languages[0].countryCode),
                  initialRoute: GetPlatform.isWeb
                      ? RouteHelper.getInitialRoute()
                      : RouteHelper.getSplashRoute(body, linkBody),
                  getPages: RouteHelper.routes,
                  defaultTransition: Transition.topLevel,
                  transitionDuration: const Duration(milliseconds: 500),
                  builder: (BuildContext context, widget) => Material(
                    child: Stack(children: [
                      widget!,
                      GetBuilder<SplashController>(builder: (splashController) {
                        if (splashController.savedCookiesData &&
                            splashController.getAcceptCookiesStatus(
                                splashController.configModel!.cookiesText!)) {
                          return ResponsiveHelper.isWeb()
                              ? const Align(
                                  alignment: Alignment.bottomCenter,
                                  child: CookiesView())
                              : const SizedBox();
                        } else {
                          return const SizedBox();
                        }
                      })
                    ]),
                  ),
                );
        });
      });
    });
  });}
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

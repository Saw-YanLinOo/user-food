import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:user/controller/auth_controller.dart';
import 'package:user/controller/cart_controller.dart';
import 'package:user/controller/location_controller.dart';
import 'package:user/controller/splash_controller.dart';
import 'package:user/controller/wishlist_controller.dart';
import 'package:user/data/model/body/deep_link_body.dart';
import 'package:user/data/model/body/notification_body.dart';
import 'package:user/helper/route_helper.dart';
import 'package:user/util/app_constants.dart';
import 'package:user/util/dimensions.dart';
import 'package:user/util/images.dart';
import 'package:user/view/base/no_internet_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/view/screens/choose_option/choose_option_screen.dart';

class SplashScreen extends StatefulWidget {
  final NotificationBody? notificationBody;
  final DeepLinkBody? linkBody;
  const SplashScreen(
      {super.key, required this.notificationBody, required this.linkBody});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  late StreamSubscription<List<ConnectivityResult>> _onConnectivityChanged;

  @override
  void initState() {
    super.initState();

    bool firstTime = true;
    _onConnectivityChanged = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      if (!firstTime) {
        bool isNotConnected = !result.contains(ConnectivityResult.wifi) &&
    !result.contains(ConnectivityResult.mobile);

        isNotConnected
            ? const SizedBox()
            : ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: isNotConnected ? Colors.red : Colors.green,
          duration: Duration(seconds: isNotConnected ? 6000 : 3),
          content: Text(
            isNotConnected ? 'no_connection'.tr : 'connected'.tr,
            textAlign: TextAlign.center,
          ),
        ));
        if (!isNotConnected) {
          _route();
        }
      }
      firstTime = false;
    });

    Get.find<SplashController>().initSharedData();
    if (Get.find<LocationController>().getUserAddress() != null &&
        (Get.find<LocationController>().getUserAddress()!.zoneIds == null ||
            Get.find<LocationController>().getUserAddress()!.zoneData ==
                null)) {
      Get.find<AuthController>().clearSharedAddress();
    }
    Get.find<CartController>().getCartData();
    _route();
  }

  @override
  void dispose() {
    super.dispose();

    _onConnectivityChanged.cancel();
  }

  void _route() {
    Get.find<SplashController>().getConfigData().then((isSuccess) {
      if (isSuccess) {
        Timer(const Duration(seconds: 1), () async {
          double? minimumVersion = 0;
          if (GetPlatform.isAndroid) {
            minimumVersion = Get.find<SplashController>()
                .configModel!
                .appMinimumVersionAndroid;
          } else if (GetPlatform.isIOS) {
            minimumVersion =
                Get.find<SplashController>().configModel!.appMinimumVersionIos;
          }
          if (AppConstants.appVersion < minimumVersion! ||
              Get.find<SplashController>().configModel!.maintenanceMode!) {
            Get.offNamed(RouteHelper.getUpdateRoute(
                AppConstants.appVersion < minimumVersion));
          } else {
            if (widget.notificationBody != null && widget.linkBody == null) {
              if (widget.notificationBody!.notificationType ==
                  NotificationType.order) {
                Get.offNamed(RouteHelper.getOrderDetailsRoute(
                    widget.notificationBody!.orderId));
              } else if (widget.notificationBody!.notificationType ==
                  NotificationType.general) {
                Get.offNamed(
                    RouteHelper.getNotificationRoute(fromNotification: true));
              } else {
                Get.offNamed(RouteHelper.getChatRoute(
                    notificationBody: widget.notificationBody,
                    conversationID: widget.notificationBody!.conversationId));
              }
            } /*else if(widget.linkBody != null && widget.notificationBody == null){
              if(widget.linkBody.deepLinkType == DeepLinkType.restaurant){
                Get.toNamed(RouteHelper.getRestaurantRoute(widget.linkBody.id));
              }else if(widget.linkBody.deepLinkType == DeepLinkType.category){
                Get.toNamed(RouteHelper.getCategoryProductRoute(widget.linkBody.id, widget.linkBody.name));
              }else if(widget.linkBody.deepLinkType == DeepLinkType.cuisine){
                Get.toNamed(RouteHelper.getCuisineRestaurantRoute(widget.linkBody.id));
              }
            }*/
            else {
              if (Get.find<AuthController>().isLoggedIn() 
                  ) {
                Get.find<AuthController>().updateToken();
                await Get.find<WishListController>().getWishList();
                if (Get.find<LocationController>().getUserAddress() != null) {
                  Get.offAll(()=>ChooseOptionScreen());
                 // Get.offNamed(RouteHelper.getInitialRoute(fromSplash: true));
                } else {
                  Get.offNamed(RouteHelper.getAccessLocationRoute('splash'));
                }
              } else {
                if (Get.find<SplashController>().showIntro()!) {
                  Get.offNamed(RouteHelper.getOnBoardingRoute());
                  // if (AppConstants.languages.length > 1) {
                  //   Get.offNamed(RouteHelper.getLanguageRoute('splash'));
                  // } else {
                  //   Get.offNamed(RouteHelper.getOnBoardingRoute());
                  // }
                } else {
                  Get.offNamed(RouteHelper.getSignInRoute(RouteHelper.splash));
                }
              }
            }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 235, 12, 12),
      key: _globalKey,
      body: GetBuilder<SplashController>(builder: (splashController) {
        return Center(
          child: splashController.hasConnection
              ? Stack(
                  //  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.center,
                          end: Alignment.bottomCenter,
                          // transform: GradientRotation(8),
                          colors: [
                            Color(0xFFff0023),
                            Color(0xFFff0023),
                            Color(0xFFff0023),
                            Color(0xFFff0023),
                            // Color(0xFFff4200),
                            // Color(0xFFf97070),
                          ],
                        ),
                      ),
                      child: Center(
                        child: Image.asset(
                          Images.splashLogo,
                          width: MediaQuery.of(context).size.width / 3,
                          height: MediaQuery.of(context).size.height / 3,
                        ),
                      ),
                    ),

                    const SizedBox(height: Dimensions.paddingSizeLarge),
                    // Image.asset(Images.logoName, width: 150),

                    /*SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
            Text(AppConstants.APP_NAME, style: robotoMedium.copyWith(fontSize: 25)),*/
                  ],
                )
              : NoInternetScreen(
                  child: SplashScreen(
                      notificationBody: widget.notificationBody,
                      linkBody: widget.linkBody)),
        );
      }),
    );
  }
}

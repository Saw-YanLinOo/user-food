import 'package:user/controller/auth_controller.dart';
import 'package:user/controller/wishlist_controller.dart';
import 'package:user/helper/route_helper.dart';
import 'package:user/view/base/custom_snackbar.dart';
import 'package:get/get.dart';

class ApiChecker {
  static void checkApi(Response response) {
    if(response.statusCode == 401) {
      Get.find<AuthController>().clearSharedData();
      Get.find<WishListController>().removeWishes();
      Get.offAllNamed(GetPlatform.isWeb ? RouteHelper.getInitialRoute() : RouteHelper.getSplashRoute(null, null));
      // Get.offAllNamed(RouteHelper.getSignInRoute(RouteHelper.splash));
    }else {
      showCustomSnackBar(response.statusText);
    }
  }
}

import 'dart:async';

import 'package:user/controller/auth_controller.dart';
import 'package:user/controller/location_controller.dart';
import 'package:user/controller/order_controller.dart';
import 'package:user/controller/restaurant_controller.dart';
import 'package:user/controller/splash_controller.dart';
import 'package:user/data/model/response/order_model.dart';
import 'package:user/helper/responsive_helper.dart';
import 'package:user/helper/route_helper.dart';
import 'package:user/util/dimensions.dart';
import 'package:user/view/base/cart_widget.dart';
import 'package:user/view/base/custom_dialog.dart';
import 'package:user/view/screens/cart/cart_screen.dart';
import 'package:user/view/screens/checkout/widget/congratulation_dialogue.dart';
import 'package:user/view/screens/dashboard/widget/bottom_nav_item.dart';
import 'package:user/view/screens/dashboard/widget/running_order_view_widget.dart';
import 'package:user/view/screens/favourite/favourite_screen.dart';
import 'package:user/view/screens/home/home_screen.dart';
import 'package:user/view/screens/menu/menu_screen_new.dart';
import 'package:user/view/screens/order/order_screen.dart';
import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../controller/banner_controller.dart';
import 'dart:ui';

class DashboardScreen extends StatefulWidget {
  final int pageIndex;
  final bool fromSplash;
  const DashboardScreen({
    super.key,
    required this.pageIndex,
    this.fromSplash = false,
  });

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  PageController? _pageController;
  int _pageIndex = 0;
  late List<Widget> _screens;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
  bool _canExit = GetPlatform.isWeb ? true : false;
  late bool _isLogin;
  bool active = false;
  final bool _hasShownAddressBottomSheet = false;

  @override
  void initState() {
    super.initState();
    _isLogin = Get.find<AuthController>().isLoggedIn();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (Get.find<LocationController>().showPopUpBanner == true) {
        await Get.find<BannerController>().getPopUpBannerList(true, false);
        Get.find<BannerController>().popupBannerStatus == "1"
            ? showPopUpBanner()
            : const SizedBox();
      }

      if (mounted) {
        if (widget.fromSplash &&
            Get.find<LocationController>().showLocationSuggestion) {
          Get.offAllNamed(RouteHelper.getAccessLocationRoute('home'));
        }
      }
    });
    if (_isLogin) {
      if (_hasShownAddressBottomSheet) {
        return; // Exit if already called
      }
      if (Get.find<SplashController>().configModel!.loyaltyPointStatus == 1 &&
          Get.find<AuthController>().getEarningPint().isNotEmpty &&
          !ResponsiveHelper.isDesktop(Get.context)) {
        Future.delayed(
          const Duration(seconds: 1),
          () => showAnimatedDialog(context, const CongratulationDialogue()),
        );
      }

      Get.find<OrderController>().getRunningOrders(1);
    }

    _pageIndex = widget.pageIndex;

    _pageController = PageController(initialPage: widget.pageIndex);

    _screens = [
      const HomeScreen(),
      const FavouriteScreen(),
      CartScreen(
        fromNav: true,
        tableId: Get.find<RestaurantController>().tableId.toString(),
      ),
      const OrderScreen(),
      const MenuScreenNew(),
    ];

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {});
    });

    /*if(GetPlatform.isMobile) {
      NetworkInfo.checkConnectivity(_scaffoldKey.currentContext);
    }*/
  }

  void showPopUpBanner() async {
    final BuildContext localContext = context;

    await precacheImage(
      NetworkImage(
        "https://momo.softedify.vip/storage/app/public/banner/${Get.find<BannerController>().popupBannerImage}",
      ),
      localContext,
    );

    if (!mounted) return;
    showDialog(
      context: localContext,
      builder: (BuildContext context) {
        return InkWell(
          onTap: () {
            _launchURL(
              Uri.parse(
                Get.find<BannerController>().popupBannerLink.toString(),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 150),
            child: Container(
              decoration: BoxDecoration(
                //   color: const Color(0xFFf0e6d1),
                borderRadius: BorderRadius.circular(30),
                image: DecorationImage(
                  image: NetworkImage(
                    "https://momo.softedify.vip/storage/app/public/banner/${Get.find<BannerController>().popupBannerImage}",
                  ),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    child: GestureDetector(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          // Adjust color and opacity as needed
                        ),
                        child: Icon(
                          Icons.close,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _launchURL(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_pageIndex != 0) {
          _setPage(0);
          return false;
        } else {
          if (_canExit) {
            return true;
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'back_press_again_to_exit'.tr,
                  style: const TextStyle(color: Colors.white),
                ),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
                margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              ),
            );
            _canExit = true;
            Timer(const Duration(seconds: 2), () {
              _canExit = false;
            });
            return false;
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        
        key: _scaffoldKey,
        // floatingActionButton: GetBuilder<OrderController>(
        //   builder: (orderController) {
        //     return ResponsiveHelper.isDesktop(context)
        //         ? const SizedBox()
        //         : (orderController.showBottomSheet &&
        //             orderController.runningOrderList != null &&
        //             orderController.runningOrderList!.isNotEmpty)
        //         ? const SizedBox.shrink()
        //         : FloatingActionButton(
        //           elevation: 5,
        //           backgroundColor:
        //               _pageIndex == 2
        //                   ? Theme.of(context).primaryColor
        //                   : Theme.of(context).cardColor,
        //           onPressed: () {
        //             // _setPage(2);
        //             Get.toNamed(RouteHelper.getCartRoute());
        //           },
        //           child: CartWidget(
        //             color:
        //                 _pageIndex == 2
        //                     ? Theme.of(context).cardColor
        //                     : Theme.of(context).disabledColor,
        //             size: 30,
        //           ),
        //         );
        //   },
        // ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: Stack(
          children: [
            // Main content
            GetBuilder<OrderController>(
              builder: (orderController) {
                List<OrderModel> runningOrder =
                    orderController.runningOrderList != null
                        ? orderController.runningOrderList!
                        : [];

                List<OrderModel> reversOrder = List.from(runningOrder.reversed);
                return ExpandableBottomSheet(
                  background: PageView.builder(
                    controller: _pageController,
                    itemCount: _screens.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return _screens[index];
                    },
                  ),
                  persistentContentHeight: 100,
                  onIsContractedCallback: () {
                    if (!orderController.showOneOrder) {
                      orderController.showOrders();
                    }
                  },
                  onIsExtendedCallback: () {
                    if (orderController.showOneOrder) {
                      orderController.showOrders();
                    }
                  },
                  enableToggle: true,
                  expandableContent:
                      (ResponsiveHelper.isDesktop(context) ||
                              !_isLogin ||
                              orderController.runningOrderList == null ||
                              orderController.runningOrderList!.isEmpty ||
                              !orderController.showBottomSheet)
                          ? const SizedBox()
                          : Dismissible(
                            key: UniqueKey(),
                            onDismissed: (direction) {
                              if (orderController.showBottomSheet) {
                                orderController.showRunningOrders();
                              }
                            },
                            child: RunningOrderViewWidget(
                              reversOrder: reversOrder,
                              onMoreClick: () {
                                if (orderController.showBottomSheet) {
                                  orderController.showRunningOrders();
                                }
                                _setPage(3);
                              },
                            ),
                          ),
                );
              },
            ),
            // Custom bottom nav bar overlay
            if (!ResponsiveHelper.isDesktop(context))
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: GetBuilder<OrderController>(
                  builder: (orderController) {
                    return (orderController.showBottomSheet &&
                            (orderController.runningOrderList != null &&
                                orderController.runningOrderList!.isNotEmpty))
                        ? const SizedBox()
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(32.0),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Frosted glass blur
                                  BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                                    child: Container(
                                      height: 70,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(32.0),
                                        border: Border.all(
                                          color: Colors.grey.withOpacity(0.5),
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Custom nav bar content
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Row(
                                      children: [
                                        BottomNavItem(
                                          iconData: Icons.home,
                                          isSelected: _pageIndex == 0,
                                          onTap: () => _setPage(0),
                                        ),
                                        BottomNavItem(
                                          iconData: Icons.favorite_border,
                                          isSelected: _pageIndex == 1,
                                          onTap: () => _setPage(1),
                                        ),
                                       // const Expanded(child: SizedBox()),
                                        BottomNavItem(
                                          iconData: Icons.shopping_bag,
                                          isSelected: _pageIndex == 3,
                                          onTap: () => _setPage(3),
                                        ),
                                        BottomNavItem(
                                          iconData: Icons.menu,
                                          isSelected: _pageIndex == 4,
                                          onTap: () => _setPage(4),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _setPage(int pageIndex) {
    setState(() {
      _pageController!.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
    });
  }

  canLaunchUrl(Uri url) {}
}

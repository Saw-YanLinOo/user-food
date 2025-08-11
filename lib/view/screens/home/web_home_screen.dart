import 'package:user/controller/auth_controller.dart';
import 'package:user/controller/banner_controller.dart';
import 'package:user/controller/splash_controller.dart';
import 'package:user/data/model/response/config_model.dart';
import 'package:user/util/dimensions.dart';
import 'package:user/view/base/productFooterView.dart';
import 'package:user/view/screens/home/web/web_new/web_cuisine_view.dart';
import 'package:user/view/screens/home/web/web_new/web_new_on_momofood_view.dart';
import 'package:user/view/screens/home/widget/combined_widgets/all_discount_product_screen.dart';
import 'package:user/view/screens/home/widget/combined_widgets/all_products.dart';

import 'package:user/view/screens/home/widget/combined_widgets/all_restaurant_screen.dart';

import 'package:user/view/screens/home/widget/combined_widgets/best_review_item_view.dart';
import 'package:user/view/screens/home/widget/combined_widgets/enjoy_off_banner_view.dart';
import 'package:user/view/screens/home/web/web_new/web_loaction_and_refer_banner_view.dart';
import 'package:user/view/screens/home/widget/combined_widgets/order_again_view.dart';
import 'package:user/view/screens/home/widget/combined_widgets/popular_foods_nearby_view.dart';
import 'package:user/view/screens/home/widget/combined_widgets/popular_restaurants_view.dart';
import 'package:user/view/screens/home/widget/combined_widgets/restaurant_filter_screen.dart';
import 'package:user/view/screens/home/widget/combined_widgets/today_trends_view.dart';
import 'package:user/view/screens/home/web/web_banner_view.dart';

import 'package:user/view/screens/home/widget/combined_widgets/web_featured_product_screen.dart';
import 'package:user/view/screens/home/widget/combined_widgets/what_on_your_mind_view.dart';
import 'package:user/view/screens/home/widget/bad_weather_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WebHomeScreen extends StatefulWidget {
  final ScrollController scrollController;
  const WebHomeScreen({super.key, required this.scrollController});

  @override
  State<WebHomeScreen> createState() => _WebHomeScreenState();
}

class _WebHomeScreenState extends State<WebHomeScreen> {
  ConfigModel? _configModel;

  @override
  void initState() {
    super.initState();
    Get.find<BannerController>().setCurrentIndex(0, false);
    _configModel = Get.find<SplashController>().configModel;
  }

  @override
  Widget build(BuildContext context) {
    bool isLogin = Get.find<AuthController>().isLoggedIn();
    final ScrollController scrollController = ScrollController();
    return CustomScrollView(
      controller: widget.scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        const SliverToBoxAdapter(
          child: Center(
            child: SizedBox(
                width: Dimensions.webMaxWidth, child: WhatOnYourMindView()),
          ),
        ),
        SliverToBoxAdapter(
            child: GetBuilder<BannerController>(builder: (bannerController) {
          return bannerController.bannerImageList == null
              ? WebBannerView(bannerController: bannerController)
              : bannerController.bannerImageList!.isEmpty
                  ? const SizedBox()
                  : WebBannerView(bannerController: bannerController);
        })),
        SliverToBoxAdapter(
            child: Center(
                child: SizedBox(
          width: Dimensions.webMaxWidth,
          child: Column(children: [
            const BadWeatherWidget(),

            isLogin?const TodayTrendsView():const SizedBox(),

            isLogin ? const OrderAgainView() : const SizedBox(),

            _configModel!.popularFood == 1
                ? const BestReviewItemView(isPopular: false)
                : const SizedBox(),

            const WebCuisineView(),
            // const FeaturedProductScreen(),
            const WebFeaturedProductView(),
            const PopularRestaurantsView(),

            const PopularFoodNearbyView(),
             const AllDiscountProductScreen(),

            isLogin
                ? const PopularRestaurantsView(isRecentlyViewed: true)
                : const SizedBox(),

            const WebLocationAndReferBannerView(),
            //const WebDiscountedProductView(),
            _configModel!.newRestaurant == 1
                ? const WebNewOnMOMOFoodView(isLatest: true)
                : const SizedBox(),

            const PromotionalBannerView(),
          
            const SizedBox(width: Dimensions.paddingSizeExtraSmall),

            // _configModel!.popularRestaurant == 1 ? const WebPopularRestaurantView(isPopular: true) : const SizedBox(),

            // const SizedBox(height: Dimensions.paddingSizeSmall),
            // const WebCampaignView(),

            //const WebCuisineView(),

            // _configModel!.popularFood == 1 ? const WebPopularFoodView(isPopular: true) : const SizedBox(),

            // isLogin ? const WebPopularRestaurantView(isPopular: false) : const SizedBox(),

            // _configModel!.newRestaurant == 1 ? const WebPopularRestaurantView(isPopular: false) : const SizedBox(),

            // _configModel!.mostReviewedFoods == 1 && isLogin ? const WebPopularRestaurantView(isPopular: false, isRecentlyViewed: true) : const SizedBox(),
          ]),
        ))),
        SliverPersistentHeader(
          pinned: true,
          delegate: SliverDelegate(
height: MediaQuery.of(context).size.height/12,
            child: const RestaurantFilterScreen(),
          ),
        ),
        const SliverToBoxAdapter(child: Center(child: AllRestaurantScreen())),
        SliverToBoxAdapter(
            child: Center(
                child: 
                ProductFooterView(
                  child: AllProducts(
                          scrollController: scrollController,
                        ),
                ))),
      ],
    );
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;
  double height;
  SliverDelegate({required this.child,this.height=50});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != height ||
        oldDelegate.minExtent != height ||
        child != oldDelegate.child;
  }
}

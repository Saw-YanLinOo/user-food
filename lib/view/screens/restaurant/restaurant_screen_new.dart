import 'dart:developer';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user/controller/auth_controller.dart';
import 'package:user/controller/cart_controller.dart';
import 'package:user/controller/category_controller.dart';
import 'package:user/controller/localization_controller.dart';
import 'package:user/controller/restaurant_controller.dart';
import 'package:user/controller/splash_controller.dart';
import 'package:user/controller/wishlist_controller.dart';
import 'package:user/data/model/response/category_model.dart';
import 'package:user/data/model/response/product_model.dart';
import 'package:user/data/model/response/restaurant_model.dart';
import 'package:user/helper/date_converter.dart';
import 'package:user/helper/price_converter.dart';
import 'package:user/helper/responsive_helper.dart';
import 'package:user/helper/route_helper.dart';
import 'package:user/util/dimensions.dart';
import 'package:user/util/images.dart';
import 'package:user/util/styles.dart';
import 'package:user/view/base/bottom_cart_widget.dart';
import 'package:user/view/base/custom_image.dart';
import 'package:user/view/base/custom_snackbar.dart';
import 'package:user/view/base/product_view.dart';
import 'package:user/view/base/product_widget.dart';
import 'package:user/view/base/veg_filter_widget.dart';
import 'package:user/view/base/web_menu_bar.dart';
import 'package:user/view/screens/restaurant/widget/customizable_space_bar.dart';
import 'package:user/view/screens/restaurant/widget/restaurant_description_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/view/widgets/custom_text.dart';

import '../../../controller/order_controller.dart';

class RestaurantScreenNew extends StatefulWidget {
  final Restaurant? restaurant;
  final String? tableId;
  const RestaurantScreenNew({super.key, this.restaurant, this.tableId});

  @override
  State<RestaurantScreenNew> createState() => _RestaurantScreenNewState();
}

class _RestaurantScreenNewState extends State<RestaurantScreenNew> {
  final ScrollController scrollController = ScrollController();
  double _fabTop = 100.0; // Initial top position
  double _fabLeft = 10.0; // Initial left position
  @override
  void initState() {
    super.initState();
    log("${widget.tableId} rest scr");
    Get.find<RestaurantController>().tableId.value = widget.tableId;
    Get.find<RestaurantController>()
        .getRestaurantDetails(Restaurant(id: widget.restaurant!.id));
    if (Get.find<CategoryController>().categoryList == null) {
      Get.find<CategoryController>().getCategoryList(true);
    }
    Get.find<RestaurantController>()
        .getRestaurantRecommendedItemList(widget.restaurant!.id, false);
    Get.find<RestaurantController>()
        .getRestaurantProductList(widget.restaurant!.id, 1, 'all', false);
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent &&
          Get.find<RestaurantController>().restaurantProducts != null &&
          !Get.find<RestaurantController>().foodPaginate) {
        int pageSize =
        (Get.find<RestaurantController>().foodPageSize! / 10).ceil();
        if (Get.find<RestaurantController>().foodOffset < pageSize) {
          Get.find<RestaurantController>()
              .setFoodOffset(Get.find<RestaurantController>().foodOffset + 1);
          debugPrint('end of the page');
          Get.find<RestaurantController>().showFoodBottomLoader();
          Get.find<RestaurantController>().getRestaurantProductList(
            widget.restaurant!.id,
            Get.find<RestaurantController>().foodOffset,
            Get.find<RestaurantController>().type,
            false,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2B1818),
      body: SafeArea(
        child:
    GetBuilder<RestaurantController>(builder: (restController) {
    return GetBuilder<CategoryController>(builder: (categoryController) {
    Restaurant? restaurant;
    if (restController.restaurant != null &&
    restController.restaurant!.name != null &&
    categoryController.categoryList != null) {
    restaurant = restController.restaurant;
    }
    restController.setCategoryList();

    return (restController.restaurant != null &&
    restController.restaurant!.name != null &&
    categoryController.categoryList != null)
    ?
        CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: 360, // increased to fit overlay card and avatar
              backgroundColor: const Color(0xFF2B1818),
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.black.withOpacity(0.4),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.favorite_border, color: Colors.red),
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Header image
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32),
                      ),
                      child: Image.asset(
                        '${Get.find<SplashController>().configModel!.baseUrls!.restaurantCoverPhotoUrl}/${restaurant!.coverPhoto}',
                        width: double.infinity,
                        height: 260,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey[300],
                          child: Center(child: Image.asset(Images.restaurantCover, )),
                        ),
                      ),
                    ),
                    // Overlay card at the bottom of the header
                    Positioned(
                      left: 24,
                      right: 24,
                      bottom: 16, // now inside the expandedHeight
                      child: Container(
                        padding: EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'စားဘားရေစက်စားသောက်ဆိုင်',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                Icon(Icons.star, color: Colors.amber, size: 20),
                                SizedBox(width: 4),
                                Text('3.5', style: TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.location_on, size: 16, color: Colors.grey),
                                SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    'လမ်းမတော်လမ်း အထက်ရပ်ကွက် (0.9 km)',
                                    style: TextStyle(color: Colors.grey[700], fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                _infoChip(Icons.delivery_dining, 'ကိုယ်တိုင်လာယူနိုင်'),
                                SizedBox(width: 8),
                                _infoChip(Icons.monetization_on, 'ဧည့်လမ်းခ - ၁၀၀ ကျပ်'),
                                SizedBox(width: 8),
                                _infoChip(Icons.access_time, '15-20 မိနစ်'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Profile/Logo Circle truly overlaying both header and card
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0, // sits at the bottom of the flexibleSpace
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 12,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 36,
                            backgroundColor: Colors.white,
                            child: ClipOval(
                              child: Image.asset(
                                'assets/image/about_icon.png',
                                fit: BoxFit.cover,
                                width: 64,
                                height: 64,
                                errorBuilder: (context, error, stackTrace) => Icon(Icons.person, size: 36),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 32), // reduced space for the overlay effect
                  SizedBox(height: 24),
                  // Recommended Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Text(
                          'အမည်ကြိုက်',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(width: 6),
                        Text('🔥', style: TextStyle(fontSize: 18)),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),
                  SizedBox(
                    height: 160,
                    child: ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      scrollDirection: Axis.horizontal,
                      itemCount: 3,
                      separatorBuilder: (_, __) => SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final items = [
                          {'img': 'assets/image/about_us.png', 'name': 'ပါစတာ', 'rating': '3.5', 'price': '3,000 MMK'},
                          {'img': 'assets/image/additionalMap.png', 'name': 'အာလူးကြော်', 'rating': '3.5', 'price': '3,000 MMK'},
                          {'img': 'assets/image/about_icon.png', 'name': 'အစားအသောက်', 'rating': '3.5', 'price': '3,000 MMK'},
                        ];
                        final item = items[index];
                        return Container(
                          width: 140,
                          decoration: BoxDecoration(
                            color: Color(0xFF4B3939),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      topRight: Radius.circular(16),
                                    ),
                                    child: Image.asset(
                                      item['img']!,
                                      height: 80,
                                      width: 140,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Container(
                                        color: Colors.grey[300],
                                        child: Center(child: Icon(Icons.fastfood, size: 40)),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: CircleAvatar(
                                      radius: 14,
                                      backgroundColor: Colors.white,
                                      child: Icon(Icons.favorite_border, color: Colors.red, size: 16),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['name']!,
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(Icons.star, color: Colors.amber, size: 14),
                                        SizedBox(width: 2),
                                        Text(item['rating']!, style: TextStyle(color: Colors.white, fontSize: 12)),
                                      ],
                                    ),
                                    SizedBox(height: 4),
                                    Text(item['price']!, style: TextStyle(color: Colors.white, fontSize: 13)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  // Category Tabs
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        _categoryTab('အာဟာရ', true),
                        SizedBox(width: 8),
                        _categoryTab('အာနိ', false),
                        SizedBox(width: 8),
                        _categoryTab('တင့်ဆည့်', false),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  // Product Grid/List
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: SizedBox(
                      height: 180,
                      child: Row(
                        children: [
                          Expanded(
                            child: _productCard('assets/image/about_us.png', 'ပါစတာ', '4.0', '8,000 MMK'),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: _productCard('assets/image/additionalMap.png', 'ကြက်သားထမင်း', '4.0', '8,000 MMK'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Add more products as needed
                ],
              ),
            ),
          ],
        ): const Center(child: CircularProgressIndicator());}
      );}),
    ));
  }

  Widget _infoChip(IconData icon, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.black54),
          SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _categoryTab(String label, bool selected) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? Colors.white : Color(0xFF4B3939),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.red : Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _productCard(String img, String name, String rating, String price) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF4B3939),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Image.asset(
                  img,
                  height: 80,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[300],
                    child: Center(child: Icon(Icons.fastfood, size: 40)),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.favorite_border, color: Colors.red, size: 16),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 14),
                    SizedBox(width: 2),
                    Text(rating, style: TextStyle(color: Colors.white, fontSize: 12)),
                  ],
                ),
                SizedBox(height: 4),
                Text(price, style: TextStyle(color: Colors.white, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
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
import '../../../data/model/response/address_model.dart';
import '../../../util/colors.dart';
import '../cart/widget/float_cart_button.dart';

class RestaurantScreen extends StatefulWidget {
  final Restaurant? restaurant;
  final String? tableId;
  const RestaurantScreen({
    super.key,
    this.restaurant,
    this.tableId,
  });

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
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
    log("arg -> tableId - ${Get.find<RestaurantController>().tableId.value}");
    return Scaffold(
        appBar: ResponsiveHelper.isDesktop(context) ? const WebMenuBar() : null,
       backgroundColor: gradient1CardColor,
        body: Stack(
          children: [
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
                    ? CustomScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        controller: scrollController,
                        slivers: [
                          ResponsiveHelper.isDesktop(context)
                              ? SliverToBoxAdapter(
                                  child: Container(
                                    color: const Color(0xFF171A29),
                                    padding: const EdgeInsets.all(
                                        Dimensions.paddingSizeDefault),
                                    alignment: Alignment.center,
                                    child: Center(
                                        child: SizedBox(
                                            width: Dimensions.webMaxWidth,
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal:
                                                      Dimensions.paddingSizeSmall),
                                              child: Row(children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          Dimensions.radiusSmall),
                                                  child: CustomImage(
                                                    fit: BoxFit.cover,
                                                    placeholder:
                                                        Images.restaurantCover,

                                                    image:
                                                        '${Get.find<SplashController>().configModel!.baseUrls!.restaurantCoverPhotoUrl}/${restaurant!.coverPhoto}',
                                                  ),
                                                ),
                                                const SizedBox(
                                                    width: Dimensions
                                                        .paddingSizeLarge),
                                                // Expanded(
                                                //     child:
                                                //         RestaurantDescriptionView(
                                                //             restaurant:
                                                //                 restaurant)),
                                              ]),
                                            ))),
                                  ),
                                )
                              : SliverAppBar(

                                  expandedHeight: 200.h,
                                  toolbarHeight: 40.h,
                                  pinned: true,
                                  floating: false,
                                  elevation: 0.5,
                                  backgroundColor: Color(0xff3E2723),
                                  leading: Padding(
                                    padding:  EdgeInsets.only(left:15.w,right: 5.w),
                                    child: InkWell(
                                      onTap:(){

                                        Get.back();

                                      },
                                      child: Container(
                                        padding: EdgeInsets.only(left: 5.w),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.grey
                                        ),
                                        child: Center(child: Icon(Icons.arrow_back_ios,color: Colors.white,size: 15.w,)),
                                      ),
                                    ),
                                  ),

                                  flexibleSpace: FlexibleSpaceBar(

                                    centerTitle: true,
                                    expandedTitleScale: 1.1,
                                    // title: CustomizableSpaceBar(
                                    //   builder: (context, scrollingRate) {
                                    //     log("Restaurant index${restaurant?.toJson()}");
                                    //     final bool isRestaurantOpenNOw =
                                    //         restController.isRestaurantOpenNow(
                                    //             restaurant!.active!,
                                    //             restaurant.schedules);
                                    //
                                    //     log("isRestaurantOpenNOw $isRestaurantOpenNOw");
                                    //     return Container(
                                    //       margin: EdgeInsets.only(left: 30,right: 30),
                                    //       height: 80.h,
                                    //       color: Colors.transparent,
                                    //       child: Container(
                                    //         color: Colors.transparent,
                                    //         padding: EdgeInsets.only(
                                    //           bottom: 0,
                                    //           left:
                                    //               Get.find<LocalizationController>()
                                    //                       .isLtr
                                    //                   ? 40 * scrollingRate
                                    //                   : 0,
                                    //           right:
                                    //               Get.find<LocalizationController>()
                                    //                       .isLtr
                                    //                   ? 0
                                    //                   : 40 * scrollingRate,
                                    //         ),
                                    //         child: Align(
                                    //           alignment: Alignment.bottomLeft,
                                    //           child: Container(
                                    //             height: 100,
                                    //
                                    //            decoration: BoxDecoration(
                                    //              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                    //              color: Theme.of(context)
                                    //                  .cardColor
                                    //                  .withOpacity(0.7),
                                    //              boxShadow: [BoxShadow(
                                    //                blurRadius: 1,
                                    //                color: Theme.of(context)
                                    //                    .disabledColor
                                    //                    .withOpacity(0.9),
                                    //              )]
                                    //            ),
                                    //             padding: EdgeInsets.only(
                                    //               left: Get.find<
                                    //                           LocalizationController>()
                                    //                       .isLtr
                                    //                   ? 20
                                    //                   : 0,
                                    //               right: Get.find<
                                    //                           LocalizationController>()
                                    //                       .isLtr
                                    //                   ? 0
                                    //                   : 20,
                                    //             ),
                                    //             child: Row(children: [
                                    //               ClipRRect(
                                    //                 borderRadius:
                                    //                     BorderRadius.circular(
                                    //                         Dimensions.radiusSmall),
                                    //                 child: Stack(children: [
                                    //                   CustomImage(
                                    //                     image:
                                    //                         '${Get.find<SplashController>().configModel!.baseUrls!.restaurantImageUrl}/${restaurant.logo}',
                                    //                     height: 60 -
                                    //                         (scrollingRate * 15),
                                    //                     width: 70 -
                                    //                         (scrollingRate * 15),
                                    //                     fit: BoxFit.cover,
                                    //                   ),
                                    //                   isRestaurantOpenNOw
                                    //                       ? const SizedBox()
                                    //                       : Positioned(
                                    //                           bottom: 0,
                                    //                           left: 0,
                                    //                           right: 0,
                                    //                           child: Container(
                                    //                             height: 30,
                                    //                             alignment: Alignment
                                    //                                 .center,
                                    //                             decoration:
                                    //                                 BoxDecoration(
                                    //                               borderRadius: const BorderRadius
                                    //                                       .vertical(
                                    //                                   bottom: Radius
                                    //                                       .circular(
                                    //                                           Dimensions
                                    //                                               .radiusSmall)),
                                    //                               color: Colors
                                    //                                   .black
                                    //                                   .withOpacity(
                                    //                                       0.6),
                                    //                             ),
                                    //                             child: Text(
                                    //                               'closed_now'.tr,
                                    //                               textAlign:
                                    //                                   TextAlign
                                    //                                       .center,
                                    //                               style: robotoRegular.copyWith(
                                    //                                   color: Colors
                                    //                                       .white,
                                    //                                   fontSize:
                                    //                                       Dimensions
                                    //                                           .fontSizeSmall),
                                    //                             ),
                                    //                           ),
                                    //                         ),
                                    //                 ]),
                                    //               ),
                                    //               const SizedBox(
                                    //                   width: Dimensions
                                    //                       .paddingSizeSmall),
                                    //               Expanded(
                                    //                   child: Column(
                                    //                       crossAxisAlignment:
                                    //                           CrossAxisAlignment
                                    //                               .start,
                                    //                       mainAxisAlignment:
                                    //                           MainAxisAlignment
                                    //                               .center,
                                    //                       children: [
                                    //                     Text(
                                    //                       restaurant.name!,
                                    //                       style: robotoMedium.copyWith(
                                    //                           fontSize: Dimensions
                                    //                                   .fontSizeLarge -
                                    //                               (scrollingRate *
                                    //                                   3),
                                    //                           color:
                                    //                               Theme.of(context)
                                    //                                   .textTheme
                                    //                                   .bodyMedium!
                                    //                                   .color),
                                    //                       maxLines: 1,
                                    //                       overflow:
                                    //                           TextOverflow.ellipsis,
                                    //                     ),
                                    //                     const SizedBox(
                                    //                         height: Dimensions
                                    //                             .paddingSizeExtraSmall),
                                    //                     Text(
                                    //                       restaurant.address ?? '',
                                    //                       maxLines: 1,
                                    //                       overflow:
                                    //                           TextOverflow.ellipsis,
                                    //                       style: robotoRegular.copyWith(
                                    //                           fontSize: Dimensions
                                    //                                   .fontSizeSmall -
                                    //                               (scrollingRate *
                                    //                                   2),
                                    //                           color: Theme.of(
                                    //                                   context)
                                    //                               .disabledColor),
                                    //                     ),
                                    //                     SizedBox(
                                    //                         height: ResponsiveHelper
                                    //                                 .isDesktop(
                                    //                                     context)
                                    //                             ? Dimensions
                                    //                                 .paddingSizeExtraSmall
                                    //                             : 0),
                                    //                     Row(children: [
                                    //                       Text('minimum_order'.tr,
                                    //                           style: robotoRegular
                                    //                               .copyWith(
                                    //                             fontSize: Dimensions
                                    //                                     .fontSizeExtraSmall -
                                    //                                 (scrollingRate *
                                    //                                     2),
                                    //                             color: Theme.of(
                                    //                                     context)
                                    //                                 .disabledColor,
                                    //                           )),
                                    //                       const SizedBox(
                                    //                           width: Dimensions
                                    //                               .paddingSizeExtraSmall),
                                    //                       Text(
                                    //                         PriceConverter
                                    //                             .convertPrice(
                                    //                                 restaurant
                                    //                                     .minimumOrder),
                                    //                         textDirection:
                                    //                             TextDirection.ltr,
                                    //                         style: robotoMedium.copyWith(
                                    //                             fontSize: Dimensions
                                    //                                     .fontSizeExtraSmall -
                                    //                                 (scrollingRate *
                                    //                                     2),
                                    //                             color: Theme.of(
                                    //                                     context)
                                    //                                 .primaryColor),
                                    //                       ),
                                    //                       const Spacer(),
                                    //                     Obx(()=>
                                    //                                     Text(
                                    //                                       '${Get.find<OrderController>().distancekm.value.toStringAsFixed(2)} ${'km'.tr}',
                                    //                                       style: robotoMedium.copyWith(
                                    //                                           fontSize:
                                    //                                               Dimensions
                                    //                                                   .fontSizeSmall,
                                    //                                           color: Theme.of(context)
                                    //                                               .primaryColor),
                                    //                                     ),
                                    //                                   ),
                                    //                     ]),
                                    //                   ])),
                                    //               const SizedBox(
                                    //                   width: Dimensions
                                    //                       .paddingSizeSmall),
                                    //
                                    //               const SizedBox(
                                    //                   width: Dimensions
                                    //                       .paddingSizeLarge),
                                    //             ]),
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     );
                                    //   },
                                    // ),
                                    background: Stack(
                                      children: [
                                        Positioned.fill(
                                          child: Column(
                                            children: [
                                              CustomImage(
                                                fit: BoxFit.cover,
                                                height: 160.h,
                                                width: double.infinity,
                                                placeholder: Images.restaurantCover,
                                                image:
                                                '${Get.find<SplashController>().configModel!.baseUrls!.restaurantCoverPhotoUrl}/${restaurant!.coverPhoto}',
                                              ),
                                              Container(
                                                height: 40.h,
                                                color: Color(0xff3E2723),
                                              )
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          left:10,
                                          right:10,
                                          bottom:-20,
                                          child: CustomizableSpaceBar(
                                            builder: (context, scrollingRate) {
                                              log("Restaurant index${restaurant?.toJson()}");
                                              final bool isRestaurantOpenNOw =
                                              restController.isRestaurantOpenNow(
                                                  restaurant!.active!,
                                                  restaurant.schedules);

                                              log("isRestaurantOpenNOw $isRestaurantOpenNOw");
                                              return Stack(
                                                children: [

                                                  Padding(
                                                    padding:  EdgeInsets.symmetric(vertical:30.h,horizontal: 20.w),
                                                    child: Container(
                                                      height: 122.h,

                                                      decoration: BoxDecoration(

                                                          borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
                                                          border:Border.all(
                                                            color: Theme.of(context).disabledColor
                                                          ),
                                                          color: Theme.of(context)
                                                              .cardColor
                                                              .withOpacity(0.7),
                                                          boxShadow: [BoxShadow(
                                                            blurRadius: 1,
                                                            color: Theme.of(context)
                                                                .disabledColor
                                                                .withOpacity(0.9),
                                                          )]
                                                      ),
                                                      padding: EdgeInsets.only(
                                                        left: Get.find<
                                                            LocalizationController>()
                                                            .isLtr
                                                            ? 20
                                                            : 0,
                                                        right: Get.find<
                                                            LocalizationController>()
                                                            .isLtr
                                                            ? 0
                                                            : 20,
                                                      ),
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Dimensions.kSizedBoxH30,

                                                          Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,

                                                            children: [
                                                              Text(
                                                                restaurant.name!,
                                                                style: robotoMedium.copyWith(
                                                                    fontSize: Dimensions
                                                                        .fontSizeLarge -
                                                                        (scrollingRate *
                                                                            3),
                                                                    color:
                                                                    Theme.of(context)
                                                                        .textTheme
                                                                        .bodyMedium!
                                                                        .color),
                                                                maxLines: 1,
                                                                overflow:
                                                                TextOverflow.ellipsis,
                                                              ),
                                                              Dimensions.kSizedBoxW15,
                                                              InkWell(
                                                                onTap: () => Get.toNamed(RouteHelper.getRestaurantReviewRoute(restaurant!.id)),
                                                                child: Row(children: [
                                                                  Icon(Icons.star, color: Theme.of(context).secondaryHeaderColor, size: 20),
                                                                  Dimensions.kSizedBoxW2,
                                                                  Text(
                                                                    restaurant!.avgRating!.toStringAsFixed(1), textDirection: TextDirection.ltr,
                                                                    style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).indicatorColor),
                                                                  ),
                                                                ]),
                                                              ),
                                                            ],
                                                          ),

                                                          InkWell(
                                                            onTap: () => Get.toNamed(RouteHelper.getMapRoute(
                                                              AddressModel(
                                                                id: restaurant!.id, address: restaurant!.address, latitude: restaurant!.latitude,
                                                                longitude: restaurant!.longitude, contactPersonNumber: '', contactPersonName: '', addressType: '',
                                                              ), 'restaurant',
                                                            )),
                                                            child: Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                                children: [
                                                                  Icon(Icons.location_on, color: Theme.of(context).disabledColor, size: 20),
                                                                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                                                  Text(restaurant!.address??"", style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),
                                                                  Dimensions.kSizedBoxW5,
                                                                  Obx(()=>
                                                                      Text(
                                                                        '(${Get.find<OrderController>().distancekm.value.toStringAsFixed(2)} ${'km'.tr})',
                                                                        style: robotoMedium.copyWith(
                                                                            fontSize:
                                                                            Dimensions
                                                                                .fontSizeSmall,
                                                                            color: Theme.of(context)
                                                                                .disabledColor),
                                                                      ),)
                                                                ]),
                                                          ),
                                                          SizedBox(
                                                              height: ResponsiveHelper
                                                                  .isDesktop(
                                                                  context)
                                                                  ? Dimensions
                                                                  .paddingSizeExtraSmall
                                                                  : 0),
                                                          Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                              children: [
                                                                Text('minimum_order'.tr,
                                                                    style: robotoRegular
                                                                        .copyWith(
                                                                      fontSize: Dimensions
                                                                          .fontSizeExtraSmall -
                                                                          (scrollingRate *
                                                                              2),
                                                                      color: Theme.of(
                                                                          context)
                                                                          .disabledColor,
                                                                    )),
                                                                const SizedBox(
                                                                    width: Dimensions
                                                                        .paddingSizeExtraSmall),
                                                                Text(
                                                                  PriceConverter
                                                                      .convertPrice(
                                                                      restaurant
                                                                          .minimumOrder),
                                                                  textDirection:
                                                                  TextDirection.ltr,
                                                                  style: robotoMedium.copyWith(
                                                                      fontSize: Dimensions
                                                                          .fontSizeExtraSmall -
                                                                          (scrollingRate *
                                                                              2),
                                                                      color: Theme.of(
                                                                          context)
                                                                          .primaryColor),
                                                                ),



                                                              ]),
                                                          ResponsiveHelper.isDesktop(context)
                                                              ? const SizedBox()
                                                              : RestaurantDescriptionView(
                                                              restaurant: restaurant),
                                                          Dimensions.kSizedBoxH10,
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top:5,

                                                    left:MediaQuery.of(context).size.width/2.5,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          Dimensions.radiusSmall),
                                                      child: Stack(children: [
                                                        CustomImage(
                                                          image:
                                                          '${Get.find<SplashController>().configModel!.baseUrls!.restaurantImageUrl}/${restaurant.logo}',
                                                          height: 60 -
                                                              (scrollingRate * 15),
                                                          width: 70 -
                                                              (scrollingRate * 15),
                                                          fit: BoxFit.cover,
                                                        ),
                                                        isRestaurantOpenNOw
                                                            ? const SizedBox()
                                                            : Positioned(
                                                          bottom: 0,
                                                          left: 0,
                                                          right: 0,
                                                          child: Container(
                                                            height: 30,
                                                            alignment: Alignment
                                                                .center,
                                                            decoration:
                                                            BoxDecoration(
                                                              borderRadius: const BorderRadius
                                                                  .vertical(
                                                                  bottom: Radius
                                                                      .circular(
                                                                      Dimensions
                                                                          .radiusSmall)),
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                  0.6),
                                                            ),
                                                            child: Text(
                                                              'closed_now'.tr,
                                                              textAlign:
                                                              TextAlign
                                                                  .center,
                                                              style: robotoRegular.copyWith(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                  Dimensions
                                                                      .fontSizeSmall),
                                                            ),
                                                          ),
                                                        ),
                                                      ]),
                                                    ),
                                                  ),

                                                ],
                                              );
                                            },
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                  actions:  [
                                    Padding(
                                      padding:  EdgeInsets.only(right: 15.w),
                                      child: GetBuilder<WishListController>(
                                          builder: (wishController) {
                                            bool isWished = wishController
                                                .wishRestIdList
                                                .contains(restaurant!.id);
                                            return InkWell(
                                              onTap: () {
                                                if (Get.find<
                                                    AuthController>()
                                                    .isLoggedIn()) {
                                                  isWished
                                                      ? wishController
                                                      .removeFromWishList(
                                                      restaurant!
                                                          .id,
                                                      true)
                                                      : wishController
                                                      .addToWishList(
                                                      null,
                                                      restaurant,
                                                      true);
                                                } else {
                                                  showCustomSnackBar(
                                                      'you_are_not_logged_in'
                                                          .tr);
                                                }
                                              },
                                              child: Container(
                                                padding: const EdgeInsets
                                                    .all(
                                                    Dimensions
                                                        .paddingSizeExtraSmall),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  // borderRadius: BorderRadius
                                                  //     .circular(Dimensions
                                                  //     .radiusDefault),
                                                  color: Colors.grey,
                                                ),
                                                child: Icon(
                                                  isWished
                                                      ? Icons.favorite
                                                      : Icons
                                                      .favorite_border,
                                                  color: isWished
                                                      ? Theme.of(context)
                                                      .primaryColor
                                                      : Theme.of(context)
                                                      .indicatorColor,
                                                  size: 24 ,
                                                ),
                                              ),
                                            );
                                          }),
                                    ),
                                  ],
                                ),
                          SliverToBoxAdapter(
                              child: Center(
                                  child: Container(
                            width: Dimensions.webMaxWidth,
                            // padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                            color: Color(0xff3E2723),
                            child: Column(children: [

                              restaurant.discount != null
                                  ? Container(
                                      width: context.width,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: Dimensions.paddingSizeSmall,
                                          horizontal: Dimensions.paddingSizeLarge),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.radiusSmall),
                                          color: Theme.of(context).primaryColor),
                                      padding: const EdgeInsets.all(
                                          Dimensions.paddingSizeSmall),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              restaurant.discount!.discountType ==
                                                      'percent'
                                                  ? '${restaurant.discount!.discount}% ${'off'.tr}'
                                                  : '${PriceConverter.convertPrice(restaurant.discount!.discount)} ${'off'.tr}',
                                              style: robotoMedium.copyWith(
                                                  fontSize:
                                                      Dimensions.fontSizeLarge,
                                                  color:
                                                      Theme.of(context).cardColor),
                                            ),
                                            Text(
                                              restaurant.discount!.discountType ==
                                                      'percent'
                                                  ? '${'enjoy'.tr} ${restaurant.discount!.discount}% ${'off_on_all_categories'.tr}'
                                                  : '${'enjoy'.tr} ${PriceConverter.convertPrice(restaurant.discount!.discount)}'
                                                      ' ${'off_on_all_categories'.tr}',
                                              style: robotoMedium.copyWith(
                                                  fontSize:
                                                      Dimensions.fontSizeSmall,
                                                  color:
                                                      Theme.of(context).cardColor),
                                            ),
                                            SizedBox(
                                                height: (restaurant.discount!
                                                                .minPurchase !=
                                                            0 ||
                                                        restaurant.discount!
                                                                .maxDiscount !=
                                                            0)
                                                    ? 5
                                                    : 0),
                                            restaurant.discount!.minPurchase != 0
                                                ? Text(
                                                    '[ ${'minimum_purchase'.tr}: ${PriceConverter.convertPrice(restaurant.discount!.minPurchase)} ]',
                                                    style: robotoRegular.copyWith(
                                                        fontSize: Dimensions
                                                            .fontSizeExtraSmall,
                                                        color: Theme.of(context)
                                                            .cardColor),
                                                  )
                                                : const SizedBox(),
                                            restaurant.discount!.maxDiscount != 0
                                                ? Text(
                                                    '[ ${'maximum_discount'.tr}: ${PriceConverter.convertPrice(restaurant.discount!.maxDiscount)} ]',
                                                    style: robotoRegular.copyWith(
                                                        fontSize: Dimensions
                                                            .fontSizeExtraSmall,
                                                        color: Theme.of(context)
                                                            .cardColor),
                                                  )
                                                : const SizedBox(),
                                            Text(
                                              '[ ${'daily_time'.tr}: ${DateConverter.convertTimeToTime(restaurant.discount!.startTime!)} '
                                              '- ${DateConverter.convertTimeToTime(restaurant.discount!.endTime!)} ]',
                                              style: robotoRegular.copyWith(
                                                  fontSize:
                                                      Dimensions.fontSizeExtraSmall,
                                                  color:
                                                      Theme.of(context).cardColor),
                                            ),
                                          ]),
                                    )
                                  : const SizedBox(),
                              const SizedBox(height: Dimensions.paddingSizeSmall),
                              restController.recommendedProductModel != null &&
                                      restController.recommendedProductModel!
                                          .products!.isNotEmpty
                                  ? Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: Dimensions.paddingSizeLarge,
                                            left: Dimensions.paddingSizeLarge,
                                            bottom: Dimensions.paddingSizeSmall,
                                            right: Dimensions.paddingSizeLarge,
                                          ),
                                          child: Text('recommended_items'.tr,
                                              style: robotoMedium),
                                        ),
                                        // const SizedBox(height: Dimensions.paddingSizeSmall),

                                        SizedBox(
                                          height:
                                              ResponsiveHelper.isDesktop(context)
                                                  ? 150
                                                  : 120,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: restController
                                                .recommendedProductModel!
                                                .products!
                                                .length,
                                            physics: const BouncingScrollPhysics(),
                                            padding: const EdgeInsets.only(
                                                left: Dimensions.paddingSizeLarge),
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding: ResponsiveHelper.isDesktop(
                                                        context)
                                                    ? const EdgeInsets.symmetric(
                                                        vertical: 20)
                                                    : const EdgeInsets.symmetric(
                                                        vertical: 10),
                                                child: Container(
                                                  width: ResponsiveHelper.isDesktop(
                                                          context)
                                                      ? 500
                                                      : 300,
                                                  margin: const EdgeInsets.only(
                                                      right: Dimensions
                                                          .paddingSizeSmall),
                                                  child: ProductWidget(
                                                    isRestaurant: false,
                                                    product: restController
                                                        .recommendedProductModel!
                                                        .products![index],
                                                    restaurant: null,
                                                    index: index,
                                                    length: null,
                                                    isCampaign: false,
                                                    inRestaurant: true,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    )
                                  : const SizedBox(),
                            ]),
                          ))),
                          ///later may be open
                          (restController.categoryList!.isNotEmpty)
                              ? SliverPersistentHeader(
                                  pinned: false,
                                  delegate: SliverDelegate(
                                      height: 90,
                                      child: Center(
                                          child: Container(
                                        width: Dimensions.webMaxWidth,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).cardColor,
                                          // boxShadow: [
                                          //   BoxShadow(
                                          //       color: Colors.grey[
                                          //           Get.isDarkMode ? 700 : 300]!,
                                          //       spreadRadius: 1,
                                          //       blurRadius: 5)
                                          // ],
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            vertical:
                                                Dimensions.paddingSizeExtraSmall),
                                        child: Column(children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal:
                                                    Dimensions.paddingSizeLarge),
                                            child: Row(children: [
                                              Text('all_products'.tr,
                                                  style: robotoBold.copyWith(
                                                      fontSize: Dimensions
                                                          .fontSizeDefault)),
                                              const Expanded(child: SizedBox()),
                                              InkWell(
                                                onTap: () => Get.toNamed(RouteHelper
                                                    .getSearchRestaurantProductRoute(
                                                        restaurant!.id)),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            Dimensions
                                                                .radiusDefault),
                                                    color: Color(0xffFFCFCF)
                                                        ,
                                                  ),
                                                  padding: const EdgeInsets.all(
                                                      Dimensions
                                                          .paddingSizeExtraSmall),
                                                  child: Icon(Icons.search,
                                                      size: 28,
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                                ),
                                              ),
                                              restController.type.isNotEmpty
                                                  ? VegFilterWidget(
                                                      type: restController.type,
                                                      onSelected: (String type) {
                                                        restController
                                                            .getRestaurantProductList(
                                                                restController
                                                                    .restaurant!.id,
                                                                1,
                                                                type,
                                                                true);
                                                      },
                                                    )
                                                  : const SizedBox(),
                                            ]),
                                          ),
                                          const SizedBox(
                                              height: Dimensions.paddingSizeSmall),
                                          SizedBox(
                                            height: 30,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: restController
                                                  .categoryList!.length,
                                              padding: const EdgeInsets.only(
                                                  left:
                                                      Dimensions.paddingSizeLarge),
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                return InkWell(
                                                  onTap: () => restController
                                                      .setCategoryIndex(index),
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: Dimensions
                                                            .paddingSizeSmall,
                                                        vertical: Dimensions
                                                            .paddingSizeExtraSmall),
                                                    margin: const EdgeInsets.only(
                                                        right: Dimensions
                                                            .paddingSizeSmall),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(color: Colors.pink),
                                                        // boxShadow: [
                                                        //   BoxShadow(
                                                        //     color: Color(0xffFFCFCF).withOpacity(0.8),
                                                        //     blurRadius: 6,
                                                        //     spreadRadius: 2,
                                                        //     offset: const Offset(
                                                        //       1,
                                                        //       1,
                                                        //     ),
                                                        //   ),
                                                        // ],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              Dimensions
                                                                  .roundRadius),
                                                      color: index ==
                                                              restController
                                                                  .categoryIndex
                                                          ? Color(0xffFFCFCF).withOpacity(0.9)
                                                          : Colors.transparent,
                                                    ),
                                                    child: SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              restController
                                                                  .categoryList![
                                                                      index]
                                                                  .name!,
                                                              style: index ==
                                                                      restController
                                                                          .categoryIndex
                                                                  ? robotoMedium.copyWith(
                                                                      fontSize:
                                                                          Dimensions
                                                                              .fontSizeSmall,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColor)
                                                                  : robotoRegular.copyWith(
                                                                      fontSize:
                                                                          Dimensions
                                                                              .fontSizeSmall),
                                                            ),
                                                          ]),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ]),
                                      ))),
                                )
                              : const SliverToBoxAdapter(child: SizedBox()),
                          SliverToBoxAdapter(
                              child: Center(
                                  child: Container(
                            width: Dimensions.webMaxWidth,
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                            ),
                            child: Column(children: [
                              ProductView(
                                isRestaurant: false,
                                restaurants: null,
                                products: restController.categoryList!.isNotEmpty
                                    ? restController.restaurantProducts
                                    : null,
                                inRestaurantPage: true,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.paddingSizeSmall,
                                  vertical: Dimensions.paddingSizeLarge,
                                ),
                              ),
                              restController.foodPaginate
                                  ? const Center(
                                      child: Padding(
                                      padding: EdgeInsets.all(
                                          Dimensions.paddingSizeSmall),
                                      child: CircularProgressIndicator(),
                                    ))
                                  : const SizedBox(),
                            ]),
                          ))),
                        ],
                      )
                    : const Center(child: CircularProgressIndicator());
              });
            }),
    GetBuilder<CartController>(builder: (cartController) {
    return cartController.cartList.isNotEmpty &&
    !ResponsiveHelper.isDesktop(context)

    ?   Positioned(
              bottom: _fabTop,
              right: _fabLeft,
              child: GestureDetector(
                onTap: ()=> Get.toNamed(RouteHelper.getCartRoute(), parameters: {
                  'tableId': widget.tableId??"0",
                }),
                onPanUpdate: (details) {
                  setState(() {
                    _fabTop -= details.delta.dy;
                    _fabLeft -= details.delta.dx;
                  });
                },
                child: Badge(
                  textColor: Theme.of(context).disabledColor,
                  label: CustomText(text: cartController.cartList.length.toString(),color: Theme.of(context).disabledColor,),
                  child: Container(
                    padding: EdgeInsets.all(5.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(colors: [
                        Color(0xffD60000).withOpacity(0.5),
                        Colors.blueGrey.withOpacity(0.5),
                      Colors.blueGrey.withOpacity(0.2),
                        Color(0xffffda00).withOpacity(0.2),
                      ]),
                      border: Border.all(color: Color(0xffD60000),),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xffD60000).withOpacity(0.5),
                          blurRadius: 6,
                          spreadRadius: 2,
                          offset: const Offset(
                            1,
                            1,
                          ),
                        ),
                      ],
                    ),
                    child: Icon(Icons.shopping_cart,color: Theme.of(context).disabledColor,),
                  ),
                ),
              ),
            ):SizedBox();})
          ],
        ),

        // bottomNavigationBar:
        //     GetBuilder<CartController>(builder: (cartController) {
        //   return cartController.cartList.isNotEmpty &&
        //           !ResponsiveHelper.isDesktop(context)
        //
        //       ? BottomCartWidget(
        //           tableId: widget.tableId ?? "0",
        //         )
        //       : const SizedBox();
        // })
    );
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;
  double height;

  SliverDelegate({required this.child, this.height = 100});

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

class CategoryProduct {
  CategoryModel category;
  List<Product> products;
  CategoryProduct(this.category, this.products);
}

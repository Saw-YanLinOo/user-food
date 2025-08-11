import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user/controller/auth_controller.dart';
import 'package:user/controller/splash_controller.dart';
import 'package:user/controller/wishlist_controller.dart';
import 'package:user/data/model/response/config_model.dart';
import 'package:user/data/model/response/product_model.dart';
import 'package:user/data/model/response/restaurant_model.dart';
import 'package:user/helper/date_converter.dart';
import 'package:user/helper/price_converter.dart';
import 'package:user/helper/responsive_helper.dart';
import 'package:user/helper/route_helper.dart';
import 'package:user/util/dimensions.dart';
import 'package:user/util/images.dart';
import 'package:user/util/styles.dart';
import 'package:user/view/base/custom_image.dart';
import 'package:user/view/base/custom_snackbar.dart';
import 'package:user/view/base/discount_tag.dart';
import 'package:user/view/base/discount_tag_without_image.dart';
import 'package:user/view/base/not_available_widget.dart';
import 'package:user/view/base/product_bottom_sheet.dart';
import 'package:user/view/base/rating_bar.dart';
import 'package:user/view/screens/restaurant/restaurant_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/view/screens/restaurant/restaurant_screen_new.dart';

class ProductWidget extends StatelessWidget {
  final Product? product;
  final Restaurant? restaurant;
  final bool isRestaurant;
  final int index;
  final int? length;
  final bool inRestaurant;
  final bool isCampaign;
  final bool fromCartSuggestion;
  const ProductWidget(
      {super.key,
      required this.product,
      required this.isRestaurant,
      required this.restaurant,
      required this.index,
      required this.length,
      this.inRestaurant = false,
      this.isCampaign = false,
      this.fromCartSuggestion = false});

  @override
  Widget build(BuildContext context) {
    BaseUrls? baseUrls = Get.find<SplashController>().configModel!.baseUrls;
    bool desktop = ResponsiveHelper.isDesktop(context);
    double? discount;
    String? discountType;
    bool isAvailable;
    String? image;
       bool productAvailable = isRestaurant?
       product?.restaurantOpen == 1 &&
        product?.restaurantActive == 1 &&
        product?.foodOpen == 1:
        product?.restaurantActive == 1 &&
        product?.foodOpen == 1;
    if (isRestaurant) {
      image = restaurant!.logo;
      discount =
          restaurant!.discount != null ? restaurant!.discount!.discount : 0;
      discountType = restaurant!.discount != null
          ? restaurant!.discount!.discountType
          : 'percent';

           
      // bool _isClosedToday = Get.find<RestaurantController>().isRestaurantClosed(true, restaurant.active, restaurant.offDay);
      // _isAvailable = DateConverter.isAvailable(restaurant.openingTime, restaurant.closeingTime) && restaurant.active && !_isClosedToday;
      isAvailable = restaurant!.open == 1 && restaurant!.active!;
    } else {
      image = product!.image;
      discount = (product!.restaurantDiscount == 0 || isCampaign)
          ? product!.discount
          : product!.restaurantDiscount;
      discountType = (product!.restaurantDiscount == 0 || isCampaign)
          ? product!.discountType
          : 'percent';
      isAvailable = DateConverter.isAvailable(
          product!.availableTimeStarts, product!.availableTimeEnds);
    }

    return InkWell(
      onTap: () {
        if (isRestaurant) {
          if (restaurant != null && restaurant!.restaurantStatus == 1) {
            Get.toNamed(RouteHelper.getRestaurantRoute(restaurant!.id),
                arguments: RestaurantScreen(restaurant: restaurant));
          } else if (restaurant!.restaurantStatus == 0) {
            showCustomSnackBar('restaurant_is_not_available'.tr);
          }
        } else {
          if (product!.restaurantStatus == 1) {
            ResponsiveHelper.isMobile(context)
                ? Get.bottomSheet(
                    ProductBottomSheet(
                        product: product,
                        inRestaurantPage: inRestaurant,
                        isCampaign: isCampaign),
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                  )
                : Get.dialog(
                    Dialog(
                        child: ProductBottomSheet(
                            product: product, inRestaurantPage: inRestaurant)),
                  );
          } else {
            showCustomSnackBar('item_is_not_available'.tr);
          }
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
          children: [
        ((image != null && image.isNotEmpty) || isRestaurant)
            ?
             Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusSmall),
                      child:

                           CustomImage(
                          image:
                              '${isCampaign ? baseUrls!.campaignImageUrl : isRestaurant ? baseUrls!.restaurantImageUrl : baseUrls!.productImageUrl}'
                              '/${isRestaurant ? restaurant!.logo : product!.image}',
                          // height: desktop
                          //     ? 120
                          //     : length == null
                          //         ? 100
                          //        : 80,
                          //
                          // width: desktop ? 120 : 120,
                          fit: BoxFit.cover,
                      ),



                    ),
                    Positioned(
                      right: 0,
                      child:Column(
                          mainAxisAlignment: isRestaurant
                              ? MainAxisAlignment.center
                              : MainAxisAlignment.spaceBetween,
                          children: [
                            // !isRestaurant
                            //     ? Padding(
                            //   padding: EdgeInsets.symmetric(
                            //       vertical:
                            //       desktop ? Dimensions.paddingSizeSmall : 0),
                            //   child: Icon(Icons.add, size: desktop ? 30 : 25),
                            // )
                            //     : const SizedBox(),
                            fromCartSuggestion
                                ? Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(
                                  Dimensions.paddingSizeExtraSmall),
                              child: Icon(Icons.add,
                                  color: Theme.of(context).cardColor),
                            )
                                : GetBuilder<WishListController>(
                                builder: (wishController) {
                                  bool isWished = isRestaurant
                                      ? wishController.wishRestIdList
                                      .contains(restaurant!.id)
                                      : wishController.wishProductIdList
                                      .contains(product!.id);
                                  return InkWell(
                                    onTap: () {
                                      if (Get.find<AuthController>().isLoggedIn()) {
                                        isWished
                                            ? wishController.removeFromWishList(
                                            isRestaurant
                                                ? restaurant!.id
                                                : product!.id,
                                            isRestaurant)
                                            : wishController.addToWishList(
                                            product, restaurant, isRestaurant);
                                      } else {
                                        showCustomSnackBar(
                                            'you_are_not_logged_in'.tr);
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey.withOpacity(0.6)
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 3.h,
                                          vertical: desktop
                                              ? Dimensions.paddingSizeSmall
                                              : 3.w),
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 3.h,
                                          vertical: desktop
                                              ? Dimensions.paddingSizeSmall
                                              : 3.w),
                                      child: Icon(
                                        isWished
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        size: desktop ? 30 : 25,
                                        color: isWished
                                            ? Theme.of(context).primaryColor
                                            : Theme.of(context).indicatorColor,
                                      ),
                                    ),
                                  );
                                }),
                          ]), ),
                  ],
                ),

      if(!productAvailable&&isRestaurant==false)
               Positioned(
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
                                      'not_available'.tr,
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
               DiscountTag(
                  discount: discount,
                  discountType: discountType,
                  freeDelivery:
                      isRestaurant ? restaurant!.freeDelivery : false,
                ),
                isAvailable
                    ? const SizedBox()
                    : NotAvailableWidget(isRestaurant: isRestaurant),
              ])
            : const SizedBox.shrink(),
        const SizedBox(width: Dimensions.paddingSizeSmall),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              isRestaurant
                                  ? restaurant!.name!
                                  : product!.name!,
                              style: robotoBold.copyWith(
                                  fontSize: Dimensions.fontSizeDefault),
                              maxLines: desktop ? 2 : 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            !isRestaurant
                                ? RatingBar(
                              rating: isRestaurant
                                  ? restaurant!.avgRating
                                  : 4,
                              size: desktop ? 15 : 12,
                              ratingCount: isRestaurant
                                  ? restaurant!.ratingCount
                                  : 4,
                            )
                                : const SizedBox(),
                          ],
                        ),
      const SizedBox(
          width: Dimensions.paddingSizeExtraSmall),
      // (!isRestaurant &&
      //         Get.find<SplashController>()
      //             .configModel!
      //             .toggleVegNonVeg!)
      //     ? Image.asset(
      //         product != null && product!.veg == 0
      //             ? Images.nonVegImage
      //             : Images.vegImage,
      //         height: 10,
      //         width: 10,
      //         fit: BoxFit.contain)
      //     : const SizedBox(),
                      ]),
                  SizedBox(
                      height: isRestaurant
        ? Dimensions.paddingSizeExtraSmall
        : 0),
                  Text(
                    isRestaurant
      ? restaurant!.address ?? 'no_address_found'.tr
      : product!.restaurantName ?? '',
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeExtraSmall,
                      color: Theme.of(context).disabledColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: (desktop || isRestaurant) ? 5 : 0),

                  SizedBox(
                      height: (!isRestaurant && desktop)
        ? Dimensions.paddingSizeExtraSmall
        : 0),
                  isRestaurant
                      ? RatingBar(
        rating: isRestaurant
            ? restaurant!.avgRating
            : product!.avgRating,
        size: desktop ? 15 : 12,
        ratingCount: isRestaurant
            ? restaurant!.ratingCount
            : product!.ratingCount,
      )
                      : Row(children: [
        Text(
          PriceConverter.convertPrice(product!.price,
              discount: discount,
              discountType: discountType),
          style: robotoMedium.copyWith(
              fontSize: Dimensions.fontSizeSmall),
          textDirection: TextDirection.ltr,
        ),
        SizedBox(
            width: discount! > 0
                ? Dimensions.paddingSizeExtraSmall
                : 0),
        discount > 0
            ? Text(
                PriceConverter.convertPrice(
                    product!.price),
                textDirection: TextDirection.ltr,
                style: robotoMedium.copyWith(
                  fontSize:
                      Dimensions.fontSizeExtraSmall,
                  color:
                      Theme.of(context).disabledColor,
                  decoration:
                      TextDecoration.lineThrough,
                ),
              )
            : const SizedBox(),
        const SizedBox(
            width: Dimensions.paddingSizeExtraSmall),
        (image != null && image.isNotEmpty)
            ? const SizedBox.shrink()
            : DiscountTagWithoutImage(
                discount: discount,
                discountType: discountType,
                freeDelivery: isRestaurant
                    ? restaurant!.freeDelivery
                    : false),
      ]),
                ]),
          ),
        ),

      ]),
    );
  }
}

import 'package:user/controller/auth_controller.dart';
import 'package:user/controller/splash_controller.dart';
import 'package:user/controller/theme_controller.dart';
import 'package:user/controller/wishlist_controller.dart';
import 'package:user/data/model/response/cart_model.dart';
import 'package:user/data/model/response/product_model.dart';
import 'package:user/helper/price_converter.dart';
import 'package:user/helper/responsive_helper.dart';
import 'package:user/helper/route_helper.dart';
import 'package:user/util/dimensions.dart';
import 'package:user/util/images.dart';
import 'package:user/util/styles.dart';
import 'package:user/view/base/custom_image.dart';
import 'package:user/view/base/custom_snackbar.dart';
import 'package:user/view/base/discount_tag.dart';
import 'package:user/view/base/product_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class MenuCard extends StatelessWidget {
  final Product product;
  final bool? isBestItem;
  final bool? isPopularNearbyItem;
  final bool isCampaignItem;
  const MenuCard(
      {super.key,
      required this.product,
      this.isBestItem,
      this.isPopularNearbyItem = false,
      this.isCampaignItem = false});

  @override
  Widget build(BuildContext context) {
    double price = product.price!;
    double discount = product.discount!;
    double discountPrice = PriceConverter.convertWithDiscount(
        price, discount, product.discountType)!;

    CartModel cartModel = CartModel(
      price,
      discountPrice,
      (price - discountPrice),
      1,
      [],
      [],
      isCampaignItem,
      product,
      [],
    );
    bool isAvailable = product.restaurantOpen == 1 &&
        product.restaurantActive == 1 &&
        product.foodOpen == 1;

    return InkWell(
        onTap: () {
          ResponsiveHelper.isMobile(context)
              ? Get.bottomSheet(
                  ProductBottomSheet(
                      product: product, isCampaign: isCampaignItem),
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                )
              : Get.dialog(
                  Dialog(
                      child: ProductBottomSheet(
                          product: product, isCampaign: isCampaignItem)),
                );
        },
        child: ResponsiveHelper.isMobile(context)
            ? 
            Container(
                width: isPopularNearbyItem!
                    ? double.infinity
                    : MediaQuery.of(context).size.width / 2.7,
                height: MediaQuery.of(context).size.height / 2,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                ),
                child: Column(children: [
                  Expanded(
                    flex: 6,
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: Dimensions.paddingSizeExtraSmall,
                              left: Dimensions.paddingSizeExtraSmall,
                              right: Dimensions.paddingSizeExtraSmall),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                                topLeft:
                                    Radius.circular(Dimensions.radiusDefault),
                                topRight:
                                    Radius.circular(Dimensions.radiusDefault)),
                            child: CustomImage(
                              placeholder: Images.placeholder,
                              image: !isCampaignItem
                                  ? '${Get.find<SplashController>().configModel?.baseUrls?.productImageUrl}'
                                      '/${product.image}'
                                  : '${Get.find<SplashController>().configModel?.baseUrls?.campaignImageUrl}'
                                      '/${product.image}',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                        ),
                        !isCampaignItem
                            ? Positioned(
                                top: Dimensions.paddingSizeSmall,
                                right: Dimensions.paddingSizeSmall,
                                child: GetBuilder<WishListController>(
                                    builder: (wishController) {
                                  bool isWished = wishController
                                      .wishProductIdList
                                      .contains(product.id);
                                  return InkWell(
                                    onTap: () {
                                      if (Get.find<AuthController>()
                                          .isLoggedIn()) {
                                        isWished
                                            ? wishController.removeFromWishList(
                                                product.id, false)
                                            : wishController.addToWishList(
                                                product, null, false);
                                      } else {
                                        showCustomSnackBar(
                                            'you_are_not_logged_in'.tr);
                                      }
                                    },
                                    child: Icon(
                                        isWished
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: isWished
                                            ? Theme.of(context).primaryColor
                                            : Theme.of(context).disabledColor,
                                        size: 20),
                                  );
                                }),
                              )
                            : const SizedBox(),
                        DiscountTag(
                          discount: product.restaurantDiscount! > 0
                              ? product.restaurantDiscount
                              : product.discount,
                          discountType: product.restaurantDiscount! > 0
                              ? 'percent'
                              : product.discountType,
                          fromTop: Dimensions.paddingSizeSmall,
                          fontSize: Dimensions.fontSizeExtraSmall,
                        ),
                        !isAvailable
                            ? Positioned(
                                top: (product.restaurantDiscount! > 0 ||
                                        product.discount! > 0)
                                    ? Dimensions.paddingSizeSmall + 20
                                    : Dimensions.paddingSizeSmall,
                                child: Container(
                                  width: 90,
                                  height: 20,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(5.0)),
                                  child: FittedBox(
                                      child: Text(
                                    "not_available".tr,
                                    style: const TextStyle(color: Colors.white),
                                  )),
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(
                          Dimensions.paddingSizeExtraSmall),
                      child: 
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: isBestItem == true
                              ? CrossAxisAlignment.center
                              : CrossAxisAlignment.start,
                          children: [
                            FittedBox(
                              //height: 18,
                              child: Text(
                                product.restaurantName!,
                                style: robotoRegular.copyWith(
                                    color: Theme.of(context).disabledColor,
                                    fontSize: Dimensions.fontSizeSmall),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            // const SizedBox(
                            //     height: Dimensions.paddingSizeExtraSmall),
                            FittedBox(
                              child: Row(
                                children: [
                                  Wrap(
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    children: [
                                      FittedBox(
                                        child: Text(product.name!,
                                            style: robotoMedium,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1),
                                      ),
                                      const SizedBox(
                                          width:
                                              Dimensions.paddingSizeExtraSmall),
                                      (Get.find<SplashController>()
                                              .configModel!
                                              .toggleVegNonVeg!)
                                          ? Image.asset(
                                              product.veg == 0
                                                  ? Images.nonVegImage
                                                  : Images.vegImage,
                                              height: 10,
                                              width: 10,
                                              fit: BoxFit.contain,
                                            )
                                          : const SizedBox(),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                                height: Dimensions.paddingSizeExtraSmall),
                            // Row(
                            //   mainAxisAlignment: isBestItem == true
                            //       ? MainAxisAlignment.center
                            //       : MainAxisAlignment.start,
                            //   children: [
                            //     Text(product.avgRating!.toStringAsFixed(1),
                            //         style: robotoRegular.copyWith(
                            //             fontSize: Dimensions.fontSizeExtraSmall)),
                            //     const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                            //     Icon(Icons.star,
                            //         color: Theme.of(context).primaryColor, size: 15),
                            //     const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                            //     Text('(${product.ratingCount})',
                            //         style: robotoRegular.copyWith(
                            //             fontSize: Dimensions.fontSizeExtraSmall,
                            //             color: Theme.of(context).disabledColor)),
                            //   ],
                            // ),
                            // const SizedBox(
                            //     height: Dimensions.paddingSizeExtraSmall),
                            Row(
                              mainAxisAlignment: isBestItem == true
                                  ? MainAxisAlignment.center
                                  : MainAxisAlignment.start,
                              children: [
                                discountPrice < price
                                    ? FittedBox(
                                        child: Text(
                                            PriceConverter.convertPrice(price),
                                            style: robotoRegular.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeExtraSmall,
                                                color: Theme.of(context)
                                                    .disabledColor,
                                                decoration:
                                                    TextDecoration.lineThrough)),
                                      )
                                    : const SizedBox(),
                                discountPrice < price
                                    ? const SizedBox(
                                        width: Dimensions.paddingSizeExtraSmall)
                                    : const SizedBox(),
                                Text(PriceConverter.convertPrice(discountPrice),
                                    style: robotoBold.copyWith(
                                        fontSize: Dimensions.fontSizeSmall)),
                              ],
                            ),
                            // if (Get.find<RestaurantController>()
                            //         .restaurant!
                            //         .delivery ==
                            //     false)
                            //   Text("to go to the shop".tr,
                            //       style: robotoBold.copyWith(
                            //           fontSize: Dimensions.fontSizeSmall))
                          ],
                        ),
                      ),
                    ),
                  ),
                ]),
              )
            : //web view
Container(
                width: isPopularNearbyItem!
                    ? double.infinity
                    :250,
                height:190,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                ),
                child: Column(
                   crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                  
                  Expanded(
                    flex: 4,
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: Dimensions.paddingSizeExtraSmall,
                              left: Dimensions.paddingSizeExtraSmall,
                              right: Dimensions.paddingSizeExtraSmall),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                                topLeft:
                                    Radius.circular(Dimensions.radiusDefault),
                                topRight:
                                    Radius.circular(Dimensions.radiusDefault)),
                            child: CustomImage(
                              placeholder: Images.placeholder,
                              image: !isCampaignItem
                                  ? '${Get.find<SplashController>().configModel?.baseUrls?.productImageUrl}'
                                      '/${product.image}'
                                  : '${Get.find<SplashController>().configModel?.baseUrls?.campaignImageUrl}'
                                      '/${product.image}',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                        ),
                        !isCampaignItem
                            ? Positioned(
                                top: Dimensions.paddingSizeSmall,
                                right: Dimensions.paddingSizeSmall,
                                child: GetBuilder<WishListController>(
                                    builder: (wishController) {
                                  bool isWished = wishController
                                      .wishProductIdList
                                      .contains(product.id);
                                  return InkWell(
                                    onTap: () {
                                      if (Get.find<AuthController>()
                                          .isLoggedIn()) {
                                        isWished
                                            ? wishController.removeFromWishList(
                                                product.id, false)
                                            : wishController.addToWishList(
                                                product, null, false);
                                      } else {
                                        showCustomSnackBar(
                                            'you_are_not_logged_in'.tr);
                                      }
                                    },
                                    child: Icon(
                                        isWished
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: isWished
                                            ? Theme.of(context).primaryColor
                                            : Theme.of(context).disabledColor,
                                        size: 20),
                                  );
                                }),
                              )
                            : const SizedBox(),
                        DiscountTag(
                          discount: product.restaurantDiscount! > 0
                              ? product.restaurantDiscount
                              : product.discount,
                          discountType: product.restaurantDiscount! > 0
                              ? 'percent'
                              : product.discountType,
                          fromTop: Dimensions.paddingSizeSmall,
                          fontSize: Dimensions.fontSizeExtraSmall,
                        ),
                        !isAvailable
                            ? Positioned(
                                top: (product.restaurantDiscount! > 0 ||
                                        product.discount! > 0)
                                    ? Dimensions.paddingSizeSmall + 20
                                    : Dimensions.paddingSizeSmall,
                                child: Container(
                                  width: 90,
                                  height: 20,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(5.0)),
                                  child: FittedBox(
                                      child: Text(
                                    "not_available".tr,
                                    style: const TextStyle(color: Colors.white),
                                  )),
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(
                          Dimensions.paddingSizeExtraSmall),
                      child: Column(
                        crossAxisAlignment: isBestItem == true
                            ? CrossAxisAlignment.center
                            : CrossAxisAlignment.start,
                        children: [
                          FittedBox(
                            //height: 18,
                            child: Text(
                              product.restaurantName!,
                              style: robotoRegular.copyWith(
                                  color: Theme.of(context).disabledColor,
                                  fontSize: Dimensions.fontSizeSmall),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          // const SizedBox(
                          //     height: Dimensions.paddingSizeExtraSmall),
                          FittedBox(
                            child: Row(
                              children: [
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    FittedBox(
                                      child: Text(product.name!,
                                          style: robotoMedium,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1),
                                    ),
                                    const SizedBox(
                                        width:
                                            Dimensions.paddingSizeExtraSmall),
                                    (Get.find<SplashController>()
                                            .configModel!
                                            .toggleVegNonVeg!)
                                        ? Image.asset(
                                            product.veg == 0
                                                ? Images.nonVegImage
                                                : Images.vegImage,
                                            height: 10,
                                            width: 10,
                                            fit: BoxFit.contain,
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                              height: Dimensions.paddingSizeExtraSmall),
                          // Row(
                          //   mainAxisAlignment: isBestItem == true
                          //       ? MainAxisAlignment.center
                          //       : MainAxisAlignment.start,
                          //   children: [
                          //     Text(product.avgRating!.toStringAsFixed(1),
                          //         style: robotoRegular.copyWith(
                          //             fontSize: Dimensions.fontSizeExtraSmall)),
                          //     const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                          //     Icon(Icons.star,
                          //         color: Theme.of(context).primaryColor, size: 15),
                          //     const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                          //     Text('(${product.ratingCount})',
                          //         style: robotoRegular.copyWith(
                          //             fontSize: Dimensions.fontSizeExtraSmall,
                          //             color: Theme.of(context).disabledColor)),
                          //   ],
                          // ),
                          // const SizedBox(
                          //     height: Dimensions.paddingSizeExtraSmall),
                          Row(
                            mainAxisAlignment: isBestItem == true
                                ? MainAxisAlignment.center
                                : MainAxisAlignment.start,
                            children: [
                              discountPrice < price
                                  ? FittedBox(
                                      child: Text(
                                          PriceConverter.convertPrice(price),
                                          style: robotoRegular.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeExtraSmall,
                                              color: Theme.of(context)
                                                  .disabledColor,
                                              decoration:
                                                  TextDecoration.lineThrough)),
                                    )
                                  : const SizedBox(),
                              discountPrice < price
                                  ? const SizedBox(
                                      width: Dimensions.paddingSizeExtraSmall)
                                  : const SizedBox(),
                              Text(PriceConverter.convertPrice(discountPrice),
                                  style: robotoBold.copyWith(
                                      fontSize: Dimensions.fontSizeSmall)),
                            ],
                          ),
                          // if (Get.find<RestaurantController>()
                          //         .restaurant!
                          //         .delivery ==
                          //     false)
                          //   Text("to go to the shop".tr,
                          //       style: robotoBold.copyWith(
                          //           fontSize: Dimensions.fontSizeSmall))
                        ],
                      ),
                    ),
                  ),
                ]),
              )

          
                                  );
  }

  void _showCartSnackBar() {
    ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
      dismissDirection: DismissDirection.horizontal,
      margin: ResponsiveHelper.isDesktop(Get.context)
          ? EdgeInsets.only(
              right: Get.context!.width * 0.7,
              left: Dimensions.paddingSizeSmall,
              bottom: Dimensions.paddingSizeSmall,
            )
          : const EdgeInsets.all(Dimensions.paddingSizeSmall),
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.green,
      action: SnackBarAction(
          label: 'view_cart'.tr,
          textColor: Colors.white,
          onPressed: () {
            Get.toNamed(RouteHelper.getCartRoute());
          }),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
      content: Text(
        'item_added_to_cart'.tr,
        style: robotoMedium.copyWith(color: Colors.white),
      ),
    ));
  }
}

class MenuCardShimmer extends StatelessWidget {
  final bool? isPopularNearbyItem;
  const MenuCardShimmer({super.key, this.isPopularNearbyItem});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: (isPopularNearbyItem! && ResponsiveHelper.isMobile(context))
            ? 1
            : 5,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault),
            child: Shimmer(
              duration: const Duration(seconds: 2),
              enabled: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 240,
                    width: 190,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusDefault),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 133,
                          width: 190,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft:
                                    Radius.circular(Dimensions.radiusDefault),
                                topRight:
                                    Radius.circular(Dimensions.radiusDefault)),
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                                topLeft:
                                    Radius.circular(Dimensions.radiusDefault),
                                topRight:
                                    Radius.circular(Dimensions.radiusDefault)),
                            child: Container(
                              color: Colors.grey[
                                  Get.find<ThemeController>().darkTheme
                                      ? 700
                                      : 300],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 10,
                                width: 100,
                                color: Colors.grey[
                                    Get.find<ThemeController>().darkTheme
                                        ? 700
                                        : 300],
                              ),
                              const SizedBox(
                                  height: Dimensions.paddingSizeExtraSmall),
                              Container(
                                height: 10,
                                width: 150,
                                color: Colors.grey[
                                    Get.find<ThemeController>().darkTheme
                                        ? 700
                                        : 300],
                              ),
                              const SizedBox(
                                  height: Dimensions.paddingSizeExtraSmall),
                              Container(
                                height: 10,
                                width: 100,
                                color: Colors.grey[
                                    Get.find<ThemeController>().darkTheme
                                        ? 700
                                        : 300],
                              ),
                              const SizedBox(
                                  height: Dimensions.paddingSizeExtraSmall),
                              Container(
                                height: 10,
                                width: 100,
                                color: Colors.grey[
                                    Get.find<ThemeController>().darkTheme
                                        ? 700
                                        : 300],
                              ),
                            ],
                          ),
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
    );
  }
}

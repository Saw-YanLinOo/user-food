import 'package:user/controller/product_controller.dart';
import 'package:user/controller/splash_controller.dart';
import 'package:user/controller/theme_controller.dart';
import 'package:user/data/model/response/product_model.dart';
import 'package:user/helper/date_converter.dart';
import 'package:user/helper/price_converter.dart';
import 'package:user/helper/responsive_helper.dart';
import 'package:user/helper/route_helper.dart';
import 'package:user/util/dimensions.dart';
import 'package:user/util/images.dart';
import 'package:user/util/styles.dart';
import 'package:user/view/base/custom_image.dart';
import 'package:user/view/base/discount_tag.dart';
import 'package:user/view/base/handover/on_hover.dart';

import 'package:user/view/base/not_available_widget.dart';
import 'package:user/view/base/product_bottom_sheet.dart';
import 'package:user/view/base/rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:get/get.dart';

class WebPopularFoodView extends StatelessWidget {
  final bool isPopular;
  const WebPopularFoodView({super.key, required this.isPopular});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(builder: (productController) {
      List<Product>? foodList = isPopular
          ? productController.popularProductList
          : productController.reviewedProductList;

      return (foodList != null && foodList.isEmpty)
          ? const SizedBox()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: Dimensions.paddingSizeSmall),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: Dimensions.paddingSizeSmall),
                  child: Text(
                      isPopular
                          ? 'popular_foods_nearby'.tr
                          : 'best_reviewed_food'.tr,
                      style: robotoMedium.copyWith(fontSize: 24)),
                ),
                foodList != null
                    ? GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          childAspectRatio: (1 / 0.36),
                          crossAxisSpacing: Dimensions.paddingSizeLarge,
                          mainAxisSpacing: Dimensions.paddingSizeLarge,
                        ),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(
                            Dimensions.paddingSizeExtraSmall),
                        itemCount: foodList.length > 7 ? 8 : foodList.length,
                        itemBuilder: (context, index) {
                          bool isAvailable = DateConverter.isAvailable(
                            foodList[index].availableTimeStarts,
                            foodList[index].availableTimeEnds,
                          );

                          return Stack(children: [
                            InkWell(
                              onTap: () {
                                ResponsiveHelper.isMobile(context)
                                    ? Get.bottomSheet(
                                        ProductBottomSheet(
                                            product: foodList[index],
                                            isCampaign: false),
                                        backgroundColor: Colors.transparent,
                                        isScrollControlled: true,
                                      )
                                    : Get.dialog(
                                        Dialog(
                                            child: ProductBottomSheet(
                                                product: foodList[index],
                                                isCampaign: false)),
                                      );
                              },
                              child: OnHover(
                                isItem: true,
                                child: Container(
                                  padding: const EdgeInsets.all(
                                      Dimensions.paddingSizeExtraSmall),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    border: Border.all(
                                        color: Theme.of(context)
                                            .disabledColor
                                            .withOpacity(0.5)),
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.radiusSmall),
                                  ),
                                  child: Row(children: [
                                    Stack(children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.radiusSmall),
                                        child: CustomImage(
                                          image:
                                              '${Get.find<SplashController>().configModel!.baseUrls!.productImageUrl}'
                                              '/${foodList[index].image}',
                                          height: 90,
                                          width: 90,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      DiscountTag(
                                        discount: foodList[index].discount,
                                        discountType:
                                            foodList[index].discountType,
                                      ),
                                      isAvailable
                                          ? const SizedBox()
                                          : const NotAvailableWidget(),
                                    ]),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: Dimensions
                                                .paddingSizeExtraSmall),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Wrap(
                                                  crossAxisAlignment:
                                                      WrapCrossAlignment.center,
                                                  children: [
                                                    Text(
                                                      foodList[index].name!,
                                                      style: robotoMedium.copyWith(
                                                          fontSize: Dimensions
                                                              .fontSizeSmall),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    const SizedBox(
                                                        width: Dimensions
                                                            .paddingSizeExtraSmall),
                                                    (Get.find<SplashController>()
                                                            .configModel!
                                                            .toggleVegNonVeg!)
                                                        ? Image.asset(
                                                            foodList[index]
                                                                        .veg ==
                                                                    0
                                                                ? Images
                                                                    .nonVegImage
                                                                : Images
                                                                    .vegImage,
                                                            height: 10,
                                                            width: 10,
                                                            fit: BoxFit.contain,
                                                          )
                                                        : const SizedBox(),
                                                  ]),
                                              const SizedBox(
                                                  height: Dimensions
                                                      .paddingSizeExtraSmall),
                                              Text(
                                                foodList[index].restaurantName!,
                                                style: robotoMedium.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeExtraSmall,
                                                    color: Theme.of(context)
                                                        .disabledColor),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              RatingBar(
                                                rating:
                                                    foodList[index].avgRating,
                                                size: 15,
                                                ratingCount:
                                                    foodList[index].ratingCount,
                                              ),
                                              Row(children: [
                                                Text(
                                                  PriceConverter.convertPrice(
                                                    foodList[index].price,
                                                    discount: foodList[index]
                                                        .discount,
                                                    discountType:
                                                        foodList[index]
                                                            .discountType,
                                                  ),
                                                  textDirection:
                                                      TextDirection.ltr,
                                                  style: robotoBold.copyWith(
                                                      fontSize: Dimensions
                                                          .fontSizeExtraSmall),
                                                ),
                                                SizedBox(
                                                    width: foodList[index]
                                                                .discount! >
                                                            0
                                                        ? Dimensions
                                                            .paddingSizeExtraSmall
                                                        : 0),
                                                foodList[index].discount! > 0
                                                    ? Expanded(
                                                        child: Text(
                                                        PriceConverter
                                                            .convertPrice(
                                                                foodList[index]
                                                                    .price),
                                                        textDirection:
                                                            TextDirection.ltr,
                                                        style: robotoRegular
                                                            .copyWith(
                                                          fontSize: Dimensions
                                                              .fontSizeExtraSmall,
                                                          color: Theme.of(
                                                                  context)
                                                              .disabledColor,
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough,
                                                        ),
                                                      ))
                                                    : const Expanded(
                                                        child: SizedBox()),
                                                const Icon(Icons.add, size: 25),
                                              ]),
                                            ]),
                                      ),
                                    ),
                                  ]),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: index == 7,
                              child: Positioned(
                                top: 0,
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: InkWell(
                                  onTap: () => Get.toNamed(
                                      RouteHelper.getPopularFoodRoute(
                                          isPopular)),
                                  child: OnHover(
                                    isItem: true,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.radiusSmall),
                                        border: Border.all(
                                            color: Theme.of(context)
                                                .disabledColor
                                                .withOpacity(0.5)),
                                        gradient: LinearGradient(
                                            colors: [
                                              Theme.of(context)
                                                  .secondaryHeaderColor
                                                  .withOpacity(0.7),
                                              Theme.of(context)
                                                  .secondaryHeaderColor
                                                  .withOpacity(1),
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        '+${foodList.length - 7}\n${'more'.tr}',
                                        textAlign: TextAlign.center,
                                        style: robotoBold.copyWith(
                                            fontSize: 24,
                                            color: Theme.of(context).cardColor),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ]);
                        },
                      )
                    : WebCampaignShimmer(enabled: foodList == null),
              ],
            );
    });
  }
}

class WebCampaignShimmer extends StatelessWidget {
  final bool enabled;
  const WebCampaignShimmer({super.key, required this.enabled});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: (1 / 0.36),
        crossAxisSpacing: Dimensions.paddingSizeLarge,
        mainAxisSpacing: Dimensions.paddingSizeLarge,
      ),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
      itemCount: 8,
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          ),
          child: Shimmer(
            duration: const Duration(seconds: 2),
            enabled: enabled,
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                height: 90,
                width: 90,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    color: Colors.grey[
                        Get.find<ThemeController>().darkTheme ? 700 : 300]),
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            height: 15,
                            width: 100,
                            color: Colors.grey[
                                Get.find<ThemeController>().darkTheme
                                    ? 700
                                    : 300]),
                        const SizedBox(height: 5),
                        Container(
                            height: 10,
                            width: 130,
                            color: Colors.grey[
                                Get.find<ThemeController>().darkTheme
                                    ? 700
                                    : 300]),
                        const SizedBox(height: 5),
                        const RatingBar(rating: 0.0, size: 12, ratingCount: 0),
                        const SizedBox(height: 5),
                        Container(
                            height: 10,
                            width: 30,
                            color: Colors.grey[
                                Get.find<ThemeController>().darkTheme
                                    ? 700
                                    : 300]),
                      ]),
                ),
              ),
            ]),
          ),
        );
      },
    );
  }
}

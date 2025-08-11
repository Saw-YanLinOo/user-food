import 'package:user/controller/theme_controller.dart';
import 'package:user/helper/responsive_helper.dart';
import 'package:user/util/dimensions.dart';
import 'package:user/util/styles.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../../../controller/product_controller.dart';
import '../new/menu_card.dart';

class WebDiscountedProductView extends StatelessWidget {
  final bool isRecentlyViewed;
  const WebDiscountedProductView({super.key, this.isRecentlyViewed = false});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(builder: (productController) {
      return (productController.allDiscountList != null &&
              productController.allDiscountList!.isEmpty)
          ? const SizedBox()
          : Padding(
              padding: EdgeInsets.symmetric(
                  vertical: ResponsiveHelper.isMobile(context)
                      ? Dimensions.paddingSizeDefault
                      : Dimensions.paddingSizeLarge),
              child: SizedBox(
                height: 232,
                width: Dimensions.webMaxWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ResponsiveHelper.isDesktop(context)
                        ? Padding(
                            padding: const EdgeInsets.only(
                                bottom: Dimensions.paddingSizeOverLarge),
                            child: Text(
                              "Discounted Products".tr,
                              style: robotoMedium.copyWith(
                                  fontSize: Dimensions.fontSizeLarge,
                                  fontWeight: FontWeight.w600),
                            )
                            // .animate()
                            // .fade(duration: const Duration(seconds: 10))
                            // .slideX(curve: Curves.easeIn),
                            )
                        : Padding(
                            padding: const EdgeInsets.only(
                                left: Dimensions.paddingSizeDefault,
                                right: Dimensions.paddingSizeDefault,
                                bottom: Dimensions.paddingSizeLarge),
                            child: Text(
                              "Discounted Products".tr,
                              style: robotoMedium.copyWith(
                                  fontSize: Dimensions.fontSizeLarge,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                    productController.allDiscountList != null
                        ? SizedBox(
                            height: 172,
                            child: ListView.builder(
                                itemCount:
                                    productController.allDiscountList!.length,
                                padding: EdgeInsets.only(
                                    right: ResponsiveHelper.isMobile(context)
                                        ? Dimensions.paddingSizeDefault
                                        : 0),
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {},
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: MenuCard(
                                        isBestItem: false,
                                        product: productController
                                            .allDiscountList![index],
                                        // image:
                                        //     '${Get.find<SplashController>().configModel!.baseUrls!.productImageUrl}'
                                        //     '/${productController.allDiscountList![index].image}',
                                        // name: productController
                                        //     .allDiscountList![index].name!,
                                      ),
                                    ),
                                  );
                                }),
                          )
                        : const PopularRestaurantShimmer()
                  ],
                ),
              ),
            );
    });
  }
}

class PopularRestaurantShimmer extends StatelessWidget {
  const PopularRestaurantShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 172,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(
              left: ResponsiveHelper.isMobile(context)
                  ? Dimensions.paddingSizeDefault
                  : 0,
              right: ResponsiveHelper.isMobile(context)
                  ? Dimensions.paddingSizeDefault
                  : 0),
          itemCount: 4,
          itemBuilder: (context, index) {
            return Shimmer(
              duration: const Duration(seconds: 2),
              enabled: true,
              child: Container(
                margin: EdgeInsets.only(
                    left: index == 0 ? 0 : Dimensions.paddingSizeDefault),
                height: 172,
                width: 253,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                ),
                child: Stack(clipBehavior: Clip.none, children: [
                  Container(
                    height: 85,
                    width: 253,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(Dimensions.radiusDefault),
                          topRight: Radius.circular(Dimensions.radiusDefault)),
                    ),
                    child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(Dimensions.radiusDefault),
                            topRight:
                                Radius.circular(Dimensions.radiusDefault)),
                        child: Container(
                          height: 85,
                          width: 253,
                          color: Colors.grey[
                              Get.find<ThemeController>().darkTheme
                                  ? 700
                                  : 300],
                        )),
                  ),
                  Positioned(
                    top: 90,
                    left: 75,
                    right: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 15,
                          width: 100,
                          color: Colors.grey[
                              Get.find<ThemeController>().darkTheme
                                  ? 700
                                  : 300],
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),
                        Container(
                          height: 15,
                          width: 200,
                          color: Colors.grey[
                              Get.find<ThemeController>().darkTheme
                                  ? 700
                                  : 300],
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),
                      ],
                    ),
                  ),
                ]),
              ),
            );
          }),
    );
  }
}


import 'package:user/controller/splash_controller.dart';
import 'package:user/controller/wishlist_controller.dart';
import 'package:user/data/model/response/product_model.dart';

import 'package:user/helper/responsive_helper.dart';

import 'package:user/util/dimensions.dart';
import 'package:user/util/images.dart';
import 'package:user/util/styles.dart';
import 'package:user/view/base/custom_image.dart';

import 'package:user/view/screens/home/widget/new/icon_with_text_row_widget.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shimmer_animation/shimmer_animation.dart';

class ProductsView extends StatelessWidget {
  final List<Product?>? products;
  
  const ProductsView({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Dimensions.webMaxWidth,
      child: products != null
          ? products!.isNotEmpty
              ? GridView.builder(
                  shrinkWrap: true,
                  itemCount: products!.length,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: ResponsiveHelper.isMobile(context)
                        ? 1
                        : ResponsiveHelper.isTab(context)
                            ? 3
                            : 4,
                    mainAxisSpacing: Dimensions.paddingSizeLarge,
                    crossAxisSpacing: Dimensions.paddingSizeLarge,
                    mainAxisExtent: 210,
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: !ResponsiveHelper.isDesktop(context)
                          ? Dimensions.paddingSizeDefault
                          : 0),
                  itemBuilder: (context, index) {
                    return restaurantView(context, products![index]!);
                  },
                )
              : Center(
                  child: Padding(
                  padding: const EdgeInsets.only(
                      top: Dimensions.paddingSizeOverLarge),
                  child:
                      Text('no_restaurant_available'.tr, style: robotoMedium),
                ))
          : GridView.builder(
              shrinkWrap: true,
              itemCount: 12,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: ResponsiveHelper.isMobile(context)
                    ? 1
                    : ResponsiveHelper.isTab(context)
                        ? 3
                        : 4,
                mainAxisSpacing: Dimensions.paddingSizeLarge,
                crossAxisSpacing: Dimensions.paddingSizeLarge,
                mainAxisExtent: 210,
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: !ResponsiveHelper.isDesktop(context)
                      ? Dimensions.paddingSizeLarge
                      : 0),
              itemBuilder: (context, index) {
                return const WebProductShimmer();
              },
            ),
    );
  }

  Widget restaurantView(BuildContext context, Product restaurant) {
    return InkWell(
      onTap: () {},
      child: 
      Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Dimensions.radiusDefault),
                    topRight: Radius.circular(Dimensions.radiusDefault)),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(Dimensions.radiusDefault),
                    topRight: Radius.circular(Dimensions.radiusDefault)),
                child: CustomImage(
                  image:
                      '${Get.find<SplashController>().configModel!.baseUrls!.productImageUrl}'
                      ,
                  fit: BoxFit.cover,
                  height: 93,
                  width: double.infinity,
                ),
              ),
            ),
            Positioned(
              top: 60,
              left: 10,
              right: 0,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusSmall),
                    ),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusSmall),
                      child: CustomImage(
                        image:
                            '${Get.find<SplashController>().configModel!.baseUrls!.productImageUrl}'
                           ,
                        fit: BoxFit.cover,
                        height: 70,
                        width: 70,
                      ),
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  Text(
                    restaurant.name!,
                    style: robotoMedium.copyWith(
                        fontSize: Dimensions.fontSizeSmall),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconWithTextRowWidget(
                        icon: Icons.star_border,
                        text: restaurant.avgRating.toString(),
                        style: robotoBold.copyWith(
                            fontSize: Dimensions.fontSizeExtraSmall),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeDefault),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: Dimensions.paddingSizeSmall,
              right: Dimensions.paddingSizeSmall,
              child: GetBuilder<WishListController>(builder: (wishController) {
                bool isWished =
                    wishController.wishRestIdList.contains(restaurant.id);
                return InkWell(
                  onTap: () {},
                  child: Icon(
                    Icons.favorite,
                    size: 20,
                    color: isWished
                        ? Theme.of(context).primaryColor
                        : Theme.of(context)
                            .secondaryHeaderColor
                            .withOpacity(0.4),
                  ),
                );
              }),
            ),
            
          ],
        ),
      ),
    );
  }
}

class WebProductShimmer extends StatelessWidget {
  const WebProductShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
      ),
      child: Shimmer(
        duration: const Duration(seconds: 2),
        child: Container(
          // height: 172, width: 290,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 93,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(Dimensions.radiusDefault),
                    topRight: Radius.circular(Dimensions.radiusDefault),
                  ),
                ),
              ),
              Positioned(
                top: 60,
                left: 10,
                right: 0,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2),
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.1),
                        borderRadius:
                            BorderRadius.circular(Dimensions.radiusSmall),
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeSmall),
                    Container(
                        height: 15,
                        width: 100,
                        color: Colors.black.withOpacity(0.1)),
                    const SizedBox(height: 5),
                    Container(
                        height: 10,
                        width: 130,
                        color: Colors.black.withOpacity(0.1)),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconWithTextRowWidget(
                          icon: Icons.star_border,
                          text: '5.0',
                          style: robotoBold.copyWith(
                              fontSize: Dimensions.fontSizeExtraSmall),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: Dimensions.paddingSizeDefault),
                          child: ImageWithTextRowWidget(
                            widget: Image.asset(Images.deliveryIcon,
                                height: 20, width: 20),
                            text: 'free'.tr,
                            style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeExtraSmall),
                          ),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeDefault),
                        IconWithTextRowWidget(
                          icon: Icons.access_time_outlined,
                          text: '10-30 min',
                          style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeExtraSmall),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                top: Dimensions.paddingSizeSmall,
                right: Dimensions.paddingSizeSmall,
                child: Icon(
                  Icons.favorite,
                  size: 20,
                  color:
                      Theme.of(context).secondaryHeaderColor.withOpacity(0.4),
                ),
              ),
              Positioned(
                top: 73,
                right: 5,
                child: Container(
                  height: 23,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(Dimensions.radiusDefault),
                        topRight: Radius.circular(Dimensions.radiusDefault)),
                    color: Theme.of(context).cardColor,
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeExtraSmall),
                  child: Center(
                    child: Text('5 ${'km'.tr}',
                        style: robotoMedium.copyWith(
                            fontSize: Dimensions.fontSizeExtraSmall,
                            color: Theme.of(context).primaryColor)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

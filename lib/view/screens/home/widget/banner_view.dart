import 'package:carousel_slider/carousel_slider.dart';
import 'package:user/controller/banner_controller.dart';
import 'package:user/controller/splash_controller.dart';
import 'package:user/controller/theme_controller.dart';
import 'package:user/data/model/response/basic_campaign_model.dart';
import 'package:user/data/model/response/category_model.dart';
import 'package:user/data/model/response/product_model.dart';
import 'package:user/data/model/response/restaurant_model.dart';
import 'package:user/helper/responsive_helper.dart';
import 'package:user/helper/route_helper.dart';
import 'package:user/util/dimensions.dart';
import 'package:user/util/styles.dart';
import 'package:user/view/base/custom_image.dart';
import 'package:user/view/base/product_bottom_sheet.dart';
import 'package:user/view/screens/restaurant/restaurant_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class BannerView extends StatelessWidget {
  const BannerView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BannerController>(builder: (bannerController) {
      return (bannerController.bannerImageList != null &&
              bannerController.bannerImageList!.isEmpty)
          ? const SizedBox()
          : 
          Container(
              width: MediaQuery.of(context).size.width,
              
              padding:
                  const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
              child: bannerController.bannerImageList != null
                  ? 
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CarouselSlider.builder(
                          options: CarouselOptions(
                          viewportFraction: 1,
                            aspectRatio: 1.7,
                            enlargeFactor: 0.3,
                            autoPlay: true,
                            enlargeCenterPage: true,
                            disableCenter: true,
                            autoPlayInterval: const Duration(seconds: 4),
                            onPageChanged: (index, reason) {
                              bannerController.setCurrentIndex(index, true);
                            },
                          ),
                          itemCount: bannerController.bannerImageList!.isEmpty
                              ? 1
                              : bannerController.bannerImageList!.length,
                          itemBuilder: (context, index, _) {
                            String? baseUrl =
                                bannerController.bannerDataList![index]
                                        is BasicCampaignModel
                                    ? Get.find<SplashController>()
                                        .configModel!
                                        .baseUrls!
                                        .campaignImageUrl
                                    : Get.find<SplashController>()
                                        .configModel!
                                        .baseUrls!
                                        .bannerImageUrl;
                            return InkWell(
                              onTap: () {
                                if (bannerController.bannerDataList![index]
                                    is Product) {
                                  Product? product =
                                      bannerController.bannerDataList![index];
                                  ResponsiveHelper.isMobile(context)
                                      ? showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          builder: (con) => ProductBottomSheet(
                                              product: product),
                                        )
                                      : showDialog(
                                          context: context,
                                          builder: (con) => Dialog(
                                              child: ProductBottomSheet(
                                                  product: product)),
                                        );
                                } else if (bannerController
                                    .bannerDataList![index] is CategoryModel) {
                                  CategoryModel category =
                                      bannerController.bannerDataList![index];

                                  Get.toNamed(
                                    RouteHelper.getCategoryProductRoute(
                                      category.id,
                                      category.name.toString(),
                                    ),
                                  );
                                } else if (bannerController
                                    .bannerDataList![index] is Restaurant) {
                                  Restaurant restaurant =
                                      bannerController.bannerDataList![index];
                                  Get.toNamed(
                                    RouteHelper.getRestaurantRoute(
                                        restaurant.id),
                                    arguments: RestaurantScreen(
                                        restaurant: restaurant),
                                  );
                                } else if (bannerController
                                        .bannerDataList![index]
                                    is BasicCampaignModel) {
                                  BasicCampaignModel campaign =
                                      bannerController.bannerDataList![index];
                                  Get.toNamed(RouteHelper.getBasicCampaignRoute(
                                      campaign));
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).secondaryHeaderColor.withOpacity(0.01),
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radiusSmall),
                                  // boxShadow: [
                                  //   BoxShadow(
                                  //       color: Colors
                                  //           .grey[Get.isDarkMode ? 800 : 200]!,
                                  //       spreadRadius: 1,
                                  //       blurRadius: 5)
                                  // ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                  child: GetBuilder<SplashController>(
                                    builder: (splashController) {
                                      return CustomImage(
                                        image:
                                            '$baseUrl/${bannerController.bannerImageList![index]}',
                                        //fit: BoxFit.fitWidth
                                      
                                       
                                      
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                            height: Dimensions.paddingSizeExtraSmall),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:
                              bannerController.bannerImageList!.map((bnr) {
                            int index =
                                bannerController.bannerImageList!.indexOf(bnr);
                            int totalBanner =
                                bannerController.bannerImageList!.length;
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 3),
                              child: index == bannerController.currentIndex
                                  ? Container(
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.radiusDefault)),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4, vertical:0),
                                      child: Text('${(index) + 1}/$totalBanner',
                                          style: robotoRegular.copyWith(
                                              color: Colors.white,
                                              fontSize: 12)),
                                    )
                                  : Container(
                                      height: 4.18,
                                      width: 5.57,
                                      decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.5),
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.radiusDefault)),
                                    ),
                            );
                          }).toList(),
                        ),
                      ],
                    )
                  : Shimmer(
                      duration: const Duration(seconds: 2),
                      enabled: bannerController.bannerImageList == null,
                      child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(Dimensions.radiusSmall),
                            color: Colors.grey[
                                Get.find<ThemeController>().darkTheme
                                    ? 700
                                    : 300],
                          )),
                    ),
            );
    });
  }
}

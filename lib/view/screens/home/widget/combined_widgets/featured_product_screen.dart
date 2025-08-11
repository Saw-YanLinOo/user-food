import 'package:user/controller/product_controller.dart';
import 'package:user/helper/responsive_helper.dart';
import 'package:user/util/dimensions.dart';
import 'package:user/util/images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../new/menu_card.dart';

class FeaturedProductScreen extends StatelessWidget {
  const FeaturedProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(builder: (productController) {
      return (productController.featuredProdcutList != null &&
              productController.featuredProdcutList!.isEmpty)
          ? const SizedBox()
          : Container(
              width: Dimensions.webMaxWidth,
              decoration: BoxDecoration(
                // color:
                //     Theme.of(context).secondaryHeaderColor.withOpacity(0.1),
                borderRadius: BorderRadius.all(Radius.circular(
                    ResponsiveHelper.isMobile(context)
                        ? 0.1
                        : Dimensions.radiusSmall)),
              ),
              child: Stack(
                children: [
                  Image.asset(Images.cuisineBg,
                      width: Dimensions.webMaxWidth,
                      fit: BoxFit.contain,
                      color: Theme.of(context).primaryColor),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'Featured Products',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17),
                        ),
                      ),
                      productController.featuredProdcutList != null
                          ? ResponsiveHelper.isMobile(context)
                              ? SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 3.1,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    // gridDelegate:
                                    //     const SliverGridDelegateWithFixedCrossAxisCount(
                                    //         crossAxisCount: 2,
                                    //         crossAxisSpacing: 10,
                                    //         mainAxisSpacing: 10),
                                    padding: const EdgeInsets.only(
                                        left: Dimensions.paddingSizeDefault,
                                        right: Dimensions.paddingSizeDefault,
                                        bottom: Dimensions.paddingSizeDefault),
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: productController
                                        .featuredProdcutList?.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {},
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: MenuCard(
                                            isBestItem: false,
                                            product: productController
                                                .featuredProdcutList![index],
                                            // image:
                                            //     '${Get.find<SplashController>().configModel!.baseUrls!.productImageUrl}'
                                            //     '/${productController.featuredProdcutList![index].image}',
                                            // name: productController
                                            //     .featuredProdcutList![index].name!,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 2,
                                  child: ListView.builder(
                                    // gridDelegate:
                                    //     const SliverGridDelegateWithFixedCrossAxisCount(
                                    //         crossAxisCount: 4,
                                    //         crossAxisSpacing: 12,
                                    //         mainAxisSpacing: 12),
                                    padding: const EdgeInsets.only(
                                        left: Dimensions.paddingSizeDefault,
                                        right: Dimensions.paddingSizeDefault,
                                        bottom: Dimensions.paddingSizeDefault),
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: productController
                                        .featuredProdcutList?.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {},
                                        child: MenuCard(
                                          isBestItem: false,
                                          product: productController
                                              .featuredProdcutList![index],
                                          // image:
                                          //     '${Get.find<SplashController>().configModel!.baseUrls!.productImageUrl}'
                                          //     '/${productController.featuredProdcutList![index].image}',
                                          // name: productController
                                          //     .featuredProdcutList![index].name!,
                                        ),
                                      );
                                    },
                                  ),
                                )
                          : Container()
                    ],
                  ),
                ],
              ),
            );
    });
  }
}

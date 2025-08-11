import 'package:user/controller/product_controller.dart';
import 'package:user/helper/responsive_helper.dart';
import 'package:user/util/dimensions.dart';
import 'package:user/util/images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../new/menu_card.dart';

class AllDiscountProductScreen extends StatelessWidget {
  const AllDiscountProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(builder: (productController) {
      return (productController.allDiscountList != null &&
              productController.allDiscountList!.isEmpty)
          ? const SizedBox()
          : Container(
              width: Dimensions.webMaxWidth,
              decoration: BoxDecoration(
                
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
                          'Discounted Products',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17),
                        ),
                      ),
                      productController.allDiscountList != null
                          ? ResponsiveHelper.isMobile(context)
                              ? SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 3.4,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    
                                    padding: const EdgeInsets.only(
                                        left: Dimensions.paddingSizeDefault,
                                        right: Dimensions.paddingSizeDefault,
                                        bottom: Dimensions.paddingSizeDefault),
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: productController
                                        .allDiscountList?.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {},
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: MenuCard(
                                            isBestItem: false,
                                            product: productController
                                                .allDiscountList![index],
                                           
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : 
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 3,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    
                                    padding: const EdgeInsets.only(
                                        left: Dimensions.paddingSizeDefault,
                                        right: Dimensions.paddingSizeDefault,
                                        bottom: Dimensions.paddingSizeDefault),
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: productController
                                        .allDiscountList?.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {},
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: MenuCard(
                                            isBestItem: false,
                                            product: productController
                                                .allDiscountList![index],
                                           
                                          ),
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

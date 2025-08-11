import 'package:user/controller/product_controller.dart';
import 'package:user/util/dimensions.dart';
import 'package:user/view/base/custom_app_bar.dart';
import 'package:user/view/base/product_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PopularFoodScreen extends StatefulWidget {
  final bool isPopular;
  const PopularFoodScreen({super.key, required this.isPopular});

  @override
  State<PopularFoodScreen> createState() => _PopularFoodScreenState();
}

class _PopularFoodScreenState extends State<PopularFoodScreen> {
  @override
  void initState() {
    super.initState();

    if (widget.isPopular) {
      Get.find<ProductController>().getPopularProductList(
          true, Get.find<ProductController>().popularType, false);
    } else {
      Get.find<ProductController>().getReviewedProductList(
          true, Get.find<ProductController>().reviewType, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(builder: (productController) {
      return Scaffold(
        appBar: CustomAppBar(
          title: widget.isPopular
              ? 'popular_foods_nearby'.tr
              : 'best_reviewed_food'.tr,
          showCart: true,
          type: widget.isPopular
              ? productController.popularType
              : productController.reviewType,
          onVegFilterTap: (String type) {
            if (widget.isPopular) {
              productController.getPopularProductList(true, type, true);
            } else {
              productController.getReviewedProductList(true, type, true);
            }
          },
        ),
        body: Scrollbar(
            child: SingleChildScrollView(
                child: Center(
                    child: SizedBox(
          width: Dimensions.webMaxWidth,
          child: GetBuilder<ProductController>(builder: (productController) {
            return ProductView(
              isRestaurant: false,
              restaurants: null,
              products: widget.isPopular
                  ? productController.popularProductList
                  : productController.reviewedProductList,
            );
          }),
        )))),
      );
    });
  }
}

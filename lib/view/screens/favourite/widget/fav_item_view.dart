import 'package:user/controller/wishlist_controller.dart';
import 'package:user/util/dimensions.dart';
import 'package:user/view/base/product_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavItemView extends StatelessWidget {
  final bool isRestaurant;
  const FavItemView({super.key, required this.isRestaurant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<WishListController>(builder: (wishController) {
        return (wishController.wishProductList != null && wishController.wishRestList != null) ? RefreshIndicator(
          onRefresh: () async {
            await wishController.getWishList();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Center(child: SizedBox(
              width: Dimensions.webMaxWidth, child:  ProductView(
                isRestaurant: isRestaurant, products: wishController.wishProductList, restaurants: wishController.wishRestList,
                noDataText: 'no_wish_data_found'.tr,
              ),
            )),
          ),
        ) : const Center(child: CircularProgressIndicator());
      }),
    );
  }
}

import 'package:user/controller/search_controller.dart' as search;
import 'package:user/util/dimensions.dart';
import 'package:user/view/base/product_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemView extends StatelessWidget {
  final bool isRestaurant;
  const ItemView({super.key, required this.isRestaurant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<search.SearchController>(builder: (searchController) {
        return SingleChildScrollView(
          child: Center(child: SizedBox(width: Dimensions.webMaxWidth, child: ProductView(
            isRestaurant: isRestaurant, products: searchController.searchProductList, restaurants: searchController.searchRestList,
          ))),
        );
      }),
    );
  }
}

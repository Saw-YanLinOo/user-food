import 'package:user/controller/cuisine_controller.dart';
import 'package:user/helper/responsive_helper.dart';
import 'package:user/util/dimensions.dart';
import 'package:user/view/base/custom_app_bar.dart';
import 'package:user/view/base/product_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../base/paginated_list_view.dart';

class CuisineRestaurantScreen extends StatefulWidget {
  final int cuisineId;
  final String? name;
  const CuisineRestaurantScreen(
      {super.key, required this.cuisineId, required this.name});

  @override
  State<CuisineRestaurantScreen> createState() =>
      _CuisineRestaurantScreenState();
}

class _CuisineRestaurantScreenState extends State<CuisineRestaurantScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Get.find<CuisineController>().initialize();
    Get.find<CuisineController>()
        .getCuisineRestaurantList(widget.cuisineId, 1, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: '${widget.name!} ${'cuisines'.tr}'),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              width: Dimensions.webMaxWidth,
              child:
                  GetBuilder<CuisineController>(builder: (cuisineController) {
                if (cuisineController.cuisineRestaurantsModel != null) {}
                return PaginatedListView(
                  scrollController: _scrollController,
                  totalSize: cuisineController.cuisineRestaurantsModel?.totalSize,
                  offset: cuisineController.cuisineRestaurantsModel != null
                      ? int.parse(
                          cuisineController.cuisineRestaurantsModel!.offset!)
                      : null,
                  onPaginate: (int? offset) async =>
                      await cuisineController.getCuisineRestaurantList(
                          widget.cuisineId, offset!, false),
                  productView: ProductView(
                    isRestaurant: true,
                    products: null,
                    restaurants: cuisineController.cuisineRestaurantsModel?.restaurants,
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveHelper.isMobile(context)
                          ? Dimensions.paddingSizeExtraSmall
                          : Dimensions.paddingSizeSmall,
                      vertical: ResponsiveHelper.isMobile(context)
                          ? Dimensions.paddingSizeExtraSmall
                          : 0,
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

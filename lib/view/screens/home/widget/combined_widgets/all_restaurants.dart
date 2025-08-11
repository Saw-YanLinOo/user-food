import 'package:user/controller/restaurant_controller.dart';
import 'package:user/view/base/paginated_list_view.dart';
import 'package:user/view/screens/home/widget/combined_widgets/restaurants_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../base/restaurant_custom_app_bar.dart';

class AllRestaurants extends StatelessWidget {
  final ScrollController scrollController;
  const AllRestaurants({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RestaurantController>(builder: (restaurantController) {
      return Scaffold(
        backgroundColor:
            Theme.of(context).secondaryHeaderColor.withOpacity(0.2),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              RestaurantAppBar(
                title: "All Restaurant",
                onVegFilterTap: (String type) {},
              ),
              PaginatedListView(
                scrollController: scrollController,
                totalSize: restaurantController.restaurantModel?.totalSize,
                offset: restaurantController.restaurantModel?.offset,
                onPaginate: (int? offset) async => await restaurantController
                    .getRestaurantList(offset!, false),
                productView: RestaurantsView(
                  restaurants: restaurantController.restaurantModel?.restaurants,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

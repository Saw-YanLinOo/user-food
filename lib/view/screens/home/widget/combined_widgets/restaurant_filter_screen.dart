import 'package:user/controller/restaurant_controller.dart';
import 'package:user/helper/responsive_helper.dart';
import 'package:user/util/dimensions.dart';
import 'package:user/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../new/all_populer_restaurant_filter_button.dart';
import '../new/arrow_icon_button.dart';
import 'all_restaurants.dart';
import 'new_filter_view.dart';

class RestaurantFilterScreen extends StatelessWidget {
  const RestaurantFilterScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    return GetBuilder<RestaurantController>(builder: (restaurantController) {
      return Center(
        child: ResponsiveHelper.isDesktop(context)
            ? 
            Container(
                height: MediaQuery.of(context).size.height * 0.4,
                width: Dimensions.webMaxWidth,
                color: Theme.of(context).colorScheme.surface,
                child:
                 Column(
                  children: [
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('all_restaurants'.tr,
                              style: robotoBold.copyWith(
                                  fontSize: Dimensions.fontSizeLarge)),
                         const SizedBox(width: 10,),
                          Text(
                            '${restaurantController.restaurantModel != null ? restaurantController.restaurantModel!.totalSize : 0} ${'restaurants_near_you'.tr}',
                            style: robotoRegular.copyWith(
                                color: Theme.of(context).disabledColor,
                                fontSize: Dimensions.fontSizeSmall),
                          ),
                         const Expanded(child: SizedBox()),
                           ArrowIconButton(
                          onTap: () {
                            Get.to(AllRestaurants(
                              scrollController: scrollController,
                            ));
                          },
                        )
                        ]),
                    const Expanded(child: SizedBox()),
                    filter(context, restaurantController),
                    const SizedBox(width: Dimensions.paddingSizeSmall),
                  ],
                ))
            : Container(
                color: Theme.of(context).colorScheme.surface,
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeDefault,
                    vertical: Dimensions.paddingSizeExtraSmall),
                child: Column(children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('all_restaurants'.tr,
                            style: robotoBold.copyWith(
                                fontSize: Dimensions.fontSizeLarge)),
                        Text(
                          '${restaurantController.restaurantModel != null ? restaurantController.restaurantModel!.totalSize : 0} ${'restaurants_near_you'.tr}',
                          style: robotoRegular.copyWith(
                              color: Theme.of(context).disabledColor,
                              fontSize: Dimensions.fontSizeSmall),
                        ),
                        ArrowIconButton(
                          onTap: () {
                            Get.to(AllRestaurants(
                              scrollController: scrollController,
                            ));
                          },
                        )
                      ]),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  filter(context, restaurantController),
                ]),
              ),
      );
    });
  }

  Widget filter(
      BuildContext context, RestaurantController restaurantController) {
    return SizedBox(
      height: ResponsiveHelper.isDesktop(context) ? 40 : 30,
      child: ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: [
          ResponsiveHelper.isDesktop(context)
              ? const SizedBox()
              : const NewFilterView(),
          const SizedBox(width: Dimensions.paddingSizeSmall),
          AllPopularRestaurantsFilterButton(
            buttonText: 'Big Restaurant'.tr,
            onTap: () => restaurantController.setBigRestaurant(),
            isSelected: restaurantController.bigRestaurant == 1,
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),
          AllPopularRestaurantsFilterButton(
            buttonText: 'Normal Restaurant'.tr,
            onTap: () => restaurantController.setHomeRestaurant(),
            isSelected: restaurantController.homeRestaurnt == 1,
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),
          AllPopularRestaurantsFilterButton(
            buttonText: 'Street Shop'.tr,
            onTap: () => restaurantController.setStreetShop(),
            isSelected: restaurantController.streetShop == 1,
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),
          AllPopularRestaurantsFilterButton(
            buttonText: 'Online Only Shop'.tr,
            onTap: () => restaurantController.setOnlineOnlyShop(),
            isSelected: restaurantController.onlineOnlyShop == 1,
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),
          AllPopularRestaurantsFilterButton(
            buttonText: 'Top Rated'.tr,
            onTap: () => restaurantController.setTopRated(),
            isSelected: restaurantController.topRated == 1,
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),
          AllPopularRestaurantsFilterButton(
            buttonText: 'Discounted'.tr,
            onTap: () => restaurantController.setDiscount(),
            isSelected: restaurantController.discount == 1,
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),
          AllPopularRestaurantsFilterButton(
            buttonText: 'Veg'.tr,
            onTap: () => restaurantController.setVeg(),
            isSelected: restaurantController.veg == 1,
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),
          AllPopularRestaurantsFilterButton(
            buttonText: 'Non Veg'.tr,
            onTap: () => restaurantController.setNonVeg(),
            isSelected: restaurantController.nonVeg == 1,
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),
          ResponsiveHelper.isDesktop(context)
              ? const NewFilterView()
              : const SizedBox(),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/controller/restaurant_controller.dart';
import 'package:user/util/dimensions.dart';
import 'package:user/util/styles.dart';

class NewFilterView extends StatelessWidget {
  const NewFilterView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RestaurantController>(builder: (restaurant) {
      return restaurant.restaurantModel != null
          ? PopupMenuButton(
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                      value: 'all',
                      textStyle: robotoMedium.copyWith(
                        color: restaurant.restaurantType == 'all'
                            ? Theme.of(context).textTheme.bodyLarge!.color
                            : Theme.of(context).disabledColor,
                      ),
                      child: Text('all'.tr)),
                  PopupMenuItem(
                      value: 'big_restaurant',
                      textStyle: robotoMedium.copyWith(
                        color: restaurant.restaurantType == 'big_restaurant'
                            ? Theme.of(context).textTheme.bodyLarge!.color
                            : Theme.of(context).disabledColor,
                      ),
                      child: Text('Big Restaurant'.tr)),
                  PopupMenuItem(
                      value: 'home_restaurant',
                      textStyle: robotoMedium.copyWith(
                        color: restaurant.restaurantType == 'home_restaurant'
                            ? Theme.of(context).textTheme.bodyLarge!.color
                            : Theme.of(context).disabledColor,
                      ),
                      child: Text('Nomal Restaurant'.tr)),
                  PopupMenuItem(
                      value: 'street_shop',
                      textStyle: robotoMedium.copyWith(
                        color: restaurant.restaurantType == 'street_shop'
                            ? Theme.of(context).textTheme.bodyLarge!.color
                            : Theme.of(context).disabledColor,
                      ),
                      child: Text('Street Shop'.tr)),
                  PopupMenuItem(
                      value: 'online_only_shop',
                      textStyle: robotoMedium.copyWith(
                        color: restaurant.restaurantType == 'online_only_shop'
                            ? Theme.of(context).textTheme.bodyLarge!.color
                            : Theme.of(context).disabledColor,
                      ),
                      child: Text('Online Only Shop'.tr)),
                  PopupMenuItem(
                      value: 'take_away',
                      textStyle: robotoMedium.copyWith(
                        color: restaurant.restaurantType == 'take_away'
                            ? Theme.of(context).textTheme.bodyLarge!.color
                            : Theme.of(context).disabledColor,
                      ),
                      child: Text('take_away'.tr)),
                  PopupMenuItem(
                      value: 'delivery',
                      textStyle: robotoMedium.copyWith(
                        color: restaurant.restaurantType == 'delivery'
                            ? Theme.of(context).textTheme.bodyLarge!.color
                            : Theme.of(context).disabledColor,
                      ),
                      child: Text('delivery Restaurant'.tr)),
                ];
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
              child: Container(
                height: 35,
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeSmall),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  border: Border.all(
                      color: Theme.of(context)
                          .secondaryHeaderColor
                          .withOpacity(0.3)),
                ),
                child: const Center(
                  child: Text(
                    "Filter",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.red,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                // child: Row(
              ),
              //  Icon(Icons.tune,
              //     color: Theme.of(context).primaryColor, size: 20),
              //),

              onSelected: (dynamic value) =>
                  restaurant.setRestaurantType(value),
            )
          : const SizedBox();
    });
  }
}

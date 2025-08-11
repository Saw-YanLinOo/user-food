import 'package:user/controller/restaurant_controller.dart';
import 'package:user/helper/responsive_helper.dart';
import 'package:user/helper/route_helper.dart';

import 'package:user/util/dimensions.dart';
import 'package:user/util/styles.dart';
import 'package:user/view/screens/home/widget/new/arrow_icon_button.dart';
import 'package:user/view/screens/home/widget/new/restaurants_card.dart';
import 'package:user/view/screens/restaurant/restaurant_screen.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class NewOnMOMOFoodView extends StatelessWidget {
  final bool isLatest;
  const NewOnMOMOFoodView({super.key, required this.isLatest});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RestaurantController>(builder: (restController) {
      return (restController.latestRestaurantList != null &&
              restController.latestRestaurantList!.isEmpty)
          ? const SizedBox()
          : Padding(
              padding: EdgeInsets.symmetric(
                  vertical: ResponsiveHelper.isMobile(context)
                      ? Dimensions.paddingSizeDefault
                      : Dimensions.paddingSizeLarge),
              child: Container(
                width: Dimensions.webMaxWidth,
                height: 210,
                color: Theme.of(context).secondaryHeaderColor.withOpacity(0.1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('new_on_momofood'.tr,
                                  style: robotoBold.copyWith(
                                      fontSize: Dimensions.fontSizeLarge)),
                              // .animate()
                              // .fade(duration: const Duration(seconds: 10))
                              // .slideX(curve: Curves.bounceInOut),
                          ArrowIconButton(
                            onTap: () => Get.toNamed(
                                RouteHelper.getAllRestaurantRoute(
                                    isLatest ? 'latest' : '')),
                          ),
                        ],
                      ),
                    ),
                    restController.latestRestaurantList != null
                        ? SizedBox(
                            height: 130,
                            child: ListView.builder(
                              padding: const EdgeInsets.only(
                                  right: Dimensions.paddingSizeDefault),
                              itemCount:
                                  restController.latestRestaurantList!.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: Dimensions.paddingSizeDefault),
                                  child: InkWell(
                                    onTap: () {
                                      Get.toNamed(
                                        RouteHelper.getRestaurantRoute(
                                            restController
                                                .latestRestaurantList![index]
                                                .id),
                                        arguments: RestaurantScreen(
                                            restaurant: restController
                                                .latestRestaurantList![index]),
                                      );
                                    },
                                    child: RestaurantsCard(
                                      isNewOnMOMOFood: true,
                                      restaurant: restController
                                          .latestRestaurantList![index],
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : const RestaurantsCardShimmer(isNewOnMOMOFood: false),
                  ],
                ),
              ),
            );
    });
  }
}

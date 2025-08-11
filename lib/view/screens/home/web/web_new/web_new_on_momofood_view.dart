import 'package:user/controller/restaurant_controller.dart';
import 'package:user/helper/route_helper.dart';
import 'package:user/util/dimensions.dart';
import 'package:user/util/styles.dart';
import 'package:user/view/screens/home/widget/new/arrow_icon_button.dart';
import 'package:user/view/screens/home/widget/new/restaurants_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WebNewOnMOMOFoodView extends StatelessWidget {
  final bool isLatest;
  const WebNewOnMOMOFoodView({super.key, required this.isLatest});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RestaurantController>(builder: (restController) {
      return (restController.latestRestaurantList != null &&
              restController.latestRestaurantList!.isEmpty)
          ? const SizedBox()
          : Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: Dimensions.paddingSizeLarge),
              child: Container(
                width: Dimensions.webMaxWidth,
                color: Theme.of(context).secondaryHeaderColor.withOpacity(0.1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: Dimensions.paddingSizeExtraLarge,
                          left: Dimensions.paddingSizeExtraLarge,
                          bottom: Dimensions.paddingSizeExtraLarge,
                          right: 17),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Text('new_on_momofood'.tr,
                                    style: robotoBold.copyWith(
                                        fontSize: Dimensions.fontSizeLarge)),
                              ],
                            ),
                          ),
                          ArrowIconButton(
                            onTap: () => Get.toNamed(
                                RouteHelper.getAllRestaurantRoute(
                                    isLatest ? 'latest' : '')),
                          ),
                        ],
                      ),
                    ),
                    restController.latestRestaurantList != null
                        ? GridView.builder(
                            padding: const EdgeInsets.only(
                                left: Dimensions.paddingSizeDefault,
                                right: Dimensions.paddingSizeDefault,
                                bottom: Dimensions.paddingSizeDefault),
                            itemCount:
                                restController.latestRestaurantList!.length > 6
                                    ? 6
                                    : restController
                                        .latestRestaurantList!.length,
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: Dimensions.paddingSizeDefault,
                              crossAxisSpacing: Dimensions.paddingSizeDefault,
                              mainAxisExtent:
                                  MediaQuery.of(context).size.height /8,
                            ),
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return RestaurantsCard(
                                isNewOnMOMOFood: true,
                                restaurant:
                                    restController.latestRestaurantList![index],
                              );
                            },
                          )
                        : const RestaurantsCardShimmer(isNewOnMOMOFood: true),
                  ],
                ),
              ),
            );
    });
  }
}

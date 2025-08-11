import 'package:user/helper/responsive_helper.dart';
import 'package:user/util/dimensions.dart';
import 'package:user/util/styles.dart';
import 'package:user/view/base/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../controller/theme_controller.dart';

class RestaurantCart extends StatelessWidget {
  final String image;
  final String name;
  const RestaurantCart({super.key, required this.image, required this.name});

  @override
  Widget build(BuildContext context) {
    return ResponsiveHelper.isMobile(context)
        ? ClipRRect(
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(Dimensions.radiusDefault),
                bottomRight: Radius.circular(Dimensions.radiusDefault)),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(50)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: CustomImage(
                          image: image,
                          fit: BoxFit.cover,
                          height: 100,
                          width: 100),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      alignment: Alignment.center,
                      height: 30,
                      width: 120,
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeExtraSmall),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey[
                                  Get.find<ThemeController>().darkTheme
                                      ? 700
                                      : 300]!,
                              spreadRadius: 0.5,
                              blurRadius: 0.5)
                        ],
                        borderRadius: const BorderRadius.only(
                            bottomLeft:
                                Radius.circular(Dimensions.radiusDefault),
                            bottomRight:
                                Radius.circular(Dimensions.radiusDefault)),
                      ),
                      child: Text(
                        name,
                        style: robotoMedium.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        : //web view
        ClipRRect(
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(Dimensions.radiusDefault),
                bottomRight: Radius.circular(Dimensions.radiusDefault)),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(15)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: CustomImage(
                          image: image,
                          fit: BoxFit.cover,
                          height: 150,
                          width: 150),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      alignment: Alignment.center,
                      height: 30,
                      width: 120,
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeExtraSmall),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey[
                                  Get.find<ThemeController>().darkTheme
                                      ? 700
                                      : 300]!,
                              spreadRadius: 0.5,
                              blurRadius: 0.5)
                        ],
                        borderRadius: const BorderRadius.only(
                            bottomLeft:
                                Radius.circular(Dimensions.radiusDefault),
                            bottomRight:
                                Radius.circular(Dimensions.radiusDefault)),
                      ),
                      child: Text(
                        name,
                        style: robotoMedium.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
  }
}

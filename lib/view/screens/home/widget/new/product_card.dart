import 'package:user/controller/theme_controller.dart';
import 'package:user/util/dimensions.dart';
import 'package:user/util/styles.dart';
import 'package:user/view/base/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductCard extends StatelessWidget {
  final String image;
  final String name;
  const ProductCard({super.key, required this.image, required this.name});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(Dimensions.radiusExtraLarge),
          bottomRight: Radius.circular(Dimensions.radiusExtraLarge)),
      child:
       InkWell(
        onTap: (){},
         child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(50)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CustomImage(
                      image: image, fit: BoxFit.cover, height: 100, width: 100),
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
                  width: 100,
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeExtraSmall),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey[
                              Get.find<ThemeController>().darkTheme ? 700 : 300]!,
                          spreadRadius: 0.5,
                          blurRadius: 0.5)
                    ],
                  ),
                  child: Text(
                    name,
                    style:
                        robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
          ],
             ),
       ),
    );
  }
}

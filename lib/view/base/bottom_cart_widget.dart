// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:user/controller/cart_controller.dart';
import 'package:user/helper/price_converter.dart';
import 'package:user/helper/route_helper.dart';
import 'package:user/util/dimensions.dart';
import 'package:user/util/styles.dart';
import 'package:user/view/base/custom_button.dart';

class BottomCartWidget extends StatelessWidget {
  final String tableId;
  const BottomCartWidget({
    super.key,
    required this.tableId,
  });

  @override
  Widget build(BuildContext context) {
    log("tabieID $tableId btncart");
    return GetBuilder<CartController>(builder: (cartController) {
      return Container(
        height: GetPlatform.isIOS ? 100 : 70,
        width: Get.width,
        padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.paddingSizeExtraLarge),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
                color: const Color(0xFF2A2A2A).withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -5))
          ],
        ),
        child: SafeArea(
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${'item'.tr}: ${cartController.cartList.length}',
                      style: robotoMedium.copyWith(
                          fontSize: Dimensions.fontSizeDefault)),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  Text(
                    '${'total'.tr}: ${PriceConverter.convertPrice(cartController.calculationCart())}',
                    style: robotoMedium.copyWith(
                        fontSize: Dimensions.fontSizeLarge,
                        color: Theme.of(context).primaryColor),
                  ),
                ]),
            CustomButton(
              buttonText: 'view_cart'.tr,
              width: 130,
              height: 45,
              onPressed: () =>
                  Get.toNamed(RouteHelper.getCartRoute(), parameters: {
                'tableId': tableId,
              }),
            ),
          ]),
        ),
      );
    });
  }
}

import 'package:user/util/dimensions.dart';
import 'package:user/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotAvailableDelivery extends StatelessWidget {
  final double fontSize;
  final bool isHomeDelivery;
  const NotAvailableDelivery(
      {super.key, this.fontSize = 8, this.isHomeDelivery = false});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -30,
      left: 0,
      bottom: 0,
      right: 0,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            color: Colors.black.withOpacity(0.6)),
        child: Text(
          isHomeDelivery
              ? 'to go to the shop'.tr
              : 'not_available_now_break'.tr,
          textAlign: TextAlign.center,
          style:
              robotoRegular.copyWith(color: Colors.white, fontSize: fontSize),
        ),
      ),
    );
  }
}

import 'package:user/controller/splash_controller.dart';
import 'package:user/util/dimensions.dart';
import 'package:user/view/screens/home/widget/combined_widgets/location_banner_view.dart';
import 'package:user/view/screens/home/widget/combined_widgets/refer_banner_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WebLocationAndReferBannerView extends StatelessWidget {
  const WebLocationAndReferBannerView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Dimensions.webMaxWidth,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13),
          child: Row(children: [
            const Expanded(
              child: LocationBannerView(),
            ),

            (Get.find<SplashController>().configModel!.refEarningStatus == 1) ? const Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: Dimensions.paddingSizeLarge),
                child: ReferBannerView(),
              ),
            ) : const SizedBox(),
          ],
          ),
        ),
      ),
    );
  }
}




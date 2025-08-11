import 'package:user/controller/splash_controller.dart';
import 'package:user/helper/price_converter.dart';
import 'package:user/helper/responsive_helper.dart';
import 'package:user/helper/route_helper.dart';
import 'package:user/util/dimensions.dart';
import 'package:user/util/images.dart';
import 'package:user/util/styles.dart';
import 'package:user/view/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReferBannerView extends StatelessWidget {
  const ReferBannerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.isMobile(context)
              ? Dimensions.paddingSizeLarge
              : 0,
          vertical: ResponsiveHelper.isMobile(context)
              ? Dimensions.paddingSizeDefault
              : Dimensions.paddingSizeLarge),
      child: Container(
        padding: EdgeInsets.all(ResponsiveHelper.isMobile(context)
            ? 0
            : Dimensions.paddingSizeLarge),
        height: ResponsiveHelper.isMobile(context) ? 85 : 147,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            image: DecorationImage(
                image: Image.asset(Images.referBg).image, fit: BoxFit.fitWidth),
            gradient: LinearGradient(colors: [
              Theme.of(context).colorScheme.tertiary,
              Theme.of(context).colorScheme.tertiaryContainer,
            ])),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  SizedBox(
                      width: ResponsiveHelper.isDesktop(context)
                          ? 180
                          : ResponsiveHelper.isMobile(context)
                              ? 135
                              : 200),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      StreamBuilder<Object>(
                          stream: null,
                          builder: (context, snapshot) {
                            return RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '${'earn'.tr} ',
                                    style: robotoMedium.copyWith(
                                        fontSize:
                                            ResponsiveHelper.isMobile(context)
                                                ? Dimensions.fontSizeSmall
                                                : Dimensions.fontSizeLarge,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  ),
                                  TextSpan(
                                    text:
                                        ' ${PriceConverter.convertPrice(Get.find<SplashController>().configModel!.refEarningExchangeRate)}\n',
                                    style: robotoBold.copyWith(
                                        fontSize:
                                            ResponsiveHelper.isMobile(context)
                                                ? Dimensions.fontSizeLarge
                                                : Dimensions.fontSizeOverLarge,
                                        color: Colors.white),
                                  ),
                                  TextSpan(
                                    text: ' ${'when_you'.tr} \n',
                                    style: robotoRegular.copyWith(
                                        fontSize:
                                            ResponsiveHelper.isMobile(context)
                                                ? Dimensions.fontSizeSmall
                                                : Dimensions.fontSizeDefault,
                                        color: Colors.white),
                                  ),
                                  TextSpan(
                                    text: 'refer_an_friend'.tr,
                                    style: robotoRegular.copyWith(
                                        fontSize:
                                            ResponsiveHelper.isMobile(context)
                                                ? Dimensions.fontSizeSmall
                                                : Dimensions.fontSizeDefault,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            );
                          }),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FittedBox(
                  child: CustomButton(
                      buttonText: 'refer_now'.tr,
                      width: ResponsiveHelper.isMobile(context) ? 65 : 120,
                      height: ResponsiveHelper.isMobile(context) ? 30 : 40,
                      isBold: true,
                      fontSize: Dimensions.fontSizeSmall,
                      textColor: Theme.of(context).primaryColor,
                      radius: Dimensions.radiusSmall,
                      color: Theme.of(context).cardColor,
                      onPressed: () =>
                          Get.toNamed(RouteHelper.getReferAndEarnRoute())),
                ),
              ],
            ),
            SizedBox(
                width: ResponsiveHelper.isMobile(context)
                    ? Dimensions.paddingSizeSmall
                    : 0),
          ],
        ),
      ),
    );
  }
}

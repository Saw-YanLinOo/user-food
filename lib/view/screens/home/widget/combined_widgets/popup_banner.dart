import 'package:user/controller/banner_controller.dart';
import 'package:user/helper/responsive_helper.dart';
import 'package:user/util/dimensions.dart';
import 'package:user/util/images.dart';
import 'package:user/view/base/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PopUpBannerView extends StatelessWidget {
  const PopUpBannerView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BannerController>(builder: (bannerController) {
      return bannerController.popupBannerImage != null
          ? Padding(
              padding: EdgeInsets.symmetric(
                vertical: ResponsiveHelper.isMobile(context)
                    ? Dimensions.paddingSizeDefault
                    : Dimensions.paddingSizeLarge,
                horizontal: !ResponsiveHelper.isDesktop(context)
                    ? Dimensions.paddingSizeDefault
                    : 0,
              ),
              child: SizedBox(
                height: ResponsiveHelper.isMobile(context) ? 70 : 122,
                width: Dimensions.webMaxWidth,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  child: CustomImage(
                    placeholder: Images.placeholder,
                    image:
                        'https://momo.softedify.vip/storage/app/public/banner/${bannerController.popupBannerImage}',
                    fit: BoxFit.fitWidth,
                    width: ResponsiveHelper.isMobile(context) ? 70 : 122,
                  ),
                ),
              ),
            )
          : const SizedBox();
    });
  }
}
 

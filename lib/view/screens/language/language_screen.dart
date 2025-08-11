import 'package:user/helper/responsive_helper.dart';
import 'package:user/helper/route_helper.dart';
import 'package:user/util/styles.dart';
import 'package:user/view/base/custom_app_bar.dart';
import 'package:user/view/screens/language/widget/language_widget.dart';
import 'package:flutter/material.dart';
import 'package:user/controller/localization_controller.dart';
import 'package:user/util/app_constants.dart';
import 'package:user/util/dimensions.dart';
import 'package:user/util/images.dart';
import 'package:user/view/base/custom_button.dart';
import 'package:user/view/base/custom_snackbar.dart';
import 'package:get/get.dart';

class ChooseLanguageScreen extends StatefulWidget {
  final bool fromMenu;
  const ChooseLanguageScreen({super.key, this.fromMenu = false});

  @override
  State<ChooseLanguageScreen> createState() => _ChooseLanguageScreenState();
}

class _ChooseLanguageScreenState extends State<ChooseLanguageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (widget.fromMenu || ResponsiveHelper.isDesktop(context))
          ? CustomAppBar(title: 'language'.tr, isBackButtonExist: true)
          : null,
      body: SafeArea(
        child: GetBuilder<LocalizationController>(
            builder: (localizationController) {
          return Column(children: [
            Expanded(
                child: Center(
              child: Scrollbar(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: Center(
                      child: SizedBox(
                    width: Dimensions.webMaxWidth,
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                              child: Image.asset(Images.logo_text,width:100)),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          // Center(child: Image.asset(Images.logoName, width: 100)),

                          //Center(child: Text(AppConstants.APP_NAME, style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE))),
                          const SizedBox(height: 30),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingSizeExtraSmall),
                            child:
                                Text('select_language'.tr, style: robotoMedium),
                          ),
                          const SizedBox(
                              height: Dimensions.paddingSizeExtraSmall),

                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                    ResponsiveHelper.isDesktop(context)
                                        ? 4
                                        : ResponsiveHelper.isTab(context)
                                            ? 3
                                            : 2,
                                childAspectRatio: (1 / 1),
                                mainAxisSpacing: Dimensions.paddingSizeSmall,
                                crossAxisSpacing: Dimensions.paddingSizeSmall,
                              ),
                              itemCount:
                                  localizationController.languages.length,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.paddingSizeSmall),
                              itemBuilder: (context, index) => LanguageWidget(
                                languageModel:
                                    localizationController.languages[index],
                                localizationController: localizationController,
                                index: index,
                              ),
                            ),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          ResponsiveHelper.isDesktop(context)
                              ? LanguageSaveButton(
                                  localizationController:
                                      localizationController,
                                  fromMenu: widget.fromMenu)
                              : const SizedBox(),
                        ]),
                  )),
                ),
              ),
            )),
            ResponsiveHelper.isDesktop(context)
                ? const SizedBox.shrink()
                : LanguageSaveButton(
                    localizationController: localizationController,
                    fromMenu: widget.fromMenu),
          ]);
        }),
      ),
    );
  }
}

class LanguageSaveButton extends StatelessWidget {
  final LocalizationController localizationController;
  final bool? fromMenu;
  const LanguageSaveButton(
      {super.key, required this.localizationController, this.fromMenu});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        child: Text(
          'you_can_change_language'.tr,
          style: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              color: Theme.of(context).disabledColor),
        ),
      ),
      CustomButton(
        radius: 10,
        buttonText: 'save'.tr,
        margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        onPressed: () {
          if (localizationController.languages.isNotEmpty &&
              localizationController.selectedIndex != -1) {
            localizationController.setLanguage(Locale(
              AppConstants.languages[localizationController.selectedIndex]
                  .languageCode!,
              AppConstants
                  .languages[localizationController.selectedIndex].countryCode,
            ));
            if (fromMenu!) {
              Navigator.pop(context);
            } else {
              Get.offNamed(RouteHelper.getOnBoardingRoute());
            }
          } else {
            showCustomSnackBar('select_a_language'.tr);
          }
        },
      ),
    ]);
  }
}

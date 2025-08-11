import 'package:user/controller/auth_controller.dart';
import 'package:user/controller/localization_controller.dart';
import 'package:user/helper/route_helper.dart';
import 'package:user/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ConditionCheckBox extends StatelessWidget {

  final AuthController authController;
  final bool fromSignUp;
  final bool fromDialog;
  const ConditionCheckBox(
      {super.key,
      required this.authController,
      this.fromSignUp = false,
      this.fromDialog = false});

  @override
  Widget build(BuildContext context) {
    final  localizationController = Get.find<LocalizationController>();
    return Row(
     // crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            fromSignUp ? MainAxisAlignment.start : MainAxisAlignment.center,
        children: [
          fromSignUp
              ? Checkbox(
            side: BorderSide(color: Colors.white60),
                  activeColor: Theme.of(context).primaryColor,
                  value: authController.acceptTerms,
                  onChanged: (bool? isChecked) => authController.toggleTerms(isChecked??false),
                )
              : const SizedBox(),
          fromSignUp ? const SizedBox() : Text('* ', style: robotoRegular),

          Expanded(
            child: InkWell(
              onTap: () =>
                  Get.toNamed(RouteHelper.getHtmlRoute('terms-and-condition')),
            child: RichText(

    text: TextSpan(children: [
    TextSpan(
    text: 'terms_conditions'.tr,
    style: robotoMedium.copyWith(
    color:localizationController.isMM.value? Theme.of(context).secondaryHeaderColor:Theme.of(context).disabledColor)),

    TextSpan(
    text: 'agree'.tr,
    style: robotoMedium.copyWith(
    color:localizationController.isMM.value? Theme.of(context).disabledColor: Theme.of(context)
        .secondaryHeaderColor)),
    ])),
            //   child: CustomText(text:'by_login_i_agree_with_all_the'.tr,
            //     color: Colors.yellow,
            //     fontSize: 11.sp,
            //     maxLines: 2,
            //       ),
             ),
          ),

        ]);
  }
}

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user/controller/auth_controller.dart';
import 'package:user/controller/localization_controller.dart';
import 'package:user/controller/splash_controller.dart';
import 'package:user/data/model/body/social_log_in_body.dart';
import 'package:user/helper/custom_validator.dart';
import 'package:user/helper/responsive_helper.dart';
import 'package:user/helper/route_helper.dart';
import 'package:user/util/dimensions.dart';
import 'package:user/util/images.dart';
import 'package:user/util/styles.dart';
import 'package:user/view/base/custom_app_bar.dart';
import 'package:user/view/base/custom_button.dart';
import 'package:user/view/base/custom_snackbar.dart';
import 'package:user/view/base/custom_text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/view/widgets/custom_text.dart';

class ForgetPassScreen extends StatefulWidget {
  final bool fromSocialLogin;
  final SocialLogInBody? socialLogInBody;
  final bool fromDialog;
  const ForgetPassScreen({
    super.key,
    required this.fromSocialLogin,
    required this.socialLogInBody,
    this.fromDialog = false,
  });

  @override
  State<ForgetPassScreen> createState() => _ForgetPassScreenState();
}

class _ForgetPassScreenState extends State<ForgetPassScreen> {
  final TextEditingController _numberController = TextEditingController();
  final authController = Get.find<AuthController>();
  String? _countryDialCode =
      CountryCode.fromCountryCode(
        Get.find<SplashController>().configModel!.country!,
      ).dialCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: EdgeInsets.all(10.w),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.only(left: 3.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white30,
              ),
              child: Center(
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 15.w,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(Images.termsImg, fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.4),
                  ],
                ),
              ),
            ),
          ),
          Scrollbar(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: Container(
                height: widget.fromDialog ? 600 : context.height,
                width:
                    widget.fromDialog
                        ? 475
                        : context.width > 700
                        ? 700
                        : context.width,
                padding: EdgeInsets.only(
                  top: kToolbarHeight + Dimensions.paddingSizeLarge,
                ),
                decoration:
                    context.width > 700
                        ? BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(
                            Dimensions.radiusSmall,
                          ),
                          boxShadow:
                              ResponsiveHelper.isDesktop(context)
                                  ? null
                                  : [
                                    BoxShadow(
                                      color:
                                          Colors.grey[Get.isDarkMode
                                              ? 700
                                              : 300]!,
                                      blurRadius: 5,
                                      spreadRadius: 1,
                                    ),
                                  ],
                        )
                        : null,
                child: Column(
                  children: [
                    ResponsiveHelper.isDesktop(context)
                        ? Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            onPressed: () => Get.back(),
                            icon: const Icon(Icons.clear),
                          ),
                        )
                        : const SizedBox(),

                    Padding(
                      padding:
                          widget.fromDialog
                              ? const EdgeInsets.all(
                                Dimensions.paddingSizeOverLarge,
                              )
                              : context.width > 700
                              ? const EdgeInsets.all(
                                Dimensions.paddingSizeDefault,
                              )
                              : const EdgeInsets.all(
                                Dimensions.paddingSizeDefault,
                              ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Dimensions.kSizedBoxH20,
                          CustomText(
                            text: 'forgot_pwd_title'.tr,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          Dimensions.kSizedBoxH10,
                          CustomText(
                            color: Colors.white,
                            maxLines: 5,
                            text: 'please_enter_mobile'.tr,
                            fontSize:
                                widget.fromDialog
                                    ? Dimensions.fontSizeSmall
                                    : null,
                          ),
                          Dimensions.kSizedBoxH30,
                          Obx(()=>
                             CustomTextField(
                              showSuffix:authController.isType.value ,
                              borderRadius: Dimensions.roundRadius,
                              titleText: 'phone'.tr,
                              controller: _numberController,
                              inputType: TextInputType.phone,
                              inputAction: TextInputAction.done,
                              isPhone: true,
                              suffixIcon: InkWell(onTap: (){
                                _numberController.text="";
                                authController.isType.value=false;
                              }, child: Padding(
                                padding:  EdgeInsets.all(12.w),
                                child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white38
                                    ),
                                    child: Icon(Icons.clear)),
                              )),
                              showTitle: ResponsiveHelper.isDesktop(context),
                              onCountryChanged: (CountryCode countryCode) {
                                _countryDialCode = countryCode.dialCode;
                              },
                              onChanged: (t){
                                if(t.isNotEmpty){
                                  authController.isType.value=true;
                                }else{
                                  authController.isType.value=false;
                                }
                              },
                              countryDialCode:
                                  _countryDialCode != null
                                      ? CountryCode.fromCountryCode(
                                        Get.find<SplashController>()
                                            .configModel!
                                            .country!,
                                      ).code
                                      : Get.find<LocalizationController>()
                                          .locale
                                          .countryCode,
                              onSubmit:
                                  (text) =>
                                      GetPlatform.isWeb
                                          ? _forgetPass(_countryDialCode!)
                                          : null,
                            ),
                          ),

                          const SizedBox(height: Dimensions.paddingSizeLarge),
                          Dimensions.kSizedBoxH30,
                          Dimensions.kSizedBoxH30,
                          Dimensions.kSizedBoxH30,

                          GetBuilder<AuthController>(
                            builder: (authController) {
                              return CustomButton(
                                radius: Dimensions.roundRadius,
                                buttonText:
                                    widget.fromDialog
                                        ? 'verify'.tr
                                        : 'Continue'.tr,
                                isLoading: authController.isLoading,
                                onPressed: () => _forgetPass(_countryDialCode!),
                              );
                            },
                          ),
                          const SizedBox(
                            height: Dimensions.paddingSizeExtraLarge,
                          ),

                          // RichText(
                          //   text: TextSpan(
                          //     children: [
                          //       TextSpan(
                          //         text:
                          //             '${'if_you_have_any_queries_feel_free_to_contact_with_our'.tr} ',
                          //         style: robotoRegular.copyWith(
                          //           color: Theme.of(context).hintColor,
                          //           fontSize: Dimensions.fontSizeSmall,
                          //         ),
                          //       ),
                          //       TextSpan(
                          //         text: 'help_and_support'.tr,
                          //         style: robotoMedium.copyWith(
                          //           color: Theme.of(context).primaryColor,
                          //           fontSize: Dimensions.fontSizeDefault,
                          //         ),
                          //         recognizer:
                          //             TapGestureRecognizer()
                          //               ..onTap =
                          //                   () => Get.toNamed(
                          //                     RouteHelper.getSupportRoute(),
                          //                   ),
                          //       ),
                          //     ],
                          //   ),
                          //   textAlign: TextAlign.center,
                          //   maxLines: 3,
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _forgetPass(String countryCode) async {
    String phone = _numberController.text.trim();

    String numberWithCountryCode = countryCode + phone;
    // Get.toNamed(RouteHelper.getVerificationRoute(numberWithCountryCode, '', RouteHelper.forgotPassword, ''));

    PhoneValid phoneValid = await CustomValidator.isPhoneValid(
      numberWithCountryCode,
    );
    numberWithCountryCode = phoneValid.phone;

    if (phone.isEmpty) {
      showCustomSnackBar('enter_phone_number'.tr);
    } else if (!phoneValid.isValid) {
      showCustomSnackBar('invalid_phone_number'.tr);
    } else {
      if (widget.fromSocialLogin) {
        widget.socialLogInBody!.phone = numberWithCountryCode;
        Get.find<AuthController>().registerWithSocialMedia(
          widget.socialLogInBody!,
        );
      } else {
        Get.find<AuthController>().forgetPassword(numberWithCountryCode).then((
          status,
        ) async {
          if (status.isSuccess) {
            Get.toNamed(
              RouteHelper.getVerificationRoute(
                numberWithCountryCode,
                '',
                RouteHelper.forgotPassword,
                '',
              ),
            );
          } else {
            showCustomSnackBar(status.message);
          }
        });
      }
    }
  }
}

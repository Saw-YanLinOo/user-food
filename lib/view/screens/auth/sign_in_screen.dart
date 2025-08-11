import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user/controller/auth_controller.dart';
import 'package:user/controller/localization_controller.dart';
import 'package:user/controller/location_controller.dart';
import 'package:user/controller/splash_controller.dart';
import 'package:user/helper/responsive_helper.dart';
import 'package:user/helper/route_helper.dart';
import 'package:user/util/dimensions.dart';
import 'package:user/view/base/custom_snackbar.dart';
import 'package:user/view/screens/auth/sign_up_screen.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:phone_number/phone_number.dart';

import '../../../util/images.dart';
import '../../base/custom_button.dart';
import '../../base/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text.dart';

class SignInScreen extends StatefulWidget {
  final bool exitFromApp;
  final bool backFromThis;
  const SignInScreen(
      {super.key, required this.exitFromApp, required this.backFromThis});

  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _countryDialCode;
  bool _canExit = GetPlatform.isWeb ? true : false;
  late LocalizationController localizationController=Get.put(LocalizationController(sharedPreferences: Get.find(), apiClient: Get.find()));

  @override
  void initState() {
    super.initState();

    _countryDialCode =
        Get.find<AuthController>().getUserCountryCode().isNotEmpty
            ? Get.find<AuthController>().getUserCountryCode()
            : CountryCode.fromCountryCode(
                    Get.find<SplashController>().configModel!.country!)
                .dialCode;
    _phoneController.text = Get.find<AuthController>().getUserNumber();
    _passwordController.text = Get.find<AuthController>().getUserPassword();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.exitFromApp) {
          if (_canExit) {
            if (GetPlatform.isAndroid) {
              SystemNavigator.pop();
            } else if (GetPlatform.isIOS) {
              exit(0);
            } else {
              Navigator.pushNamed(context, RouteHelper.getInitialRoute());
            }
            return Future.value(false);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('back_press_again_to_exit'.tr,
                  style: const TextStyle(color: Colors.white)),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
              margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            ));
            _canExit = true;
            Timer(const Duration(seconds: 2), () {
              _canExit = false;
            });
            return Future.value(false);
          }
        } else {
          return true;
        }
      },
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // Background image covers the whole screen
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Images.loginImg),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
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
            SafeArea(
              child: Scrollbar(
                child: Container(
                  width: context.width > 700 ? 500 : context.width,
                  padding: context.width > 700
                      ? const EdgeInsets.all(50)
                      : const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                  margin: context.width > 700
                      ? const EdgeInsets.all(30)
                      : EdgeInsets.zero,
                  decoration: context.width > 700
                      ? BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius:
                              BorderRadius.circular(Dimensions.radiusSmall),
                          boxShadow: ResponsiveHelper.isDesktop(context)
                              ? null
                              : [
                                  BoxShadow(
                                      color: Colors.grey[
                                          Get.isDarkMode ? 700 : 300]!,
                                      blurRadius: 5,
                                      spreadRadius: 1)
                                ],
                        )
                      : null, // Remove image decoration for mobile
                  child: GetBuilder<AuthController>(builder: (authController) {
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ResponsiveHelper.isDesktop(context)
                                ? Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                      onPressed: () => Get.back(),
                                      icon: const Icon(Icons.clear),
                                    ),
                                  )
                                : Container(),
Dimensions.kSizedBoxH25,
                            Image.asset(Images.splashLogo, width: 100.w),
                            // const SizedBox(height: Dimensions.paddingSizeSmall),
                            // Image.asset(Images.logoName, width: 100),
                            // const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                            Dimensions.kSizedBoxH25,
                            Align(
                              alignment: Alignment.topLeft,
                              child: CustomText(text: 'login'.tr,color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18.sp,)

                            ),
                            Dimensions.kSizedBoxH15,
                    Align(
                        alignment: Alignment.topLeft,
                        child: CustomText(text: 'login_info_text'.tr,color: Colors.white,)),
                            Dimensions.kSizedBoxH15,
                            Obx(()=>
                               CustomTextField(
                                borderRadius: Dimensions.roundRadius,
                                titleText: ResponsiveHelper.isDesktop(context)
                                    ? 'phone'.tr
                                    : 'enter_phone_number'.tr,
                                hintText: 'enter_phone_number'.tr,
                                isValidate:authController.isValidate.value,
                                requireText: 'empty_phone_text'.tr,
                                controller: _phoneController,
                                focusNode: _phoneFocus,
                                nextFocus: _passwordFocus,
                                inputType: TextInputType.phone,
                                prefixIcon: (Icons.phone),
                                isPhone: true,

                                showBorder: true,
                                onCountryChanged: (CountryCode countryCode) {
                                  _countryDialCode = countryCode.dialCode;
                                },
                                countryDialCode: _countryDialCode != null
                                    ? CountryCode.fromCountryCode(
                                            Get.find<SplashController>()
                                                .configModel!
                                                .country!)
                                        .code
                                    : Get.find<LocalizationController>()
                                        .locale
                                        .countryCode,
                              ),
                            ),
                            Dimensions.kSizedBoxH15,

                            Obx(()=>
                               CustomTextField(
                                borderRadius: Dimensions.roundRadius,
                                titleText: ResponsiveHelper.isDesktop(context)
                                    ? 'password'.tr
                                    : 'enter_your_password'.tr,
                                hintText: 'enter_your_password'.tr,
                                controller: _passwordController,
                                focusNode: _passwordFocus,
                                isValidate:authController.isValidate.value,
                                requireText: 'empty_pwd_text'.tr,
                                inputAction: TextInputAction.done,
                                inputType: TextInputType.visiblePassword,
                                prefixIcon: (Icons.lock),
                                isPassword: true,
                                showBorder: true,
                                showTitle: ResponsiveHelper.isDesktop(context),
                                onSubmit: (text) => (GetPlatform.isWeb)
                                    ? _login(authController, _countryDialCode!)
                                    : null,
                              ),
                            ),
                            const SizedBox(
                                height: Dimensions.paddingSizeDefault),

                            Row(children: [
                              Expanded(
                                child: ListTile(
                                  onTap: () =>
                                      authController.toggleRememberMe(),
                                  leading: Checkbox(
                                    side: BorderSide(color: Colors.white),
                                    activeColor: Theme.of(context).primaryColor,
                                    value: authController.isActiveRememberMe,
                                    onChanged: (bool? isChecked) =>
                                        authController.toggleRememberMe(),
                                  ),
                                  title: CustomText(text:'remember_me'.tr,color: Colors.white,),
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                  horizontalTitleGap: 0,
                                ),
                              ),
                              TextButton(
                                onPressed: () => Get.toNamed(
                                    RouteHelper.getForgotPassRoute(
                                        false, null)),
                                child: CustomText(text: '${'forgot_password'.tr}?',
                                  color: Colors.yellow,
                                  textUnderLine: TextDecoration.underline,
                                    ),
                              ),
                            ]),
                            const SizedBox(height: Dimensions.paddingSizeLarge),

                            //ConditionCheckBox(authController: authController),
                            const SizedBox(height: Dimensions.paddingSizeSmall),

                            CustomButton(
height: 40.h,
                              radius: Dimensions.roundRadius,
                              buttonText: 'login'.tr,
                              isLoading: authController.isLoading,
                              onPressed:  () {
                                authController.isValidate.value=true;
                                authController.acceptTerms
                                    ? _login(authController,_countryDialCode!)
                                  : null;}
                            ),
                            Dimensions.kSizedBoxH30,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                    width:40.w,
                                    child: Divider(color: Colors.white)),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                                  child: CustomText(
                                    text: 'or'.tr,
                                    color: Colors.white,
                                    fontSize: 13.sp,
                                  ),
                                ),
                                SizedBox(
                                    width: 40.w,
                                    child: Divider(color: Colors.white)),
                              ],
                            ),
                            Dimensions.kSizedBoxH30,
                    // Register button (yellow outline)
                            Center(
                              child: CustomTTButton(
                                isRounded: true,
                                width: 200.w,
                                bgColor: Colors.transparent,
                                outlineColor: Colors.yellow,
                                txtColor: Colors.yellow,
                                text: 'sign_up_btn'.tr,
                                height: 40.h,
                                onTap: () {
                                  if (ResponsiveHelper.isDesktop(context)) {
                                    Get.back();
                                    Get.dialog(const SignUpScreen());
                                  } else {
                                    Get.toNamed(
                                        RouteHelper.getSignUpRoute());
                                  }
                                },
                              ),
                            ),
                            // Row(
                            //     mainAxisAlignment: MainAxisAlignment.center,
                            //     children: [
                            //       Text('do_not_have_account'.tr,
                            //           style: robotoRegular.copyWith(
                            //               color: Theme.of(context).hintColor)),
                            //       InkWell(
                            //         onTap: () {
                            //           if (ResponsiveHelper.isDesktop(context)) {
                            //             Get.back();
                            //             Get.dialog(const SignUpScreen());
                            //           } else {
                            //             Get.toNamed(
                            //                 RouteHelper.getSignUpRoute());
                            //           }
                            //         },
                            //         child: Padding(
                            //           padding: const EdgeInsets.all(
                            //               Dimensions.paddingSizeExtraSmall),
                            //           child: Text('sign_up'.tr,
                            //               style: robotoMedium.copyWith(
                            //                   color: Theme.of(context)
                            //                       .primaryColor)),
                            //         ),
                            //       ),
                            //     ]),

                            const SizedBox(height: Dimensions.paddingSizeSmall),

                           // const SocialLoginWidget(),

                            //const GuestButton(),
                          ]),
                      ),
                    );
                  }),
                ),
              ),
            ),

               Positioned(
                right: 10.w,
                bottom: MediaQuery.of(context).padding.bottom+30.h,
                child:  Column(
                  children: [
                    InkWell(
                      onTap: (){
                        localizationController.setLanguage(Locale(
                          "my",
                          "MM",
                        ));
                        localizationController.isMM.value=true;
                       // localizationController.setSelectIndex(index);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: 10.w,),
                        child: Container(
                          width:localizationController.isMM.value? 80.w:60.w,
                          padding: EdgeInsets.symmetric(horizontal:localizationController.isMM.value? 10.w:5.w, vertical:localizationController.isMM.value? 4.h:2.h),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.35),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset(Images.myanmar, width:localizationController.isMM.value? 20.w:10.w, height:localizationController.isMM.value? 20.h:10.h),
                              SizedBox(width: 4.w),
                              CustomText(text: 'မြန်မာ', color: Colors.white, fontSize:localizationController.isMM.value? 13.sp:10.sp),
                            ],
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        localizationController.setLanguage(Locale(
                          "en",
                          "US",
                        ));
                        localizationController.isMM.value=false;
                        // localizationController.setSelectIndex(index);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: 10.w,),
                        child: Container(
                          width: localizationController.isMM.value?60.w:80.w,
                          padding: EdgeInsets.symmetric(horizontal:localizationController.isMM.value? 5.w:10.w, vertical:localizationController.isMM.value? 2.h:4.h),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.35),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset(Images.english, width:localizationController.isMM.value? 10.w:20.w, height:localizationController.isMM.value? 10.h:20.h),
                              SizedBox(width: 4.w),
                              CustomText(text: 'EN', color: Colors.white, fontSize:localizationController.isMM.value?10.sp: 13.sp),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),),
            // Positioned(
            //   right: 10.w,
            //   bottom: MediaQuery.of(context).padding.bottom+10.h,
            //   child:  InkWell(
            //     onTap: (){
            //       localizationController.setLanguage(Locale(
            //         "en",
            //         "US",
            //       ));
            //       localizationController.isMM.value=false;
            //       // localizationController.setSelectIndex(index);
            //     },
            //     child: Padding(
            //       padding: EdgeInsets.only(right: 10.w,),
            //       child: Container(
            //         width: localizationController.isMM.value?60.w:80.w,
            //         padding: EdgeInsets.symmetric(horizontal:localizationController.isMM.value? 5.w:10.w, vertical:localizationController.isMM.value? 2.h:4.h),
            //         decoration: BoxDecoration(
            //           color: Colors.white.withOpacity(0.35),
            //           borderRadius: BorderRadius.circular(20.r),
            //         ),
            //         child: Row(
            //           mainAxisSize: MainAxisSize.min,
            //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //           children: [
            //             Image.asset(Images.english, width:localizationController.isMM.value? 10.w:20.w, height:localizationController.isMM.value? 10.h:20.h),
            //             SizedBox(width: 4.w),
            //             CustomText(text: 'EN', color: Colors.white, fontSize:localizationController.isMM.value?10.sp: 13.sp),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ),),

          ],
        ),
      ),
    );
  }

  void _login(AuthController authController, String countryDialCode) async {
    String phone = _phoneController.text.trim();
    String password = _passwordController.text.trim();
    String numberWithCountryCode = countryDialCode + phone;
    String email;
    bool isValid = (GetPlatform.isAndroid && !kIsWeb) ? false : true;
    if (GetPlatform.isAndroid && !kIsWeb) {
      try {
        PhoneNumber phoneNumber =
        await PhoneNumberUtil().parse(numberWithCountryCode);
        numberWithCountryCode =
        '+${phoneNumber.countryCode}${phoneNumber.nationalNumber}';
        isValid = true;
      } catch (_) {}
    }
    if (phone.isEmpty) {
      showCustomSnackBar('enter_phone_number'.tr);
    } else if (!isValid) {
      showCustomSnackBar('invalid_phone_number'.tr);
    } else if (password.isEmpty) {
      showCustomSnackBar('enter_password'.tr);
    } else if (password.length < 6) {
      showCustomSnackBar('password_should_be'.tr);
    } else {
      authController
          .login(numberWithCountryCode, password,
          alreadyInApp: widget.backFromThis)
          .then((status) async {
        if (status.isSuccess) {
          if (authController.isActiveRememberMe) {
            authController.saveUserNumberAndPassword(
                phone, password, countryDialCode);
          } else {
            authController.clearUserNumberAndPassword();
          }

          String token = status.message!.substring(1, status.message!.length);
//get email from status reponse
          String statusMessage = status.message!;

          RegExp emailRegex = RegExp(r"[a-zA-Z0-9.]+@gmail.com");

          String? tokenMessage;

          if (emailRegex.hasMatch(statusMessage)) {
            email = emailRegex.firstMatch(statusMessage)!.group(0)!;

            int emailEndIndex = statusMessage.indexOf(email) + email.length;
            if (emailEndIndex < statusMessage.length) {
              tokenMessage = statusMessage.substring(emailEndIndex);
            }
          } else {
            email = "";
          }

          // print("email: $email");
          // print("tokenMessage: $tokenMessage");

          if (Get.find<SplashController>().configModel!.customerVerification! &&
              tokenMessage![0] == 'n'
          //int.parse(status.message![0]) == 0
          ) {
            List<int> encoded = utf8.encode(password);
            String data = base64Encode(encoded);
            Get.toNamed(RouteHelper.getVerificationRoute(
                email, token, RouteHelper.signUp, data));
          } else {
            // if (widget.backFromThis) {
            //   // Get.back();
            // } else
            // {
            Get.find<LocationController>()
                .navigateToLocationScreen('sign-in', offNamed: true);
            // Get.toNamed(RouteHelper.getAccessLocationRoute('sign-in'));
            // }
          }
        } else {
          showCustomSnackBar(status.message);
        }
      });
    }
  }
}

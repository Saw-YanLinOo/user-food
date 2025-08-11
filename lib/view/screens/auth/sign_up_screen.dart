import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user/controller/auth_controller.dart';
import 'package:user/controller/localization_controller.dart';
import 'package:user/controller/splash_controller.dart';
import 'package:user/helper/responsive_helper.dart';
import 'package:user/helper/route_helper.dart';
import 'package:user/util/dimensions.dart';
import 'package:user/util/images.dart';
import 'package:user/util/styles.dart';
import 'package:user/view/base/custom_text_field.dart';
import 'package:user/view/screens/auth/phone_number_screen.dart';
import 'package:user/view/screens/auth/sign_in_screen.dart';
import 'package:user/view/screens/auth/widget/condition_check_box.dart';
import 'package:user/view/screens/auth/widget/pass_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_number/phone_number.dart';

import '../../../controller/user_controller.dart';
import '../../../theme/dark_theme.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  late LocalizationController localizationController = Get.put(
    LocalizationController(
      sharedPreferences: Get.find(),
      apiClient: Get.find(),
    ),
  );
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final FocusNode _referCodeFocus = FocusNode();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _referCodeController = TextEditingController();
  String? _countryDialCode;

  @override
  void initState() {
    super.initState();

    _countryDialCode =
        CountryCode.fromCountryCode(
          Get.find<SplashController>().configModel!.country!,
        ).dialCode;
    if (Get.find<AuthController>().showPassView) {
      Get.find<AuthController>().showHidePass(isUpdate: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,

      body: Stack(
        children: [
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
                width: context.width > 700 ? 700 : context.width,
                padding:
                    context.width > 700
                        ? EdgeInsets.all(20.w)
                        : EdgeInsets.all(Dimensions.paddingSizeLarge),
                decoration:
                    context.width > 700
                        ? BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(
                            Dimensions.radiusSmall,
                          ),
                        )
                        : null,
                child: GetBuilder<AuthController>(
                  builder: (authController) {
                    return SingleChildScrollView(
                      child: Column(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // ResponsiveHelper.isDesktop(context)
                          //     ? Align(
                          //         alignment: Alignment.topRight,
                          //         child: IconButton(
                          //           onPressed: () => Get.back(),
                          //           icon: const Icon(Icons.clear),
                          //         ),
                          //       )
                          //     : const SizedBox(),
                          const SizedBox(
                            height: Dimensions.paddingSizeExtraLarge,
                          ),
                          Image.asset(Images.splashLogo, width: 100.w),
                          // const SizedBox(height: Dimensions.paddingSizeSmall),
                          // Image.asset(Images.logoName, width: 100),
                          const SizedBox(
                            height: Dimensions.paddingSizeExtraLarge,
                          ),

                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'sign_up'.tr,
                              style: robotoBold.copyWith(
                                color: Colors.white,
                                fontSize: Dimensions.fontSizeExtraLarge,
                              ),
                            ),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          Align(
                            alignment: Alignment.topLeft,
                            child: CustomText(
                              text: 'login_info_text'.tr,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeDefault),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          Obx(
                            () => CustomTextField(
                              isValidate: authController.isSignUpValidate.value,
                              borderRadius: Dimensions.roundRadius,
                              requireText: 'empty_name_text'.tr,
                              titleText: 'first_name'.tr,
                              hintText: 'ex_jhon'.tr,
                              controller: _firstNameController,
                              focusNode: _firstNameFocus,
                              nextFocus:
                                  ResponsiveHelper.isDesktop(context)
                                      ? _emailFocus
                                      : _phoneFocus,
                              inputType: TextInputType.name,
                              capitalization: TextCapitalization.words,
                              prefixIcon: (Icons.person),
                              showTitle: ResponsiveHelper.isDesktop(context),
                            ),
                          ),
                          const SizedBox(
                            height: Dimensions.paddingSizeExtraLarge,
                          ),

                          // Row(children: [
                          //   ResponsiveHelper.isDesktop(context)
                          //       ? Expanded(
                          //           child: CustomTextField(
                          //             titleText: 'email'.tr,
                          //             hintText: 'enter_email'.tr,
                          //             controller: _emailController,
                          //             focusNode: _emailFocus,
                          //             nextFocus:
                          //                 ResponsiveHelper.isDesktop(context)
                          //                     ? _phoneFocus
                          //                     : _passwordFocus,
                          //             inputType: TextInputType.emailAddress,
                          //             prefixIcon: (Icons.mail_outline_rounded),
                          //             showTitle:
                          //                 ResponsiveHelper.isDesktop(context),
                          //           ),
                          //         )
                          //       : const SizedBox(),
                          //   SizedBox(
                          //       width: ResponsiveHelper.isDesktop(context)
                          //           ? Dimensions.paddingSizeSmall
                          //           : 0),
                          //   Expanded(
                          //     child: CustomTextField(
                          //       titleText: ResponsiveHelper.isDesktop(context)
                          //           ? 'phone'.tr
                          //           : 'enter_phone_number'.tr,
                          //       controller: _phoneController,
                          //       focusNode: _phoneFocus,
                          //       nextFocus: ResponsiveHelper.isDesktop(context)
                          //           ? _passwordFocus
                          //           : _emailFocus,
                          //       inputType: TextInputType.phone,
                          //       isPhone: true,
                          //       showTitle: ResponsiveHelper.isDesktop(context),
                          //       onCountryChanged: (CountryCode countryCode) {
                          //         _countryDialCode = countryCode.dialCode;
                          //       },
                          //       countryDialCode: _countryDialCode != null
                          //           ? CountryCode.fromCountryCode(
                          //                   Get.find<SplashController>()
                          //                       .configModel!
                          //                       .country!)
                          //               .code
                          //           : Get.find<LocalizationController>()
                          //               .locale
                          //               .countryCode,
                          //     ),
                          //   ),
                          // ]),
                          // const SizedBox(height: Dimensions.paddingSizeLarge),

                          // !ResponsiveHelper.isDesktop(context)
                          //     ? CustomTextField(
                          //         titleText: 'email'.tr,
                          //         hintText: 'enter_email'.tr,
                          //         controller: _emailController,
                          //         focusNode: _emailFocus,
                          //         nextFocus: _passwordFocus,
                          //         inputType: TextInputType.emailAddress,
                          //         prefixIcon: (Icons.mail_outline_rounded),
                          //         divider: false,
                          //       )
                          //     : const SizedBox(),
                          // SizedBox(
                          //     height: !ResponsiveHelper.isDesktop(context)
                          //         ? Dimensions.paddingSizeLarge
                          //         : 0),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Obx(
                                      () => CustomTextField(
                                        borderRadius: Dimensions.roundRadius,
                                        titleText: 'password'.tr,
                                        hintText: 'password'.tr,
                                        controller: _passwordController,
                                        focusNode: _passwordFocus,
                                        nextFocus: _confirmPasswordFocus,
                                        isValidate:
                                            authController
                                                .isSignUpValidate
                                                .value,
                                        requireText: 'empty_pwd_text'.tr,
                                        inputType:
                                            TextInputType.visiblePassword,
                                        prefixIcon: (Icons.lock),
                                        isPassword: true,
                                        showTitle: ResponsiveHelper.isDesktop(
                                          context,
                                        ),
                                        onChanged: (value) {
                                          if (value != null &&
                                              value.isNotEmpty) {
                                            if (!authController.showPassView) {
                                              authController.showHidePass();
                                            }
                                            authController.validPassCheck(
                                              value,
                                            );
                                          } else {
                                            if (authController.showPassView) {
                                              authController.showHidePass();
                                            }
                                          }
                                        },
                                      ),
                                    ),
                                    authController.showPassView
                                        ? const PassView()
                                        : const SizedBox(),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width:
                                    ResponsiveHelper.isDesktop(context)
                                        ? Dimensions.paddingSizeSmall
                                        : 0,
                              ),
                              // ResponsiveHelper.isDesktop(context)
                              //     ? Expanded(
                              //         child: CustomTextField(
                              //         titleText: 'confirm_password'.tr,
                              //         hintText: 'confirm_password'.tr,
                              //         controller: _confirmPasswordController,
                              //         focusNode: _confirmPasswordFocus,
                              //         nextFocus: Get.find<SplashController>()
                              //                     .configModel!
                              //                     .refEarningStatus ==
                              //                 1
                              //             ? _referCodeFocus
                              //             : null,
                              //         inputAction: Get.find<SplashController>()
                              //                     .configModel!
                              //                     .refEarningStatus ==
                              //                 1
                              //             ? TextInputAction.next
                              //             : TextInputAction.done,
                              //         inputType: TextInputType.visiblePassword,
                              //         prefixIcon: (Icons.lock),
                              //         isPassword: true,
                              //         showTitle:
                              //             ResponsiveHelper.isDesktop(context),
                              //         onSubmit: (text) => (GetPlatform.isWeb)
                              //             ? _register(
                              //                 authController, _countryDialCode!)
                              //             : null,
                              //       ))
                              //     : const SizedBox()
                            ],
                          ),
                          // const SizedBox(height: Dimensions.paddingSizeLarge),

                          // !ResponsiveHelper.isDesktop(context)
                          //     ? CustomTextField(
                          //         titleText: 'confirm_password'.tr,
                          //         hintText: 'confirm_password'.tr,
                          //         controller: _confirmPasswordController,
                          //         focusNode: _confirmPasswordFocus,
                          //         nextFocus: Get.find<SplashController>()
                          //                     .configModel!
                          //                     .refEarningStatus ==
                          //                 1
                          //             ? _referCodeFocus
                          //             : null,
                          //         inputAction: Get.find<SplashController>()
                          //                     .configModel!
                          //                     .refEarningStatus ==
                          //                 1
                          //             ? TextInputAction.next
                          //             : TextInputAction.done,
                          //         inputType: TextInputType.visiblePassword,
                          //         prefixIcon: (Icons.lock),
                          //         isPassword: true,
                          //         onSubmit: (text) => (GetPlatform.isWeb)
                          //             ? _register(
                          //                 authController, _countryDialCode!)
                          //             : null,
                          //       )
                          //     : const SizedBox(),
                          // SizedBox(
                          //     height: !ResponsiveHelper.isDesktop(context)
                          //         ? Dimensions.paddingSizeLarge
                          //         : 0),
                          //
                          // (Get.find<SplashController>()
                          //             .configModel!
                          //             .refEarningStatus ==
                          //         1)
                          //     ? CustomTextField(
                          //         hintText: 'refer_code'.tr,
                          //         titleText: 'refer_code'.tr,
                          //         controller: _referCodeController,
                          //         focusNode: _referCodeFocus,
                          //         inputAction: TextInputAction.done,
                          //         inputType: TextInputType.text,
                          //         capitalization: TextCapitalization.words,
                          //         // prefixIcon: Images.referCode,
                          //         prefixImage: Images.referCode,
                          //         divider: false,
                          //         prefixSize: 14,
                          //         showTitle: ResponsiveHelper.isDesktop(context),
                          //       )
                          //     : const SizedBox(),
                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          ConditionCheckBox(
                            authController: authController,
                            fromSignUp: true,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          Dimensions.kSizedBoxH10,
                          CustomTTButton(
                            isRounded: true,
                            outlineColor:
                                authController.acceptTerms
                                    ? dark.primaryColor
                                    : Theme.of(context).disabledColor,
                            bgColor:
                                authController.acceptTerms
                                    ? dark.primaryColor
                                    : Theme.of(context).disabledColor,
                            text: 'sign_up_btn'.tr,
                            onTap: () {
                              authController.isSignUpValidate.value = true;
                              if (authController.acceptTerms) {
                                _register(authController, _countryDialCode!);
                              }
                            },
                          ),
                          // CustomButton(
                          //   radius: Dimensions.roundRadius,
                          //   buttonText: 'sign_up_btn'.tr,
                          //   isLoading: authController.isLoading,
                          //   onPressed:() {
                          //     authController.isSignUpValidate.value=true;
                          //     authController.acceptTerms
                          //       ? () =>
                          //       _register(authController, _countryDialCode!)
                          //       : null;},
                          // ),
                          Dimensions.kSizedBoxH20,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 40.w,
                                child: Divider(color: Colors.white),
                              ),
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
                                child: Divider(color: Colors.white),
                              ),
                            ],
                          ),
                          Dimensions.kSizedBoxH20,
                          // Register button (yellow outline)
                          Center(
                            child: CustomTTButton(
                              isRounded: true,
                              width: 200.w,
                              bgColor: Colors.transparent,
                              outlineColor: Colors.yellow,
                              txtColor: Colors.yellow,
                              text: 'guest_user'.tr,
                              height: 40.h,
                              onTap: () {
                                authController.guestLogin().then((response) {
                                  if (response.isSuccess) {
                                    Get.find<UserController>()
                                        .setForceFullyUserEmpty();
                                    Navigator.pushReplacementNamed(
                                      context,
                                      RouteHelper.getInitialRoute(),
                                    );
                                  }
                                });
                              },
                            ),
                          ),
                          Dimensions.kSizedBoxH10,
                          Center(
                            child: CustomTTButton(
                              isRounded: true,
                              width: 200.w,
                              bgColor: Colors.transparent,
                              outlineColor: Colors.yellow,
                              txtColor: Colors.yellow,
                              text: 'login_btn'.tr,
                              height: 40.h,
                              onTap: () {
                                if (ResponsiveHelper.isDesktop(context)) {
                                  Get.back();
                                  Get.dialog(
                                    const SignInScreen(
                                      exitFromApp: false,
                                      backFromThis: false,
                                    ),
                                  );
                                } else {
                                  Get.toNamed(
                                    RouteHelper.getSignInRoute(
                                      RouteHelper.signUp,
                                    ),
                                  );
                                }
                              },
                            ),
                          ),

                          // SocialLoginWidget(),

                          // const GuestButton(),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Positioned(
            right: 10.w,
            bottom: MediaQuery.of(context).padding.bottom + 30.h,
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    localizationController.setLanguage(Locale("my", "MM"));
                    localizationController.isMM.value = true;
                    // localizationController.setSelectIndex(index);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 10.w),
                    child: Container(
                      width: localizationController.isMM.value ? 80.w : 60.w,
                      padding: EdgeInsets.symmetric(
                        horizontal:
                            localizationController.isMM.value ? 10.w : 5.w,
                        vertical: localizationController.isMM.value ? 4.h : 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.35),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset(
                            Images.myanmar,
                            width:
                                localizationController.isMM.value ? 20.w : 10.w,
                            height:
                                localizationController.isMM.value ? 20.h : 10.h,
                          ),
                          SizedBox(width: 4.w),
                          CustomText(
                            text: 'မြန်မာ',
                            color: Colors.white,
                            fontSize:
                                localizationController.isMM.value
                                    ? 13.sp
                                    : 10.sp,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    localizationController.setLanguage(Locale("en", "US"));
                    localizationController.isMM.value = false;
                    // localizationController.setSelectIndex(index);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 10.w),
                    child: Container(
                      width: localizationController.isMM.value ? 60.w : 80.w,
                      padding: EdgeInsets.symmetric(
                        horizontal:
                            localizationController.isMM.value ? 5.w : 10.w,
                        vertical: localizationController.isMM.value ? 2.h : 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.35),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset(
                            Images.english,
                            width:
                                localizationController.isMM.value ? 10.w : 20.w,
                            height:
                                localizationController.isMM.value ? 10.h : 20.h,
                          ),
                          SizedBox(width: 4.w),
                          CustomText(
                            text: 'EN',
                            color: Colors.white,
                            fontSize:
                                localizationController.isMM.value
                                    ? 10.sp
                                    : 13.sp,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _register(AuthController authController, String countryCode) async {
    print("zzzzzzzzzzzzzzzz");
    String firstName = _firstNameController.text.trim();
    // String lastName = _lastNameController.text.trim();
    String email = _emailController.text.trim();
    String number = _phoneController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();
    String referCode = _referCodeController.text.trim();

    String numberWithCountryCode = countryCode + number;
    bool isValid = GetPlatform.isAndroid ? false : true;
    if (GetPlatform.isAndroid) {
      try {
        PhoneNumber phoneNumber = await PhoneNumberUtil().parse(
          numberWithCountryCode,
        );
        numberWithCountryCode =
            '+${phoneNumber.countryCode}${phoneNumber.nationalNumber}';
        isValid = true;
      } catch (_) {}
    }

    if (firstName.isNotEmpty && password.isNotEmpty) {
      Get.to(() => PhoneNumberScreen());
    }
    // if (firstName.isEmpty) {
    //   showCustomSnackBar('enter_your_first_name'.tr);
    // }
    // else if (lastName.isEmpty) {
    //   showCustomSnackBar('enter_your_last_name'.tr);
    // }
    // else if (email.isEmpty) {
    //   showCustomSnackBar('enter_email_address'.tr);
    // } else if (!GetUtils.isEmail(email)) {
    //   showCustomSnackBar('enter_a_valid_email_address'.tr);
    // } else if (number.isEmpty) {
    //   showCustomSnackBar('enter_phone_number'.tr);
    // } else if (!isValid) {
    //   showCustomSnackBar('invalid_phone_number'.tr);
    // } else if (password.isEmpty) {
    //   showCustomSnackBar('enter_password'.tr);
    // } else if (password.length < 6) {
    //   showCustomSnackBar('password_should_be'.tr);
    // } else if (password != confirmPassword) {
    //   showCustomSnackBar('confirm_password_does_not_matched'.tr);
    // } else if (referCode.isNotEmpty && referCode.length != 10) {
    //   showCustomSnackBar('invalid_refer_code'.tr);
    // } else {
    //   SignUpBody signUpBody = SignUpBody(
    //     fName: firstName,
    //     // lName: lastName,
    //     email: email,
    //     phone: numberWithCountryCode,
    //     password: password,
    //     refCode: referCode,
    //   );
    //   authController.registration(signUpBody).then((status) async {
    //     if (status.isSuccess) {
    //       if (Get.find<SplashController>().configModel!.customerVerification!) {
    //         List<int> encoded = utf8.encode(password);
    //         String data = base64Encode(encoded);
    //         Get.toNamed(RouteHelper.getVerificationRoute(
    //             email, status.message, RouteHelper.signUp, data));
    //       } else {
    //         Get.find<LocationController>()
    //             .navigateToLocationScreen(RouteHelper.signUp);
    //         //Get.toNamed(RouteHelper.getAccessLocationRoute(RouteHelper.signUp));
    //       }
    //     } else {
    //       showCustomSnackBar(status.message);
    //     }
    //  });
    //}
  }
}

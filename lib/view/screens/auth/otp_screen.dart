import 'dart:async';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user/controller/auth_controller.dart';
import 'package:user/controller/splash_controller.dart';
import 'package:user/helper/route_helper.dart';
import 'package:user/util/dimensions.dart';
import 'package:user/util/images.dart';
import 'package:user/util/styles.dart';
import 'package:user/view/base/custom_button.dart';
import 'package:user/view/base/custom_dialog.dart';
import 'package:user/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:user/view/widgets/custom_text.dart';

class OTPScreen extends StatefulWidget {
  final String? email;
  final bool fromSignUp;
  final String? token;
  final String password;
  const OTPScreen(
      {super.key,
        required this.email,
        required this.password,
        required this.fromSignUp,
        required this.token});

  @override
  OTPScreenState createState() => OTPScreenState();
}

class OTPScreenState extends State<OTPScreen> {
  String? _email;
  Timer? _timer;
  int _seconds = 0;

  @override
  void initState() {
    super.initState();

    // print('-------${widget.fromSignUp} // ${(widget.password.isNotEmpty)}');

    Get.find<AuthController>().updateVerificationCode('', canUpdate: false);
    _email = widget.email;
    _startTimer();
  }

  void _startTimer() {
    _seconds = 120;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _seconds = _seconds - 1;
      if (_seconds == 0) {
        timer.cancel();
        _timer?.cancel();
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();

    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding:  EdgeInsets.all(10.w),
          child: InkWell(
            onTap:(){
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.only(left: 3.w),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white30
              ),
              child: Center(child: Icon(Icons.arrow_back_ios,color: Colors.white,size: 15.w,)),
            ),
          ),
        ),
      ),
      body: Stack(

        children: [
          Positioned.fill(
            child: Image.asset(
              Images.termsImg,
              fit: BoxFit.cover,
            ),
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
          SafeArea(
              child: Scrollbar(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                    child: Container(
                      width: context.width > 700 ? 700 : context.width,
                      height: context.height,
                      padding: context.width > 700
                          ? const EdgeInsets.all(Dimensions.paddingSizeDefault)
                          : null,
                      decoration: context.width > 700
                          ? BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey[Get.isDarkMode ? 700 : 300]!,
                              blurRadius: 5,
                              spreadRadius: 1)
                        ],
                      )
                          : null,
                      child: GetBuilder<AuthController>(builder: (authController) {
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Dimensions.kSizedBoxH30,
                              Dimensions.kSizedBoxH30,
                          CustomText(text: 'otp_title'.tr,fontWeight: FontWeight.bold,fontSize: 18.sp,color: Colors.white,),
                          Dimensions.kSizedBoxH10,
                          Get.find<SplashController>().configModel!.demo!
                              ? Text(
                            'for_demo_purpose'.tr,
                            style: robotoRegular,
                          )
                              : RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text: 'otp_body'.tr,
                                    style: robotoRegular.copyWith(
                                        color: Theme.of(context).disabledColor)),
                                TextSpan(
                                    text: '$_email',
                                    style: robotoMedium.copyWith(
                                        color: Theme.of(context)
                                            .cardColor)),
                                TextSpan(
                                    text: 'otp_body1'.tr,
                                    style: robotoRegular.copyWith(
                                        color: Theme.of(context).disabledColor)),
                              ])),

Dimensions.kSizedBoxH20,
                          Padding(
                            padding:
                             EdgeInsets.symmetric(horizontal: 39.w, vertical: 20.h),
                            child: PinCodeTextField(
                              textStyle: TextStyle(
                                color: Colors.white
                              ),
                              length: 4,
                              appContext: context,
                              keyboardType: TextInputType.number,
                              animationType: AnimationType.slide,

                              pinTheme: PinTheme(
                                shape: PinCodeFieldShape.box,
                                fieldHeight: 60,
                                fieldWidth: 60,
                                borderWidth: 1,
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                selectedColor:
                                Colors.white,
                                selectedFillColor: Theme.of(context).disabledColor.withOpacity(0.2),
                                inactiveFillColor:
                                Theme.of(context).disabledColor.withOpacity(0.2),
                                inactiveColor:
                                Theme.of(context).disabledColor.withOpacity(0.2),
                                activeColor:
                                Theme.of(context).disabledColor.withOpacity(0.2),
                                activeFillColor:
                                Theme.of(context).disabledColor.withOpacity(0.2),
                              ),
                              animationDuration: const Duration(milliseconds: 300),
                              backgroundColor: Colors.transparent,
                              enableActiveFill: true,
                              onChanged: authController.updateVerificationCode,
                              beforeTextPaste: (text) => true,
                            ),
                          ),
                          /*(widget.password.isNotEmpty) ?*/ Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Text(
                                //   'did_not_receive_the_code'.tr,
                                //   style: robotoRegular.copyWith(
                                //       color: Theme.of(context).disabledColor),
                                // ),
                                _seconds > 0? Text(
                                    style: robotoRegular.copyWith(
                                        color: Theme.of(context).secondaryHeaderColor),

                                       ' ${(_seconds ~/ 60).toString().padLeft(2, '0')}:${(_seconds % 60).toString().padLeft(2, '0')}'
                                        ,):
                                InkWell(
                                  onTap: (){
                                    Get.find<AuthController>().updateVerificationCode('', canUpdate: false);
                                    _startTimer();
                                  },
                                  child: CustomText(text: 'resend'.tr,
                                  textUnderLine: TextDecoration.underline,
                                  color:Colors.yellow,),
                                )
                                ,
                                Dimensions.kSizedBoxH30,

                                // TextButton(
                                //   onPressed: _seconds < 1
                                //       ? () {
                                //           if (widget.fromSignUp) {
                                //             authController
                                //                 .login(_email, widget.password)
                                //                 .then((value) {
                                //               if (value.isSuccess) {
                                //                 _startTimer();
                                //                 showCustomSnackBar(
                                //                     'resend_code_successful'.tr,
                                //                     isError: false);
                                //               } else {
                                //                 showCustomSnackBar(value.message);
                                //               }
                                //             });
                                //           } else {
                                //             authController
                                //                 .forgetPassword(_email)
                                //                 .then((value) {
                                //               if (value.isSuccess) {
                                //                 _startTimer();
                                //                 showCustomSnackBar(
                                //                     'resend_code_successful'.tr,
                                //                     isError: false);
                                //               } else {
                                //                 showCustomSnackBar(value.message);
                                //               }
                                //             });
                                //           }
                                //         }
                                //       : null,
                                //   child: Text(
                                //       '${'remaining time'.tr}${_seconds > 0 ? ' ($_seconds)' : ''}'),
                                // ),
                              ]) /* : const SizedBox()*/,
                          Dimensions.kSizedBoxH30,
                          // authController.verificationCode.length == 4
                          //     ?
                          CustomButton(
                            radius: Dimensions.roundRadius,
                            buttonText: 'Continue'.tr,
                            isLoading: authController.isLoading,
                            onPressed: () {
                              if (widget.fromSignUp) {
                                authController
                                    .verifyEmail(_email!, widget.token!)
                                    .then((value) {
                                  if (value.isSuccess) {
                                    showAnimatedDialog(
                                        context,
                                        Center(
                                          child: Container(
                                            width: 300,
                                            padding: const EdgeInsets.all(
                                                Dimensions.paddingSizeExtraLarge),
                                            decoration: BoxDecoration(
                                                color: Theme.of(context).cardColor,
                                                borderRadius: BorderRadius.circular(
                                                    Dimensions.radiusExtraLarge)),
                                            child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Image.asset(Images.checked,
                                                      width: 100, height: 100),
                                                  const SizedBox(
                                                      height: Dimensions
                                                          .paddingSizeLarge),
                                                  Text('verified'.tr,
                                                      style: robotoBold.copyWith(
                                                        fontSize: 30,
                                                        color: Theme.of(context)
                                                            .textTheme
                                                            .bodyLarge!
                                                            .color,
                                                        decoration:
                                                        TextDecoration.none,
                                                      )),
                                                ]),
                                          ),
                                        ),
                                        dismissible: false);
                                    Future.delayed(const Duration(seconds: 2), () {
                                      Get.offNamed(RouteHelper.getAccessLocationRoute(
                                          'verification'));
                                    });
                                  } else {
                                    showCustomSnackBar(value.message);
                                  }
                                });
                              } else {
                                // Get.toNamed(RouteHelper.getResetPasswordRoute(_email, authController.verificationCode, 'reset-password'));
                                authController.verifyToken(_email).then((value) {
                                  if (value.isSuccess) {
                                    Get.toNamed(RouteHelper.getResetPasswordRoute(
                                        _email,
                                        authController.verificationCode,
                                        'reset-password'));
                                  } else {
                                    showCustomSnackBar(value.message);
                                  }
                                });
                              }
                            },
                          )
                            //  : const SizedBox.shrink(),
                        ]);
                      }),
                    ),
                  ))),
        ],
      ),
    );
  }
}

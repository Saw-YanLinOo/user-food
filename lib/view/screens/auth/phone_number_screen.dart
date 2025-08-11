import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:user/controller/phone_controller.dart';
import 'package:user/theme/dark_theme.dart';
import 'package:user/theme/light_theme.dart';
import 'package:user/util/dimensions.dart';
import 'package:user/view/screens/auth/otp_screen.dart';
import 'package:user/view/widgets/custom_button.dart';
import 'package:user/view/widgets/custom_text.dart';

import '../../../util/images.dart';
import '../../base/custom_text_field.dart';

class PhoneNumberScreen extends StatelessWidget {
  const PhoneNumberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pController = Get.put(PhoneController());
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
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
          Padding(
            padding:  EdgeInsets.only(left:15.w,right: 15.w,top: kToolbarHeight+50.h),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Dimensions.kSizedBoxH30,
                CustomText(text: 'enter_phone'.tr,color: Colors.white,fontSize: 18.sp,fontWeight: FontWeight.bold,),
                Dimensions.kSizedBoxH10,
                CustomText(text: 'login_info_text'.tr,color: Colors.white,),
                Dimensions.kSizedBoxH30,
                CustomTextField(
                  controller:pController.phoneController,
                  showBorder: false,
                  prefixIcon: Icons.phone,
                    borderRadius: Dimensions.roundRadius,
                    hintText: 'phone'.tr, isValidate: false),
                Dimensions.kSizedBoxH30,
                Dimensions.kSizedBoxH30,
                Dimensions.kSizedBoxH30,
                CustomTTButton(
                  bgColor:Get.isDarkMode? dark.primaryColor:light.primaryColor ,
                    isRounded: true,
                    text: 'Continue'.tr, onTap: (){
                    Get.to(()=>OTPScreen(email:pController.phoneController.text, password: "password", fromSignUp: true, token: "token"));
                })
              ],
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:user/controller/user_controller.dart';
import 'package:user/controller/wallet_controller.dart';
import 'package:user/util/dimensions.dart';
import 'package:user/view/base/custom_text_field.dart';
import 'package:user/view/screens/wallet/wallet_transfer_otp.dart';
import 'package:user/view/widgets/custom_button.dart';

import '../../widgets/custom_text.dart';
import '../../widgets/custom_text_form_field.dart';
import '../auth/otp_screen.dart';

class WalletTransferConfirm extends StatelessWidget {
  final String amount;
  final String phone;
  const WalletTransferConfirm({super.key, required this.amount, required this.phone});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60.h,
        backgroundColor: Color(0xff6c5d5a),
        centerTitle: true,
        title: CustomText(
          text: 'my_wallet'.tr,
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14.sp,
        ),
        leading: Padding(
          padding: EdgeInsets.all(10.w),
          child: InkWell(
            onTap: () {
              Get.back();
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
      body: Container(
        padding: EdgeInsets.all(15.w),
        height: context.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff3E2723), Color(0xff212121)],
          ),
        ),
        child:GetBuilder<UserController>(
    builder: (userController) {
    return ListView(
          children: [
            Dimensions.kSizedBoxH30,
            Dimensions.kSizedBoxH10,
            Center(
              child: CustomText(text: 'w_transfer_title'.tr,color: Theme.of(context).disabledColor,fontSize: 18.sp,fontWeight: FontWeight.bold,),
            ),
            Dimensions.kSizedBoxH30,
            Center(
              child: CustomText(text: 'w_transfer_hint'.tr,color: Theme.of(context).disabledColor,),
            ),
            Dimensions.kSizedBoxH30,
            CustomText(text: 'w_transfer_pwd'.tr,color: Theme.of(context).disabledColor),
            Dimensions.kSizedBoxH5,
            CustomTextFormField(
              textColor: Theme.of(context).disabledColor,
              controller:userController.passwordController,
              hintText: '',
              isValidate: false,
              fillColor: Colors.transparent,
              radius:Dimensions.radiusDefault,
            ),
            Dimensions.kSizedBoxH5,
            Align(
              alignment: Alignment.topRight,
              child: CustomText(text: 'forgot_password'.tr,color: Theme.of(context).secondaryHeaderColor,textUnderLine: TextDecoration.underline,),
            ),
            Dimensions.kSizedBoxH30,
            Dimensions.kSizedBoxH30,
            CustomTTButton(text: 'Continue'.tr, onTap: (){
              Get.to(()=>WalletTransferOTPScreen(email:userController.userInfoModel?.phone, password: "password", fromSignUp: true, token: "token",phone: phone,amount: amount,));
            },isRounded: true,)
          ],
        );})
      ),
    );
  }
}

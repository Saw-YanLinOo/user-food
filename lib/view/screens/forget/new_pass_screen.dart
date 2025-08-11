import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user/controller/auth_controller.dart';
import 'package:user/controller/user_controller.dart';
import 'package:user/data/model/response/userinfo_model.dart';
import 'package:user/helper/route_helper.dart';
import 'package:user/util/dimensions.dart';
import 'package:user/util/images.dart';
import 'package:user/util/styles.dart';
import 'package:user/view/base/custom_app_bar.dart';
import 'package:user/view/base/custom_button.dart';
import 'package:user/view/base/custom_snackbar.dart';
import 'package:user/view/base/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/custom_text.dart';

class NewPassScreen extends StatefulWidget {
  final String? resetToken;
  final String? number;
  final bool fromPasswordChange;
  const NewPassScreen({super.key, required this.resetToken, required this.number, required this.fromPasswordChange});

  @override
  State<NewPassScreen> createState() => _NewPassScreenState();
}

class _NewPassScreenState extends State<NewPassScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final FocusNode _newPasswordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // backgroundColor: Theme.of(context).cardColor,
      appBar: AppBar(
        toolbarHeight: 60.h,
        backgroundColor: Color(0xff6c5d5a),
        centerTitle: true,
        title: CustomText(text:widget.fromPasswordChange ? 'change_password'.tr : 'reset_password'.tr,color: Colors.white,fontWeight: FontWeight.bold,fontSize: 14.sp,),
        leading: Padding(
          padding:  EdgeInsets.all(10.w),
          child: InkWell(
            onTap:(){

                Get.back();

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
      //appBar: CustomAppBar(title: widget.fromPasswordChange ? 'change_password'.tr : 'reset_password'.tr),
      body: Container(
        height: context.height,
        width: context.width > 700 ? 700 : context.width,
        padding: context.width > 700 ? const EdgeInsets.all(Dimensions.paddingSizeDefault) : EdgeInsets.all(Dimensions.paddingSizeDefault),
        //margin: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        decoration: context.width > 700 ? BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff3E2723), Color(0xff212121)],
          ),
          //color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        //  boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 300]!, blurRadius: 5, spreadRadius: 1)],
        ) : BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xff3E2723), Color(0xff212121)],
            )),
        child: ListView(children: [

          // Image.asset(Images.resetLock, height: 100),
          const SizedBox(height: Dimensions.paddingSizeExtraLarge),

          CustomText(text: 'change_pwd_title'.tr, textAlign: TextAlign.left,color: Theme.of(context).disabledColor,fontWeight: FontWeight.bold,fontSize: 17.sp,),
          const SizedBox(height: 50),

          Column(children: [

            CustomTextField(
              borderRadius: Dimensions.roundRadius,
              hintText: 'new_password'.tr,
              controller: _newPasswordController,
              focusNode: _newPasswordFocus,
              nextFocus: _confirmPasswordFocus,
              inputType: TextInputType.visiblePassword,
              prefixIcon: (Icons.lock),

              isPassword: true,
              divider: false,
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            CustomTextField(
              borderRadius: Dimensions.roundRadius,
              hintText: 'confirm_password'.tr,
              controller: _confirmPasswordController,
              focusNode: _confirmPasswordFocus,
              inputAction: TextInputAction.done,
              inputType: TextInputType.visiblePassword,
              prefixIcon: (Icons.lock),
              isPassword: true,
              onSubmit: (text) => GetPlatform.isWeb ? _resetPassword() : null,
            ),

          ]),
          const SizedBox(height: 30),

          GetBuilder<UserController>(builder: (userController) {
            return GetBuilder<AuthController>(builder: (authBuilder) {
              return CustomButton(

                radius: Dimensions.roundRadius,
                buttonText: 'submit'.tr,
                isLoading: (authBuilder.isLoading && userController.isLoading),
                onPressed: () => _resetPassword(),
              );
            });
          }),

        ]),
      ),
    );
  }

  void _resetPassword() {
    String password = _newPasswordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();
    if (password.isEmpty) {
      showCustomSnackBar('enter_password'.tr);
    }else if (password.length < 6) {
      showCustomSnackBar('password_should_be'.tr);
    }else if(password != confirmPassword) {
      showCustomSnackBar('confirm_password_does_not_matched'.tr);
    }else {
      if(widget.fromPasswordChange) {
        UserInfoModel user = Get.find<UserController>().userInfoModel!;
        user.password = password;
        Get.find<UserController>().changePassword(user).then((response) {
          if(response.isSuccess) {
            showCustomSnackBar('password_updated_successfully'.tr, isError: false);
            Get.back();
          

          }else {
            showCustomSnackBar(response.message);
          }
        });
      }else {
        Get.find<AuthController>().resetPassword(widget.resetToken, '+${widget.number!.trim()}', password, confirmPassword).then((value) {
          if (value.isSuccess) {
            Get.find<AuthController>().login('+${widget.number!.trim()}', password).then((value) async {
              Get.offAllNamed(RouteHelper.getAccessLocationRoute('reset-password'));
            });
          } else {
            showCustomSnackBar(value.message);
          }
        });
      }
    }
  }
}

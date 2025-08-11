import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:user/controller/wallet_controller.dart';
import 'package:user/util/dimensions.dart';
import 'package:user/util/images.dart';
import 'package:user/view/widgets/custom_button.dart';

import '../../widgets/custom_text.dart';
import '../../widgets/custom_text_form_field.dart';

class WalletTopUpConfirm extends StatelessWidget {
  final String amount;
  const WalletTopUpConfirm({super.key, required this.amount});

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
      body:GetBuilder<WalletController>(
        builder: (walletController) {
      return Container(
        padding: EdgeInsets.all(15.w),
        height: context.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff3E2723), Color(0xff212121)],
          ),
        ),
        child: ListView(
          children: [
            Row(
              children: [
                CustomText(text: 'top_up_amt'.tr,color: Theme.of(context).disabledColor,fontWeight: FontWeight.bold,fontSize: 15.sp,),
                CustomText(text: " $amount ${'currency'.tr}",color: Theme.of(context).disabledColor,fontWeight: FontWeight.bold,fontSize: 15.sp,),
              ],
            ),
            Divider(color: Theme.of(context).disabledColor.withOpacity(0.5),),
            Dimensions.kSizedBoxH30,
            CustomText(text: 'choose_pay_type'.tr,color: Theme.of(context).disabledColor,fontWeight: FontWeight.bold,),
            Dimensions.kSizedBoxH15,
            Obx(()=>
             Row(
                children: [
                  InkWell(
                    onTap: (){
                      walletController.isWave.value=false;
                      walletController.isKPay.value=true;
                    },
                    child: Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.roundRadius),
                        border: Border.all(color:walletController.isKPay.value?Theme.of(context).primaryColor: Theme.of(context).disabledColor)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(3.r),
                              child: Image.asset(Images.kpay,width: 20.w,)),
                          Dimensions.kSizedBoxW10,
                          CustomText(text: 'k_pay'.tr,color: Theme.of(context).disabledColor,fontWeight: FontWeight.bold,),
                        ],
                      ),
                    ),
                  ),
                  Dimensions.kSizedBoxW15,
                  InkWell(
                    onTap: (){
                      walletController.isWave.value=true;
                      walletController.isKPay.value=false;
                    },
                    child: Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.roundRadius),
                          border: Border.all(color:walletController.isWave.value?Theme.of(context).primaryColor: Theme.of(context).disabledColor)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(3.r),
                              child: Image.asset(Images.wave,width: 20.w,)),
                          Dimensions.kSizedBoxW10,
                          CustomText(text: 'w_pay'.tr,color: Theme.of(context).disabledColor,fontWeight: FontWeight.bold,),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Dimensions.kSizedBoxH15,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
               Row(
                 children: [
                   CustomText(text: 'to_phone'.tr,color: Theme.of(context).disabledColor,fontSize: 11.sp,),
                   Dimensions.kSizedBoxW5,
                   CustomText(text: '09987654321 (MOMO)',color: Theme.of(context).disabledColor,),
                 ],
               ),
                Dimensions.kSizedBoxW5,

                Expanded(
                  child: GestureDetector(
                    onTap: (){},
                    child: Container(
                  
                        padding: EdgeInsets.all(5.w),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(Dimensions.roundRadius),
                            //border: Border.all(color:walletController.isKPay.value?Theme.of(context).primaryColor: Theme.of(context).disabledColor)
                  
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.copy_rounded,size: 15.w,),
                          Dimensions.kSizedBoxW5,
                          CustomText(text: 'copy'.tr,fontSize: 10.sp,color: Theme.of(context).disabledColor,),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            Dimensions.kSizedBoxH20,
            InkWell(
              onTap: () {
                walletController.pickImageFrontID();
              },
              child: Padding(
                
               padding: EdgeInsets.symmetric(horizontal:80.w),
                child: DottedBorder(
                  strokeWidth: 1, // Thickness of the border
                  color:
                  Theme.of(context).disabledColor, // Color of the dots/dashes
                  borderType:
                  BorderType
                      .RRect, // Shape of the border (e.g., rectangle with rounded corners)
                  radius: Radius.circular(
                    15.r,
                  ), // Radius for rounded corners if borderType is RRect
                  dashPattern: [
                    2,
                    3,
                  ], // Pattern of dashes and spaces (e.g., 5 pixels dash, 5 pixels space)
                  child: Container(
                    height: 110.h,
                    //width:150.w,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Center(
                      child: walletController.pickedIDFrontFile != null
                          ? Obx(
                              () =>  Image.file(
                            File(walletController.imageFrontPath.value),
                            // width: 100,
                            // height: 100,
                            fit: BoxFit.cover,
                          ))
                          :  Icon(
                        Icons.photo,
                        size: 80.w,
                        color: Colors.grey.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Dimensions.kSizedBoxH10,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(text: 'add_screenshot'.tr,color: Theme.of(context).disabledColor,),
                Dimensions.kSizedBoxW5,
                CustomText(text: '*',color: Colors.red,),
              ],
            ),
            Dimensions.kSizedBoxH30,
            CustomTextFormField(
                keyBoardType: TextInputType.number,
                onChange: (a){
                  walletController.accountController.text=a;
                  if(a.isNotEmpty){
                    walletController.isTextEmpty.value=false;
                  }
                  else{
                    walletController.isTextEmpty.value=true;
                  }

                },
                textColor: Theme.of(context).disabledColor,
                controller: walletController.accountController,
                fillColor: Colors.transparent,
                radius: Dimensions.radiusDefault,
                hintText: 'acc'.tr, isValidate: false),
            Dimensions.kSizedBoxH15,
            CustomTextFormField(
                keyBoardType: TextInputType.number,
                onChange: (a){
                  walletController.transController.text=a;
                  if(a.isNotEmpty){
                    walletController.isTextEmpty.value=false;
                  }
                  else{
                    walletController.isTextEmpty.value=true;
                  }

                },
                textColor: Theme.of(context).disabledColor,
                controller: walletController.transController,
                fillColor: Colors.transparent,
                radius: Dimensions.radiusDefault,
                hintText: 'trans_number'.tr, isValidate: false),
            Dimensions.kSizedBoxH3,
            InkWell(
              onTap:(){
                showDialog(
                  context: context,
                  builder: (context) => CustomConfirmDialog(
                    onConfirm: () {

                      Navigator.pop(context);
                    },
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Theme.of(context).disabledColor)
                    ),
                      child: Icon(Icons.question_mark_sharp,size: 15.w,)),
                  Dimensions.kSizedBoxW2,
                  CustomText(text: 'ID',color: Theme.of(context).disabledColor,fontWeight: FontWeight.bold,)
                ],
              ),
            ),
            Dimensions.kSizedBoxH30,
            Dimensions.kSizedBoxH30,
           // Dimensions.kSizedBoxH30,
            CustomTTButton(
                isRounded: true,
                text: 'Confirm'.tr, onTap: (){
              showDialog(
                context: context,
                builder: (context) => CustomConfirmPDialog(
                  onConfirm: () {

                    Navigator.pop(context);
                  },
                ),
              );
            })
          ],
        ),
      );})
    );
  }
}
// Custom dialog
class CustomConfirmPDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  const CustomConfirmPDialog({Key? key, required this.onConfirm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 56, left: 24, right: 24, bottom: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 24),
                CustomText(text: 'w_topup_title'.tr,fontWeight: FontWeight.bold,fontSize: 16.sp,),
                Dimensions.kSizedBoxH10,
                CustomText(text: 'w_topup_body'.tr,maxLines: 8,textAlign: TextAlign.center,),
                const SizedBox(height: 24),
                SizedBox(
                  width: context.width,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFE53935), width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child:  Text('close1'.tr
                        , style: TextStyle(color: Color(0xFFE53935), fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: -90.h,
            child: Center(
              child: Image.asset(
                'assets/image/processing.png',
                width: 120.w,
                height: 170.h,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class CustomConfirmDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  const CustomConfirmDialog({Key? key, required this.onConfirm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Padding(
            padding:  EdgeInsets.only(top: 30.h, left: 20.w, right: 24.w, bottom: 24.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                CustomText(text: 'id_info'.tr,fontWeight: FontWeight.bold,fontSize: 15.sp,),
                Dimensions.kSizedBoxH20,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(3.r),
                            child: Image.asset(Images.kpay,width: 20.w,)),
                        Dimensions.kSizedBoxW10,
                        CustomText(text: 'k_pay'.tr,color: Theme.of(context).disabledColor,),
                      ],
                    ),
                    Image.asset(
                      'assets/image/k_i.png',
                      width: 150.w,

                      fit: BoxFit.contain,
                    ),
                  ],
                ),
                Dimensions.kSizedBoxH10,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(3.r),
                            child: Image.asset(Images.wave,width: 20.w,)),
                        Dimensions.kSizedBoxW10,
                        CustomText(text: 'w_pay'.tr,color: Theme.of(context).disabledColor,),
                      ],
                    ),
                    Image.asset(
                      'assets/image/wave_i.png',
                      width: 130.w,

                      fit: BoxFit.contain,
                    ),
                  ],
                ),
                // SizedBox(
                //   width: context.width,
                //   child: OutlinedButton(
                //     onPressed: () => Navigator.pop(context),
                //     style: OutlinedButton.styleFrom(
                //       side: const BorderSide(color: Color(0xFFE53935), width: 1.5),
                //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                //       padding: const EdgeInsets.symmetric(vertical: 14),
                //     ),
                //     child:  Text('close1'.tr
                //         , style: TextStyle(color: Color(0xFFE53935), fontWeight: FontWeight.bold)),
                //   ),
                // ),
              ],
            ),
          ),
          // Positioned(
          //   top: -90.h,
          //   child: Center(
          //     child: Image.asset(
          //       'assets/image/processing.png',
          //       width: 120.w,
          //       height: 170.h,
          //       fit: BoxFit.contain,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

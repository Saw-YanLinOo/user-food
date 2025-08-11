import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:user/util/dimensions.dart';

import '../../../helper/route_helper.dart';
import '../../widgets/custom_text.dart';

class WalletTransferSuccess extends StatelessWidget {
  final String phone;
  final String amount;
  const WalletTransferSuccess({super.key, required this.phone, required this.amount});

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
              Get.offAllNamed(RouteHelper.getInitialRoute());
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
        width: context.width,
        decoration: BoxDecoration(

          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff3E2723), Color(0xff212121)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.check_circle,color: Colors.green,size: 100.w,),
            Dimensions.kSizedBoxH30,
            CustomText(text: 'transfer_success'.tr,color: Theme.of(context).disabledColor,fontWeight: FontWeight.bold,),
            Dimensions.kSizedBoxH30,
            Dimensions.kSizedBoxH30,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align
                  (
                  alignment: Alignment.topLeft,
                    child: CustomText(text: 'details'.tr,color: Theme.of(context).cardColor,textAlign: TextAlign.left,)),
                
                Container(
                  padding: EdgeInsets.all(15.w),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(15.r)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(text: "$amount ${'currency'.tr} ${'transferred'.tr}",color: Theme.of(context).disabledColor,fontWeight: FontWeight.bold,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(text: 'to'.tr,color: Theme.of(context).disabledColor,),
                          CustomText(text: phone,color: Theme.of(context).disabledColor,),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(text: 'date'.tr,color: Theme.of(context).disabledColor,),
                          CustomText(text: DateTime.now().toIso8601String(),color: Theme.of(context).disabledColor,),
                        ],
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

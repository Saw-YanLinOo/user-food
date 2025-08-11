import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../helper/route_helper.dart';
import '../../../util/dimensions.dart';
import '../../widgets/custom_text.dart';

class DeliveryManRegSuccess extends StatelessWidget {
  final String phone;
  final String fromPage;
  const DeliveryManRegSuccess({super.key, required this.phone, required this.fromPage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60.h,
        backgroundColor: Color(0xff6c5d5a),
        centerTitle: true,
        title: CustomText(
          text:fromPage=="deli"? 'delivery_man_registration'.tr:"restaurant_registration".tr,
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14.sp,
        ),
        leading: Padding(
          padding: EdgeInsets.all(10.w),
          child: InkWell(
            onTap: () {
              Get.offAllNamed(RouteHelper.getInitialRoute());
              //Get.back();
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle,color: Colors.green,size: 100.w,),
            Dimensions.kSizedBoxH30,
            Dimensions.kSizedBoxH10,
            CustomText(text: 'deli_man_reg_success_title'.tr,color: Theme.of(context).disabledColor,fontWeight: FontWeight.bold,),
            Dimensions.kSizedBoxH30,
            Dimensions.kSizedBoxH10,
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(text: 'deli_man_reg_success_body'.tr,color: Theme.of(context).disabledColor,maxLines: 3,textAlign: TextAlign.center,),
                CustomText(text: "$phone ${'deli_man_reg_success_body1'.tr}",color: Theme.of(context).disabledColor,maxLines: 3,textAlign: TextAlign.center,),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

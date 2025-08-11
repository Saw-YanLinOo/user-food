import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:user/util/dimensions.dart';

import 'custom_text.dart';

class CustomLoading extends StatelessWidget {
  const CustomLoading({super.key, this.color, this.colorLoading});
final Color? color;
final Color? colorLoading;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [


        CustomText(text: 'Please Wait',color: color??Colors.black,fontSize: 12.sp,fontWeight: FontWeight.bold
          ,),
        Dimensions.kSizedBoxW10,
        LoadingAnimationWidget.waveDots(
          color:colorLoading?? Colors.white,
          size: 30.sp,
        ),

      ],
    );
  }
}

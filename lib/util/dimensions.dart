import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class Dimensions {
  static double fontSizeExtraSmall = Get.context!.width >= 1300 ? 14 : 10;
  static double fontSizeSmall = Get.context!.width >= 1300 ? 16 : 12;
  static double fontSizeDefault = Get.context!.width >= 1300 ? 18 : 14;
  static double fontSizeLarge = Get.context!.width >= 1300 ? 20 : 16;
  static double fontSizeExtraLarge = Get.context!.width >= 1300 ? 22 : 18;
  static double fontSizeOverLarge = Get.context!.width >= 1300 ? 28 : 24;

  static const double paddingSizeExtraSmall = 5.0;
  static const double paddingSizeSmall = 10.0;
  static const double paddingSizeDefault = 15.0;
  static const double paddingSizeLarge = 20.0;
  static const double paddingSizeExtraLarge = 25.0;
  static const double paddingSizeOverLarge = 30.0;

  static const double radiusSmall = 5.0;
  static const double radiusDefault = 10.0;
  static const double radiusLarge = 15.0;
  static const double radiusExtraLarge = 20.0;
  static const double roundRadius = 50.0;

  static const double webMaxWidth = 1170;
  static const int messageInputLength = 250;

  static SizedBox kSizedBoxH3 = SizedBox(height: 3.h);
  static SizedBox kSizedBoxH5 = SizedBox(height: 5.h);
  static SizedBox kSizedBoxH10 = SizedBox(height: 10.h);
  static SizedBox kSizedBoxH15 = SizedBox(height: 15.h);
  static SizedBox kSizedBoxH20 = SizedBox(height: 20.h);
  static SizedBox kSizedBoxH25 = SizedBox(height: 25.h);
  static SizedBox kSizedBoxH30 = SizedBox(height: 30.h);

  static SizedBox kSizedBoxW2 = SizedBox(width: 2.w);
  static SizedBox kSizedBoxW5 = SizedBox(width: 5.w);
  static SizedBox kSizedBoxW10 = SizedBox(width: 10.w);
  static SizedBox kSizedBoxW15 = SizedBox(width: 15.w);
  static SizedBox kSizedBoxW20 = SizedBox(width: 20.w);
  static SizedBox kSizedBoxW25 = SizedBox(width: 25.w);
  static SizedBox kSizedBoxW30 = SizedBox(width: 30.w);


  double kPadding5 = 5.w;
  double kPadding10 = 10.w;
  double kPadding15 = 15.w;
  double kPadding20 = 20.w;
  double kPadding25 = 25.w;
  double kPadding30 = 30.w;
}

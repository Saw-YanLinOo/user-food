import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user/controller/localization_controller.dart';
import 'package:get/get.dart';
import '../../../helper/route_helper.dart';
import '../../../util/images.dart';
import '../../widgets/custom_text.dart';

class ChooseOptionScreen extends StatelessWidget {
  const ChooseOptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizationController = Get.put(
      LocalizationController(
        sharedPreferences: Get.find(),
        apiClient: Get.find(),
      ),
    );
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(Images.menubgImg, fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.5),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding:  EdgeInsets.only(left:20.w,right: 20.w,top: kToolbarHeight+50.h),
            child: Column(
              children: [
                Image.asset(Images.splashLogo, width: 100.w),
                Expanded(
                  child: GridView(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.9,
                      crossAxisSpacing: 7.w,
                      mainAxisSpacing: 7.h
                    ),
                    children: [
                      MenuWidget(
                        text: 'show_all_food'.tr,
                        text1: 'show_all_food1'.tr,
                        imageUrl: Images.menu1Img,
                        onTap: (){
                          Get.offNamed(RouteHelper.getInitialRoute(fromSplash: false));
                        },
                      ),
                      MenuWidget(
                        text: 'show_all_rest'.tr,
                        text1: 'show_all_rest1'.tr,
                        imageUrl: Images.menu2Img,
                        onTap: (){},
                      ),
                      MenuWidget(
                        text: 'show_all_book'.tr,
                        text1: 'show_all_book1'.tr,
                        imageUrl: Images.menu3Img,
                        onTap: (){},
                      ),
                      MenuWidget(
                        text: 'show_all_qr'.tr,
                        text1: 'show_all_qr1'.tr,
                        imageUrl: Images.menu4Img,
                        onTap: (){},
                      ),
                    ],
                  ),
                ),
              ],
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
                    // localizationController.setSelectIndex();
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
}

class MenuWidget extends StatelessWidget {
  final String imageUrl;
  final String text;
  final String text1;
  final GestureTapCallback onTap;
  const MenuWidget({
    super.key, required this.imageUrl, required this.text, required this.text1, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        // padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            color: Colors.grey.withOpacity(0.8)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
                padding: EdgeInsets.all(5.w),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white70
                ),
                child: Image.asset(imageUrl,width: 40.w,)),
            Column(
              children: [
                CustomText(text: text,color: Colors.white54,),
                CustomText(text: text1,color: Colors.white54,),
              ],
            ),
            Container(
                padding: EdgeInsets.all(5.w),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white30
                ),
                child: Icon(Icons.arrow_forward_ios,color: Colors.white70,size: 10.w,))
          ],
        ),
      ),
    );
  }
}

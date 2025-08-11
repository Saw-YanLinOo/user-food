// import 'package:user/controller/onboarding_controller.dart';
// import 'package:user/controller/splash_controller.dart';
// import 'package:user/helper/responsive_helper.dart';
// import 'package:user/helper/route_helper.dart';
// import 'package:user/util/dimensions.dart';
// import 'package:user/util/styles.dart';
// import 'package:user/view/base/custom_button.dart';
// import 'package:user/view/base/web_menu_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class OnBoardingScreen extends StatelessWidget {
//   final PageController _pageController = PageController();
//
//   OnBoardingScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     Get.find<OnBoardingController>().getOnBoardingList();
//
//     return Scaffold(
//       appBar: ResponsiveHelper.isDesktop(context) ? const WebMenuBar() : null,
//       body: GetBuilder<OnBoardingController>(
//         builder: (onBoardingController) => onBoardingController
//                 .onBoardingList.isNotEmpty
//             ? SafeArea(
//                 child: Center(
//                     child: SizedBox(
//                         width: Dimensions.webMaxWidth,
//                         child: Column(children: [
//                           Expanded(
//                               child: PageView.builder(
//                             itemCount:
//                                 onBoardingController.onBoardingList.length,
//                             controller: _pageController,
//                             physics: const BouncingScrollPhysics(),
//                             itemBuilder: (context, index) {
//                               return Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Padding(
//                                       padding:
//                                           EdgeInsets.all(context.height * 0.05),
//                                       child: Image.asset(
//                                           onBoardingController
//                                               .onBoardingList[index].imageUrl,
//                                           height: context.height * 0.4),
//                                     ),
//                                     Text(
//                                       onBoardingController
//                                           .onBoardingList[index].title,
//                                       style: robotoMedium.copyWith(
//                                           fontSize: context.height * 0.022,
//                                           color:
//                                               Theme.of(context).primaryColor),
//                                       textAlign: TextAlign.center,
//                                     ),
//                                     SizedBox(height: context.height * 0.025),
//                                     Padding(
//                                       padding: const EdgeInsets.symmetric(
//                                           horizontal:
//                                               Dimensions.paddingSizeLarge),
//                                       child: Text(
//                                         onBoardingController
//                                             .onBoardingList[index].description,
//                                         style: robotoRegular.copyWith(
//                                             fontSize: context.height * 0.015,
//                                             color: Theme.of(context)
//                                                 .disabledColor),
//                                         textAlign: TextAlign.center,
//                                       ),
//                                     ),
//                                   ]);
//                             },
//                             onPageChanged: (index) {
//                               onBoardingController.changeSelectIndex(index);
//                             },
//                           )),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children:
//                                 _pageIndicators(onBoardingController, context),
//                           ),
//                           SizedBox(height: context.height * 0.05),
//                           Padding(
//                             padding: const EdgeInsets.all(
//                                 Dimensions.paddingSizeSmall),
//                             child: Row(children: [
//                               onBoardingController.selectedIndex == 2
//                                   ? const SizedBox()
//                                   : Expanded(
//                                       child: CustomButton(
//                                         transparent: true,
//                                         onPressed: () {
//                                           Get.find<SplashController>()
//                                               .disableIntro();
//                                           Get.offNamed(
//                                               RouteHelper.getSignInRoute(
//                                                   RouteHelper.onBoarding));
//                                         },
//                                         buttonText: 'skip'.tr,
//                                       ),
//                                     ),
//                               Expanded(
//                                 child: CustomButton(
//                                   radius:
//                                       onBoardingController.selectedIndex != 2
//                                           ? 5
//                                           : 10,
//                                   buttonText:
//                                       onBoardingController.selectedIndex != 2
//                                           ? 'next'.tr
//                                           : 'get_started'.tr,
//                                   onPressed: () {
//                                     if (onBoardingController.selectedIndex !=
//                                         2) {
//                                       _pageController.nextPage(
//                                           duration: const Duration(seconds: 1),
//                                           curve: Curves.ease);
//                                     } else {
//                                       Get.find<SplashController>()
//                                           .disableIntro();
//                                       Get.offNamed(RouteHelper.getSignInRoute(
//                                           RouteHelper.onBoarding));
//                                     }
//                                   },
//                                 ),
//                               ),
//                             ]),
//                           ),
//                         ]))),
//               )
//             : const SizedBox(),
//       ),
//     );
//   }
//
//   List<Widget> _pageIndicators(
//       OnBoardingController onBoardingController, BuildContext context) {
//     List<Container> indicators = [];
//
//     for (int i = 0; i < onBoardingController.onBoardingList.length; i++) {
//       indicators.add(
//         Container(
//           width: 7,
//           height: 7,
//           margin: const EdgeInsets.only(right: 10),
//           decoration: BoxDecoration(
//             color: i == onBoardingController.selectedIndex
//                 ? Theme.of(context).primaryColor
//                 : Theme.of(context).secondaryHeaderColor.withOpacity(0.40),
//             borderRadius: i == onBoardingController.selectedIndex
//                 ? BorderRadius.circular(50)
//                 : BorderRadius.circular(25),
//           ),
//         ),
//       );
//     }
//     return indicators;
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:user/theme/dark_theme.dart';

import '../../../controller/splash_controller.dart';
import '../../../helper/route_helper.dart';
import '../../widgets/custom_text.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnBoardData> _pages = [
    _OnBoardData(
      image: 'assets/image/onBoard1.jpg',
      bgColor: Color(0xFFFAFAFA),
      buttonColor: Color(0xFFD60000),
      title: 'အကြိုက်ဆုံးအစားအစာများရယူပါ',
      desc: 'အစားအသောက်များမှာယူရန်သင်၏တည်နေရာကိုရွေးချယ်ပါ။',
    ),
    _OnBoardData(
      image: 'assets/image/onBoard2.jpg',
      bgColor: Color(0xFFD60000),
      buttonColor: Colors.yellow,
      title: 'မြန်ဆန်သောပို့ဆောင်မှု',
      desc: 'မြန်ဆန်စွာပို့ဆောင်မှုအတွက်အမြန်ဆုံးအော်ဒါတင်နိုင်ပြီးသင့်အိမ်အထိအချိန်မီပို့ဆောင်ပေးမည်ဖြစ်ပါသည်။',
    ),
    _OnBoardData(
      image: 'assets/image/onBoard3.png', // Placeholder for e-wallet image
      bgColor: Color(0xFFD60000),
      buttonColor: Colors.yellow,
      title: 'လွယ်ကူသောငွေပေးချေမှု',
      desc: 'အိမ်တွင်းအော်ဒါများအတွက်လွယ်ကူသောငွေပေးချေမှုနည်းလမ်းများအားဖြင့်အော်ဒါအတင်အဆင်ပြေစေပါသည်။',
    ),
  ];

  void _onNext() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      Get.find<SplashController>()
                                              .disableIntro();
                                          Get.offNamed(
                                              RouteHelper.getSignInRoute(
                                                  RouteHelper.onBoarding));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pages[_currentPage].bgColor,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final data = _pages[index];
              final mediaQuery = MediaQuery.of(context);
              return Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    data.image,
                    fit: BoxFit.cover,
                  ),
                  Container(
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
                  Padding(
                    padding: EdgeInsets.only(
                      top: mediaQuery.padding.top,
                      bottom: mediaQuery.padding.bottom,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        //SizedBox(height: 24.h),
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: 20.w, top: 10.h),
                            child: GestureDetector(
                              onTap:() async{
                                Get.find<SplashController>()
                                              .disableIntro();
                                          Get.offNamed(
                                              RouteHelper.getSignInRoute(
                                                  RouteHelper.onBoarding));
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.white, width: 1),
                                ),
                                child: CustomText(
                                  text: 'ကျော်မည်',
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: CustomText(
                            text: data.title,
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: CustomText(
                            text: data.desc,
                            color: Colors.white,
                            fontSize: 13.sp,
                            maxLines: 3,
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(height: 32.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(_pages.length, (i) => AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            margin: EdgeInsets.symmetric(horizontal: 4.w),
                            width: _currentPage == i ? 24.w : 8.w,
                            height: 8.h,
                            decoration: BoxDecoration(
                              color: _currentPage == i ? dark.secondaryHeaderColor : Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          )),
                        ),
                        SizedBox(height: 32.h),

                      ],
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: MediaQuery.of(context).size.height * 0.5 - 10.w,
                    child: GestureDetector(
                      onTap: _onNext,
                      child: ClipPath(
                        clipper: _TriangleWithRoundedLeftTipClipper(),
                        child: Container(
                          width: 110.w,
                          height: 170.w,
                          color: Colors.white.withOpacity(0.50),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 25.0),
                              child: Container(

                                width: 60.w,
                                height: 60.w,
                                decoration: BoxDecoration(
                                  color: Color(0xFFD60000),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.70),
                                      blurRadius: 18,
                                      offset: Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.double_arrow_rounded,
                                    color: Colors.white,
                                    size: 25.w,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _OnBoardData {
  final String image;
  final Color bgColor;
  final Color buttonColor;
  final String title;
  final String desc;
  _OnBoardData({required this.image, required this.bgColor, required this.buttonColor, required this.title, required this.desc});
}

// Custom clipper for a left-pointing triangle with a rounded left tip
class _TriangleWithRoundedLeftTipClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double radius = 40.0;
    double tipY = size.height / 2;
    Path path = Path();
    // Start at top right
    path.moveTo(size.width, 0);
    // Line to bottom right
    path.lineTo(size.width, size.height);
    // Line to just above the left tip
    path.lineTo(radius * 1.3, tipY + radius);
    // Curve around the left tip
    path.quadraticBezierTo(
        0, tipY, // control point at the left tip
        radius * 1.2, tipY - radius // end point just below the left tip
    );
    // Line back to top right
    path.close();
    return path;
  }
  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/util/images.dart';
import 'package:user/view/screens/splash/splash_screen.dart';
import '../../../data/model/body/deep_link_body.dart';
import '../../../data/model/body/notification_body.dart';

class SplashScreen1 extends StatefulWidget {
  final NotificationBody? notificationBody;
  final DeepLinkBody? linkBody;
  const SplashScreen1({super.key, this.notificationBody, this.linkBody});

  @override
  State<SplashScreen1> createState() => _SplashScreen1State();
}

class _SplashScreen1State extends State<SplashScreen1> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () {
      Get.offAll(() =>  SplashScreen(notificationBody:widget.notificationBody , linkBody: widget.linkBody,));
    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Center(
            child:  Container(
              width: MediaQuery.of(context).size.width*.7,
              height: 100.h,
              decoration: BoxDecoration(

                  image: DecorationImage(image: AssetImage(Images.splashLogo))
              ),

            ),
          )
      ),
    );
  }
}

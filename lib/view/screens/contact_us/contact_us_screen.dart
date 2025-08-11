import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:user/util/colors.dart';
import 'package:user/util/dimensions.dart';
import 'package:user/util/images.dart';
import 'package:user/view/widgets/custom_text.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF6B6464),
      appBar: AppBar(
        backgroundColor: const Color(0xff6c5d5a),
        elevation: 0,
        toolbarHeight: 60.h,
        leading: Padding(
          padding: EdgeInsets.all(10.w),
          child: InkWell(
            onTap: () {
              Navigator.of(context).maybePop();
            },
            child: Container(
              padding: EdgeInsets.only(left: 6.w),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white30,
              ),
              child: Center(
                child: Icon(Icons.arrow_back_ios, color: Colors.white, size: 15.w),
              ),
            ),
          ),
        ),
        centerTitle: true,
        title:  CustomText(
          text: 'contact_us'.tr,

            color: Theme.of(context).disabledColor,
            fontWeight: FontWeight.bold,
            fontSize: 14.sp,

        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff3E2723),Color(0xff212121)])


        ),
        child: Padding(
          padding:  EdgeInsets.all(15.w),
          child: ListView(

            children: [
             Row(
               children: [
                 // Placeholder for mascot icon (replace with your asset if needed)
                 Column(
                   children: [
                     Dimensions.kSizedBoxH30,
                     Image.asset(Images.contactUs, width: 60.w,),
                   ],
                 ),

                 // Message box

                 Expanded(
                   child: Column(
                     children: [
                       Container(

                         padding:  EdgeInsets.symmetric(horizontal:12.w,vertical: 5.h),
                         decoration: BoxDecoration(
                           border: GradientBoxBorder(gradient: LinearGradient(colors: [Colors.red, Colors.yellow])),
                           borderRadius: BorderRadius.only(topLeft: Radius.circular(50.r),topRight: Radius.circular(50.r),bottomRight: Radius.circular(50.r)),
                         ),
                         child:  CustomText(
                           maxLines: 3,

                           color: Theme.of(context).primaryColorLight,
                           text: 'momo_title'.tr,
                          fontFamily: 'Roboto',
                         ),
                       ),
                       Dimensions.kSizedBoxH30,
                     ],
                   ),
                 ),
               ],
             ),

               SizedBox(height: 24.h),
              // Feedback text
               CustomText(
                text: 'momo_body'.tr
                 ,
                textAlign: TextAlign.center,
               color: Theme.of(context).disabledColor,
                 maxLines: 9,
              ),
              const SizedBox(height: 32),
              // Call and Email buttons
              Row(
                children: [
                  Expanded(
                    child: _ContactCardButton(
                      icon: Icons.call,
                      iconColor: Color(0xFF7FFF00),
                      label: 'call_me_now'.tr,
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _ContactCardButton(
                      icon: Icons.email,
                      iconColor: Color(0xFF3AA6F2),
                      label: 'email_me'.tr,
                      onTap: () {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Social Media section
               Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'contact_us_in_social_media'.tr,
                  style: TextStyle(
                    color: Color(0xFFD3C7C7),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Social buttons
              Column(
                children: [
                  _SocialButton(
                    icon: Icons.facebook,
                    iconColor: Color(0xFF1877F3),
                    label: 'facebook'.tr,
                    onTap: () {},
                  ),
                  const SizedBox(height: 12),
                  _SocialButton(
                    icon: Icons.send,
                    iconColor: Color(0xFF29A9EA),
                    label: 'telegram'.tr,
                    onTap: () {},
                  ),
                  const SizedBox(height: 12),
                  _SocialButton(
                    icon: Icons.phone_in_talk,
                    iconColor: Color(0xFF7B519D),
                    label: 'viber'.tr, // Change to 'Viber' if you add the icon
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactCardButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final VoidCallback onTap;

  const _ContactCardButton({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 110,
        decoration: BoxDecoration(
          color: listTileColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 38),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFFD3C7C7),
                fontSize: 16,
                fontFamily: 'Roboto',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final VoidCallback onTap;

  const _SocialButton({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding:  EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: listTileColor,
          borderRadius: BorderRadius.circular(25.r),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Roboto'),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }
}

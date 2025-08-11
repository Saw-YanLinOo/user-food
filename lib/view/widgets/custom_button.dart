import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user/theme/dark_theme.dart';

import 'custom_text.dart';

class CustomTTButton extends StatelessWidget {
  final String text;
  final double? size;
  final Color? txtColor;
  final Color? bgColor;
  final Color? outlineColor;
  final Color? shadowColor;
  final bool? isRounded;
  final double? width;
  final double? height;
  final IconData? icon;
  final String? image;
  final void Function()? onTap;

  const CustomTTButton(
      {super.key,
      required this.text,
      this.size,
      this.txtColor,
      this.bgColor,
      this.outlineColor,
      this.shadowColor,
      this.isRounded,
      this.width,
      this.height,
      this.icon,
      this.image,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 40.h,
        decoration: BoxDecoration(
          border: Border.all(color: outlineColor ?? dark.primaryColor, width: 2),
          borderRadius: isRounded == true
              ? BorderRadius.circular(100)
              : BorderRadius.circular(10),
          color: bgColor ?? dark.primaryColor,
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: icon != null,
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(icon, color: Colors.white),
              ),
            ),
            Visibility(
              visible: image != null,
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Image.asset(
                  image ?? '',
                  width: 20.h,
                  height: 20.h,
                ),
              ),
            ),
            CustomText(
              text: text,
              color: txtColor ?? Colors.white,
              fontSize: size ?? 14.sp,
              fontWeight: FontWeight.normal,
            ),
          ],
        ),
      ),
    );
  }
}

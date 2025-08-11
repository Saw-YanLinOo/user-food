import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final Widget? prefixIcon;
  final IconButton? suffixIcon;
  final String? requiredText;
  final bool? obscureText;
  final void Function(String)? onChange;
  final void Function()? onPress;
  final int? maxlines;
  final Color? textColor;
  final bool? readonly;
  final bool? isValidate;
  final TextInputType? keyBoardType;
  final String? initialValue;
  final Color? borderColor;
  final FocusNode? focusNode;
  final ValueChanged<String>? onFieldSubmitted;
  final int? maxLength;
  final bool? isFill;
  final Color? fillColor;
  final double? radius;

  const CustomTextFormField(
      {super.key,
      this.controller,
      required this.hintText,
      this.prefixIcon,
      this.suffixIcon,
      this.requiredText,
      this.obscureText,
      this.onChange,
      this.onPress,
      this.maxlines,
      this.textColor,
      this.readonly,
      required this.isValidate,
      this.keyBoardType,
      this.initialValue,
      this.borderColor,
      this.focusNode,
      this.onFieldSubmitted, this.maxLength, this.isFill, this.fillColor, this.radius});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      maxLength: maxLength,
      cursorColor: Colors.white,
      initialValue: initialValue,
      onTap: onPress,
      maxLines: maxlines ?? 1,
      readOnly: readonly ?? false,
      autofocus: false,
      controller: controller,
      obscureText: obscureText ?? false,
      onChanged: onChange,
      keyboardType: keyBoardType ?? TextInputType.text,
      style: TextStyle(color: textColor ?? Colors.black, fontSize: 12),
      decoration: InputDecoration(
          filled: isFill?? true,
          fillColor:fillColor?? Colors.white,
          contentPadding:
               EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
          errorStyle: TextStyle(color: Colors.red),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor ?? Colors.grey.withOpacity(0.2), width: 1.5.w),
              borderRadius: BorderRadius.all(Radius.circular(radius??50.r))),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor ?? Colors.grey.withOpacity(0.2), width: 1.5.w),
              borderRadius: BorderRadius.all(Radius.circular(radius??50.r))),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1.5.w),
              borderRadius: BorderRadius.all(Radius.circular(radius??50.r))),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 1.5.w),
              borderRadius: BorderRadius.all(Radius.circular(radius??50.r))),
          hintText: hintText,
          hintStyle: TextStyle(color: Theme.of(context).disabledColor, fontSize: 12),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon),
      validator: (value) {
        if (isValidate == true) {
          if (value!.isEmpty) {
            return requiredText ?? "This field is required.";
          }
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.always,
      onFieldSubmitted: onFieldSubmitted,
    );
  }
}

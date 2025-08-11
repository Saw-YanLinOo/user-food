import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:user/theme/dark_theme.dart';
import 'package:user/util/dimensions.dart';
import 'package:user/view/widgets/custom_button.dart';
import 'package:user/view/widgets/custom_text_form_field.dart';

import '../../../helper/route_helper.dart';
import '../../widgets/custom_text.dart';
import 'package:user/controller/user_controller.dart';
import 'package:user/view/base/custom_dropdown.dart';

class PersonalInformationScreen extends StatelessWidget {
  const PersonalInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
   // final UserController userController = Get.find<UserController>();
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60.h,
        backgroundColor: Color(0xff6c5d5a),
        centerTitle: true,
        title: CustomText(
          text: 'personal_information'.tr,
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14.sp,
        ),
        leading: Padding(
          padding: EdgeInsets.all(10.w),
          child: InkWell(
            onTap: () {
              Get.back();
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
      body: GetBuilder<UserController>(builder: (userController){

          return Container(
            padding: EdgeInsets.all(15.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff3E2723), Color(0xff212121)],
              ),
            ),
            child: ListView(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: CustomText(
                    text: 'personal_info_hint'.tr,
                    color: Theme.of(context).disabledColor,
                    maxLines: 7,
                    textAlign: TextAlign.center,
                  ),
                ),
                Dimensions.kSizedBoxH30,
                CustomText(
                  text: 'username'.tr,
                  color: Theme.of(context).disabledColor,
                ),
                Dimensions.kSizedBoxH5,
                CustomTextFormField(
                  radius: Dimensions.radiusDefault,
                  hintText: 'Benn Benn',
                  isValidate: false,
                  fillColor: Colors.transparent,
                ),
                Dimensions.kSizedBoxH15,
                CustomText(
                  text: 'register_ph_number'.tr,
                  color: Theme.of(context).disabledColor,
                ),
                Dimensions.kSizedBoxH5,
                CustomTextFormField(
                  radius: Dimensions.radiusDefault,
                  readonly: true,
                  hintText: '09987654321',
                  isValidate: false,
                  fillColor: Colors.transparent,
                ),
                Dimensions.kSizedBoxH15,
                CustomText(
                  text: 'e-mail'.tr,
                  color:
                      Get.isDarkMode
                          ? Colors.white60
                          : Theme.of(context).disabledColor,
                ),
                Dimensions.kSizedBoxH5,
                CustomTextFormField(
                  radius: Dimensions.radiusDefault,
                  hintText: 'benn@gmail.com',
                  isValidate: false,
                  fillColor: Colors.transparent,
                ),
                Dimensions.kSizedBoxH15,
                CustomText(
                  text: 'date_of_birth'.tr,
                  color:
                      Get.isDarkMode
                          ? Colors.white60
                          : Theme.of(context).disabledColor,
                ),
                Dimensions.kSizedBoxH5,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Day Dropdown
                    Container(
                      width: 60.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: Color(0xffa89d92), width: 1),
                      ),
                      child: CustomDropdown<String>(
                        hideIcon: true,
                        items: List.generate(
                          31,
                          (i) => DropdownItem<String>(
                            value: (i + 1).toString().padLeft(2, '0'),
                            child: Center(
                              child: CustomText(
                                text: (i + 1).toString().padLeft(2, '0'),
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        selectedValue: userController.dobDay.value,
                        dropdownButtonStyle: DropdownButtonStyle(
                          height: 40.h,
                          width: 60.w,
                          padding: EdgeInsets.zero,
                        ),
                        dropdownStyle: DropdownStyle(
                          elevation: 10,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        onChange: (String? val, int idx) {
                          if (val != null) {
                            userController.setDobDay(val);
                          }
                        },
                        child: Center(
                          child: Obx(
                            () => CustomText(
                              text:
                                  userController.dobDay.value.isEmpty
                                      ? 'DD'
                                      : userController.dobDay.value,
                              color:
                                  userController.dobDay.value.isEmpty
                                      ? Colors.white60
                                      : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    CustomText(text: '-', color: Colors.white60),
                    // Month Dropdown
                    Container(
                      width: 60.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: Color(0xffa89d92), width: 1),
                      ),
                      child: CustomDropdown<String>(
                        hideIcon: true,
                        items:
                            [
                                  'Jan',
                                  'Feb',
                                  'Mar',
                                  'Apr',
                                  'May',
                                  'Jun',
                                  'Jul',
                                  'Aug',
                                  'Sep',
                                  'Oct',
                                  'Nov',
                                  'Dec',
                                ]
                                .asMap()
                                .entries
                                .map(
                                  (e) => DropdownItem<String>(
                                    value: (e.key + 1).toString().padLeft(2, '0'),
                                    child: Center(
                                      child: CustomText(
                                        text: e.value,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                        selectedValue: userController.dobMonth.value,
                        dropdownButtonStyle: DropdownButtonStyle(
                          height: 40.h,
                          width: 60.w,
                          padding: EdgeInsets.zero,
                        ),
                        dropdownStyle: DropdownStyle(
                          elevation: 10,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        onChange: (String? val, int idx) {
                          if (val != null) {
                            userController.setDobMonth(val);
                          }
                        },
                        child: Center(
                          child: Obx(() {
                            String val = userController.dobMonth.value;
                            String display =
                                val.isEmpty
                                    ? 'MM'
                                    : [
                                      'Jan',
                                      'Feb',
                                      'Mar',
                                      'Apr',
                                      'May',
                                      'Jun',
                                      'Jul',
                                      'Aug',
                                      'Sep',
                                      'Oct',
                                      'Nov',
                                      'Dec',
                                    ][(int.tryParse(val) ?? 1) - 1];
                            return CustomText(
                              text: val.isEmpty ? 'MM' : display,
                              color: val.isEmpty ? Colors.white60 : Colors.white,
                            );
                          }),
                        ),
                      ),
                    ),
                    CustomText(text: '-', color: Colors.white60),
                    // Year TextField
                    Container(
                      width: 90.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: Color(0xffa89d92), width: 1),
                      ),
                      alignment: Alignment.center,
                      child: TextField(
                        controller: userController.dobYearController,
                        onChanged: (val) {
                          userController.setDobYear(val);
                        },
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'YYYY',
                          hintStyle: TextStyle(color: Colors.white60),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40.h,
                      child: VerticalDivider(
                        color: Colors.white60,
                        width: 4,
                        thickness: 1,
                      ),
                    ),
                    Obx(
                      () => Container(
                        height: 40.h,
                        padding: EdgeInsets.symmetric(horizontal: 18.w),
                        decoration: BoxDecoration(
                          color: Color(0xffa89d92),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        alignment: Alignment.center,
                        child: CustomText(
                          text:
                              userController.dobAge.value > 0
                                  ? '${userController.dobAge.value} Years'
                                  : '-- Years',
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                Dimensions.kSizedBoxH15,
                CustomText(
                  text: 'gender'.tr,
                  color:
                      Get.isDarkMode
                          ? Colors.white60
                          : Theme.of(context).disabledColor,
                ),
                Dimensions.kSizedBoxH5,
                Obx(
                  () => Row(
                    children: [
                      RadioMenuButton(
                        value: userController.isMale.value,
                        groupValue: true,
                        onChanged: (val) {
                          userController.isFemale.value = false;
                          userController.isMale.value = true;
                        },
                        child: CustomText(
                          text: 'male'.tr,
                          color:
                              Get.isDarkMode
                                  ? Colors.white
                                  : Theme.of(context).disabledColor,
                        ),
                      ),
                      Dimensions.kSizedBoxW30,
                      RadioMenuButton(
                        value: userController.isFemale.value,
                        groupValue: true,
                        onChanged: (val) {
                          userController.isMale.value = false;
                          userController.isFemale.value = true;
                        },
                        child: CustomText(
                          text: 'female'.tr,
                          color:
                              Get.isDarkMode
                                  ? Colors.white
                                  : Theme.of(context).disabledColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Dimensions.kSizedBoxH15,
                CustomText(
                  text: 'nrc'.tr,
                  color:
                      Get.isDarkMode
                          ? Colors.white60
                          : Theme.of(context).disabledColor,
                ),
                Dimensions.kSizedBoxH5,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 60.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: Color(0xffa89d92), width: 1),
                      ),
                      child: CustomDropdown<String>(
                        items: List.generate(
                          31,
                          (i) => DropdownItem<String>(
                            value: (i + 1).toString().padLeft(2, '0'),
                            child: Center(
                              child: CustomText(
                                text: (i + 1).toString().padLeft(2, '0'),
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        selectedValue: userController.dobDay.value,
                        dropdownButtonStyle: DropdownButtonStyle(
                          height: 40.h,
                          width: 60.w,
                          padding: EdgeInsets.zero,
                        ),
                        dropdownStyle: DropdownStyle(
                          elevation: 10,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        onChange: (String? val, int idx) {
                          if (val != null) {
                            userController.setDobDay(val);
                          }
                        },
                        child: Center(
                          child: Obx(
                            () => CustomText(
                              text:
                                  userController.dobDay.value.isEmpty
                                      ? 'No.'
                                      : userController.dobDay.value,
                              color:
                                  userController.dobDay.value.isEmpty
                                      ? Colors.white60
                                      : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    CustomText(text: '/', color: Colors.white60),
                    // Month Dropdown
                    Container(
                      width: 60.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: Color(0xffa89d92), width: 1),
                      ),
                      child: CustomDropdown<String>(
                        items:
                            [
                                  'Jan',
                                  'Feb',
                                  'Mar',
                                  'Apr',
                                  'May',
                                  'Jun',
                                  'Jul',
                                  'Aug',
                                  'Sep',
                                  'Oct',
                                  'Nov',
                                  'Dec',
                                ]
                                .asMap()
                                .entries
                                .map(
                                  (e) => DropdownItem<String>(
                                    value: (e.key + 1).toString().padLeft(2, '0'),
                                    child: Center(
                                      child: CustomText(
                                        text: e.value,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                        selectedValue: userController.dobMonth.value,
                        dropdownButtonStyle: DropdownButtonStyle(
                          height: 40.h,
                          width: 60.w,
                          padding: EdgeInsets.zero,
                        ),
                        dropdownStyle: DropdownStyle(
                          elevation: 10,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        onChange: (String? val, int idx) {
                          if (val != null) {
                            userController.setDobMonth(val);
                          }
                        },
                        child: Center(
                          child: Obx(() {
                            String val = userController.dobMonth.value;
                            String display =
                                val.isEmpty
                                    ? 'City'
                                    : [
                                      'Jan',
                                      'Feb',
                                      'Mar',
                                      'Apr',
                                      'May',
                                      'Jun',
                                      'Jul',
                                      'Aug',
                                      'Sep',
                                      'Oct',
                                      'Nov',
                                      'Dec',
                                    ][(int.tryParse(val) ?? 1) - 1];
                            return CustomText(
                              text: val.isEmpty ? 'City' : display,
                              color: val.isEmpty ? Colors.white60 : Colors.white,
                            );
                          }),
                        ),
                      ),
                    ),
                    CustomText(text: '/', color: Colors.white60),
                    Container(
                      width: 60.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: Color(0xffa89d92), width: 1),
                      ),
                      child: CustomDropdown<String>(
                        items:
                            [
                                  'Jan',
                                  'Feb',
                                  'Mar',
                                  'Apr',
                                  'May',
                                  'Jun',
                                  'Jul',
                                  'Aug',
                                  'Sep',
                                  'Oct',
                                  'Nov',
                                  'Dec',
                                ]
                                .asMap()
                                .entries
                                .map(
                                  (e) => DropdownItem<String>(
                                    value: (e.key + 1).toString().padLeft(2, '0'),
                                    child: Center(
                                      child: CustomText(
                                        text: e.value,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                        selectedValue: userController.dobMonth.value,
                        dropdownButtonStyle: DropdownButtonStyle(
                          height: 40.h,
                          width: 60.w,
                          padding: EdgeInsets.zero,
                        ),
                        dropdownStyle: DropdownStyle(
                          elevation: 10,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        onChange: (String? val, int idx) {
                          if (val != null) {
                            userController.setDobMonth(val);
                          }
                        },
                        child: Center(
                          child: Obx(() {
                            String val = userController.dobMonth.value;
                            String display =
                                val.isEmpty
                                    ? 'Type'
                                    : [
                                      'Jan',
                                      'Feb',
                                      'Mar',
                                      'Apr',
                                      'May',
                                      'Jun',
                                      'Jul',
                                      'Aug',
                                      'Sep',
                                      'Oct',
                                      'Nov',
                                      'Dec',
                                    ][(int.tryParse(val) ?? 1) - 1];
                            return CustomText(
                              text: val.isEmpty ? 'Type' : display,
                              color: val.isEmpty ? Colors.white60 : Colors.white,
                            );
                          }),
                        ),
                      ),
                    ),
                    Container(
                      width: 90.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: Color(0xffa89d92), width: 1),
                      ),
                      alignment: Alignment.center,
                      child: TextField(
                        controller: userController.dobYearController,
                        onChanged: (val) {
                          userController.setDobYear(val);
                        },
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '123456',
                          hintStyle: TextStyle(color: Colors.white60),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
                Dimensions.kSizedBoxH15,

                InkWell(
                  onTap: () {
                    userController.pickImageFrontID();
                  },
                  child: DottedBorder(
                    strokeWidth: 1, // Thickness of the border
                    color:
                        Theme.of(context).disabledColor, // Color of the dots/dashes
                    borderType:
                        BorderType
                            .RRect, // Shape of the border (e.g., rectangle with rounded corners)
                    radius: Radius.circular(
                      15.r,
                    ), // Radius for rounded corners if borderType is RRect
                    dashPattern: [
                      2,
                      3,
                    ], // Pattern of dashes and spaces (e.g., 5 pixels dash, 5 pixels space)
                    child: Container(
                      height: 170.h,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      child: Center(
                        child: userController.pickedIDFrontFile != null
                            ? Obx(
                                () =>  Image.file(
                              File(userController.imageFrontPath.value),
                              // width: 100,
                              // height: 100,
                              fit: BoxFit.cover,
                            ))
                            :  Icon(
                          Icons.photo,
                          size: 80.w,
                          color: Colors.grey.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                ),
                Dimensions.kSizedBoxH10,
                Center(
                  child: CustomText(
                    text: 'front_photo'.tr,
                    color: Theme.of(context).disabledColor,
                  ),
                ),
                Dimensions.kSizedBoxH20,
               InkWell(
                    onTap: () {
                      userController.pickImageBackID();
                    },
                    child: DottedBorder(
                      strokeWidth: 1, // Thickness of the border
                      color: Theme.of(context).disabledColor,
                      borderType: BorderType.RRect,
                      radius: Radius.circular(15.r),
                      dashPattern: [
                        2,
                        3,
                      ], // Pattern of dashes and spaces (e.g., 5 pixels dash, 5 pixels space)
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        height: 170.h,

                        child: Center(
                          child:
                              userController.imageBackPath.value != ""
                                  ? Obx(
                                    () =>  Image.file(
                                    File(userController.imageBackPath.value),
                                    // width: 100,
                                    // height: 100,
                                    fit: BoxFit.cover,
                                  ))
                                  : Icon(
                                    Icons.photo,
                                    size: 80.w,
                                    color: Colors.grey.withOpacity(0.5),
                                  ),
                        ),
                      ),
                    ),
                  ),

                Dimensions.kSizedBoxH10,
                Center(
                  child: CustomText(
                    text: 'back_photo'.tr,
                    color: Theme.of(context).disabledColor,
                  ),
                ),
                Dimensions.kSizedBoxH30,
                Dimensions.kSizedBoxH30,
                Dimensions.kSizedBoxH30,
                CustomTTButton(
                  bgColor: dark.primaryColor,
                  isRounded: true,
                  text: 'save_setting'.tr,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => CustomClearAllDialog(
                        onConfirm: () {

                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}

// Custom dialog for clearing all notifications
class CustomClearAllDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  const CustomClearAllDialog({Key? key, required this.onConfirm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 56, left: 24, right: 24, bottom: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 24),
                CustomText(
                  text: 'congrat'.tr,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                CustomText(
                  text: 'rewards_for_profile'.tr,
                  maxLines: 6,
                  fontSize: 14.sp,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: context.width,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFE53935), width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child:  Text('see_my_points'.tr
                        , style: TextStyle(color: Color(0xFFE53935), fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: -90.h,
            child: Center(
              child: Image.asset(
                'assets/image/profile_reward.png',
                width: 130.w,
                height: 170.h,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

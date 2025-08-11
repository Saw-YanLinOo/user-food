import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user/controller/auth_controller.dart';
import 'package:user/controller/localization_controller.dart';
import 'package:user/controller/splash_controller.dart';
import 'package:user/controller/theme_controller.dart';
import 'package:user/controller/user_controller.dart';
import 'package:user/helper/date_converter.dart';
import 'package:user/helper/price_converter.dart';
import 'package:user/helper/responsive_helper.dart';
import 'package:user/helper/route_helper.dart';
import 'package:user/util/app_constants.dart';
import 'package:user/util/colors.dart';
import 'package:user/util/dimensions.dart';
import 'package:user/util/images.dart';
import 'package:user/util/styles.dart';
import 'package:user/view/base/confirmation_dialog.dart';
import 'package:user/view/base/custom_image.dart';
import 'package:user/view/base/web_menu_bar.dart';
import 'package:user/view/screens/auth/sign_in_screen.dart';
import 'package:user/view/screens/profile/personal_information_screen.dart';
import 'package:user/view/screens/profile/widget/profile_button.dart';
import 'package:user/view/screens/profile/widget/profile_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/view/widgets/custom_text.dart';
import 'package:user/view/widgets/dark_mode_toggle.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late bool _isLoggedIn;

  @override
  void initState() {
    super.initState();
    _isLoggedIn = Get.find<AuthController>().isLoggedIn();

    if (_isLoggedIn && Get.find<UserController>().userInfoModel == null) {
      Get.find<UserController>().getUserInfo();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool showWalletCard =
        Get.find<SplashController>().configModel!.customerWalletStatus == 1 ||
        Get.find<SplashController>().configModel!.loyaltyPointStatus == 1;

    return Scaffold(
      //extendBodyBehindAppBar: true,
      appBar:
          ResponsiveHelper.isDesktop(context)
              ? const WebMenuBar()
              : AppBar(
                backgroundColor: Color(0xff3E2723),
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
                actions: [DarkModeToggle()],
              ),
      //backgroundColor: Theme.of(context).cardColor,
      body: Stack(
        children: [
          // Positioned.fill(
          //   child: Image.asset(
          //     Images.termsImg,
          //     fit: BoxFit.cover,
          //   ),
          // ),
          // Positioned.fill(
          //   child: Container(
          //     decoration: BoxDecoration(
          //       gradient: LinearGradient(
          //         begin: Alignment.topLeft,
          //         end: Alignment.bottomRight,
          //         colors: [
          //           Colors.black.withOpacity(0.1),
          //           Colors.black.withOpacity(0.4),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          GetBuilder<UserController>(
            builder: (userController) {
              return (_isLoggedIn && userController.userInfoModel == null)
                  ? const Center(child: CircularProgressIndicator())
                  : Container(
                    padding: EdgeInsets.all(15.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xff3E2723), Color(0xff212121)],
                      ),
                    ),
                    // color:
                    //     Theme.of(context).secondaryHeaderColor.withOpacity(0.2),
                    width: Dimensions.webMaxWidth,
                    height: context.height,
                    child: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeExtraLarge,
                          ),
                          child: Column(
                            children: [
                              Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  ClipOval(
                                    child: CustomImage(
                                      placeholder: Images.guestIcon,
                                      image:
                                          '${Get.find<SplashController>().configModel!.baseUrls!.customerImageUrl}'
                                          '/${(userController.userInfoModel != null && _isLoggedIn) ? userController.userInfoModel!.image : ''}',
                                      height: 100.h,
                                      width: 110.w,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child:
                                        _isLoggedIn
                                            ? InkWell(
                                              onTap:
                                                  () => Get.toNamed(
                                                    RouteHelper.getUpdateProfileRoute(),
                                                  ),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.white54,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Theme.of(context)
                                                          .secondaryHeaderColor
                                                          .withOpacity(0.05),
                                                      blurRadius: 5,
                                                      spreadRadius: 1,
                                                      offset: const Offset(
                                                        3,
                                                        3,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                padding: const EdgeInsets.all(
                                                  Dimensions
                                                      .paddingSizeExtraSmall,
                                                ),
                                                child: const Icon(
                                                  Icons.camera_alt,
                                                  size: 24,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            )
                                            : InkWell(
                                              onTap: () async {
                                                if (!ResponsiveHelper.isDesktop(
                                                  context,
                                                )) {
                                                  await Get.toNamed(
                                                    RouteHelper.getSignInRoute(
                                                      Get.currentRoute,
                                                    ),
                                                  );
                                                } else {
                                                  Get.dialog(
                                                    const SignInScreen(
                                                      exitFromApp: false,
                                                      backFromThis: true,
                                                    ),
                                                  );
                                                }
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        Dimensions
                                                            .radiusDefault,
                                                      ),
                                                  color:
                                                      Theme.of(
                                                        context,
                                                      ).primaryColor,
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical:
                                                          Dimensions
                                                              .paddingSizeSmall,
                                                      horizontal:
                                                          Dimensions
                                                              .paddingSizeLarge,
                                                    ),
                                                child: Text(
                                                  'login'.tr,
                                                  style: robotoMedium.copyWith(
                                                    color:
                                                        Theme.of(
                                                          context,
                                                        ).cardColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                  ),
                                  // if (_isLoggedIn)
                                  //   Positioned(
                                  //     bottom: 0,
                                  //     right: 0,
                                  //     child: InkWell(
                                  //       onTap: () {
                                  //         // TODO: Implement your image update logic here
                                  //       },
                                  //       child: Container(
                                  //         decoration: BoxDecoration(
                                  //           shape: BoxShape.circle,
                                  //           color: Theme.of(context).primaryColor,
                                  //           border: Border.all(color: Colors.white, width: 2),
                                  //         ),
                                  //         padding: const EdgeInsets.all(4),
                                  //         child: const Icon(
                                  //           Icons.edit,
                                  //           size: 16,
                                  //           color: Colors.white,
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ),
                                ],
                              ),
                              Dimensions.kSizedBoxH5,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        _isLoggedIn
                                            ? '${userController.userInfoModel!.fName}'
                                            : 'guest_user'.tr,
                                        style: robotoBold.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              Dimensions.fontSizeOverLarge,
                                        ),
                                      ),
                                      Dimensions.kSizedBoxW10,
                                      Image.asset(
                                        'assets/image/crown.png',
                                        width: 25.w,
                                        height: 25.h,
                                      ),
                                    ],
                                  ),

                                  if (_isLoggedIn)
                                    Text(
                                      '',
                                      // '${'joined'.tr} ${DateConverter.containTAndZToUTCFormat(userController.userInfoModel!.createdAt!)}',
                                      style: robotoMedium.copyWith(
                                        fontSize: Dimensions.fontSizeSmall,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  if (!_isLoggedIn)
                                    InkWell(
                                      onTap: () async {
                                        if (!ResponsiveHelper.isDesktop(
                                          context,
                                        )) {
                                          await Get.toNamed(
                                            RouteHelper.getSignInRoute(
                                              Get.currentRoute,
                                            ),
                                          );
                                        } else {
                                          Get.dialog(
                                            const SignInScreen(
                                              exitFromApp: false,
                                              backFromThis: true,
                                            ),
                                          );
                                        }
                                      },
                                      child: Text(
                                        'login_to_view_all_feature'.tr,
                                        style: robotoMedium.copyWith(
                                          fontSize: Dimensions.fontSizeSmall,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              Container(
                                width: 100.w,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 5.h,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.r),
                                  color: Colors.green,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(
                                      Icons.verified,
                                      color: Colors.greenAccent,
                                    ),
                                    CustomText(
                                      text: 'verified'.tr,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeLarge),
                        Card(
                          color: Colors.yellow,

                          child: ListTile(
                            leading: Image.asset(
                              'assets/image/crown.png',
                              width: 40.w,
                              height: 40.h,
                            ),
                            trailing: Icon(Icons.arrow_forward_ios, size: 15.w),
                            title: CustomText(text: 'gold'.tr),
                            subtitle: CustomText(text: '1200 Points'.tr),
                          ),
                        ),
                        Card(
                          color: Theme.of(context).cardColor,
                          child: ListTile(
                            leading: Icon(Icons.wallet_rounded, size: 30.w),
                            trailing: Icon(Icons.arrow_forward_ios, size: 15.w),
                            title: CustomText(
                              text: 'wallet'.tr,
                              color: Theme.of(context).disabledColor,
                              fontWeight: FontWeight.bold,
                            ),
                            subtitle: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(text: "wallet_balance".tr),
                                  TextSpan(
                                    text: PriceConverter.convertPrice(
                                      userController
                                          .userInfoModel!
                                          .walletBalance,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // (showWalletCard && _isLoggedIn)
                        //     ? Row(children: [
                        //   Get.find<SplashController>()
                        //       .configModel!
                        //       .loyaltyPointStatus ==
                        //       1
                        //       ? Expanded(
                        //       child: ProfileCard(
                        //         image: Images.loyaltyIcon,
                        //         data: userController
                        //             .userInfoModel!
                        //             .loyaltyPoint !=
                        //             null
                        //             ? userController
                        //             .userInfoModel!
                        //             .loyaltyPoint
                        //             .toString()
                        //             : '0',
                        //         title: 'loyalty_points'.tr,
                        //       ))
                        //       : const SizedBox(),
                        //   SizedBox(
                        //       width: Get.find<SplashController>()
                        //           .configModel!
                        //           .loyaltyPointStatus ==
                        //           1
                        //           ? Dimensions.paddingSizeSmall
                        //           : 0),
                        //   _isLoggedIn
                        //       ? Expanded(
                        //       child: ProfileCard(
                        //         image: Images.shoppingBagIcon,
                        //         data: userController
                        //             .userInfoModel!.orderCount
                        //             .toString(),
                        //         title: 'total_order'.tr,
                        //       ))
                        //       : const SizedBox(),
                        //   SizedBox(
                        //       width: Get.find<SplashController>()
                        //           .configModel!
                        //           .customerWalletStatus ==
                        //           1
                        //           ? Dimensions.paddingSizeSmall
                        //           : 0),
                        //   Get.find<SplashController>()
                        //       .configModel!
                        //       .customerWalletStatus ==
                        //       1
                        //       ? Expanded(
                        //       child: ProfileCard(
                        //         image: Images.walletProfile,
                        //         data:
                        //         PriceConverter.convertPrice(
                        //             userController
                        //                 .userInfoModel!
                        //                 .walletBalance),
                        //         title: 'wallet_balance'.tr,
                        //       ))
                        //       : const SizedBox(),
                        // ])
                        //     : const SizedBox(),
                        const SizedBox(height: Dimensions.paddingSizeDefault),
                        CustomText(
                          text: 'general'.tr,
                          color: Theme.of(context).disabledColor,
                          fontSize: 15.sp,
                        ),
                        Dimensions.kSizedBoxH5,
                        Card(
                          shape:RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(Dimensions.roundRadius)
                          ),
                          color: Theme.of(context).cardColor,
                          child: ListTile(
                            onTap: () {
                              Get.to(()=>PersonalInformationScreen());
                              // Get.toNamed(RouteHelper
                              //     .getResetPasswordRoute('', '',
                              //     'password-change'));
                            },
                            title: CustomText(
                              text: 'personal_information'.tr,
                              color:
                                  Theme.of(context).textTheme.bodyMedium!.color,
                            ),
                            leading: Icon(
                              Icons.person,
                              color:
                                  Theme.of(context).textTheme.bodyMedium!.color,
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              color:
                                  Theme.of(context).textTheme.bodyMedium!.color,
                              size: 15.w,
                            ),
                          ),
                        ),
                        //Dimensions.kSizedBoxH3,
                        // ProfileButton(
                        //     icon: Icons.tonality_outlined,
                        //     title: 'dark_mode'.tr,
                        //     isButtonActive: Get.isDarkMode,
                        //     onTap: () {
                        //       Get.find<ThemeController>().toggleTheme();
                        //     }),
                        _isLoggedIn
                            ? userController.userInfoModel!.socialId == null
                                ? Card(
                          shape:RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(Dimensions.roundRadius)
                          ),
                                  color: Theme.of(context).cardColor,
                                  child: ListTile(
                                    onTap: () {
                                      Get.toNamed(
                                        RouteHelper.getResetPasswordRoute(
                                          '',
                                          '',
                                          'password-change',
                                        ),
                                      );
                                    },
                                    title: CustomText(
                                      text: 'change_password'.tr,
                                      color:
                                          Theme.of(
                                            context,
                                          ).textTheme.bodyMedium!.color,
                                    ),
                                    leading: Icon(
                                      Icons.lock,
                                      color:
                                          Theme.of(
                                            context,
                                          ).textTheme.bodyMedium!.color,
                                    ),
                                    trailing: Icon(
                                      Icons.arrow_forward_ios,
                                      color:
                                          Theme.of(
                                            context,
                                          ).textTheme.bodyMedium!.color,
                                      size: 15.w,
                                    ),
                                  ),
                                )

                                : const SizedBox()
                            : const SizedBox(),
                        //Dimensions.kSizedBoxH3,
                        GetBuilder<LocalizationController>(
                          builder: (authController) {
                            return Obx(
                              () => Card(
                                shape:RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(Dimensions.roundRadius)
                                ),
                                color: Theme.of(context).cardColor,
                                child: ListTile(
                                  contentPadding: EdgeInsets.only(
                                    left: 15.w,
                                    right: 15.w,
                                  ),

                                  //subtitle: CustomText(text: 'lan'.tr,color: Theme.of(context).textTheme.bodyMedium!.color),
                                  title: CustomText(
                                    text: 'language'.tr,
                                    color:
                                        Theme.of(
                                          context,
                                        ).textTheme.bodyMedium!.color,
                                  ),
                                  leading: Image.asset(
                                    Images.lanIcon,
                                    color:
                                        Theme.of(
                                          context,
                                        ).textTheme.bodyMedium!.color,
                                    width: 23.w,
                                  ),
                                  trailing: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CustomText(
                                        text: 'lan'.tr,
                                        color:
                                            Theme.of(
                                              context,
                                            ).textTheme.bodyMedium!.color,
                                      ),
                                      Transform.scale(
                                        scale: 0.8,
                                        child: CupertinoSwitch(
                                          value: !authController.isMM.value,
                                          activeTrackColor:
                                          Colors.green,
                                          onChanged: (bool? value) {
                                            if (authController.isMM.value) {
                                              authController.setLanguage(
                                                Locale("en", "US"),
                                              );
                                              authController.isMM.value = false;
                                            } else {
                                              authController.setLanguage(
                                                Locale("my", "MM"),
                                              );
                                              authController.isMM.value = true;
                                            }
                                          },
                                          inactiveTrackColor: Theme.of(context)
                                              .secondaryHeaderColor
                                              .withOpacity(0.5),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              //  ProfileButton(
                              //   iconImage: Images.lanIcon,
                              //   title: 'language'.tr,
                              //   subTitle: 'lan'.tr,
                              //   isButtonActive:
                              //   !authController.isMM.value,
                              //   onTap: () {

                              //   },
                              // ),
                            );
                          },
                        ),
                        //Dimensions.kSizedBoxH3,
                        _isLoggedIn
                            ? GetBuilder<AuthController>(
                              builder: (authController) {
                                return Card(
                                  shape:RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(Dimensions.roundRadius)
                                  ),
                                  color: Theme.of(context).cardColor,
                                  child: ListTile(
                                    contentPadding: EdgeInsets.only(
                                      left: 15.w,
                                      right: 15.w,
                                    ),
                                    //subtitle: CustomText(text: 'lan'.tr,color: Theme.of(context).textTheme.bodyMedium!.color),
                                    title: CustomText(
                                      text: 'notification'.tr,
                                      color:
                                          Theme.of(
                                            context,
                                          ).textTheme.bodyMedium!.color,
                                    ),
                                    leading: Icon(
                                      Icons.notifications,
                                      color:
                                          Theme.of(
                                            context,
                                          ).textTheme.bodyMedium!.color,
                                    ),
                                    trailing: Transform.scale(
                                      scale: 0.8,
                                      child: CupertinoSwitch(
                                        value: authController.notification,
                                        activeTrackColor: Colors.green,
                                        onChanged: (bool? value) {
                                          authController.setNotificationActive(
                                            !authController.notification,
                                          );
                                        },
                                        inactiveTrackColor: Theme.of(
                                          context,
                                        ).secondaryHeaderColor.withOpacity(0.5),
                                      ),
                                    ),
                                  ),
                                );

                              },
                            )
                            : const SizedBox(),
                        Dimensions.kSizedBoxH15,
                        CustomText(
                          text: 'earnings'.tr,
                          color: Theme.of(context).disabledColor,
                          fontSize: 15.sp,
                        ),
                        Dimensions.kSizedBoxH5,
                        Card(
                          shape:RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(Dimensions.roundRadius)
                          ),
                          color: Theme.of(context).cardColor,
                          child: ListTile(
                            onTap: () {
                              // Get.toNamed(RouteHelper
                              //     .getResetPasswordRoute('', '',
                              //     'password-change'));
                            },
                            title: CustomText(
                              text: 'refer_your_friends'.tr,
                              color:
                              Theme.of(context).textTheme.bodyMedium!.color,
                            ),
                            leading: Image.asset(
                              Images.referImg,
                              width: 20.w,
                              // color:
                              // Theme.of(context).textTheme.bodyMedium!.color,
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              color:
                              Theme.of(context).textTheme.bodyMedium!.color,
                              size: 15.w,
                            ),
                          ),
                        ),
                        Card(
                          shape:RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(Dimensions.roundRadius)
                          ),
                          color: Theme.of(context).cardColor,
                          child: ListTile(
                            onTap: () {
                              // Get.toNamed(RouteHelper
                              //     .getResetPasswordRoute('', '',
                              //     'password-change'));
                            },
                            title: CustomText(
                              text: 'join_as_a_delivery_man'.tr,
                              color:
                              Theme.of(context).textTheme.bodyMedium!.color,
                            ),
                            leading: Image.asset(
                              Images.deliBoyIcon,
                              width: 20.w,
                              height: 20.h,
                              // color:
                              // Theme.of(context).textTheme.bodyMedium!.color,
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              color:
                              Theme.of(context).textTheme.bodyMedium!.color,
                              size: 15.w,
                            ),
                          ),
                        ),
                        Card(
                          shape:RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(Dimensions.roundRadius)
                          ),
                          color: Theme.of(context).cardColor,
                          child: ListTile(
                            onTap: () {
                              // Get.toNamed(RouteHelper
                              //     .getResetPasswordRoute('', '',
                              //     'password-change'));
                            },
                            title: CustomText(
                              text: 'open_store'.tr,
                              color:
                              Theme.of(context).textTheme.bodyMedium!.color,
                            ),
                            leading: Icon(
                              Icons.restaurant,
                              color:
                              Theme.of(context).textTheme.bodyMedium!.color,
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              color:
                              Theme.of(context).textTheme.bodyMedium!.color,
                              size: 15.w,
                            ),
                          ),
                        ),

                        Dimensions.kSizedBoxH15,
                        CustomText(
                          text: 'help_and_support'.tr,
                          color: Theme.of(context).disabledColor,
                          fontSize: 15.sp,
                        ),
                        Dimensions.kSizedBoxH5,
                        Card(
                          shape:RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(Dimensions.roundRadius)
                          ),
                          color: Theme.of(context).cardColor,
                          child: ListTile(
                            onTap: () {
                              // Get.toNamed(RouteHelper
                              //     .getResetPasswordRoute('', '',
                              //     'password-change'));
                            },
                            title: CustomText(
                              text: 'privacy_policy'.tr,
                              color:
                              Theme.of(context).textTheme.bodyMedium!.color,
                            ),
                            leading: Icon(
                              Icons.policy,
                              color:
                              Theme.of(context).textTheme.bodyMedium!.color,
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              color:
                              Theme.of(context).textTheme.bodyMedium!.color,
                              size: 15.w,
                            ),
                          ),
                        ),
                        Card(
                          shape:RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(Dimensions.roundRadius)
                          ),
                          color: Theme.of(context).cardColor,
                          child: ListTile(
                            onTap: () {
                              // Get.toNamed(RouteHelper
                              //     .getResetPasswordRoute('', '',
                              //     'password-change'));
                            },
                            title: CustomText(
                              text: 'terms_and_conditions'.tr,
                              color:
                              Theme.of(context).textTheme.bodyMedium!.color,
                            ),
                            leading: Icon(
                              Icons.book,
                              color:
                              Theme.of(context).textTheme.bodyMedium!.color,
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              color:
                              Theme.of(context).textTheme.bodyMedium!.color,
                              size: 15.w,
                            ),
                          ),
                        ),
                        Card(
                          shape:RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(Dimensions.roundRadius)
                          ),
                          color: Theme.of(context).cardColor,
                          child: ListTile(
                            onTap: () {
                              // Get.toNamed(RouteHelper
                              //     .getResetPasswordRoute('', '',
                              //     'password-change'));
                            },
                            title: CustomText(
                              text: 'contact_us'.tr,
                              color:
                              Theme.of(context).textTheme.bodyMedium!.color,
                            ),
                            leading: Icon(
                              Icons.headset_mic_outlined,
                              color:
                              Theme.of(context).textTheme.bodyMedium!.color,
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              color:
                              Theme.of(context).textTheme.bodyMedium!.color,
                              size: 15.w,
                            ),
                          ),
                        ),
                        Dimensions.kSizedBoxH25,
                        Card(
                          shape:RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(Dimensions.roundRadius)
                          ),
                          color: Theme.of(context).cardColor,
                          child: ListTile(
                            onTap: () {
                              // Get.toNamed(RouteHelper
                              //     .getResetPasswordRoute('', '',
                              //     'password-change'));
                            },
                            title: CustomText(
                              text: 'feedback'.tr,
                              color:
                              Theme.of(context).textTheme.bodyMedium!.color,
                            ),
                            leading: Icon(
                              Icons.feedback,
                              color:
                              Theme.of(context).textTheme.bodyMedium!.color,
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              color:
                              Theme.of(context).textTheme.bodyMedium!.color,
                              size: 15.w,
                            ),
                          ),
                        ),
                        Card(
                          shape:RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(Dimensions.roundRadius)
                          ),
                          color: Theme.of(context).cardColor,
                          child: ListTile(
                            onTap: () {
                              // Get.toNamed(RouteHelper
                              //     .getResetPasswordRoute('', '',
                              //     'password-change'));
                            },
                            title: CustomText(
                              text: 'logout'.tr,
                              color:
                              Theme.of(context).textTheme.bodyMedium!.color,
                            ),
                            leading: Icon(
                              Icons.logout,
                              color:
                              Theme.of(context).textTheme.bodyMedium!.color,
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              color:
                              Theme.of(context).textTheme.bodyMedium!.color,
                              size: 15.w,
                            ),
                          ),
                        ),

                        // _isLoggedIn
                        //     ? ProfileButton(
                        //   icon: Icons.delete,
                        //   iconImage: Images.profileDelete,
                        //   title: 'delete_account'.tr,
                        //   onTap: () {
                        //     Get.dialog(
                        //         ConfirmationDialog(
                        //           icon: Images.support,
                        //           title:
                        //           'are_you_sure_to_delete_account'
                        //               .tr,
                        //           description:
                        //           'it_will_remove_your_all_information'
                        //               .tr,
                        //           isLogOut: true,
                        //           onYesPressed: () =>
                        //               userController.removeUser(),
                        //         ),
                        //         useSafeArea: false);
                        //   },
                        // )
                        //     : const SizedBox(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${'version'.tr}:',
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeExtraSmall,
                              ),
                            ),
                            const SizedBox(
                              width: Dimensions.paddingSizeExtraSmall,
                            ),
                            Text(
                              AppConstants.appVersion.toString(),
                              style: robotoMedium.copyWith(
                                fontSize: Dimensions.fontSizeExtraSmall,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
            },
          ),
        ],
      ),
    );
  }
}

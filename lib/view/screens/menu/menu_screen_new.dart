import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user/controller/auth_controller.dart';
import 'package:user/controller/cart_controller.dart';
import 'package:user/controller/splash_controller.dart';
import 'package:user/controller/theme_controller.dart';
import 'package:user/controller/user_controller.dart';
import 'package:user/controller/wishlist_controller.dart';
import 'package:user/helper/date_converter.dart';
import 'package:user/helper/price_converter.dart';
import 'package:user/helper/responsive_helper.dart';
import 'package:user/helper/route_helper.dart';
import 'package:user/util/dimensions.dart';
import 'package:user/util/images.dart';
import 'package:user/util/styles.dart';
import 'package:user/view/base/confirmation_dialog.dart';
import 'package:user/view/base/custom_image.dart';
import 'package:user/view/screens/contact_us/contact_us_screen.dart';
import 'package:user/view/screens/feedback/feedback_screen.dart';
import 'package:user/view/screens/menu/widget/portion_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/localization_controller.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/dark_mode_toggle.dart';
import '../auth/sign_in_screen.dart';

class MenuScreenNew extends StatefulWidget {
  const MenuScreenNew({super.key});

  @override
  State<MenuScreenNew> createState() => _MenuScreenNewState();
}

class _MenuScreenNewState extends State<MenuScreenNew> {
  final bool _isLoggedIn = Get.find<AuthController>().isLoggedIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Color(0xff3E2723),

        actions: [DarkModeToggle()],
      ),
      backgroundColor: Theme.of(context).cardColor,
      body: Container(
        width:double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xff3E2723), Color(0xff212121)],
            ),
          ),

        child: ListView(children: [
          GetBuilder<UserController>(builder: (userController) {
            return Padding(
              padding: const EdgeInsets.only(
                left: Dimensions.paddingSizeSmall,
                right: Dimensions.paddingSizeSmall,
                top: Dimensions.paddingSizeSmall,
                bottom: Dimensions.paddingSizeOverLarge,
              ),
              child: Column(

                  children: [
                    Container(

                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(1),
                      child:   Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          ClipOval(
                            child: CustomImage(
                              placeholder: Images.guestIcon,
                              image:
                              '${Get.find<SplashController>().configModel!.baseUrls!.customerImageUrl}'
                                  '/${(userController.userInfoModel != null && _isLoggedIn) ? userController.userInfoModel!.image : ''}',
                              height: 90.h,
                              width: 100.w,
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
                    ),
                    Dimensions.kSizedBoxH15,
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _isLoggedIn
                                    ? '${userController.userInfoModel?.fName}'
                                    : 'guest_user'.tr,
                                style: robotoBlack.copyWith(
                                    fontSize: Dimensions.fontSizeExtraLarge,
                                    color: Theme.of(context).primaryColorLight),
                              ),
                              Dimensions.kSizedBoxW10,
                              Image.asset(
                                'assets/image/crown.png',
                                width: 25.w,
                                height: 25.h,
                              ),
                            ],
                          ),
                          const SizedBox(
                              height: Dimensions.paddingSizeExtraSmall),
                          // _isLoggedIn && userController.userInfoModel != null
                          //     ? Text(
                          //   "",
                          //         // DateConverter.containTAndZToUTCFormat(
                          //         //     userController
                          //         //         .userInfoModel!.createdAt!),
                          //         style: robotoMedium.copyWith(
                          //             fontSize: Dimensions.fontSizeSmall,
                          //             color: Theme.of(context).cardColor),
                          //       )
                          //     :
                         if (!_isLoggedIn && userController.userInfoModel == null)
                          Text(
                                  'login_to_view_all_feature'.tr,
                                  style: robotoMedium.copyWith(
                                      fontSize: Dimensions.fontSizeSmall,
                                      color: Theme.of(context).cardColor),
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
                        ]),
                    Dimensions.kSizedBoxH5,
                    if (_isLoggedIn && userController.userInfoModel != null)
                    Card(
                      color: Colors.yellow,

                      child: ListTile(
                        onTap:(){
                          Get.toNamed(RouteHelper.getWalletRoute(false));
                        },
                        leading: Image.asset(
                          'assets/image/crown.png',
                          width: 40.w,
                          height: 40.h,
                        ),
                        trailing: Icon(Icons.arrow_forward_ios, size: 15.w),
                        title: CustomText(text: 'gold'.tr),
                        subtitle: CustomText(text: userController
                            .userInfoModel!
                            .loyaltyPoint ==
                            null
                            ? '0'
                            : "${userController
                            .userInfoModel!
                            .loyaltyPoint} ${'points'.tr}",),
                      ),
                    ),
                  if(
                        (Get.find<SplashController>()
                            .configModel!
                            .customerWalletStatus ==
                            1)
                  )
                    Card(
                      color: Theme.of(context).cardColor,
                      child: ListTile(
                        onTap:(){
                          Get.toNamed(RouteHelper.getWalletRoute(true));
                        },
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
                                  double.parse("${userController.userInfoModel?.walletBalance??"0"}"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Dimensions.kSizedBoxH15,
                    Column(children: [
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.paddingSizeDefault),
                          child: Text(
                            'general'.tr,
                            style: robotoMedium.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                color: Theme.of(context).disabledColor),
                          ),
                        ),
                        // Container(
                        //   decoration: BoxDecoration(
                        //     color: Theme.of(context).cardColor,
                        //     borderRadius:
                        //         BorderRadius.circular(Dimensions.radiusDefault),
                        //     boxShadow: const [
                        //       BoxShadow(
                        //           color: Colors.black12, spreadRadius: 1, blurRadius: 5)
                        //     ],
                        //   ),
                        //   padding: const EdgeInsets.symmetric(
                        //       horizontal: Dimensions.paddingSizeLarge,
                        //       vertical: Dimensions.paddingSizeDefault),
                        //   margin: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                        //   child: Column(children: [
                        //     PortionWidget(
                        //         icon: Images.profileIcon,
                        //         title: 'profile'.tr,
                        //         route: RouteHelper.getProfileRoute()),
                        //     PortionWidget(
                        //         icon: Images.addressIcon,
                        //         title: 'my_address'.tr,
                        //         route: RouteHelper.getAddressRoute()),
                        //     PortionWidget(
                        //         icon: Images.languageIcon,
                        //         title: 'language'.tr,
                        //         hideDivider: true,
                        //         route: RouteHelper.getLanguageRoute('menu')),
                        //   ]),
                        // )
                        Card(
                          shape:RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(Dimensions.roundRadius)
                          ),
                          color: Theme.of(context).cardColor,
                          child: ListTile(
                            onTap: () {
                              Get.toNamed(RouteHelper.getProfileRoute());
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
                        Card(
                          shape:RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(Dimensions.roundRadius)
                          ),
                          color: Theme.of(context).cardColor,
                          child: ListTile(
                            onTap: () {
                              Get.toNamed(RouteHelper.getAddressRoute());
                              // Get.toNamed(RouteHelper
                              //     .getResetPasswordRoute('', '',
                              //     'password-change'));
                            },
                            title: CustomText(
                              text: 'my_address'.tr,
                              color:
                              Theme.of(context).textTheme.bodyMedium!.color,
                            ),
                            leading: Icon(
                              Icons.location_on_rounded,
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
                              //Get.toNamed(RouteHelper.getAddressRoute());
                              // Get.toNamed(RouteHelper
                              //     .getResetPasswordRoute('', '',
                              //     'password-change'));
                            },
                            title: CustomText(
                              text: 'my_order'.tr,
                              color:
                              Theme.of(context).textTheme.bodyMedium!.color,
                            ),
                            leading: Icon(
                              Icons.history,
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
                      ]),
Dimensions.kSizedBoxH15,
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.paddingSizeDefault),
                          child: Text(
                            'earnings'.tr,
                            style: robotoMedium.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                color: Theme.of(context).disabledColor),
                          ),
                        ),
                        if(
                (Get.find<SplashController>()
                    .configModel!
                    .refEarningStatus ==
                    1)
                     ) Card(
                          shape:RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(Dimensions.roundRadius)
                          ),
                          color: Theme.of(context).cardColor,
                          child: ListTile(
                            onTap: () {
                              Get.toNamed(RouteHelper
                                  .getReferAndEarnRoute());
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
                    if((Get.find<SplashController>()
                    .configModel!
                    .toggleDmRegistration! &&
                    !ResponsiveHelper.isDesktop(context)))
                     Card(
                          shape:RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(Dimensions.roundRadius)
                          ),
                          color: Theme.of(context).cardColor,
                          child: ListTile(
                            onTap: () {
                              Get.toNamed(RouteHelper
                                  .getDeliverymanRegistrationRoute());
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
                        if((Get.find<SplashController>()
                            .configModel!
                            .toggleDmRegistration! &&
                            !ResponsiveHelper.isDesktop(context)))
                        Card(
                          shape:RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(Dimensions.roundRadius)
                          ),
                          color: Theme.of(context).cardColor,
                          child: ListTile(
                            onTap: () {
                              Get.toNamed(RouteHelper
                                  .getRestaurantRegistrationRoute());
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
                        // Container(
                        //   decoration: BoxDecoration(
                        //     color: Theme.of(context).cardColor,
                        //     borderRadius:
                        //     BorderRadius.circular(Dimensions.radiusDefault),
                        //     boxShadow: const [
                        //       BoxShadow(
                        //           color: Colors.black12, spreadRadius: 1, blurRadius: 5)
                        //     ],
                        //   ),
                        //   padding: const EdgeInsets.symmetric(
                        //       horizontal: Dimensions.paddingSizeLarge,
                        //       vertical: Dimensions.paddingSizeDefault),
                        //   margin: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                        //   child: Column(children: [
                        //     (Get.find<SplashController>()
                        //         .configModel!
                        //         .refEarningStatus ==
                        //         1)
                        //         ? PortionWidget(
                        //       icon: Images.referIcon,
                        //       title: 'refer_and_earn'.tr,
                        //       route: RouteHelper.getReferAndEarnRoute(),
                        //     )
                        //         : const SizedBox(),
                        //     (Get.find<SplashController>()
                        //         .configModel!
                        //         .toggleDmRegistration! &&
                        //         !ResponsiveHelper.isDesktop(context))
                        //         ? PortionWidget(
                        //       icon: Images.dmIcon,
                        //       title: 'join_as_a_delivery_man'.tr,
                        //       route:
                        //       RouteHelper.getDeliverymanRegistrationRoute(),
                        //     )
                        //         : const SizedBox(),
                        //     (Get.find<SplashController>()
                        //         .configModel!
                        //         .toggleRestaurantRegistration! &&
                        //         !ResponsiveHelper.isDesktop(context))
                        //         ? PortionWidget(
                        //       icon: Images.storeIcon,
                        //       title: 'open_store'.tr,
                        //       hideDivider: true,
                        //       route: RouteHelper.getRestaurantRegistrationRoute(),
                        //     )
                        //         : const SizedBox(),
                        //   ]),
                        // )
                      ]),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.paddingSizeDefault),
                          child: Text(
                            'help_and_support'.tr,
                            style: robotoMedium.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                color: Theme.of(context).disabledColor),
                          ),
                        ),
                        Card(
                          shape:RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(Dimensions.roundRadius)
                          ),
                          color: Theme.of(context).cardColor,
                          child: ListTile(
                            onTap: () {
                              Get.toNamed(RouteHelper.getHtmlRoute('privacy-policy'));
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
                              Get.toNamed(RouteHelper.getHtmlRoute('terms-and-condition'));
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
                              Get.to(()=>ContactUsScreen());
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
                        // Container(
                        //   decoration: BoxDecoration(
                        //     color: Theme.of(context).cardColor,
                        //     borderRadius:
                        //     BorderRadius.circular(Dimensions.radiusDefault),
                        //     boxShadow: const [
                        //       BoxShadow(
                        //           color: Colors.black12, spreadRadius: 1, blurRadius: 5)
                        //     ],
                        //   ),
                        //   padding: const EdgeInsets.symmetric(
                        //       horizontal: Dimensions.paddingSizeLarge,
                        //       vertical: Dimensions.paddingSizeDefault),
                        //   margin: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                        //   child: Column(children: [
                        //     PortionWidget(
                        //         icon: Images.chatIcon,
                        //         title: 'live_chat'.tr,
                        //         route: RouteHelper.getConversationRoute()),
                        //     PortionWidget(
                        //         icon: Images.helpIcon,
                        //         title: 'help_and_support'.tr,
                        //         route: RouteHelper.getSupportRoute()),
                        //     PortionWidget(
                        //         icon: Images.aboutIcon,
                        //         title: 'about_us'.tr,
                        //         route: RouteHelper.getHtmlRoute('about-us')),
                        //     PortionWidget(
                        //         icon: Images.termsIcon,
                        //         title: 'terms_conditions'.tr,
                        //         route: RouteHelper.getHtmlRoute('terms-and-condition')),
                        //     PortionWidget(
                        //         icon: Images.privacyIcon,
                        //         title: 'privacy_policy'.tr,
                        //         route: RouteHelper.getHtmlRoute('privacy-policy')),
                        //     (Get.find<SplashController>()
                        //         .configModel!
                        //         .refundPolicyStatus ==
                        //         1)
                        //         ? PortionWidget(
                        //       icon: Images.refundIcon,
                        //       title: 'refund_policy'.tr,
                        //       route: RouteHelper.getHtmlRoute('refund-policy'),
                        //     )
                        //         : const SizedBox(),
                        //     (Get.find<SplashController>()
                        //         .configModel!
                        //         .cancellationPolicyStatus ==
                        //         1)
                        //         ? PortionWidget(
                        //       icon: Images.cancelationIcon,
                        //       title: 'cancellation_policy'.tr,
                        //       route:
                        //       RouteHelper.getHtmlRoute('cancellation-policy'),
                        //     )
                        //         : const SizedBox(),
                        //     (Get.find<SplashController>()
                        //         .configModel!
                        //         .shippingPolicyStatus ==
                        //         1)
                        //         ? PortionWidget(
                        //       icon: Images.shippingIcon,
                        //       title: 'shipping_policy'.tr,
                        //       hideDivider: true,
                        //       route: RouteHelper.getHtmlRoute('shipping-policy'),
                        //     )
                        //         : const SizedBox(),
                        //   ]),
                        // )
                      ]),
                      // Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      //   Padding(
                      //     padding: const EdgeInsets.symmetric(
                      //         horizontal: Dimensions.paddingSizeDefault),
                      //     child: Text(
                      //       'promotional_activity'.tr,
                      //       style: robotoMedium.copyWith(
                      //           fontSize: Dimensions.fontSizeDefault,
                      //           color: Theme.of(context).primaryColor),
                      //     ),
                      //   ),
                      //   Container(
                      //     decoration: BoxDecoration(
                      //       color: Theme.of(context).cardColor,
                      //       borderRadius:
                      //       BorderRadius.circular(Dimensions.radiusDefault),
                      //       boxShadow: const [
                      //         BoxShadow(
                      //             color: Colors.black12, spreadRadius: 1, blurRadius: 5)
                      //       ],
                      //     ),
                      //     padding: const EdgeInsets.symmetric(
                      //         horizontal: Dimensions.paddingSizeLarge,
                      //         vertical: Dimensions.paddingSizeDefault),
                      //     margin: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      //     child: Column(children: [
                      //       PortionWidget(
                      //           icon: Images.couponIcon,
                      //           title: 'coupon'.tr,
                      //           route: RouteHelper.getCouponRoute(fromCheckout: false)),
                      //       (Get.find<SplashController>()
                      //           .configModel!
                      //           .loyaltyPointStatus ==
                      //           1)
                      //           ? PortionWidget(
                      //         icon: Images.pointIcon,
                      //         title: 'loyalty_points'.tr,
                      //         route: RouteHelper.getWalletRoute(false),
                      //         hideDivider: Get.find<SplashController>()
                      //             .configModel!
                      //             .customerWalletStatus ==
                      //             1
                      //             ? false
                      //             : true,
                      //         suffix: !_isLoggedIn
                      //             ? null
                      //             : '${Get.find<UserController>().userInfoModel?.loyaltyPoint != null ? Get.find<UserController>().userInfoModel!.loyaltyPoint.toString() : '0'} ${'points'.tr}',
                      //       )
                      //           : const SizedBox(),
                      //       (Get.find<SplashController>()
                      //           .configModel!
                      //           .customerWalletStatus ==
                      //           1)
                      //           ? PortionWidget(
                      //         icon: Images.walletIcon,
                      //         title: 'my_wallet'.tr,
                      //         hideDivider: true,
                      //         route: RouteHelper.getWalletRoute(true),
                      //         suffix: !_isLoggedIn
                      //             ? null
                      //             : PriceConverter.convertPrice(
                      //             Get.find<UserController>().userInfoModel !=
                      //                 null
                      //                 ? Get.find<UserController>()
                      //                 .userInfoModel!
                      //                 .walletBalance
                      //                 : 0),
                      //       )
                      //           : const SizedBox(),
                      //     ]),
                      //   )
                      // ]),
                      Dimensions.kSizedBoxH25,
                      Card(
                        shape:RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(Dimensions.roundRadius)
                        ),
                        color: Theme.of(context).cardColor,
                        child: ListTile(
                          onTap: () {
                            Get.to(()=>FeedbackScreen());
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
                            if (Get.find<AuthController>().isLoggedIn()) {
                              Get.dialog(
                                  ConfirmationDialog(
                                      icon: Images.support,
                                      description: 'are_you_sure_to_logout'.tr,
                                      isLogOut: true,
                                      onYesPressed: () {
                                        Get.find<AuthController>().clearSharedData();
                                        Get.find<AuthController>().socialLogout();
                                        Get.find<CartController>().clearCartList();
                                        Get.find<WishListController>().removeWishes();
                                        Get.offAllNamed(RouteHelper.getSignInRoute(
                                            RouteHelper.splash));
                                      }),
                                  useSafeArea: false);
                            } else {
                              Get.find<WishListController>().removeWishes();
                              Get.toNamed(RouteHelper.getSignInRoute(Get.currentRoute));
                            }
                          },
                          title: CustomText(
                            text:   Get.find<AuthController>().isLoggedIn()
                                ? 'logout'.tr
                                : 'sign_in'.tr,
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
                      Dimensions.kSizedBoxH30,
                      // InkWell(
                      //   onTap: () {
                      //     if (Get.find<AuthController>().isLoggedIn()) {
                      //       Get.dialog(
                      //           ConfirmationDialog(
                      //               icon: Images.support,
                      //               description: 'are_you_sure_to_logout'.tr,
                      //               isLogOut: true,
                      //               onYesPressed: () {
                      //                 Get.find<AuthController>().clearSharedData();
                      //                 Get.find<AuthController>().socialLogout();
                      //                 Get.find<CartController>().clearCartList();
                      //                 Get.find<WishListController>().removeWishes();
                      //                 Get.offAllNamed(RouteHelper.getSignInRoute(
                      //                     RouteHelper.splash));
                      //               }),
                      //           useSafeArea: false);
                      //     } else {
                      //       Get.find<WishListController>().removeWishes();
                      //       Get.toNamed(RouteHelper.getSignInRoute(Get.currentRoute));
                      //     }
                      //   },
                      //   child: Padding(
                      //     padding: const EdgeInsets.symmetric(
                      //         vertical: Dimensions.paddingSizeSmall),
                      //     child: Row(
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //           Container(
                      //             padding: const EdgeInsets.all(2),
                      //             decoration: const BoxDecoration(
                      //                 shape: BoxShape.circle, color: Colors.red),
                      //             child: Icon(Icons.power_settings_new_sharp,
                      //                 size: 14, color: Theme.of(context).cardColor),
                      //           ),
                      //           const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                      //           Text(
                      //               Get.find<AuthController>().isLoggedIn()
                      //                   ? 'logout'.tr
                      //                   : 'sign_in'.tr,
                      //               style: robotoMedium)
                      //         ]),
                      //   ),
                      // ),
                      const SizedBox(height: Dimensions.paddingSizeOverLarge)
                    ]),
                    // Image.asset(
                    //   Images.splashLogo,
                    //   width: 50,
                    // ),
                  ]),
            );
          }),

          // SingleChildScrollView(
          //             physics: const BouncingScrollPhysics(),
          //             child: Ink(
          // color: Get.find<ThemeController>().darkTheme
          //     ? Theme.of(context).colorScheme.surface
          //     : Theme.of(context).secondaryHeaderColor.withOpacity(0.1),
          // padding: const EdgeInsets.only(top: Dimensions.paddingSizeLarge),
          // child:
          //             ),
          //           ),
        ]),
      ),
    );
  }
}

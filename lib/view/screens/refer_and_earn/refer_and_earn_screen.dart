import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user/controller/auth_controller.dart';
import 'package:user/controller/splash_controller.dart';
import 'package:user/controller/user_controller.dart';
import 'package:user/helper/price_converter.dart';
import 'package:user/helper/responsive_helper.dart';
import 'package:user/util/dimensions.dart';
import 'package:user/util/images.dart';
import 'package:user/util/styles.dart';
import 'package:user/view/base/custom_app_bar.dart';
import 'package:user/view/base/custom_snackbar.dart';
import 'package:user/view/base/not_logged_in_screen.dart';
import 'package:user/view/screens/refer_and_earn/widget/bottom_sheet_view.dart';
import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:user/view/widgets/custom_button.dart';

import '../../widgets/custom_text.dart';

enum ShareType {
  facebook,
  messenger,
  twitter,
  whatsapp,
}

class ReferAndEarnScreen extends StatefulWidget {
  const ReferAndEarnScreen({super.key});

  @override
  State<ReferAndEarnScreen> createState() => _ReferAndEarnScreenState();
}

class _ReferAndEarnScreenState extends State<ReferAndEarnScreen> {
  @override
  void initState() {
    super.initState();

    initCall();
  }

  void initCall() {
    if (Get.find<AuthController>().isLoggedIn() &&
        Get.find<UserController>().userInfoModel == null) {
      Get.find<UserController>().getUserInfo();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = Get.find<AuthController>().isLoggedIn();
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60.h,
        backgroundColor: Color(0xff6c5d5a),
        centerTitle: true,
        title: CustomText(
          text:'refer'.tr ,
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

      body: isLoggedIn
            ? Container(
              height: context.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xff3E2723), Color(0xff212121)],
                ),
              ),
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeLarge),
              child: GetBuilder<UserController>(builder: (userController) {
                return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(child: Column(
                        children: [
                          const SizedBox(
                              height: Dimensions.paddingSizeExtraLarge),

                          Image.asset(
                            Images.referImage,
                            width:
                            ResponsiveHelper.isDesktop(context) ? 200 : 500,
                            height:
                            ResponsiveHelper.isDesktop(context) ? 250 : 150,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(
                              height: Dimensions.paddingSizeExtraLarge),

                          Text('refer_title'.tr,
                              style: robotoBold.copyWith(
                                //color: Theme.of(context).primaryColor,
                                  fontSize: Dimensions.fontSizeLarge)),
                          const SizedBox(
                              height: Dimensions.paddingSizeExtraSmall),

                          // Text(
                          //   '${'one_referral'.tr}= ${PriceConverter.convertPrice(Get.find<SplashController>().configModel != null ? Get.find<SplashController>().configModel!.refEarningExchangeRate!.toDouble() : 0.0)}',
                          //   style: robotoBold.copyWith(
                          //       fontSize: Dimensions.fontSizeDefault),
                          //   textDirection: TextDirection.ltr,
                          // ),
                          const SizedBox(height: 40),

                          // Text('invite_friends_and_business'.tr,
                          //     style: robotoBold.copyWith(
                          //         fontSize: Dimensions.fontSizeOverLarge),
                          //     textAlign: TextAlign.center),
                          // const SizedBox(height: Dimensions.paddingSizeSmall),


                          const SizedBox(
                              height: Dimensions.paddingSizeExtraLarge),

                          // Text('your_personal_code'.tr,
                          //     style: robotoRegular.copyWith(
                          //         fontSize: Dimensions.fontSizeSmall,
                          //         color: Theme.of(context).hintColor),
                          //     textAlign: TextAlign.center),
                          // const SizedBox(height: Dimensions.paddingSizeSmall),

                          DottedBorder(
                            color: Theme.of(context).disabledColor,
                            strokeWidth: 1.5,
                            strokeCap: StrokeCap.butt,
                            dashPattern: const [10, 0],
                            padding: const EdgeInsets.all(0),
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(50),
                            child: SizedBox(
                              height: 50,
                              width: context.width/1.5,
                              child: (userController.userInfoModel != null)
                                  ? Row(children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left:
                                        Dimensions.paddingSizeLarge),
                                    child: Text(
                                      userController.userInfoModel != null
                                          ? userController.userInfoModel!
                                          .refCode ??
                                          ''
                                          : '',
                                      style: robotoMedium.copyWith(
                                          fontSize: Dimensions
                                              .fontSizeExtraLarge),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    if (userController.userInfoModel!
                                        .refCode!.isNotEmpty) {
                                      Clipboard.setData(ClipboardData(
                                          text:
                                          '${userController.userInfoModel != null ? userController.userInfoModel!.refCode : ''}'));
                                      showCustomSnackBar(
                                          'referral_code_copied'.tr,
                                          isError: false);
                                    }
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .primaryColor,
                                        borderRadius:
                                        BorderRadius.only(bottomRight: Radius.circular(50.r),topRight: Radius.circular(50.r))),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: Dimensions
                                            .paddingSizeExtraLarge),
                                    // margin: const EdgeInsets.all(
                                    //     Dimensions.paddingSizeExtraSmall),
                                    child: Text('copy'.tr,
                                        style: robotoMedium.copyWith(
                                            color: Theme.of(context)
                                                .disabledColor,
                                            fontSize: Dimensions
                                                .fontSizeDefault)),
                                  ),
                                ),
                              ])
                                  : const CircularProgressIndicator(),
                            ),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeLarge),
                          Text('refer_body'.tr,
                              style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeSmall),
                              textAlign: TextAlign.center),

                        ],
                      )),

                      Padding(padding: EdgeInsets.all(10.w),
                        child: CustomTTButton(
                            isRounded: true,
                            text: 'refer_now'.tr,
                            onTap: () => Share.share(
                                '${'this_is_my_refer_code'.tr}: ${userController.userInfoModel!.refCode}'),
                        ),
                      ),
                      // InkWell(
                      //   onTap: () => Share.share(
                      //       '${'this_is_my_refer_code'.tr}: ${userController.userInfoModel!.refCode}'),
                      //   child: Container(
                      //     decoration: BoxDecoration(
                      //       shape: BoxShape.circle,
                      //       color: Theme.of(context).cardColor,
                      //       boxShadow: [
                      //         BoxShadow(
                      //             color: Theme.of(context)
                      //                 .secondaryHeaderColor
                      //                 .withOpacity(0.2),
                      //             blurRadius: 5)
                      //       ],
                      //     ),
                      //     padding: const EdgeInsets.all(7),
                      //     child: const Icon(Icons.share),
                      //   ),
                      // ),

                      // Wrap(children: [
                      //   InkWell(
                      //     onTap: () => onButtonTap(ShareType.messenger, userController.userInfoModel!.refCode!),
                      //     child: Image.asset(Images.messengerIcon, height: 40, width: 40),
                      //   ),
                      //   const SizedBox(width: Dimensions.paddingSizeSmall),
                      //
                      //   InkWell(
                      //     onTap: () => onButtonTap(ShareType.whatsapp, userController.userInfoModel!.refCode!),
                      //     child: Image.asset(Images.whatsappIcon, height: 40, width: 40),
                      //   ),
                      //   const SizedBox(width: Dimensions.paddingSizeSmall),
                      //
                      //   InkWell(
                      //     onTap: () => Share.share('${'this_is_my_refer_code'.tr}: ${userController.userInfoModel!.refCode}'),
                      //     child: Container(
                      //       decoration: BoxDecoration(
                      //         shape: BoxShape.circle,
                      //         color: Theme.of(context).cardColor,
                      //         boxShadow: [BoxShadow(color: Theme.of(context).secondaryHeaderColor.withOpacity(0.2), blurRadius: 5)],
                      //       ),
                      //       padding: const EdgeInsets.all(7),
                      //       child: const Icon(Icons.share),
                      //     ),
                      //   )
                      // ]),

                      ResponsiveHelper.isDesktop(context)
                          ? const Padding(
                              padding: EdgeInsets.only(
                                  top: Dimensions.paddingSizeExtraLarge),
                              child: BottomSheetView(),
                            )
                          : const SizedBox(),
                    ]);
              }),
            )
            : NotLoggedInScreen(callBack: (value) {
                initCall();
                setState(() {});
              }),
        //persistentContentHeight: ResponsiveHelper.isDesktop(context) ? 0 : 60,
        // expandableContent: ResponsiveHelper.isDesktop(context) || !isLoggedIn
        //     ? const SizedBox()
        //     : const BottomSheetView(),

      // body: ExpandableBottomSheet(
      //   background: isLoggedIn
      //       ? SingleChildScrollView(
      //     padding: EdgeInsets.symmetric(
      //         horizontal: ResponsiveHelper.isDesktop(context)
      //             ? 0
      //             : Dimensions.paddingSizeLarge),
      //     child: Container(
      //       decoration: BoxDecoration(
      //         gradient: LinearGradient(
      //           begin: Alignment.topCenter,
      //           end: Alignment.bottomCenter,
      //           colors: [Color(0xff3E2723), Color(0xff212121)],
      //         ),
      //       ),
      //       padding: const EdgeInsets.symmetric(
      //           horizontal: Dimensions.paddingSizeLarge),
      //       child: GetBuilder<UserController>(builder: (userController) {
      //         return Column(
      //             mainAxisAlignment: MainAxisAlignment.start,
      //             children: [
      //               const SizedBox(
      //                   height: Dimensions.paddingSizeExtraLarge),
      //
      //               Image.asset(
      //                 Images.referImage,
      //                 width:
      //                 ResponsiveHelper.isDesktop(context) ? 200 : 500,
      //                 height:
      //                 ResponsiveHelper.isDesktop(context) ? 250 : 150,
      //                 fit: BoxFit.contain,
      //               ),
      //               const SizedBox(
      //                   height: Dimensions.paddingSizeExtraLarge),
      //
      //               Text('earn_money_on_every_referral'.tr,
      //                   style: robotoRegular.copyWith(
      //                       color: Theme.of(context).primaryColor,
      //                       fontSize: Dimensions.fontSizeSmall)),
      //               const SizedBox(
      //                   height: Dimensions.paddingSizeExtraSmall),
      //
      //               Text(
      //                 '${'one_referral'.tr}= ${PriceConverter.convertPrice(Get.find<SplashController>().configModel != null ? Get.find<SplashController>().configModel!.refEarningExchangeRate!.toDouble() : 0.0)}',
      //                 style: robotoBold.copyWith(
      //                     fontSize: Dimensions.fontSizeDefault),
      //                 textDirection: TextDirection.ltr,
      //               ),
      //               const SizedBox(height: 40),
      //
      //               Text('invite_friends_and_business'.tr,
      //                   style: robotoBold.copyWith(
      //                       fontSize: Dimensions.fontSizeOverLarge),
      //                   textAlign: TextAlign.center),
      //               const SizedBox(height: Dimensions.paddingSizeSmall),
      //
      //               Text('copy_your_code_share_it_with_your_friends'.tr,
      //                   style: robotoRegular.copyWith(
      //                       fontSize: Dimensions.fontSizeSmall),
      //                   textAlign: TextAlign.center),
      //               const SizedBox(
      //                   height: Dimensions.paddingSizeExtraLarge),
      //
      //               Text('your_personal_code'.tr,
      //                   style: robotoRegular.copyWith(
      //                       fontSize: Dimensions.fontSizeSmall,
      //                       color: Theme.of(context).hintColor),
      //                   textAlign: TextAlign.center),
      //               const SizedBox(height: Dimensions.paddingSizeSmall),
      //
      //               DottedBorder(
      //                 color: Theme.of(context).primaryColor,
      //                 strokeWidth: 1,
      //                 strokeCap: StrokeCap.butt,
      //                 dashPattern: const [8, 5],
      //                 padding: const EdgeInsets.all(0),
      //                 borderType: BorderType.RRect,
      //                 radius: const Radius.circular(50),
      //                 child: SizedBox(
      //                   height: 50,
      //                   child: (userController.userInfoModel != null)
      //                       ? Row(children: [
      //                     Expanded(
      //                       child: Padding(
      //                         padding: const EdgeInsets.only(
      //                             left:
      //                             Dimensions.paddingSizeLarge),
      //                         child: Text(
      //                           userController.userInfoModel != null
      //                               ? userController.userInfoModel!
      //                               .refCode ??
      //                               ''
      //                               : '',
      //                           style: robotoMedium.copyWith(
      //                               fontSize: Dimensions
      //                                   .fontSizeExtraLarge),
      //                         ),
      //                       ),
      //                     ),
      //                     InkWell(
      //                       onTap: () {
      //                         if (userController.userInfoModel!
      //                             .refCode!.isNotEmpty) {
      //                           Clipboard.setData(ClipboardData(
      //                               text:
      //                               '${userController.userInfoModel != null ? userController.userInfoModel!.refCode : ''}'));
      //                           showCustomSnackBar(
      //                               'referral_code_copied'.tr,
      //                               isError: false);
      //                         }
      //                       },
      //                       child: Container(
      //                         alignment: Alignment.center,
      //                         decoration: BoxDecoration(
      //                             color: Theme.of(context)
      //                                 .primaryColor,
      //                             borderRadius:
      //                             BorderRadius.circular(50)),
      //                         padding: const EdgeInsets.symmetric(
      //                             horizontal: Dimensions
      //                                 .paddingSizeExtraLarge),
      //                         margin: const EdgeInsets.all(
      //                             Dimensions.paddingSizeExtraSmall),
      //                         child: Text('copy'.tr,
      //                             style: robotoMedium.copyWith(
      //                                 color: Theme.of(context)
      //                                     .cardColor,
      //                                 fontSize: Dimensions
      //                                     .fontSizeDefault)),
      //                       ),
      //                     ),
      //                   ])
      //                       : const CircularProgressIndicator(),
      //                 ),
      //               ),
      //               const SizedBox(height: Dimensions.paddingSizeLarge),
      //
      //               InkWell(
      //                 onTap: () => Share.share(
      //                     '${'this_is_my_refer_code'.tr}: ${userController.userInfoModel!.refCode}'),
      //                 child: Container(
      //                   decoration: BoxDecoration(
      //                     shape: BoxShape.circle,
      //                     color: Theme.of(context).cardColor,
      //                     boxShadow: [
      //                       BoxShadow(
      //                           color: Theme.of(context)
      //                               .secondaryHeaderColor
      //                               .withOpacity(0.2),
      //                           blurRadius: 5)
      //                     ],
      //                   ),
      //                   padding: const EdgeInsets.all(7),
      //                   child: const Icon(Icons.share),
      //                 ),
      //               ),
      //               // Wrap(children: [
      //               //   InkWell(
      //               //     onTap: () => onButtonTap(ShareType.messenger, userController.userInfoModel!.refCode!),
      //               //     child: Image.asset(Images.messengerIcon, height: 40, width: 40),
      //               //   ),
      //               //   const SizedBox(width: Dimensions.paddingSizeSmall),
      //               //
      //               //   InkWell(
      //               //     onTap: () => onButtonTap(ShareType.whatsapp, userController.userInfoModel!.refCode!),
      //               //     child: Image.asset(Images.whatsappIcon, height: 40, width: 40),
      //               //   ),
      //               //   const SizedBox(width: Dimensions.paddingSizeSmall),
      //               //
      //               //   InkWell(
      //               //     onTap: () => Share.share('${'this_is_my_refer_code'.tr}: ${userController.userInfoModel!.refCode}'),
      //               //     child: Container(
      //               //       decoration: BoxDecoration(
      //               //         shape: BoxShape.circle,
      //               //         color: Theme.of(context).cardColor,
      //               //         boxShadow: [BoxShadow(color: Theme.of(context).secondaryHeaderColor.withOpacity(0.2), blurRadius: 5)],
      //               //       ),
      //               //       padding: const EdgeInsets.all(7),
      //               //       child: const Icon(Icons.share),
      //               //     ),
      //               //   )
      //               // ]),
      //
      //               ResponsiveHelper.isDesktop(context)
      //                   ? const Padding(
      //                 padding: EdgeInsets.only(
      //                     top: Dimensions.paddingSizeExtraLarge),
      //                 child: BottomSheetView(),
      //               )
      //                   : const SizedBox(),
      //             ]);
      //       }),
      //     ),
      //   )
      //       : NotLoggedInScreen(callBack: (value) {
      //     initCall();
      //     setState(() {});
      //   }),
      //   persistentContentHeight: ResponsiveHelper.isDesktop(context) ? 0 : 60,
      //   expandableContent: ResponsiveHelper.isDesktop(context) || !isLoggedIn
      //       ? const SizedBox()
      //       : const BottomSheetView(),
      // ),
    );
  }
}

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user/controller/auth_controller.dart';
import 'package:user/controller/splash_controller.dart';
import 'package:user/controller/user_controller.dart';
import 'package:user/controller/wallet_controller.dart';
import 'package:user/helper/price_converter.dart';
import 'package:user/helper/responsive_helper.dart';
import 'package:user/util/dimensions.dart';
import 'package:user/util/images.dart';
import 'package:user/util/styles.dart';
import 'package:user/view/base/not_logged_in_screen.dart';
import 'package:user/view/base/title_widget.dart';
import 'package:user/view/screens/wallet/wallet_history.dart';
import 'package:user/view/screens/wallet/wallet_topup.dart';
import 'package:user/view/screens/wallet/wallet_transfer.dart';
import 'package:user/view/screens/wallet/widget/wallet_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:user/view/widgets/custom_button.dart';
import 'package:user/view/widgets/custom_text.dart';

class WalletScreen extends StatefulWidget {
  final bool fromWallet;
  const WalletScreen({super.key, required this.fromWallet});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    initCall();
  }

  void initCall() {
    if (Get.find<AuthController>().isLoggedIn()) {
      Get.find<UserController>().getUserInfo();

      Get.find<WalletController>().getWalletTransactionList(
        '1',
        false,
        widget.fromWallet,
      );

      Get.find<WalletController>().setOffset(1);

      scrollController.addListener(() {
        if (scrollController.position.pixels ==
                scrollController.position.maxScrollExtent &&
            Get.find<WalletController>().transactionList != null &&
            !Get.find<WalletController>().isLoading) {
          int pageSize =
              (Get.find<WalletController>().popularPageSize! / 10).ceil();
          if (Get.find<WalletController>().offset < pageSize) {
            Get.find<WalletController>().setOffset(
              Get.find<WalletController>().offset + 1,
            );
            debugPrint('end of the page');
            Get.find<WalletController>().showBottomLoader();
            Get.find<WalletController>().getWalletTransactionList(
              Get.find<WalletController>().offset.toString(),
              false,
              widget.fromWallet,
            );
          }
        }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();

    scrollController.dispose();
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
          text: widget.fromWallet ? 'my_wallet'.tr : 'loyalty_points'.tr,
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
      //appBar: CustomAppBar(title: widget.fromWallet ? 'wallet'.tr : 'loyalty_points'.tr,isBackButtonExist: true),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:
          (!widget.fromWallet &&
                  isLoggedIn &&
                  !ResponsiveHelper.isDesktop(context) &&
                  Get.find<SplashController>()
                          .configModel!
                          .customerWalletStatus ==
                      1)
              ? FloatingActionButton.extended(
                backgroundColor: Theme.of(context).primaryColor,
                label: Text(
                  'convert_to_wallet_money'.tr,
                  style: robotoBold.copyWith(
                    color: Colors.white,
                    fontSize: Dimensions.fontSizeDefault,
                  ),
                ),
                onPressed: () {
                  Get.dialog(
                    Dialog(
                      backgroundColor: Colors.transparent,
                      child: WalletBottomSheet(
                        fromWallet: widget.fromWallet,
                        amount:
                            Get.find<UserController>()
                                        .userInfoModel!
                                        .loyaltyPoint ==
                                    null
                                ? '0'
                                : Get.find<UserController>()
                                    .userInfoModel!
                                    .loyaltyPoint
                                    .toString(),
                      ),
                    ),
                  );
                },
              )
              : null,
      body: Container(
        padding: EdgeInsets.all(15.w),
        height: context.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff3E2723), Color(0xff212121)],
          ),
        ),
        child: GetBuilder<UserController>(
          builder: (userController) {
            return isLoggedIn
                ? userController.userInfoModel != null
                    ? SafeArea(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          Get.find<WalletController>().getWalletTransactionList(
                            '1',
                            true,
                            widget.fromWallet,
                          );
                          Get.find<UserController>().getUserInfo();
                        },
                        child: SingleChildScrollView(
                          controller: scrollController,
                          // padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                          child: Center(
                            child: SizedBox(
                              width: Dimensions.webMaxWidth,
                              child: GetBuilder<WalletController>(
                                builder: (walletController) {
                                  return Column(
                                    children: [
                                      InkWell(
                                        onTap: (){
                                          Get.to(()=>WalletHistory());
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: Dimensions.paddingSizeLarge,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Icon(
                                                Icons.history,
                                                color:
                                                    Theme.of(
                                                      context,
                                                    ).disabledColor,
                                              ),
                                              Dimensions.kSizedBoxW5,
                                              TitleWidget(
                                                title: 'transaction_history'.tr,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      Stack(
                                        children: [
                                          Container(
                                            padding:
                                                widget.fromWallet
                                                    ? const EdgeInsets.all(
                                                      Dimensions
                                                          .paddingSizeExtraLarge,
                                                    )
                                                    : EdgeInsets.only(
                                                      top: 40.h,
                                                      left:
                                                          Dimensions
                                                              .paddingSizeOverLarge,
                                                      right:
                                                          Dimensions
                                                              .paddingSizeOverLarge,
                                                      bottom:
                                                          Dimensions
                                                              .paddingSizeOverLarge,
                                                    ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    Dimensions.radiusDefault,
                                                  ),
                                              color:
                                                  widget.fromWallet
                                                      ? Theme.of(
                                                        context,
                                                      ).cardColor
                                                      : Theme.of(context)
                                                          .hintColor
                                                          .withOpacity(0.2),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  widget.fromWallet
                                                      ? MainAxisAlignment.start
                                                      : MainAxisAlignment
                                                          .center,
                                              children: [
                                                Image.asset(
                                                  widget.fromWallet
                                                      ? Images.wallet
                                                      : Images.loyal,
                                                  height: 60,
                                                  width: 60,
                                                  color:
                                                      widget.fromWallet
                                                          ? Theme.of(
                                                            context,
                                                          ).disabledColor
                                                          : null,
                                                ),
                                                const SizedBox(
                                                  width:
                                                      Dimensions
                                                          .paddingSizeExtraLarge,
                                                ),

                                                widget.fromWallet
                                                    ? Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                          'wallet_amount'.tr,
                                                          style: robotoBlack.copyWith(
                                                            fontSize:
                                                                Dimensions
                                                                    .fontSizeExtraLarge,
                                                            color:
                                                                Theme.of(
                                                                  context,
                                                                ).disabledColor,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height:
                                                              Dimensions
                                                                  .paddingSizeSmall,
                                                        ),

                                                        Text(
                                                          PriceConverter.convertPrice(
                                                            userController
                                                                .userInfoModel!
                                                                .walletBalance,
                                                          ),
                                                          textDirection:
                                                              TextDirection.ltr,
                                                          style: robotoMedium.copyWith(
                                                            fontSize:
                                                                Dimensions
                                                                    .fontSizeLarge,
                                                            color:
                                                                Theme.of(
                                                                  context,
                                                                ).disabledColor,
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                    : Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          '${'loyalty_points'.tr} !',
                                                          style: robotoRegular.copyWith(
                                                            fontSize:
                                                                Dimensions
                                                                    .fontSizeSmall,
                                                            color:
                                                                Theme.of(
                                                                      context,
                                                                    )
                                                                    .textTheme
                                                                    .bodyLarge!
                                                                    .color,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height:
                                                              Dimensions
                                                                  .paddingSizeSmall,
                                                        ),

                                                        Text(
                                                          userController
                                                                      .userInfoModel!
                                                                      .loyaltyPoint ==
                                                                  null
                                                              ? '0'
                                                              : userController
                                                                  .userInfoModel!
                                                                  .loyaltyPoint
                                                                  .toString(),
                                                          style: robotoBold.copyWith(
                                                            fontSize:
                                                                Dimensions
                                                                    .fontSizeOverLarge,
                                                            color:
                                                                Theme.of(
                                                                      context,
                                                                    )
                                                                    .textTheme
                                                                    .bodyLarge!
                                                                    .color,
                                                          ),
                                                          textDirection:
                                                              TextDirection.ltr,
                                                        ),
                                                      ],
                                                    ),
                                              ],
                                            ),
                                          ),

                                          (ResponsiveHelper.isDesktop(
                                                    context,
                                                  ) &&
                                                  !widget.fromWallet &&
                                                  Get.find<SplashController>()
                                                          .configModel!
                                                          .customerWalletStatus ==
                                                      1)
                                              ? Positioned(
                                                top: 30,
                                                right: 20,
                                                child: InkWell(
                                                  onTap: () {
                                                    Get.dialog(
                                                      Dialog(
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        child: WalletBottomSheet(
                                                          fromWallet:
                                                              widget.fromWallet,
                                                          amount:
                                                              Get.find<
                                                                            UserController
                                                                          >()
                                                                          .userInfoModel!
                                                                          .loyaltyPoint ==
                                                                      null
                                                                  ? '0'
                                                                  : Get.find<
                                                                        UserController
                                                                      >()
                                                                      .userInfoModel!
                                                                      .loyaltyPoint
                                                                      .toString(),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color:
                                                          Theme.of(
                                                            context,
                                                          ).primaryColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            Dimensions
                                                                .radiusDefault,
                                                          ),
                                                    ),
                                                    padding: const EdgeInsets.symmetric(
                                                      horizontal:
                                                          Dimensions
                                                              .paddingSizeLarge,
                                                      vertical:
                                                          Dimensions
                                                              .paddingSizeSmall,
                                                    ),
                                                    child: Text(
                                                      'convert_to_wallet_money'
                                                          .tr,
                                                      style: robotoMedium.copyWith(
                                                        color:
                                                            Theme.of(
                                                              context,
                                                            ).cardColor,
                                                        fontSize:
                                                            Dimensions
                                                                .fontSizeSmall,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                              : const SizedBox(),

                                          // widget.fromWallet ? const SizedBox.shrink() : Positioned(
                                          //   top: 10,right: 10,
                                          //   child: InkWell(
                                          //     onTap: (){
                                          //       ResponsiveHelper.isMobile(context) ? Get.bottomSheet(
                                          //           WalletBottomSheet(fromWallet: widget.fromWallet)
                                          //       ) : Get.dialog(
                                          //         Dialog(child: WalletBottomSheet(fromWallet: widget.fromWallet)),
                                          //       );
                                          //     },
                                          //     child: Row(
                                          //       children: [
                                          //         Text(
                                          //           'convert_to_currency'.tr , style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall,
                                          //             color: widget.fromWallet ? Theme.of(context).cardColor : Theme.of(context).textTheme.bodyLarge!.color),
                                          //         ),
                                          //         Icon(Icons.keyboard_arrow_down_outlined,size: 16, color: widget.fromWallet ? Theme.of(context).cardColor
                                          //             : Theme.of(context).textTheme.bodyLarge!.color)
                                          //       ],
                                          //     ),
                                          //   ),
                                          // )
                                        ],
                                      ),
                                      Dimensions.kSizedBoxH30,
                                      Dimensions.kSizedBoxH30,
                                      Column(
                                        children: [
                                          CustomTTButton(

                                            isRounded: true,
                                            bgColor:
                                                Theme.of(context).primaryColor,
                                            text: 'topup_wallet'.tr,
                                            onTap: () {
                                              Get.to(()=>WalletTopupScreen());
                                            },
                                          ),
                                          Dimensions.kSizedBoxH20,
                                          CustomTTButton(
                                            isRounded: true,
                                            bgColor:
                                                Theme.of(context).primaryColor,
                                            text: 'transfer_wallet'.tr,
                                            onTap: () {
                                              Get.to(()=>WalletTransfer());
                                            },
                                          ),
                                        ],
                                      ),


                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                    : const Center(child: CircularProgressIndicator())
                : NotLoggedInScreen(
                  callBack: (value) {
                    initCall();
                    setState(() {});
                  },
                );
          },
        ),
      ),
    );
  }
}



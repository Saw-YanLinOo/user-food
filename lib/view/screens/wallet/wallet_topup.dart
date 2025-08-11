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
import 'package:user/view/screens/wallet/wallet_topup_confirm.dart';
import 'package:user/view/screens/wallet/widget/wallet_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:user/view/widgets/custom_button.dart';
import 'package:user/view/widgets/custom_text.dart';
import 'package:user/view/widgets/custom_text_form_field.dart';

class WalletTopupScreen extends StatefulWidget {

  const WalletTopupScreen({super.key, });

  @override
  State<WalletTopupScreen> createState() => _WalletTopupScreenState();
}

class _WalletTopupScreenState extends State<WalletTopupScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    initCall();
  }

  void initCall() {
    if (Get.find<AuthController>().isLoggedIn()) {
      Get.find<UserController>().getUserInfo();



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
          text: 'my_wallet'.tr,
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
                              Padding(
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

                              Stack(
                                children: [
                                  Container(
                                    padding:
                                   EdgeInsets.only(
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
                                     Theme.of(
                                        context,
                                      ).cardColor

                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,

                                      children: [
                                        Image.asset(
                                         Images.wallet
                                             ,
                                          height: 60,
                                          width: 60,
                                          color:
                                        Theme.of(
                                            context,
                                          ).disabledColor
                                            ,
                                        ),
                                        const SizedBox(
                                          width:
                                          Dimensions
                                              .paddingSizeExtraLarge,
                                        ),

                                     Column(
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
                                        //     : Column(
                                        //   crossAxisAlignment:
                                        //   CrossAxisAlignment
                                        //       .start,
                                        //   mainAxisAlignment:
                                        //   MainAxisAlignment.end,
                                        //   children: [
                                        //     Text(
                                        //       '${'loyalty_points'.tr} !',
                                        //       style: robotoRegular.copyWith(
                                        //         fontSize:
                                        //         Dimensions
                                        //             .fontSizeSmall,
                                        //         color:
                                        //         Theme.of(
                                        //           context,
                                        //         )
                                        //             .textTheme
                                        //             .bodyLarge!
                                        //             .color,
                                        //       ),
                                        //     ),
                                        //     const SizedBox(
                                        //       height:
                                        //       Dimensions
                                        //           .paddingSizeSmall,
                                        //     ),
                                        //
                                        //     Text(
                                        //       userController
                                        //           .userInfoModel!
                                        //           .loyaltyPoint ==
                                        //           null
                                        //           ? '0'
                                        //           : userController
                                        //           .userInfoModel!
                                        //           .loyaltyPoint
                                        //           .toString(),
                                        //       style: robotoBold.copyWith(
                                        //         fontSize:
                                        //         Dimensions
                                        //             .fontSizeOverLarge,
                                        //         color:
                                        //         Theme.of(
                                        //           context,
                                        //         )
                                        //             .textTheme
                                        //             .bodyLarge!
                                        //             .color,
                                        //       ),
                                        //       textDirection:
                                        //       TextDirection.ltr,
                                        //     ),
                                        //   ],
                                        // ),
                                      ],
                                    ),
                                  ),



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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(text: "topup_info".tr,color: Theme.of(context).disabledColor,),
                                  Dimensions.kSizedBoxH10,

                                    CustomTextFormField(
                                      keyBoardType: TextInputType.number,
                                      onChange: (a){
                                        walletController.amountController.text=a;
                                        if(a.isNotEmpty){
                                          walletController.isTextEmpty.value=false;
                                        }
                                        else{
                                          walletController.isTextEmpty.value=true;
                                        }

                                      },
                                      textColor: Theme.of(context).disabledColor,
                                      controller: walletController.amountController,
                                      fillColor: Colors.transparent,
                                        radius: Dimensions.radiusDefault,
                                        hintText: '', isValidate: false),

                                  Dimensions.kSizedBoxH30,
                                  Dimensions.kSizedBoxH30,

                                  Obx(()=>
                                   CustomTTButton(
                                      outlineColor: Colors.transparent,

                                      isRounded: true,
                                      bgColor:walletController.isTextEmpty.value? Theme.of(context).unselectedWidgetColor:
                                      Theme.of(context).primaryColor,
                                      text: 'Continue'.tr,
                                      onTap: () {
                                        if(walletController.amountController.text.isNotEmpty){
                                          Get.to(()=>WalletTopUpConfirm(amount: walletController.amountController.text,));
                                        }

                                      },
                                    ),
                                  ),
                                ],
                              ),

                              // Column(children: [
                              //   Padding(
                              //     padding: const EdgeInsets.only(top: Dimensions.paddingSizeOverLarge),
                              //     child: TitleWidget(title: 'transaction_history'.tr),
                              //   ),
                              //   walletController.transactionList != null ? walletController.transactionList!.isNotEmpty ? GridView.builder(
                              //     key: UniqueKey(),
                              //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              //       crossAxisSpacing: 50,
                              //       mainAxisSpacing: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeLarge : 0.01,
                              //       childAspectRatio: ResponsiveHelper.isDesktop(context) ? 5 : 4.45,
                              //       crossAxisCount: ResponsiveHelper.isMobile(context) ? 1 : 2,
                              //     ),
                              //     physics:  const NeverScrollableScrollPhysics(),
                              //     shrinkWrap:  true,
                              //     itemCount: walletController.transactionList!.length ,
                              //     padding: EdgeInsets.only(top: ResponsiveHelper.isDesktop(context) ? 28 : 25),
                              //     itemBuilder: (context, index) {
                              //       return HistoryItem(index: index,fromWallet: widget.fromWallet, data: walletController.transactionList );
                              //     },
                              //   ) : NoDataScreen(text: 'no_data_found'.tr) : WalletShimmer(walletController: walletController),
                              //
                              //   walletController.isLoading ? const Center(child: Padding(
                              //     padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                              //     child: CircularProgressIndicator(),
                              //   )) : const SizedBox(),
                              // ])
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

class WalletShimmer extends StatelessWidget {
  final WalletController walletController;
  const WalletShimmer({super.key, required this.walletController});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      key: UniqueKey(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 50,
        mainAxisSpacing:
        ResponsiveHelper.isDesktop(context)
            ? Dimensions.paddingSizeLarge
            : 0.01,
        childAspectRatio: ResponsiveHelper.isDesktop(context) ? 5 : 4.3,
        crossAxisCount: ResponsiveHelper.isMobile(context) ? 1 : 2,
      ),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 10,
      padding: EdgeInsets.only(
        top: ResponsiveHelper.isDesktop(context) ? 28 : 25,
      ),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: Dimensions.paddingSizeSmall,
          ),
          child: Shimmer(
            duration: const Duration(seconds: 2),
            enabled: walletController.transactionList == null,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 10,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 10,
                          width: 70,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          height: 10,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 10,
                          width: 70,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: Dimensions.paddingSizeDefault,
                  ),
                  child: Divider(color: Theme.of(context).disabledColor),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

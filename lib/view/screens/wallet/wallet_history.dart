import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:user/view/screens/wallet/widget/history_item.dart';

import '../../../controller/wallet_controller.dart';
import '../../../helper/responsive_helper.dart';
import '../../../util/dimensions.dart';
import '../../base/no_data_screen.dart';
import '../../base/title_widget.dart';
import '../../widgets/custom_text.dart';

class WalletHistory extends StatelessWidget {
  const WalletHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,

      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 60.h,
          backgroundColor: Color(0xff6c5d5a),
          centerTitle: true,
          title: CustomText(
            text: 'wallet_history'.tr,
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
        body:
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xff3E2723), Color(0xff212121)],
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 8.w),
                child: TabBar(

                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorColor: Theme.of(context).primaryColor,
                  indicatorAnimation: TabIndicatorAnimation.elastic,
                  labelColor: Theme.of(context).disabledColor,
                  unselectedLabelColor: Theme.of(context).disabledColor,
                  dividerColor: Theme.of(context).disabledColor,
                  // indicator: BoxDecoration(
                  //     color: Theme.of(context).cardColor,
                  //     border: Border(bottom: BorderSide(color: Theme.of(context).primaryColor))
                  // ),

                  tabs: [
                    Tab(
                      icon: CustomText(text: ""),
                        height: 50.h,
                        text: 'received'.tr), // Deposit Tab
                    Tab(
                        icon: CustomText(text: ""),
                        height: 50.h,
                        text: 'transferred'.tr), // Withdraw Tab
                    //Tab(text: 'prize'.tr), // Withdraw Tab
                  ],
                ),
              ),
              Expanded(
                child: GetBuilder<WalletController>(
                  builder: (walletController) {
                return TabBarView(
                  children: [
                    Padding(
                      padding:  EdgeInsets.all(15.w),
                      child: Column(children: [

                        walletController.transactionList!=null ? walletController.transactionList!.isNotEmpty ? GridView.builder(
                          key: UniqueKey(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 50,
                            mainAxisSpacing: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeLarge : 0.01,
                            childAspectRatio: ResponsiveHelper.isDesktop(context) ? 5 : 3.5,
                            crossAxisCount: ResponsiveHelper.isMobile(context) ? 1 : 2,
                          ),
                          physics:  const NeverScrollableScrollPhysics(),
                          shrinkWrap:  true,
                          itemCount: walletController.transactionList!.length,
                         // padding: EdgeInsets.only(top: ResponsiveHelper.isDesktop(context) ? 28 : 25),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:  EdgeInsets.only(bottom:10.h),
                              child: Container(
                                padding: EdgeInsets.all(15.w),

                                decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(15.r)
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(text: "123456 ${'currency'.tr} ${'received'.tr}",color: Theme.of(context).disabledColor,fontWeight: FontWeight.bold,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomText(text: 'from'.tr,color: Theme.of(context).disabledColor,),
                                        CustomText(text: "phone",color: Theme.of(context).disabledColor,),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomText(text: 'date'.tr,color: Theme.of(context).disabledColor,),
                                        CustomText(text: DateTime.now().toIso8601String(),color: Theme.of(context).disabledColor,),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ) : Center(child: NoDataScreen(text: 'no_data_found'.tr)) : WalletShimmer(walletController: walletController),

                        walletController.isLoading ? const Center(child: Padding(
                          padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                          child: CircularProgressIndicator(),
                        )) : const SizedBox(),
                      ]),
                    ),
                    Padding(
                      padding:  EdgeInsets.all(15.w),
                      child: Column(children: [

                        walletController.transactionList!=null ? walletController.transactionList!.isNotEmpty ? GridView.builder(
                          key: UniqueKey(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 50,
                            mainAxisSpacing: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeLarge : 0.01,
                            childAspectRatio: ResponsiveHelper.isDesktop(context) ? 5 : 3.5,
                            crossAxisCount: ResponsiveHelper.isMobile(context) ? 1 : 2,
                          ),
                          physics:  const NeverScrollableScrollPhysics(),
                          shrinkWrap:  true,
                          itemCount: walletController.transactionList!.length,
                          // padding: EdgeInsets.only(top: ResponsiveHelper.isDesktop(context) ? 28 : 25),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:  EdgeInsets.only(bottom:10.h),
                              child: Container(
                                padding: EdgeInsets.all(15.w),

                                decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(15.r)
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(text: "123456 ${'currency'.tr} ${'transferred'.tr}",color: Theme.of(context).disabledColor,fontWeight: FontWeight.bold,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomText(text: 'to'.tr,color: Theme.of(context).disabledColor,),
                                        CustomText(text: "phone",color: Theme.of(context).disabledColor,),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomText(text: 'date'.tr,color: Theme.of(context).disabledColor,),
                                        CustomText(text: DateTime.now().toIso8601String(),color: Theme.of(context).disabledColor,),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ) : Center(child: NoDataScreen(text: 'no_data_found'.tr)) : WalletShimmer(walletController: walletController),

                        walletController.isLoading ? const Center(child: Padding(
                          padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                          child: CircularProgressIndicator(),
                        )) : const SizedBox(),
                      ]),
                    ),
                  ],
                );}),
              ),
            ],
          ),
        )
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
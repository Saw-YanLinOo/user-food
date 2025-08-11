import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user/controller/auth_controller.dart';
import 'package:user/controller/notification_controller.dart';
import 'package:user/controller/splash_controller.dart';
import 'package:user/helper/date_converter.dart';
import 'package:user/helper/route_helper.dart';
import 'package:user/util/dimensions.dart';
import 'package:user/util/images.dart';
import 'package:user/util/styles.dart';
import 'package:user/view/base/custom_image.dart';
import 'package:user/view/base/no_data_screen.dart';
import 'package:user/view/base/not_logged_in_screen.dart';
import 'package:user/view/screens/notification/widget/notification_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../widgets/custom_text.dart';
import 'package:user/data/model/response/notification_model.dart';
import 'package:user/view/screens/notification/notification_detail_screen.dart';

import 'order_feedback_detail_screen.dart';

class NotificationScreen extends StatefulWidget {
  final bool fromNotification;
  const NotificationScreen({super.key, this.fromNotification = false});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  void _loadData() async {
    Get.find<NotificationController>().clearNotification();
    if(Get.find<SplashController>().configModel == null) {
      await Get.find<SplashController>().getConfigData();
    }
    if(Get.find<AuthController>().isLoggedIn()) {
      Get.find<NotificationController>().getNotificationList(true);
    }
  }
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {


    return WillPopScope(
      onWillPop: () async {
        if(widget.fromNotification) {
          Get.offAllNamed(RouteHelper.getInitialRoute());
          return true;
        }else {
          Get.back();
          return true;
        }
      },
      child: Scaffold(
        //extendBodyBehindAppBar: true,
        //extendBody: true,

        appBar: AppBar(
          toolbarHeight: 60.h,
          backgroundColor: Color(0xff6c5d5a),
          centerTitle: true,
          title: CustomText(text:'notification'.tr,color: Colors.white,fontWeight: FontWeight.bold,fontSize: 14.sp),
          leading: Padding(
            padding:  EdgeInsets.all(10.w),
            child: InkWell(
              onTap:(){
                if(widget.fromNotification) {
                  Get.offAllNamed(RouteHelper.getInitialRoute());
                }else {
                  Get.back();
                }
              },
              child: Container(
                padding: EdgeInsets.only(left: 3.w),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white30
                ),
                child: Center(child: Icon(Icons.arrow_back_ios,color: Colors.white,size: 15.w,)),
              ),
            ),
          ),
        ),
        // appBar: CustomAppBar(title: 'notification'.tr, onBackPressed: () {
        //   if(widget.fromNotification) {
        //     Get.offAllNamed(RouteHelper.getInitialRoute());
        //   }else {
        //     Get.back();
        //   }
        // }),
        body: Get.find<AuthController>().isLoggedIn() ? 
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff3E2723),Color(0xff212121)])
          ),
          child: GetBuilder<NotificationController>(builder: (notificationController) {
            // SAMPLE DATA FOR UI TESTING (remove/comment out in production)
            final now = DateTime.now();
            final bool useSample = notificationController.notificationList == null || notificationController.notificationList!.isEmpty;
            final sampleList = [
              // NotificationModel(
              //   id: 1,
              //   createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').format(now.subtract(Duration(minutes: 5))),
              //   data: Data(
              //     title: 'MOMO Food မှ အသစ်ကြော်ငြာပါ!',
              //     description: 'သင့်အတွက်အထူးပရိုမိုးရှင်းအသစ်ရှိပါသည်။',
              //     image: '',
              //   ),
              // ),
              // NotificationModel(
              //   id: 2,
              //   createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').format(now.subtract(Duration(hours: 1))),
              //   data: Data(
              //     title: 'အသိပေးချက်',
              //     description: 'မနက် ၉ နာရီတွင် စတိုးဖွင့်ပါမည်။',
              //     image: '',
              //   ),
              // ),
              // NotificationModel(
              //   id: 3,
              //   createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').format(now.subtract(Duration(days: 1))),
              //   data: Data(
              //     title: 'MOMO Food မှ အော်ဒါ ၃ ကြိမ်မှာယူပါ',
              //     description: 'MOMO Food မှ အော်ဒါ ၃ ကြိမ်မှာယူပြီး လျှော့စျေးကူပွန်များရယူလိုက်ပါ။',
              //     image: '',
              //   ),
              // ),
              // NotificationModel(
              //   id: 4,
              //   createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').format(now.subtract(Duration(minutes: 10))),
              //   data: Data(
              //     title: 'သင့်အော်ဒါအတွက် Feedbackပေးပြီး Point များရယူပါ!',
              //     description: 'အော်ဒါအတွက်တုံ့ပြန်ချက်ပေးပြီး Point များရယူလိုက်ပါ။',
              //     image: 'https://images.pexels.com/photos/461382/pexels-photo-461382.jpeg?auto=compress&w=80',
              //   ),
              // ),
            ];
            final notiList = useSample ? sampleList : notificationController.notificationList!;
            if(notificationController.notificationList != null) {
              notificationController.saveSeenNotificationCount(notiList.length);
            }
            List<DateTime> dateTimeList = [];
            return notiList.isNotEmpty ? RefreshIndicator(
              onRefresh: () async {
                await notificationController.getNotificationList(true);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  // Clear All Messages Button
                 if (notiList.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.yellow[700],
                            side: BorderSide(color: Colors.yellow[700]!, width: 1.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => CustomClearAllDialog(
                                onConfirm: () {
                                  notificationController.clearNotification();
                                  Navigator.pop(context);
                                },
                              ),
                            );
                          },
                          child: Text(
                            'delete_all_msg'.tr,
                            style: TextStyle(
                              color: Colors.yellow[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),

                  Expanded(
                    child: ListView.builder(
                      itemCount: notiList.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        DateTime originalDateTime = DateConverter.dateTimeStringToDate(notiList[index].createdAt!);
                        DateTime convertedDate = DateTime(originalDateTime.year, originalDateTime.month, originalDateTime.day);
                        bool addTitle = false;
                        if(!dateTimeList.contains(convertedDate)) {
                          addTitle = true;
                          dateTimeList.add(convertedDate);
                        }
                        bool isSeen = notificationController.getSeenNotificationIdList()!.contains(notiList[index].id);
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            addTitle ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall, horizontal: Dimensions.paddingSizeSmall),
                              child: Text(
                                DateConverter.dateTimeStringToDateOnly(notiList[index].createdAt!),
                                style: robotoMedium.copyWith(color: Colors.white70),
                              ),
                            ) : const SizedBox(),
                            GestureDetector(
                              onTap: () {
                                notificationController.addSeenNotificationId(notiList[index].id!);
                                final title = notiList[index].data?.title ?? '';
                                if (title.contains('Feedback') || title.contains('အော်ဒါ')) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => OrderFeedbackDetailScreen(),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => NotificationDetailScreen(notification: notiList[index]),
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                                decoration: BoxDecoration(
                                  color: isSeen ? Colors.grey.withOpacity(0.5) : Colors.yellow[100],
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isSeen ? Colors.transparent : Colors.yellow[700]!,
                                    width: isSeen ? 0 : 1.5,
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor:isSeen? Colors.grey.withOpacity(0.5) :Colors.grey.withOpacity(0.8),
                                      radius: 22,
                                      child: Image.asset(Images.splashLogo, width: 28, height: 28),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  notiList[index].data!.title ?? '',
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontWeight: isSeen ? FontWeight.normal : FontWeight.bold,
                                                    color: isSeen ? Colors.white70 : Colors.black87,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),

                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            notiList[index].data!.description ?? '',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: isSeen ? Colors.white54 : Colors.black87,
                                              fontSize: 13,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Text(
                                                DateConverter.dateTimeStringToTime(notiList[index].createdAt!),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: isSeen ? Colors.white38 : Colors.black54,
                                                ),
                                              ),
                                              Dimensions.kSizedBoxW5,
                                              Text(
                                                DateConverter.dateTimeStringToDateOnly(notiList[index].createdAt!),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: isSeen ? Colors.white38 : Colors.black54,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ) : NoDataScreen(text: 'no_notification_found'.tr,fromNoti: true,); //: const Center(child: CircularProgressIndicator());
          }),
        ) : NotLoggedInScreen(callBack: (value){
          _loadData();
          setState(() {});
        }),
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
                Text(
                  'notice_title'.tr,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'notice_body'.tr,
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFE53935), width: 1.5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child:  Text('cancel_delete'.tr
                            , style: TextStyle(color: Color(0xFFE53935), fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onConfirm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE53935),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                        ),
                        child:  Text('confirm_delete'.tr
                            , style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: -90.h,
            child: Center(
              child: Image.asset(
                'assets/image/warning_1.png',
                width: 170.w,
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

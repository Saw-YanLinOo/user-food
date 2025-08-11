import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:user/data/model/response/notification_model.dart';
import 'package:user/helper/date_converter.dart';

class NotificationDetailScreen extends StatelessWidget {
  final NotificationModel notification;
  const NotificationDetailScreen({Key? key, required this.notification}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final date = DateConverter.dateTimeStringToDateOnly(notification.createdAt!);
    final time = DateConverter.dateTimeStringToTime(notification.createdAt!);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Color(0xff6c5d5a),
        elevation: 0,
        toolbarHeight: 60.h,
        leading: Padding(
          padding:  EdgeInsets.all(10.w),
          child: InkWell(
            onTap:(){

                Get.back();

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
        centerTitle: true,
        title: Text(
          notification.data?.title ?? '',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14.sp,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff3E2723), Color(0xff212121)],
          ),
        ),
        child: Padding(
          padding:  EdgeInsets.only(top: 120.h, left: 20.w, right: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notification.data?.title ?? '',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    time,
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 13,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    date,
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                notification.data?.description ?? '',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:user/theme/dark_theme.dart';
import 'package:user/theme/light_theme.dart';
import 'package:user/util/dimensions.dart';
import 'package:user/util/images.dart';
import 'package:user/view/base/custom_text_field.dart';
import 'package:user/view/widgets/custom_text.dart';

import '../../widgets/custom_text_form_field.dart';

class OrderFeedbackDetailScreen extends StatefulWidget {
  const OrderFeedbackDetailScreen({Key? key}) : super(key: key);

  @override
  State<OrderFeedbackDetailScreen> createState() => _OrderFeedbackDetailScreenState();
}

class _OrderFeedbackDetailScreenState extends State<OrderFeedbackDetailScreen> {
  int _rating = 0;
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Color(0xff6c5d5a),
        elevation: 0,
        toolbarHeight: 60.h,
        leading: Padding(
          padding: EdgeInsets.all(10.w),
          child: InkWell(
            onTap: () => Get.back(),
            child: Container(
              padding: EdgeInsets.only(left: 3.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white30,
              ),
              child: Center(child: Icon(Icons.arrow_back_ios, color: Colors.white, size: 15.w)),
            ),
          ),
        ),
        centerTitle: true,
        title: Text('notification'.tr, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff312723), Color(0xff212121)],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: 110.h, left: 20.w, right: 20.w, bottom: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order summary
                Row(
                  children: [
                    Image.asset(Images.orderLogo,color: Colors.white,width: 20.w,),
                    CustomText(text: 'order_details'.tr,color: Colors.white,fontWeight: FontWeight.bold,),
                  ],
                ),
                Dimensions.kSizedBoxH15,
                CustomText(text: 'order_items'.tr,color: Colors.white,),
                Dimensions.kSizedBoxH10,
                Container(
                 // padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: Image.network(
                          'https://images.pexels.com/photos/461382/pexels-photo-461382.jpeg?auto=compress&w=80',
                          width: 60.w,
                          height: 60.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Noodle Soup', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                                    Dimensions.kSizedBoxH5,
                                    Row(
                                      children: [
                                        Icon(Icons.star, color: Colors.amber, size: 16),
                                        SizedBox(width: 2),
                                        Text('4.0', style: TextStyle(color: Colors.white, fontSize: 13)),
                                        SizedBox(width: 8),
                                        Text('8,000 MMK', style: TextStyle(color: Colors.white, fontSize: 13)),
                                      ],
                                    ),
                                  ],
                                ),

                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                                  margin: EdgeInsets.symmetric(horizontal: 8.w,),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white),

                                  ),
                                  child: Text('2', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                                ),
                              ],
                            ),


                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 18),
                // Order info
                //Text('အော်ဒါအချက်အလက်', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('order_number'.tr, style: TextStyle(color: Colors.white70, fontSize: 13)),
                        Text('#1849833', style: TextStyle(color: Colors.white70, fontSize: 13)),
                      ],
                    ),
                    Dimensions.kSizedBoxH10,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('order_time'.tr, style: TextStyle(color: Colors.white70, fontSize: 13)),
                        Text('12/07/2025 1:49 PM', style: TextStyle(color: Colors.white70, fontSize: 13)),
                      ],
                    ),
                    Dimensions.kSizedBoxH10,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.circle, size: 8, color: Colors.white54),
                            SizedBox(width: 4),
                            Text('door_to_door'.tr, style: TextStyle(color: Colors.white70, fontSize: 13)),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.circle, size: 8, color: Colors.white54),
                            SizedBox(width: 4),
                            Text('cod_service'.tr, style: TextStyle(color: Colors.white70, fontSize: 13)),
                          ],
                        ),
                      ],
                    ),
                    Dimensions.kSizedBoxH15,
                    DottedLine(
                      dashColor: Colors.white30,
                    ),
                    Dimensions.kSizedBoxH15,
                    Padding(
                      padding:  EdgeInsets.only(left: 18.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('restaurant'.tr, style: TextStyle(color: Colors.white54, fontSize: 13)),
                          Text('ဆာဟာရ စားသောက်ဆိုင်', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          Dimensions.kSizedBoxH10,
                          Text('deliver_address'.tr, style: TextStyle(color: Colors.white54, fontSize: 13)),
                          Text('အမှတ်(၁၂)၊ ရန်ကုန်မြို့', style: TextStyle(color: Colors.white54, )),
                        ],
                      ),
                    ),
                    Dimensions.kSizedBoxH15,
                    DottedLine(
                      dashColor: Colors.white30,
                    ),
                    Dimensions.kSizedBoxH15,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('items_prices'.tr, style: TextStyle(color: Colors.white70)),
                        Text('25,500 MMK', style: TextStyle(color: Colors.white)),
                      ],
                    ),
Dimensions.kSizedBoxH5,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('discount'.tr, style: TextStyle(color: Colors.white70)),
                        Text('0 MMK', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    Dimensions.kSizedBoxH5,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('tax'.tr, style: TextStyle(color: Colors.white70)),
                        Text('0 MMK', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    Dimensions.kSizedBoxH5,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('delivery_fee'.tr
                            , style: TextStyle(color: Colors.white70)),
                        Text('500 MMK', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    Dimensions.kSizedBoxH15,
                    DottedLine(
                      dashColor: Colors.white30,
                    ),
                    Dimensions.kSizedBoxH15,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('total'.tr, style: TextStyle(color: Colors.white70, )),
                        Text('26,000 MMK', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),

                // Emoji above the stars
              if(_rating>0)  Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: _rating > 0
                        ? Image.asset(
                            'assets/image/emoji_${_rating}.png',
                            width: 90.w,
                            height: 90.w,
                          )
                        : SizedBox(height: 90.w),
                  ),
                ),
                // Star rating
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) => IconButton(
                      icon: Icon(
                        index < _rating ? Icons.star : Icons.star_border,
                        color:index < _rating ? Colors.amber :Colors.grey,
                        size: 32,
                      ),
                      onPressed: () {
                        setState(() {
                          _rating = index + 1;
                        });
                      },
                    )),
                  ),
                ),
                SizedBox(height: 8),
                Center(child: Text('set_rating'.tr, style: TextStyle(color: Colors.white70))),
               Dimensions.kSizedBoxH20,
                // Feedback input
                Align(
                    alignment: Alignment.topRight,
                    child: CustomText(text: 'optional'.tr,color: Colors.white30,)),
                Dimensions.kSizedBoxH3,
                CustomTextFormField(
                  isValidate:false,
                  maxlines: 5,
                  radius: 10.r,
                  isFill: true,
                  fillColor: Colors.transparent,
                  borderColor: Colors.white24,

                  hintText: 'momo_app_feedback_hint'.tr,


                ),

                Dimensions.kSizedBoxH25,
                // Submit button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle submit
                      Get.snackbar('Feedback', 'Thanks for your feedback!', backgroundColor: Colors.green, colorText: Colors.white);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Get.isDarkMode?dark.primaryColor:light.primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text('feedback'.tr, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
                SizedBox(height: 24),
                // Floating action button (bottom right)
               
              ],
            ),
          ),
        ),
      ),
    );
  }
} 
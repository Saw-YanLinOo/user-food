import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../theme/dark_theme.dart';
import '../../../theme/light_theme.dart';
import '../../../util/dimensions.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/custom_text_form_field.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  int _rating = 0;
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: CustomText(text: 'feedback'.tr, color: Theme.of(context).disabledColor, fontWeight: FontWeight.bold,fontSize: 14.sp,),
      ),
      body: Container(
        padding: EdgeInsets.all(10.w),
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff312723), Color(0xff212121)],
          ),
        ),
        child: Column(
          children: [
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
                  if(_rating<=0) {
                   // Get.snackbar('Warning', 'Thanks for your feedback!', backgroundColor: Colors.green, colorText: Colors.white);
                  }else{
                    Get.snackbar('Feedback', 'Thanks for your feedback!', backgroundColor: Colors.green, colorText: Colors.white);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:_rating<=0?dark.disabledColor:light.primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text('feedback'.tr, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

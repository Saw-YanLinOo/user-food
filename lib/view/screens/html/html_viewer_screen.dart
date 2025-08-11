import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user/controller/splash_controller.dart';
import 'package:user/util/dimensions.dart';
import 'package:user/util/html_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../util/images.dart';

class HtmlViewerScreen extends StatefulWidget {
  final HtmlType htmlType;
  const HtmlViewerScreen({super.key, required this.htmlType});

  @override
  State<HtmlViewerScreen> createState() => _HtmlViewerScreenState();
}

class _HtmlViewerScreenState extends State<HtmlViewerScreen> {

  @override
  void initState() {
    super.initState();

    Get.find<SplashController>().getHtmlText(widget.htmlType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      //backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background image and gradient
          Positioned.fill(
            child: Image.asset(
              Images.termsImg,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.4),
                  ],
                ),
              ),
            ),
          ),
          // Main content with SliverAppBar
          GetBuilder<SplashController>(builder: (splashController) {
            return CustomScrollView(
              slivers: [

                  SliverAppBar(
                    leading: Padding(
                       padding:  EdgeInsets.all(10.w),
                       child: InkWell(
                         onTap:(){
                           Navigator.pop(context);
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
                    pinned: true,
                    backgroundColor: Colors.transparent,
                    expandedHeight: 140,
                    automaticallyImplyLeading: false,
                    flexibleSpace: LayoutBuilder(
                      builder: (context, constraints) {
                        final double collapsePercent = (constraints.maxHeight - kToolbarHeight) / (140 - kToolbarHeight);
                        final bool isCollapsed = collapsePercent < 0.5;
                        return Stack(
                          children: [
                            if (isCollapsed)
                              Positioned.fill(
                                child: Container(
                                  color: Colors.grey,
                                ),
                              ),
                            FlexibleSpaceBar(

                              titlePadding: EdgeInsets.only(left: 56.w, bottom: 10.h, right: 20.w),
                              title: isCollapsed
                                  ? Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.end,

                                      children: [
                                        Image.asset(Images.splashLogo, width: 30.w),
                                      ],
                                    )
                                  : null,
                              background: !isCollapsed
                                  ? Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.end,

                                      children: [
                                        SizedBox(height: kToolbarHeight + 10.h),
                                        Center(child: Image.asset(Images.splashLogo, width: 70)),
                                      ],
                                    )
                                  : null,
                            ),
                          ],
                        );
                      },

                  ),
                ),
                SliverToBoxAdapter(
                  child: splashController.htmlText != null
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.paddingSizeLarge, vertical: 24),
                          child: HtmlWidget(
                            splashController.htmlText ?? '',
                            textStyle: TextStyle(color: Colors.white),
                            key: Key(widget.htmlType.toString()),
                            onTapUrl: (String url) {
                              return launchUrlString(url,
                                  mode: LaunchMode.externalApplication);
                            },
                          ),
                        )
                      : const Center(child: CircularProgressIndicator()),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

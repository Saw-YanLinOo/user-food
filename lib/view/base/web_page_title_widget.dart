import 'package:user/helper/responsive_helper.dart';
import 'package:user/util/styles.dart';
import 'package:flutter/material.dart';

class WebScreenTitleWidget extends StatelessWidget {
  final String title;
  const WebScreenTitleWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return ResponsiveHelper.isDesktop(context)
        ? Container(
            height: 64,
            color: Theme.of(context).secondaryHeaderColor,
            child: Center(child: Text(title, style: robotoMedium)),
          )
        : const SizedBox();
  }
}

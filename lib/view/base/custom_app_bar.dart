import 'dart:developer';

import 'package:user/helper/responsive_helper.dart';
import 'package:user/util/dimensions.dart';
import 'package:user/view/base/veg_filter_widget.dart';
import 'package:user/view/base/web_menu_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../helper/route_helper.dart';
import '../../util/styles.dart';
import 'cart_widget.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isBackButtonExist;
  final Function? onBackPressed;
  final bool showCart;
  final Color? bgColor;
  final Function(String value)? onVegFilterTap;
  final String? type;
  const CustomAppBar(
      {super.key,
      required this.title,
      this.isBackButtonExist = true,
      this.onBackPressed,
      this.showCart = false,
      this.bgColor,
      this.onVegFilterTap,
      this.type});

  @override
  Widget build(BuildContext context) {
    log("rebuild");
    log("platform -> ${GetPlatform.isDesktop}");
    log("rebuild appbar");
    log("rr ${ResponsiveHelper.isMobile(context)}");
    return LayoutBuilder(builder: (context, constraint) {
      log("constraints ${constraint.maxWidth}");

      if (constraint.maxWidth <= 720) {
        return AppBar(
          title: Text(title,
              style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                  color: bgColor == null
                      ? Theme.of(context).textTheme.bodyLarge!.color
                      : Theme.of(context).cardColor)),
          centerTitle: true,
          
          leading: isBackButtonExist
              ? Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white30
            ),
                child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios,color: Colors.white,),
                    color: bgColor == null
                        ? Theme.of(context).textTheme.bodyLarge!.color
                        : Theme.of(context).cardColor,
                    onPressed: () => onBackPressed != null
                        ? onBackPressed!()
                        : Navigator.pop(context),
                  ),
              )
              : const SizedBox(),

          
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: showCart || onVegFilterTap != null
              ? [
                  showCart
                      ? IconButton(
                          onPressed: () =>
                              Get.toNamed(RouteHelper.getCartRoute()),
                          icon: CartWidget(
                              color:
                                  Theme.of(context).textTheme.bodyLarge!.color,
                              size: 25),
                        )
                      : const SizedBox(),
                  onVegFilterTap != null
                      ? VegFilterWidget(
                          type: type,
                          onSelected: onVegFilterTap,
                          fromAppBar: true,
                        )
                      : const SizedBox(),
                ]
              : null,
        );
      } else {
        return const WebMenuBar();
      }
    });
  }

  @override
  Size get preferredSize =>
      Size(Dimensions.webMaxWidth, GetPlatform.isDesktop ? 70 : 50);
}

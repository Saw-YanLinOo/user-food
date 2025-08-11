
import 'package:user/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/auth_controller.dart';
import '../../../../helper/route_helper.dart';
import '../../../../util/styles.dart';

class GuestButton extends StatelessWidget {
  const GuestButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) {
      return !authController.guestLoading ? TextButton(
        style: TextButton.styleFrom(
          minimumSize: const Size(1, 40),
        ),
        onPressed: () {
          authController.guestLogin().then((response) {
            if(response.isSuccess) {
              Get.find<UserController>().setForceFullyUserEmpty();
              Navigator.pushReplacementNamed(context, RouteHelper.getInitialRoute());
            }
          });
        },
        child: RichText(text: TextSpan(children: [
          TextSpan(text: '${'continue_as'.tr} ', style: robotoRegular.copyWith(color: Theme.of(context).disabledColor)),
          TextSpan(text: 'guest'.tr, style: robotoMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color)),
        ])),
      ) : const Center(child: SizedBox(height: 25, width: 25, child: CircularProgressIndicator()));
    });
  }
}

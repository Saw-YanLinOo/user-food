// import 'package:user/view/base/custom_app_bar.dart';
// import 'package:user/view/base/custom_button.dart';
// import 'package:user/view/screens/location/widget/permission_dialog.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';

// import '../../../../controller/location_controller.dart';
// import '../../../../data/model/response/address_model.dart';
// import '../../../../data/model/response/zone_response_model.dart';
// import '../../../../helper/responsive_helper.dart';
// import '../../../../helper/route_helper.dart';
// import '../../../../util/images.dart';
// import '../../../base/custom_loader.dart';
// import '../../../base/custom_snackbar.dart';

// class AdditioanlCurrentUserInput extends StatefulWidget {
//   final bool fromSignUp;
//   final bool fromHome;
//   final String? route;
//   const AdditioanlCurrentUserInput(
//       {Key? key, this.route, required this.fromSignUp, required this.fromHome})
//       : super(key: key);

//   @override
//   State<AdditioanlCurrentUserInput> createState() =>
//       _AdditioanlCurrentUserInputState();
// }

// class _AdditioanlCurrentUserInputState
//     extends State<AdditioanlCurrentUserInput> {
//   @override
//   Widget build(BuildContext context) {
//     TextEditingController nameController = TextEditingController();
//     TextEditingController noteController = TextEditingController();

//     return Scaffold(
//       appBar: CustomAppBar(
//         title: "Additional Note".tr,
//         isBackButtonExist: false,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: SingleChildScrollView(
//           child:
//               Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//             Center(
//               child: Container(
//                 width: 200,
//                 height: 200,
//                 decoration: const BoxDecoration(
//                     image: DecorationImage(
//                         image: AssetImage(
//                   Images.additonalD,
//                 ))),
//               ),
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//             Text(
//               "ပို့ဆောင်မှု လမ်းညွှန်ချက်များ".tr,
//               style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
//             ),
//             Text(
//               "ကျေးဇူးပြု၍ သင့်လိပ်စာနှင့်ပတ်သက်သော နောက်ထပ်အချက်အလက်များ  ထည့်သွင်းပါ"
//                   .tr,
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             TextField(
//               controller: nameController,
//               decoration: InputDecoration(
//                   border: const OutlineInputBorder(
//                     borderRadius: BorderRadius.all(
//                       Radius.circular(10),
//                     ),
//                   ),
//                   hintText: "Enter name(Option)".tr,
//                   labelText:
//                       "မှာယူသူ(သို့)အော်ဒါလက်ခံမည့်သူ၏ အမည်ကိုထည့်ပါ".tr),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             TextField(
//               controller: noteController,
//               decoration: InputDecoration(
//                   border: const OutlineInputBorder(
//                     borderRadius: BorderRadius.all(
//                       Radius.circular(10),
//                     ),
//                   ),
//                   hintText: "Additional Note(Option)".tr,
//                   labelText:
//                       "ပို့ဆောင်သူအတွက် အမှာစာ ဥပမာ-အိမ်နံပါတ်,လမ်းနာမည်".tr),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             GetBuilder<LocationController>(builder: (locationController) {
//               return 
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SizedBox(
//                     width: 100,
//                     child: CustomButton(buttonText: "Skip".tr,
//                     onPressed: (){
//                     _checkPermission(() async {
//                           Get.dialog(const CustomLoader(), barrierDismissible: false);
//                           AddressModel address = await Get.find<LocationController>()
//                               .getCurrentLocation(true);
//                           ZoneResponseModel response = await locationController
//                               .getZone(address.latitude, address.longitude, false);
//                           if (response.isSuccess) {
//                             locationController.saveAddressAndNavigate(
//                               address,
//                               widget.fromSignUp,
//                               widget.route,
//                               widget.route != null,
//                               ResponsiveHelper.isDesktop(Get.context),
//                             );
                           
//                           } else {
//                             Get.back();
//                             Get.toNamed(RouteHelper.getPickMapRoute(
//                                 widget.route ?? RouteHelper.accessLocation,
//                                 widget.route != null));
//                             showCustomSnackBar(
//                                 'service_not_available_in_current_location'.tr);
//                           }
//                         });
//                     },),
//                   ),
// const SizedBox(width: 20,),
//                   SizedBox(
//                     width: 100,
//                     child: CustomButton(
                      
//                       //isLoading: locationController.isLoading,
//                       buttonText: "Continue".tr,
//                       onPressed: () {
//                         _checkPermission(() async {
//                           Get.dialog(const CustomLoader(), barrierDismissible: false);
//                           AddressModel address = await Get.find<LocationController>()
//                               .getCurrentLocation(true);
//                           ZoneResponseModel response = await locationController
//                               .getZone(address.latitude, address.longitude, false);
//                           if (response.isSuccess) {
//                             locationController.saveAddressAndNavigate(
//                               address,
//                               widget.fromSignUp,
//                               widget.route,
//                               widget.route != null,
//                               ResponsiveHelper.isDesktop(Get.context),
//                             );
//                             Get.find<LocationController>().additionalNote(
//                                 nameController.text.trim(),
//                                 noteController.text.trim());
//                           } else {
//                             Get.back();
//                             Get.toNamed(RouteHelper.getPickMapRoute(
//                                 widget.route ?? RouteHelper.accessLocation,
//                                 widget.route != null));
//                             showCustomSnackBar(
//                                 'service_not_available_in_current_location'.tr);
//                           }
//                         });
//                       },
//                     ),
//                   ),
//                 ],
//               );
//             })
//           ]),
//         ),
//       ),
//     );
//   }

//   void _checkPermission(Function onTap) async {
//     await Geolocator.requestPermission();
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//     }
//     if (permission == LocationPermission.denied) {
//       showCustomSnackBar('you_have_to_allow'.tr);
//     } else if (permission == LocationPermission.deniedForever) {
//       Get.dialog(const PermissionDialog());
//     } else {
//       onTap();
//     }
//   }
// }

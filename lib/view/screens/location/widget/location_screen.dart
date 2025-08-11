// import 'package:user/view/base/custom_app_bar.dart';
// import 'package:user/view/base/custom_button.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../../../controller/location_controller.dart';
// import '../../../../data/model/response/address_model.dart';
// import '../../../../helper/responsive_helper.dart';
// import '../../../../util/images.dart';

// class AdditionalUerInput extends StatefulWidget {
//   final bool fromSignUp;
//   final bool fromAddAddress;
//   final bool canRoute;
//   final String? route;
//   const AdditionalUerInput(
//       {Key? key,
//       required this.fromSignUp,
//       required this.fromAddAddress,
//       required this.canRoute,
//       this.route})
//       : super(key: key);

//   @override
//   State<AdditionalUerInput> createState() => _AdditionalUerInputState();
// }

// class _AdditionalUerInputState extends State<AdditionalUerInput> {
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
//             Text("ပို့ဆောင်မှု လမ်းညွှန်ချက်များ".tr),
//             Text(
//                 "ကျေးဇူးပြု၍ သင့်လိပ်စာနှင့်ပတ်သက်သော နောက်ထပ်အချက်အလက်များ  ထည့်သွင်းပါ"
//                     .tr),
//             const SizedBox(
//               height: 10,
//             ),
//             TextField(
//               controller: nameController,
//               decoration: InputDecoration(
//                   border: const OutlineInputBorder(
//                     borderRadius: BorderRadius.all(
//                       Radius.circular(10),
//                     ),
//                   ),
//                   labelText: "မှာယူသူ(သို့)အော်ဒါလက်ခံမည့်သူ၏ အမည်ကိုထည့်ပါ".tr,
//                   hintText: "Enter name(Option)".tr),
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//             TextField(
//               controller: noteController,
//               decoration: InputDecoration(
//                   border: const OutlineInputBorder(
//                     borderRadius: BorderRadius.all(
//                       Radius.circular(10),
//                     ),
//                   ),
//                   labelText:
//                       "ပို့ဆောင်သူအတွက် အမှာစာ ဥပမာ-အိမ်နံပါတ်,လမ်းနာမည်".tr,
//                   hintText: "Additional Note(Option)".tr),
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
                     
//                     child: CustomButton(
                     
//                       buttonText: "Skip",onPressed: (){
//                       locationController.isLoading==true;
//                        AddressModel address = AddressModel(
//                                 latitude: Get.find<LocationController>()
//                                     .pickPosition
//                                     .latitude
//                                     .toString(),
//                                 longitude: Get.find<LocationController>()
//                                     .pickPosition
//                                     .longitude
//                                     .toString(),
//                                 addressType: 'others',
//                                 address: Get.find<LocationController>().pickAddress,
//                               );
//                               Get.find<LocationController>().saveAddressAndNavigate(
//                                 address,
//                                 widget.fromSignUp,
//                                 widget.route,
//                                 widget.canRoute,
//                                 ResponsiveHelper.isDesktop(Get.context),
//                               );
//                     },),
//                   ),
//                   SizedBox(width: 10,),
//                   Container(
//                     width: 100,
//                     child: CustomButton(
                   
//                       buttonText: "Continue",
//                       onPressed: 
//                       // (locationController.buttonDisabled ||
//                       //         locationController.loading)
//                       //     ? null
//                       //     : 
//                           () {
                          
//                               AddressModel address = AddressModel(
//                                 latitude: Get.find<LocationController>()
//                                     .pickPosition
//                                     .latitude
//                                     .toString(),
//                                 longitude: Get.find<LocationController>()
//                                     .pickPosition
//                                     .longitude
//                                     .toString(),
//                                 addressType: 'others',
//                                 address: Get.find<LocationController>().pickAddress,
//                               );
//                               Get.find<LocationController>().saveAddressAndNavigate(
//                                 address,
//                                 widget.fromSignUp,
//                                 widget.route,
//                                 widget.canRoute,
//                                 ResponsiveHelper.isDesktop(Get.context),
//                               );
//                               Get.find<LocationController>().additionalNote(
//                                   nameController.text.trim(),
//                                   noteController.text.trim());
//                             },
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
// }

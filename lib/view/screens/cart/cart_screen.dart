// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:user/controller/cart_controller.dart';
import 'package:user/controller/coupon_controller.dart';
import 'package:user/controller/restaurant_controller.dart';
import 'package:user/controller/splash_controller.dart';
import 'package:user/controller/theme_controller.dart';
import 'package:user/data/model/response/cart_model.dart';
import 'package:user/data/model/response/product_model.dart';
import 'package:user/data/model/response/restaurant_model.dart';
import 'package:user/helper/price_converter.dart';
import 'package:user/helper/responsive_helper.dart';
import 'package:user/helper/route_helper.dart';
import 'package:user/util/dimensions.dart';
import 'package:user/util/images.dart';
import 'package:user/util/styles.dart';
import 'package:user/view/base/custom_app_bar.dart';
import 'package:user/view/base/custom_button.dart';
import 'package:user/view/base/custom_snackbar.dart';
import 'package:user/view/base/no_data_screen.dart';
import 'package:user/view/base/product_widget.dart';
import 'package:user/view/base/web_constrained_box.dart';
import 'package:user/view/screens/cart/widget/cart_product_widget.dart';
import 'package:user/view/screens/cart/widget/not_available_bottom_sheet.dart';
import 'package:user/view/screens/restaurant/restaurant_screen.dart';

import '../../../util/colors.dart';
import '../../widgets/custom_text.dart';

class CartScreen extends StatefulWidget {
  final bool fromNav;
  final String tableId;
  const CartScreen({
    super.key,
    required this.fromNav,
    required this.tableId,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();

    initCall();
  }

  Future<void> initCall() async {
    await Get.find<RestaurantController>().getRestaurantDetails(
        Restaurant(
            id: Get.find<CartController>().cartList[0].product!.restaurantId,
            name: null),
        fromCart: true);
    Get.find<CartController>().calculationCart();
    if (Get.find<CartController>().cartList.isNotEmpty) {
      if (Get.find<CartController>().addCutlery) {
        Get.find<CartController>().updateCutlery(isUpdate: false);
      }
      Get.find<CartController>().setAvailableIndex(-1, isUpdate: false);
      Get.find<RestaurantController>().getCartRestaurantSuggestedItemList(
          Get.find<CartController>().cartList[0].product!.restaurantId);
    }
  }

  @override
  Widget build(BuildContext context) {
    log("table_id ${widget.tableId}");

    return Scaffold(
      // appBar: CustomAppBar(
      //     title: 'my_cart'.tr,
      //     isBackButtonExist:
      //         (ResponsiveHelper.isDesktop(context) || !widget.fromNav)),
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
        title: CustomText(text: 'my_cart'.tr, color: Theme.of(context).disabledColor, fontWeight: FontWeight.bold,fontSize: 14.sp,),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff3E2723),gradient1CardColor])
        ),
        child: GetBuilder<CartController>(
          builder: (cartController) {
            return cartController.cartList.isNotEmpty
                ? Column(
                    children: [
                      Expanded(
                        child: Scrollbar(
                          child: SingleChildScrollView(
                            padding: ResponsiveHelper.isDesktop(context)
                                ? const EdgeInsets.only(
                                    top: Dimensions.paddingSizeSmall)
                                : EdgeInsets.zero,
                            child: Center(
                              child: SizedBox(
                                width: Dimensions.webMaxWidth,
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Product


                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                              flex: 6,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  WebConstrainedBox(
                                                    dataLength: cartController
                                                        .cartList.length,
                                                    minLength: 5,
                                                    minHeight: 0.6,
                                                    child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                         Container(
                                                           padding: EdgeInsets.all(15.w),
                                                           decoration: BoxDecoration(
                                                             borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                                             border: Border(bottom: BorderSide(color: Theme.of(context).disabledColor))
                                                           ),
                                                           child: Column(
                                                             crossAxisAlignment: CrossAxisAlignment.start,
                                                             children: [
                                                               CustomText(text: 'order_items_in_cart'.tr,color: Theme.of(context).disabledColor,),
                                                               Dimensions.kSizedBoxH10,
                                                               ListView.builder(
                                                                 physics:
                                                                 const NeverScrollableScrollPhysics(),
                                                                 shrinkWrap: true,
                                                                 // padding: const EdgeInsets
                                                                 //         .all(
                                                                 //     Dimensions
                                                                 //         .paddingSizeDefault),
                                                                 itemCount:
                                                                 cartController
                                                                     .cartList
                                                                     .length,
                                                                 itemBuilder:
                                                                     (context, index) {
                                                                   return CartProductWidget(
                                                                     cart: cartController
                                                                         .cartList[
                                                                     index],
                                                                     cartIndex: index,
                                                                     addOns: cartController
                                                                         .addOnsList[
                                                                     index],
                                                                     isAvailable:
                                                                     (cartController
                                                                         .availableList[
                                                                     index]),
                                                                   );
                                                                 },
                                                               ),
                                                               // const SizedBox(height: Dimensions.paddingSizeSmall),

                                                               // const Divider(
                                                               //     thickness: 0.5,
                                                               //     height: 5),
                                                               InkWell(
                                                                 onTap: (){
                                                                   Get.toNamed(
                                                                     RouteHelper.getRestaurantRoute(
                                                                         cartController
                                                                             .cartList[
                                                                         0]
                                                                             .product!
                                                                             .restaurantId),
                                                                     arguments: RestaurantScreen(
                                                                         restaurant: Restaurant(
                                                                             id: cartController
                                                                                 .cartList[0]
                                                                                 .product!
                                                                                 .restaurantId)),
                                                                   );
                                                                 },
                                                                 child: Row(
                                                                   children: [
                                                                     Icon(Icons.add,color: Theme.of(context).primaryColor,),
                                                                     CustomText(text: 'add_more_items'.tr,color: Theme.of(context).primaryColor,)
                                                                   ],
                                                                 ),
                                                               ),

                                                               // TextButton.icon(
                                                               //                                                               onPressed: () {
                                                               //
                                                               //                                                               },
                                                               //                                                               icon: Icon(
                                                               //   Icons
                                                               //       .add,
                                                               //   color: Theme.of(
                                                               //           context)
                                                               //       .primaryColor),
                                                               //                                                               label: Text(
                                                               //   'add_more_items'
                                                               //       .tr,
                                                               //   style: robotoMedium.copyWith(
                                                               //       color: Theme.of(
                                                               //               context)
                                                               //           .primaryColor,
                                                               //       fontSize:
                                                               //           Dimensions
                                                               //               .fontSizeDefault)),
                                                               //                                                             ),
                                                               Dimensions.kSizedBoxH10,
                                                               Text("if_any_product_is_not_available".tr,style: robotoMedium,),
                                                               Dimensions.kSizedBoxH10,
                                                               InkWell(
                                                                 onTap: () {
                                                                   if (ResponsiveHelper.isDesktop(context)) {
                                                                     Get.dialog(
                                                                         const Dialog(child: NotAvailableBottomSheet()));
                                                                   } else {
                                                                     showModalBottomSheet(
                                                                       context: context,
                                                                       isScrollControlled: true,
                                                                       backgroundColor: Colors.transparent,
                                                                       builder: (con) => const NotAvailableBottomSheet(),
                                                                     );
                                                                   }
                                                                 },
                                                                 child: Container(
                                                                   padding: EdgeInsets.all(10.w),
                                                                   decoration: BoxDecoration(
                                                                       borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                                                       border: Border.all(color: Theme.of(context).cardColor)
                                                                   ),
                                                                   child: Row(children: [
                                                                     Expanded(
                                                                         child: Text(
                                                                             cartController.notAvailableIndex!=-1?   cartController
                                                                                 .notAvailableList[cartController.notAvailableIndex]
                                                                                 .tr: cartController
                                                                                 .notAvailableList[0]
                                                                                 .tr,
                                                                             style: robotoMedium,
                                                                             maxLines: 2,
                                                                             overflow: TextOverflow.ellipsis)),
                                                                     const Icon(Icons.arrow_forward_ios_sharp, size: 18),
                                                                   ]),
                                                                 ),
                                                               ),
                                                               //Dimensions.kSizedBoxH10,
                                                             ],
                                                           ),
                                                         ),


                                                          !ResponsiveHelper
                                                                  .isDesktop(
                                                                      context)
                                                              ? suggestedItemView(
                                                                  cartController
                                                                      .cartList)
                                                              : const SizedBox(),
                                                        ]),
                                                  ),
                                                  const SizedBox(
                                                      height: Dimensions
                                                          .paddingSizeSmall),

                                                  //Pricing View
                                                  !ResponsiveHelper.isDesktop(
                                                          context)
                                                      ? pricingView(
                                                          cartController,
                                                          cartController
                                                              .cartList[0]
                                                              .product!)
                                                      : const SizedBox(),
                                                ],
                                              )),
                                          ResponsiveHelper.isDesktop(context)
                                              ? Expanded(
                                                  flex: 4,
                                                  child: pricingView(
                                                      cartController,
                                                      cartController
                                                          .cartList[0].product!))
                                              : const SizedBox(),
                                        ],
                                      ),

                                      ResponsiveHelper.isDesktop(context)
                                          ? suggestedItemView(
                                              cartController.cartList)
                                          : const SizedBox(),
                                    ]),
                              ),
                            ),
                          ),
                        ),
                      ),
                      ResponsiveHelper.isDesktop(context)
                          ? const SizedBox.shrink()
                          : CheckoutButton(
                              tableId: widget.tableId,
                              cartController: cartController,
                              availableList: cartController.availableList),
                    ],
                  )
                : const NoDataScreen(isCart: true, text: '');
          },
        ),
      ),
    );
  }

  Widget suggestedItemView(List<CartModel> cartList) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context)
            .cardColor
            .withOpacity(Get.find<ThemeController>().darkTheme ? 0 : 1),
      ),
      width: double.infinity,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        GetBuilder<RestaurantController>(builder: (restaurantController) {
          List<Product>? suggestedItems;
          if (restaurantController.suggestedItems != null) {
            suggestedItems = [];
            List<int> cartIds = [];
            for (CartModel cartItem in cartList) {
              cartIds.add(cartItem.product!.id!);
            }
            for (Product item in restaurantController.suggestedItems!) {
              if (cartIds.contains(item.id)) {
                if (kDebugMode) {
                  print(
                      'it will not added -> ${restaurantController.suggestedItems!.indexOf(item)}');
                }
              } else {
                suggestedItems.add(item);
              }
            }
          }
          return restaurantController.suggestedItems != null &&
                  suggestedItems!.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: Dimensions.paddingSizeSmall),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeDefault,
                          vertical: Dimensions.paddingSizeExtraSmall),
                      child: Text('you_may_also_like'.tr,
                          style: robotoMedium.copyWith(
                              fontSize: Dimensions.fontSizeDefault)),
                    ),
                    SizedBox(
                      height: ResponsiveHelper.isDesktop(context) ? 160 : 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: suggestedItems.length,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(
                            left: Dimensions.paddingSizeDefault),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: ResponsiveHelper.isDesktop(context)
                                ? const EdgeInsets.symmetric(vertical: 20)
                                : const EdgeInsets.symmetric(vertical: 10),
                            child: Container(
                              width: ResponsiveHelper.isDesktop(context)
                                  ? 500
                                  : 300,
                              padding: const EdgeInsets.only(
                                  right: Dimensions.paddingSizeSmall,
                                  left: Dimensions.paddingSizeExtraSmall),
                              margin: const EdgeInsets.only(
                                  right: Dimensions.paddingSizeSmall),
                              child: ProductWidget(
                                isRestaurant: false,
                                product: suggestedItems![index],
                                fromCartSuggestion: true,
                                restaurant: null,
                                index: index,
                                length: null,
                                isCampaign: false,
                                inRestaurant: false,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                )
              : const SizedBox();
        }),
      ]),
    );
  }

  Widget pricingView(CartController cartController, Product product) {
    return Container(
      decoration: BoxDecoration(
       // color: Color(0xff212121),
       // borderRadius: BorderRadius.only(Dimensions.radiusSmall),
      ),
      child: GetBuilder<RestaurantController>(builder: (restaurantController) {
        return Column(children: [
          (restaurantController.restaurant != null &&
                  (restaurantController.restaurant?.cutlery ?? false))
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeDefault,
                      vertical: Dimensions.paddingSizeSmall),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.flatware,
                            size: ResponsiveHelper.isDesktop(context) ? 30 : 25,
                            color: Theme.of(context).primaryColor),
                        const SizedBox(width: Dimensions.paddingSizeDefault),
                        Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('add_cutlery'.tr,
                                    style: robotoMedium.copyWith(
                                        color: Theme.of(context).primaryColor)),
                                const SizedBox(
                                    height: Dimensions.paddingSizeExtraSmall),
                                Text('do_not_have_cutlery'.tr,
                                    style: robotoRegular.copyWith(
                                        color: Theme.of(context).disabledColor,
                                        fontSize: Dimensions.fontSizeSmall)),
                              ]),
                        ),
                        Transform.scale(
                          scale: 0.7,
                          child: CupertinoSwitch(
                            value: cartController.addCutlery,
                            activeTrackColor: Theme.of(context).primaryColor,
                            onChanged: (bool? value) {
                              cartController.updateCutlery();
                            },
                            inactiveTrackColor: Theme.of(context)
                                .secondaryHeaderColor
                                .withOpacity(0.5),
                          ),
                        )
                      ]),
                )
              : const SizedBox(),

          // Container(
          //   decoration: BoxDecoration(
          //     color: Theme.of(context).cardColor,
          //     border:
          //         Border.all(color: Theme.of(context).primaryColor, width: 0.5),
          //   ),
          //   padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          //   margin: ResponsiveHelper.isDesktop(context)
          //       ? const EdgeInsets.symmetric(
          //           horizontal: Dimensions.paddingSizeDefault,
          //           vertical: Dimensions.paddingSizeSmall)
          //       : EdgeInsets.zero,
          //   child: Column(
          //     mainAxisSize: MainAxisSize.min,
          //     children: [
          //       InkWell(
          //         onTap: () {
          //           if (ResponsiveHelper.isDesktop(context)) {
          //             Get.dialog(
          //                 const Dialog(child: NotAvailableBottomSheet()));
          //           } else {
          //             showModalBottomSheet(
          //               context: context,
          //               isScrollControlled: true,
          //               backgroundColor: Colors.transparent,
          //               builder: (con) => const NotAvailableBottomSheet(),
          //             );
          //           }
          //         },
          //         child: Row(children: [
          //           Expanded(
          //               child: Text('if_any_product_is_not_available'.tr,
          //                   style: robotoMedium,
          //                   maxLines: 2,
          //                   overflow: TextOverflow.ellipsis)),
          //           const Icon(Icons.arrow_forward_ios_sharp, size: 18),
          //         ]),
          //       ),
          //       cartController.notAvailableIndex != -1
          //           ? Row(children: [
          //               Text(
          //                   cartController
          //                       .notAvailableList[
          //                           cartController.notAvailableIndex]
          //                       .tr,
          //                   style: robotoMedium.copyWith(
          //                       fontSize: Dimensions.fontSizeSmall,
          //                       color: Theme.of(context).primaryColor)),
          //               IconButton(
          //                 onPressed: () => cartController.setAvailableIndex(-1),
          //                 icon: const Icon(Icons.clear, size: 18),
          //               )
          //             ])
          //           : const SizedBox(),
          //     ],
          //   ),
          // ),
          const SizedBox(height: Dimensions.paddingSizeSmall),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeDefault,
                vertical: Dimensions.paddingSizeSmall),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

              Text('details'.tr, style: robotoBold),
              Dimensions.kSizedBoxH10,
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('item_price'.tr, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor)),
                PriceConverter.convertAnimationPrice(cartController.itemPrice,
                    textStyle: robotoRegular.copyWith(color: Theme.of(context).disabledColor)),
                // Text(PriceConverter.convertPrice(cartController.itemPrice), style: robotoRegular, textDirection: TextDirection.ltr),
              ]),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('discount'.tr, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor)),
                restaurantController.restaurant != null
                    ? Row(children: [
                        Text('(-)', style: robotoRegular.copyWith(color: Theme.of(context).disabledColor)),
                        PriceConverter.convertAnimationPrice(
                            cartController.itemDiscountPrice,
                            textStyle: robotoRegular.copyWith(color: Theme.of(context).disabledColor)),
                      ])
                    : Text('calculating'.tr, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor)),
                // Text('(-) ${PriceConverter.convertPrice(cartController.itemDiscountPrice)}', style: robotoRegular, textDirection: TextDirection.ltr),
              ]),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('addons'.tr, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor)),
                  Row(children: [
                    Text('(+)', style: robotoRegular.copyWith(color: Theme.of(context).disabledColor)),
                    PriceConverter.convertAnimationPrice(cartController.addOns,
                        textStyle: robotoRegular.copyWith(color: Theme.of(context).disabledColor)),
                  ]),
                  // Text('(+) ${PriceConverter.convertPrice(cartController.addOns)}', style: robotoRegular, textDirection: TextDirection.ltr),
                ],
              ),
            ]),
          ),
          ResponsiveHelper.isDesktop(context)
              ? CheckoutButton(
                  tableId: widget.tableId,
                  cartController: cartController,
                  availableList: cartController.availableList)
              : const SizedBox.shrink(),
        ]);
      }),
    );
  }
}

class CheckoutButton extends StatelessWidget {
  final String tableId;
  final CartController cartController;
  final List<bool> availableList;
  const CheckoutButton(
      {super.key,
      required this.cartController,
      required this.availableList,
      required this.tableId});

  @override
  Widget build(BuildContext context) {
    double percentage = 0;

    return Material(
      elevation: 5,
      child: Container(
        width: Dimensions.webMaxWidth,
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: gradient1CardColor.withOpacity(0.8),width: 3),),
            color: gradient1CardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black
                 ,
              blurRadius: 5,
              spreadRadius: 1,
              offset: const Offset(
                3,
                3,
              ),
            ),
          ],
          ),

        child: SafeArea(
          child: GetBuilder<RestaurantController>(builder: (storeController) {
            var restaurant = Get.find<RestaurantController>().restaurant;
            if (restaurant != null &&
                !(restaurant.freeDelivery ?? false) &&
                Get.find<SplashController>().configModel!.freeDeliveryOver !=
                    null) {
              percentage = cartController.subTotal /
                  Get.find<SplashController>().configModel!.freeDeliveryOver!;
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                (storeController.restaurant != null &&
                        !(storeController.restaurant?.freeDelivery ?? false) &&
                        Get.find<SplashController>()
                                .configModel!
                                .freeDeliveryOver !=
                            null &&
                        percentage < 1)
                    ?
                Column(children: [
                        Row(children: [
                          Image.asset(Images.percentTag, height: 20, width: 20),
                          const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                          PriceConverter.convertAnimationPrice(
                            Get.find<SplashController>()
                                    .configModel!
                                    .freeDeliveryOver! -
                                cartController.subTotal,
                            textStyle: robotoMedium.copyWith(
                                color: Theme.of(context).primaryColor),
                          ),

                          // Text(PriceConverter.convertPrice(Get.find<SplashController>().configModel!.freeDeliveryOver! - cartController.subTotal), style: robotoMedium.copyWith(color: Theme.of(context).primaryColor)),
                          const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                          Text('more_for_free_delivery'.tr,
                              style: robotoMedium.copyWith(
                                  color: Theme.of(context).disabledColor)),
                        ]),
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                        LinearProgressIndicator(
                          backgroundColor: Theme.of(context)
                              .secondaryHeaderColor
                              .withOpacity(0.2),
                          value: percentage,
                        ),
                      ])
                    : const SizedBox(),
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Padding(
                     padding: const EdgeInsets.symmetric(
                         vertical: Dimensions.paddingSizeSmall),
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text('subtotal'.tr,
                             style: robotoMedium.copyWith(
                                 color: Theme.of(context).disabledColor)),
                         Container(
                           padding: EdgeInsets.symmetric(horizontal:7.w,vertical: 3.h),
                           decoration: BoxDecoration(
                             color: Colors.grey,
                             borderRadius: BorderRadius.circular(Dimensions.roundRadius)
                           ),
                           child: PriceConverter.convertAnimationPrice(
                               cartController.subTotal,
                               textStyle: robotoBold),
                         ),

                         // Text(
                         //   PriceConverter.convertPrice(cartController.subTotal),
                         //   style: robotoMedium.copyWith(color: Theme.of(context).primaryColor), textDirection: TextDirection.ltr,
                         // ),
                       ],
                     ),
                   ),
                   CustomButton(
                     width: MediaQuery.of(context).size.width/1.7,
                       radius: Dimensions.roundRadius,
                       buttonText: 'proceed_to_checkout'.tr,
                       onPressed: () {
                         if (!cartController
                             .cartList.first.product!.scheduleOrder! &&
                             cartController.availableList.contains(false)) {
                           showCustomSnackBar('one_or_more_product_unavailable'.tr);
                         }
                         //  else if (cartController
                         //             .cartList.first.product!.restaurantOpen! ==
                         //         0 ||
                         //     cartController
                         //             .cartList.first.product!.restaurantActive! ==
                         //         0 ||
                         //     cartController.cartList.first.product!.foodOpen! == 0) {
                         //   showCustomSnackBar('restaurant_is_closed'.tr);
                         // }
                         else {
                           Get.find<CouponController>().removeCouponData(false);
                           Get.toNamed(
                             RouteHelper.getCheckoutRoute('cart', tableId),
                           );
                         }
                       }),
                 ],
               )
              ],
            );
          }),
        ),
      ),
    );
  }
}

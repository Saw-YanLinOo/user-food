import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:user/controller/cart_controller.dart';
import 'package:user/controller/localization_controller.dart';
import 'package:user/controller/splash_controller.dart';
import 'package:user/data/model/response/cart_model.dart';
import 'package:user/data/model/response/product_model.dart';
import 'package:user/helper/price_converter.dart';
import 'package:user/helper/responsive_helper.dart';
import 'package:user/util/dimensions.dart';
import 'package:user/util/styles.dart';
import 'package:user/view/base/custom_image.dart';
import 'package:user/view/base/product_bottom_sheet.dart';
import 'package:user/view/base/quantity_button.dart';
import 'package:user/view/base/rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

class CartProductWidget extends StatefulWidget {
  final CartModel cart;
  final int cartIndex;
  final List<AddOns> addOns;
  final bool isAvailable;
  const CartProductWidget(
      {super.key,
      required this.cart,
      required this.cartIndex,
      required this.isAvailable,
      required this.addOns});

  @override
  State<CartProductWidget> createState() => _CartProductWidgetState();
}

class _CartProductWidgetState extends State<CartProductWidget> {
  @override
  Widget build(BuildContext context) {
    String addOnText = '';
    int index0 = 0;
    List<int?> ids = [];
    List<int?> qtys = [];
    for (var addOn in widget.cart.addOnIds!) {
      ids.add(addOn.id);
      qtys.add(addOn.quantity);
    }
    for (var addOn in widget.cart.product!.addOns!) {
      if (ids.contains(addOn.id)) {
        addOnText =
            '$addOnText${(index0 == 0) ? '' : ',  '}${addOn.name} (${qtys[index0]})';
        index0 = index0 + 1;
      }
    }

    String variationText = '';

    if (widget.cart.variations!.isNotEmpty) {
      for (int index = 0; index < widget.cart.variations!.length; index++) {
        if (widget.cart.variations![index].isNotEmpty &&
            widget.cart.variations![index].contains(true)) {
          variationText +=
              '${variationText.isNotEmpty ? ', ' : ''}${widget.cart.product!.variations![index].name} (';

          for (int i = 0; i < widget.cart.variations![index].length; i++) {
            if (widget.cart.variations![index][i]!) {
              variationText +=
                  '${variationText.endsWith('(') ? '' : ', '}${widget.cart.product!.variations![index].variationValues![i].level}';
            }
          }
          variationText += ')';
        }
      }
    }
    // final bool isAvailableRes = widget.cart.product!.restaurantActive == 1 &&
    //     widget.cart.product!.restaurantOpen == 1 &&
    //     widget.cart.product!.foodOpen == 1;

    return Padding(
      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
      child: InkWell(
        onTap: () {
          ResponsiveHelper.isMobile(context)
              ? showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (con) => ProductBottomSheet(
                      product: widget.cart.product,
                      cartIndex: widget.cartIndex,
                      cart: widget.cart),
                )
              : showDialog(
                  context: context,
                  builder: (con) => Dialog(
                        child: ProductBottomSheet(
                            product: widget.cart.product,
                            cartIndex: widget.cartIndex,
                            cart: widget.cart),
                      ));
        },
        child: Slidable(
          key: UniqueKey(),
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            extentRatio: 0.2,
            children: [
              SlidableAction(
                onPressed: (context) =>
                    Get.find<CartController>().removeFromCart(widget.cartIndex),
                backgroundColor: Theme.of(context).colorScheme.error,
                borderRadius: BorderRadius.horizontal(
                    right: Radius.circular(
                        Get.find<LocalizationController>().isLtr
                            ? Dimensions.radiusDefault
                            : 0),
                    left: Radius.circular(
                        Get.find<LocalizationController>().isLtr
                            ? 0
                            : Dimensions.radiusDefault)),
                foregroundColor: Colors.white,
                icon: Icons.delete_outline,
              ),
            ],
          ),
          child: Container(
              // padding: const EdgeInsets.symmetric(
              //     vertical: Dimensions.paddingSizeExtraSmall,
              //     horizontal: Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                // !isAvailableRes ?
                //  Colors.red : Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                // boxShadow: [
                //   BoxShadow(
                //     color:
                //         Theme.of(context).secondaryHeaderColor.withOpacity(0.2),
                //     blurRadius: 5,
                //     spreadRadius: 1,
                //   )
                // ],
              ),
              child: Column(
                children: [
                  Row(children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius:
                              BorderRadius.only(topLeft:Radius.circular(Dimensions.radiusDefault),bottomLeft:Radius.circular(Dimensions.radiusDefault) ),
                          child: CustomImage(
                            image:
                                '${Get.find<SplashController>().configModel!.baseUrls!.productImageUrl}/${widget.cart.product!.image}',
                            height: 65,
                            width: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                        widget.isAvailable
                            ? const SizedBox()
                            : Positioned(
                                top: 0,
                                left: 0,
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.radiusSmall),
                                      color: Colors.black.withOpacity(0.6)),
                                  child: Text('not_available_now_break'.tr,
                                      textAlign: TextAlign.center,
                                      style: robotoRegular.copyWith(
                                        color: Colors.white,
                                        fontSize: 8,
                                      )),
                                ),
                              ),
                      ],
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(children: [
                              Flexible(
                                child: Text(
                                  widget.cart.product!.name!,
                                  style: robotoMedium.copyWith(
                                      fontSize: Dimensions.fontSizeSmall),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(
                                  width: Dimensions.paddingSizeExtraSmall),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: Dimensions.paddingSizeExtraSmall,
                                    horizontal: Dimensions.paddingSizeSmall),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radiusSmall),
                                  color: Theme.of(context)
                                      .secondaryHeaderColor
                                      .withOpacity(0.2),
                                ),
                                child: Text(
                                  widget.cart.product!.veg == 0
                                      ? 'non_veg'.tr
                                      : 'veg'.tr,
                                  style: robotoMedium.copyWith(
                                      fontSize: Dimensions.fontSizeExtraSmall,
                                      color: Theme.of(context).primaryColor),
                                ),
                              ),
                            ]),
                            const SizedBox(height: 2),
                            RatingBar(
                                rating: widget.cart.product!.avgRating,
                                size: 12,
                                ratingCount: widget.cart.product!.ratingCount),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Text(
                                  PriceConverter.convertPrice(
                                      widget.cart.discountedPrice),
                                  style: robotoMedium.copyWith(
                                      fontSize: Dimensions.fontSizeSmall),
                                  textDirection: TextDirection.ltr,
                                ),
                                const SizedBox(
                                    width: Dimensions.paddingSizeExtraSmall),
                                widget.cart.discountedPrice! +
                                            widget.cart.discountAmount! >
                                        widget.cart.discountedPrice!
                                    ? Text(
                                        PriceConverter.convertPrice(
                                            widget.cart.discountedPrice! +
                                                widget.cart.discountAmount!),
                                        textDirection: TextDirection.ltr,
                                        style: robotoMedium.copyWith(
                                            color:
                                                Theme.of(context).disabledColor,
                                            fontSize: Dimensions.fontSizeSmall,
                                            decoration:
                                                TextDecoration.lineThrough),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          ]),
                    ),
                    Row(children: [
                      QuantityButton(
                        onTap: () {
                          if (widget.cart.quantity! > 1) {
                            Get.find<CartController>()
                                .setQuantity(false, widget.cart);
                          } else {
                            Get.find<CartController>()
                                .removeFromCart(widget.cartIndex);
                          }
                        },
                        isIncrement: false,
                        showRemoveIcon: widget.cart.quantity! == 1,
                      ),

                      AnimatedFlipCounter(
                        duration: const Duration(milliseconds: 500),
                        value: widget.cart.quantity!.toDouble(),
                        textStyle: robotoMedium.copyWith(
                            fontSize: Dimensions.fontSizeExtraLarge),
                      ),
                      // Text(cart.quantity.toString(), style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge)),
                      QuantityButton(
                        onTap: () => Get.find<CartController>()
                            .setQuantity(true, widget.cart),
                        isIncrement: true,
                      ),
                    ]),
                    !ResponsiveHelper.isMobile(context)
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingSizeSmall),
                            child: IconButton(
                              onPressed: () {
                                Get.find<CartController>()
                                    .removeFromCart(widget.cartIndex);
                              },
                              icon: const Icon(Icons.delete, color: Colors.red),
                            ),
                          )
                        : const SizedBox(),
                  ]),
                  addOnText.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(
                              top: Dimensions.paddingSizeExtraSmall),
                          child: Row(children: [
                            const SizedBox(width: 80),
                            Text('${'addons'.tr}: ',
                                style: robotoMedium.copyWith(
                                    fontSize: Dimensions.fontSizeSmall)),
                            Flexible(
                                child: Text(
                              addOnText,
                              style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeSmall,
                                  color: Theme.of(context).disabledColor),
                            )),
                          ]),
                        )
                      : const SizedBox(),
                  variationText.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(
                              top: Dimensions.paddingSizeExtraSmall),
                          child: Row(children: [
                            const SizedBox(width: 80),
                            Text('${'variations'.tr}: ',
                                style: robotoMedium.copyWith(
                                    fontSize: Dimensions.fontSizeSmall)),
                            Flexible(
                                child: Text(
                              variationText,
                              style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeSmall,
                                  color: Theme.of(context).disabledColor),
                            )),
                          ]),
                        )
                      : const SizedBox(),
                  // !isAvailableRes
                  //     ? Padding(
                  //         padding: const EdgeInsets.all(8.0),
                  //         child: Text(
                  //           "restaurant_is_closed".tr,
                  //           style: const TextStyle(
                  //               color: Colors.white,
                  //               fontWeight: FontWeight.bold),
                  //         ),
                  //       )
                  //     : const SizedBox(),
                ],
              )),
        ),
      ),
    );
  }
}













// import 'package:user/controller/cart_controller.dart';
// import 'package:user/controller/splash_controller.dart';
// import 'package:user/data/model/response/cart_model.dart';
// import 'package:user/data/model/response/product_model.dart';
// import 'package:user/helper/price_converter.dart';
// import 'package:user/helper/responsive_helper.dart';
// import 'package:user/util/dimensions.dart';
// import 'package:user/util/styles.dart';
// import 'package:user/view/base/custom_image.dart';
// import 'package:user/view/base/product_bottom_sheet.dart';
// import 'package:user/view/base/quantity_button.dart';
// import 'package:user/view/base/rating_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class CartProductWidget extends StatelessWidget {
//   final CartModel cart;
//   final int cartIndex;
//   final List<AddOns> addOns;
//   final bool isAvailable;
//   const CartProductWidget({Key? key, required this.cart, required this.cartIndex, required this.isAvailable, required this.addOns}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     String addOnText = '';
//     int index0 = 0;
//     List<int?> ids = [];
//     List<int?> qtys = [];
//     for (var addOn in cart.addOnIds!) {
//       ids.add(addOn.id);
//       qtys.add(addOn.quantity);
//     }
//     for (var addOn in cart.product!.addOns!) {
//       if (ids.contains(addOn.id)) {
//         addOnText = '$addOnText${(index0 == 0) ? '' : ',  '}${addOn.name} (${qtys[index0]})';
//         index0 = index0 + 1;
//       }
//     }
//
//     String variationText = '';
//
//     if(cart.variations!.isNotEmpty) {
//       for(int index=0; index<cart.variations!.length; index++) {
//         if(cart.variations![index].isNotEmpty && cart.variations![index].contains(true)) {
//           variationText += '${variationText.isNotEmpty ? ', ' : ''}${cart.product!.variations![index].name} (';
//
//           for(int i=0; i<cart.variations![index].length; i++) {
//             if(cart.variations![index][i]!) {
//               variationText += '${variationText.endsWith('(') ? '' : ', '}${cart.product!.variations![index].variationValues![i].level}';
//             }
//           }
//           variationText += ')';
//         }
//       }
//     }
//
//     return Padding(
//       padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
//       child: InkWell(
//         onTap: () {
//           ResponsiveHelper.isMobile(context) ? showModalBottomSheet(
//             context: context,
//             isScrollControlled: true,
//             backgroundColor: Colors.transparent,
//             builder: (con) => ProductBottomSheet(product: cart.product, cartIndex: cartIndex, cart: cart),
//           ) : showDialog(context: context, builder: (con) => Dialog(
//             child: ProductBottomSheet(product: cart.product, cartIndex: cartIndex, cart: cart),
//           ));
//         },
//         child: Container(
//           decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
//           child: Stack(children: [
//             const Positioned(
//               top: 0, bottom: 0, right: 0, left: 0,
//               child: Icon(Icons.delete, color: Colors.white, size: 50),
//             ),
//             Dismissible(
//               key: UniqueKey(),
//               onDismissed: (DismissDirection direction) => Get.find<CartController>().removeFromCart(cartIndex),
//               child: Container(
//                 padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall, horizontal: Dimensions.paddingSizeSmall),
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).cardColor,
//                   borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
//                   boxShadow: [BoxShadow(
//                     color: Colors.grey[Get.isDarkMode ? 800 : 200]!,
//                     blurRadius: 5, spreadRadius: 1,
//                   )],
//                 ),
//                 child: Column(
//                   children: [
//
//                     Row(children: [
//                       (cart.product!.image != null && cart.product!.image!.isNotEmpty) ? Stack(
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
//                             child: CustomImage(
//                               image: '${Get.find<SplashController>().configModel!.baseUrls!.productImageUrl}/${cart.product!.image}',
//                               height: 65, width: 70, fit: BoxFit.cover,
//                             ),
//                           ),
//                           isAvailable ? const SizedBox() : Positioned(
//                             top: 0, left: 0, bottom: 0, right: 0,
//                             child: Container(
//                               alignment: Alignment.center,
//                               decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), color: Colors.black.withOpacity(0.6)),
//                               child: Text('not_available_now_break'.tr, textAlign: TextAlign.center, style: robotoRegular.copyWith(
//                                 color: Colors.white, fontSize: 8,
//                               )),
//                             ),
//                           ),
//                         ],
//                       ) : const SizedBox.shrink(),
//                       const SizedBox(width: Dimensions.paddingSizeSmall),
//
//                       Expanded(
//                         child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
//                           Text(
//                             cart.product!.name!,
//                             style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
//                             maxLines: 2, overflow: TextOverflow.ellipsis,
//                           ),
//                           const SizedBox(height: 2),
//                           RatingBar(rating: cart.product!.avgRating, size: 12, ratingCount: cart.product!.ratingCount),
//                           const SizedBox(height: 5),
//                           Row(children: [
//                             Text(
//                               PriceConverter.convertPrice(cart.discountedPrice), textDirection: TextDirection.ltr,
//                               style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
//                             ),
//                             const SizedBox(width: Dimensions.paddingSizeExtraSmall),
//
//                             cart.discountedPrice!+cart.discountAmount! > cart.discountedPrice! ? Text(
//                               PriceConverter.convertPrice(cart.discountedPrice!+cart.discountAmount!), textDirection: TextDirection.ltr,
//                               style: robotoMedium.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall, decoration: TextDecoration.lineThrough),
//                             ) : const SizedBox(),
//                           ]),
//                         ]),
//                       ),
//
//                       Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//                         Get.find<SplashController>().configModel!.toggleVegNonVeg! ? Container(
//                           padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall, horizontal: Dimensions.paddingSizeSmall),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
//                             color: Theme.of(context).primaryColor,
//                           ),
//                           child: Text(
//                             cart.product!.veg == 0 ? 'non_veg'.tr : 'veg'.tr,
//                             style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Colors.white),
//                           ),
//                         ) : const SizedBox(),
//                         SizedBox(height: Get.find<SplashController>().configModel!.toggleVegNonVeg! ? Dimensions.paddingSizeExtraSmall : 0),
//                         Row(children: [
//                           QuantityButton(
//                             onTap: () {
//                               if (cart.quantity! > 1) {
//                                 Get.find<CartController>().setQuantity(false, cart);
//                               }else {
//                                 Get.find<CartController>().removeFromCart(cartIndex);
//                               }
//                             },
//                             isIncrement: false,
//                           ),
//                           Text(cart.quantity.toString(), style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge)),
//                           QuantityButton(
//                             onTap: () => Get.find<CartController>().setQuantity(true, cart),
//                             isIncrement: true,
//                           ),
//                         ]),
//                       ]),
//
//                       !ResponsiveHelper.isMobile(context) ? Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
//                         child: IconButton(
//                           onPressed: () {
//                             Get.find<CartController>().removeFromCart(cartIndex);
//                           },
//                           icon: const Icon(Icons.delete, color: Colors.red),
//                         ),
//                       ) : const SizedBox(),
//
//                     ]),
//
//                     addOnText.isNotEmpty ? Padding(
//                       padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
//                       child: Row(children: [
//                         const SizedBox(width: 80),
//                         Text('${'addons'.tr}: ', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
//                         Flexible(child: Text(
//                           addOnText, textDirection: TextDirection.ltr,
//                           style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
//                         )),
//                       ]),
//                     ) : const SizedBox(),
//
//                     (variationText != '' && cart.product!.variations != null && cart.product!.variations!.isNotEmpty) ? Padding(
//                       padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
//                       child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                         const SizedBox(width: 80),
//                         Text('${'variations'.tr}: ', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall), textDirection: TextDirection.ltr),
//                         Flexible(child: Text(variationText, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),
//                         ),
//                       ]),
//                     ) : const SizedBox(),
//
//                   ],
//                 ),
//               ),
//             ),
//           ]),
//         ),
//       ),
//     );
//   }
// }

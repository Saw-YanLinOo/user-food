import 'package:user/controller/restaurant_controller.dart';
import 'package:user/controller/splash_controller.dart';
import 'package:user/controller/theme_controller.dart';
import 'package:user/helper/responsive_helper.dart';
import 'package:user/helper/route_helper.dart';
import 'package:user/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../../../controller/auth_controller.dart';
import '../../../../../controller/localization_controller.dart';
import '../../../../../controller/wishlist_controller.dart';
import '../../../../../util/images.dart';
import '../../../../../util/styles.dart';
import '../../../../base/custom_image.dart';
import '../../../../base/custom_snackbar.dart';
import '../../../restaurant/restaurant_screen.dart';
import '../new/icon_with_text_row_widget.dart';

class AllRestaurantScreen extends StatelessWidget {
  const AllRestaurantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RestaurantController>(builder: (restaurantController) {
      return (restaurantController.restaurantModel != null &&
              restaurantController.restaurantModel!.restaurants!.isEmpty)
          ? const SizedBox()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                Container(
                  width: Dimensions.webMaxWidth,
                  decoration: BoxDecoration(
                   
                    borderRadius: BorderRadius.all(Radius.circular(
                        ResponsiveHelper.isMobile(context)
                            ? 0
                            : Dimensions.radiusSmall)),
                  ),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          restaurantController.restaurantModel != null
                              ? ResponsiveHelper.isMobile(context)
                                  ?
                                   Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20.0),
                                      child: SizedBox(
                                        height: 180,
                                        child: ListView.builder(
                                          itemCount: restaurantController
                                              .restaurantModel!
                                              .restaurants!
                                              .length,
                                          padding: EdgeInsets.only(
                                              right: ResponsiveHelper.isMobile(
                                                      context)
                                                  ? Dimensions
                                                      .paddingSizeDefault
                                                  : 0),
                                          scrollDirection: Axis.horizontal,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            bool isAvailable =
                                                restaurantController
                                                            .restaurantModel!
                                                            .restaurants![index]
                                                            .open ==
                                                        1 &&
                                                    restaurantController
                                                        .restaurantModel!
                                                        .restaurants![index]
                                                        .active!;
                                            bool isHomeDelivery =
                                                restaurantController
                                                        .restaurantModel!
                                                        .restaurants![index]
                                                        .delivery ==
                                                    true;
                                            return AnimationConfiguration
                                                .staggeredList(
                                              position: index,
                                              duration:
                                                  const Duration(seconds: 2),
                                              child: SlideAnimation(
                                                horizontalOffset: 200,
                                                child: FadeInAnimation(
                                                  child: InkWell(
                                                    onTap: () => Get.toNamed(
                                                      RouteHelper.getRestaurantRoute(
                                                          restaurantController
                                                              .restaurantModel!
                                                              .restaurants![
                                                                  index]
                                                              .id),
                                                      arguments: RestaurantScreen(
                                                          restaurant:
                                                              restaurantController
                                                                  .restaurantModel!
                                                                  .restaurants![index]),
                                                    ),
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: (ResponsiveHelper
                                                                      .isDesktop(
                                                                          context) &&
                                                                  index == 0 &&
                                                                  Get.find<
                                                                          LocalizationController>()
                                                                      .isLtr)
                                                              ? 0
                                                              : Dimensions
                                                                  .paddingSizeDefault),
                                                      child: Container(
                                                        height: 172,
                                                        width: 253,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Theme.of(context)
                                                                  .cardColor,
                                                          borderRadius: BorderRadius
                                                              .circular(Dimensions
                                                                  .radiusDefault),
                                                        ),
                                                        child: Stack(
                                                          clipBehavior:
                                                              Clip.none,
                                                          children: [
                                                            Container(
                                                              height: 85,
                                                              width: 253,
                                                              decoration:
                                                                  const BoxDecoration(
                                                                borderRadius: BorderRadius.only(
                                                                    topLeft: Radius.circular(
                                                                        Dimensions
                                                                            .radiusDefault),
                                                                    topRight: Radius.circular(
                                                                        Dimensions
                                                                            .radiusDefault)),
                                                              ),
                                                              child: ClipRRect(
                                                                borderRadius: const BorderRadius
                                                                        .only(
                                                                    topLeft: Radius.circular(
                                                                        Dimensions
                                                                            .radiusDefault),
                                                                    topRight: Radius.circular(
                                                                        Dimensions
                                                                            .radiusDefault)),
                                                                child: Stack(
                                                                  children: [
                                                                    CustomImage(
                                                                      placeholder:
                                                                          Images
                                                                              .placeholder,
                                                                      image:
                                                                          '${Get.find<SplashController>().configModel!.baseUrls!.restaurantCoverPhotoUrl}'
                                                                          '/${restaurantController.restaurantModel!.restaurants![index].coverPhoto}',
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      height:
                                                                          83,
                                                                      width:
                                                                          253,
                                                                    ),
                                                                    !isAvailable
                                                                        ? Positioned(
                                                                            top:
                                                                                0,
                                                                            left:
                                                                                0,
                                                                            right:
                                                                                0,
                                                                            bottom:
                                                                                0,
                                                                            child:
                                                                                Container(
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(Dimensions.radiusDefault), topRight: Radius.circular(Dimensions.radiusDefault)),
                                                                                color: Colors.black.withOpacity(0.3),
                                                                              ),
                                                                            ),
                                                                          )
                                                                        : const SizedBox(),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            !isAvailable
                                                                ? Positioned(
                                                                    top: 10,
                                                                    left: 60,
                                                                    child:
                                                                        Container(
                                                                      decoration: BoxDecoration(
                                                                          color: Theme.of(context)
                                                                              .colorScheme
                                                                              .error
                                                                              .withOpacity(
                                                                                  0.5),
                                                                          borderRadius:
                                                                              BorderRadius.circular(Dimensions.radiusLarge)),
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal: Dimensions
                                                                              .fontSizeExtraLarge,
                                                                          vertical:
                                                                              Dimensions.paddingSizeExtraSmall),
                                                                      child: Row(
                                                                          children: [
                                                                            Icon(Icons.access_time,
                                                                                size: 12,
                                                                                color: Theme.of(context).cardColor),
                                                                            const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                                                            Text('closed_now'.tr,
                                                                                style: robotoMedium.copyWith(color: Theme.of(context).cardColor, fontSize: Dimensions.fontSizeSmall)),
                                                                          ]),
                                                                    ))
                                                                : const SizedBox(),
                                                            !isHomeDelivery
                                                                ? Positioned(
                                                                    top: 40,
                                                                    left: 60,
                                                                    child:
                                                                        Container(
                                                                      decoration: BoxDecoration(
                                                                          color: Theme.of(context)
                                                                              .colorScheme
                                                                              .error
                                                                              .withOpacity(
                                                                                  0.5),
                                                                          borderRadius:
                                                                              BorderRadius.circular(Dimensions.radiusLarge)),
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal: Dimensions
                                                                              .fontSizeExtraLarge,
                                                                          vertical:
                                                                              Dimensions.paddingSizeExtraSmall),
                                                                      child: Row(
                                                                          children: [
                                                                            Icon(Icons.assist_walker,
                                                                                size: 12,
                                                                                color: Theme.of(context).cardColor),
                                                                            const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                                                            Text('to go to the shop'.tr,
                                                                                style: robotoMedium.copyWith(color: Theme.of(context).cardColor, fontSize: Dimensions.fontSizeSmall)),
                                                                          ]),
                                                                    ))
                                                                : const SizedBox(),
                                                            Positioned(
                                                              top: 90,
                                                              left: 75,
                                                              right: 0,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                      restaurantController
                                                                          .restaurantModel!
                                                                          .restaurants![
                                                                              index]
                                                                          .name!,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      maxLines:
                                                                          1,
                                                                      style: robotoMedium.copyWith(
                                                                          fontWeight:
                                                                              FontWeight.w600)),
                                                                 
                                                                  Text(
                                                                      restaurantController
                                                                          .restaurantModel!
                                                                          .restaurants![
                                                                              index]
                                                                          .address!,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      maxLines:
                                                                          1,
                                                                      style: robotoRegular.copyWith(
                                                                          fontSize: Dimensions
                                                                              .fontSizeSmall,
                                                                          color:
                                                                              Theme.of(context).disabledColor)),
                                                                ],
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height: Dimensions
                                                                    .paddingSizeSmall),
                                                            Positioned(
                                                              bottom: 0.5,
                                                              left: 0,
                                                              right: 0,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  IconWithTextRowWidget(
                                                                    icon: Icons
                                                                        .star_border,
                                                                    text: restaurantController
                                                                        .restaurantModel!
                                                                        .restaurants![
                                                                            index]
                                                                        .avgRating!
                                                                        .toStringAsFixed(
                                                                            1),
                                                                    style: robotoBold.copyWith(
                                                                        fontSize:
                                                                            Dimensions.fontSizeSmall),
                                                                  ),
                                                                  const SizedBox(
                                                                      width: Dimensions
                                                                          .paddingSizeDefault),
                                                                  restaurantController
                                                                          .restaurantModel!
                                                                          .restaurants![
                                                                              index]
                                                                          .freeDelivery!
                                                                      ? ImageWithTextRowWidget(
                                                                          widget: Image.asset(
                                                                              Images.deliveryIcon,
                                                                              height: 20,
                                                                              width: 20),
                                                                          text:
                                                                              'free'.tr,
                                                                          style:
                                                                              robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                                                                        )
                                                                      : const SizedBox(),
                                                                  restaurantController
                                                                          .restaurantModel!
                                                                          .restaurants![
                                                                              index]
                                                                          .freeDelivery!
                                                                      ? const SizedBox(
                                                                          width:
                                                                              Dimensions.paddingSizeDefault)
                                                                      : const SizedBox(),
                                                                  IconWithTextRowWidget(
                                                                    icon: Icons
                                                                        .access_time_outlined,
                                                                    text:
                                                                        '${restaurantController.restaurantModel!.restaurants![index].deliveryTime}',
                                                                    style: robotoRegular.copyWith(
                                                                        fontSize:
                                                                            Dimensions.fontSizeSmall),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Positioned(
                                                              top: Dimensions
                                                                  .paddingSizeSmall,
                                                              right: Dimensions
                                                                  .paddingSizeSmall,
                                                              child: GetBuilder<
                                                                      WishListController>(
                                                                  builder:
                                                                      (wishController) {
                                                                bool isWished = wishController
                                                                    .wishRestIdList
                                                                    .contains(restaurantController
                                                                        .restaurantModel!
                                                                        .restaurants![
                                                                            index]
                                                                        .id);
                                                                return InkWell(
                                                                  onTap: () {
                                                                    if (Get.find<
                                                                            AuthController>()
                                                                        .isLoggedIn()) {
                                                                      isWished
                                                                          ? wishController.removeFromWishList(
                                                                              restaurantController.restaurantModel!.restaurants![index].id,
                                                                              true)
                                                                          : wishController.addToWishList(null, restaurantController.restaurantModel!.restaurants![index], true);
                                                                    } else {
                                                                      showCustomSnackBar(
                                                                          'you_are_not_logged_in'
                                                                              .tr);
                                                                    }
                                                                  },
                                                                  child: Icon(
                                                                      isWished
                                                                          ? Icons
                                                                              .favorite
                                                                          : Icons
                                                                              .favorite_border,
                                                                      color: isWished
                                                                          ? Theme.of(context)
                                                                              .primaryColor
                                                                          : Theme.of(context)
                                                                              .disabledColor,
                                                                      size: 20),
                                                                );
                                                              }),
                                                            ),
                                                            // Positioned(
                                                            //   top: 63,
                                                            //   right: 12,
                                                            //   child: Container(
                                                            //     height: 23,
                                                            //     decoration:
                                                            //         BoxDecoration(
                                                            //       borderRadius: const BorderRadius
                                                            //               .only(
                                                            //           topLeft: Radius.circular(
                                                            //               Dimensions
                                                            //                   .radiusDefault),
                                                            //           topRight:
                                                            //               Radius.circular(
                                                            //                   Dimensions.radiusDefault)),
                                                            //       color: Theme.of(
                                                            //               context)
                                                            //           .cardColor,
                                                            //     ),
                                                            //     padding: const EdgeInsets
                                                            //             .symmetric(
                                                            //         horizontal:
                                                            //             Dimensions
                                                            //                 .paddingSizeExtraSmall),
                                                            //     child: Center(
                                                            //       child: Text(
                                                            //         '${Get.find<LocationController>().getRestaurantDistance(
                                                            //               LatLng(
                                                            //                   double.parse(restaurantController.restaurantModel!.restaurants![index].latitude!),
                                                            //                   double.parse(restaurantController.restaurantModel!.restaurants![index].longitude!)),
                                                            //             ).toStringAsFixed(2)} ${'km'.tr}',
                                                            //         style: robotoMedium.copyWith(
                                                            //             fontSize:
                                                            //                 Dimensions
                                                            //                     .fontSizeSmall,
                                                            //             color: Theme.of(context)
                                                            //                 .primaryColor),
                                                            //       ),
                                                            //     ),
                                                            //   ),
                                                            // ),
                                                            Positioned(
                                                              top: 60,
                                                              left: Dimensions
                                                                  .paddingSizeSmall,
                                                              child: Container(
                                                                height: 58,
                                                                width: 58,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .cardColor,
                                                                  border: Border.all(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .cardColor
                                                                          .withOpacity(
                                                                              0.2),
                                                                      width: 3),
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          Dimensions
                                                                              .radiusSmall),
                                                                ),
                                                                child:
                                                                    ClipRRect(
                                                                  child:
                                                                      CustomImage(
                                                                    placeholder:
                                                                        Images
                                                                            .placeholder,
                                                                    image:
                                                                        '${Get.find<SplashController>().configModel!.baseUrls!.restaurantImageUrl}'
                                                                        '/${restaurantController.restaurantModel!.restaurants![index].logo}',
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    height: 58,
                                                                    width: 58,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    )

                                  //   SizedBox(
                                  //       height:
                                  //           MediaQuery.of(context).size.height /
                                  //               5.5,
                                  //       child: AnimationLimiter(
                                  //         child: ListView.builder(
                                  //           scrollDirection: Axis.horizontal,
                                  //           padding: const EdgeInsets.only(
                                  //               left:
                                  //                   Dimensions.paddingSizeDefault,
                                  //               right:
                                  //                   Dimensions.paddingSizeDefault,
                                  //               bottom: Dimensions
                                  //                   .paddingSizeDefault),
                                  //           physics:
                                  //               const BouncingScrollPhysics(),
                                  //           itemCount: restaurantController
                                  //               .restaurantModel!
                                  //               .restaurants!
                                  //               .length,
                                  //           shrinkWrap: true,
                                  //           itemBuilder: (context, index) {
                                  //             return AnimationConfiguration
                                  //                 .staggeredList(
                                  //                     position: index,
                                  //                     duration: const Duration(
                                  //                         seconds: 6),
                                  //                     child: SlideAnimation(
                                  //                       horizontalOffset: 200,
                                  //                       child: FadeInAnimation(
                                  //                         child: InkWell(
                                  //                           onTap: () =>
                                  //                               Get.toNamed(
                                  //                             RouteHelper.getRestaurantRoute(
                                  //                                 restaurantController
                                  //                                     .restaurantModel!
                                  //                                     .restaurants![
                                  //                                         index]
                                  //                                     .id),
                                  //                             arguments: RestaurantScreen(
                                  //                                 restaurant: restaurantController
                                  //                                     .restaurantModel!
                                  //                                     .restaurants![index]),
                                  //                           ),
                                  //                           child: RestaurantCart(
                                  //                             image:
                                  //                                 '${Get.find<SplashController>().configModel!.baseUrls!.restaurantImageUrl}'
                                  //                                 '/${restaurantController.restaurantModel!.restaurants![index].logo}',
                                  //                             name: restaurantController
                                  //                                 .restaurantModel!
                                  //                                 .restaurants![
                                  //                                     index]
                                  //                                 .name!,
                                  //                           ),
                                  //                         ),
                                  //                       ),
                                  //                     ));
                                  //           },
                                  //         ),
                                  //       ),
                                  //     )
                                  //  /

                                  : //web view
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20.0),
                                      child: SizedBox(
                                        height: 180,
                                        child: ListView.builder(
                                          itemCount: restaurantController
                                              .restaurantModel!
                                              .restaurants!
                                              .length,
                                          padding: EdgeInsets.only(
                                              right: ResponsiveHelper.isMobile(
                                                      context)
                                                  ? Dimensions
                                                      .paddingSizeDefault
                                                  : 0),
                                          scrollDirection: Axis.horizontal,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            bool isAvailable =
                                                restaurantController
                                                            .restaurantModel!
                                                            .restaurants![index]
                                                            .open ==
                                                        1 &&
                                                    restaurantController
                                                        .restaurantModel!
                                                        .restaurants![index]
                                                        .active!;
                                            bool isHomeDelivery =
                                                restaurantController
                                                        .restaurantModel!
                                                        .restaurants![index]
                                                        .delivery ==
                                                    true;
                                            return AnimationConfiguration
                                                .staggeredList(
                                              position: index,
                                              duration:
                                                  const Duration(seconds: 2),
                                              child: SlideAnimation(
                                                horizontalOffset: 200,
                                                child: FadeInAnimation(
                                                  child: InkWell(
                                                    onTap: () => Get.toNamed(
                                                      RouteHelper.getRestaurantRoute(
                                                          restaurantController
                                                              .restaurantModel!
                                                              .restaurants![
                                                                  index]
                                                              .id),
                                                      arguments: RestaurantScreen(
                                                          restaurant:
                                                              restaurantController
                                                                  .restaurantModel!
                                                                  .restaurants![index]),
                                                    ),
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: (ResponsiveHelper
                                                                      .isDesktop(
                                                                          context) &&
                                                                  index == 0 &&
                                                                  Get.find<
                                                                          LocalizationController>()
                                                                      .isLtr)
                                                              ? 0
                                                              : Dimensions
                                                                  .paddingSizeDefault),
                                                      child: Container(
                                                        height: 172,
                                                        width: 253,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Theme.of(context)
                                                                  .cardColor,
                                                          borderRadius: BorderRadius
                                                              .circular(Dimensions
                                                                  .radiusDefault),
                                                        ),
                                                        child: Stack(
                                                          clipBehavior:
                                                              Clip.none,
                                                          children: [
                                                            Container(
                                                              height: 85,
                                                              width: 253,
                                                              decoration:
                                                                  const BoxDecoration(
                                                                borderRadius: BorderRadius.only(
                                                                    topLeft: Radius.circular(
                                                                        Dimensions
                                                                            .radiusDefault),
                                                                    topRight: Radius.circular(
                                                                        Dimensions
                                                                            .radiusDefault)),
                                                              ),
                                                              child: ClipRRect(
                                                                borderRadius: const BorderRadius
                                                                        .only(
                                                                    topLeft: Radius.circular(
                                                                        Dimensions
                                                                            .radiusDefault),
                                                                    topRight: Radius.circular(
                                                                        Dimensions
                                                                            .radiusDefault)),
                                                                child: Stack(
                                                                  children: [
                                                                    CustomImage(
                                                                      placeholder:
                                                                          Images
                                                                              .placeholder,
                                                                      image:
                                                                          '${Get.find<SplashController>().configModel!.baseUrls!.restaurantCoverPhotoUrl}'
                                                                          '/${restaurantController.restaurantModel!.restaurants![index].coverPhoto}',
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      height:
                                                                          83,
                                                                      width:
                                                                          253,
                                                                    ),
                                                                    !isAvailable
                                                                        ? Positioned(
                                                                            top:
                                                                                0,
                                                                            left:
                                                                                0,
                                                                            right:
                                                                                0,
                                                                            bottom:
                                                                                0,
                                                                            child:
                                                                                Container(
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(Dimensions.radiusDefault), topRight: Radius.circular(Dimensions.radiusDefault)),
                                                                                color: Colors.black.withOpacity(0.3),
                                                                              ),
                                                                            ),
                                                                          )
                                                                        : const SizedBox(),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            !isAvailable
                                                                ? Positioned(
                                                                    top: 10,
                                                                    left: 60,
                                                                    child:
                                                                        Container(
                                                                      decoration: BoxDecoration(
                                                                          color: Theme.of(context)
                                                                              .colorScheme
                                                                              .error
                                                                              .withOpacity(
                                                                                  0.5),
                                                                          borderRadius:
                                                                              BorderRadius.circular(Dimensions.radiusLarge)),
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal: Dimensions
                                                                              .fontSizeExtraLarge,
                                                                          vertical:
                                                                              Dimensions.paddingSizeExtraSmall),
                                                                      child: Row(
                                                                          children: [
                                                                            Icon(Icons.access_time,
                                                                                size: 12,
                                                                                color: Theme.of(context).cardColor),
                                                                            const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                                                            Text('closed_now'.tr,
                                                                                style: robotoMedium.copyWith(color: Theme.of(context).cardColor, fontSize: Dimensions.fontSizeSmall)),
                                                                          ]),
                                                                    ))
                                                                : const SizedBox(),
                                                            !isHomeDelivery
                                                                ? Positioned(
                                                                    top: 40,
                                                                    left: 60,
                                                                    child:
                                                                        Container(
                                                                      decoration: BoxDecoration(
                                                                          color: Theme.of(context)
                                                                              .colorScheme
                                                                              .error
                                                                              .withOpacity(
                                                                                  0.5),
                                                                          borderRadius:
                                                                              BorderRadius.circular(Dimensions.radiusLarge)),
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal: Dimensions
                                                                              .fontSizeExtraLarge,
                                                                          vertical:
                                                                              Dimensions.paddingSizeExtraSmall),
                                                                      child: Row(
                                                                          children: [
                                                                            Icon(Icons.assist_walker,
                                                                                size: 12,
                                                                                color: Theme.of(context).cardColor),
                                                                            const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                                                            Text('to go to the shop'.tr,
                                                                                style: robotoMedium.copyWith(color: Theme.of(context).cardColor, fontSize: Dimensions.fontSizeSmall)),
                                                                          ]),
                                                                    ))
                                                                : const SizedBox(),
                                                            Positioned(
                                                              top: 90,
                                                              left: 75,
                                                              right: 0,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                      restaurantController
                                                                          .restaurantModel!
                                                                          .restaurants![
                                                                              index]
                                                                          .name!,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      maxLines:
                                                                          1,
                                                                      style: robotoMedium.copyWith(
                                                                          fontWeight:
                                                                              FontWeight.w600)),
                                                                  // const SizedBox(
                                                                  //     height: Dimensions
                                                                  //         .paddingSizeSmall),
                                                                  Text(
                                                                      restaurantController
                                                                          .restaurantModel!
                                                                          .restaurants![
                                                                              index]
                                                                          .address!,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      maxLines:
                                                                          1,
                                                                      style: robotoRegular.copyWith(
                                                                          fontSize: Dimensions
                                                                              .fontSizeSmall,
                                                                          color:
                                                                              Theme.of(context).disabledColor)),
                                                                ],
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height: Dimensions
                                                                    .paddingSizeSmall),
                                                            Positioned(
                                                              bottom: 0.5,
                                                              left: 0,
                                                              right: 0,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  IconWithTextRowWidget(
                                                                    icon: Icons
                                                                        .star_border,
                                                                    text: restaurantController
                                                                        .restaurantModel!
                                                                        .restaurants![
                                                                            index]
                                                                        .avgRating!
                                                                        .toStringAsFixed(
                                                                            1),
                                                                    style: robotoBold.copyWith(
                                                                        fontSize:
                                                                            Dimensions.fontSizeSmall),
                                                                  ),
                                                                  const SizedBox(
                                                                      width: Dimensions
                                                                          .paddingSizeDefault),
                                                                  restaurantController
                                                                          .restaurantModel!
                                                                          .restaurants![
                                                                              index]
                                                                          .freeDelivery!
                                                                      ? ImageWithTextRowWidget(
                                                                          widget: Image.asset(
                                                                              Images.deliveryIcon,
                                                                              height: 20,
                                                                              width: 20),
                                                                          text:
                                                                              'free'.tr,
                                                                          style:
                                                                              robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                                                                        )
                                                                      : const SizedBox(),
                                                                  restaurantController
                                                                          .restaurantModel!
                                                                          .restaurants![
                                                                              index]
                                                                          .freeDelivery!
                                                                      ? const SizedBox(
                                                                          width:
                                                                              Dimensions.paddingSizeDefault)
                                                                      : const SizedBox(),
                                                                  IconWithTextRowWidget(
                                                                    icon: Icons
                                                                        .access_time_outlined,
                                                                    text:
                                                                        '${restaurantController.restaurantModel!.restaurants![index].deliveryTime}',
                                                                    style: robotoRegular.copyWith(
                                                                        fontSize:
                                                                            Dimensions.fontSizeSmall),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Positioned(
                                                              top: Dimensions
                                                                  .paddingSizeSmall,
                                                              right: Dimensions
                                                                  .paddingSizeSmall,
                                                              child: GetBuilder<
                                                                      WishListController>(
                                                                  builder:
                                                                      (wishController) {
                                                                bool isWished = wishController
                                                                    .wishRestIdList
                                                                    .contains(restaurantController
                                                                        .restaurantModel!
                                                                        .restaurants![
                                                                            index]
                                                                        .id);
                                                                return InkWell(
                                                                  onTap: () {
                                                                    if (Get.find<
                                                                            AuthController>()
                                                                        .isLoggedIn()) {
                                                                      isWished
                                                                          ? wishController.removeFromWishList(
                                                                              restaurantController.restaurantModel!.restaurants![index].id,
                                                                              true)
                                                                          : wishController.addToWishList(null, restaurantController.restaurantModel!.restaurants![index], true);
                                                                    } else {
                                                                      showCustomSnackBar(
                                                                          'you_are_not_logged_in'
                                                                              .tr);
                                                                    }
                                                                  },
                                                                  child: Icon(
                                                                      isWished
                                                                          ? Icons
                                                                              .favorite
                                                                          : Icons
                                                                              .favorite_border,
                                                                      color: isWished
                                                                          ? Theme.of(context)
                                                                              .primaryColor
                                                                          : Theme.of(context)
                                                                              .disabledColor,
                                                                      size: 20),
                                                                );
                                                              }),
                                                            ),
                                                            // Positioned(
                                                            //   top: 63,
                                                            //   right: 12,
                                                            //   child: Container(
                                                            //     height: 23,
                                                            //     decoration:
                                                            //         BoxDecoration(
                                                            //       borderRadius: const BorderRadius
                                                            //               .only(
                                                            //           topLeft: Radius.circular(
                                                            //               Dimensions
                                                            //                   .radiusDefault),
                                                            //           topRight:
                                                            //               Radius.circular(
                                                            //                   Dimensions.radiusDefault)),
                                                            //       color: Theme.of(
                                                            //               context)
                                                            //           .cardColor,
                                                            //     ),
                                                            //     padding: const EdgeInsets
                                                            //             .symmetric(
                                                            //         horizontal:
                                                            //             Dimensions
                                                            //                 .paddingSizeExtraSmall),
                                                            //     child: Center(
                                                            //       child: Text(
                                                            //         '${Get.find<LocationController>().getRestaurantDistance(
                                                            //               LatLng(
                                                            //                   double.parse(restaurantController.restaurantModel!.restaurants![index].latitude!),
                                                            //                   double.parse(restaurantController.restaurantModel!.restaurants![index].longitude!)),
                                                            //             ).toStringAsFixed(2)} ${'km'.tr}',
                                                            //         style: robotoMedium.copyWith(
                                                            //             fontSize:
                                                            //                 Dimensions
                                                            //                     .fontSizeSmall,
                                                            //             color: Theme.of(context)
                                                            //                 .primaryColor),
                                                            //       ),
                                                            //     ),
                                                            //   ),
                                                            // ),
                                                            Positioned(
                                                              top: 60,
                                                              left: Dimensions
                                                                  .paddingSizeSmall,
                                                              child: Container(
                                                                height: 58,
                                                                width: 58,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .cardColor,
                                                                  border: Border.all(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .cardColor
                                                                          .withOpacity(
                                                                              0.2),
                                                                      width: 3),
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          Dimensions
                                                                              .radiusSmall),
                                                                ),
                                                                child:
                                                                    ClipRRect(
                                                                  child:
                                                                      CustomImage(
                                                                    placeholder:
                                                                        Images
                                                                            .placeholder,
                                                                    image:
                                                                        '${Get.find<SplashController>().configModel!.baseUrls!.restaurantImageUrl}'
                                                                        '/${restaurantController.restaurantModel!.restaurants![index].logo}',
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    height: 58,
                                                                    width: 58,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    )
                              : const CuisineShimmer()
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
    });
  }
}

class CuisineShimmer extends StatelessWidget {
  const CuisineShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.only(
          left: Dimensions.paddingSizeDefault,
          right: Dimensions.paddingSizeDefault,
          bottom: Dimensions.paddingSizeDefault),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 6,
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: Dimensions.paddingSizeDefault,
        crossAxisSpacing: Dimensions.paddingSizeDefault,
      ),
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(Dimensions.paddingSizeSmall),
              bottomRight: Radius.circular(Dimensions.paddingSizeSmall)),
          child: Shimmer(
            duration: const Duration(seconds: 2),
            enabled: true,
            child: Stack(
              children: [
                Positioned(
                  bottom: -55,
                  left: 0,
                  right: 0,
                  child: Transform.rotate(
                    angle: 40,
                    child: Container(
                      height: 120,
                      width: 120,
                      color: Theme.of(context).cardColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[
                            Get.find<ThemeController>().darkTheme ? 700 : 300],
                        borderRadius: BorderRadius.circular(50)),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Container(
                          height: 100,
                          width: 100,
                          color: Colors.grey[
                              Get.find<ThemeController>().darkTheme
                                  ? 700
                                  : 300],
                        )),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    alignment: Alignment.center,
                    height: 30,
                    width: 120,
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeExtraSmall),
                    decoration: BoxDecoration(
                      color: Colors.grey[
                          Get.find<ThemeController>().darkTheme ? 700 : 300],
                      borderRadius: const BorderRadius.only(
                          bottomLeft:
                              Radius.circular(Dimensions.paddingSizeSmall),
                          bottomRight:
                              Radius.circular(Dimensions.paddingSizeSmall)),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

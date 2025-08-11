// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:io';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user/controller/auth_controller.dart';
import 'package:user/controller/cart_controller.dart';
import 'package:user/controller/coupon_controller.dart';
import 'package:user/controller/localization_controller.dart';
import 'package:user/controller/location_controller.dart';
import 'package:user/controller/order_controller.dart';
import 'package:user/controller/restaurant_controller.dart';
import 'package:user/controller/splash_controller.dart';
import 'package:user/controller/user_controller.dart';
import 'package:user/data/model/body/place_order_body.dart';
import 'package:user/data/model/response/address_model.dart';
import 'package:user/data/model/response/cart_model.dart';
import 'package:user/data/model/response/order_model.dart';
import 'package:user/data/model/response/product_model.dart';
import 'package:user/data/model/response/zone_response_model.dart';
import 'package:user/helper/date_converter.dart';
import 'package:user/helper/price_converter.dart';
import 'package:user/helper/responsive_helper.dart';
import 'package:user/helper/route_helper.dart';
import 'package:user/util/app_constants.dart';
import 'package:user/util/colors.dart';
import 'package:user/util/dimensions.dart';
import 'package:user/util/images.dart';
import 'package:user/util/styles.dart';
import 'package:user/view/base/custom_button.dart';
import 'package:user/view/base/custom_dropdown.dart';
import 'package:user/view/base/custom_snackbar.dart';
import 'package:user/view/base/custom_text_field.dart';
import 'package:user/view/screens/address/widget/address_widget.dart';
import 'package:user/view/screens/cart/widget/delivery_option_button.dart';
import 'package:user/view/screens/checkout/widget/condition_check_box.dart';
import 'package:user/view/screens/checkout/widget/coupon_bottom_sheet.dart';
import 'package:user/view/screens/checkout/widget/delivery_instruction_view.dart';
import 'package:user/view/screens/checkout/widget/order_type_widget.dart';
import 'package:user/view/screens/checkout/widget/payment_method_bottom_sheet.dart';
import 'package:user/view/screens/checkout/widget/subscription_view.dart';
import 'package:user/view/screens/checkout/widget/time_slot_bottom_sheet.dart';
import 'package:user/view/screens/checkout/widget/tips_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:lottie/lottie.dart';
import 'package:universal_html/html.dart' as html;
import 'package:user/view/widgets/custom_button.dart';

import '../../../helper/auth_helper.dart';
import '../../base/not_logged_in_screen.dart';
import '../../widgets/custom_text.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartModel>? cartList;

  final Product? product;
  final bool fromCart;
  final String tableId;
  const CheckoutScreen({
    super.key,
    this.cartList,
    this.product,
    required this.fromCart,
    required this.tableId,
  });

  @override
  CheckoutScreenState createState() => CheckoutScreenState();
}

class CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController _couponController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _tipController = TextEditingController();
  final TextEditingController _streetNumberController = TextEditingController();
  final TextEditingController _houseController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();
  final TextEditingController _transitionNo = TextEditingController();
  final TextEditingController _accountName = TextEditingController();
  final FocusNode _streetNode = FocusNode();
  final FocusNode _houseNode = FocusNode();
  
  double? _taxPercent = 0;
  double? _appServiceFeePercent = 0;
  bool? _isOnlinePaymentActive;
  bool? _isCashOnDeliveryActive;
  bool? _isDigitalPaymentActive;
  bool _isWalletActive = false;
  final List<CartModel> _cartList = [];

  List<AddressModel> address = [];
  bool firstTime = true;
  final tooltipController1 = JustTheController();
  final tooltipController2 = JustTheController();
  final tooltipController3 = JustTheController();

  @override
  void initState() {
    super.initState();

    initCall();
  }

  void initCall() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if ((int.tryParse(widget.tableId) ?? 0) > 0) {
        Get.find<OrderController>().orderType = "dine_in";

        _streetNumberController.text = "Table no:${widget.tableId}";
      }
      Get.find<LocationController>().getZone(
          Get.find<LocationController>().getUserAddress()!.latitude,
          Get.find<LocationController>().getUserAddress()!.longitude,
          false,
          updateInAddress: true);
      _isCashOnDeliveryActive =
          Get.find<SplashController>().configModel!.cashOnDelivery;
      _isDigitalPaymentActive =
          Get.find<SplashController>().configModel!.digitalPayment;
      _isWalletActive =
          Get.find<SplashController>().configModel!.customerWalletStatus == 1;
      _isOnlinePaymentActive = Get.find<SplashController>().configModel!.kpay;
      Get.find<OrderController>().setPaymentMethod(
          _isCashOnDeliveryActive!
              ? 0
              : _isDigitalPaymentActive!
                  ? 1
                  : _isWalletActive
                      ? 2
                      : 3,
          isUpdate: false);
      // _cartList = [];
      widget.fromCart
          ? _cartList.addAll(Get.find<CartController>().cartList)
          : _cartList.addAll(widget.cartList!);
      
      // print(
      //     "CartListId${Get.find<CartController>().cartList.first.product!.id}");
      Get.find<RestaurantController>()
          .initCheckoutData(_cartList[0].product!.restaurantId);

      // Get.find<OrderController>().updateTips(
      //   Get.find<AuthController>().getDmTipIndex().isNotEmpty
      //       ? int.parse(Get.find<AuthController>().getDmTipIndex())
      //       : 0,
      //   notify: false,
      // );
      _tipController.text = Get.find<OrderController>().selectedTips != -1
          ? AppConstants.tips[Get.find<OrderController>().selectedTips]
          : '';
      Get.find<CouponController>().setCoupon('');

      // Get.find<RestaurantController>().tableId.value =
      //     _streetNumberController.text;
      Get.find<OrderController>().stopLoader(isUpdate: false);
      Get.find<OrderController>().updateTimeSlot(0, notify: false);

      if (Get.find<AuthController>().isLoggedIn()) {
        if (Get.find<UserController>().userInfoModel == null) {
          Get.find<UserController>().getUserInfo();
        }
        if (Get.find<LocationController>().addressList == null) {
          Get.find<LocationController>().getAddressList();
        }

        Get.find<CouponController>().getCouponList();
      } else if (int.tryParse(widget.tableId) != 0) {
        widget.fromCart
            ? _cartList.addAll(Get.find<CartController>().cartList)
            : _cartList.addAll(widget.cartList!);
        
        Get.find<RestaurantController>()
            .initCheckoutData(_cartList[0].product!.restaurantId);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _streetNumberController.dispose();
    _houseController.dispose();
    _floorController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = Get.find<AuthController>().isLoggedIn();
    bool guestCheckoutPermission = AuthHelper.isGuestLoggedIn();

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
          title: CustomText(text: 'order_confirm'.tr, color: Theme.of(context).disabledColor, fontWeight: FontWeight.bold,fontSize: 14.sp,),
        ),
        body: (int.tryParse(widget.tableId) ?? 0) > 0 ||
                guestCheckoutPermission ||
                isLoggedIn
            ?
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xff3E2723),Color(0xff212121)])
              ),
              child: GetBuilder<LocationController>(builder: (locationController) {
                  return GetBuilder<RestaurantController>(
                      builder: (restController) {
                    bool todayClosed = false;
                    bool tomorrowClosed = false;
                    List<DropdownItem<int>> addressList = [];
                    address=[];
                    addressList.add(DropdownItem<int>(
                        value: 0,
                        child: SizedBox(
                          width: context.width > Dimensions.webMaxWidth
                              ? Dimensions.webMaxWidth - 50
                              : context.width - 50,
                          child: AddressWidget(
                            address:
                                Get.find<LocationController>().getUserAddress(),
                            fromAddress: false,
                            fromCheckout: true,
                          ),
                        )));
                    address.add(locationController.getUserAddress()!);

                    if (restController.restaurant != null) {
                      if (locationController.addressList != null) {
                        for (int index = 0;
                            index < locationController.addressList!.length;
                            index++) {
                          if (locationController.addressList![index].zoneIds!
                              .contains(restController.restaurant!.zoneId)) {
                            address.add(locationController.addressList![index]);

                            addressList.add(DropdownItem<int>(
                                value: index + 1,
                                child: SizedBox(
                                  width: context.width > Dimensions.webMaxWidth
                                      ? Dimensions.webMaxWidth - 50
                                      : context.width - 50,
                                  child: AddressWidget(
                                    address:
                                        locationController.addressList![index],
                                    fromAddress: false,
                                    fromCheckout: true,
                                  ),
                                )));
                          }
                        }
                      }
                      todayClosed = restController.isRestaurantClosed(
                          true,
                          restController.restaurant!.active!,
                          restController.restaurant!.schedules);
                      tomorrowClosed = restController.isRestaurantClosed(
                          false,
                          restController.restaurant!.active!,
                          restController.restaurant!.schedules);
                      _taxPercent = restController.restaurant!.tax;
                      _appServiceFeePercent =
                          restController.restaurant!.appServiceFee;
                    }
                    return GetBuilder<CouponController>(
                        builder: (couponController) {
                      return GetBuilder<OrderController>(
                          builder: (orderController) {
                        ///TODO:

                        if ((int.tryParse(widget.tableId) ?? 0) > 0) {
                          orderController.orderType = "dine_in";
                        }
                        double deliveryCharge = 0;

                        double charge = 0;
                        double? maxCodOrderAmount;
                        if (restController.restaurant != null &&
                            orderController.distance != null &&
                            orderController.distance != -1 &&
                            orderController.orderType == 'delivery') {
                          ZoneData zoneData = Get.find<LocationController>()
                              .getUserAddress()!
                              .zoneData!
                              .firstWhere((data) =>
                                  data.id == restController.restaurant!.zoneId);
                          double perKmCharge =
                              restController.restaurant!.selfDeliverySystem == 1
                                  ? restController
                                      .restaurant!.perKmShippingCharge!
                                  : zoneData.perKmShippingCharge ?? 0;

                          double minimumCharge =
                              restController.restaurant!.selfDeliverySystem == 1
                                  ? restController
                                      .restaurant!.minimumShippingCharge!
                                  : zoneData.minimumShippingCharge ?? 0;

                          double? maximumCharge =
                              restController.restaurant!.selfDeliverySystem == 1
                                  ? restController
                                      .restaurant!.maximumShippingCharge
                                  : zoneData.maximumShippingCharge;
                          //deliveryCharge=3.28*2=6.56
                          double firstdeliveryCharge = orderController.distance! *
                              (perKmCharge) /
                              100; //6.56
                              double discountDeliveryCharge=orderController.distance!>=3?(firstdeliveryCharge-firstdeliveryCharge*0.2):firstdeliveryCharge;
                          double decimalDeliveryCharge = discountDeliveryCharge -
                              discountDeliveryCharge.floor(); //6.56-6=0.56

                          if (decimalDeliveryCharge >= 0.5) {
                            deliveryCharge =
                                discountDeliveryCharge.ceilToDouble() * 100;
                          } else {
                            deliveryCharge =
                                discountDeliveryCharge.floorToDouble() * 100;
                          }

                          // deliveryCharge =
                          //     orderController.distance! * perKmCharge;
                         // charge = orderController.distance! * perKmCharge;

                          charge =
                          deliveryCharge;

                          if (deliveryCharge < minimumCharge) {
                            deliveryCharge = minimumCharge;
                            charge = minimumCharge;
                          }

                          if (restController.restaurant!.selfDeliverySystem ==
                                  0 &&
                              orderController.extraCharge != null) {
                            deliveryCharge =
                                deliveryCharge + orderController.extraCharge!;
                            charge = charge + orderController.extraCharge!;
                          }

                          if (maximumCharge != null &&
                              deliveryCharge > maximumCharge) {
                            deliveryCharge = maximumCharge;
                            charge = maximumCharge;
                          }

                          if (restController.restaurant!.selfDeliverySystem ==
                                  0 &&
                              zoneData.increasedDeliveryFeeStatus == 1) {
                            deliveryCharge = deliveryCharge +
                                (deliveryCharge *
                                    (zoneData.increasedDeliveryFee! / 100));
                            charge = charge +
                                charge * (zoneData.increasedDeliveryFee! / 100);
                          }

                          if (zoneData.maxCodOrderAmount != null) {
                            maxCodOrderAmount = zoneData.maxCodOrderAmount;
                          }
                        }
                        double additionalCharge = Get.find<SplashController>()
                                .configModel!
                                .additionalChargeStatus!
                            ? Get.find<SplashController>()
                                .configModel!
                                .additionCharge!
                            : 0;

                        double price = 0;
                        double? discount = 0;
                        double? couponDiscount = couponController.discount;
                        double tax = 0;
                        double appServiceFee = 0;
                        bool taxIncluded = Get.find<SplashController>()
                                .configModel!
                                .taxIncluded ==
                            1;

                        double addOns = 0;
                        double subTotal = 0;
                        double orderAmount = 0;
                        bool restaurantSubscriptionActive = false;
                        int subscriptionQty =
                            orderController.subscriptionOrder ? 0 : 1;
                        log("charge $charge, deli $deliveryCharge");
                        if (restController.restaurant != null) {
                          restaurantSubscriptionActive = restController
                                  .restaurant!.orderSubscriptionActive! &&
                              widget.fromCart;

                          if (restaurantSubscriptionActive) {
                            if (orderController.subscriptionOrder &&
                                orderController.subscriptionRange != null) {
                              if (orderController.subscriptionType == 'weekly') {
                                List<int> weekDays = [];
                                for (int index = 0;
                                    index < orderController.selectedDays.length;
                                    index++) {
                                  if (orderController.selectedDays[index] !=
                                      null) {
                                    weekDays.add(index + 1);
                                  }
                                }
                                subscriptionQty = DateConverter.getWeekDaysCount(
                                    orderController.subscriptionRange!, weekDays);
                              } else if (orderController.subscriptionType ==
                                  'monthly') {
                                List<int> days = [];
                                for (int index = 0;
                                    index < orderController.selectedDays.length;
                                    index++) {
                                  if (orderController.selectedDays[index] !=
                                      null) {
                                    days.add(index + 1);
                                  }
                                }
                                subscriptionQty = DateConverter.getMonthDaysCount(
                                    orderController.subscriptionRange!, days);
                              } else {
                                subscriptionQty = orderController
                                    .subscriptionRange!.duration.inDays;
                              }
                            }
                          }

                          for (var cartModel in _cartList) {
                            List<AddOns> addOnList = [];
                            for (var addOnId in cartModel.addOnIds!) {
                              for (AddOns addOns in cartModel.product!.addOns!) {
                                if (addOns.id == addOnId.id) {
                                  addOnList.add(addOns);
                                  break;
                                }
                              }
                            }

                            for (int index = 0;
                                index < addOnList.length;
                                index++) {
                              addOns = addOns +
                                  (addOnList[index].price! *
                                      cartModel.addOnIds![index].quantity!);
                            }
                            price =
                                price + (cartModel.price! * cartModel.quantity!);
                            double? dis = (restController.restaurant!.discount !=
                                        null &&
                                    DateConverter.isAvailable(
                                        restController
                                            .restaurant!.discount!.startTime,
                                        restController
                                            .restaurant!.discount!.endTime))
                                ? restController.restaurant!.discount!.discount
                                : cartModel.product!.discount;
                            String? disType =
                                (restController.restaurant!.discount != null &&
                                        DateConverter.isAvailable(
                                            restController
                                                .restaurant!.discount!.startTime,
                                            restController
                                                .restaurant!.discount!.endTime))
                                    ? 'percent'
                                    : cartModel.product!.discountType;
                            discount = discount! +
                                ((cartModel.price! -
                                        PriceConverter.convertWithDiscount(
                                            cartModel.price, dis, disType)!) *
                                    cartModel.quantity!);
                          }
                          if (restController.restaurant != null &&
                              restController.restaurant!.discount != null) {
                            if (restController
                                        .restaurant!.discount!.maxDiscount !=
                                    0 &&
                                restController
                                        .restaurant!.discount!.maxDiscount! <
                                    discount!) {
                              discount = restController
                                  .restaurant!.discount!.maxDiscount;
                            }
                            if (restController
                                        .restaurant!.discount!.minPurchase !=
                                    0 &&
                                restController
                                        .restaurant!.discount!.minPurchase! >
                                    (price + addOns)) {
                              discount = 0;
                            }
                          }
                          price = PriceConverter.toFixed(price);
                          addOns = PriceConverter.toFixed(addOns);
                          discount = PriceConverter.toFixed(discount!);
                          couponDiscount =
                              PriceConverter.toFixed(couponDiscount!);
                          subTotal = price + addOns;
                          orderAmount =
                              (price - discount) + addOns - couponDiscount;

                          if (orderController.orderType != 'delivery' ||
                              restController.restaurant!.freeDelivery! ||
                              (Get.find<SplashController>()
                                          .configModel!
                                          .freeDeliveryOver !=
                                      null &&
                                  orderAmount >=
                                      Get.find<SplashController>()
                                          .configModel!
                                          .freeDeliveryOver!) ||
                              couponController.freeDelivery) {
                            deliveryCharge = 0;
                          }
                        }
                        appServiceFee = PriceConverter.calculation(
                            orderAmount, _appServiceFeePercent, 'percent', 1);
                        // appServiceFee = orderAmount *
                        //     _appServiceFeePercent! /
                        //     (100 + _appServiceFeePercent!);
                        if (taxIncluded) {
                          tax = orderAmount * _taxPercent! / (100 + _taxPercent!);
                        } else {
                          tax = PriceConverter.calculation(
                              orderAmount, _taxPercent, 'percent', 1);
                        }
                        tax = PriceConverter.toFixed(tax);

                        List<String> cartRestaurantList = [];

                        for (var cartItem in _cartList) {
                          String? restaurantName =
                              cartItem.product!.restaurantName;

                          if (!cartRestaurantList.contains(restaurantName)) {
                            cartRestaurantList.add(restaurantName.toString());
                          }
                        }

                       deliveryCharge = cartRestaurantList.isNotEmpty
                            ? PriceConverter.toFixed(deliveryCharge) *
                                cartRestaurantList.length
                            : PriceConverter.toFixed(deliveryCharge);

                        //deliveryCharge = PriceConverter.toFixed(deliveryCharge);
                        //widget.cartList!.first.product!.restaurantName!.length;
                        double total = subTotal +
                            deliveryCharge -
                            discount -
                            couponDiscount! +
                            additionalCharge +
                            (taxIncluded ? 0 : tax) +
                            getServiceFeeDisplayValue(appServiceFee)
                             +
                            orderController.tips;
                        total = PriceConverter.toFixed(total);
                        log("Delivery Options => ${orderController.orderType}");

                        return (orderController.distance != null &&
                                (locationController.addressList != null && !guestCheckoutPermission )&&
                                restController.restaurant != null)
                            ?
                            DefaultTabController(length: 2, child:  Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(5.w),
                                  margin: EdgeInsets.all(15.w),
                           decoration:  BoxDecoration(
                               borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            color: Theme.of(context).cardColor
                            ),
                                  child: TabBar(
                                    indicator: BoxDecoration(
                                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                      color: Color(0xffffe2c6)
                                    ),
                                      indicatorSize: TabBarIndicatorSize.tab,
                                      indicatorColor: Theme.of(context).primaryColor,
                                      indicatorAnimation: TabIndicatorAnimation.elastic,
                                      labelColor: Theme.of(context).primaryColor,
                                      unselectedLabelColor: Theme.of(context).disabledColor,
                                      dividerColor: Colors.transparent,
                                      onTap: (index){
                                        if(index==0) {
                                          orderController.setOrderType("delivery");
                                        }else{
                                          orderController.setOrderType("take_away");
                                        }
                                        orderController.setInstruction(-1);
                                      },
                                      tabs: [
                                    Tab(text: 'home_delivery'.tr),
                                    Tab(text: 'take_away'.tr,),
                                    // Tab(text: 'Dine in'.tr,),
                                  ]),
                                ),
                                Expanded(
                                    child: SingleChildScrollView(
                                      physics: const BouncingScrollPhysics(),
                                      child: Center(
                                        child: SizedBox(
                                          width: Dimensions.webMaxWidth,
                                          child: ResponsiveHelper.isDesktop(context)
                                              ? Padding(
                                            padding: const EdgeInsets.only(
                                                top: Dimensions
                                                    .paddingSizeLarge),
                                            child: Row(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: topSection(
                                                        restController,
                                                        charge,
                                                        deliveryCharge,
                                                        orderController,
                                                        locationController,
                                                        addressList,
                                                        tomorrowClosed,
                                                        todayClosed,
                                                        price,
                                                        discount,
                                                        addOns,
                                                        restaurantSubscriptionActive),
                                                  ),
                                                  const SizedBox(
                                                      width: Dimensions
                                                          .paddingSizeLarge),
                                                  Expanded(
                                                      child: bottomSection(
                                                          orderController,
                                                          total,
                                                          subTotal,
                                                          discount,
                                                          couponController,
                                                          taxIncluded,
                                                          tax,
                                                          appServiceFee,
                                                          additionalCharge,
                                                          deliveryCharge,
                                                          restController,
                                                          locationController,
                                                          todayClosed,
                                                          tomorrowClosed,
                                                          orderAmount,
                                                          maxCodOrderAmount,
                                                          subscriptionQty)),
                                                ]),
                                          )
                                              : Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                /// TopSection
                                                topSection(
                                                    restController,
                                                    charge,
                                                    deliveryCharge,
                                                    orderController,
                                                    locationController,
                                                    addressList,
                                                    tomorrowClosed,
                                                    todayClosed,
                                                    price,
                                                    discount,
                                                    addOns,
                                                    restaurantSubscriptionActive),

                                                ///BottomSection
                                                bottomSection(
                                                    orderController,
                                                    total,
                                                    subTotal,
                                                    discount,
                                                    couponController,
                                                    taxIncluded,
                                                    tax,
                                                    appServiceFee,
                                                    additionalCharge,
                                                    deliveryCharge,
                                                    restController,
                                                    locationController,
                                                    todayClosed,
                                                    tomorrowClosed,
                                                    orderAmount,
                                                    maxCodOrderAmount,
                                                    subscriptionQty),
                                              ]),
                                        ),
                                      ),
                                    )),
                                ResponsiveHelper.isDesktop(context)
                                    ? const SizedBox()
                                    : Container(
                                  padding: EdgeInsets.all(10.h),
                                  decoration: BoxDecoration(
                                    color: gradient1CardColor,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.1),
                                          blurRadius: 10)
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets
                                            .symmetric(
                                            horizontal: Dimensions
                                                .paddingSizeLarge,
                                            vertical: Dimensions
                                                .paddingSizeExtraSmall),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceBetween,
                                            children: [
                                              Text(
                                                'total_amount'.tr,
                                                style: robotoMedium.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeSmall,
                                                    color: Theme.of(
                                                        context)
                                                        .disabledColor),
                                              ),
                                              Container(
                                                padding: EdgeInsets.symmetric(horizontal: 5.w,vertical: 3.h),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(Dimensions.roundRadius),
                                                  color: Theme.of(context).disabledColor
                                                ),
                                                child: PriceConverter
                                                    .convertAnimationPrice(
                                                  total,
                                                  textStyle:
                                                  robotoMedium.copyWith(
                                                      fontSize: Dimensions
                                                          .fontSizeLarge,
                                                      color: Theme.of(
                                                          context)
                                                          .indicatorColor),
                                                ),
                                              ),

                                              // Text(
                                              //   PriceConverter.convertPrice(total), textDirection: TextDirection.ltr,
                                              //   style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor),
                                              // ),
                                            ]),
                                      ),
                                      _orderPlaceButton(
                                          orderController,
                                          restController,
                                          locationController,
                                          todayClosed,
                                          tomorrowClosed,
                                          orderAmount,
                                          deliveryCharge,
                                          tax,
                                          appServiceFee,
                                          discount,
                                          total,
                                          maxCodOrderAmount,
                                          subscriptionQty),
                                    ],
                                  ),
                                ),
                              ],
                            ))

                            : Column(
                                children: [
                                  Expanded(
                                      child: SingleChildScrollView(
                                    physics: const BouncingScrollPhysics(),
                                    child: Center(
                                      child: SizedBox(
                                        width: Dimensions.webMaxWidth,
                                        child: ResponsiveHelper.isDesktop(context)
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    top: Dimensions
                                                        .paddingSizeLarge),
                                                child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                    children: [
                                                      Expanded(
                                                        child: topSection(
                                                            restController,
                                                            charge,
                                                            deliveryCharge,
                                                            orderController,
                                                            locationController,
                                                            addressList,
                                                            tomorrowClosed,
                                                            todayClosed,
                                                            price,
                                                            discount,
                                                            addOns,
                                                            restaurantSubscriptionActive),
                                                      ),
                                                      const SizedBox(
                                                          width: Dimensions
                                                              .paddingSizeLarge),

                                                      Expanded(
                                                          child: bottomSectionForGuest(
                                                              orderController,
                                                              total,
                                                              subTotal,
                                                              discount,
                                                              couponController,
                                                              taxIncluded,
                                                              tax,
                                                              appServiceFee,
                                                              additionalCharge,
                                                              deliveryCharge,
                                                              restController,
                                                              locationController,
                                                              todayClosed,
                                                              tomorrowClosed,
                                                              orderAmount,
                                                              maxCodOrderAmount,
                                                              subscriptionQty)),
                                                    ]),
                                              )
                                            : Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                    /// TopSection
                                                    topSection(
                                                        restController,
                                                        charge,
                                                        deliveryCharge,
                                                        orderController,
                                                        locationController,
                                                        addressList,
                                                        tomorrowClosed,
                                                        todayClosed,
                                                        price,
                                                        discount,
                                                        addOns,
                                                        restaurantSubscriptionActive),

                                                    ///BottomSection
                                                    bottomSectionForGuest(
                                                        orderController,
                                                        total,
                                                        subTotal,
                                                        discount,
                                                        couponController,
                                                        taxIncluded,
                                                        tax,
                                                        appServiceFee,
                                                        additionalCharge,
                                                        deliveryCharge,
                                                        restController,
                                                        locationController,
                                                        todayClosed,
                                                        tomorrowClosed,
                                                        orderAmount,
                                                        maxCodOrderAmount,
                                                        subscriptionQty),
                                                  ]),
                                      ),
                                    ),
                                  )),
                                  ResponsiveHelper.isDesktop(context)
                                      ? const SizedBox()
                                      : Container(
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).cardColor,
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Theme.of(context)
                                                      .primaryColor
                                                      .withOpacity(0.1),
                                                  blurRadius: 10)
                                            ],
                                          ),
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets
                                                        .symmetric(
                                                    horizontal: Dimensions
                                                        .paddingSizeLarge,
                                                    vertical: Dimensions
                                                        .paddingSizeExtraSmall),
                                                child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        'total_amount'.tr,
                                                        style: robotoMedium.copyWith(
                                                            fontSize: Dimensions
                                                                .fontSizeLarge,
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor),
                                                      ),
                                                      PriceConverter
                                                          .convertAnimationPrice(
                                                        total,
                                                        textStyle:
                                                            robotoMedium.copyWith(
                                                                fontSize: Dimensions
                                                                    .fontSizeLarge,
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor),
                                                      ),
                                                      // Text(
                                                      //   PriceConverter.convertPrice(total), textDirection: TextDirection.ltr,
                                                      //   style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor),
                                                      // ),
                                                    ]),
                                              ),
                                              _orderPlaceButtonForGuest(
                                                  orderController,
                                                  restController,
                                                  locationController,
                                                  todayClosed,
                                                  tomorrowClosed,
                                                  orderAmount,
                                                  deliveryCharge,
                                                  tax,
                                                  appServiceFee,
                                                  discount,
                                                  total,
                                                  maxCodOrderAmount,
                                                  subscriptionQty),
                                            ],
                                          ),
                                        ),
                                ],
                              );
                      });
                    });
                  });
                }),
            )
            : NotLoggedInScreen(callBack: (value) {
                initCall();
                setState(() {});
              }));
  }

  Widget topSection(
      RestaurantController restController,
      double charge,
      double deliveryCharge,
      OrderController orderController,
      LocationController locationController,
      List<DropdownItem<int>> addressList,
      bool tomorrowClosed,
      bool todayClosed,
      double price,
      double couponDiscount,
      double addOns,
      bool restaurantSubscriptionActive) {
    return Container(
      decoration: ResponsiveHelper.isDesktop(context)
          ? BoxDecoration(
              //color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey[Get.isDarkMode ? 700 : 300]!,
                    blurRadius: 5,
                    spreadRadius: 1)
              ],
            )
          : null,
      child: Column(children: [
        (_isCashOnDeliveryActive ?? true) && restaurantSubscriptionActive
            ? Container(
                width: context.width,
                //color: Theme.of(context).cardColor,
                padding: const EdgeInsets.symmetric(
                    vertical: Dimensions.paddingSizeSmall,
                    horizontal: Dimensions.paddingSizeLarge),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('order_type'.tr, style: robotoMedium),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                      Row(children: [
                        Expanded(
                            child: OrderTypeWidget(
                          title: 'regular_order'.tr,
                          subtitle: 'place_an_order_and_enjoy'.tr,
                          icon: Images.regularOrder,
                          isSelected: !orderController.subscriptionOrder,
                          onTap: () {
                            orderController.setSubscription(false);
                            // orderController.updateTips(
                            //   Get.find<AuthController>()
                            //           .getDmTipIndex()
                            //           .isNotEmpty
                            //       ? int.parse(Get.find<AuthController>()
                            //           .getDmTipIndex())
                            //       : 1,
                            //   notify: false,
                            // );
                          },
                        )),
                        SizedBox(
                            width: _isCashOnDeliveryActive!
                                ? Dimensions.paddingSizeSmall
                                : 0),
                        Expanded(
                            child: OrderTypeWidget(
                          title: 'subscription_order'.tr,
                          subtitle: 'place_order_and_enjoy_it_everytime'.tr,
                          icon: Images.subscriptionOrder,
                          isSelected: orderController.subscriptionOrder,
                          onTap: () {
                            orderController.setSubscription(true);
                            orderController.addTips(0);
                          },
                        )),
                      ]),
                      const SizedBox(height: Dimensions.paddingSizeLarge),
                      orderController.subscriptionOrder
                          ? SubscriptionView(
                              orderController: orderController,
                            )
                          : const SizedBox(),
                      SizedBox(
                          height: orderController.subscriptionOrder
                              ? Dimensions.paddingSizeLarge
                              : 0),
                    ]),
              )
            : const SizedBox(),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

        restController.restaurant != null
            ? Container(
                width: context.width,
              //  color: Theme.of(context).cardColor,
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeLarge,
                    vertical: Dimensions.paddingSizeSmall),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // Text('delivery_option'.tr, style: robotoMedium),
                      // // const SizedBox(height: Dimensions.paddingSizeDefault),
                      // SingleChildScrollView(
                      //     scrollDirection: Axis.horizontal,
                      //     child: Row(children: [
                      //       /// DeliveryOptions Row
                      //       (Get.find<SplashController>()
                      //                   .configModel!
                      //                   .homeDelivery! &&
                      //               restController.restaurant!.delivery! &&
                      //               (int.tryParse(widget.tableId) ?? 0) == 0)
                      //           ? DeliveryOptionButton(
                      //               value: 'delivery',
                      //               title: 'home_delivery'.tr,
                      //               charge: charge,
                      //               isFree:
                      //                   restController.restaurant!.freeDelivery,
                      //             )
                      //           : const SizedBox(),
                      //
                      //       /// DeliveryOptions Row
                      //
                      //       const SizedBox(
                      //           width: Dimensions.paddingSizeDefault),
                      //       (Get.find<SplashController>()
                      //                   .configModel!
                      //                   .takeAway! &&
                      //               restController.restaurant!.takeAway! &&
                      //               (int.tryParse(widget.tableId) ?? 0) == 0)
                      //           ? DeliveryOptionButton(
                      //               value: 'take_away',
                      //               title: 'take_away'.tr,
                      //               charge: 0,
                      //               isFree: true,
                      //             )
                      //           : const SizedBox(),
                      //
                      //       /// Dining In
                      //       (Get.find<SplashController>()
                      //                       .configModel!
                      //                       .takeAway! &&
                      //                   restController.restaurant!.takeAway! ||
                      //               (int.tryParse(widget.tableId) ?? 0) > 1)
                      //           ? DeliveryOptionButton(
                      //               value: 'dine_in',
                      //               title: 'Dine in'.tr,
                      //               charge: 0,
                      //               isFree: true,
                      //             )
                      //           : const SizedBox(),
                      //     ])),
                    ]),
              )
            : const SizedBox(),

        SizedBox(
            height: orderController.orderType == 'delivery'
                ? Dimensions.paddingSizeLarge
                : 0),


        (orderController.orderType == 'delivery')
            ? Center(
                child:
                locationController.isLoading?
          Lottie.asset(Images.loading,height: 70):
                 Text(
                    '${'delivery_charge'.tr}:${_getDeliveryCharge(
                      orderType: orderController.orderType,
                      charge: charge,
                      deliveryCharge: deliveryCharge,
                      isFreeDelivery:
                          restController.restaurant?.freeDelivery ?? true,
                    )}',
                    textDirection: TextDirection.ltr))
            : const SizedBox(),
        // _getDeliveryCharge(),

        ///
        SizedBox(
            height: orderController.orderType == 'delivery'
                ? Dimensions.paddingSizeLarge
                : 0),

        orderController.orderType == 'delivery'
            ? Padding(
              padding:  EdgeInsets.symmetric(horizontal:15.w),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('delivery_address'.tr, style: robotoMedium),
                          InkWell(
                            onTap: ()  {
                              Get.bottomSheet(
                                Container(
                                  padding: EdgeInsets.all(10.w),
                                  width: Dimensions.webMaxWidth,
                                  decoration: BoxDecoration(
                                    color: Color(0xff262626).withOpacity(0.8),
                                    boxShadow: [
                                      BoxShadow(
                                          color:Color(0xff262626).withOpacity(0.5),
                                          blurRadius: 1)
                                    ],
                                    border: Border(top: BorderSide(color: Theme.of(context).disabledColor.withOpacity(0.5))),
                                    borderRadius: ResponsiveHelper.isMobile(context)
                                        ? const BorderRadius.vertical(
                                        top: Radius.circular(Dimensions.radiusExtraLarge))
                                        : const BorderRadius.all(
                                        Radius.circular(Dimensions.radiusExtraLarge)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CustomText(text: 'choose_your_address'.tr,fontWeight: FontWeight.bold,color: Theme.of(context).indicatorColor,),
                                      Dimensions.kSizedBoxH10,
                                      InkWell(
                                        onTap: ()async{
                                          var address = await Get.toNamed(
                                              RouteHelper.getAddAddressRoute(true,
                                                  restController.restaurant!.zoneId));
                                          if (address != null) {
                                            _streetNumberController.text =
                                                address.road ?? '';
                                            _houseController.text = address.house ?? '';
                                            _floorController.text = address.floor ?? '';

                                            orderController.getDistanceInMeter(
                                              LatLng(double.parse(address.latitude),
                                                  double.parse(address.longitude)),
                                              LatLng(
                                                  double.parse(restController
                                                      .restaurant!.latitude!),
                                                  double.parse(restController
                                                      .restaurant!.longitude!)),
                                            );
                                          }
                                        },
                                        child: Row(children: [
                                          Icon(Icons.add,
                                              size: 20,
                                              color: Theme.of(context).primaryColor),
                                          const SizedBox(
                                              width: Dimensions.paddingSizeExtraSmall),
                                          Text('add_new'.tr,
                                              style: robotoMedium.copyWith(
                                                  fontSize: Dimensions.fontSizeSmall,
                                                  color:
                                                  Theme.of(context).primaryColor)),
                                        ]),
                                      ),
                                      Dimensions.kSizedBoxH20,
                                      Flexible(child: ListView.builder(
                                        itemCount:address.length ,
                                          itemBuilder: (context,index){
                                          print("zzzzzzzz ${locationController.addressList?.length}");

                                        return Expanded(
                                          child: InkWell(
                                            onTap: (){
                                              if (restController.restaurant!.selfDeliverySystem ==
                                                  0) {
                                                orderController.getDistanceInMeter(
                                                  LatLng(
                                                    double.parse(index == 0
                                                        ? locationController
                                                        .getUserAddress()!
                                                        .latitude!
                                                        : address[index].latitude!),
                                                    double.parse(index == 0
                                                        ? locationController
                                                        .getUserAddress()!
                                                        .longitude!
                                                        : address[index].longitude!),
                                                  ),
                                                  LatLng(
                                                      double.parse(
                                                          restController.restaurant!.latitude!),
                                                      double.parse(
                                                          restController.restaurant!.longitude!)),
                                                );
                                              }
                                              orderController.setAddressIndex(index);

                                              _streetNumberController.text = orderController
                                                  .addressIndex ==
                                                  0
                                                  ? locationController.getUserAddress()!.road ??
                                                  ''
                                                  : address[orderController.addressIndex].road ??
                                                  '';
                                              _houseController.text = orderController
                                                  .addressIndex ==
                                                  0
                                                  ? locationController.getUserAddress()!.house ??
                                                  ''
                                                  : address[orderController.addressIndex].house ??
                                                  '';
                                              _floorController.text = orderController
                                                  .addressIndex ==
                                                  0
                                                  ? locationController.getUserAddress()!.floor ??
                                                  ''
                                                  : address[orderController.addressIndex].floor ??
                                                  '';
                                              Get.back();
                                            },
                                            child: Padding(
                                              padding:  EdgeInsets.all(8.w),
                                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                  // Image.asset(
                                                  //   address!.addressType == 'home' ? Images.homeIcon : address!.addressType == 'office' ? Images.workIcon : Images.otherIcon,
                                                  //   height: ResponsiveHelper.isDesktop(context) ? 25 : 20, color: Theme.of(context).primaryColor,
                                                  // ),
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Icon(Icons.location_on_rounded,color: Theme.of(context).disabledColor,size: 20.w,),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          address[index].addressType!.tr,
                                                          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault),
                                                        ),
                                                        Dimensions.kSizedBoxH5,
                                                        SizedBox(
                                                          width: MediaQuery.of(context).size.width/1.5,
                                                          child: Text(
                                                            address[index].address!,
                                                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                                                            maxLines: 5, overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                      Icon(Icons.edit,color: Theme.of(context).disabledColor,size: 20.w,),


                                                ]),
                                                //const SizedBox(height: Dimensions.paddingSizeExtraSmall),



                                              ]),
                                            ),
                                          ),
                                        );
                                      })),
                                      CustomTTButton(
                                        isRounded: true,
                                          text: 'user_current_location'.tr, onTap: ()async{
                                        var address = await Get.toNamed(
                                            RouteHelper.getAddAddressRoute(true,
                                                restController.restaurant!.zoneId));
                                        if (address != null) {
                                          _streetNumberController.text =
                                              address.road ?? '';
                                          _houseController.text = address.house ?? '';
                                          _floorController.text = address.floor ?? '';

                                          orderController.getDistanceInMeter(
                                            LatLng(double.parse(address.latitude),
                                                double.parse(address.longitude)),
                                            LatLng(
                                                double.parse(restController
                                                    .restaurant!.latitude!),
                                                double.parse(restController
                                                    .restaurant!.longitude!)),
                                          );
                                        }
                                      }),
                                      Dimensions.kSizedBoxH20,


                                    ],
                                  ),
                                )
                              );

                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: Dimensions.paddingSizeSmall),
                              child: Row(children: [
                                Icon(Icons.edit,
                                    size: 20,
                                    color: Theme.of(context).indicatorColor),
                                const SizedBox(
                                    width: Dimensions.paddingSizeExtraSmall),
                                Text('edit'.tr,
                                    style: robotoMedium.copyWith(
                                        fontSize: Dimensions.fontSizeSmall,
                                        color:
                                            Theme.of(context).indicatorColor)),
                              ]),
                            ),
                          ),
                        ]),
                    Container(
                      constraints: const BoxConstraints(minHeight: 100),
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(Dimensions.radiusDefault),
                        color: Theme.of(context)
                            .disabledColor
                            .withOpacity(0.5),
                      ),
                      child:AddressWidget(
                        address: address[orderController.addressIndex],
                        fromAddress: false,
                        fromCheckout: true,
                      ) ,
                    ),
                    // Container(
                    //   constraints: const BoxConstraints(minHeight: 100),
                    //   decoration: BoxDecoration(
                    //     borderRadius:
                    //         BorderRadius.circular(Dimensions.radiusDefault),
                    //     color: Theme.of(context)
                    //         .disabledColor
                    //         .withOpacity(0.5),
                    //   ),
                    //   child: CustomDropdown<int>(
                    //     onChange: (int? value, int index) {
                    //
                    //     },
                    //     dropdownButtonStyle: DropdownButtonStyle(
                    //       height: 50,
                    //       padding: const EdgeInsets.symmetric(
                    //         vertical: Dimensions.paddingSizeExtraSmall,
                    //         horizontal: Dimensions.paddingSizeExtraSmall,
                    //       ),
                    //       primaryColor:
                    //           Theme.of(context).textTheme.bodyLarge!.color,
                    //     ),
                    //     dropdownStyle: DropdownStyle(
                    //       elevation: 10,
                    //       borderRadius:
                    //           BorderRadius.circular(Dimensions.radiusDefault),
                    //       padding: const EdgeInsets.all(
                    //           Dimensions.paddingSizeExtraSmall),
                    //     ),
                    //     items: addressList,
                    //     child: AddressWidget(
                    //       address: address[orderController.addressIndex],
                    //       fromAddress: false,
                    //       fromCheckout: true,
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(height: Dimensions.paddingSizeDefault),
                    // CustomTextField(
                    //   titleText: 'add address'.tr,
                    //   inputType: TextInputType.streetAddress,
                    //   focusNode: _streetNode,
                    //   nextFocus: _houseNode,
                    //   controller: _streetNumberController,
                    // ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: CustomTextField(
                    //         titleText: 'house'.tr,
                    //         inputType: TextInputType.text,
                    //         focusNode: _houseNode,
                    //         nextFocus: _floorNode,
                    //         controller: _houseController,
                    //       ),
                    //     ),
                    //     const SizedBox(width: Dimensions.paddingSizeSmall),
                    //     Expanded(
                    //       child: CustomTextField(
                    //         titleText: 'floor'.tr,
                    //         inputType: TextInputType.text,
                    //         focusNode: _floorNode,
                    //         inputAction: TextInputAction.done,
                    //         controller: _floorController,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  ]),
            )
            : const SizedBox(),


        //delivery instruction
        Padding(
          padding:  EdgeInsets.only(left:15.w,bottom: 15.h),
          child: InkWell(
            onTap: (){
              orderController.selectInstruction=!orderController.selectInstruction;
              orderController.setInstruction(0);
            },
            child: Row(
              children: [
                Icon( orderController.selectInstruction? Icons.check_box:Icons.check_box_outline_blank, color:orderController.selectInstruction? Theme.of(context).primaryColor: Theme.of(context).disabledColor),
                Text(
                  AppConstants.deliveryInstructionList[0].tr,
                  style: robotoMedium.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                      color:Theme.of(context).disabledColor),
                ),
              ],
            ),
          ),
        ),
        // (orderController.orderType == 'delivery')
        //     ? const DeliveryInstructionView()
        //     : const SizedBox(),
        // const SizedBox(height: Dimensions.paddingSizeExtraSmall),

        // Time Slot
        
        (widget.fromCart &&
                !orderController.subscriptionOrder &&
                (restController.restaurant?.scheduleOrder! ?? true))
            ? Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context)
                            .secondaryHeaderColor
                            .withOpacity(0.05),
                        blurRadius: 10)
                  ],
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeLarge,
                    vertical: Dimensions.paddingSizeSmall),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Text('preference_time'.tr, style: robotoMedium),
                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                        JustTheTooltip(
                          backgroundColor: Colors.black87,
                          controller: tooltipController2,
                          preferredDirection: AxisDirection.right,
                          tailLength: 14,
                          tailBaseWidth: 20,
                          content: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('schedule_time_tool_tip'.tr,
                                style: robotoRegular.copyWith(
                                    color: Colors.white)),
                          ),
                          child: InkWell(
                            onTap: () => tooltipController2.showTooltip(),
                            child: const Icon(Icons.info_outline),
                          ),
                          // child: const Icon(Icons.info_outline),
                        ),
                      ]),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      InkWell(
                        onTap: () {
                          if (ResponsiveHelper.isDesktop(context)) {
                            showDialog(
                                context: context,
                                builder: (con) => Dialog(
                                      child: TimeSlotBottomSheet(
                                        tomorrowClosed: tomorrowClosed,
                                        todayClosed: todayClosed,
                                      ),
                                    ));
                          } else {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (con) => TimeSlotBottomSheet(
                                tomorrowClosed: tomorrowClosed,
                                todayClosed: todayClosed,
                              ),
                            );
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 0.3),
                            borderRadius:
                                BorderRadius.circular(Dimensions.radiusDefault),
                          ),
                          height: 50,
                          child: Row(children: [
                            const SizedBox(width: Dimensions.paddingSizeLarge),
                            Expanded(
                                child: Text(
                              (orderController.selectedDateSlot == 0 &&
                                      todayClosed)
                                  ? 'restaurant_is_closed'.tr
                                  : orderController.preferableTime.isNotEmpty
                                      ? orderController.preferableTime
                                      : 'now'.tr,
                              style: robotoRegular.copyWith(
                                  color:
                                      (orderController.selectedDateSlot == 0 &&
                                              todayClosed)
                                          ? Theme.of(context).colorScheme.error
                                          : Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .color),
                            )),
                            const Icon(Icons.arrow_drop_down_outlined),
                            const SizedBox(
                                width: Dimensions.paddingSizeExtraSmall),
                            Icon(Icons.access_time_filled_outlined,
                                color: Theme.of(context).primaryColor),
                            const SizedBox(
                                width: Dimensions.paddingSizeExtraSmall),
                          ]),
                        ),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeLarge),
                    ]),
              )
            : const SizedBox(),
            AuthHelper.isGuestLoggedIn()?
        SizedBox(
            height: (widget.fromCart &&
                    !orderController.subscriptionOrder &&
                    (restController.restaurant?.scheduleOrder! ?? true))
                ? Dimensions.paddingSizeSmall
                : 0):const SizedBox(),

        // Coupon
       
        ((int.tryParse(widget.tableId) ?? 0) > 0)
            ? Container()
            :!AuthHelper.isGuestLoggedIn()?
             GetBuilder<CouponController>(
                builder: (couponController) {
                  return Container(
                    decoration: BoxDecoration(
                      //color: Theme.of(context).cardColor,
                      // boxShadow: [
                      //   BoxShadow(
                      //       color: Theme.of(context)
                      //           .secondaryHeaderColor
                      //           .withOpacity(0.05),
                      //       blurRadius: 10)
                      // ],
                    ),
                    padding:  EdgeInsets.symmetric(
                        horizontal: 15.w),
child:
                    Column(children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('promo_code'.tr, style: robotoMedium),
                            InkWell(
                              onTap: () {
                                if (ResponsiveHelper.isDesktop(context)) {
                                  Get.dialog(const Dialog(
                                          child: CouponBottomSheet()))
                                      .then((value) {
                                    if (value != null) {
                                      _couponController.text = value.toString();
                                    }
                                  });
                                } else {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (con) => const CouponBottomSheet(),
                                  ).then((value) {
                                    if (value != null) {
                                      _couponController.text = value.toString();
                                    }
                                    if (_couponController.text.isNotEmpty) {
                                      if (couponController.discount! < 1 &&
                                          !couponController.freeDelivery) {
                                        if (_couponController.text.isNotEmpty &&
                                            !couponController.isLoading) {
                                          couponController
                                              .applyCoupon(
                                                  _couponController.text,
                                                  (price - couponDiscount) +
                                                      addOns,
                                                  deliveryCharge,
                                                  restController.restaurant!.id)
                                              .then((discount) {
                                            _couponController.text =
                                                'coupon_applied'.tr;
                                            if (discount! > 0) {
                                              showCustomSnackBar(
                                                '${'you_got_discount_of'.tr} ${PriceConverter.convertPrice(discount)}',
                                                isError: false,
                                              );
                                            }
                                          });
                                        } else if (_couponController
                                            .text.isEmpty) {
                                          showCustomSnackBar(
                                              'enter_a_coupon_code'.tr);
                                        }
                                      } else {
                                        couponController.removeCouponData(true);
                                        _couponController.text = '';
                                      }
                                    }
                                  });
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(children: [
                                  Text('add_voucher'.tr,
                                      style: robotoMedium.copyWith(
                                          fontSize: Dimensions.fontSizeSmall,
                                          color:
                                              Theme.of(context).primaryColor)),
                                  const SizedBox(
                                      width: Dimensions.paddingSizeExtraSmall),
                                  Icon(Icons.add,
                                      size: 20,
                                      color: Theme.of(context).primaryColor),
                                ]),
                              ),
                            )
                          ]),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                      
                      Container(
                        padding: EdgeInsets.all(5.w),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(Dimensions.radiusDefault),
                          border: Border.all(
                              color: Theme.of(context).disabledColor,
                              width: 0.2),
                        ),
                        child: Row(children: [
                          Expanded(
                            child: SizedBox(
                              height: 45,
                              child: TextField(
                                controller: _couponController,
                                style: robotoRegular.copyWith(
                                    height: ResponsiveHelper.isMobile(context)
                                        ? null
                                        : 2),
                                decoration: InputDecoration(
                                    hintText: 'enter_promo_code'.tr,
                                    hintStyle: robotoRegular.copyWith(
                                        color: Theme.of(context).hintColor),
                                    isDense: true,
                                    filled: true,
                                    enabled: couponController.discount == 0,
                                    fillColor: Colors.transparent,
                                    border: OutlineInputBorder(
                                      // borderRadius: BorderRadius.horizontal(
                                      //   left: Radius.circular(
                                      //       Get.find<LocalizationController>()
                                      //               .isLtr
                                      //           ? 10
                                      //           : 0),
                                      //   right: Radius.circular(
                                      //       Get.find<LocalizationController>()
                                      //               .isLtr
                                      //           ? 0
                                      //           : 10),
                                      // ),
                                      borderSide: BorderSide.none,
                                   ),
                                    prefixIcon: Icon(Icons.local_offer_outlined,
                                        color: Theme.of(context).disabledColor)),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              String couponCode = _couponController.text.trim();
                              if (couponController.discount! < 1 &&
                                  !couponController.freeDelivery) {
                                if (couponCode.isNotEmpty &&
                                    !couponController.isLoading) {
                                  couponController
                                      .applyCoupon(
                                          couponCode,
                                          (price - couponDiscount) + addOns,
                                          deliveryCharge,
                                          restController.restaurant!.id)
                                      .then((discount) {
                                    if (discount! > 0) {
                                      showCustomSnackBar(
                                        '${'you_got_discount_of'.tr} ${PriceConverter.convertPrice(discount)}',
                                        isError: false,
                                      );
                                    }
                                  });
                                } else if (couponCode.isEmpty) {
                                  showCustomSnackBar('enter_a_coupon_code'.tr);
                                }
                              } else {
                                couponController.removeCouponData(true);
                                _couponController.text = '';
                              }
                            },
                            child: Container(
                              height: 45,
                              width: (couponController.discount! <= 0 &&
                                      !couponController.freeDelivery)
                                  ? 100
                                  : 50,
                              alignment: Alignment.center,
                              margin: const EdgeInsets.all(
                                  Dimensions.paddingSizeExtraSmall),
                              decoration: BoxDecoration(
                                color: (couponController.discount! <= 0 &&
                                        !couponController.freeDelivery)
                                    ? Theme.of(context).primaryColor
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(
                                    Dimensions.radiusDefault),
                              ),
                              child: (couponController.discount! <= 0 &&
                                      !couponController.freeDelivery)
                                  ? !couponController.isLoading
                                      ? Text(
                                          'apply'.tr,
                                          style: robotoMedium.copyWith(
                                              color: Colors.white),
                                        )
                                      : const SizedBox(
                                          height: 30,
                                          width: 30,
                                          child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Colors.white)),
                                        )
                                  : Icon(Icons.clear,
                                      color:
                                          Theme.of(context).colorScheme.error),
                            ),
                          ),
                        ]),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeLarge),
                    ]),
                  );
                },
              ):const SizedBox(),
       AuthHelper.isGuestLoggedIn()? const SizedBox(height: Dimensions.paddingSizeExtraSmall):const SizedBox(),

        (orderController.orderType == 'delivery' &&
                Get.find<SplashController>().configModel!.dmTipsStatus == 1 &&
                !orderController.subscriptionOrder)
            ? Container(
                color: Theme.of(context).cardColor,
                padding: const EdgeInsets.symmetric(
                    vertical: Dimensions.paddingSizeLarge,
                    horizontal: Dimensions.paddingSizeLarge),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Text('delivery_man_tips'.tr, style: robotoMedium),
                        JustTheTooltip(
                          backgroundColor: Colors.black87,
                          controller: tooltipController3,
                          preferredDirection: AxisDirection.right,
                          tailLength: 14,
                          tailBaseWidth: 20,
                          content: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                'it_s_a_great_way_to_show_your_appreciation_for_their_hard_work'
                                    .tr,
                                style: robotoRegular.copyWith(
                                    color: Colors.white)),
                          ),
                          child: InkWell(
                            onTap: () => tooltipController3.showTooltip(),
                            child: const Icon(Icons.info_outline),
                          ),
                        ),
                      ]),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      SizedBox(
                        height: (orderController.selectedTips ==
                                    AppConstants.tips.length - 1) &&
                                orderController.canShowTipsField
                            ? 0
                            : 45,
                        child: (orderController.selectedTips ==
                                    AppConstants.tips.length - 1) &&
                                orderController.canShowTipsField
                            ? const SizedBox()
                            : ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                itemCount: AppConstants.tips.length,
                                itemBuilder: (context, index) {
                                  return TipsWidget(
                                    title: (index != 0 &&
                                            index !=
                                                AppConstants.tips.length - 1)
                                        ? PriceConverter.convertPrice(
                                            double.parse(AppConstants
                                                .tips[index]
                                                .toString()),
                                            forDM: true)
                                        : AppConstants.tips[index].tr,
                                    isSelected:
                                        orderController.selectedTips == index,
                                    onTap: () {
                                     // orderController.updateTips(index);
                                      if (orderController.selectedTips != 0 &&
                                          orderController.selectedTips !=
                                              AppConstants.tips.length - 1) {
                                        orderController.addTips(double.parse(
                                            AppConstants.tips[index]));
                                      }
                                      if (orderController.selectedTips ==
                                          AppConstants.tips.length - 1) {
                                        orderController.showTipsField();
                                      }
                                      if (orderController.selectedTips == 0) {
                                        orderController.addTips(0);
                                      }
                                      _tipController.text =
                                          orderController.tips.toString();
                                    },
                                  );
                                },
                              ),
                      ),
                      SizedBox(
                          height: (orderController.selectedTips ==
                                      AppConstants.tips.length - 1) &&
                                  orderController.canShowTipsField
                              ? Dimensions.paddingSizeExtraSmall
                              : 0),
                      orderController.selectedTips ==
                              AppConstants.tips.length - 1
                          ? const SizedBox()
                          : ListTile(
                              onTap: () => orderController.toggleDmTipSave(),
                              leading: Checkbox(
                                visualDensity: const VisualDensity(
                                    horizontal: -4, vertical: -4),
                                activeColor: Theme.of(context).primaryColor,
                                value: orderController.isDmTipSave,
                                onChanged: (bool? isChecked) =>
                                    orderController.toggleDmTipSave(),
                              ),
                              title: Text('save_for_later'.tr,
                                  style: robotoMedium.copyWith(
                                      color: Theme.of(context).primaryColor)),
                              contentPadding: EdgeInsets.zero,
                              visualDensity: const VisualDensity(
                                  horizontal: 0, vertical: -4),
                              dense: true,
                              horizontalTitleGap: 0,
                            ),
                      SizedBox(
                          height: orderController.selectedTips ==
                                  AppConstants.tips.length - 1
                              ? Dimensions.paddingSizeDefault
                              : 0),
                      orderController.selectedTips ==
                              AppConstants.tips.length - 1
                          ? Row(children: [
                              Expanded(
                                child: CustomTextField(
                                  titleText: 'enter_amount'.tr,
                                  controller: _tipController,
                                  inputAction: TextInputAction.done,
                                  inputType: TextInputType.number,
                                  onSubmit: (value) {
                                    if (value.isNotEmpty) {
                                      if (double.parse(value) >= 0) {
                                        orderController
                                            .addTips(double.parse(value));
                                      } else {
                                        showCustomSnackBar(
                                            'tips_can_not_be_negative'.tr);
                                      }
                                    } else {
                                      orderController.addTips(0.0);
                                    }
                                  },
                                  onChanged: (String value) {
                                    if (value.isNotEmpty) {
                                      if (double.parse(value) >= 0) {
                                        orderController
                                            .addTips(double.parse(value));
                                      } else {
                                        showCustomSnackBar(
                                            'tips_can_not_be_negative'.tr);
                                      }
                                    } else {
                                      orderController.addTips(0.0);
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(
                                  width: Dimensions.paddingSizeSmall),
                              InkWell(
                                onTap: () {
                                  //orderController.updateTips(0);
                                  orderController.showTipsField();
                                  orderController.addTips(0);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.5),
                                  ),
                                  padding: const EdgeInsets.all(
                                      Dimensions.paddingSizeSmall),
                                  child: const Icon(Icons.clear),
                                ),
                              ),
                            ])
                          : const SizedBox(),
                    ]),
              )
            : const SizedBox.shrink(),

        SizedBox(
            height: (orderController.orderType == 'delivery' &&
                    Get.find<SplashController>().configModel!.dmTipsStatus == 1)
                ? Dimensions.paddingSizeExtraSmall
                : 0),
      ]),
    );
  }

  ///bottom Sction
  Widget bottomSection(
      OrderController orderController,
      double total,
      double subTotal,
      double discount,
      CouponController couponController,
      bool taxIncluded,
      double tax,
      double appServiceFee,
      double additionalCharge,
      double deliveryCharge,
      RestaurantController restaurantController,
      LocationController locationController,
      bool todayClosed,
      bool tomorrowClosed,
      double orderAmount,
      double? maxCodOrderAmount,
      int subscriptionQty) {
    return Container(
      decoration: ResponsiveHelper.isDesktop(context)
          ? BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey[Get.isDarkMode ? 700 : 300]!,
                    blurRadius: 5,
                    spreadRadius: 1)
              ],
            )
          : null,
      padding:
          const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
      child: Column(children: [
        Container(
          decoration: BoxDecoration(
            // color: Theme.of(context).cardColor,
            // boxShadow: [
            //   BoxShadow(
            //       color:
            //           Theme.of(context).secondaryHeaderColor.withOpacity(0.05),
            //       blurRadius: 10)
            // ],
          ),
          padding: const EdgeInsets.symmetric(
              vertical: Dimensions.paddingSizeLarge,
              horizontal: Dimensions.paddingSizeLarge),
          child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('choose_payment_method'.tr, style: robotoMedium),

            ]),
            Dimensions.kSizedBoxH10,

            (_isCashOnDeliveryActive! ||
                    _isDigitalPaymentActive! ||
                    _isWalletActive ||
                    _isOnlinePaymentActive!)
                ? InkWell(
              onTap:(){
                if (ResponsiveHelper.isDesktop(context)) {
                  Get.dialog(Dialog(
                      child: PaymentMethodBottomSheet(
                        isCashOnDeliveryActive: _isCashOnDeliveryActive!,
                        isDigitalPaymentActive: _isDigitalPaymentActive!,
                        isWalletActive: _isWalletActive,
                        isOnlineActive: _isOnlinePaymentActive!,
                      )));
                } else {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (con) => PaymentMethodBottomSheet(
                        isOnlineActive: _isOnlinePaymentActive!,
                        isCashOnDeliveryActive: _isCashOnDeliveryActive!,
                        isDigitalPaymentActive: _isDigitalPaymentActive! &&
                            orderController.orderType != "dine_in",
                        isWalletActive: _isWalletActive &&
                            orderController.orderType != "dine_in"),
                  );
                }
              },
                  child: Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      border: Border.all(
                        color: Theme.of(context).disabledColor
                      )
                    ),
                    child: Row(children: [
                        Image.asset(
                          orderController.paymentMethodIndex == 0
                              ? Images.cashOnDelivery
                              : orderController.paymentMethodIndex == 1
                                  ? Images.digitalPayment
                                  : orderController.paymentMethodIndex == 2
                                      ? Images.wallet
                                      : Images.aboutIcon,
                          width: 20,
                          height: 20,
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                        ),
                        const SizedBox(width: Dimensions.paddingSizeSmall ),

                        Expanded(
                          child: Text(
                            orderController.paymentMethodIndex == 0
                                ? 'cash_on_delivery'.tr
                                : orderController.paymentMethodIndex == 1
                                    ? 'digital_payment'.tr
                                    : orderController.paymentMethodIndex == 2
                                        ? 'wallet'.tr
                                        : 'online payment'.tr,
                            style: robotoMedium.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                color: Theme.of(context).disabledColor),
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios,color: Theme.of(context).disabledColor,)
                        // PriceConverter.convertAnimationPrice(
                        //   total,
                        //   textStyle: robotoMedium.copyWith(
                        //       fontSize: Dimensions.fontSizeLarge,
                        //       color: Theme.of(context).primaryColor),
                        // ),
                        // Text(
                        //   PriceConverter.convertPrice(total), textDirection: TextDirection.ltr,
                        //   style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor),
                        // ),
                      ]),
                  ),
                )
                : Text('no_payment_method_available'.tr,
                    style: robotoMedium.copyWith(
                        color: Theme.of(context).colorScheme.error)),
          ]),
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall),


        
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                  color:
                      Theme.of(context).secondaryHeaderColor.withOpacity(0.05),
                  blurRadius: 10)
            ],
          ),
          padding: const EdgeInsets.symmetric(
              vertical: Dimensions.paddingSizeExtraLarge,
              horizontal: Dimensions.paddingSizeLarge),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (orderController.paymentMethodIndex == 3)
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Online Payment'.tr, style: robotoMedium),
                  const SizedBox(height: Dimensions.paddingSizeDefault),
                  Get.find<SplashController>()
                                .configModel!
                                .transferPhoneno !=null ?
                   
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('WavePay'.tr,  style: robotoMedium.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                            color: Theme.of(context).primaryColor),),
                        
                     
                        Text(
                            Get.find<SplashController>()
                                .configModel!
                                .transferPhoneno!,
                              style: robotoMedium.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                            color: Theme.of(context).primaryColor),
                      )
                            
                      ],

                    ):const SizedBox(),
                     const SizedBox(height: Dimensions.paddingSizeSmall),
 Get.find<SplashController>()
                                .configModel!
                                .transferKpay !=null ?
                   
                   
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Kpay'.tr,  style: robotoMedium.copyWith(
                         
                            fontSize: Dimensions.fontSizeDefault,
                            color: Theme.of(context).primaryColor)),
                        
                     
                        Text(
                            Get.find<SplashController>()
                                .configModel!
                                .transferKpay!,
                            style: robotoMedium.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                            color: Theme.of(context).primaryColor),
                            ),
                      ],

                    ):const SizedBox(),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  CustomTextField(
                    controller: _accountName,
                    titleText: 'Enter Account Name'.tr,
                    maxLines: 1,
                    inputType: TextInputType.name,
                    inputAction: TextInputAction.done,
                    capitalization: TextCapitalization.sentences,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  CustomTextField(
                    controller: _transitionNo,
                    titleText: 'Enter Transition Number or ID(Option)'.tr,
                    maxLines: 1,
                    inputType: TextInputType.number,
                    inputAction: TextInputAction.done,
                    capitalization: TextCapitalization.sentences,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  Align(
                      alignment: Alignment.center,
                      child: Stack(children: [
                        ClipRRect(
                            borderRadius:
                                BorderRadius.circular(Dimensions.radiusSmall),
                            child: orderController.pickOnlineImage != null
                                ? GetPlatform.isWeb
                                    ? Image.network(
                                        orderController.pickOnlineImage!.path,
                                        width: 120,
                                        height: 90,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.file(
                                        File(orderController
                                            .pickOnlineImage!.path),
                                        width: 120,
                                        height: 90,
                                        fit: BoxFit.cover,
                                      )
                                : const SizedBox()

                            //  FadeInImage.assetNetwork(
                            //     placeholder: Images.placeholder,
                            //     image:
                            //         'https://momofooddelivery.com/storage/app/public/onlinepayments/${orderController.pickOnlineImage}',
                            //     height: 190,
                            //     width: 120,
                            //     fit: BoxFit.cover,
                            //     imageErrorBuilder: (c, o, s) => Image.asset(
                            //         Images.placeholder,
                            //         height: 120,
                            //         width: 150,
                            //         fit: BoxFit.cover),
                            //   ),

                            ),
                        InkWell(
                          onTap: () => orderController.pickImage(true),
                          child: Container(
                            width: 120,
                            height: 90,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              borderRadius:
                                  BorderRadius.circular(Dimensions.radiusSmall),
                              border: Border.all(
                                  width: 1,
                                  color: Theme.of(context).primaryColor),
                            ),
                            child: Container(
                              margin: const EdgeInsets.all(25),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 2, color: Colors.white),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.camera_alt,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ])),
                ],
              ),
             AuthHelper.isGuestLoggedIn()?const SizedBox(height: Dimensions.paddingSizeSmall):const SizedBox(),
            AuthHelper.isGuestLoggedIn()?Text('Contact Person Number'.tr, style: robotoMedium)
           : Text('additional_note'.tr, style: robotoMedium),


          
            const SizedBox(height: Dimensions.paddingSizeSmall),
            AuthHelper.isGuestLoggedIn()?
            CustomTextField(
              controller: _noteController,
              titleText: 'please enter your phone number'.tr,
              maxLines: 3,
              inputType: TextInputType.number,
              inputAction: TextInputAction.done,
              capitalization: TextCapitalization.sentences,
            ):
            CustomTextField(
             
              controller: _noteController,
              titleText: 'ex_please_provide_extra_napkin'.tr,
              maxLines: 1,
              inputType: TextInputType.multiline,
              inputAction: TextInputAction.done,
              capitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),
            if (orderController.orderType == 'dine_in')
              CustomTextField(
                hintText: "table_no".tr,
                //inputType: TextInputType.streetAddress,
                focusNode: _streetNode,
                nextFocus: _houseNode,
                controller: _streetNumberController,
              ),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('item_price'.tr, style: robotoMedium),
              Text(PriceConverter.convertPrice(subTotal),
                  style: robotoMedium, textDirection: TextDirection.ltr),
            ]),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('discount'.tr, style: robotoRegular),
              Row(children: [
                Text('(-) ', style: robotoRegular),
                PriceConverter.convertAnimationPrice(discount,
                    textStyle: robotoRegular)
              ]),
              // Text('(-) ${PriceConverter.convertPrice(discount)}', style: robotoRegular, textDirection: TextDirection.ltr),
            ]),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            (additionalCharge > 0)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        Text(
                            Get.find<SplashController>()
                                .configModel!
                                .additionalChargeName!,
                            style: robotoRegular),
                        Text(
                            '(+) ${PriceConverter.convertPrice(additionalCharge)}',
                            style: robotoRegular,
                            textDirection: TextDirection.ltr),
                      ])
                : const SizedBox(),
            (additionalCharge > 0)
                ? const SizedBox(height: 10)
                : const SizedBox(),
            (couponController.discount! > 0 || couponController.freeDelivery)
                ? Column(children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('coupon_discount'.tr, style: robotoRegular),
                          (couponController.coupon != null &&
                                  couponController.coupon!.couponType ==
                                      'free_delivery')
                              ? Text(
                                  'free_delivery'.tr,
                                  style: robotoRegular.copyWith(
                                      color: Theme.of(context).primaryColor),
                                )
                              : Text(
                                  '(-) ${PriceConverter.convertPrice(couponController.discount)}',
                                  style: robotoRegular,
                                  textDirection: TextDirection.ltr,
                                ),
                        ]),
                    const SizedBox(height: Dimensions.paddingSizeSmall),
                  ])
                : const SizedBox(),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(
                  '${'vat_tax'.tr} ${taxIncluded ? 'tax_included'.tr : ''} ($_taxPercent%)',
                  style: robotoRegular),
              Text(
                  (taxIncluded ? '' : '(+) ') +
                      PriceConverter.convertPrice(tax),
                  style: robotoRegular,
                  textDirection: TextDirection.ltr),
            ]),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Software Service Fee'.tr,
               //($_appServiceFeePercent%)',
                  style: robotoRegular),
              Text(('(+) ') + PriceConverter.convertPrice(getServiceFeeDisplayValue(appServiceFee)),
                  style: robotoRegular, textDirection: TextDirection.ltr),
            ]),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            (orderController.orderType == 'delivery' &&
                    Get.find<SplashController>().configModel!.dmTipsStatus ==
                        1 &&
                    !orderController.subscriptionOrder)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('delivery_man_tips'.tr, style: robotoRegular),
                      Row(children: [
                        Text('(+) ', style: robotoRegular),
                        PriceConverter.convertAnimationPrice(
                            orderController.tips,
                            textStyle: robotoRegular)
                      ]),
                      Text(
                          '(+) ${PriceConverter.convertPrice(orderController.tips)}',
                          style: robotoRegular,
                          textDirection: TextDirection.ltr),
                    ],
                  )
                : const SizedBox.shrink(),
            SizedBox(
                height: orderController.orderType == 'delivery' &&
                        Get.find<SplashController>()
                                .configModel!
                                .dmTipsStatus ==
                            1 &&
                        !orderController.subscriptionOrder
                    ? Dimensions.paddingSizeSmall
                    : 0.0),
            orderController.orderType == 'delivery'
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        Text('delivery_fee'.tr, style: robotoRegular),
                        orderController.distance == -1
                            ? Text(
                                'calculating'.tr,
                                style:
                                    robotoRegular.copyWith(color: Colors.red),
                              )
                            : (deliveryCharge == 0 ||
                                    (couponController.coupon != null &&
                                        couponController.coupon!.couponType ==
                                            'free_delivery'))
                                ? Text(
                                    'free'.tr,
                                    style: robotoRegular.copyWith(
                                        color: Theme.of(context).primaryColor),
                                  )
                                : Text(
                                    '(+) ${PriceConverter.convertPrice(deliveryCharge)}',
                                    style: robotoRegular,
                                    textDirection: TextDirection.ltr,
                                  ),
                      ])
                : const SizedBox(),
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: Dimensions.paddingSizeSmall),
              child: Divider(
                  thickness: 1,
                  color: Theme.of(context).hintColor.withOpacity(0.5)),
            ),
            ResponsiveHelper.isDesktop(context)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        Text(
                          'total_amount'.tr,
                          style: robotoMedium.copyWith(
                              fontSize: Dimensions.fontSizeLarge,
                              color: Theme.of(context).primaryColor),
                        ),
                        PriceConverter.convertAnimationPrice(
                          total,
                          textStyle: robotoMedium.copyWith(
                              fontSize: Dimensions.fontSizeLarge,
                              color: Theme.of(context).primaryColor),
                        ),

                        // Text(
                        //   PriceConverter.convertPrice(total), textDirection: TextDirection.ltr,
                        //   style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor),
                        // ),
                      ])
                : const SizedBox(),
            const SizedBox(height: Dimensions.paddingSizeLarge),
            CheckoutCondition(orderController: orderController),
          ]),
        ),
        ResponsiveHelper.isDesktop(context)
            ? Padding(
                padding:
                    const EdgeInsets.only(top: Dimensions.paddingSizeLarge),
                child: _orderPlaceButton(
                    orderController,
                    restaurantController,
                    locationController,
                    todayClosed,
                    tomorrowClosed,
                    orderAmount,
                    deliveryCharge,
                    tax,
                    appServiceFee,
                    discount,
                    total,
                    maxCodOrderAmount,
                    subscriptionQty),
              )
            : const SizedBox(),
      ]),
    );
  }

  Widget bottomSectionForGuest(
      OrderController orderController,
      double total,
      double subTotal,
      double discount,
      CouponController couponController,
      bool taxIncluded,
      double tax,
      double appServiceFee,
      double additionalCharge,
      double deliveryCharge,
      RestaurantController restaurantController,
      LocationController locationController,
      bool todayClosed,
      bool tomorrowClosed,
      double orderAmount,
      double? maxCodOrderAmount,
      int subscriptionQty) {
    return Container(
      decoration: ResponsiveHelper.isDesktop(context)
          ? BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey[Get.isDarkMode ? 700 : 300]!,
                    blurRadius: 5,
                    spreadRadius: 1)
              ],
            )
          : null,
      padding:
          const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
      child: Column(children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                  color:
                      Theme.of(context).secondaryHeaderColor.withOpacity(0.05),
                  blurRadius: 10)
            ],
          ),
          padding: const EdgeInsets.symmetric(
              vertical: Dimensions.paddingSizeLarge,
              horizontal: Dimensions.paddingSizeLarge),
          child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('choose_payment_method'.tr, style: robotoMedium),
              InkWell(
                onTap: () {},
                child: Image.asset(Images.paymentSelect, height: 24, width: 24),
              ),
            ]),
            const Divider(),
            ((_isCashOnDeliveryActive ?? true) ||
                    (_isDigitalPaymentActive ?? true) ||
                    _isWalletActive ||
                    (_isOnlinePaymentActive ?? true))
                ? Row(children: [
                    Image.asset(
                      orderController.paymentMethodIndex == 0
                          ? Images.cashOnDelivery
                          : orderController.paymentMethodIndex == 1
                              ? Images.digitalPayment
                              : orderController.paymentMethodIndex == 2
                                  ? Images.wallet
                                  : Images.aboutIcon,
                      width: 20,
                      height: 20,
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),

                    Expanded(
                      child: Text(
                        orderController.paymentMethodIndex == 0
                            ? 'cash_on_delivery'.tr
                            : orderController.paymentMethodIndex == 1
                                ? 'digital_payment'.tr
                                : orderController.paymentMethodIndex == 2
                                    ? 'wallet'.tr
                                    : 'online payment'.tr,
                        style: robotoMedium.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: Theme.of(context).disabledColor),
                      ),
                    ),
                    PriceConverter.convertAnimationPrice(
                      Get.find<CartController>().subTotal,
                      textStyle: robotoMedium.copyWith(
                          fontSize: Dimensions.fontSizeLarge,
                          color: Theme.of(context).primaryColor),
                    ),
                    // Text(
                    //   PriceConverter.convertPrice(total), textDirection: TextDirection.ltr,
                    //   style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor),
                    // ),
                  ])
                : Text('no_payment_method_available'.tr,
                    style: robotoMedium.copyWith(
                        color: Theme.of(context).colorScheme.error)),
          ]),
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                  color:
                      Theme.of(context).secondaryHeaderColor.withOpacity(0.05),
                  blurRadius: 10)
            ],
          ),
          padding: const EdgeInsets.symmetric(
              vertical: Dimensions.paddingSizeDefault,
              horizontal: Dimensions.paddingSizeLarge),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (orderController.paymentMethodIndex == 3)
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Online Payment'.tr, style: robotoMedium),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  CustomTextField(
                    controller: _accountName,
                    titleText: 'Enter Account Name'.tr,
                    maxLines: 1,
                    inputType: TextInputType.name,
                    inputAction: TextInputAction.done,
                    capitalization: TextCapitalization.sentences,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  CustomTextField(
                    controller: _transitionNo,
                    titleText: 'Enter Transition Number or ID'.tr,
                    maxLines: 1,
                    inputType: TextInputType.number,
                    inputAction: TextInputAction.done,
                    capitalization: TextCapitalization.sentences,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  Align(
                      alignment: Alignment.center,
                      child: Stack(children: [
                        ClipRRect(
                            borderRadius:
                                BorderRadius.circular(Dimensions.radiusSmall),
                            child: orderController.pickOnlineImage != null
                                ? GetPlatform.isWeb
                                    ? Image.network(
                                        orderController.pickOnlineImage!.path,
                                        width: 120,
                                        height: 90,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.file(
                                        File(orderController
                                            .pickOnlineImage!.path),
                                        width: 120,
                                        height: 90,
                                        fit: BoxFit.cover,
                                      )
                                : const SizedBox()

                            //  FadeInImage.assetNetwork(
                            //     placeholder: Images.placeholder,
                            //     image:
                            //         'https://momofooddelivery.com/storage/app/public/onlinepayments/${orderController.pickOnlineImage}',
                            //     height: 190,
                            //     width: 120,
                            //     fit: BoxFit.cover,
                            //     imageErrorBuilder: (c, o, s) => Image.asset(
                            //         Images.placeholder,
                            //         height: 120,
                            //         width: 150,
                            //         fit: BoxFit.cover),
                            //   ),

                            ),
                        InkWell(
                          onTap: () => orderController.pickImage(true),
                          child: Container(
                            width: 120,
                            height: 90,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              borderRadius:
                                  BorderRadius.circular(Dimensions.radiusSmall),
                              border: Border.all(
                                  width: 1,
                                  color: Theme.of(context).primaryColor),
                            ),
                            child: Container(
                              margin: const EdgeInsets.all(25),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 2, color: Colors.white),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.camera_alt,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ])),
                ],
              ),
            
            AuthHelper.isGuestLoggedIn()? const SizedBox(height: Dimensions.paddingSizeSmall):const SizedBox(),
            AuthHelper.isGuestLoggedIn()? Text('Contact Person Number'.tr, style: robotoMedium):
            Text('additional_note'.tr, style: robotoMedium),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            AuthHelper.isGuestLoggedIn()?
            CustomTextField(
              controller: _noteController,
              titleText: 'please enter your phone number'.tr,
              maxLines: 1,
              inputType: TextInputType.number,
              inputAction: TextInputAction.done,
              capitalization: TextCapitalization.sentences,
            ):  CustomTextField(
              controller: _noteController,
              titleText: 'ex_please_provide_extra_napkin'.tr,
              maxLines: 3,
              inputType: TextInputType.number,
              inputAction: TextInputAction.done,
              capitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),
            if (orderController.orderType == 'dine_in')
              CustomTextField(
                hintText: "table_no".tr,
                //inputType: TextInputType.streetAddress,
                focusNode: _streetNode,
                nextFocus: _houseNode,
                controller: _streetNumberController,
              ),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('item_price'.tr, style: robotoMedium),
              Text(
                  PriceConverter.convertPrice(
                      Get.find<CartController>().subTotal),
                  style: robotoMedium,
                  textDirection: TextDirection.ltr),
            ]),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('discount'.tr, style: robotoRegular),
              Row(children: [
                Text('(-) ', style: robotoRegular),
                PriceConverter.convertAnimationPrice(discount,
                    textStyle: robotoRegular)
              ]),
              // Text('(-) ${PriceConverter.convertPrice(discount)}', style: robotoRegular, textDirection: TextDirection.ltr),
            ]),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            (additionalCharge > 0)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        Text(
                            Get.find<SplashController>()
                                .configModel!
                                .additionalChargeName!,
                            style: robotoRegular),
                        Text(
                            '(+) ${PriceConverter.convertPrice(additionalCharge)}',
                            style: robotoRegular,
                            textDirection: TextDirection.ltr),
                      ])
                : const SizedBox(),
            (additionalCharge > 0)
                ? const SizedBox(height: 10)
                : const SizedBox(),
            (couponController.discount! > 0 || couponController.freeDelivery)
                ? Column(children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('coupon_discount'.tr, style: robotoRegular),
                          (couponController.coupon != null &&
                                  couponController.coupon!.couponType ==
                                      'free_delivery')
                              ? Text(
                                  'free_delivery'.tr,
                                  style: robotoRegular.copyWith(
                                      color: Theme.of(context).primaryColor),
                                )
                              : Text(
                                  '(-) ${PriceConverter.convertPrice(couponController.discount)}',
                                  style: robotoRegular,
                                  textDirection: TextDirection.ltr,
                                ),
                        ]),
                    const SizedBox(height: Dimensions.paddingSizeSmall),
                  ])
                : const SizedBox(),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(
                  '${'vat_tax'.tr} ${taxIncluded ? 'tax_included'.tr : ''} ($_taxPercent%)',
                  style: robotoRegular),
              Text(
                  (taxIncluded ? '' : '(+) ') +
                      PriceConverter.convertPrice(tax),
                  style: robotoRegular,
                  textDirection: TextDirection.ltr),
            ]),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Software Service Fee'.tr,
             //  ($_appServiceFeePercent%)',
                  style: robotoRegular),
              Text(('(+) ') + PriceConverter.convertPrice(getServiceFeeDisplayValue(appServiceFee)),
                  style: robotoRegular, textDirection: TextDirection.ltr),
            ]),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            (orderController.orderType == 'delivery' &&
                    Get.find<SplashController>().configModel!.dmTipsStatus ==
                        1 &&
                    !orderController.subscriptionOrder)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('delivery_man_tips'.tr, style: robotoRegular),
                      Row(children: [
                        Text('(+) ', style: robotoRegular),
                        PriceConverter.convertAnimationPrice(
                            orderController.tips,
                            textStyle: robotoRegular)
                      ]),
                      // Text('(+) ${PriceConverter.convertPrice(orderController.tips)}', style: robotoRegular, textDirection: TextDirection.ltr),
                    ],
                  )
                : const SizedBox.shrink(),
            SizedBox(
                height: orderController.orderType == 'delivery' &&
                        Get.find<SplashController>()
                                .configModel!
                                .dmTipsStatus ==
                            1 &&
                        !orderController.subscriptionOrder
                    ? Dimensions.paddingSizeSmall
                    : 0.0),
            orderController.orderType == 'delivery'
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        Text('delivery_fee'.tr, style: robotoRegular),
                        orderController.distance == -1
                            ? Text(
                                'calculating'.tr,
                                style:
                                    robotoRegular.copyWith(color: Colors.red),
                              )
                            : (deliveryCharge == 0 ||
                                    (couponController.coupon != null &&
                                        couponController.coupon!.couponType ==
                                            'free_delivery'))
                                ? Text(
                                    'free'.tr,
                                    style: robotoRegular.copyWith(
                                        color: Theme.of(context).primaryColor),
                                  )
                                : Text(
                                    '(+) ${PriceConverter.convertPrice(deliveryCharge)}',
                                    style: robotoRegular,
                                    textDirection: TextDirection.ltr,
                                  ),
                      ])
                : const SizedBox(),
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: Dimensions.paddingSizeSmall),
              child: Divider(
                  thickness: 1,
                  color: Theme.of(context).hintColor.withOpacity(0.5)),
            ),
            ResponsiveHelper.isDesktop(context)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        Text(
                          'total_amount'.tr,
                          style: robotoMedium.copyWith(
                              fontSize: Dimensions.fontSizeLarge,
                              color: Theme.of(context).primaryColor),
                        ),
                         PriceConverter.convertAnimationPrice(
                          total,
                          textStyle: robotoMedium.copyWith(
                              fontSize: Dimensions.fontSizeLarge,
                              color: Theme.of(context).primaryColor),
                        ),

                        // Text(
                        //   PriceConverter.convertPrice(total), textDirection: TextDirection.ltr,
                        //   style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor),
                        // ),
                      ])
                : const SizedBox(),
            const SizedBox(height: Dimensions.paddingSizeLarge),
            CheckoutCondition(orderController: orderController),
          ]),
        ),
        ResponsiveHelper.isDesktop(context)
            ? Padding(
                padding:
                    const EdgeInsets.only(top: Dimensions.paddingSizeLarge),
                child: _orderPlaceButtonForGuest(
                    orderController,
                    restaurantController,
                    locationController,
                    todayClosed,
                    tomorrowClosed,
                    orderAmount,
                    deliveryCharge,
                    tax,
                    appServiceFee,
                    discount,
                    total,
                    maxCodOrderAmount,
                    subscriptionQty),
              )
            : const SizedBox(),
      ]),
    );
  }

  void _callback(
      bool isSuccess, String message, String orderID, double amount) async {
    if (isSuccess) {
      Get.find<OrderController>().getRunningOrders(1, notify: false);
      if (widget.fromCart) {
        Get.find<CartController>().clearCartList();
      }
      Get.find<OrderController>().stopLoader();
      if (Get.find<OrderController>().paymentMethodIndex == 0 ||
          Get.find<OrderController>().paymentMethodIndex == 2 ||
          Get.find<OrderController>().paymentMethodIndex == 3) {
        Get.offNamed(
            RouteHelper.getOrderSuccessRoute(orderID, 'success', amount));
        double total = ((amount / 100) *
            Get.find<SplashController>()
                .configModel!
                .loyaltyPointItemPurchasePoint!);
        Get.find<AuthController>().saveEarningPoint(total.toStringAsFixed(0));
      } else {
        if (GetPlatform.isWeb) {
          Get.back();
          String? hostname = html.window.location.hostname;
          String protocol = html.window.location.protocol;
          String selectedUrl =
              '${AppConstants.baseUrl}/payment-mobile?order_id=$orderID&customer_id=${Get.find<UserController>().userInfoModel!.id}&&callback=$protocol//$hostname${RouteHelper.orderSuccess}?id=$orderID&amount=$amount&status=';
          html.window.open(selectedUrl, "_self");
        } else {
          Get.offNamed(
            RouteHelper.getPaymentRoute(OrderModel(
                id: int.parse(orderID),
                userId: Get.find<UserController>().userInfoModel!.id,
                orderAmount: amount,
                restaurant: Get.find<RestaurantController>().restaurant)),
          );
        }
      }
      Get.find<OrderController>().clearPrevData();
      //Get.find<OrderController>().updateTips(-1);
      Get.find<CouponController>().removeCouponData(false);
    } else {
      showCustomSnackBar(message);
    }
  }

  ///place Order Button
  Widget _orderPlaceButton(
      OrderController orderController,
      RestaurantController restController,
      LocationController locationController,
      bool todayClosed,
      bool tomorrowClosed,
      double orderAmount,
      double? deliveryCharge,
      double tax,
      double appServiceFee,
      double? discount,
      double total,
      double? maxCodOrderAmount,
      int subscriptionQty) {
    return SafeArea(
      child: Padding(
        padding:  EdgeInsets.all(10.w),
        child: CustomButton(
            width: MediaQuery.of(context).size.width/2,
      
            buttonText: 'confirm_order'.tr,
            radius: Dimensions.roundRadius,
            isLoading: orderController.isLoading,
            onPressed: () async {
              String? imagePath;
              if (orderController.pickOnlineImage != null) {
                imagePath = await orderController
                    .storeOrderImage(orderController.pickOnlineImage);
                if (imagePath == null) {
      
                  // Handle error appropriately
                  return;
                }
              }
              bool isAvailable = true;
              bool isDinein = true;
              DateTime scheduleStartDate = DateTime.now();
              DateTime scheduleEndDate = DateTime.now();
      
              if (orderController.timeSlots == null ||
                  orderController.timeSlots!.isEmpty ||
                  (orderController.orderType == "dine_in" &&
                      int.tryParse(widget.tableId)== 0)) {
                isAvailable = false;
              } else {
                DateTime date = orderController.selectedDateSlot == 0
                    ? DateTime.now()
                    : DateTime.now().add(const Duration(days: 1));
                DateTime startTime = orderController
                    .timeSlots![orderController.selectedTimeSlot!].startTime!;
                DateTime endTime = orderController
                    .timeSlots![orderController.selectedTimeSlot!].endTime!;
                scheduleStartDate = DateTime(date.year, date.month, date.day,
                    startTime.hour, startTime.minute + 1);
                scheduleEndDate = DateTime(date.year, date.month, date.day,
                    endTime.hour, endTime.minute + 1);
      
                for (CartModel cart in _cartList) {
                  if (!DateConverter.isAvailable(
                        cart.product!.availableTimeStarts,
                        cart.product!.availableTimeEnds,
                        time: restController.restaurant!.scheduleOrder!
                            ? scheduleStartDate
                            : null,
                      ) &&
                      !DateConverter.isAvailable(
                        cart.product!.availableTimeStarts,
                        cart.product!.availableTimeEnds,
                        time: restController.restaurant!.scheduleOrder!
                            ? scheduleEndDate
                            : null,
                      )) {
                    isAvailable = false;
                    break;
                  }
                }
              }
              if ((orderController.orderType == "dine_in" &&
                  (int.tryParse(widget.tableId) ?? 0) == 0)) {
                isDinein = false;
              }
      
              bool datePicked = false;
              for (DateTime? time in orderController.selectedDays) {
                if (time != null) {
                  datePicked = true;
                  break;
                }
              }
      
              if (Get.find<OrderController>().isDmTipSave) {
                Get.find<AuthController>().saveDmTipIndex(
                    Get.find<OrderController>().selectedTips.toString());
              }
      
              if (!_isCashOnDeliveryActive! &&
                  !_isDigitalPaymentActive! &&
                  !_isWalletActive &&
                  !_isOnlinePaymentActive!) {
                showCustomSnackBar('no_payment_method_is_enabled'.tr);
              } else if (orderAmount <
                  restController.restaurant!.minimumOrder!) {
                showCustomSnackBar(
                    '${'minimum_order_amount_is'.tr} ${restController.restaurant!.minimumOrder}');
              } else if (orderController.subscriptionOrder &&
                  orderController.subscriptionRange == null) {
                showCustomSnackBar('select_a_date_range_for_subscription'.tr);
              } else if (orderController.subscriptionOrder &&
                  !datePicked &&
                  orderController.subscriptionType == 'daily') {
                showCustomSnackBar('choose_time'.tr);
              } else if (orderController.subscriptionOrder && !datePicked) {
                showCustomSnackBar(
                    'select_at_least_one_day_for_subscription'.tr);
              } else if ((orderController.selectedDateSlot == 0 &&
                      todayClosed) ||
                  (orderController.selectedDateSlot == 1 && tomorrowClosed)) {
                showCustomSnackBar('restaurant_is_closed'.tr);
              } else if (orderController.paymentMethodIndex == 0 &&
                  Get.find<SplashController>().configModel!.cashOnDelivery! &&
                  maxCodOrderAmount != null &&
                  (total > maxCodOrderAmount)) {
                showCustomSnackBar(
                    '${'you_cant_order_more_then'.tr} ${PriceConverter.convertPrice(maxCodOrderAmount)} ${'in_cash_on_delivery'.tr}');
              } else if (orderController.timeSlots == null ||
                  orderController.timeSlots!.isEmpty) {
                if (restController.restaurant!.scheduleOrder! &&
                    !orderController.subscriptionOrder) {
                  showCustomSnackBar('select_a_time'.tr);
                } else {
                  showCustomSnackBar('restaurant_is_closed'.tr);
                }
              }  else if (!isDinein) {
                showCustomSnackBar('go_to_shop'.tr);
              }
              else if (!isAvailable && !orderController.subscriptionOrder) {
                showCustomSnackBar(
                    'one_or_more_products_are_not_available_for_this_selected_time'
                        .tr);
              } else if (orderController.orderType == 'delivery' &&
                  orderController.distance == -1 &&
                  deliveryCharge == -1) {
                showCustomSnackBar('delivery_fee_not_set_yet'.tr);
              } else if(AuthHelper.isGuestLoggedIn()&& _noteController.text.isEmpty){
                 showCustomSnackBar('please enter your phone number'.tr);
              }
              else if(orderController.paymentMethodIndex==3 && _accountName.text.isEmpty){
                 showCustomSnackBar(
                    'Please enter your account number'
                        .tr);
              }
              // else if(orderController.paymentMethodIndex==3 && _transitionNo.text.isEmpty){
              //    showCustomSnackBar(
              //       'Please enter your transition number'
              //           .tr);
              // }
              else if(orderController.paymentMethodIndex==3 && imagePath==null){
                 showCustomSnackBar(
                    'Please enter your E-Receipt'
                        .tr);
              }
              else if (orderController.paymentMethodIndex == 2 &&
                  Get.find<UserController>().userInfoModel != null &&
                  Get.find<UserController>().userInfoModel!.walletBalance! <
                      total) {
                showCustomSnackBar(
                    'you_do_not_have_sufficient_balance_in_wallet'.tr);
              } else {
                List<Cart> carts = [];
                for (int index = 0; index < _cartList.length; index++) {
                  CartModel cart = _cartList[index];
                  List<int?> addOnIdList = [];
                  List<int?> addOnQtyList = [];
                  List<OrderVariation> variations = [];
                  for (var addOn in cart.addOnIds!) {
                    addOnIdList.add(addOn.id);
                    addOnQtyList.add(addOn.quantity);
                  }
                  if (cart.product!.variations != null) {
                    for (int i = 0; i < cart.product!.variations!.length; i++) {
                      if (cart.variations![i].contains(true)) {
                        variations.add(OrderVariation(
                            name: cart.product!.variations![i].name,
                            values: OrderVariationValue(label: [])));
                        for (int j = 0;
                            j <
                                cart.product!.variations![i].variationValues!
                                    .length;
                            j++) {
                          if (cart.variations![i][j]!) {
                            variations[variations.length - 1]
                                .values!
                                .label!
                                .add(cart.product!.variations![i]
                                    .variationValues![j].level);
                          }
                        }
                      }
                    }
                  }
                  carts.add(Cart(
                    cart.isCampaign! ? null : cart.product!.id,
                    cart.isCampaign! ? cart.product!.id : null,
                    cart.discountedPrice.toString(),
                    '',
                    variations,
                    cart.quantity,
                    addOnIdList,
                    cart.addOns,
                    addOnQtyList,
                  ));
                }
      
                List<SubscriptionDays> days = [];
                for (int index = 0;
                    index < orderController.selectedDays.length;
                    index++) {
                  if (orderController.selectedDays[index] != null) {
                    days.add(SubscriptionDays(
                      day: orderController.subscriptionType == 'weekly'
                          ? (index == 6 ? 0 : (index + 1)).toString()
                          : orderController.subscriptionType == 'monthly'
                              ? (index + 1).toString()
                              : index.toString(),
                      time: DateConverter.dateToTime(
                          orderController.selectedDays[index]!),
                    ));
                  }
                }
                AddressModel finalAddress =
                    address[orderController.addressIndex];
      
                ///calculate tip
                ///
      
                int? tips = int.tryParse(_tipController.text.trim());
      
                //place order here
                orderController.placeOrder(
                    PlaceOrderBody(
                        cart: carts,
                        couponDiscountAmount:
                            Get.find<CouponController>().discount,
                        distance: orderController.distance,
                        couponDiscountTitle: Get.find<CouponController>().discount! > 0
                            ? Get.find<CouponController>().coupon!.title
                            : null,
                        scheduleAt: !restController.restaurant!.scheduleOrder!
                            ? null
                            : (orderController.selectedDateSlot == 0 &&
                                    orderController.selectedTimeSlot == 0)
                                ? null
                                : DateConverter.dateToDateAndTime(
                                    scheduleStartDate),
                        orderAmount: total,
                        orderNote: _noteController.text,
                        transitionNo: _transitionNo.text,
                        image: imagePath,
                        accountName: _accountName.text,
                        orderType: orderController.orderType,
                        paymentMethod: orderController.paymentMethodIndex == 0
                            ? 'cash_on_delivery'
                            : orderController.paymentMethodIndex == 1
                                ? 'digital_payment'
                                : orderController.paymentMethodIndex == 2
                                    ? 'wallet'
                                    : 'kpay',
                        couponCode: (Get.find<CouponController>().discount! > 0 ||
                                (Get.find<CouponController>().coupon != null &&
                                    Get.find<CouponController>().freeDelivery))
                            ? Get.find<CouponController>().coupon!.code
                            : null,
                        restaurantId: _cartList[0].product!.restaurantId,
                        address: finalAddress.address,
                        latitude:
                            double.tryParse(finalAddress.latitude.toString()),
                        longitude:
                            double.tryParse(finalAddress.longitude.toString()),
                        addressType: finalAddress.addressType,
                        contactPersonName:
                            '${Get.find<UserController>().userInfoModel!.fName} '
                                    '${Get.find<UserController>().userInfoModel!.lName}',
      
                        contactPersonNumber: Get.find<UserController>().userInfoModel!.phone,
      
                        discountAmount: discount,
                        taxAmount: tax,
                        appServiceFee: appServiceFee,
                        road: _streetNumberController.text.trim(),
                        cutlery: Get.find<CartController>().addCutlery ? 1 : 0,
                        house: _houseController.text.trim(),
                        floor: _floorController.text.trim(),
                        dmTips: tips != null ? tips.toString() : "",
                        subscriptionOrder:
                            orderController.subscriptionOrder ? '1' : '0',
                        subscriptionType: orderController.subscriptionType,
                        subscriptionQuantity: subscriptionQty.toString(),
                        subscriptionDays: days,
                        subscriptionStartAt: orderController.subscriptionOrder
                            ? DateConverter.dateToDateAndTime(
                                orderController.subscriptionRange!.start)
                            : '',
                        subscriptionEndAt: orderController.subscriptionOrder
                            ? DateConverter.dateToDateAndTime(orderController.subscriptionRange!.end)
                            : '',
                        unavailableItemNote: Get.find<CartController>().notAvailableIndex != -1 ? Get.find<CartController>().notAvailableList[Get.find<CartController>().notAvailableIndex] : '',
                        deliveryInstruction: orderController.selectedInstruction != -1 ? AppConstants.deliveryInstructionList[orderController.selectedInstruction] : '',
                       // guestId: (int.tryParse(widget.tableId))! > 0 ? widget.tableId : AuthHelper.getGuestId()
                        ),
                    _callback,
                    total);
              }
            }),
      ),
    );
  }

  Widget _orderPlaceButtonForGuest(
      OrderController orderController,
      RestaurantController restController,
      LocationController locationController,
      bool todayClosed,
      bool tomorrowClosed,
      double orderAmount,
      double? deliveryCharge,
      double tax,
      double appServiceFee,
      double? discount,
      double total,
      double? maxCodOrderAmount,
      int subscriptionQty) {
    return Container(
      width: Dimensions.webMaxWidth,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
      child: SafeArea(
        child: CustomButton(
            buttonText: 'confirm_order'.tr,
            radius: Dimensions.radiusDefault,
            isLoading: orderController.isLoading,
            
            onPressed: () async {
              bool isDinein=true;
              
              String? imagePath;
              if (orderController.pickOnlineImage != null) {
                imagePath = await orderController
                    .storeOrderImage(orderController.pickOnlineImage);
                if (imagePath == null) {
                  log("Image upload failed or returned null path.");
                  // Handle error appropriately
                  return;
                }
              }
               if ((orderController.orderType == "dine_in" ||
                  (int.tryParse(widget.tableId) ?? 0) > 0)) {
                isDinein = false;
              }

              if (Get.find<OrderController>().isDmTipSave) {
                Get.find<AuthController>().saveDmTipIndex(
                    Get.find<OrderController>().selectedTips.toString());
              }

              // if (isDinein==false) {
              //   showCustomSnackBar('go_to'.tr);
              // } 
              

                
               if(_noteController.text.isEmpty){
                showCustomSnackBar('Enter your phone number'.tr);
              }

              
              else {
                List<Cart> carts = [];

                for (int index = 0; index < _cartList.length; index++) {
                  CartModel cart = _cartList[index];
                  List<int?> addOnIdList = [];
                  List<int?> addOnQtyList = [];
                  List<OrderVariation> variations = [];
                  for (var addOn in cart.addOnIds!) {
                    addOnIdList.add(addOn.id);
                    addOnQtyList.add(addOn.quantity);
                  }
                  if (cart.product!.variations != null) {
                    for (int i = 0; i < cart.product!.variations!.length; i++) {
                      if (cart.variations![i].contains(true)) {
                        variations.add(OrderVariation(
                            name: cart.product!.variations![i].name,
                            values: OrderVariationValue(label: [])));
                        for (int j = 0;
                            j <
                                cart.product!.variations![i].variationValues!
                                    .length;
                            j++) {
                          if (cart.variations![i][j]!) {
                            variations[variations.length - 1]
                                .values!
                                .label!
                                .add(cart.product!.variations![i]
                                    .variationValues![j].level);
                          }
                        }
                      }
                    }
                  }
                   

                  carts.add(Cart(
                    cart.isCampaign! ? null : cart.product!.id,
                    cart.isCampaign! ? cart.product!.id : null,
                    cart.discountedPrice.toString(),
                    '',
                    variations,
                    // cart.isCampaign!?null:
                    Get.find<CartController>().cartList.first.quantity,
                    addOnIdList,
                    
                    Get.find<CartController>().cartList.first.addOns,
                    addOnQtyList,
                  ));
                }
                log("cartList1$carts");
                log("quantity:eeee${Get.find<CartController>().cartList.first.quantity}");
                log("productID${Get.find<CartController>().cartList.first.product!.id}");
                AddressModel finalAddress =
                    address[orderController.addressIndex];
                // print("RestaurantId:${_cartList[0].product!.restaurantId}");
                //place order here
                orderController.placeOrderForGuest(
                    PlaceOrderBody(
                        cart: carts,
                        couponDiscountAmount: 0.0,
                        distance: orderController.distance,
                        couponDiscountTitle: "",
                        scheduleAt: "",
                        orderAmount: total,
                        orderNote: _noteController.text,
                        transitionNo: "",
                        image: imagePath,
                        accountName: "Walking Customer",
                        orderType: orderController.orderType,
                        paymentMethod: 'cash_on_delivery',
                        couponCode: "",
                        restaurantId: Get.find<CartController>()
                            .cartList
                            .first
                            .product!
                            .restaurantId,
                        address: finalAddress.address??"Dine in Customer",
                        latitude:
                            double.tryParse(finalAddress.latitude.toString())??0.0,
                        longitude:
                            double.tryParse(finalAddress.longitude.toString())??0.0,
                        addressType: finalAddress.addressType,
                        contactPersonName: "Walking Customer",
                        contactPersonNumber: _noteController.text??"09",
                        tableId: widget.tableId ?? "0",
                        discountAmount: discount,
                        taxAmount: tax,
                        appServiceFee: appServiceFee,
                        road: _streetNumberController.text.trim(),
                        cutlery: 0,
                        house: " ",
                        floor: _floorController.text.trim(),
                        dmTips: "",
                        subscriptionOrder: '0',
                        subscriptionType: "1",
                        subscriptionQuantity: "1",
                        subscriptionDays: [],
                        subscriptionStartAt: '',
                        subscriptionEndAt: '',
                        unavailableItemNote: '',
                        deliveryInstruction: '',
                        guestId: (int.tryParse(widget.tableId))! > 0
                            ? widget.tableId
                            : AuthHelper.getGuestId()),
                    _callbackForGuest,
                    total);
              }
            }),
      ),
    );
  }


double getServiceFeeDisplayValue(double appServiceFee) {
  
double serviceFeeApproximate =appServiceFee>0? ((appServiceFee / 50).ceil()) * 50:0;
  
  return serviceFeeApproximate;
}
 
 
 
 
  void _callbackForGuest(
      bool isSuccess, String message, String orderID, double amount) async {
    if (isSuccess) {
      Get.find<OrderController>().getRunningOrders(1, notify: false);
      if (widget.fromCart) {
        Get.find<CartController>().clearCartList();
      }
      Get.offNamed(
          RouteHelper.getOrderSuccessRoute(orderID, 'success', amount));
      Get.find<OrderController>().stopLoader();
    }
    Get.find<OrderController>().clearPrevData();
  }
}

String _getDeliveryCharge(
    {required String orderType,
    required bool isFreeDelivery,
    required double charge,
    required double deliveryCharge}) {
  ///free?
  if (orderType != 'delivery' ||
      (orderType == 'delivery' ? isFreeDelivery : true)) {
    return 'free'.tr;
  } else if (charge != -1) {
    return PriceConverter.convertPrice(
        orderType == 'delivery' ? charge : deliveryCharge);
  } else {
    return 'calculating'.tr;
  }

  //   return (orderType == 'take_away' ||
  //           (orderType == 'delivery' ? isFreeDelivery : true))
  //       ? 'free'.tr
  //       : charge != -1
  //           ? PriceConverter.convertPrice(
  //               orderType == 'delivery' ? charge : deliveryCharge)
  //           : 'calculating'.tr;
}

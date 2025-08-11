import 'dart:convert';

import 'package:user/data/model/response/product_model.dart';

class PlaceOrderBody {
  List<Cart>? _cart;
  double? _couponDiscountAmount;
  String? _couponDiscountTitle;
  double? _orderAmount;
  String? _orderType;
  String? _paymentMethod;
  String? _orderNote;
  String? _image;
  String? _transitionNo;
  String? _accountName;
  String? _couponCode;
  int? _restaurantId;
  double? _distance;
  String? _scheduleAt;
  double? _discountAmount;
  double? _taxAmount;
  double? _appServiceFee;
  String? _address;
  double? _latitude;
  double? _longitude;
  String? _contactPersonName;
  String? _contactPersonNumber;
  String? _addressType;
  String? _road;
  String? _house;
  String? _floor;
  String? _dmTips;
  String? _subscriptionOrder;
  String? _subscriptionType;
  List<SubscriptionDays>? _subscriptionDays;
  String? _subscriptionQuantity;
  String? _subscriptionStartAt;
  String? _subscriptionEndAt;
  int? _cutlery;
  String? _unavailableItemNote;
  String? _deliveryInstruction;
  String? _guestId;
  String? _tableId;

  PlaceOrderBody({
    required List<Cart> cart,
    required double? couponDiscountAmount,
    required String? couponDiscountTitle,
    required String? couponCode,
    required double orderAmount,
    required String orderType,
    required String paymentMethod,
    required int? restaurantId,
    required double? distance,
    required String? scheduleAt,
    required double? discountAmount,
    required double taxAmount,
    required double appServiceFee,
    String? image,
    required String orderNote,
    required String? transitionNo,
    required String? accountName,
    required String? address,
    required double? latitude,
    required double? longitude,
    required String contactPersonName,
    required String? contactPersonNumber,
    required String? addressType,
    required String road,
    required String house,
    required String floor,
    required String dmTips,
    required String subscriptionOrder,
    required String? subscriptionType,
    required List<SubscriptionDays> subscriptionDays,
    required String subscriptionQuantity,
    required String subscriptionStartAt,
    required String subscriptionEndAt,
    required int cutlery,
    required String unavailableItemNote,
    required String deliveryInstruction,
    String? guestId,
    String? tableId,
    // required String? orderNote,
  }) {
    _cart = cart;
    _couponDiscountAmount = couponDiscountAmount;
    _couponDiscountTitle = couponDiscountTitle;
    _orderAmount = orderAmount;
    _orderType = orderType;
    _paymentMethod = paymentMethod;

    _orderNote = orderNote;
    _image = image;
    _transitionNo = transitionNo;
    _accountName = accountName;
    _couponCode = couponCode;
    _restaurantId = restaurantId;
    _distance = distance;
    _scheduleAt = scheduleAt;
    _discountAmount = discountAmount;
    _taxAmount = taxAmount;
    _appServiceFee = appServiceFee;
    _address = address;
    _latitude = latitude;
    _longitude = longitude;
    _contactPersonName = contactPersonName;
    _contactPersonNumber = contactPersonNumber;
    _addressType = addressType;
    _road = road;
    _house = house;
    _floor = floor;
    _dmTips = dmTips;
    _subscriptionOrder = subscriptionOrder;
    _subscriptionType = subscriptionType;
    _subscriptionDays = subscriptionDays;
    _subscriptionQuantity = subscriptionQuantity;
    _subscriptionStartAt = subscriptionStartAt;
    _subscriptionEndAt = subscriptionEndAt;
    _cutlery = cutlery;
    _unavailableItemNote = unavailableItemNote;
    _deliveryInstruction = deliveryInstruction;
    _guestId = guestId;
    _tableId = tableId;
  }

  List<Cart>? get cart => _cart;
  double? get couponDiscountAmount => _couponDiscountAmount;
  String? get couponDiscountTitle => _couponDiscountTitle;
  double? get orderAmount => _orderAmount;
  String? get orderType => _orderType;
  String? get paymentMethod => _paymentMethod;
  String? get orderNote => _orderNote;
  String? get image => _image;
  String? get transitionNo => _transitionNo;
  String? get accountName => _accountName;
  String? get couponCode => _couponCode;
  int? get restaurantId => _restaurantId;
  double? get distance => _distance;
  String? get scheduleAt => _scheduleAt;
  double? get discountAmount => _discountAmount;
  double? get taxAmount => _taxAmount;
  double? get appServiceFee => _appServiceFee;
  String? get address => _address;
  double? get latitude => _latitude;
  double? get longitude => _longitude;
  String? get contactPersonName => _contactPersonName;
  String? get contactPersonNumber => _contactPersonNumber;
  String? get road => _road;
  String? get house => _house;
  String? get floor => _floor;
  String? get dmTips => _dmTips;
  String? get subscriptionOrder => _subscriptionOrder;
  String? get subscriptionType => _subscriptionType;
  List<SubscriptionDays>? get subscriptionDays => _subscriptionDays;
  String? get subscriptionQuantity => _subscriptionQuantity;
  String? get subscriptionStartAt => _subscriptionStartAt;
  String? get subscriptionEndAt => _subscriptionEndAt;
  int? get cutlery => _cutlery;
  String? get unavailableItemNote => _unavailableItemNote;
  String? get deliveryInstruction => _deliveryInstruction;
  String? get guestId => _guestId;
  String? get tableId => _tableId;

  PlaceOrderBody.fromJson(Map<String, dynamic> json) {
    if (json['cart'] != null) {
      _cart = [];
      json['cart'].forEach((v) {
        _cart!.add(Cart.fromJson(v));
      });
    }
    _couponDiscountAmount = json['coupon_discount_amount'];
    _couponDiscountTitle = json['coupon_discount_title'];
    _orderAmount = json['order_amount'];
    _orderType = json['order_type'];
    _paymentMethod = json['payment_method'];
    _orderNote = json['order_note'];
    _image = json['kpay_image'];
    _transitionNo = json['kpay_transition'];
    _accountName = json['kpay_name'];
    _couponCode = json['coupon_code'];
    _restaurantId = json['restaurant_id'];
    _distance = json['distance'];
    _scheduleAt = json['schedule_at'];
    _discountAmount = json['discount_amount'].toDouble();
    _taxAmount = json['tax_amount'].toDouble();
    _appServiceFee = json['app_service_fee'].toDouble();
    _address = json['address'];
    _latitude = json['latitude'];
    _longitude = json['longitude'];
    _contactPersonName = json['contact_person_name'];
    _contactPersonNumber = json['contact_person_number'];
    _addressType = json['address_type'];
    _road = json['road'];
    _house = json['house'];
    _floor = json['floor'];
    _dmTips = json['dm_tips'];
    _subscriptionOrder = json['subscription_order'];
    _subscriptionType = json['subscription_type'];
    if (json['subscription_days'] != null) {
      _subscriptionDays = <SubscriptionDays>[];
      json['subscription_days'].forEach((v) {
        _subscriptionDays!.add(SubscriptionDays.fromJson(v));
      });
    }
    _subscriptionQuantity = json['subscription_quantity'];
    _subscriptionStartAt = json['subscription_start_at'];
    _subscriptionEndAt = json['subscription_end_at'];
    _cutlery = json['cutlery'];
    _unavailableItemNote = json['unavailable_item_note'];
    _deliveryInstruction = json['delivery_instruction'];
    _guestId = json['guest_id'];
    _tableId = json['table_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (_cart != null) {
      data['cart'] = _cart!.map((v) => v.toJson()).toList();
    }
    data['coupon_discount_amount'] = _couponDiscountAmount;
    data['coupon_discount_title'] = _couponDiscountTitle;
    data['order_amount'] = _orderAmount;
    data['order_type'] = _orderType;
    data['payment_method'] = _paymentMethod;
    data['order_note'] = _orderNote;
    data['kpay_image'] = _image;
    data['kpay_transition'] = _transitionNo;
    data['kpay_name'] = _accountName;
    data['coupon_code']=_couponCode;

    data['restaurant_id'] = _restaurantId;
    data['distance'] = _distance;
    data['schedule_at'] = _scheduleAt;
    data['discount_amount'] = _discountAmount;
    data['tax_amount'] = _taxAmount;
    data['app_service_fee'] = appServiceFee;
    data['address'] = _address;
    data['latitude'] = _latitude;
    data['longitude'] = _longitude;
    data['contact_person_name'] = _contactPersonName;
    data['contact_person_number'] = _contactPersonNumber;
    data['address_type'] = _addressType;
    data['road'] = _road;
    data['house'] = _house;
    data['floor'] = _floor;
    data['dm_tips'] = _dmTips;
    data['subscription_order'] = _subscriptionOrder;
    data['subscription_type'] = _subscriptionType;
    if (_subscriptionDays != null) {
      data['subscription_days'] =
          jsonEncode(_subscriptionDays!.map((v) => v.toJson()).toList());
    }
    data['subscription_quantity'] = _subscriptionQuantity;
    data['subscription_start_at'] = _subscriptionStartAt;
    data['subscription_end_at'] = _subscriptionEndAt;
    data['unavailable_item_note'] = _unavailableItemNote!;
    data['delivery_instruction'] = _deliveryInstruction!;
    data['guest_id'] = _guestId;
    data['table_id'] = _tableId;
    // data['cutlery'] = _cutlery;

    if (_cutlery != null) {
      data['cutlery'] = _cutlery.toString();
    }
    return data;
  }
}

class Cart {
  int? _foodId;
  int? _itemCampaignId;
  String? _price;
  String? _variant;
  List<OrderVariation>? _variation;
  int? _quantity;
  List<int?>? _addOnIds;
  List<AddOns>? _addOns;
  List<int?>? _addOnQtys;

  Cart(
      int? foodId,
      int? itemCampaignId,
      String price,
      String variant,
      List<OrderVariation> variation,
      int? quantity,
      List<int?> addOnIds,
      List<AddOns>? addOns,
      List<int?> addOnQtys) {
    _foodId = foodId;
    _itemCampaignId = itemCampaignId;
    _price = price;
    _variant = variant;
    _variation = variation;
    _quantity = quantity;
    _addOnIds = addOnIds;
    _addOns = addOns;
    _addOnQtys = addOnQtys;
  }

  int? get foodId => _foodId;
  int? get itemCampaignId => _itemCampaignId;
  String? get price => _price;
  String? get variant => _variant;
  List<OrderVariation>? get variation => _variation;
  int? get quantity => _quantity;
  List<int?>? get addOnIds => _addOnIds;
  List<AddOns>? get addOns => _addOns;
  List<int?>? get addOnQtys => _addOnQtys;

  Cart.fromJson(Map<String, dynamic> json) {
    _foodId = json['food_id'];
    _itemCampaignId = json['item_campaign_id'];
    _price = json['price'];
    _variant = json['variant'];
    if (json['variation'] != null) {
      _variation = [];
      json['variations'].forEach((v) {
        _variation!.add(OrderVariation.fromJson(v));
      });
    }
    _quantity = json['quantity'];
    _addOnIds = json['add_on_ids'].cast<int>();
    if (json['add_ons'] != null) {
      _addOns = [];
      json['add_ons'].forEach((v) {
        _addOns!.add(AddOns.fromJson(v));
      });
    }
    _addOnQtys = json['add_on_qtys'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['food_id'] = _foodId;
    data['item_campaign_id'] = _itemCampaignId;
    data['price'] = _price;
    data['variant'] = _variant;
    if (_variation != null) {
      data['variations'] = _variation!.map((v) => v.toJson()).toList();
    }
    data['quantity'] = _quantity;
    data['add_on_ids'] = _addOnIds;
    if (_addOns != null) {
      data['add_ons'] = _addOns!.map((v) => v.toJson()).toList();
    }
    data['add_on_qtys'] = _addOnQtys;
    return data;
  }
}

class OrderVariation {
  String? name;
  OrderVariationValue? values;

  OrderVariation({this.name, this.values});

  OrderVariation.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    values = json['values'] != null
        ? OrderVariationValue.fromJson(json['values'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    if (values != null) {
      data['values'] = values!.toJson();
    }
    return data;
  }
}

class OrderVariationValue {
  List<String?>? label;

  OrderVariationValue({this.label});

  OrderVariationValue.fromJson(Map<String, dynamic> json) {
    label = json['label'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    return data;
  }
}

class SubscriptionDays {
  String? _day;
  String? _time;

  SubscriptionDays({String? day, String? time}) {
    if (day != null) {
      _day = day;
    }
    if (time != null) {
      _time = time;
    }
  }

  String? get day => _day;
  String? get time => _time;

  SubscriptionDays.fromJson(Map<String, dynamic> json) {
    _day = json['day'];
    _time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['day'] = _day;
    data['time'] = _time;
    return data;
  }
}

class ProductModel {
  int? totalSize;
  String? limit;
  int? offset;
  List<Product>? products;

  ProductModel({this.totalSize, this.limit, this.offset, this.products});

  ProductModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['totalsize'];
    limit = json['limit'].toString();
    offset =
        (json['offset'] != null && json['offset'].toString().trim().isNotEmpty)
            ? int.parse(json['offset'].toString())
            : null;
    if (json['products'] != null) {
      products = [];
      json['products'].forEach((v) {
        if (v['variations'] == null ||
            v['variations'].isEmpty ||
            v['variations'][0]['values'] != null) {
          products!.add(Product.fromJson(v));
        }
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalsize'] = totalSize;
    data['limit'] = limit;
    data['offset'] = offset;
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Product {
  int? id;
  String? name;
  String? description;
  String? image;
  int? categoryId;
  List<CategoryIds>? categoryIds;
  List<Variation>? variations;
  List<AddOns>? addOns;
  List<ChoiceOptions>? choiceOptions;
  double? price;
  double? tax;
  double? discount;
  String? discountType;
  String? availableTimeStarts;
  String? availableTimeEnds;

  int? restaurantId;
  String? restaurantName;
  double? restaurantDiscount;
  int? restaurantStatus;
  int? restaurantActive;
  int? restaurantOpen;
  int? foodOpen;
  bool? scheduleOrder;
  double? avgRating;
  int? ratingCount;
  int? veg;
  int? quantityLimit;
  

  Product({
    this.id,
    this.name,
    this.description,
    this.image,
    this.categoryId,
    this.categoryIds,
    this.variations,
    this.addOns,
    this.choiceOptions,
    this.price,
    this.tax,
    this.discount,
    this.discountType,
    this.availableTimeStarts,
    this.availableTimeEnds,
    this.restaurantId,
    this.restaurantName,
    this.restaurantDiscount,
    this.restaurantStatus,
    this.restaurantActive,
    this.restaurantOpen,
    this.foodOpen,
    this.scheduleOrder,
    this.avgRating,
    this.ratingCount,
    this.veg,
    this.quantityLimit,
  });

  Product.fromJson(Map<String, dynamic> json) {
    id = intConverter(json['id']);
    name = json['name'];
    description = json['description'];
    image = json['image'];
    categoryId = json['category_id'];
    if (json['category_ids'] != null) {
      categoryIds = [];
      json['category_ids'].forEach((v) {
        categoryIds!.add(CategoryIds.fromJson(v));
      });
    }
    if (json['variations'] != null && json['variations'].isNotEmpty) {
      variations = [];
      if (json['variations'][0]['values'] != null) {
        json['variations'].forEach((v) {
          variations!.add(Variation.fromJson(v));
        });
      }
    }
    if (json['add_ons'] != null) {
      addOns = [];
      json['add_ons'].forEach((v) {
        addOns!.add(AddOns.fromJson(v));
      });
    }
    if (json['choice_options'] != null && json['choice_options'] is! String) {
      choiceOptions = [];
      json['choice_options'].forEach((v) {
        choiceOptions!.add(ChoiceOptions.fromJson(v));
      });
    }
    price = doubleConverter(json['price']);
    tax = doubleConverter(json['tax']);
    discount = doubleConverter(json['discount']);
    discountType = json['discount_type'];
    availableTimeStarts = json['available_time_starts'];
    availableTimeEnds = json['available_time_ends'];
    restaurantId = intConverter(json['restaurant_id']);
    restaurantName = json['restaurant_name'];
    restaurantDiscount = json['restaurant_discount'].toDouble();
    restaurantStatus =
        intConverter(json['restaurant_status']); //adminကနေ active on/off
    restaurantActive =
        intConverter(json['restaurant_active']); //ဆိုင်က  temporily on/off
    restaurantOpen = intConverter(json[
        'restaurant_open']); //၁ပတ်လုံးစာ schedules အ‌ပေါ်မူတည်ပြီး ဆိုင်ဖ္ငင့်ချိန် ပိတ်ချိန်
    foodOpen = intConverter(json['food_open']);
    scheduleOrder = json['schedule_order'];
    avgRating = doubleConverter(json['avg_rating']);
    ratingCount = intConverter(json['rating_count']);
    veg = intConverter(json['veg']) != null
        ? int.parse(json['veg'].toString())
        : 0;
    quantityLimit = intConverter(json['maximum_cart_quantity']);
  }
  double doubleConverter(dynamic value) {
    if (value is String) {
      return double.parse(value);
    } else if (value is int) {
      return value.toDouble();
    } else if (value is double) {
      return value;
    } else {
      return 0.0;
    }
  }

  int? intConverter(dynamic value) {
    if (value is String) {
      return int.parse(value);
    } else if (value is int) {
      return value;
    } else if (value is double) {
      return value.toInt();
    } else {
      return 0;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['image'] = image;
    data['category_id'] = categoryId;
    if (categoryIds != null) {
      data['category_ids'] = categoryIds!.map((v) => v.toJson()).toList();
    }
    if (variations != null) {
      data['variations'] = variations!.map((v) => v.toJson()).toList();
    }
    if (addOns != null) {
      data['add_ons'] = addOns!.map((v) => v.toJson()).toList();
    }
    if (choiceOptions != null) {
      data['choice_options'] = choiceOptions!.map((v) => v.toJson()).toList();
    }
    data['price'] = price;
    data['tax'] = tax;
    data['discount'] = discount;
    data['discount_type'] = discountType;
    data['available_time_starts'] = availableTimeStarts;
    data['available_time_ends'] = availableTimeEnds;
    data['restaurant_id'] = restaurantId;
    data['restaurant_name'] = restaurantName;
    data['restaurant_discount'] = restaurantDiscount;
    data['restaurant_active'] = restaurantActive;
    data['restaurant_open'] = restaurantOpen;
    data['food_open'] = foodOpen;
    data['restaurant_status'] = restaurantStatus;
    data['schedule_order'] = scheduleOrder;
    data['avg_rating'] = avgRating;
    data['rating_count'] = ratingCount;
    data['veg'] = veg;
    data['maximum_cart_quantity'] = quantityLimit;
    return data;
  }
}

class CategoryIds {
  String? id;

  CategoryIds({this.id});

  CategoryIds.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    return data;
  }
}

class Variation {
  String? name;
  bool? multiSelect;
  int? min;
  int? max;
  bool? required;
  List<VariationValue>? variationValues;

  Variation(
      {this.name,
      this.multiSelect,
      this.min,
      this.max,
      this.required,
      this.variationValues});

  Variation.fromJson(Map<String, dynamic> json) {
    if (json['max'] != null) {
      name = json['name'];
      multiSelect = json['type'] == 'multi';
      min = multiSelect! ? int.parse(json['min'].toString()) : 0;
      max = multiSelect! ? int.parse(json['max'].toString()) : 0;
      required = json['required'] == 'on';
      if (json['values'] != null) {
        variationValues = [];
        json['values'].forEach((v) {
          variationValues!.add(VariationValue.fromJson(v));
        });
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['type'] = multiSelect;
    data['min'] = min;
    data['max'] = max;
    data['required'] = required;
    if (variationValues != null) {
      data['values'] = variationValues!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VariationValue {
  String? level;
  double? optionPrice;

  VariationValue({this.level, this.optionPrice});

  VariationValue.fromJson(Map<String, dynamic> json) {
    level = json['label'];
    optionPrice = json['optionPrice'] is String
        ? double.tryParse(json['optionPrice'].toString())
        : json['optionPrice'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = level;
    data['optionPrice'] = optionPrice;
    return data;
  }
}

class AddOns {
  int? id;
  String? name;
  double? price;
  String? image;

  AddOns({this.id, this.name, this.price, this.image});

  AddOns.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'].toDouble();
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['price'] = price;
    data['image'] = image;
    return data;
  }
}

class ChoiceOptions {
  String? name;
  String? title;
  List<String>? options;

  ChoiceOptions({this.name, this.title, this.options});

  ChoiceOptions.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    title = json['title'];
    options = json['options'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['title'] = title;
    data['options'] = options;
    return data;
  }
}

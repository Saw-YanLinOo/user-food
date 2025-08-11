import 'package:user/data/model/response/basic_campaign_model.dart';
import 'package:user/data/model/response/product_model.dart';
import 'package:user/data/model/response/restaurant_model.dart';

import 'category_model.dart';

class BannerModel {
  List<BasicCampaignModel>? campaigns;
  List<Banner>? banners;
  String? popupBannerLink;
  String? popupBannerImage;
  String? popupBannerStatus;
  BannerModel({this.campaigns, this.banners});

  BannerModel.fromJson(Map<String, dynamic> json) {
    popupBannerLink = json['popup_banner_link'];
    popupBannerImage = json['popup_banner_image'];
    popupBannerStatus = json['popup_banner_status'];
    if (json['campaigns'] != null) {
      campaigns = [];
      json['campaigns'].forEach((v) {
        campaigns!.add(BasicCampaignModel.fromJson(v));
      });
    }
    if (json['banners'] != null) {
      banners = [];
      json['banners'].forEach((v) {
        banners!.add(Banner.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['popup_banner_link'] = popupBannerLink;
    data['popup_banner_image'] = popupBannerImage;
    data['popup_banner_status'] = popupBannerStatus;
    if (campaigns != null) {
      data['campaigns'] = campaigns!.map((v) => v.toJson()).toList();
    }
    if (banners != null) {
      data['banners'] = banners!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Banner {
  int? id;
  String? title;
  String? type;
  String? image;
  Restaurant? restaurant;
  Product? food;
  CategoryModel? category;

  Banner(
      {this.id,
      this.title,
      this.type,
      this.image,
      this.restaurant,
      this.food,
      this.category});

  Banner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    type = json['type'];
    image = json['image'];
    restaurant = json['restaurant'] != null
        ? Restaurant.fromJson(json['restaurant'])
        : null;
    food = json['food'] != null ? Product.fromJson(json['food']) : null;
    category = json['category'] != null
        ? CategoryModel.fromJson(json['category'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['type'] = type;
    data['image'] = image;
    if (restaurant != null) {
      data['restaurant'] = restaurant!.toJson();
    }
    if (food != null) {
      data['food'] = food!.toJson();
    }
    if (category != null) {
      data['category'] = category!.toJson();
    }
    return data;
  }
}

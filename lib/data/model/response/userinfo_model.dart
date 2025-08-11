import 'package:user/data/model/response/conversation_model.dart';

class UserInfoModel {
  int? id;
  String? fName;
  String? lName;
  String? email;
  String? image;
  String? phone;
  String? password;
  int? orderCount;
  int? memberSinceDays;
  double? walletBalance;
  int? loyaltyPoint;
  String? refCode;
  int? socialId;
  User? userInfo;
  String? createdAt;
  String? additionalNote;
  String? additionalName;

  UserInfoModel({
    this.id,
    this.fName,
    this.lName,
    this.email,
    this.image,
    this.phone,
    this.password,
    this.orderCount,
    this.memberSinceDays,
    this.walletBalance,
    this.loyaltyPoint,
    this.refCode,
    this.socialId,
    this.userInfo,
    this.createdAt,
    this.additionalName,
    this.additionalNote,
  });

  UserInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fName = json['f_name'];
    lName = json['l_name'];
    email = json['email'];
    image = json['image'];
    phone = json['phone'];
    password = json['password'];
    orderCount = json['order_count'];
    memberSinceDays = json['member_since_days'];
    walletBalance = json['wallet_balance'].toDouble();
    loyaltyPoint = json['loyalty_point'];
    refCode = json['ref_code'];
    socialId = json['social_id'];
    userInfo =
        json['userinfo'] != null ? User.fromJson(json['userinfo']) : null;
    createdAt = json['created_at'];
    additionalName = json['additional_name'];
    additionalNote = json['additional_note'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['f_name'] = fName;
    data['l_name'] = lName;
    data['email'] = email;
    data['image'] = image;
    data['phone'] = phone;
    data['password'] = password;
    data['order_count'] = orderCount;
    data['member_since_days'] = memberSinceDays;
    data['wallet_balance'] = walletBalance;
    data['loyalty_point'] = loyaltyPoint;
    data['ref_code'] = refCode;
    if (userInfo != null) {
      data['user`info'] = userInfo!.toJson();
    }
    data['created_at'] = createdAt;
    data['additioanl_note'] = additionalNote;
    data['additional_name'] = additionalName;

    return data;
  }
}

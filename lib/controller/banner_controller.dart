import 'package:user/data/api/api_checker.dart';
import 'package:user/data/model/response/banner_model.dart';
import 'package:user/data/repository/banner_repo.dart';
import 'package:user/helper/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BannerController extends GetxController implements GetxService {
  final BannerRepo bannerRepo;
  BannerController({required this.bannerRepo});
  final List<VoidCallback> _listeners = [];
  List<String?>? _bannerImageList;
  List<dynamic>? _bannerDataList;
  String? _popupBannerImage;
  String? _popupBannerLink;
  String? _popupBannerStatus;

  int _currentIndex = 0;

  List<String?>? get bannerImageList => _bannerImageList;
  String? get popupBannerImage => _popupBannerImage;
  String? get popupBannerLink => _popupBannerLink;
  String? get popupBannerStatus => _popupBannerStatus;
  List<dynamic>? get bannerDataList => _bannerDataList;
  int get currentIndex => _currentIndex;
  void notifyListeners() {
    for (var listener in _listeners) {
      listener();
    }
  }

  Future<void> getBannerList(bool reload) async {
    if (_bannerImageList == null || reload) {
      Response response = await bannerRepo.getBannerList();
      if (response.statusCode == 200) {
        _bannerImageList = [];
        _bannerDataList = [];
        BannerModel bannerModel = BannerModel.fromJson(response.body);
        for (var campaign in bannerModel.campaigns!) {
          _bannerImageList!.add(campaign.image);
          _bannerDataList!.add(campaign);
        }
        for (var banner in bannerModel.banners!) {
          _bannerImageList!.add(banner.image);
          if (banner.food != null) {
            _bannerDataList!.add(banner.food);
          } else if (banner.category != null) {
            _bannerDataList!.add(banner.category);
          } else if (banner.restaurant != null) {
            _bannerDataList!.add(banner.restaurant);
          }
        }
       
        if (ResponsiveHelper.isDesktop(Get.context) &&
            _bannerImageList!.length % 2 != 0) {
          _bannerImageList!.add(_bannerImageList![0]);
          _bannerDataList!.add(_bannerDataList![0]);
        }
      } else {
        ApiChecker.checkApi(response);
      }
      update();
    }
  }

  Future<void> getPopUpBannerList(bool reload, context) async {
    if (_popupBannerImage == null || reload) {
      Response response = await bannerRepo.getPopUpBannerList();

      if (response.statusCode == 200) {
        BannerModel bannerModel = BannerModel.fromJson(response.body);
        _popupBannerImage = bannerModel.popupBannerImage!;
        _popupBannerLink = bannerModel.popupBannerLink!;
        _popupBannerStatus=bannerModel.popupBannerStatus!;

      
      } else {
        ApiChecker.checkApi(response);
      }
      notifyListeners();
    }
  }

  void setCurrentIndex(int index, bool notify) {
    _currentIndex = index;
    if (notify) {
      update();
    }
  }
}

import 'package:user/data/api/api_client.dart';
import 'package:user/util/app_constants.dart';
import 'package:get/get_connect/http/src/response/response.dart';
class BannerRepo {
  final ApiClient apiClient;
  BannerRepo({required this.apiClient});

  Future<Response> getBannerList() async {
    return await apiClient.getData(AppConstants.bannerUri);
  }
  Future<Response> getPopUpBannerList() async {
    return await apiClient.getData(AppConstants.popUpBannerUri);
  }
}
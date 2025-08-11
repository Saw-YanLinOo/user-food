import 'package:user/data/api/api_client.dart';
import 'package:user/util/app_constants.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class WishListRepo {
  final ApiClient apiClient;
  WishListRepo({required this.apiClient});

  Future<Response> getWishList() async {
    return await apiClient.getData(AppConstants.wishListGetUri);
  }

  Future<Response> addWishList(int? id, bool isRestaurant) async {
    return await apiClient.postData('${AppConstants.addWishListUri}${isRestaurant ? 'restaurant_id=' : 'food_id='}$id', null);
  }

  Future<Response> removeWishList(int? id, bool isRestaurant) async {
    return await apiClient.deleteData('${AppConstants.removeWishListUri}${isRestaurant ? 'restaurant_id=' : 'food_id='}$id');
  }
}

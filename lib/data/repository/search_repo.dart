import 'package:user/data/api/api_client.dart';
import 'package:user/util/app_constants.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  SearchRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> getSearchData(String query, bool isRestaurant) async {
    return await apiClient.getData('${AppConstants.searchUri}${isRestaurant ? 'restaurants' : 'products'}/search?name=$query&offset=1&limit=50');
  }

  Future<Response> getSuggestedFoods() async {
    return await apiClient.getData(AppConstants.suggestedFoodUri);
  }

  Future<bool> saveSearchHistory(List<String> searchHistories) async {
    return await sharedPreferences.setStringList(AppConstants.searchHistory, searchHistories);
  }

  List<String> getSearchAddress() {
    return sharedPreferences.getStringList(AppConstants.searchHistory) ?? [];
  }

  Future<bool> clearSearchHistory() async {
    return sharedPreferences.setStringList(AppConstants.searchHistory, []);
  }
}

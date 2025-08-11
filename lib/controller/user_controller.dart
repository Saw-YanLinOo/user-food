import 'package:user/controller/auth_controller.dart';
import 'package:user/controller/cart_controller.dart';
import 'package:user/controller/wishlist_controller.dart';
import 'package:user/data/api/api_checker.dart';
import 'package:user/data/model/response/conversation_model.dart';
import 'package:user/data/model/response/response_model.dart';
import 'package:user/data/repository/user_repo.dart';
import 'package:user/data/model/response/userinfo_model.dart';
import 'package:user/helper/route_helper.dart';
import 'package:user/view/base/custom_snackbar.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class UserController extends GetxController implements GetxService {
  final UserRepo userRepo;
  UserController({required this.userRepo});

  UserInfoModel? _userInfoModel;
  XFile? _pickedFile;
  XFile? _pickedIDFrontFile;
  XFile? _pickedIDBackFile;
  bool _isLoading = false;

  // Date of Birth fields for UI
  final RxString dobDay = ''.obs;
  final RxString dobMonth = ''.obs;
  final TextEditingController dobYearController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final RxInt dobAge = 0.obs;
  RxBool isMale=true.obs;
  RxBool isFemale=false.obs;
  RxString imageFrontPath ="".obs;
  RxString imageBackPath ="".obs;

  UserInfoModel? get userInfoModel => _userInfoModel;
  XFile? get pickedFile => _pickedFile;
  XFile? get pickedIDFrontFile => _pickedIDFrontFile;
  XFile? get pickedIDBackFile => _pickedIDBackFile;
  bool get isLoading => _isLoading;

  Future<ResponseModel> getUserInfo() async {
    _pickedFile = null;
    ResponseModel responseModel;
    Response response = await userRepo.getUserInfo();
    if (response.statusCode == 200) {
      _userInfoModel = UserInfoModel.fromJson(response.body);

      responseModel = ResponseModel(true, 'successful');

    } else {
      responseModel = ResponseModel(false, response.statusText);
      ApiChecker.checkApi(response);
    }
    update();
    return responseModel;
  }

  /*Future<ResponseModel> updateUserInfo(UserInfoModel updateUserModel, String password) async {
    _isLoading = true;
    update();
    ResponseModel _responseModel;
    Response response = await userRepo.updateProfile(updateUserModel, password, _pickedFile);
    _isLoading = false;
    if (response.statusCode == 200) {
      Map map = jsonDecode(await response.body);
      String message = map["message"];
      _userInfoModel = updateUserModel;
      _responseModel = ResponseModel(true, message);
    } else {
      _responseModel = ResponseModel(false, response.statusText);
      print('${response.statusCode} ${response.statusText}');
    }
    update();
    return _responseModel;
  }*/
  void setForceFullyUserEmpty() {
    _userInfoModel = null;
    update();
  }

  Future<ResponseModel> updateUserInfo(
      UserInfoModel updateUserModel, String token) async {
    _isLoading = true;
    update();
    ResponseModel responseModel;
    Response response =
        await userRepo.updateProfile(updateUserModel, _pickedFile, token);
    _isLoading = false;
    if (response.statusCode == 200) {
      _userInfoModel = updateUserModel;
      responseModel = ResponseModel(true, response.bodyString);
      _pickedFile = null;
      getUserInfo();
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    update();
    return responseModel;
  }

  void updateUserWithNewData(User? user) {
    _userInfoModel!.userInfo = user;
  }

  Future<ResponseModel> changePassword(UserInfoModel updatedUserModel) async {
    _isLoading = true;
    update();
    ResponseModel responseModel;
    Response response = await userRepo.changePassword(updatedUserModel);
    _isLoading = false;
    if (response.statusCode == 200) {
      String? message = response.body["message"];
      responseModel = ResponseModel(true, message);
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    update();
    return responseModel;
  }

  void pickImage() async {
    _pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    update();
  }

  void pickImageFrontID() async {
    _pickedIDFrontFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    imageFrontPath.value = _pickedIDFrontFile!.path;
    update();
  }
  void pickImageBackID() async {
    _pickedIDBackFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    imageBackPath.value = _pickedIDBackFile!.path;
    update();
  }

  void initData() {
    _pickedFile = null;
    _pickedIDFrontFile =null;
    _pickedIDBackFile =null;
  }

  void setDobDay(String day) {
    print('setDobDay called with $day');
    dobDay.value = day;
    _updateDobAge();
  }

  void setDobMonth(String month) {
    print('setDobMonth called with $month');
    dobMonth.value = month;
    _updateDobAge();
  }

  void setDobYear(String year) {
    dobYearController.text = year;
    _updateDobAge();
  }

  void _updateDobAge() {
    final day = int.tryParse(dobDay.value);
    final month = int.tryParse(dobMonth.value);
    final year = int.tryParse(dobYearController.text);
    print('DEBUG: dobDay=${dobDay.value}, dobMonth=${dobMonth.value}, dobYear=${dobYearController.text}');
    if (day != null && month != null && year != null) {
      try {
        final dob = DateTime(year, month, day);
        if (dob.year == year && dob.month == month && dob.day == day) {
          final now = DateTime.now();
          int age = now.year - dob.year;
          if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
            age--;
          }
          print('DEBUG: Calculated age=$age');
          dobAge.value = age;
        } else {
          print('DEBUG: Invalid date selected');
          dobAge.value = 0;
        }
      } catch (e) {
        print('DEBUG: Exception in date calculation: $e');
        dobAge.value = 0;
      }
    } else {
      print('DEBUG: One or more fields are null, age not calculated');
      dobAge.value = 0;
    }
  }

  @override
  void onClose() {
    dobYearController.dispose();
    super.onClose();
  }

  Future removeUser() async {
    _isLoading = true;
    update();
    Response response = await userRepo.deleteUser();
    _isLoading = false;
    if (response.statusCode == 200) {
      showCustomSnackBar('your_account_remove_successfully'.tr);
      Get.find<AuthController>().clearSharedData();
      Get.find<CartController>().clearCartList();
      Get.find<WishListController>().removeWishes();
      Get.offAllNamed(RouteHelper.getSignInRoute(RouteHelper.splash));
    } else {
      Get.back();
      ApiChecker.checkApi(response);
    }
  }
}

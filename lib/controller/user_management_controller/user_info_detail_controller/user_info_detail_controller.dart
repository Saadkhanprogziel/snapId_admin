import 'package:admin/models/users/users_moderation_history.dart';
import 'package:admin/models/users/users_order_data.dart';
import 'package:admin/models/users/users_model.dart';
import 'package:admin/repositories/users_repository/users_info_repository.dart';
import 'package:admin/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserInfoDetailController extends GetxController {
  final UsersInfoRepository usersInfoRepository = UsersInfoRepository();

  var currentPage = 0.obs;
  var is_loading = true.obs;

  UsersModel? userModel;

  var orderList = <UsersOrderData>[].obs;
  var moderationList = <UsersModerationHistory>[].obs;

  UserInfoDetailController({this.userModel});

  @override
  void onInit() {
    super.onInit();
    if (userModel?.id != null) {
      fetchUsersOrderData();
      fetchUsersModerationData();
    }
  }

  void setUserModel(UsersModel? user) {
    userModel = user;
    if (userModel?.id != null) {
      fetchUsersOrderData();
      fetchUsersModerationData();
    }
  }

  void fetchUsersOrderData() {
    if (userModel?.id == null) return;

    is_loading.value = true;
    usersInfoRepository.getUsersOrderData(userModel!.id!).then((response) {
      response.fold((error) {
        is_loading.value = false;
      }, (success) {
        orderList.value = success;
        is_loading.value = false;
      });
    });
  }

  void blockUser(BuildContext context) {
    if (userModel?.id == null) return;

    is_loading.value = true;
    usersInfoRepository.blockUser(userModel!.id!).then((response) {
      response.fold((error) {
        is_loading.value = false;
        showCustomSnackbar(
            context: context, message: error, type: SnackbarType.error);
      }, (success) {
        is_loading.value = false;
      });
    });
  }

  void unblockUser(BuildContext context) {
    if (userModel?.id == null) return;

    is_loading.value = true;
    usersInfoRepository.unblockUser(userModel!.id!).then((response) {
      response.fold((error) {
        is_loading.value = false;
        showCustomSnackbar(
            context: context, message: error, type: SnackbarType.error);
      }, (success) {
        is_loading.value = false;
      });
    });
  }

  void fetchUsersModerationData() {
    if (userModel?.id == null) return;

    is_loading.value = true;
    usersInfoRepository.getUsersModerationData(userModel!.id!).then((response) {
      response.fold((error) {
        is_loading.value = false;
      }, (success) {
        moderationList.value = success;
        is_loading.value = false;
      });
    });
  }

  var selectedScreen = 'Basic Info'.obs;
  void changeScreen(String screen) => selectedScreen.value = screen;
}

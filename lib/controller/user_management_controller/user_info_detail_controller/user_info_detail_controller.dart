import 'package:admin/controller/user_management_controller/user_management_controller.dart';
import 'package:admin/models/users/users_moderation_history.dart';
import 'package:admin/models/users/users_order_data.dart';
import 'package:admin/models/users/users_model.dart';
import 'package:admin/repositories/users_repository/users_info_repository.dart';
import 'package:admin/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserInfoDetailController extends GetxController {
  final UsersInfoRepository usersInfoRepository = UsersInfoRepository();
  final UserManagementController userManagementController =
      Get.find<UserManagementController>();

  TextEditingController reasonBlocking = TextEditingController();
  var currentPage = 0.obs;
  var moderationCurrentPage = 0.obs;
  var is_loading = true.obs;

  var userModel = Rxn<UsersModel>();
  var orderList = <UsersOrderData>[].obs;
  var moderationList = <UsersModerationHistory>[].obs;

  bool _isDisposed = false;

  @override
  void onInit() {
    super.onInit();
    if (userModel.value?.id != null) {
      fetchUsersOrderData();
      fetchUsersModerationData();
    }
  }

  @override
  void onClose() {
    _isDisposed = true;
    reasonBlocking.dispose();
    super.onClose();
  }

  void setUserModel(UsersModel? user) {
    userModel.value = user;
    if (userModel.value?.id != null) {
      fetchUsersOrderData();
      fetchUsersModerationData();
    }
    update();
  }

  void fetchUsersOrderData() {
    if (userModel.value?.id == null || _isDisposed) return;

    is_loading.value = true;
    usersInfoRepository.getUsersOrderData(userModel.value?.id).then((response) {
      if (_isDisposed) return;

      response.fold((error) {
        is_loading.value = false;
      }, (success) {
        orderList.value = success;
        is_loading.value = false;
      });
    });
  }

  void blockUser(BuildContext context) {
    if (userModel.value?.id == null || _isDisposed) return;

    is_loading.value = true;
    usersInfoRepository
        .blockUser(userModel.value?.id, reasonBlocking.text)
        .then((response) {
      if (_isDisposed) return;

      response.fold((error) {
        is_loading.value = false;

        if (context.mounted) {
          showCustomSnackbar(
              context: context, message: error, type: SnackbarType.error);
        }
      }, (success) {
        int index = userManagementController.usersData
            .indexWhere((u) => u.id == userModel.value?.id);

        if (userModel.value != null) {
          userModel.value = userModel.value!.copyWith(isActive: "BLOCKED");
        }

        if (index != -1) {
          userManagementController.usersData[index] = userModel.value!;
          update();
        }
        userManagementController.checkMethod(index, userModel.value!);

        if (context.mounted) {
          showCustomSnackbar(
              context: context,
              message: "User Blocked",
              type: SnackbarType.success);
        }
        is_loading.value = false;
        update();
      });
    });
  }

  void unblockUser(BuildContext context) {
    if (userModel.value?.id == null || _isDisposed) return;

    is_loading.value = true;
    usersInfoRepository.unblockUser(userModel.value?.id).then((response) {
      if (_isDisposed) return;

      response.fold((error) {
        is_loading.value = false;

        if (context.mounted) {
          showCustomSnackbar(
              context: context, message: error, type: SnackbarType.error);
        }
      }, (success) {
        if (userModel.value != null) {
          userModel.value = userModel.value!.copyWith(isActive: "ACTIVE");
        }

        int index = userManagementController.usersData
            .indexWhere((u) => u.id == userModel.value?.id);
        if (index != -1) {
          userManagementController.usersData[index] = userModel.value!;
        }
        userManagementController.checkMethod(index, userModel.value!);

        if (context.mounted) {
          showCustomSnackbar(
              context: context,
              message: "User Unblocked",
              type: SnackbarType.success);
        }
        is_loading.value = false;
        update();
      });
    });
  }

  void fetchUsersModerationData() {
    if (userModel.value?.id == null || _isDisposed) return;

    is_loading.value = true;
    usersInfoRepository
        .getUsersModerationData(userModel.value?.id)
        .then((response) {
      if (_isDisposed) return;

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

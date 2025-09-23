import 'dart:io';

import 'package:admin/controller/auth_controller/auth_controller.dart';
import 'package:admin/main.dart';
import 'package:admin/repositories/auth_repository/auth_repository.dart';
import 'package:admin/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'dart:typed_data';
import 'package:admin/models/admin_model/admin_model.dart';
import 'package:image_picker/image_picker.dart';

class SettingsController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  // -------------------- Dependencies --------------------
  final AuthRepository _authRepository = AuthRepository();

  // -------------------- Reactive States --------------------
  final selectedScreen = 'Profile Info'.obs;
  final profileImageName = ''.obs;
  final isLoading = false.obs;
  final isUpdatingProfile = false.obs;
  final isChangingPassword = false.obs;

  // Notification settings
  final ticketNotifications = true.obs;
  final newOrderNotifications = false.obs;
  final isLightTheme = true.obs;

  // Current user data
  final currentUser = Rxn<AdminUserModel>();

  final Map<String, RxBool> obscureMap = {};

  // -------------------- Text Controllers --------------------
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final phoneController = TextEditingController();

  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final selectedPhoto = Rxn<ImageProvider>();
  final capturedPhoto = Rxn<XFile>();
  final ImagePicker _picker = ImagePicker();
  final isCapturingPhotos = false.obs;

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      capturedPhoto.value = pickedFile;
      if (kIsWeb) {
        Uint8List bytes = await pickedFile.readAsBytes();
        selectedPhoto.value = MemoryImage(bytes);
      } else {
        selectedPhoto.value = Image.file(
          File(pickedFile.path),
        ).image;
      }
    }
  }

  Future<void> fetchUserProfile() async {
    try {
      isLoading.value = true;
      final result = await _authRepository.getProfile();
      result.fold(
        (error) {
          Get.snackbar(
            'Error',
            'Failed to fetch profile: $error',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        },
        (user) {
          print("yesss ${localStorage.getString("user")}");
          currentUser.value = user;
          firstName.text = user.firstName;
          lastName.text = user.lastName;
          phoneController.text = user.phoneNo;
        },
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile() async {
    try {
      isUpdatingProfile.value = true;

      Uint8List? imageBytes;
      String? imageName;
      if (capturedPhoto.value != null) {
        imageBytes = await capturedPhoto.value!.readAsBytes();
        imageName = capturedPhoto.value!.name;
      }

      final result = await _authRepository.updateProfile(
        firstName: firstName.text.trim(),
        lastName: lastName.text.trim(),
        phoneNumber: phoneController.text.trim(),
        profileImageBytes: imageBytes,
        profileImageName: imageName,
      );

      result.fold(
        (error) {
          Get.snackbar(
            'Error',
            error,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        },
        (updatedUser) {
          AuthController authController = Get.find<AuthController>();
          currentUser.value = updatedUser;
          fetchUserProfile();
                   authController.fetchUserProfile();

          Get.snackbar(
            'Success',
            'Profile updated successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        },
      );
    } finally {
      isUpdatingProfile.value = false;
    }
  }

  // -------------------- Password Management --------------------
  Future<void> savePasswordChanges(BuildContext context) async {
    if (isChangingPassword.value) return;

    // Validation
    if (currentPasswordController.text.isEmpty) {
      showCustomSnackbar(
        context: context,
        message: 'Please enter your current password',
        type: SnackbarType.error,
      );
      return;
    }

    if (newPasswordController.text.isEmpty) {
      showCustomSnackbar(
        context: context,
        message: 'Please enter a new password',
        type: SnackbarType.error,
      );
      return;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      showCustomSnackbar(
        context: context,
        message: 'Password does not match',
        type: SnackbarType.error,
      );
      return;
    }

    if (confirmPasswordController.text.length < 6) {
      showCustomSnackbar(
          context: context,
          message: 'Password must be at least 6 characters long',
          type: SnackbarType.success);
      return;
    }

    try {
      isChangingPassword.value = true;

      final result = await _authRepository.changePassword(
        currentPassword: currentPasswordController.text,
        newPassword: newPasswordController.text,
        confirmNewPassword: confirmPasswordController.text,
      );

      result.fold(
        (error) {
          Get.snackbar(
            'Error',
            error,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          showCustomSnackbar(
              context: context, message: error, type: SnackbarType.success);
        },
        (success) {
          clearPasswordFields();
          showCustomSnackbar(
              context: context,
              message: " Successfully changed password.",
              type: SnackbarType.success);
        },
      );
    } finally {
      isChangingPassword.value = false;
    }
  }

  void clearPasswordFields() {
    currentPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
  }

  void cancelPasswordChanges() {
    clearPasswordFields();
    Get.snackbar(
      'Cancelled',
      'Password changes cancelled',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // -------------------- Obscure Text Handlers --------------------
  void initObscure(String key) {
    if (!obscureMap.containsKey(key)) {
      obscureMap[key] = true.obs;
    }
  }

  void toggleObscure(String key) {
    if (obscureMap.containsKey(key)) {
      obscureMap[key]!.value = !obscureMap[key]!.value;
    }
  }

  // -------------------- Navigation --------------------
  void changeScreen(String screen) => selectedScreen.value = screen;

  // -------------------- Notification Toggles --------------------
  void toggleTicketNotifications(bool value) =>
      ticketNotifications.value = value;

  void toggleNewOrderNotifications(bool value) =>
      newOrderNotifications.value = value;

  void toggleTheme(bool value) => isLightTheme.value = value;

  // -------------------- Reset Functions --------------------
  void cancelChanges() {}

  // -------------------- Lifecycle --------------------
  @override
  void onClose() {
    firstName.dispose();
    lastName.dispose();
    phoneController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}

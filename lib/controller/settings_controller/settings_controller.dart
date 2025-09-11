import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // Added for kIsWeb
import 'package:get/get.dart';
import 'dart:typed_data'; // Added for Uint8List

class SettingsController extends GetxController {
  // -------------------- Reactive States --------------------
  final selectedScreen = 'Profile Info'.obs;
  final profileImagePath = ''.obs;
  final profileImageBytes = Uint8List(0).obs; // Added for web support

  final ticketNotifications = true.obs;
  final newOrderNotifications = false.obs;
  final isLightTheme = true.obs;

  final Map<String, RxBool> obscureMap = {};

  // -------------------- Text Controllers --------------------
  final nameController = TextEditingController(text: 'Marco Kasper');
  final emailController = TextEditingController(text: 'admin@SnapID.app');
  final phoneController = TextEditingController(text: '+1 789 937 5988');

  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

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

  // -------------------- Profile Image --------------------
  void setProfileImage(String imagePath) {
    profileImagePath.value = imagePath;
    // Clear bytes when using file path
    profileImageBytes.value = Uint8List(0);
    Get.snackbar(
      'Success',
      'Profile picture updated successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  // Added for web support
  void setProfileImageBytes(Uint8List imageBytes) {
    profileImageBytes.value = imageBytes;

    print("manzarrrrr $imageBytes");
    // Clear file path when using bytes
    profileImagePath.value = '';
    Get.snackbar(
      'Success',
      'Profile picture updated successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void removeProfileImage() {
    profileImagePath.value = '';
    profileImageBytes.value = Uint8List(0); // Clear bytes as well
    Get.snackbar(
      'Success',
      'Profile picture removed successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // Helper method to check if profile image exists
  bool get hasProfileImage {
    if (kIsWeb) {
      return profileImageBytes.value.isNotEmpty;
    } else {
      return profileImagePath.value.isNotEmpty;
    }
  }

  // -------------------- Password --------------------
  void savePasswordChanges() {
    if (newPasswordController.text != confirmPasswordController.text) {
      Get.snackbar('Error', 'Passwords do not match');
      return;
    }

    Get.snackbar('Success', 'Password updated successfully');
  }

  void cancelPasswordChanges() {
    currentPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
  }

  // -------------------- General Settings --------------------
  void saveSettings() {
    Get.snackbar(
      'Success',
      'Settings saved successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void cancelChanges() {
    nameController.text = 'Marco Kasper';
    emailController.text = 'admin@SnapID.app';
    phoneController.text = '+1 789 937 5988';
    ticketNotifications.value = true;
    newOrderNotifications.value = false;
    profileImagePath.value = '';
    profileImageBytes.value = Uint8List(0); // Clear bytes as well

    Get.snackbar(
      'Cancelled',
      'Changes discarded',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // -------------------- Lifecycle --------------------
  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
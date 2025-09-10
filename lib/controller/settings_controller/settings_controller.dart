import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  var selectedScreen = 'Profile Info'.obs;
  var profileImagePath = ''.obs;

  final nameController = TextEditingController(text: 'Marco Kasper');
  final emailController = TextEditingController(text: 'admin@SnapID.app');
  final phoneController = TextEditingController(text: '+1 789 937 5988');

  var ticketNotifications = true.obs;
  var newOrderNotifications = false.obs;
  var isLightTheme = true.obs;

  void changeScreen(String screen) => selectedScreen.value = screen;

  void toggleTicketNotifications(bool value) =>
      ticketNotifications.value = value;

  void toggleNewOrderNotifications(bool value) =>
      newOrderNotifications.value = value;

  void toggleTheme(bool value) => isLightTheme.value = value;

  void setProfileImage(String imagePath) {
    profileImagePath.value = imagePath;
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
    Get.snackbar(
      'Success',
      'Profile picture removed successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void saveSettings() {
    Get.snackbar('Success', 'Settings saved successfully',
        snackPosition: SnackPosition.BOTTOM);
  }

  void cancelChanges() {
    nameController.text = 'Marco Kasper';
    emailController.text = 'admin@SnapID.app';
    phoneController.text = '+1 789 937 5988';
    ticketNotifications.value = true;
    newOrderNotifications.value = false;
    profileImagePath.value = '';
    Get.snackbar('Cancelled', 'Changes discarded',
        snackPosition: SnackPosition.BOTTOM);
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}

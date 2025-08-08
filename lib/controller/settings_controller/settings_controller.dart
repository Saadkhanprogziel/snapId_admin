import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:admin/theme/text_theme.dart'; // Assuming this is your custom text theme

// SettingsController (unchanged from your code)
class SettingsController extends GetxController {
  var selectedScreen = 'Profile Info'.obs;

  final nameController = TextEditingController(text: 'Marco Kasper');
  final emailController = TextEditingController(text: 'admin@SnapID.app');
  final phoneController = TextEditingController(text: '+1 789 937 5988');

  var ticketNotifications = true.obs;
  var newOrderNotifications = false.obs;
  var isLightTheme = true.obs;

  void changeScreen(String screen) => selectedScreen.value = screen;

  void toggleTicketNotifications(bool value) => ticketNotifications.value = value;

  void toggleNewOrderNotifications(bool value) =>
      newOrderNotifications.value = value;

  void toggleTheme(bool value) => isLightTheme.value = value;

  void saveSettings() {
    // Implement save logic (e.g., API call, local storage)
    Get.snackbar('Success', 'Settings saved successfully',
        snackPosition: SnackPosition.BOTTOM);
  }

  void cancelChanges() {
    // Reset to initial values or navigate back
    nameController.text = 'Marco Kasper';
    emailController.text = 'admin@SnapID.app';
    phoneController.text = '+1 789 937 5988';
    ticketNotifications.value = true;
    newOrderNotifications.value = false;
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

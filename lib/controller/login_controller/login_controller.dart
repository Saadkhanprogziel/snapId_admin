import 'package:admin/repositories/auth_repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  AuthRepository authRepository = AuthRepository();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  bool isPasswordVisible = false;
  bool rememberMe = false;

  @override
  void onInit() {
    super.onInit();
    // Initialize any necessary data or state here
  }

  void login() {
    isLoading = true;
    update();
    try {
      authRepository
          .login(email: emailController.text, password: passwordController.text)
          .then((response) => response.fold(
                (error) {
                  isLoading = false;
                  update();
                  Get.snackbar("Error", "$error",
                      backgroundColor: Colors.red, colorText: Colors.white);
                },
                (success) {
                  isLoading = false;
                  update();
                  print("you are logged");
                },
              ));
    } on Exception catch (e) {
      isLoading = false;
      Get.snackbar("Error", "Biometric login failed: ${e.toString()}",
          backgroundColor: Colors.red, colorText: Colors.white);
      update();
    }
  }
}

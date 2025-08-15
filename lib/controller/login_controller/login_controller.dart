import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isPasswordVisible = false;
  bool rememberMe = false;

  @override
  void onInit() {
    super.onInit();
    // Initialize any necessary data or state here
  }

  void login() {
    // Implement login logic here
    String email = emailController.text;
    String password = passwordController.text;

    if (email.isNotEmpty && password.isNotEmpty) {
      // Perform login operation
      print("Logging in with Email: $email and Password: $password");
    } else {
      print("Email and Password cannot be empty");
    }
  }

  
}
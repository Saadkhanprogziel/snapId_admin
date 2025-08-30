import 'package:admin/constants/app_routes.dart';
import 'package:admin/repositories/auth_repository/auth_repository.dart';
import 'package:admin/utils/utils.dart';
import 'package:admin/views/navigations/app_navigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
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

  void login(BuildContext context) {
    isLoading = true;
    update();
    try {
      authRepository
          .login(email: emailController.text, password: passwordController.text)
          .then((response) => response.fold(
                (error) {
                  isLoading = false;
                  update();

                  showCustomSnackbar(
                      context: context,
                      message: error,
                      type: SnackbarType.error);
                },
                (success) {
                  isLoading = false;
                  update();
                  print("ye to latest news hai");

                  AppNavigation.pushReplacementNamed("dashboard");
                },
              ));
    } on Exception catch (e) {
      isLoading = false;
      showCustomSnackbar(
          context: context, message: e.toString(), type: SnackbarType.error);
    }
    update();
  }

  void logout(BuildContext context) {
    authRepository.logout().then((response) {
      response.fold(
        (error) {
          showCustomSnackbar(
              context: context, message: error, type: SnackbarType.error);
        },
        (success) {
          AppNavigation.pushReplacementNamed("login");

          showCustomSnackbar(
              context: context,
              message: "You are Logged Out",
              type: SnackbarType.success);
        },
      );
    });
  }
}

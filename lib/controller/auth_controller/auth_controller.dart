import 'package:admin/models/admin_model/admin_model.dart';
import 'package:admin/repositories/auth_repository/auth_repository.dart';
import 'package:admin/utils/utils.dart';
import 'package:admin/views/navigations/app_navigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  AuthRepository authRepository = AuthRepository();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  var isLoading = false.obs;
  var adminUser = Rxn<AdminUserModel>();
  var isPasswordVisible = false.obs;
  var rememberMe = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Check if user is already logged in and fetch profile
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    // Check if user is already authenticated (has token)
    // and fetch profile if authenticated
    await fetchUserProfile();
  }

  void login(BuildContext context) {
    isLoading.value = true;
    
    try {
      authRepository
          .login(email: emailController.text, password: passwordController.text)
          .then((response) => response.fold(
                (error) {
                  showCustomSnackbar(
                      context: context,
                      message: error,
                      type: SnackbarType.error);
                },
                (success) async {
                  // Fetch user profile after successful login
                  await fetchUserProfile();
                  AppNavigation.pushReplacementNamed("dashboard");
                },
              ));
    } on Exception catch (e) {
      showCustomSnackbar(
          context: context, message: e.toString(), type: SnackbarType.error);
    }
    finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchUserProfile() async {
    try {
      final result = await authRepository.getProfile();
      result.fold(
        (error) {
          print('Error fetching profile: $error');
          Get.snackbar(
            'Error',
            'Failed to fetch profile: $error',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        },
        (user) {
          adminUser.value = user;
          print('Profile loaded: ${user.firstName}'); // Debug print
        }
      );
    } catch (e) {
      print('Exception in fetchUserProfile: $e');
    }
  }

  void logout(BuildContext context) {
    authRepository.logout().then((response) {
      response.fold(
        (error) {
          showCustomSnackbar(
              context: context, message: error, type: SnackbarType.error);
        },
        (success) {
          // Clear user data on logout
          adminUser.value = null;
          AppNavigation.pushReplacementNamed("login");
          showCustomSnackbar(
              context: context,
              message: "You are Logged Out",
              type: SnackbarType.success);
        },
      );
    });
  }

  // Method to refresh profile data
  Future<void> refreshProfile() async {
    await fetchUserProfile();
  }
}
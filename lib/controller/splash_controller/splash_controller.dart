import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

class SplashController extends GetxController {
  


  navigateToLogin(BuildContext context) async {
    // Wait for 3 seconds (adjust as needed)
    await Future.delayed(Duration(seconds: 3));
    
    print("Navigating to login screen context is $context"); 
    if (context.mounted) {
      context.go('/login');
    }
  }
}
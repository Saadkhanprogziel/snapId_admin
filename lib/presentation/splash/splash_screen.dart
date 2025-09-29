import 'package:admin/controller/splash_controller/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GetBuilder<SplashController>(
      init: SplashController(),
      initState: (state) {
        // Call startSplash with context when the widget is initialized
        WidgetsBinding.instance.addPostFrameCallback((_) {
          state.controller?.navigateToLogin(context);
        });
      },
      builder: (controller) {
        return Scaffold(
          backgroundColor: isDark ? const Color(0xFF181A20) : Colors.white,
          body: Center(
            child: Image.asset(
              'assets/images/splash_animation.gif',
              width: 500.w, // Adjust size as needed
              height: 500.h, // Adjust size as needed
              fit: BoxFit.contain,
            ),
          ),
        );
      }
    );
  }
}
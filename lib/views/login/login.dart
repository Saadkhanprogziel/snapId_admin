import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../controller/login_controller/login_controller.dart';

class SnapIdLoginScreen extends StatelessWidget {
  const SnapIdLoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/shade.png', // Update path as needed
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 580),
                  child: GetBuilder<LoginController>(
                    init: LoginController(),
                    builder: (controller) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Logo Section
                          Container(
                            margin: const EdgeInsets.only(bottom: 60),
                            child: Column(
                              children: [
                                const SizedBox(height: 20),
                                // Logo Image
                                Container(
                                  width: 160, // increased from 200
                                  height: 175, // increased from 200
                                  child: Image.asset(
                                    'assets/images/logo.png',
                                    fit: BoxFit
                                        .contain, // ensures the image scales nicely
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Login Form Card with border
                          Container(
                            padding: const EdgeInsets.all(50),
                            decoration: BoxDecoration(
                              // color: Colors.white.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(40),
                              border: Border.all(
                                color: const Color.fromARGB(149, 117, 99, 210),
                                width: 0.5,
                              ),
                              // boxShadow: [
                              //   BoxShadow(
                              //     color: Colors.black.withOpacity(0.05),
                              //     blurRadius: 15,
                              //     offset: const Offset(0, 5),
                              //   ),
                              // ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  'Sign In',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1F2937),
                                  ),
                                ),
                                const SizedBox(height: 40),
                                // Email Field
                                Container(
                                  height: 68,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF9FAFB),
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: const Color(0xFFE5E7EB),
                                      width: 1,
                                    ),
                                  ),
                                  child: Center(
                                    child: TextFormField(
                                      controller: controller.emailController,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Color(0xFF374151),
                                      ),
                                      decoration: InputDecoration(
                                        hintText: 'Enter Your Email',
                                        hintStyle: const TextStyle(
                                          color: Color(0xFF9CA3AF),
                                          fontSize: 15,
                                        ),
                                        prefixIcon: const Icon(
                                          Icons.email_outlined,
                                          color: Color(0xFF9CA3AF),
                                          size: 20,
                                        ),
                                        border: InputBorder.none,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 0,
                                        ),
                                        isDense: true,
                                      ),
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                // Password Field
                                Container(
                                  height: 68,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF9FAFB),
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: const Color(0xFFE5E7EB),
                                      width: 1,
                                    ),
                                  ),
                                  child: Center(
                                    child: TextFormField(
                                      controller: controller.passwordController,
                                      obscureText:
                                          !controller.isPasswordVisible,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Color(0xFF374151),
                                      ),
                                      decoration: InputDecoration(
                                        hintText: 'Your Password',
                                        hintStyle: const TextStyle(
                                          color: Color(0xFF9CA3AF),
                                          fontSize: 15,
                                        ),
                                        prefixIcon: const Icon(
                                          Icons.lock_outline,
                                          color: Color(0xFF9CA3AF),
                                          size: 20,
                                        ),
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            controller.isPasswordVisible =
                                                !controller.isPasswordVisible;
                                            controller.update();
                                          },
                                          icon: Icon(
                                            controller.isPasswordVisible
                                                ? Icons.visibility_outlined
                                                : Icons.visibility_off_outlined,
                                            color: const Color(0xFF9CA3AF),
                                            size: 20,
                                          ),
                                        ),
                                        border: InputBorder.none,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 0,
                                        ),
                                        isDense: true,
                                      ),
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                // Remember Me & Forgot Password Row
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Transform.scale(
                                          scale: 0.9,
                                          child: Checkbox(
                                            value: controller.rememberMe,
                                            onChanged: (value) {
                                              controller.rememberMe =
                                                  value ?? false;
                                              controller.update();
                                            },
                                            activeColor:
                                                const Color(0xFF6366F1),
                                            checkColor: Colors.white,
                                            side: BorderSide(
                                              color: const Color(0xFF9CA3AF),
                                              width: 1.5,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                          ),
                                        ),
                                        const Text(
                                          'Remember me ?',
                                          style: TextStyle(
                                            color: Color(0xFF6B7280),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        // Handle forgot password
                                      },
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                      ),
                                      child: const Text(
                                        'Forgot Password?',
                                        style: TextStyle(
                                          color: Color(0xFF6B7280),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 32),
                                // Login Button
                                SizedBox(
                                  width: double.infinity,
                                  height: 55,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // controller.login();
                                      // Navigate to dashboard after login
                                      context.go('/dashboard');
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF6366F1),
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      shadowColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    child: const Text(
                                      'Login',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

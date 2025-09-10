import 'package:admin/views/login/auth_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/auth_controller/auth_controller.dart';

class SnapIdLoginScreen extends StatelessWidget {
  SnapIdLoginScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF181A20) : Colors.white;
    final cardColor = isDark ? const Color(0xFF23272F) : Colors.transparent;
    final textColor = isDark ? Colors.white : const Color(0xFF1F2937);
    final borderColor = isDark ? Colors.grey.shade700 : const Color.fromARGB(149, 117, 99, 210);
    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          if (!isDark)
            Positioned.fill(
              child: Image.asset(
                'assets/images/shade.png',
                fit: BoxFit.cover,
              ),
            ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 580),
                  child: GetBuilder<AuthController>(
                    init: AuthController(),
                    builder: (controller) {
                      return Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 60),
                              child: Column(
                                children: [
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    width: 160,
                                    height: 175,
                                    child: Image.asset(
                                      'assets/images/logo.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              padding: const EdgeInsets.all(50),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                border: Border.all(
                                  color: borderColor,
                                  width: 0.5,
                                ),
                                color: cardColor,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Sign In',
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w700,
                                      color: textColor,
                                    ),
                                  ),
                                  const SizedBox(height: 40),

                                  AuthTextField(
                                    hintText: 'Email',
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      if (value == null || value.isEmpty)
                                        return "Email cannot be empty";
                                      if (!GetUtils.isEmail(value))
                                        return "Enter a valid email";
                                      return null;
                                    },
                                    controller: controller.emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    prefixIcon: Icon(Icons.email_outlined,
                                        color: isDark ? Colors.grey[400] : const Color(0xFF9CA3AF), size: 20),
                                  ),
                                  const SizedBox(height: 20),

                                  AuthTextField(
                                    hintText: 'Password',
                                    isPasswordField: true,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      if (value == null || value.isEmpty)
                                        return "Password cannot be empty";
                                      if (value.length < 6)
                                        return "Password must be at least 6 characters";
                                      return null;
                                    },
                                    controller: controller.passwordController,
                                    prefixIcon: Icon(Icons.lock,
                                        color: isDark ? Colors.grey[400] : const Color(0xFF9CA3AF), size: 20),
                                  ),
                                  const SizedBox(height: 32),

                                  SizedBox(
                                    width: double.infinity,
                                    height: 55,
                                    child: ElevatedButton(
                                      onPressed: controller.isLoading
                                          ? null 
                                          : () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                controller.login(context);
                                              }
                                            },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF6366F1),
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        shadowColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                        ),
                                      ),
                                      child: controller.isLoading
                                          ? const SizedBox(
                                              height: 24,
                                              width: 24,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2.5,
                                                color: Colors
                                                    .white, 
                                              ),
                                            )
                                          : const Text(
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
                        ),
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

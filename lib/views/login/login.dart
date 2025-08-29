import 'package:admin/views/login/auth_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../controller/login_controller/login_controller.dart';

class SnapIdLoginScreen extends StatelessWidget {
  SnapIdLoginScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
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
                  child: GetBuilder<LoginController>(
                    init: LoginController(),
                    builder: (controller) {
                      return Form(
                        key: _formKey,
                        
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // ✅ LOGO
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

                            // ✅ LOGIN CARD
                            Container(
                              padding: const EdgeInsets.all(50),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                border: Border.all(
                                  color:
                                      const Color.fromARGB(149, 117, 99, 210),
                                  width: 0.5,
                                ),
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

                                  // ✅ EMAIL FIELD
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
                                    prefixIcon: const Icon(Icons.email_outlined,
                                        color: Color(0xFF9CA3AF), size: 20),
                                  ),
                                  const SizedBox(height: 20),

                                  // ✅ PASSWORD FIELD
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
                                    prefixIcon: const Icon(Icons.lock,
                                        color: Color(0xFF9CA3AF), size: 20),
                                  ),
                                  const SizedBox(height: 32),

                                  // ✅ LOGIN BUTTON
                                  SizedBox(
                                    width: double.infinity,
                                    height: 55,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          controller.login();
                                          // // If all fields are valid
                                          // context.go('/dashboard');
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

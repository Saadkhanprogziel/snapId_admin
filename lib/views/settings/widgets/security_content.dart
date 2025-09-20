// widgets/security_content.dart
import 'package:admin/controller/settings_controller/settings_controller.dart';
import 'package:admin/views/settings/widgets/setting_buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SecurityContent extends StatelessWidget {
  const SecurityContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SettingsController controller = Get.find<SettingsController>();
    final isMobile = MediaQuery.of(context).size.width <= 600;

    return Column(
      children: [
        if (isMobile) ...[
          PasswordTextField(
            label: 'Current Password',
            hint: 'Enter current password',
            controller: controller.currentPasswordController,
          ),
          const SizedBox(height: 24),
          PasswordTextField(
            label: 'New Password',
            hint: 'Enter new password',
            controller: controller.newPasswordController,
          ),
          const SizedBox(height: 24),
          PasswordTextField(
            label: 'Confirm Password',
            hint: 'Confirm new password',
            controller: controller.confirmPasswordController,
          ),
        ] else ...[
          Row(
            children: [
              Expanded(
                child: PasswordTextField(
                  label: 'Current Password',
                  hint: 'Enter current password',
                  controller: controller.currentPasswordController,
                ),
              ),
              const SizedBox(width: 24),
              const Expanded(child: SizedBox()),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: PasswordTextField(
                  label: 'New Password',
                  hint: 'Enter new password',
                  controller: controller.newPasswordController,
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: PasswordTextField(
                  label: 'Confirm Password',
                  hint: 'Confirm new password',
                  controller: controller.confirmPasswordController,
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 40),
        SettingsButtons(
          onSave:(){

          controller.savePasswordChanges(context);
          } ,
          onCancel: controller.cancelPasswordChanges,
          isMobile: isMobile,
        ),
      ],
    );
  }
}

class PasswordTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;

  const PasswordTextField({
    Key? key,
    required this.label,
    required this.hint,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final SettingsController controllerGet = Get.find<SettingsController>();
    // Use a unique key for each password field to manage its own state in the controller
    final String fieldKey = label.toLowerCase().replaceAll(' ', '_');
    controllerGet.initObscure(fieldKey);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white : const Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        Obx(() => TextFormField(
          controller: controller,
          obscureText: controllerGet.obscureMap[fieldKey]!.value,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: IconButton(
              icon: Icon(
                controllerGet.obscureMap[fieldKey]!.value ? Icons.visibility_off : Icons.visibility,
                color: const Color(0xFF6B7280),
              ),
              onPressed: () {
                controllerGet.toggleObscure(fieldKey);
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 0.4),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 0.4),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF6366F1), width: 0.4),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          ),
        )),
      ],
    );
  }
}
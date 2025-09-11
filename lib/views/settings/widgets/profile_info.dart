import 'package:admin/controller/settings_controller/settings_controller.dart';
import 'package:admin/views/settings/widgets/setting_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data'; 

class ProfileInfoContent extends StatelessWidget {
  final SettingsController controller;

  const ProfileInfoContent({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = MediaQuery.of(context).size.width <= 600;

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileImagePicker(controller: controller),
          ],
        ),
        const SizedBox(height: 40),
        if (isMobile) ...[
          SettingsTextField(
            label: 'Name',
            hint: 'Enter your name',
            controller: controller.nameController,
          ),
          const SizedBox(height: 24),
          SettingsTextField(
            label: 'Email',
            hint: 'Enter your email',
            controller: controller.emailController,
          ),
          const SizedBox(height: 24),
          SettingsTextField(
            label: 'Phone Number',
            hint: 'Enter phone number',
            controller: controller.phoneController,
          ),
        ] else ...[
          Row(
            children: [
              Expanded(
                child: SettingsTextField(
                  label: 'Name',
                  hint: 'Enter your name',
                  controller: controller.nameController,
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: SettingsTextField(
                  label: 'Email',
                  hint: 'Enter your email',
                  controller: controller.emailController,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: SettingsTextField(
                  label: 'Phone Number',
                  hint: 'Enter phone number',
                  controller: controller.phoneController,
                ),
              ),
              const SizedBox(width: 24),
              const Expanded(child: SizedBox()),
            ],
          ),
        ],
        const SizedBox(height: 40),
        SettingsButtons(
          onSave: controller.saveSettings,
          onCancel: controller.cancelChanges,
          isMobile: isMobile,
        ),
      ],
    );
  }
}

class SettingsTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;

  const SettingsTextField({
    Key? key,
    required this.label,
    required this.hint,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  const BorderSide(color: Color(0xFFE5E7EB), width: 0.4),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  const BorderSide(color: Color(0xFFE5E7EB), width: 0.4),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  const BorderSide(color: Color(0xFF6366F1), width: 0.4),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          ),
        ),
      ],
    );
  }
}

class ProfileImagePicker extends StatelessWidget {
  final SettingsController controller;

  const ProfileImagePicker({
    Key? key,
    required this.controller,
  }) : super(key: key);

  Future<void> _pickImage(BuildContext context) async {
    try {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      final ImageSource? source = await showDialog<ImageSource>(
        context: context,
        builder: (BuildContext context) {
          final bgColor = isDark ? const Color(0xFF23272F) : Colors.white;
          final textColor = isDark ? Colors.white : const Color(0xFF1F2937);
          final iconColor = isDark ? Colors.white : const Color(0xFF6366F1);
          return AlertDialog(
            backgroundColor: bgColor,
            title:
                Text('Select Image Source', style: TextStyle(color: textColor)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!kIsWeb) // Only show camera option on mobile platforms
                  ListTile(
                    leading: Icon(Icons.camera_alt, color: iconColor),
                    title: Text('Camera', style: TextStyle(color: textColor)),
                    onTap: () => Navigator.of(context).pop(ImageSource.camera),
                  ),
                ListTile(
                  leading: Icon(Icons.photo_library, color: iconColor),
                  title: Text('Gallery', style: TextStyle(color: textColor)),
                  onTap: () => Navigator.of(context).pop(ImageSource.gallery),
                ),
              ],
            ),
          );
        },
      );

      if (source != null) {
        final ImagePicker picker = ImagePicker();
        final XFile? image = await picker.pickImage(
          source: source,
          maxWidth: 800,
          maxHeight: 800,
          imageQuality: 85,
        );

        if (image != null) {
          if (kIsWeb) {
            // For web, read the image as bytes
            final Uint8List imageBytes = await image.readAsBytes();
            controller.setProfileImageBytes(imageBytes);
          } else {
            // For mobile platforms, use the file path
            controller.setProfileImage(image.path);
          }
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width <= 600;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        GestureDetector(
          onTap: () => _pickImage(context),
          child: Stack(
            children: [
              Obx(() => Container(
                    width: isMobile ? 80 : 120,
                    height: isMobile ? 80 : 120,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFE5E7EB),
                    ),
                    child: _buildProfileImage(isMobile),
                  )),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: isMobile ? 28 : 36,
                  height: isMobile ? 28 : 36,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: const Color(0xFFE5E7EB), width: 2),
                  ),
                  child: Icon(
                    Icons.camera_alt_outlined,
                    size: isMobile ? 14 : 18,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Profile Picture',
          style: TextStyle(
            fontSize: isMobile ? 12 : 14,
            color: isDark ? Colors.white : const Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileImage(bool isMobile) {
    if (kIsWeb) {
      // For web, use image bytes
      if (controller.profileImageBytes.value.isNotEmpty) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(60),
          child: Image.memory(
            controller.profileImageBytes.value,
            width: isMobile ? 80 : 120,
            height: isMobile ? 80 : 120,
            fit: BoxFit.cover,
          ),
        );
      }
    } else {
      // For mobile platforms, use file path
      if (controller.profileImagePath.value.isNotEmpty) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(60),
          child: Image.file(
            File(controller.profileImagePath.value),
            width: isMobile ? 80 : 120,
            height: isMobile ? 80 : 120,
            fit: BoxFit.cover,
          ),
        );
      }
    }

    return Icon(
      Icons.person,
      size: isMobile ? 40 : 60,
      color: const Color.fromARGB(255, 255, 255, 255),
    );
  }
}

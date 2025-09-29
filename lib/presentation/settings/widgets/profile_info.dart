import 'package:admin/controller/settings_controller/settings_controller.dart';
import 'package:admin/presentation/settings/widgets/setting_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';


class ProfileInfoContent extends StatelessWidget {
  final SettingsController controller;

  const ProfileInfoContent({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = MediaQuery.of(context).size.width <= 600;

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

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
              label: 'First Name',
              hint: 'Enter First Name',
              controller: controller.firstName,
              enabled: !controller.isUpdatingProfile.value,
            ),
            const SizedBox(height: 24),
            SettingsTextField(
              label: 'Last_Name',
              hint: 'Enter Last Name',
              controller: controller.lastName,
              
            ),
            const SizedBox(height: 24),
            SettingsTextField(
              label: 'Phone Number',
              hint: 'Enter phone number',
              controller: controller.phoneController,
              enabled: !controller.isUpdatingProfile.value,
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: SettingsTextField(
                    label: 'First Name',
                    hint: 'Enter  First Name',
                    controller: controller.firstName,
                    enabled: !controller.isUpdatingProfile.value,
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: SettingsTextField(
                    label: 'Last Name',
                    hint: 'Enter Last Name',
                    controller: controller.lastName,
                    
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
                    enabled: !controller.isUpdatingProfile.value,
                  ),
                ),
                const SizedBox(width: 24),
                const Expanded(child: SizedBox()),
              ],
            ),
          ],
          const SizedBox(height: 40),
          SettingsButtons(
            onSave: controller.updateProfile,
            onCancel: controller.cancelChanges,
            isMobile: isMobile,
            // isLoading: controller.isUpdatingProfile.value,
          ),
        ],
      );
    });
  }
}

class SettingsTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool enabled;

  const SettingsTextField({
    Key? key,
    required this.label,
    required this.hint,
    required this.controller,
    this.enabled = true,
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
          enabled: enabled,
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
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                  color: isDark ? Colors.grey[700]! : const Color(0xFFE5E7EB),
                  width: 0.4),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  const BorderSide(color: Color(0xFF6366F1), width: 0.4),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            fillColor: enabled
                ? null
                : isDark
                    ? Colors.grey[800]
                    : Colors.grey[100],
            filled: !enabled,
          ),
          style: TextStyle(
            color: enabled
                ? (isDark ? Colors.white : Colors.black)
                : (isDark ? Colors.grey[400] : Colors.grey[600]),
          ),
        ),
      ],
    );
  }
}

class ProfileImagePicker extends StatelessWidget {
  final SettingsController controller;

   ProfileImagePicker({
    Key? key,
    required this.controller,
  }) : super(key: key);

  


  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width <= 600;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        GestureDetector(
          onTap: () => controller.pickImage(),
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
    if (controller.selectedPhoto.value != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(60),
        child: Image(
          image: controller.selectedPhoto.value!,
          width: isMobile ? 80 : 120,
          height: isMobile ? 80 : 120,
          fit: BoxFit.cover,
        ),
      );
    }

    // Show current user's profile image if available
    if (controller.currentUser.value?.profilePicture != null &&
        controller.currentUser.value!.profilePicture.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(60),
        child: Image.network(
          controller.currentUser.value!.profilePicture,
          width: isMobile ? 80 : 120,
          height: isMobile ? 80 : 120,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.person,
              size: isMobile ? 40 : 60,
              color: const Color.fromARGB(255, 255, 255, 255),
            );
          },
        ),
      );
    }

    return Icon(
      Icons.person,
      size: isMobile ? 40 : 60,
      color: const Color.fromARGB(255, 255, 255, 255),
    );
  }
}

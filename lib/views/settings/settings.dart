import 'package:admin/controller/settings_controller/settings_controller.dart';
import 'package:admin/controller/app_controller.dart';
import 'package:admin/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

Widget _buildElevatedButton(String text, VoidCallback onPressed) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      backgroundColor: const Color(0xFF6366F1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 0,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.save_outlined, size: 18, color: Colors.white),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    final SettingsController controller = Get.put(SettingsController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF181A20) : Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            
            bool isDesktop = constraints.maxWidth > 1024;
            bool isTablet =
                constraints.maxWidth > 600 && constraints.maxWidth <= 1024;
            bool isMobile = constraints.maxWidth <= 600;

            return Padding(
              padding: EdgeInsets.only(
                top: isDesktop ? 70 : 20,
                left: isMobile ? 16 : 20,
                right: isMobile ? 16 : 20,
                bottom: 20,
              ),
              child: isDesktop
                  ? _buildDesktopLayout(controller, context, isDark)
                  : _buildMobileTabletLayout(
                      controller, context, isDark, isMobile),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(
      SettingsController controller, BuildContext context, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        Expanded(
          flex: 1,
          child: Column(
            children: [
              _buildSidebarButtons(controller, context, false),
              const SizedBox(height: 20),
              _buildThemeSwitcher(controller, false),
              const Spacer(),
              Container(
                height: 300,
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: Image.asset(
                  'assets/images/setting.png',
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
        
        Expanded(
          flex: 2,
          child: _buildMainContent(controller, context, isDark),
        ),
      ],
    );
  }

  Widget _buildMobileTabletLayout(SettingsController controller,
      BuildContext context, bool isDark, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        _buildSidebarButtons(controller, context, true),
        const SizedBox(height: 20),
        
        _buildThemeSwitcher(controller, true),
        const SizedBox(height: 20),
        
        Expanded(
          child: _buildMainContent(controller, context, isDark),
        ),
      ],
    );
  }

  Widget _buildSidebarButtons(
      SettingsController controller, BuildContext context, bool isHorizontal) {
    final buttons = [
      Obx(() => _buildSidebarItem(
            context: context,
            title: 'Profile Info',
            isActive: controller.selectedScreen.value == 'Profile Info',
            onTap: () => controller.changeScreen('Profile Info'),
            isHorizontal: isHorizontal,
          )),
      Obx(() => _buildSidebarItem(
            context: context,
            title: 'Security',
            isActive: controller.selectedScreen.value == 'Security',
            onTap: () => controller.changeScreen('Security'),
            isHorizontal: isHorizontal,
          )),
      Obx(() => _buildSidebarItem(
            context: context,
            title: 'Notifications',
            isActive: controller.selectedScreen.value == 'Notifications',
            onTap: () => controller.changeScreen('Notifications'),
            isHorizontal: isHorizontal,
          )),
    ];

    if (isHorizontal) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: buttons
                .map(
                  (button) => Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: button,
                  ),
                )
                .toList(),
          ),
        ),
      );
    } else {
      return Column(
        children: buttons
            .map(
              (button) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: button,
              ),
            )
            .toList(),
      );
    }
  }

  Widget _buildMainContent(
      SettingsController controller, BuildContext context, bool isDark) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width > 600 ? 20 : 0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          width: 0.4,
          color: isDark ? Colors.grey.shade700 : Colors.grey,
        ),
        color: isDark ? const Color(0xFF23272F) : Colors.white,
      ),
      padding: EdgeInsets.all(
        MediaQuery.of(context).size.width > 600 ? 50 : 20,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => Text(
                          controller.selectedScreen.value,
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width > 600
                                ? 32
                                : 24,
                            fontWeight: FontWeight.w600,
                            color:
                                isDark ? Colors.white : const Color(0xFF1F2937),
                          ),
                        )),
                    const SizedBox(height: 40),
                    Obx(() {
                      if (controller.selectedScreen.value == 'Profile Info') {
                        return Column(
                          children:
                              _buildProfileInfoContent(controller, context),
                        );
                      } else if (controller.selectedScreen.value ==
                          'Security') {
                        return Column(
                          children: _buildSecurityContent(),
                        );
                      } else if (controller.selectedScreen.value ==
                          'Notifications') {
                        return Column(
                          children:
                              _buildNotificationsContent(controller, context),
                        );
                      }
                      return const SizedBox();
                    }),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  
  Future<void> _pickImage(SettingsController controller, BuildContext context) async {
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
            title: Text('Select Image Source', style: TextStyle(color: textColor)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
          controller.setProfileImage(image.path);
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

  List<Widget> _buildProfileInfoContent(
      SettingsController controller, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = MediaQuery.of(context).size.width <= 600;

    return [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              GestureDetector(
                onTap: () => _pickImage(controller, context),
                child: Stack(
                  children: [
                    Obx(() => Container(
                      width: isMobile ? 80 : 120,
                      height: isMobile ? 80 : 120,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFE5E7EB),
                      ),
                      child: controller.profileImagePath.value.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: Image.file(
                                File(controller.profileImagePath.value),
                                width: isMobile ? 80 : 120,
                                height: isMobile ? 80 : 120,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Icon(
                              Icons.person,
                              size: isMobile ? 40 : 60,
                              color: const Color.fromARGB(255, 255, 255, 255),
                            ),
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
                          border: Border.all(
                              color: const Color(0xFFE5E7EB), width: 2),
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
          ),
        ],
      ),
      const SizedBox(height: 40),
      
      if (isMobile) ...[
        _buildTextField(
            'Name', 'Enter your name', controller.nameController, context),
        const SizedBox(height: 24),
        _buildTextField(
            'Email', 'Enter your email', controller.emailController, context),
        const SizedBox(height: 24),
        _buildTextField('Phone Number', 'Enter phone number',
            controller.phoneController, context),
      ] else ...[
        Row(
          children: [
            Expanded(
              child: _buildTextField('Name', 'Enter your name',
                  controller.nameController, context),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _buildTextField('Email', 'Enter your email',
                  controller.emailController, context),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: _buildTextField('Phone Number', 'Enter phone number',
                  controller.phoneController, context),
            ),
            const SizedBox(width: 24),
            const Expanded(child: SizedBox()),
          ],
        ),
      ],
      const SizedBox(height: 40),
      
      if (isMobile) ...[
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildElevatedButton('Save', controller.saveSettings),
            const SizedBox(height: 12),
            _buildOutlinedButton('Cancel', controller.cancelChanges,
                isDark: isDark),
          ],
        ),
      ] else ...[
        Row(
          children: [
            _buildOutlinedButton('Cancel', controller.cancelChanges,
                isDark: isDark),
            const SizedBox(width: 16),
            _buildElevatedButton('Save', controller.saveSettings),
          ],
        ),
      ],
    ];
  }

  Widget _buildTextField(String label, String hint,
      TextEditingController controller, BuildContext context) {
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

  List<Widget> _buildSecurityContent() {
    return [
      Builder(
        builder: (context) => Text(
          'Security settings content goes here...',
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : const Color(0xFF6B7280),
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildNotificationsContent(
      SettingsController controller, BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width <= 600;

    return [
      Obx(() => _buildNotificationToggle(
            label: 'Ticket Notifications',
            value: controller.ticketNotifications.value,
            onChanged: controller.toggleTicketNotifications,
            context: context,
          )),
      const SizedBox(height: 16),
      Obx(() => _buildNotificationToggle(
            label: 'New Order Notifications',
            value: controller.newOrderNotifications.value,
            onChanged: controller.toggleNewOrderNotifications,
            context: context,
          )),
      const SizedBox(height: 40),
      
      if (isMobile) ...[
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildElevatedButton('Save', controller.saveSettings),
            const SizedBox(height: 12),
            _buildOutlinedButton('Cancel', controller.cancelChanges),
          ],
        ),
      ] else ...[
        Row(
          children: [
            _buildOutlinedButton('Cancel', controller.cancelChanges),
            const SizedBox(width: 16),
            _buildElevatedButton('Save', controller.saveSettings),
          ],
        ),
      ],
    ];
  }

  Widget _buildNotificationToggle({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
    required BuildContext context,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(width: 0.4, color: Colors.grey),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white : const Color(0xFF374151),
                  ),
                ),
              ),
              Transform.scale(
                scale: 0.8,
                child: Switch(
                  value: value,
                  onChanged: onChanged,
                  activeColor: Colors.white,
                  activeTrackColor: const Color(0xFF6366F1),
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: const Color(0xFFE5E7EB),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOutlinedButton(String text, VoidCallback onPressed,
      {bool isDark = false}) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        side: const BorderSide(color: Color(0xFFD1D5DB)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (text != "Cancel") ...[
            const Icon(Icons.save_outlined, size: 18, color: Colors.white),
            const SizedBox(width: 8),
          ],
          Text(
            text,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem({
    required BuildContext context,
    required String title,
    required bool isActive,
    VoidCallback? onTap,
    bool isHorizontal = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = const Color(0xFF6366F1);
    final inactiveTextColor = isDark ? Colors.white : Colors.black;
    final activeTextColor = Colors.white;
    final isMobile = MediaQuery.of(context).size.width <= 600;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isHorizontal ? 0 : 40,
        vertical: isHorizontal ? 0 : 5,
      ),
      padding: EdgeInsets.symmetric(
        vertical: isHorizontal ? 8 : 5,
        horizontal: isHorizontal ? 16 : 0,
      ),
      constraints: isHorizontal ? const BoxConstraints(minWidth: 120) : null,
      decoration: BoxDecoration(
        border: !isActive
            ? Border.all(
                width: 0.4,
                color: isDark ? Colors.grey.shade700 : Colors.grey,
              )
            : null,
        color: isActive
            ? activeColor
            : (isDark ? const Color(0xFF23272F) : Colors.transparent),
        borderRadius: BorderRadius.circular(12),
      ),
      child: isHorizontal
          ? InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: CustomTextTheme.regular14.copyWith(
                    color: isActive ? activeTextColor : inactiveTextColor,
                    fontWeight: FontWeight.w500,
                    fontSize: isMobile ? 14 : 16,
                  ),
                ),
              ),
            )
          : ListTile(
              onTap: onTap,
              title: Text(
                title,
                style: CustomTextTheme.regular14.copyWith(
                  color: isActive ? activeTextColor : inactiveTextColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            ),
    );
  }

  Widget _buildThemeSwitcher(SettingsController controller, bool isHorizontal) {
    final appController = Get.find<AppController>();
    return Container(
      margin: EdgeInsets.symmetric(horizontal: isHorizontal ? 15 : 40),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.wb_sunny_outlined,
                  size: 16,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Switch Theme', style: CustomTextTheme.regular14),
                  Obx(() => Text(
                        appController.themeMode.value == ThemeMode.light
                            ? 'Light Mode'
                            : 'Dark Mode',
                        style: const TextStyle(
                          color: Color(0xFF9CA3AF),
                          fontSize: 12,
                        ),
                      )),
                ],
              ),
            ],
          ),
          Obx(() => Switch(
                value: appController.themeMode.value == ThemeMode.dark,
                onChanged: (isDark) => appController.toggleTheme(isDark),
              )),
        ],
      ),
    );
  }
}
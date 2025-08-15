import 'package:admin/controller/settings_controller/settings_controller.dart';
import 'package:admin/controller/app_controller.dart';
import 'package:admin/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    // Initialize the controller
    final SettingsController controller = Get.put(SettingsController());

    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF181A20) : Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 70),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sidebar
              Expanded(
                flex: 1,
                child: Container(
                  // No sidebar background
                  child: Column(
                    children: [
                      Obx(() => _buildSidebarItem(
                            context: context,
                            title: 'Profile Info',
                            isActive: controller.selectedScreen.value ==
                                'Profile Info',
                            onTap: () =>
                                controller.changeScreen('Profile Info'),
                          )),
                      const SizedBox(height: 8),
                      Obx(() => _buildSidebarItem(
                            context: context,
                            title: 'Security',
                            isActive:
                                controller.selectedScreen.value == 'Security',
                            onTap: () => controller.changeScreen('Security'),
                          )),
                      const SizedBox(height: 8),
                      Obx(() => _buildSidebarItem(
                            context: context,
                            title: 'Notifications',
                            isActive: controller.selectedScreen.value ==
                                'Notifications',
                            onTap: () =>
                                controller.changeScreen('Notifications'),
                          )),
                      const SizedBox(height: 8),
                      _buildThemeSwitcher(controller),
                      const Spacer(),
                      Container(
                        height: 300,
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        child:
                        Image.asset(
                          'assets/images/setting.png',
                          fit: BoxFit.contain,
                        )
                      ),
                    ],
                  ),
                ),
              ),

              // Main content
              Expanded(
                flex: 2,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                        width: 0.4,
                        color: isDark ? Colors.grey.shade700 : Colors.grey),
                    color: isDark ? const Color(0xFF23272F) : Colors.white,
                  ),
                  padding: const EdgeInsets.all(50),
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
                                        fontSize: 32,
                                        fontWeight: FontWeight.w600,
                                        color: isDark
                                            ? Colors.white
                                            : const Color(0xFF1F2937),
                                      ),
                                    )),
                                const SizedBox(height: 40),
                                Obx(() {
                                  if (controller.selectedScreen.value ==
                                      'Profile Info') {
                                    return Column(
                                      children: _buildProfileInfoContent(
                                          controller, context),
                                    );
                                  } else if (controller.selectedScreen.value ==
                                      'Security') {
                                    return Column(
                                      children: _buildSecurityContent(),
                                    );
                                  } else if (controller.selectedScreen.value ==
                                      'Notifications') {
                                    return Column(
                                      children: _buildNotificationsContent(
                                          controller, context),
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildProfileInfoContent(
      SettingsController controller, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFE5E7EB),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 60,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: const Color(0xFFE5E7EB), width: 2),
                      ),
                      child: const Icon(
                        Icons.camera_alt_outlined,
                        size: 18,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Profile Picture',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ],
      ),
      const SizedBox(height: 40),
      Row(
        children: [
          Expanded(
            child: _buildTextField(
                'Name', 'Enter your name', controller.nameController, context),
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
      const SizedBox(height: 40),
      Row(
        children: [
          _buildOutlinedButton('Cancel', controller.cancelChanges,
              isDark: isDark),
          const SizedBox(width: 16),
          _buildElevatedButton('Save', controller.saveSettings),
        ],
      ),
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
      Row(
        children: [
          _buildOutlinedButton('Cancel', controller.cancelChanges),
          const SizedBox(width: 16),
          _buildElevatedButton('Save', controller.saveSettings),
        ],
      ),
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
            // color: isDark ? const Color(0xFF23272F) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(width: 0.4, color: Colors.grey),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white : const Color(0xFF374151),
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
            Icon(Icons.save_outlined, size: 18, color: Colors.white),
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
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color activeColor = const Color(0xFF6366F1);
    final Color inactiveTextColor = isDark ? Colors.white : Colors.black;
    final Color activeTextColor = Colors.white;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        border: !isActive
            ? Border.all(
                width: 0.4, color: isDark ? Colors.grey.shade700 : Colors.grey)
            : null,
        color: isActive
            ? activeColor
            : (isDark ? const Color(0xFF23272F) : Colors.transparent),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: onTap,
        title: Text(
          title,
          style: CustomTextTheme.regular14.copyWith(
            color: isActive ? activeTextColor : inactiveTextColor,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      ),
    );
  }

  Widget _buildThemeSwitcher(SettingsController controller) {
    final appController = Get.find<AppController>();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
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
                value: appController.themeMode.value ==
                    ThemeMode.dark, // ON only if Dark mode is active
                onChanged: (isDark) => appController.toggleTheme(isDark),
              )),
        ],
      ),
    );
  }
}

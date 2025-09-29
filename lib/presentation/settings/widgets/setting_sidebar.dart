import 'package:admin/controller/settings_controller/settings_controller.dart';
import 'package:admin/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsSidebar extends StatelessWidget {
  final SettingsController controller;
  final bool isHorizontal;

  const SettingsSidebar({
    Key? key,
    required this.controller,
    required this.isHorizontal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttons = [
      Obx(() => SettingsSidebarItem(
            context: context,
            title: 'Profile Info',
            isActive: controller.selectedScreen.value == 'Profile Info',
            onTap: () => controller.changeScreen('Profile Info'),
            isHorizontal: isHorizontal,
          )),
      Obx(() => SettingsSidebarItem(
            context: context,
            title: 'Security',
            isActive: controller.selectedScreen.value == 'Security',
            onTap: () => controller.changeScreen('Security'),
            isHorizontal: isHorizontal,
          )),
      // Obx(() => SettingsSidebarItem(
      //       context: context,
      //       title: 'Notifications',
      //       isActive: controller.selectedScreen.value == 'Notifications',
      //       onTap: () => controller.changeScreen('Notifications'),
      //       isHorizontal: isHorizontal,
      //     )),
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
}

class SettingsSidebarItem extends StatelessWidget {
  final BuildContext context;
  final String title;
  final bool isActive;
  final VoidCallback? onTap;
  final bool isHorizontal;

  const SettingsSidebarItem({
    Key? key,
    required this.context,
    required this.title,
    required this.isActive,
    this.onTap,
    this.isHorizontal = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}
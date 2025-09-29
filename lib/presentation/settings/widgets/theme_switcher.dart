import 'package:admin/controller/settings_controller/settings_controller.dart';
import 'package:admin/controller/app_controller.dart';
import 'package:admin/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsThemeSwitcher extends StatelessWidget {
  final SettingsController controller;
  final bool isHorizontal;

  const SettingsThemeSwitcher({
    Key? key,
    required this.controller,
    required this.isHorizontal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
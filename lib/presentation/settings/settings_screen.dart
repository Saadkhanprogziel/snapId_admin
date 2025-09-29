import 'package:admin/controller/settings_controller/settings_controller.dart';
import 'package:admin/presentation/settings/widgets/profile_info.dart';
import 'package:admin/presentation/settings/widgets/security_content.dart';
import 'package:admin/presentation/settings/widgets/setting_sidebar.dart';
import 'package:admin/presentation/settings/widgets/theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
              SettingsSidebar(controller: controller, isHorizontal: false),
              const SizedBox(height: 20),
              SettingsThemeSwitcher(
                  controller: controller, isHorizontal: false),
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
          child: SettingsMainContent(controller: controller),
        ),
      ],
    );
  }

  Widget _buildMobileTabletLayout(SettingsController controller,
      BuildContext context, bool isDark, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSidebar(controller: controller, isHorizontal: true),
        const SizedBox(height: 20),
        SettingsThemeSwitcher(controller: controller, isHorizontal: true),
        const SizedBox(height: 20),
        Expanded(
          child: SettingsMainContent(controller: controller),
        ),
      ],
    );
  }
}

class SettingsMainContent extends StatelessWidget {
  final SettingsController controller;

  const SettingsMainContent({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                        return ProfileInfoContent(controller: controller);
                      } else if (controller.selectedScreen.value ==
                          'Security') {
                        return const SecurityContent();
                      }
                      // else if (controller.selectedScreen.value == 'Notifications') {
                      //   return NotificationsContent(controller: controller);
                      // }
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
}

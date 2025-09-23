import 'package:admin/constants/colors.dart';
import 'package:admin/controller/app_controller.dart';
import 'package:admin/controller/auth_controller/auth_controller.dart';
import 'package:admin/theme/text_theme.dart';
import 'package:admin/views/notification/notification.dart';
import 'package:admin/views/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class TopBar extends StatelessWidget {
  final VoidCallback? onSettingsPressed;

  const TopBar({Key? key, this.onSettingsPressed}) : super(key: key);
  String _getTitle(String location) {
    if (location.startsWith('/dashboard')) {
      return "dashboard";
    } else if (location.startsWith('/analytics')) {
      return "Analytics";
    } else if (location.startsWith('/orders')) {
      return "Manage Order";
    } else if (location.startsWith('/users')) {
      return "Manage Users";
    } else if (location.startsWith('/settings')) {
      return "Settings";
    } else if (location.startsWith('/support')) {
      return "Support";
    } else if (location.startsWith('/user-activity')) {
      return "User Activity";
    } else if (location.startsWith('/price-settings')) {
      return "Price Settings";
    } else {
      return "Welcome";
    }
  }

  @override
  Widget build(BuildContext context) {
    final drawerController = Get.find<AppController>();
    final authController = Get.find<AuthController>();

    final currentLocation = GoRouterState.of(context).uri.path;
    final title = _getTitle(currentLocation);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (title == "dashboard") ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Welcome",
                    style: CustomTextTheme.regular20.copyWith(
                        color: isDark ? Colors.white : AppColors.grey)),
                Obx(() {
                  final user = authController.adminUser.value;
                  final fullName = [user?.firstName ?? '', user?.lastName ?? '']
                      .where((s) => s.isNotEmpty)
                      .join(' ');
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(fullName,
                          style: CustomTextTheme.regular24.copyWith(
                              color: isDark
                                  ? Colors.white
                                  : AppColors.blackColor)),
                      if (user?.email != null && user!.email.isNotEmpty)
                        Text(user.email,
                            style: TextStyle(fontSize: 14, color: Colors.grey)),
                      if (user?.role != null && user!.role.isNotEmpty)
                        Text(user.role,
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  );
                }),
              ],
            ),
          ],
          if (title != "dashboard")
            Text(title,
                style: CustomTextTheme.regular26.copyWith(
                    color: isDark ? Colors.white : AppColors.blackColor)),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  drawerController.isNotification.value = true;
                  drawerController.toggleDrawer(content: NotificationsScreen());
                },
                child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                        color: AppColors.grey.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8)),
                    child: Icon(Icons.notifications_none)),
              ),
              SizedBox(width: 16),
              GestureDetector(
                onTap: () {
                  drawerController.toggleDrawer(content: Settings());
                },
                child: Obx(() {
                  final user = authController.adminUser.value;
                  final hasProfilePic =
                      user != null && user.profilePicture.isNotEmpty;
                  return CircleAvatar(
                    backgroundImage: hasProfilePic
                        ? NetworkImage(user.profilePicture)
                        : null,
                    child: !hasProfilePic ? Icon(Icons.person) : null,
                  );
                }),
              ),
              SizedBox(width: 8),
              Obx(() {
                final user = authController.adminUser.value;
                final fullName = [user?.firstName ?? '', user?.lastName ?? '']
                    .where((s) => s.isNotEmpty)
                    .join(' ');
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(fullName,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                );
              })
            ],
          )
        ],
      ),
    );
  }
}

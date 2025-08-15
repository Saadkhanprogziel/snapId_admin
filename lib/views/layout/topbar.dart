import 'package:admin/constants/colors.dart';
import 'package:admin/controller/app_controller.dart';
import 'package:admin/theme/text_theme.dart';
import 'package:admin/views/notification/notification.dart';
import 'package:admin/views/settings/settings.dart';
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
                    style: CustomTextTheme.regular20
                        .copyWith(color: isDark ? Colors.white : AppColors.grey)),
                Text("Marco Kasper!",
                    style: CustomTextTheme.regular24
                        .copyWith(color: isDark ? Colors.white : AppColors.blackColor)),
              ],
            ),
          ],
          if (title != "dashboard")
            Text(title,
                style: CustomTextTheme.regular26
                    .copyWith(color: isDark ? Colors.white : AppColors.blackColor)),
          Row(
            children: [
                GestureDetector(
                  onTap: () {
                    drawerController.isNotification.value = true;
                    drawerController.toggleDrawer(
                      content: NotificationsScreen()  
                    );
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
                onTap: (){
                  drawerController.toggleDrawer(
                content:Settings()
              );
                },
                child: CircleAvatar(
                    backgroundImage: NetworkImage(
                        "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D")),
              ),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Marco Kasper",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("Admin", style: TextStyle(fontSize: 12)),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}

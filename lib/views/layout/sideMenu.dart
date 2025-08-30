import 'package:admin/constants/colors.dart';
import 'package:admin/controller/auth_controller/auth_controller.dart';
import 'package:admin/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
// Import your AuthController

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final String currentRoute = GoRouterState.of(context).uri.toString();
    final AuthController authController = Get.put(AuthController());

    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: 400,
      color: isDark ? const Color(0xFF181A20) : Colors.white,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/purple_shade.png',
              fit: BoxFit.cover,
              alignment: Alignment.centerLeft,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
            child: CustomScrollView(
                slivers: [
                // Fixed header section
                SliverToBoxAdapter(
                  child: Column(
                  children: [
                    const SizedBox(height: 100),
                    SizedBox(
                    width: 171,
                    height: 60,
                    child: Image.asset(
                      'assets/images/text_logo.png',
                      fit: BoxFit.contain,
                    ),
                    ),
                    const SizedBox(height: 32),
                  ],
                  ),
                ),
                // Scrollable menu items
                SliverList(
                  delegate: SliverChildListDelegate([
                  _sideMenuItem(
                    context,
                    icon: "assets/icons/dash.svg",
                    label: "Dashboard",
                    route: "/",
                    selected: currentRoute == '/',
                  ),
                  _sideMenuItem(
                    context,
                    icon: "assets/icons/analytics.svg",
                    label: "Analytics",
                    route: "/analytics",
                    selected: currentRoute == '/analytics',
                  ),
                  _sideMenuItem(
                    context,
                    icon: "assets/icons/manage_user.svg",
                    label: "Manage Users",
                    route: "/users",
                    selected: currentRoute == '/users',
                  ),
                  _sideMenuItem(
                    context,
                    icon: "assets/icons/manage_orders.svg",
                    label: "Manage Orders",
                    route: "/orders",
                    selected: currentRoute == '/orders',
                  ),
                  _sideMenuItem(
                    context,
                    icon: "assets/icons/support.svg",
                    label: "Support",
                    route: "/support",
                    selected: currentRoute == '/support',
                  ),
                  _sideMenuItem(
                    context,
                    icon: "assets/icons/price_setting.svg",
                    label: "Price Setting",
                    route: "/price-settings",
                    selected: currentRoute == '/price-settings',
                  ),
                  _sideMenuItem(
                    context,
                    icon: "assets/icons/activity.svg",
                    label: "User Activity",
                    route: "/user-activity",
                    selected: currentRoute == '/user-activity',
                  ),
                  _sideMenuItem(
                    context,
                    icon: "assets/icons/analytics.svg",
                    label: "Setting",
                    route: "/settings",
                    selected: currentRoute == '/settings',
                  ),
                  // Add some space before the sign out button
                  const SizedBox(height: 40),
                  ]),
                ),
                // Fixed Sign Out button at the bottom
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: SizedBox(
                    height: 65,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                      backgroundColor: isDark
                        ? const Color(0xFF23272F).withOpacity(0.5)
                        : Colors.white.withOpacity(0.7),
                      foregroundColor: isDark ? Colors.white : AppColors.themeText,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                        color: isDark ? Colors.white24 : AppColors.themeText.withOpacity(0.2),
                        width: 0.5,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20 ),
                      alignment: Alignment.centerLeft,
                      ),
                      onPressed: () async {
                        // Show confirmation dialog before logout
                        final bool shouldLogout = await _showLogoutDialog(context);
                        if (shouldLogout) {
                          // Call the logout method from AuthController
                          authController.logout(context);
                          // Navigate to login page after logout
                          if (context.mounted) {
                            context.go('/login');
                          }
                        }
                      },
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.logout, color: isDark ? Colors.white : AppColors.themeText),
                        const SizedBox(width: 12),
                        Text(
                        "Sign Out",
                        style: TextStyle(
                          color: isDark ? Colors.white : AppColors.themeText,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                        ),
                      ],
                      ),
                    ),
                    ),
                  ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Add confirmation dialog for logout
  Future<bool> _showLogoutDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF181A20) : Colors.white,
          title: Text(
            'Confirm Logout',
            style: TextStyle(
              color: isDark ? Colors.white : AppColors.themeText,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'Are you sure you want to sign out?',
            style: TextStyle(
              color: isDark ? Colors.white70 : AppColors.themeText.withOpacity(0.8),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: isDark ? Colors.white70 : AppColors.themeText.withOpacity(0.7),
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Sign Out'),
            ),
          ],
        );
      },
    ) ?? false;
  }

  Widget _sideMenuItem(
    BuildContext context, {
    required String icon,
    required String label,
    required String route,
    required bool selected,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color activeColor = selected
        ? (isDark ? const Color(0xFF6366F1).withOpacity(0.85) : const Color.fromARGB(217, 96, 66, 255))
        : (isDark ? const Color(0xFF23272F).withOpacity(0.5) : Colors.white.withOpacity(0.7));
    final Color textColor = selected
        ? Colors.white
        : (isDark ? Colors.white : AppColors.themeText);
    return InkWell(
      onTap: () => context.go(route),
      child: Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        margin: const EdgeInsets.symmetric(vertical: 3),
        decoration: BoxDecoration(
          color: activeColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              color: textColor,
            ),
            const SizedBox(width: 20),
            Text(
              label,
              style: CustomTextTheme.regular16.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

class PriceSetting extends StatelessWidget {
  const PriceSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Price Setting"),
    );
  }
}
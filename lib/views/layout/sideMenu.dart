import 'package:admin/constants/colors.dart';
import 'package:admin/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final String currentRoute = GoRouterState.of(context).uri.toString();

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
            child: Column(
              children: [
                const SizedBox(height: 100),
                const Text(
                  "SnapID",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 32),
                _sideMenuItem(
                  context,
                  icon: "assets/icons/dash.svg",
                  label: "Dashboard",
                  route: "/dashboard",
                  selected: currentRoute == '/dashboard',
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
                  // route: "/users/42",
                  // selected: currentRoute.startsWith('/orders'),
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
              ],
            ),
          ),
        ],
      ),
    );
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
        ? (isDark ? const Color(0xFF6366F1).withOpacity(0.85) : Color.fromARGB(217, 96, 66, 255))
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
    return Center(
      child: Text("Price Setting"),
    );
  }
}



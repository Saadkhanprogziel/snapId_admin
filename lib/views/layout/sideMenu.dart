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

    return Container(
      width: 400,
      color: Colors.white,
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
                  icon: "assets/icons/setting.svg",
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
    return InkWell(
      onTap: () => context.go(route),
      child: Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        margin: const EdgeInsets.symmetric(vertical: 3),
        decoration: BoxDecoration(
          color: selected ? Color.fromARGB(255,96, 66, 255,) : Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            SvgPicture.asset(icon,color: selected ? Colors.white : AppColors.themeText,),
            const SizedBox(width: 20),
            Text(
              label,
              style: CustomTextTheme.regular16.copyWith(color: selected ? Colors.white : AppColors.themeText,fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

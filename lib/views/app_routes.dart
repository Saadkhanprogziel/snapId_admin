import 'package:admin/views/activity/activity.dart';
import 'package:admin/views/analytics/analytics.dart';
import 'package:admin/views/dashboard/dashboard.dart';
import 'package:admin/views/layout/layout.dart';
import 'package:admin/views/layout/sideMenu.dart';
import 'package:admin/views/order_management/order_info_content/order_info_content.dart';
import 'package:admin/views/order_management/order_management.dart';
import 'package:admin/views/price_setting/pricing_setting.dart';
import 'package:admin/views/settings/settings.dart';
import 'package:admin/views/support/support.dart';
import 'package:admin/views/user_management/user_management.dart';
import 'package:go_router/go_router.dart';
import 'package:admin/views/login/login.dart';



final router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const SnapIdLoginScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) => AdminLayout(child: child),
      routes: [
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => DashboardContent(),
        ),
        GoRoute(
          path: '/analytics',
          builder: (context, state) => Analytics(),
        ),
        GoRoute(
          path: '/orders',
          builder: (context, state) => OrderManagement(),
        ),
        GoRoute(
          path: '/users',
          builder: (context, state) => UserManagement(),
        ),
        GoRoute(
          path: '/support',
          builder: (context, state) => Support(),
        ),
        GoRoute(
          path: '/user-activity',
          builder: (context, state) => Activity(),
        ),
        GoRoute(
          path: '/price-settings',
          builder: (context, state) => PricingSetting(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => Settings(),
        ),
        // ...existing code...
      ],
    ),
  ],
);





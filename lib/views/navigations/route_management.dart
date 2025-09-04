import 'package:admin/constants/app_routes.dart';
import 'package:admin/main.dart';
import 'package:admin/views/navigations/app_navigation.dart';
import 'package:go_router/go_router.dart';


import 'package:admin/views/login/login.dart';
import 'package:admin/views/layout/layout.dart';
import 'package:admin/views/dashboard/dashboard.dart';
import 'package:admin/views/analytics/analytics.dart';
import 'package:admin/views/order_management/order_management.dart';
import 'package:admin/views/user_management/user_management.dart';
import 'package:admin/views/support/support.dart';
import 'package:admin/views/activity/activity.dart';
import 'package:admin/views/price_setting/pricing_setting.dart';
import 'package:admin/views/settings/settings.dart';

class AppRouter {
  static final router = GoRouter(
    navigatorKey: AppNavigation.navigatorKey,
    initialLocation: '/',
    routes: [
      GoRoute(
        path: AppRoutes.login,
        name: 'login', 
        builder: (context, state) => SnapIdLoginScreen(),
        redirect: (context, state) {
          final token = localStorage.getString("token");
          if (token != null && token.isNotEmpty) return '/';
          return null; 
        },
      ),
      ShellRoute(
        builder: (context, state, child) => AdminLayout(child: child),
        routes: [
          GoRoute(
            path: '/',
            name: 'dashboard', 
            builder: (context, state) => DashboardContent(),
            redirect: (context, state) {
              final token = localStorage.getString("token");
              if (token == null || token.isEmpty) return AppRoutes.login;
              return null;
            },
          ),
          GoRoute(
            path: AppRoutes.analytics,
            builder: (context, state) => Analytics(),
          ),
          GoRoute(
            path: AppRoutes.orders,
            builder: (context, state) => OrderManagement(),
          ),
          GoRoute(
            path: AppRoutes.users,
            builder: (context, state) => UserManagement(),
          ),
          GoRoute(
            path: AppRoutes.support,
            builder: (context, state) => Support(),
          ),
          GoRoute(
            path: AppRoutes.userActivity,
            builder: (context, state) => Activity(),
          ),
          GoRoute(
            path: AppRoutes.priceSettings,
            builder: (context, state) => PricingSetting(),
          ),
          GoRoute(
            path: AppRoutes.settings,
            builder: (context, state) => Settings(),
          ),
        ],
      ),
    ],
  );
}

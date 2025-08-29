import 'package:admin/constants/app_routes.dart';
import 'package:admin/main.dart';
import 'package:go_router/go_router.dart';

// Import views
import 'package:admin/views/splash/splash_screen.dart';
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
    initialLocation: AppRoutes.login,
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) =>  SnapIdLoginScreen(),
        redirect: (context, state) {
              final token = localStorage.getString("token");
              if (token != null && token.isNotEmpty) return '/dashboard';
              return '/login';
            },
      ),
      ShellRoute(
        builder: (context, state, child) => AdminLayout(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.dashboard,
            builder: (context, state) => DashboardContent(),
            redirect: (context, state) {
              final token = localStorage.getString("token");
              if (token != null && token.isNotEmpty) return '/dashboard';
              return '/login';
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

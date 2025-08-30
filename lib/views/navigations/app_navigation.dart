import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:universal_html/html.dart' as html;

class AppNavigation {
  static final navigatorKey = GlobalKey<NavigatorState>();

  static BuildContext get _appContext {
    final ctx = navigatorKey.currentContext;
    if (ctx == null) {
      throw Exception("Navigator context not ready yet!");
    }
    return ctx;
  }

  static void pushNamed(
    String routeName, {
    dynamic extra,
    Map<String, String>? pathParameters,
  }) {
    _appContext.pushNamed(
      routeName,
      extra: extra,
      pathParameters: pathParameters ?? {},
    );
  }

  static Future<T?> pushNamedWithResult<T>(
    String routeName, {
    dynamic extra,
    Map<String, String>? pathParameters,
  }) {
    return _appContext.pushNamed<T>(
      routeName,
      extra: extra,
      pathParameters: pathParameters ?? {},
    );
  }

  static void popUntil(
    String routeName, {
    dynamic extra,
    Map<String, String>? pathParameters,
  }) {
    _appContext.goNamed(
      routeName,
      extra: extra,
      pathParameters: pathParameters ?? {},
    );
  }

  static void pushReplacementNamed(
    String routeName, {
    dynamic extra,
    Map<String, String>? pathParameters,
  }) {
    _appContext.replaceNamed(
      routeName,
      extra: extra,
      pathParameters: pathParameters ?? {},
    );
  }

  static void pop<T>([T? result]) {
    _appContext.pop(result);
  }

  static String getCurrentPathFromBrowser() {
    final location = html.window.location.href;
    final hashedPath = location.split('#');
    final path = hashedPath.length > 1 ? hashedPath[1] : location;
    return path;
  }
}

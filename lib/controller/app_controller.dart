import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppController extends GetxController {
  // Theme mode state
  final Rx<ThemeMode> themeMode = ThemeMode.light.obs;

  void setThemeMode(ThemeMode mode) => themeMode.value = mode;
  void toggleTheme(bool isLight) => themeMode.value = isLight ? ThemeMode.light : ThemeMode.dark;
  var sidebarCollapsed = false.obs;


  final RxBool _isRightDrawerOpen = false.obs;
  final Rx<Widget?> _drawerContent = Rx<Widget?>(null);

  bool get isRightDrawerOpen => _isRightDrawerOpen.value;
  Widget? get drawerContent => _drawerContent.value;

  void toggleDrawer({Widget? content}) {
    _isRightDrawerOpen.value = !_isRightDrawerOpen.value;
    if (content != null) {
      _drawerContent.value = content;
    }
    if (!_isRightDrawerOpen.value) {
      _drawerContent.value = null; // Clear content when closing
    }
  }

  void setDrawerContent(Widget content) {
    _drawerContent.value = content;
  }

  void closeDrawer() {
    _isRightDrawerOpen.value = false;
    _drawerContent.value = null;
  }

  void toggleSidebar() {
    sidebarCollapsed.value = !sidebarCollapsed.value;
  }
}

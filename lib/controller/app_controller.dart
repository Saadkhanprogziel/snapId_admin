import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AppController extends GetxController {
  final GetStorage _storage = GetStorage();


  // Start with Light theme
      final RxBool showFilter = false.obs;
      final Rx<Widget?> _filterContent = Rx<Widget?>(null);


    final RxBool isNotification = false.obs;
  final Rx<ThemeMode> themeMode = ThemeMode.light.obs;

  // Toggle based on switch value
  void toggleTheme(bool darkModeEnabled) {
    themeMode.value = darkModeEnabled ? ThemeMode.dark : ThemeMode.light;
    _storage.write('themeMode', themeMode.value == ThemeMode.dark ? 'dark' : 'light');
  }

  var sidebarCollapsed = false.obs;
  final RxBool isThemeToggleOn = false.obs; // you can remove if unused

  final RxBool _isRightDrawerOpen = false.obs;
  final Rx<Widget?> _drawerContent = Rx<Widget?>(null);

  bool get isRightDrawerOpen => _isRightDrawerOpen.value;
  Widget? get drawerContent => _drawerContent.value;
  Widget? get filterContent => _filterContent.value;

  void toggleDrawer({Widget? content}) {
    _isRightDrawerOpen.value = !_isRightDrawerOpen.value;
    if (content != null) {
      _drawerContent.value = content;
    }
    if (!_isRightDrawerOpen.value) {
      _drawerContent.value = null;
    }
  }

  void setDrawerContent(Widget content) {
    _drawerContent.value = content;
  }

  void setFilterContent(Widget content) {
    _filterContent.value = content;
    }


  void closeDrawer() {
    _isRightDrawerOpen.value = false;
    _drawerContent.value = null;
    isNotification.value = false; // Reset notification state when drawer is closed
  }

  void toggleSidebar() {
    sidebarCollapsed.value = !sidebarCollapsed.value;
  }
@override
void onInit() {
  super.onInit();
  String? storedTheme = _storage.read('themeMode');
  if (storedTheme == 'dark') {
    themeMode.value = ThemeMode.dark;
  } else {
    themeMode.value = ThemeMode.light;
  }
}

  void setThemeMode(ThemeMode mode) {
    themeMode.value = mode;
    _storage.write('themeMode', mode == ThemeMode.dark ? 'dark' : 'light');
  }
}

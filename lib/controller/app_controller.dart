import 'package:admin/main.dart';
import 'package:admin/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AppController extends GetxController {
  final GetStorage _storage = GetStorage();

  
  late final Rx<ThemeMode> themeMode;
  
  
  final RxBool showFilter = false.obs;
  final Rx<Widget?> _filterContent = Rx<Widget?>(null);
  final RxBool isNotification = false.obs;
  var sidebarCollapsed = false.obs;
  final RxBool isThemeToggleOn = false.obs; 

  final RxBool _isRightDrawerOpen = false.obs;
  final Rx<Widget?> _drawerContent = Rx<Widget?>(null);

  
  AppController() {
    _loadTheme();
  }

  
  void _loadTheme() {
    String? storedTheme = _storage.read('themeMode');
    ThemeMode initialTheme = storedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;
    themeMode = initialTheme.obs;
  }

  
  bool get isRightDrawerOpen => _isRightDrawerOpen.value;
  Widget? get drawerContent => _drawerContent.value;
  Widget? get filterContent => _filterContent.value;

  
  void toggleTheme(bool darkModeEnabled) {
    themeMode.value = darkModeEnabled ? ThemeMode.dark : ThemeMode.light;
    _saveTheme();
  }

  void setThemeMode(ThemeMode mode) {
    themeMode.value = mode;
    _saveTheme();
  }

  
  void _saveTheme() {
    _storage.write('themeMode', themeMode.value == ThemeMode.dark ? 'dark' : 'light');
    
    
  }

  
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
    isNotification.value = false;
  }

  void toggleSidebar() {
    sidebarCollapsed.value = !sidebarCollapsed.value;
  }

  @override
  void onInit() {
    super.onInit();
    // appSocket = SocketService();
    
  }

  @override
  void onClose() {
    super.onClose();
    
  }
}
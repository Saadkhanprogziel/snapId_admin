import 'package:get/get.dart';

class AppController extends GetxController {
  var sidebarCollapsed = false.obs;

  void toggleSidebar() {
    sidebarCollapsed.value = !sidebarCollapsed.value;
  }
}
import 'package:admin/network/network_repository.dart';
import 'package:admin/services/local_storage_service.dart';
import 'package:admin/services/socket_service.dart';
// import 'package:admin/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:get/get.dart';
import 'package:admin/controller/app_controller.dart';
import 'package:get_storage/get_storage.dart';
import 'package:admin/views/layout/layout.dart';

final networkRepository = NetworkRepository();
final localStorage = LocalStorageService.instance;
  late SocketService appSocket;
  
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  setUrlStrategy(PathUrlStrategy());
   Get.put(AppController());
  runApp(
    ScreenUtilInit(
      designSize: Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => SnapIDDashboard(),
    ),
  );
}

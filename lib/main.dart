import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:get/get.dart';

import 'package:admin/controller/app_controller.dart';
import 'package:admin/views/layout/layout.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  setUrlStrategy(PathUrlStrategy());
  await GetStorage.init(); // Must happen before Get.put()

  Get.put(AppController());

  runApp(
    ScreenUtilInit(
      designSize: Size(375, 812), // iPhone X resolution
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => SnapIDDashboard(),
    ),
  );
}

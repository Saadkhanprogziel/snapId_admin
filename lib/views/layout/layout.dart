import 'package:admin/controller/app_controller.dart';
import 'package:admin/views/navigations/route_management.dart';
import 'package:admin/views/layout/sideMenu.dart';
import 'package:admin/views/layout/topbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SnapIDDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appController = Get.put(AppController());

    return ScreenUtilInit(
      designSize: const Size(1440, 1024),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) => Obx(() => MaterialApp.router(
            title: 'Admin Dashboard',
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light(),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              scaffoldBackgroundColor: const Color(0xFF181A20),
              cardColor: const Color(0xFF23272F),
              canvasColor: const Color(0xFF181A20),
              dialogBackgroundColor: const Color(0xFF23272F),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFF23272F),
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              textTheme: ThemeData.dark().textTheme.apply(
                    bodyColor: Colors.white,
                    displayColor: Colors.white,
                  ),
            ),
            themeMode: appController.themeMode.value,
            routerConfig: AppRouter.router,
          )),
    );
  }
}

class AdminLayout extends StatelessWidget {
  final Widget child;
  const AdminLayout({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    final drawerController = Get.find<AppController>();
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 1000;
    final isMobile = screenWidth < 600;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? Theme.of(context).scaffoldBackgroundColor : Colors.white,
      drawer: isSmallScreen ? Drawer(child: SideMenu()) : null,
      appBar: isSmallScreen
          ? AppBar(
              surfaceTintColor: Colors.transparent,
              backgroundColor: isDark
                  ? Theme.of(context).scaffoldBackgroundColor
                  : Colors.white,
              elevation: 0,
              leading: Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
            )
          : null,
      body: Stack(
        children: [
          Row(
            children: [
              if (!isSmallScreen) SideMenu(),
              Expanded(
                child: Container(
                  margin: !isSmallScreen
                      ? EdgeInsets.only(top: 40.h, right: 30.w)
                      : EdgeInsets.all(30.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.r),
                    border: Border.all(
                      color: Colors.grey,
                      width: 0.4.w,
                    ),
                  ),
                  child: Column(
                    children: [
                      TopBar(
                        onSettingsPressed: () {
                          drawerController.toggleDrawer();
                        },
                      ),
                      Expanded(child: child),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Obx(() => drawerController.isRightDrawerOpen
              ? GestureDetector(
                  onTap: drawerController.closeDrawer,
                  child: Container(
                    color: Colors.black.withOpacity(0.3),
                    width: double.infinity,
                    height: double.infinity,
                  ),
                )
              : const SizedBox.shrink()),
          Obx(() {
            double rightDrawerWidth;
            if (isMobile) {
              rightDrawerWidth = screenWidth;
            } else {
              rightDrawerWidth = drawerController.isNotification.value
                  ? screenWidth * 0.25
                  : screenWidth * 0.70;
            }

            return AnimatedPositioned(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              top: 0,
              bottom: 0,
              right: drawerController.isRightDrawerOpen ? 0 : -rightDrawerWidth,
              child: Material(
                elevation: 16,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  width: rightDrawerWidth,
                  child: Column(
                    children: [
                      Expanded(
                        child: drawerController.drawerContent ??
                            Scaffold(
                              backgroundColor: isDark
                                  ? Theme.of(context).scaffoldBackgroundColor
                                  : Colors.white,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

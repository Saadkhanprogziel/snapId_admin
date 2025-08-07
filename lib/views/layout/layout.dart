import 'package:admin/views/app_routes.dart';
import 'package:admin/views/layout/sideMenu.dart';
import 'package:admin/views/layout/topbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class SnapIDDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1440, 1024), // Adjust to your Figma base size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) => MaterialApp.router(
        title: 'Admin Dashboard',
        debugShowCheckedModeBanner: false,
        routerConfig: router,
      ),
    );
  }
}

class AdminLayout extends StatefulWidget {
  final Widget child;
  const AdminLayout({required this.child, super.key});

  @override
  State<AdminLayout> createState() => _AdminLayoutState();
}

class _AdminLayoutState extends State<AdminLayout> {
  bool _isRightDrawerOpen = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 1000;
    final rightDrawerWidth = screenWidth * 0.75;

    return Scaffold(
      backgroundColor: Colors.white,

      // Left Drawer (for small screens)
      drawer: isSmallScreen ? Drawer(child: SideMenu()) : null,

      // No appBar on large screens, but show buttons on small
      appBar: isSmallScreen
          ? AppBar(
              backgroundColor: Colors.white,
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
    // Main layout
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
                    setState(() {
                      _isRightDrawerOpen = true;
                    });
                  },
                ),
                Expanded(child: widget.child),
              ],
            ),
          ),
        ),
      ],
    ),

    // ✅ Backdrop (only visible when drawer is open)
    if (_isRightDrawerOpen)
      GestureDetector(
        onTap: () {
          setState(() {
            _isRightDrawerOpen = false;
          });
        },
        child: Container(
          color: Colors.black.withOpacity(0.3),
          width: double.infinity,
          height: double.infinity,
        ),
      ),

    // ✅ Always present, animates in/out
    AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      top: 0,
      bottom: 0,
      right: _isRightDrawerOpen ? 0 : -rightDrawerWidth,
      child: Material(
        elevation: 16,
        child: Container(
          width: rightDrawerWidth,
          color: Colors.blue[50],
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _isRightDrawerOpen = false;
                    });
                  },
                ),
              ),
              Expanded(
                child: Text("I want to pass widget from any screen I want and I can open this drawer from any screen"),
              ),
            ],
          ),
        ),
      ),
    ),
  ],
),

    );
  }
}

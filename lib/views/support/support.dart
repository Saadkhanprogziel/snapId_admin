import 'package:admin/controller/support_controller/support_controller.dart';
import 'package:admin/views/support/support_list_widget/support_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:admin/views/support/queries_line_chart.dart';
import 'package:admin/views/support/support_status_chart.dart';
import 'package:get/get.dart';

class Support extends StatelessWidget {
  const Support({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SupportController());

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          backgroundColor: _getBackgroundColor(context),
          body: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: _getPadding(constraints.maxWidth),
            child: _buildResponsiveLayout(context, constraints, controller),
          ),
        );
      },
    );
  }

  Widget _buildResponsiveLayout(BuildContext context, BoxConstraints constraints, SupportController controller) {
    final deviceType = _getDeviceType(constraints.maxWidth);
    
    switch (deviceType) {
      case DeviceType.desktop:
        return _buildDesktopLayout(context, constraints, controller);
      case DeviceType.tablet:
        return _buildTabletLayout(context, constraints, controller);
      case DeviceType.mobile:
        return _buildMobileLayout(context, constraints, controller);
    }
  }

  Widget _buildDesktopLayout(BuildContext context, BoxConstraints constraints, SupportController controller) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: QueriesLineChart(
                deviceType: DeviceType.desktop,
                width: constraints.maxWidth * 0.65,
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              flex: 2,
              child: SupportStatusChart(
                deviceType: DeviceType.desktop,
                width: constraints.maxWidth * 0.35,
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        
        Container(
          height: 800,
          width: double.infinity,
          decoration: _getContainerDecoration(context, DeviceType.desktop),
          child: SupportListWidget(
            controller: controller,
            isMobile: false,
            isTablet: false,
          ),
        ),
      ],
    );
  }

  Widget _buildTabletLayout(BuildContext context, BoxConstraints constraints, SupportController controller) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: QueriesLineChart(
                deviceType: DeviceType.tablet,
                width: constraints.maxWidth * 0.6,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 1,
              child: SupportStatusChart(
                deviceType: DeviceType.tablet,
                width: constraints.maxWidth * 0.4,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        
        Container(
          height: 650,
          width: double.infinity,
          decoration: _getContainerDecoration(context, DeviceType.tablet),
          child: SupportListWidget(
            controller: controller,
            isMobile: false,
            isTablet: true,
          ),
        ),
      ],
    );
  }

 Widget _buildMobileLayout(BuildContext context, BoxConstraints constraints, SupportController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      SizedBox(
        height: 350, // give a fixed height
        child: QueriesLineChart(
          deviceType: DeviceType.mobile,
          width: constraints.maxWidth,
        ),
      ),
      const SizedBox(height: 16),
      SizedBox(
        height: 430, // fixed height again
        child: SupportStatusChart(
          deviceType: DeviceType.mobile,
          width: constraints.maxWidth,
        ),
      ),
      const SizedBox(height: 16),
      Container(
        height: 500,
        width: double.infinity,
        decoration: _getContainerDecoration(context, DeviceType.mobile),
        child: SupportListWidget(
          controller: controller,
          isMobile: true,
          isTablet: false,
        ),
      ),
    ],
  );
}


  DeviceType _getDeviceType(double width) {
    if (width >= 1200) return DeviceType.desktop;
    if (width >= 768) return DeviceType.tablet;
    return DeviceType.mobile;
  }

  EdgeInsets _getPadding(double width) {
    if (width >= 1200) return const EdgeInsets.all(32.0);
    if (width >= 768) return const EdgeInsets.all(20.0);
    return const EdgeInsets.all(16.0);
  }

  Color _getBackgroundColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? Theme.of(context).scaffoldBackgroundColor : Colors.white;
  }

  BoxDecoration _getContainerDecoration(BuildContext context, DeviceType deviceType) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderRadius = deviceType == DeviceType.mobile ? 16.0 : 
                        deviceType == DeviceType.tablet ? 20.0 : 25.0;
    
    return BoxDecoration(
      color: isDark ? const Color(0xFF23272F) : Colors.white,
      border: Border.all(width: 0.4, color: Colors.grey),
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: deviceType == DeviceType.desktop ? [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ] : null,
    );
  }
}

enum DeviceType { mobile, tablet, desktop }

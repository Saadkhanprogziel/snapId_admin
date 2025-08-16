import 'package:admin/controller/support_controller/support_controller.dart';
import 'package:admin/utils/custom_spaces.dart';
import 'package:admin/views/support/support_list_widget/support_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
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
        // Charts section - Side by side with proper spacing
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
        
        // Support list with full height
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
        // Charts section - Side by side but more compact
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
        
        // Support list
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
      children: [
        // Charts section - Stacked vertically
        QueriesLineChart(
          deviceType: DeviceType.mobile,
          width: constraints.maxWidth,
        ),
        const SizedBox(height: 16),
        SupportStatusChart(
          deviceType: DeviceType.mobile,
          width: constraints.maxWidth,
        ),
        const SizedBox(height: 16),
        
        // Support list
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

class QueriesLineChart extends StatelessWidget {
  final DeviceType deviceType;
  final double width;
  final SupportController controller = Get.find<SupportController>();

  QueriesLineChart({
    Key? key,
    required this.deviceType,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = deviceType == DeviceType.mobile;
    final isTablet = deviceType == DeviceType.tablet;
    
    return Container(
      height: _getChartHeight(),
      width: width,
      padding: EdgeInsets.all(_getPadding()),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF23272F) : Colors.transparent,
        borderRadius: BorderRadius.circular(_getBorderRadius()),
        border: Border.all(
          width: 1,
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
        ),
       
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title & Filters
          _buildHeader(isDark, isMobile, isTablet),
          SizedBox(height: _getSpacing()),

          // Chart
          Expanded(
            child: Obx(() => LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 50,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: _getTitlesData(),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 5,
                minY: 0,
                maxY: 250,
                lineBarsData: [
                  LineChartBarData(
                    spots: controller.aiAssistantData,
                    isCurved: true,
                    gradient: LinearGradient(
                      colors: [
                        controller.chartColors['aiAssistant']!,
                        controller.chartColors['aiAssistant']!
                      ],
                    ),
                    barWidth: deviceType == DeviceType.mobile ? 2 : 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) =>
                          FlDotCirclePainter(
                        radius: deviceType == DeviceType.mobile ? 3 : 4,
                        color: controller.chartColors['aiAssistant']!,
                        strokeWidth: 2,
                        strokeColor: Colors.white,
                      ),
                    ),
                  ),
                  LineChartBarData(
                    spots: controller.manualSupportData,
                    isCurved: true,
                    gradient: LinearGradient(
                      colors: [
                        controller.chartColors['manualSupport']!,
                        controller.chartColors['manualSupport']!
                      ],
                    ),
                    barWidth: deviceType == DeviceType.mobile ? 2 : 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                  ),
                ],
              ),
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDark, bool isMobile, bool isTablet) {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitleSection(),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLegend(),
              _buildDropdown(isDark),
            ],
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildTitleSection(),
        Row(
          children: [
            if (!isTablet) _buildLegend(),
            if (!isTablet) const SizedBox(width: 20),
            _buildDropdown(isDark),
          ],
        ),
      ],
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() => Text(
          controller.queriesChartTitle.value,
          style: TextStyle(
            fontSize: _getTitleFontSize(),
            fontWeight: FontWeight.w500,
          ),
        )),
        const SizedBox(height: 4),
        Obx(() => Text(
          controller.totalQueries.value.toString(),
          style: TextStyle(
            fontSize: _getValueFontSize(),
            fontWeight: FontWeight.bold,
          ),
        )),
      ],
    );
  }

  Widget _buildLegend() {
    return Row(
      children: [
        _buildLegendItem(
          color: controller.chartColors['aiAssistant']!,
          label: controller.legendLabels['aiAssistant']!,
        ),
        SizedBox(width: deviceType == DeviceType.mobile ? 12 : 16),
        _buildLegendItem(
          color: controller.chartColors['manualSupport']!,
          label: controller.legendLabels['manualSupport']!,
        ),
      ],
    );
  }

  Widget _buildDropdown(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF23272F) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 1,
          color: isDark ? Colors.white : Colors.grey.shade300,
        ),
      ),
      child: Obx(() => DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: controller.selectedQueriesPeriod.value,
          isDense: true,
          style: TextStyle(
            fontSize: deviceType == DeviceType.mobile ? 11 : 12,
            color: isDark ? Colors.white  : Colors.grey[600],
          ),
          icon: Icon(
            Icons.keyboard_arrow_down,
            size: 16,
            color: isDark ? Colors.white  : Colors.grey[600],
          ),
          items: controller.periods.map((String period) {
            return DropdownMenuItem<String>(
              value: period,
              child: Text(period),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              controller.changeQueriesPeriod(newValue);
              controller.fetchQueriesData(newValue);
            }
          },
        ),
      )),
    );
  }

  FlTitlesData _getTitlesData() {
    return FlTitlesData(
      rightTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      topTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          interval: 1,
          getTitlesWidget: (double value, TitleMeta meta) {
            final style = TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w400,
              fontSize: deviceType == DeviceType.mobile ? 10 : 12,
            );
            if (value.toInt() >= 0 && value.toInt() < controller.monthLabels.length) {
              return Text(controller.monthLabels[value.toInt()], style: style);
            }
            return  Text('', style: style);
          },
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: 100,
          getTitlesWidget: (double value, TitleMeta meta) {
            return Text(
              value.toInt().toString(),
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w400,
                fontSize: deviceType == DeviceType.mobile ? 10 : 12,
              ),
            );
          },
          reservedSize: deviceType == DeviceType.mobile ? 35 : 42,
        ),
      ),
    );
  }

  Widget _buildLegendItem({required Color color, required String label}) {
    return Row(
      children: [
        Container(
          width: deviceType == DeviceType.mobile ? 10 : 12,
          height: deviceType == DeviceType.mobile ? 10 : 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: deviceType == DeviceType.mobile ? 10 : 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  double _getChartHeight() {
    switch (deviceType) {
      case DeviceType.desktop:
        return 500;
      case DeviceType.tablet:
        return 480;
      case DeviceType.mobile:
        return 350;
    }
  }

  double _getPadding() {
    switch (deviceType) {
      case DeviceType.desktop:
        return 32;
      case DeviceType.tablet:
        return 24;
      case DeviceType.mobile:
        return 16;
    }
  }

  double _getBorderRadius() {
    switch (deviceType) {
      case DeviceType.desktop:
        return 25;
      case DeviceType.tablet:
        return 20;
      case DeviceType.mobile:
        return 16;
    }
  }

  double _getSpacing() {
    switch (deviceType) {
      case DeviceType.desktop:
        return 32;
      case DeviceType.tablet:
        return 24;
      case DeviceType.mobile:
        return 16;
    }
  }

  double _getTitleFontSize() {
    switch (deviceType) {
      case DeviceType.desktop:
        return 16;
      case DeviceType.tablet:
        return 14;
      case DeviceType.mobile:
        return 12;
    }
  }

  double _getValueFontSize() {
    switch (deviceType) {
      case DeviceType.desktop:
        return 36;
      case DeviceType.tablet:
        return 32;
      case DeviceType.mobile:
        return 24;
    }
  }
}

class SupportStatusChart extends StatelessWidget {
  final DeviceType deviceType;
  final double width;
  final SupportController controller = Get.find<SupportController>();

  SupportStatusChart({
    Key? key,
    required this.deviceType,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      height: _getChartHeight(),
      width: width,
      padding: EdgeInsets.all(_getPadding()),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF23272F) : Colors.transparent,
        borderRadius: BorderRadius.circular(_getBorderRadius()),
        border: Border.all(
          width: 1,
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
        ),
       
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title & Filter
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Obx(() => Text(
                  controller.statusChartTitle.value,
                  style: TextStyle(
                    fontSize: _getTitleFontSize(),
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                )),
              ),
              const SizedBox(width: 12),
              _buildDropdown(isDark),
            ],
          ),
          SizedBox(height: _getSpacing()),

          // Chart content
          Expanded(
            child: _buildChartContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildChartContent() {
    if (deviceType == DeviceType.mobile) {
      return Column(
        children: [
          Expanded(flex: 3, child: _statusPie()),
          const SizedBox(height: 12),
          SizedBox(height: 60, child: _statusLegend()),
        ],
      );
    } else if (deviceType == DeviceType.tablet) {
      return Column(
        children: [
          Expanded(flex: 2, child: _statusPie()), // Reduced from flex: 3 to flex: 2
          const SizedBox(height: 16),
          Expanded(flex: 1, child: _statusLegend()), // Reduced from flex: 2 to flex: 1
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(flex: 2, child: _statusLegend()),
          const SizedBox(width: 16),
          Expanded(flex: 3, child: _statusPie()),
        ],
      );
    }
  }

  Widget _buildDropdown(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF23272F) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 1,
          color: isDark ? Colors.white : Colors.grey.shade300,
        ),
      ),
      child: Obx(() => DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: controller.selectedStatusPeriod.value,
          isDense: true,
          style: TextStyle(
            fontSize: deviceType == DeviceType.mobile ? 11 : 12,
            color: isDark ? Colors.white  : Colors.grey[600],
          ),
          icon: Icon(
            Icons.keyboard_arrow_down,
            size: 16,
            color: isDark ? Colors.white  : Colors.grey[600],
          ),
          items: controller.periods.map((String period) {
            return DropdownMenuItem<String>(
              value: period,
              child: Text(period),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              controller.changeStatusPeriod(newValue);
              controller.fetchStatusData(newValue);
            }
          },
        ),
      )),
    );
  }

  Widget _statusLegend() {
    return Obx(() => deviceType == DeviceType.mobile 
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCompactStatusItem(
                  controller.statusLabels['open']!,
                  controller.openCount.value,
                  controller.statusColors['open']!,
                ),
                _buildCompactStatusItem(
                  controller.statusLabels['pending']!,
                  controller.pendingCount.value,
                  controller.statusColors['pending']!,
                ),
                _buildCompactStatusItem(
                  controller.statusLabels['closed']!,
                  controller.closedCount.value,
                  controller.statusColors['closed']!,
                ),
              ],
            ),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStatusItem(
                controller.statusLabels['open']!,
                controller.openCount.value,
                controller.statusColors['open']!,
              ),
              SizedBox(height: _getItemSpacing()),
              _buildStatusItem(
                controller.statusLabels['pending']!,
                controller.pendingCount.value,
                controller.statusColors['pending']!,
              ),
              SizedBox(height: _getItemSpacing()),
              _buildStatusItem(
                controller.statusLabels['closed']!,
                controller.closedCount.value,
                controller.statusColors['closed']!,
              ),
            ],
          )
    );
  }

  Widget _statusPie() {
    final centerRadius = deviceType == DeviceType.mobile ? 35.0 : 
                        deviceType == DeviceType.tablet ? 45.0 : 60.0; // Reduced tablet from 60.0 to 45.0
    final totalFontSize = deviceType == DeviceType.mobile ? 16.0 : 
                          deviceType == DeviceType.tablet ? 18.0 : 24.0; // Reduced tablet from 24.0 to 18.0
    final labelFontSize = deviceType == DeviceType.mobile ? 9.0 : 
                          deviceType == DeviceType.tablet ? 10.0 : 12.0; // Reduced tablet from 12.0 to 10.0
    
    return Stack(
      children: [
        Obx(() => PieChart(
          PieChartData(
            sectionsSpace: 2,
            centerSpaceRadius: centerRadius,
            sections: controller.getPieChartSections(),
            startDegreeOffset: -90,
          ),
        )),
        Positioned.fill(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(() => Text(
                controller.computedTotal.toString(),
                style: TextStyle(
                  fontSize: totalFontSize,
                  fontWeight: FontWeight.bold,
                ),
              )),
              Text(
                'Total Status',
                style: TextStyle(
                  fontSize: labelFontSize,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusItem(String label, int value, Color color) {
    return Container(
      padding: EdgeInsets.all(_getItemPadding()),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: deviceType == DeviceType.tablet ? 8 : 10, // Reduced tablet from 10 to 8
            height: deviceType == DeviceType.tablet ? 8 : 10, // Reduced tablet from 10 to 8
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: _getItemFontSize(),
                // color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: _getItemFontSize(),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactStatusItem(String label, int value, Color color) {
    return Flexible(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value.toString(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 8,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  double _getChartHeight() {
    switch (deviceType) {
      case DeviceType.desktop:
        return 500;
      case DeviceType.tablet:
        return 480;
      case DeviceType.mobile:
        return 350;
    }
  }

  double _getPadding() {
    switch (deviceType) {
      case DeviceType.desktop:
        return 32;
      case DeviceType.tablet:
        return 24;
      case DeviceType.mobile:
        return 16;
    }
  }

  double _getBorderRadius() {
    switch (deviceType) {
      case DeviceType.desktop:
        return 25;
      case DeviceType.tablet:
        return 20;
      case DeviceType.mobile:
        return 16;
    }
  }

  double _getSpacing() {
    switch (deviceType) {
      case DeviceType.desktop:
        return 24;
      case DeviceType.tablet:
        return 20;
      case DeviceType.mobile:
        return 16;
    }
  }

  double _getItemSpacing() {
    switch (deviceType) {
      case DeviceType.desktop:
        return 16;
      case DeviceType.tablet:
        return 10; // Reduced from 12 to 10
      case DeviceType.mobile:
        return 8;
    }
  }

  double _getItemPadding() {
    switch (deviceType) {
      case DeviceType.desktop:
        return 12;
      case DeviceType.tablet:
        return 8; // Reduced from 10 to 8
      case DeviceType.mobile:
        return 8;
    }
  }

  double _getTitleFontSize() {
    switch (deviceType) {
      case DeviceType.desktop:
        return 18;
      case DeviceType.tablet:
        return 14; // Reduced from 16 to 14
      case DeviceType.mobile:
        return 14;
    }
  }

  double _getItemFontSize() {
    switch (deviceType) {
      case DeviceType.desktop:
        return 14;
      case DeviceType.tablet:
        return 11; // Reduced from 12 to 11
      case DeviceType.mobile:
        return 11;
    }
  }
}
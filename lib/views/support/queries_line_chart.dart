import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:admin/controller/support_controller/support_controller.dart';
import 'support.dart';

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

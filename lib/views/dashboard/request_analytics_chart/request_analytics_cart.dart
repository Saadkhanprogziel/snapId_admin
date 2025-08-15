import 'package:admin/constants/colors.dart';
import 'package:admin/controller/dashboard_controller/dashboard_controller.dart';
import 'package:admin/models/plateform_request_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';


class RequestAnalyticsChart extends StatelessWidget {
  final DashboardController controller;

  const RequestAnalyticsChart({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Obx(() {
      final data = controller.currentData;
      return Container(
        decoration: BoxDecoration(
          // color: isDark ? Color(0xFF23272F) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          // border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey, width: 0.8),
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(isDark),
            const SizedBox(height: 16),
            Expanded(child: _buildChart(data, isDark)),
            const SizedBox(height: 16),
            _buildLegend(isDark),
            const SizedBox(height: 16),
          ],
        ),
      );
    });
  }

  Widget _buildHeader(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Total Request",
              style: TextStyle(fontSize: 18, color: isDark ? Colors.white : Colors.grey),
            ),
            Text(
              "11000",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: isDark ? Colors.white : Colors.black),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildToggleButton("Week", controller.isWeeklyView.value, () => controller.isWeeklyView.value = true),
              _buildToggleButton("Month", !controller.isWeeklyView.value, () => controller.isWeeklyView.value = false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildToggleButton(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[600],
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildLegend(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem('Mobile', const Color.fromARGB(255, 151, 135, 255), isDark),
        const SizedBox(width: 24),
        _buildLegendItem('Web', const Color.fromARGB(255, 200, 147, 253), isDark),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color, bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(color: isDark ? Colors.white70 : Colors.grey, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildChart(List<PlatformRequestData> data, bool isDark) {
    final maxY = _getMaxValue(data) * 1.05;
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY,
       barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    // tooltipBgColor: Colors.grey.shade800,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '\$${rod.toY.round()}',
                        const TextStyle(color: Colors.white, fontSize: 12),
                      );
                    },
                  ),
                ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                if (value.toInt() < data.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      data[value.toInt()].label,
                      style: TextStyle(color: isDark ? Colors.white70 : Colors.grey, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 45,
              getTitlesWidget: (value, meta) {
                return Text(
                  _formatYAxisValue(value),
                  style: TextStyle(color: isDark ? Colors.white70 : Colors.grey, fontSize: 10, fontWeight: FontWeight.bold),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
        ),
        barGroups: data.asMap().entries.map((entry) {
          return BarChartGroupData(
            x: entry.key,
            barRods: [
              BarChartRodData(
                toY: entry.value.mobileCount.toDouble(),
                color: const Color.fromARGB(255, 151, 135, 255),
                width: 12,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
              ),
              BarChartRodData(
                toY: entry.value.webCount.toDouble(),
                color: const Color.fromARGB(255, 200, 147, 253),
                width: 12,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
              ),
            ],
            barsSpace: 4,
          );
        }).toList(),
        groupsSpace: 16,
        gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.grey.withOpacity(0.2),
            strokeWidth: 1,
            dashArray: [5, 5],
          ),
        ),
      ),
    );
  }

  double _getMaxValue(List<PlatformRequestData> data) {
    double maxMobile = data.map((e) => e.mobileCount).reduce((a, b) => a > b ? a : b).toDouble();
    double maxWeb = data.map((e) => e.webCount).reduce((a, b) => a > b ? a : b).toDouble();
    return maxMobile > maxWeb ? maxMobile : maxWeb;
  }

  String _formatYAxisValue(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(value % 1000000 == 0 ? 0 : 1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(value % 1000 == 0 ? 0 : 1)}k';
    } else {
      return value.toInt().toString();
    }
  }
}

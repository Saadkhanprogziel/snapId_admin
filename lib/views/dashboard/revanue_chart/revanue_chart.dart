import 'package:admin/controller/dashboard_controller/dashboard_controller.dart';
import 'package:admin/models/revanue_data.dart';
import 'package:admin/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';

class RevanueChart extends StatelessWidget {
  final DashboardController controller;

  const RevanueChart({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Obx(() {
      final data = controller.revanueData;
      if (data.length < 2) {
        return Center(child: Text("Not enough data to render chart.", style: TextStyle(color: isDark ? Colors.white : Colors.black)));
      }
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
            _buildHeader( isDark),
            const SizedBox(height: 16),
            Expanded(child: _buildChart(data, isDark)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "20,000",
                  style: CustomTextTheme.regular20.copyWith(color: isDark ? Colors.white : Colors.black),
                ),
              ],
            )
          ],
        ),
      );
    });
  }

  Widget _buildHeader(bool  isDark) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Builder(
        builder: (context) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          return Text(
            "Total Revenue",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: isDark ? Colors.white : Colors.grey,
            ),
          );
        },
      ),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? Colors.transparent : Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: DropdownButtonHideUnderline(
          child: Obx(() {
            return DropdownButton<String>(
              value: controller.selectedRevanueFilter.value,
              isDense: true, // Minimizes height
              style:  TextStyle(fontSize: 14, color: isDark ? Colors.white : Colors.grey[800] ), // smaller text
              menuMaxHeight: 250, // Optional: controls dropdown list height
              items: const [
                DropdownMenuItem(
                    value: 'day',
                    child: Text('Day', style: TextStyle(fontSize: 14))),
                DropdownMenuItem(
                    value: 'week',
                    child: Text('Week', style: TextStyle(fontSize: 14))),
                DropdownMenuItem(
                    value: 'month',
                    child: Text('Month', style: TextStyle(fontSize: 14))),
                DropdownMenuItem(
                    value: '3month',
                    child: Text('3 Month', style: TextStyle(fontSize: 14))),
                DropdownMenuItem(
                    value: 'six month',
                    child: Text('6 Month', style: TextStyle(fontSize: 14))),
                DropdownMenuItem(
                    value: 'year',
                    child: Text('Year', style: TextStyle(fontSize: 14))),
              ],
              onChanged: (value) {
                if (value != null) {
                  controller.updateFilter(value);
                }
              },
            );
          }),
        ),
      ),
    ],
  );
}


  Widget _buildChart(List<RevanueData> data, bool isDark) {
    double maxY = _getMaxValue(data) * 1.2;
    return LineChart(
      LineChartData(
        minX: 0,
        maxX: (data.length - 1).toDouble(),
        minY: 0,
        maxY: maxY,
        lineBarsData: [
          LineChartBarData(
            spots: data.asMap().entries.map((entry) {
              return FlSpot(
                  entry.key.toDouble(), entry.value.amount.toDouble());
            }).toList(),
            isCurved: true,
            color: const Color.fromARGB(255, 151, 135, 255),
            barWidth: 1,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(
                      100, 151, 135, 255), // Purple at top (semi-transparent)
                  isDark ? Color(0xFF23272F) : Colors.white, // dark bg
                ],
              ),
            ),
          ),
        ],
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1, // Ensure one label per data point
              getTitlesWidget: (value, meta) {
                final index = value.round();
                if (index >= 0 && index < data.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      data[index].label,
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.grey,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
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
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.grey,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          drawVerticalLine: true,
          verticalInterval: 1,
          horizontalInterval: maxY / 5,
          getDrawingHorizontalLine: (value) => FlLine(
            color: isDark ? Colors.white12 : Colors.grey,
            strokeWidth: .5, // No dashArray = solid line
          ),
          getDrawingVerticalLine: (value) => FlLine(
            color: isDark ? Colors.white12 : Colors.grey,
            strokeWidth: .5, // No dashArray = solid line
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: isDark ? Colors.white24 : Colors.grey, width: .3),
        ),
      ),
    );
  }

  double _getMaxValue(List<RevanueData> data) {
    return data.map((e) => e.amount).reduce((a, b) => a > b ? a : b).toDouble();
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

import 'package:admin/controller/dashboard_controller/dashboard_controller.dart';
import 'package:admin/models/dashboard/dashboard_subscribers_chart_Model.dart';
import 'package:admin/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';

class SubscriberChart extends StatelessWidget {
  final DashboardController controller;

  SubscriberChart({super.key, required this.controller});
  final Color package1Color = Color.fromRGBO(74, 58, 255, 1); // Solid blue
  final Color package2Color = Color.fromRGBO(200, 147, 253, 1); // Light purple
  final Color package3Color = Color.fromRGBO(198, 210, 253, 1); // Soft blue

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Obx(() {
      final data = controller.subscriberChartData.value?.plansWithNames ?? [];

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${controller.subscriberChartData.value?.planCount}",
                  style: CustomTextTheme.regular20
                      .copyWith(color: isDark ? Colors.white : Colors.black),
                ),
                _buildLegend(isDark)
              ],
            )
          ],
        ),
      );
    });
  }

  Widget _buildHeader(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Total Subscribers",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: isDark ? Colors.white : Colors.grey,
          ),
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
                value: controller.selectedSubscriberFilter.value,
                isDense: true, // reduces height
                style: TextStyle(
                    fontSize: 14,
                    color: isDark
                        ? Colors.white
                        : Colors.grey[800]), // smaller text
                menuMaxHeight: 250, // optional: limits dropdown menu height
                items: const [
                  DropdownMenuItem(
                      value: 'today',
                      child: Text('Today', style: TextStyle(fontSize: 14))),
                  DropdownMenuItem(
                      value: 'this_week',
                      child: Text('Week', style: TextStyle(fontSize: 14))),
                  DropdownMenuItem(
                      value: 'this_month',
                      child: Text('Month', style: TextStyle(fontSize: 14))),
                  DropdownMenuItem(
                      value: 'last_6_months',
                      child: Text('6 Month', style: TextStyle(fontSize: 14))),
                  DropdownMenuItem(
                      value: 'last_month',
                      child:
                          Text('Last Month', style: TextStyle(fontSize: 14))),
                  DropdownMenuItem(
                      value: 'this_year',
                      child: Text('Year', style: TextStyle(fontSize: 14))),
                ],
                onChanged: (value) {
                  if (value != null) {
                    controller.updateSubscriberFilter(value);
                  }
                },
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildLegend(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem('Single Photo', package1Color, isDark),
        const SizedBox(width: 20),
        _buildLegendItem('Standard Pack', package2Color, isDark),
        const SizedBox(width: 20),
        _buildLegendItem('Family Pack', package3Color, isDark),
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
          style: TextStyle(
              color: isDark ? Colors.white70 : Colors.grey,
              fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildChart(List<SubscriptionItem> data, bool isDark) {
    double maxY = _getMaxValue(data) * 1.2;
    return LineChart(
      LineChartData(
        minX: 0,
        maxX: (data.length - 1).toDouble(),
        minY: 0,
        maxY: maxY,
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipPadding: const EdgeInsets.all(8),
            tooltipMargin: 8,
            fitInsideHorizontally: true,
            fitInsideVertically: true,
            getTooltipItems: (List<LineBarSpot> touchedSpots) {
              return touchedSpots.map((spot) {
                String packageLabel;
                if (spot.barIndex == 0) {
                  packageLabel = 'Single Photo';
                } else if (spot.barIndex == 1) {
                  packageLabel = 'Standard Pack';
                } else {
                  packageLabel = 'Family Pack';
                }
                return LineTooltipItem(
                  '$packageLabel\n${spot.y.toInt()}',
                  TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontSize: 12),
                );
              }).toList();
            },
          ),
        ),
        lineBarsData: [
          // Single Photo line
          LineChartBarData(
            spots: data.asMap().entries.map((entry) {
              return FlSpot(entry.key.toDouble(),
                  (entry.value.singlePhoto ?? 0).toDouble());
            }).toList(),
            isCurved: true,
            color: package1Color,
            barWidth: 2,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
          // Standard Pack line
          LineChartBarData(
            spots: data.asMap().entries.map((entry) {
              return FlSpot(entry.key.toDouble(),
                  (entry.value.standardPack ?? 0).toDouble());
            }).toList(),
            isCurved: true,
            color: package2Color,
            barWidth: 2,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
          // Family Pack line
          LineChartBarData(
            spots: data.asMap().entries.map((entry) {
              return FlSpot(entry.key.toDouble(),
                  (entry.value.familyPack ?? 0).toDouble());
            }).toList(),
            isCurved: true,
            color: package3Color,
            barWidth: 2,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        ],
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
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
          horizontalInterval: (maxY > 0 ? maxY / 5 : 1), // ✅ safe fallback
          getDrawingHorizontalLine: (value) => FlLine(
            color: isDark ? Colors.white12 : Colors.grey,
            strokeWidth: .5,
          ),
          getDrawingVerticalLine: (value) => FlLine(
            color: isDark ? Colors.white12 : Colors.grey,
            strokeWidth: .5,
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
              color: isDark ? Colors.white24 : Colors.grey, width: .3),
        ),
      ),
    );
  }

  double _getMaxValue(List<SubscriptionItem> data) {
    double max = 0;
    for (var d in data) {
      final singlePhoto = (d.singlePhoto ?? 0).toDouble();
      final standardPack = (d.standardPack ?? 0).toDouble();
      final familyPack = (d.familyPack ?? 0).toDouble();

      max = [singlePhoto, standardPack, familyPack, max]
          .reduce((a, b) => a > b ? a : b);
    }
    return max;
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

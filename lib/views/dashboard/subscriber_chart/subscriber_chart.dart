import 'package:admin/controller/dashboard_controller/dashboard_controller.dart';
import 'package:admin/models/subscriber_data.dart';
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
    return Obx(() {
      final data = controller.subscriberData;
      if (data.length < 2) {
        return const Center(child: Text("Not enough data to render chart."));
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          Expanded(child: _buildChart(data)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "20,000",
                style: CustomTextTheme.regular20,
              ),
              _buildLegend()
            ],
          )
        ],
      );
    });
  }

  Widget _buildHeader() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      const Text(
        "Total Subscribers",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          color: Colors.grey,
        ),
      ),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: DropdownButtonHideUnderline(
          child: Obx(() {
            return DropdownButton<String>(
              value: controller.selectedSubscriberFilter.value,
              isDense: true, // reduces height
              style: const TextStyle(fontSize: 14), // smaller text
              menuMaxHeight: 250, // optional: limits dropdown menu height
              items: const [
                DropdownMenuItem(
                  value: 'day',
                  child: Text('Day', style: TextStyle(fontSize: 14)),
                ),
                DropdownMenuItem(
                  value: 'week',
                  child: Text('Week', style: TextStyle(fontSize: 14)),
                ),
                DropdownMenuItem(
                  value: 'month',
                  child: Text('Month', style: TextStyle(fontSize: 14)),
                ),
                DropdownMenuItem(
                  value: '3month',
                  child: Text('3 Month', style: TextStyle(fontSize: 14)),
                ),
                DropdownMenuItem(
                  value: 'six month',
                  child: Text('6 Month', style: TextStyle(fontSize: 14)),
                ),
                DropdownMenuItem(
                  value: 'year',
                  child: Text('Year', style: TextStyle(fontSize: 14)),
                ),
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


  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem('Package 1', package1Color),
        const SizedBox(width: 20),
        _buildLegendItem('Package 2', package2Color),
        const SizedBox(width: 20),
        _buildLegendItem('Package 3', package3Color),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
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
          style:
              const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
Widget _buildChart(List<SubscriberData> data) {
  double maxY = _getMaxValue(data) * 1.2;

  return LineChart(
    LineChartData(
      minX: 0,
      maxX: (data.length - 1).toDouble(),
      minY: 0,
      maxY: maxY,

      // ✅ Correctly structured LineTouchData with updated API
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipPadding: const EdgeInsets.all(8),
          tooltipMargin: 8,
          fitInsideHorizontally: true,
          fitInsideVertically: true,

          // ✅ Custom text inside tooltip
          getTooltipItems: (List<LineBarSpot> touchedSpots) {
            return touchedSpots.map((spot) {
              String packageLabel;
              if (spot.barIndex == 0) {
                packageLabel = 'Package 1';
              } else if (spot.barIndex == 1) {
                packageLabel = 'Package 2';
              } else {
                packageLabel = 'Package 3';
              }

              return LineTooltipItem(
                '$packageLabel\nValue: ${spot.y.toStringAsFixed(2)}',
                const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              );
            }).toList();
          },
        ),
      ),

      lineBarsData: [
        _buildLine(
            data, (e) => e.package1.toDouble(), package1Color, 'Package 1'),
        _buildLine(
            data, (e) => e.package2.toDouble(), package2Color, 'Package 2'),
        _buildLine(
            data, (e) => e.package3.toDouble(), package3Color, 'Package 3'),
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
                    style: const TextStyle(
                      color: Colors.grey,
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
                style: const TextStyle(
                  color: Colors.grey,
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
          color: Colors.grey,
          strokeWidth: .5,
        ),
        getDrawingVerticalLine: (value) => FlLine(
          color: Colors.grey,
          strokeWidth: .5,
        ),
      ),

      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
      ),
    ),
  );
}

  LineChartBarData _buildLine(
    List<SubscriberData> data,
    double Function(SubscriberData) getY,
    Color color,
    String label,
  ) {
    return LineChartBarData(
      spots: data.asMap().entries.map((entry) {
        return FlSpot(entry.key.toDouble(), getY(entry.value));
      }).toList(),
      isCurved: true,
      color: color,
      barWidth: 2,
      dotData: FlDotData(show: false),
      dashArray: label == 'Package 1' ? null : [5, 5],
      // Optional below area fill:
      // belowBarData: BarAreaData(
      //   show: true,
      //   color: color.withOpacity(0.2),
      // ),
    );
  }

  double _getMaxValue(List<SubscriberData> data) {
    return data
        .map((e) => [e.package1, e.package2, e.package3]
            .reduce((a, b) => a > b ? a : b))
        .reduce((a, b) => a > b ? a : b)
        .toDouble();
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

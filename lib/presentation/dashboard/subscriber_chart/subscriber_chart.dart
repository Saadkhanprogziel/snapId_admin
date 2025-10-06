
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
  final Color package4Color = Color.fromRGBO(255, 159, 64, 1); // Orange for Guest Purchase

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Obx(() {
      final data = controller.subscriberChartData.value?.plansWithNames ?? [];

      // Debug: Print data to check values
      print('Chart Data Length: ${data.length}');
      for (var item in data) {
        print('Label: ${item.label}, Single: ${item.singlePhoto}, Standard: ${item.standardPack}, Family: ${item.familyPack}, Guest: ${item.guestPurchase}');
      }

      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
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
                  "${controller.subscriberChartData.value?.planCount ?? 0}",
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
                isDense: true,
                style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white : Colors.grey[800]),
                menuMaxHeight: 250,
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
                      child: Text('Last Month', style: TextStyle(fontSize: 14))),
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
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        _buildLegendItem('Single Photo', package1Color, isDark),
        _buildLegendItem('Standard Pack', package2Color, isDark),
        _buildLegendItem('Family Pack', package3Color, isDark),
        _buildLegendItem('Guest Purchase', package4Color, isDark),
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
              fontSize: 12,
              fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildChart(List<SubscriptionItem> data, bool isDark) {
    if (data.isEmpty) {
      return Center(
        child: Text(
          'No data available',
          style: TextStyle(
            color: isDark ? Colors.white70 : Colors.grey,
            fontSize: 14,
          ),
        ),
      );
    }

    double maxY = _getMaxValue(data);
    if (maxY == 0) maxY = 10;
    maxY = maxY * 1.2;

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
                Color color;
                if (spot.barIndex == 0) {
                  packageLabel = 'Single Photo';
                  color = package1Color;
                } else if (spot.barIndex == 1) {
                  packageLabel = 'Standard Pack';
                  color = package2Color;
                } else if (spot.barIndex == 2) {
                  packageLabel = 'Family Pack';
                  color = package3Color;
                } else {
                  packageLabel = 'Guest Purchase';
                  color = package4Color;
                }
                return LineTooltipItem(
                  '$packageLabel\n${spot.y.toInt()}',
                  TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: '',
                      style: TextStyle(color: color),
                    ),
                  ],
                );
              }).toList();
            },
          ),
        ),
        lineBarsData: _buildLineBars(data),
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
          horizontalInterval: maxY > 0 ? maxY / 5 : 1,
          getDrawingHorizontalLine: (value) => FlLine(
            color: isDark ? Colors.white12 : Colors.grey.shade300,
            strokeWidth: .5,
          ),
          getDrawingVerticalLine: (value) => FlLine(
            color: isDark ? Colors.white12 : Colors.grey.shade300,
            strokeWidth: .5,
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
              color: isDark ? Colors.white24 : Colors.grey.shade400, width: .3),
        ),
      ),
    );
  }

  List<LineChartBarData> _buildLineBars(List<SubscriptionItem> data) {
    List<LineChartBarData> lines = [];

    // Single Photo line
    final singlePhotoSpots = data.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(),
          (entry.value.singlePhoto ?? 0).toDouble());
    }).toList();
    if (singlePhotoSpots.any((spot) => spot.y > 0)) {
      lines.add(LineChartBarData(
        spots: singlePhotoSpots,
        isCurved: true,
        color: package1Color,
        barWidth: 3,
        dotData: FlDotData(show: true, getDotPainter: (spot, percent, barData, index) {
          return FlDotCirclePainter(
            radius: 4,
            color: package1Color,
            strokeWidth: 2,
            strokeColor: Colors.white,
          );
        }),
        belowBarData: BarAreaData(show: false),
      ));
    }

    // Standard Pack line
    final standardPackSpots = data.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(),
          (entry.value.standardPack ?? 0).toDouble());
    }).toList();
    if (standardPackSpots.any((spot) => spot.y > 0)) {
      lines.add(LineChartBarData(
        spots: standardPackSpots,
        isCurved: true,
        color: package2Color,
        barWidth: 3,
        dotData: FlDotData(show: true, getDotPainter: (spot, percent, barData, index) {
          return FlDotCirclePainter(
            radius: 4,
            color: package2Color,
            strokeWidth: 2,
            strokeColor: Colors.white,
          );
        }),
        belowBarData: BarAreaData(show: false),
      ));
    }

    // Family Pack line
    final familyPackSpots = data.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(),
          (entry.value.familyPack ?? 0).toDouble());
    }).toList();
    if (familyPackSpots.any((spot) => spot.y > 0)) {
      lines.add(LineChartBarData(
        spots: familyPackSpots,
        isCurved: true,
        color: package3Color,
        barWidth: 3,
        dotData: FlDotData(show: true, getDotPainter: (spot, percent, barData, index) {
          return FlDotCirclePainter(
            radius: 4,
            color: package3Color,
            strokeWidth: 2,
            strokeColor: Colors.white,
          );
        }),
        belowBarData: BarAreaData(show: false),
      ));
    }

    // Guest Purchase line
    final guestPurchaseSpots = data.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(),
          (entry.value.guestPurchase ?? 0).toDouble());
    }).toList();
    if (guestPurchaseSpots.any((spot) => spot.y > 0)) {
      lines.add(LineChartBarData(
        spots: guestPurchaseSpots,
        isCurved: true,
        color: package4Color,
        barWidth: 3,
        dotData: FlDotData(show: true, getDotPainter: (spot, percent, barData, index) {
          return FlDotCirclePainter(
            radius: 4,
            color: package4Color,
            strokeWidth: 2,
            strokeColor: Colors.white,
          );
        }),
        belowBarData: BarAreaData(show: false),
      ));
    }

    return lines;
  }

  double _getMaxValue(List<SubscriptionItem> data) {
    if (data.isEmpty) return 0;
    
    double max = 0;
    for (var d in data) {
      final singlePhoto = (d.singlePhoto ?? 0).toDouble();
      final standardPack = (d.standardPack ?? 0).toDouble();
      final familyPack = (d.familyPack ?? 0).toDouble();
      final guestPurchase = (d.guestPurchase ?? 0).toDouble();

      max = [singlePhoto, standardPack, familyPack, guestPurchase, max]
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

// ============================================================================
// SUBSCRIPTION CHART WIDGET
// ============================================================================
import 'package:admin/controller/orders_management_controller/order_management.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubscriptionsChartWidget extends StatelessWidget {
  final OrderManagementController controller;
  final bool isMobile;
  final bool isTablet;

  const SubscriptionsChartWidget({
    super.key,
    required this.controller,
    required this.isMobile,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF23272F) : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Subscriptions',
                    style: TextStyle(
                      fontSize: isMobile ? 14 : 16,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Obx(() {
                    final currentData = controller.getCurrentSubscriptionData();
                    int totalSubscriptions = 0;
                    for (var item in currentData) {
                      totalSubscriptions += ((item['photo1'] ?? 0) + 
                                          (item['photo2'] ?? 0) + 
                                          (item['photo3'] ?? 0)) as int;
                    }

                    return Text(
                      _formatNumber(totalSubscriptions),
                      style: TextStyle(
                        fontSize: isMobile ? 24 : 28,
                        fontWeight: FontWeight.bold,
                        // color: Colors.black87,
                      ),
                    );
                  }),
                ],
              ),
              _buildDropdownButton(controller, isDark),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: isMobile ? 200 : isTablet ? 250 : 300,
            child: Obx(() {
              final barGroups = controller.getSubscriptionBarGroups();
              final maxValue = _getMaxYValue(barGroups);
              final dataLength = controller.getCurrentSubscriptionData().length;

              return BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxValue,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${rod.toY.round()}',
                          const TextStyle(color: Colors.white, fontSize: 12),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 32,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < dataLength) {
                            final label = controller.getLabel(index, controller.selectedSubscriptionRange.value, false);
                            if (label.isNotEmpty) {
                              return Text(
                                label,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                ),
                              );
                            }
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          final interval = _getYAxisInterval(maxValue);
                          if (value % interval == 0) {
                            return Text(
                              '${value.toInt()}',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 10,
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: barGroups,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: _getYAxisInterval(maxValue),
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.shade200,
                        strokeWidth: 1,
                      );
                    },
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          _buildChartLegend([
            {'label': 'Photo 1', 'color': const Color.fromARGB(255, 151, 135, 255)},
            {'label': 'Photo 2', 'color': const Color.fromARGB(255, 200, 147, 253)},
            {'label': 'Photo 3', 'color': const Color.fromARGB(255, 198, 210, 253)},
          ]),
        ],
      ),
    );
  }

  double _getMaxYValue(List<BarChartGroupData> barGroups) {
    if (barGroups.isEmpty) return 100;
    
    double maxValue = 0;
    for (var group in barGroups) {
      for (var rod in group.barRods) {
        if (rod.toY > maxValue) maxValue = rod.toY;
      }
    }
    return (maxValue * 1.2).ceilToDouble();
  }

  double _getYAxisInterval(double maxValue) {
    if (maxValue >= 2000) return 500;
    if (maxValue >= 1000) return 200;
    if (maxValue >= 500) return 100;
    if (maxValue >= 100) return 50;
    return 20;
  }

  String _formatNumber(int value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    } else {
      return value.toString();
    }
  }

  Widget _buildChartLegend(List<Map<String, dynamic>> legendItems) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: legendItems.map((item) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: item['color'],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              item['label'],
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildDropdownButton(OrderManagementController controller, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        // color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: Obx(() {
          final value = controller.selectedSubscriptionRange.value;

          return DropdownButton<DataRange>(
            value: value,
            isDense: true,
            style:  TextStyle(fontSize: 14,color: isDark ? Colors.white : Colors.grey),
            menuMaxHeight: 250,
            items: const [
              DropdownMenuItem(
                value: DataRange.weekly,
                child: Text('Week', style: TextStyle(fontSize: 14)),
              ),
              DropdownMenuItem(
                value: DataRange.monthly,
                child: Text('Month', style: TextStyle(fontSize: 14)),
              ),
              // DropdownMenuItem(
              //   value: DataRange.threeMonths,
              //   child: Text('3 Months', style: TextStyle(fontSize: 14)),
              // ),
            ],
            onChanged: (newValue) {
              if (newValue != null) {
                controller.updateSubscriptionRange(newValue);
              }
            },
          );
        }),
      ),
    );
  }
}
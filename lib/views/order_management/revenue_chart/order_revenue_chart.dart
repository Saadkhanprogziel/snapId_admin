
import 'package:admin/controller/orders_management_controller/order_management.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RevenueChartWidget extends StatelessWidget {
  final OrderManagementController controller;
  final bool isMobile;
  final bool isTablet;

  const RevenueChartWidget({
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
                    'Total Summary of Revenue',
                    style: TextStyle(
                      fontSize: isMobile ? 14 : 16,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Obx(() {
                    final currentData = controller.getCurrentRevenueData();
                    double totalRevenue = 0;
                    for (var item in currentData) {
                      totalRevenue += (item['all'] ?? 0).toDouble();
                    }

                    return Text(
                      '\$${_formatCurrency(totalRevenue)}',
                      style: TextStyle(
                        fontSize: isMobile ? 24 : 28,
                        fontWeight: FontWeight.bold,
                        // color: Colors.black87,
                      ),
                    );
                  }),
                ],
              ),
              _buildDropdownButton(controller, true, isDark),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: isMobile
                ? 200
                : isTablet
                    ? 250
                    : 300,
            child: Obx(() {
              final barGroups = controller.getRevenueBarGroups();
              final maxValue = _getMaxYValue(barGroups);
              final dataLength = controller.getCurrentRevenueData().length;

              return BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxValue,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final labels = ['Photo 1', 'Photo 2', 'Photo 3'];
                        final label = rodIndex < labels.length
                            ? labels[rodIndex]
                            : 'Unknown';
                        return BarTooltipItem(
                          '$label\n\$${_formatCurrency(rod.toY)}',
                          const TextStyle(color: Colors.white, fontSize: 12),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 32,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < dataLength) {
                            final label = controller.getLabel(index,
                                controller.selectedRevenueRange.value, true);
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
                        reservedSize: 50,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            _formatYAxisLabel(value),
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 10,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: barGroups,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: _getGridInterval(maxValue),
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
            {
              'label': 'Photo 1',
              'color': const Color.fromARGB(255, 151, 135, 255)
            },
            {
              'label': 'Photo 2',
              'color': const Color.fromARGB(255, 200, 147, 253)
            },
            {
              'label': 'Photo 3',
              'color': const Color.fromARGB(255, 198, 210, 253)
            },
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

  String _formatCurrency(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    } else {
      return value.toStringAsFixed(0);
    }
  }

  String _formatYAxisLabel(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toInt()}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toInt()}K';
    } else {
      return '${value.toInt()}';
    }
  }

  double _getGridInterval(double maxValue) {
    if (maxValue >= 100000) return 20000;
    if (maxValue >= 50000) return 10000;
    if (maxValue >= 10000) return 5000;
    return 1000;
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

  Widget _buildDropdownButton(
      OrderManagementController controller, bool isRevenue,bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        // color: Colors.white,
        border: Border.all(width: 0.5,color: Colors.grey.shade600),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: Obx(() {
          final value = isRevenue
              ? controller.selectedRevenueRange.value
              : controller.selectedSubscriptionRange.value;

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
                if (isRevenue) {
                  controller.updateRevenueRange(newValue);
                } else {
                  controller.updateSubscriptionRange(newValue);
                }
              }
            },
          );
        }),
      ),
    );
  }
}

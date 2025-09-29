import 'package:admin/controller/orders_management_controller/order_management_controller.dart';
import 'package:admin/models/orders/revenue_summary.dart';
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
        color: isDark ? const Color(0xFF23272F) : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header + Total Revenue
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
                    final SummaryRevenue? summary =
                        controller.summaryRevenue.value;

                    if (summary == null) {
                      return const Text(
                        '\$0.00',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      );
                    }

                    return Text(
                      '\$${_formatCurrency(summary.totalRevenue)}',
                      style: TextStyle(
                        fontSize: isMobile ? 24 : 28,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }),
                ],
              ),
              _buildDropdownButton(controller, true, isDark),
            ],
          ),

          const SizedBox(height: 24),

          // Revenue Chart
          SizedBox(
            height: isMobile
                ? 200
                : isTablet
                    ? 250
                    : 300,
            child: Obx(() {
              final SummaryRevenue? summary = controller.summaryRevenue.value;

              if (summary == null) {
                return const Center(child: Text("No data available"));
              }

              final barGroups = controller.getRevenueBarGroups();
              final maxValue = _getMaxYValue(barGroups);

              return BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxValue,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final products = summary
                            .revenueSummary[groupIndex].items.keys
                            .toList();
                        final product = rodIndex < products.length
                            ? products[rodIndex]
                            : 'Unknown';

                        return BarTooltipItem(
                          '$product\n\$${_formatCurrency(rod.toY)}',
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
                          if (index >= 0 &&
                              index < summary.revenueSummary.length) {
                            return Text(
                              summary.revenueSummary[index].label,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
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
                        color: Colors.grey.shade300,
                        strokeWidth: 1,
                        dashArray: [6, 4],
                      );
                    },
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 16),

          // Legend
          Obx(() {
            final SummaryRevenue? summary = controller.summaryRevenue.value;
            if (summary == null || summary.revenueSummary.isEmpty) {
              return const SizedBox.shrink();
            }

            // Fixed product colors
            final Map<String, Color> productColors = {
              "Family Pack": const Color(0xFF9787FF),
              "Single Photo": const Color(0xFFC6D2FD),
              "Standard Pack": const Color(0xFFC893FD),
            };

            
            final productOrder = [
              "Single Photo",
              "Family Pack",
              "Standard Pack"
            ];

            return _buildChartLegend([
              for (final product in productOrder)
                {
                  'label': product,
                  'color': productColors[product] ?? Colors.grey,
                }
            ]);
          }),
        ],
      ),
    );
  }


  // -------------------------
  // Helper methods
  // -------------------------

  double _getMaxYValue(List<BarChartGroupData> barGroups) {
    if (barGroups.isEmpty) return 100;
    double maxValue = 0;
    for (var group in barGroups) {
      for (var rod in group.barRods) {
        if (rod.toY > maxValue) maxValue = rod.toY;
      }
    }
    return (maxValue * 1.2);
  }

  String _formatCurrency(double value) {
    // Always show 2 decimals (no rounding to K/M)
    return value.toStringAsFixed(2);
  }

  String _formatYAxisLabel(double value) {
    return value.toStringAsFixed(2);
  }

  double _getGridInterval(double maxValue) {
    if (maxValue <= 50) return 10;
    if (maxValue <= 100) return 20;
    if (maxValue <= 500) return 50;
    if (maxValue <= 1000) return 100;
    return 200;
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
      OrderManagementController controller, bool isRevenue, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(width: 0.5, color: Colors.grey.shade600),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: Obx(() {
          final value = 
               controller.selectedRevenueRange.value;
              
          return DropdownButton(
            value: value,
            isDense: true,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white : Colors.grey,
            ),
            menuMaxHeight: 250,
            items: const [
              DropdownMenuItem(
                value: "today",
                child: Text('Today', style: TextStyle(fontSize: 14)),
              ),
              DropdownMenuItem(
                value: "this_week",
                child: Text('Week', style: TextStyle(fontSize: 14)),
              ),
              DropdownMenuItem(
                value: "this_month",
                child: Text('Month', style: TextStyle(fontSize: 14)),
              ),
              DropdownMenuItem(
                value: "last_month",
                child: Text('Month', style: TextStyle(fontSize: 14)),
              ),
              DropdownMenuItem(
                value: "last_6_months",
                child: Text('Last 6 Months', style: TextStyle(fontSize: 14)),
              ),
              DropdownMenuItem(
                value: "this_year",
                child: Text('This Year', style: TextStyle(fontSize: 14)),
              ),
            ],
            onChanged: (newValue) {
              if (newValue != null) {
                controller.updateRevenueFilter(newValue);
              }
            },
          );
        }),
      ),
    );
  }
}

import 'package:admin/controller/orders_management_controller/order_management_controller.dart';
import 'package:admin/models/orders/subscribers_analytics_data.dart';
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
                    final SubscriptionAnalyticsData? analyticsData = controller.subscriberAnalytics.value;
                    int totalSubscriptions = analyticsData?.totalSubscription ?? 0;
                    return Text(
                      _formatNumber(totalSubscriptions),
                      style: TextStyle(
                        fontSize: isMobile ? 24 : 28,
                        fontWeight: FontWeight.bold,
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
              final SubscriptionAnalyticsData? analyticsData = controller.subscriberAnalytics.value;
              final List<SubscriptionSummary> summaryList = analyticsData?.subscriptionSummary ?? [];
              final barGroups = <BarChartGroupData>[];
              double maxValue = 0;
              
              // Store data for tooltips
              List<Map<String, dynamic>> chartData = [];
              
              for (int i = 0; i < summaryList.length; i++) {
                final summary = summaryList[i];
                final familyPack = summary.items['Family Pack']?.count ?? 0;
                final standardPack = summary.items['Standard Pack']?.count ?? 0;
                final singlePhoto = summary.items['Single Photo']?.count ?? 0;
                final total = familyPack + standardPack + singlePhoto;
                maxValue = [maxValue, total.toDouble()].reduce((a, b) => a > b ? a : b);
                
                // Store data for tooltips
                chartData.add({
                  'familyPack': familyPack,
                  'standardPack': standardPack,
                  'singlePhoto': singlePhoto,
                  'total': total,
                  'label': summary.label,
                });
                
                barGroups.add(
                  BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: total.toDouble(),
                        width: 22,
                        color: Colors.transparent,
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        rodStackItems: [
                          BarChartRodStackItem(0, familyPack.toDouble(), const Color.fromARGB(255, 151, 135, 255)),
                          BarChartRodStackItem(familyPack.toDouble(), familyPack.toDouble() + standardPack.toDouble(), const Color.fromARGB(255, 200, 147, 253)),
                          BarChartRodStackItem(familyPack.toDouble() + standardPack.toDouble(), total.toDouble(), const Color.fromARGB(255, 198, 210, 253)),
                        ],
                      ),
                    ],
                  ),
                );
              }
              
              // Calculate proper max value with padding
              maxValue = _calculateMaxValue(maxValue);
              final interval = _getYAxisInterval(maxValue);
              
              return BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxValue,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      // tooltipBgColor: isDark ? Colors.grey.shade800 : Colors.white,
                      tooltipBorder: BorderSide(color: Colors.grey.shade400, width: 1),
                      // tooltipRoundedRadius: 8,
                      tooltipPadding: const EdgeInsets.all(12),
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        if (groupIndex >= chartData.length) return null;
                        
                        final data = chartData[groupIndex];
                        final familyPack = data['familyPack'];
                        final standardPack = data['standardPack'];
                        final singlePhoto = data['singlePhoto'];
                        final total = data['total'];
                        final label = data['label'];
                        
                        return BarTooltipItem(
                          '$label\n'
                          'Family Pack: $familyPack\n'
                          'Standard: $standardPack\n'
                          'Single Photo: $singlePhoto\n'
                          'Total: $total',
                          TextStyle(
                            color:Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
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
                          if (index >= 0 && index < summaryList.length) {
                            final label = summaryList[index].label;
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
                        interval: interval,
                        getTitlesWidget: (value, meta) {
                          if (value % interval == 0 && value <= maxValue) {
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
                    horizontalInterval: interval,
                    getDrawingHorizontalLine: (value) {
                      // Only show grid lines for values that are multiples of interval and within maxValue
                      if (value % interval == 0 && value <= maxValue && value > 0) {
                        return FlLine(
                          color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                          strokeWidth: 1,
                          dashArray: [6, 4],
                        );
                      }
                      return FlLine(color: Colors.transparent);
                    },
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          _buildChartLegend([
            {'label': 'Family Pack', 'color': const Color.fromARGB(255, 151, 135, 255)},
            {'label': 'Standard', 'color': const Color.fromARGB(255, 200, 147, 253)},
            {'label': 'Single Photo', 'color': const Color.fromARGB(255, 198, 210, 253)},
          ]),
        ],
      ),
    );
  }

  double _calculateMaxValue(double dataMaxValue) {
    if (dataMaxValue == 0) return 100;
    
    // Add 20% padding and round to nearest appropriate value
    double paddedMax = dataMaxValue * 1.2;
    
    if (paddedMax <= 10) return 10;
    if (paddedMax <= 20) return 20;
    if (paddedMax <= 50) return 50;
    if (paddedMax <= 100) return 100;
    if (paddedMax <= 200) return 200;
    if (paddedMax <= 500) return 500;
    if (paddedMax <= 1000) return 1000;
    
    // For larger values, round to nearest 100
    return (paddedMax / 100).ceil() * 100;
  }

  double _getYAxisInterval(double maxValue) {
    if (maxValue <= 10) return 2;
    if (maxValue <= 20) return 5;
    if (maxValue <= 50) return 10;
    if (maxValue <= 100) return 20;
    if (maxValue <= 200) return 25;
    if (maxValue <= 500) return 50;
    if (maxValue <= 1000) return 100;
    return 200;
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

          return DropdownButton(
            value: value,
            isDense: true,
            style:  TextStyle(fontSize: 14,color: isDark ? Colors.white : Colors.grey),
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
                controller.updateSubscriberFilter(newValue);
              }
            },
          );
        }),
      ),
    );
  }
}
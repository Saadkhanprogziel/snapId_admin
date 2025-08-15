import 'package:admin/controller/support_controller/support_controller.dart';
import 'package:admin/utils/custom_spaces.dart';
import 'package:admin/views/support/support_list_widget/support_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';

class Support extends StatelessWidget {
  const Support({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SupportController());

    // Responsive breakpoints
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor:
          isDark ? Theme.of(context).scaffoldBackgroundColor : Colors.white,
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Charts section: Row on large screens, Column on mobile
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child:
                      QueriesLineChart(isMobile: isMobile, isTablet: isTablet),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: SupportStatusChart(
                      isMobile: isMobile, isTablet: isTablet),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Orders list
            Container(
              height: isMobile
                  ? 500
                  : isTablet
                      ? 600
                      : 700,
              decoration: BoxDecoration(
                color:  isDark ? Color(0xFF23272F) : Colors.white,
                border: Border.all(width: 0.4, color: Colors.grey),
                borderRadius: BorderRadius.circular(isMobile ? 16 : 25),
              ),
              child: SupportListWidget(
                controller: controller,
                isMobile: isMobile,
                isTablet: isTablet,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QueriesLineChart extends StatelessWidget {
  final bool isMobile;
  final bool isTablet;
  final SupportController controller = Get.find<SupportController>();

  QueriesLineChart({Key? key, required this.isMobile, required this.isTablet})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: isMobile ? 300 : 400,
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF23272F) : Colors.white,
        borderRadius: BorderRadius.circular(isMobile ? 16 : 25),
        border: Border.all(
            width: 1,
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title & Filters
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => Text(
                        controller.queriesChartTitle.value,
                        style: TextStyle(
                          fontSize: isMobile ? 12 : 14,
                          // color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      )),
                  const SizedBox(height: 4),
                  Obx(() => Text(
                        controller.totalQueries.value.toString(),
                        style: TextStyle(
                          fontSize: isMobile ? 24 : 32,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                ],
              ),
              Row(
                children: [
                  Row(
                    children: [
                      _buildLegendItem(
                        color: controller.chartColors['aiAssistant']!,
                        label: controller.legendLabels['aiAssistant']!,
                      ),
                      const SizedBox(width: 16),
                      _buildLegendItem(
                        color: controller.chartColors['manualSupport']!,
                        label: controller.legendLabels['manualSupport']!,
                      ),
                    ],
                  ),
                  SpaceW20(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                        color: isDark ? Color(0xFF23272F) : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            width: 1,
                            color: isDark
                                ? Colors.grey.shade800
                                : Colors.grey.shade300)),
                    child: Obx(() => DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: controller.selectedQueriesPeriod.value,
                            isDense: true,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                            icon: Icon(
                              Icons.keyboard_arrow_down,
                              size: 16,
                              color: Colors.grey[600],
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
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

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
                          color: Colors.grey[200]!,
                          strokeWidth: 1,
                        );
                      },
                    ),
                    titlesData: FlTitlesData(
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
                            const style = TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                            );
                            if (value.toInt() >= 0 &&
                                value.toInt() < controller.monthLabels.length) {
                              return Text(controller.monthLabels[value.toInt()],
                                  style: style);
                            }
                            return const Text('', style: style);
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
                              style: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                              ),
                            );
                          },
                          reservedSize: 42,
                        ),
                      ),
                    ),
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
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) =>
                              FlDotCirclePainter(
                            radius: 4,
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
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(show: false),
                      ),
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem({required Color color, required String label}) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class SupportStatusChart extends StatelessWidget {
  final bool isMobile;
  final bool isTablet;
  final SupportController controller = Get.find<SupportController>();

  SupportStatusChart({Key? key, required this.isMobile, required this.isTablet})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: isMobile ? 300 : 400,
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF23272F) : Colors.white,
        borderRadius: BorderRadius.circular(isMobile ? 16 : 25),
        border: Border.all(
            width: 1,
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title & Filter
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() => Text(
                    controller.statusChartTitle.value,
                    style: TextStyle(
                      fontSize: isMobile ? 14 : 16,
                      fontWeight: FontWeight.w600,
                    ),
                  )),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                    color: isDark ? Color(0xFF23272F) : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        width: 1,
                        color: isDark
                            ? Colors.grey.shade800
                            : Colors.grey.shade300)),
                child: Obx(() => DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: controller.selectedStatusPeriod.value,
                        isDense: true,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        items: controller.periods.map((String period) {
                          return DropdownMenuItem<String>(
                            value: period,
                            child: Text(period),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            controller.changeStatusPeriod(newValue);
                            controller.fetchStatusData(newValue);
                          }
                        },
                      ),
                    )),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Chart content
          Expanded(
            child: isMobile
                ? Column(
                    children: [
                      _statusLegend(),
                      const SizedBox(height: 16),
                      _statusPie(),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(flex: 2, child: _statusLegend()),
                      const SizedBox(width: 16),
                      Expanded(flex: 3, child: _statusPie()),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _statusLegend() {
    return Obx(() => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildStatusItem(controller.statusLabels['open']!,
                controller.openCount.value, controller.statusColors['open']!),
            const SizedBox(height: 16),
            _buildStatusItem(
                controller.statusLabels['pending']!,
                controller.pendingCount.value,
                controller.statusColors['pending']!),
            const SizedBox(height: 16),
            _buildStatusItem(
                controller.statusLabels['closed']!,
                controller.closedCount.value,
                controller.statusColors['closed']!),
          ],
        ));
  }

  Widget _statusPie() {
    return Stack(
      children: [
        Obx(() => PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 60,
                sections: controller.getPieChartSections(),
                startDegreeOffset: -90,
              ),
            )),
        Positioned.fill(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(() => Text(
                    controller.computedTotal.toString(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              Text(
                'Total Status',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusItem(String label, int value, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value.toString(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

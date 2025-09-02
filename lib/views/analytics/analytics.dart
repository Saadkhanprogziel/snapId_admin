import 'package:admin/controller/analytics_controller/analytics_controller.dart';
import 'package:admin/models/analytics/processed_count.dart';
import 'package:admin/utils/custom_spaces.dart';
import 'package:admin/utils/stat_card_widget.dart';
import 'package:admin/views/analytics/analytics_list_widget/analytics_list_widget.dart';
import 'package:admin/views/analytics/document_chart/document_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Analytics extends StatelessWidget {
  const Analytics({super.key});
  static final ValueNotifier<int?> hoveredIndex = ValueNotifier<int?>(null);

  @override
  Widget build(BuildContext context) {
    final AnalyticsController analyticsController =
        Get.put(AnalyticsController());

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isDesktop = screenWidth > 1200;
        final isTablet = screenWidth > 600 && screenWidth <= 1200;
        final isMobile = screenWidth <= 600;
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Container(
          color:
              isDark ? Theme.of(context).scaffoldBackgroundColor : Colors.white,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(isMobile
                ? 16
                : isTablet
                    ? 20
                    : 24),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stat Cards Section

                    // Chart Section
                    _buildChartSection(
                        analyticsController, isDesktop, isTablet, isMobile, isDark),

                    SizedBox(
                        height: isMobile
                            ? 16
                            : isTablet
                                ? 20
                                : 24),

                    // List Widget Section
                    Container(
                      height: isMobile
                          ? 500
                          : isTablet
                              ? 600
                              : 700,
                      decoration: BoxDecoration(
                        color: isDark ? Color(0xFF23272F) : Colors.white,
                        border: Border.all(
                            width: 0.4,
                            color: isDark ? Colors.grey.shade800 : Colors.grey),
                        borderRadius: BorderRadius.circular(isMobile ? 16 : 25),
                      ),
                      child: AnalyticsListWidget(
                        controller: analyticsController,
                        isMobile: isMobile,
                        isTablet: isTablet,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ---------------- Stat Cards ----------------

  
  // ---------------- Chart Section ----------------

  Widget _buildChartSection(AnalyticsController analyticsController,
      bool isDesktop, bool isTablet, bool isMobile, bool isDark) {
    if (isMobile) {
      return Column(
        children: [
          // Document Chart Card
          Container(
            height: 400,
            decoration: BoxDecoration(
              color: isDark ? Color(0xFF23272F) : Colors.white,
              border: Border.all(
                  width: 0.4,
                  color: isDark ? Colors.grey.shade800 : Colors.grey),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Obx(() => DocumentTypeChart(
                  chartData: analyticsController
                      .topDocumentTypesCount.value!.topDocumentTypes,
                  selectedPeriod:
                      analyticsController.selectedDocTypePeriod.value,
                  onPeriodChanged: (value) {
                    analyticsController.updateDocTypeFilter(value);
                  },
                )),
          ),
          const SizedBox(height: 16),
          // Pie Chart Card
          Container(
            height: 400,
            decoration: BoxDecoration(
              color: isDark ? Color(0xFF23272F) : Colors.white,
              border: Border.all(
                  width: 0.4,
                  color: isDark ? Colors.grey.shade800 : Colors.grey),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: EdgeInsets.all(16),
            child: _buildPieChart(isDark),
          ),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Document Chart Card
        Expanded(
          flex: 70,
          child: Container(
            height: isTablet ? 400 : 380,
            decoration: BoxDecoration(
              color: isDark ? Color(0xFF23272F) : Colors.white,
              border: Border.all(
                  width: 0.4,
                  color: isDark ? Colors.grey.shade800 : Colors.grey),
              borderRadius: BorderRadius.circular(isMobile ? 16 : 25),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 24 : 40,
              vertical: 16,
            ),
            child: Obx(() => DocumentTypeChart(
                  chartData: analyticsController
                      .topDocumentTypesCount.value!.topDocumentTypes,
                  selectedPeriod:
                      analyticsController.selectedDocTypePeriod.value,
                  onPeriodChanged: (value) {
                    analyticsController.updateDocTypeFilter(value);
                  },
                )),
          ),
        ),
        SizedBox(width: isTablet ? 20 : 24),
        // Pie Chart Card
        Expanded(
          flex: 30,
          child: Container(
            height: isTablet ? 360 : 380,
            decoration: BoxDecoration(
              color: isDark ? Color(0xFF23272F) : Colors.white,
              border: Border.all(
                  width: 0.4,
                  color: isDark ? Colors.grey.shade800 : Colors.grey),
              borderRadius: BorderRadius.circular(isMobile ? 16 : 25),
            ),
            padding: EdgeInsets.all(isTablet ? 20 : 24),
            child: _buildPieChart(isDark),
          ),
        ),
      ],
    );
  }

  // ---------------- Pie Chart ----------------

  Widget _buildPieChart(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total Processing Request',
              style: TextStyle(
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
            Obx(() {
              final controller = Get.find<AnalyticsController>();
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? Colors.transparent : Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: controller.pieChartPeriod.value,
                    isDense: true,
                    style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white : Colors.grey[800]),
                    menuMaxHeight: 250,
                    items: const [
                      DropdownMenuItem(
                        value: 'this_week',
                        child: Text('Week', style: TextStyle(fontSize: 14)),
                      ),
                      DropdownMenuItem(
                        value: 'last_month',
                        child: Text('Last Month', style: TextStyle(fontSize: 14)),
                      ),
                      DropdownMenuItem(
                        value: 'this_month',
                        child: Text('This Month', style: TextStyle(fontSize: 14)),
                      ),
                      DropdownMenuItem(
                        value: 'this_year',
                        child: Text('This Year', style: TextStyle(fontSize: 14)),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) controller.updatePieChartFilter(value);
                    },
                  ),
                ),
              );
            }),
          ],
        ),

        // Total + Chart
        Obx(() {
          final controller = Get.find<AnalyticsController>();
          final status = controller.processedDocumentCount.value?.sessionByStatus;

          if (status == null) return SizedBox();

          final data = [
            {
              'label': 'Image Processed',
              'value': status.imageProcessed,
              'color': const Color(0xFF81C784), // green
            },
            {
              'label': 'Downloaded',
              'value': status.downloaded,
              'color': const Color(0xFFFF8A95), // red
            },
          ];

          final total =
              data.fold<num>(0, (sum, item) => sum + (item['value'] as num));

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                total.toStringAsFixed(0),
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildLegend(data, isDark),
              const SizedBox(height: 12),
              SizedBox(
                height: 200,
                child: ValueListenableBuilder<int?>(
                  valueListenable: hoveredIndex,
                  builder: (context, value, child) {
                    return PieChart(
                      PieChartData(
                        sectionsSpace: 4,
                        centerSpaceRadius: 50,
                        startDegreeOffset: 180,
                        sections: _getPieChartSectionsFromController(
                          data,
                          isDark,
                          hovered: value,
                        ),
                        pieTouchData: PieTouchData(
                          touchCallback: (event, pieTouchResponse) {
                            if (event is FlPointerHoverEvent) {
                              if (pieTouchResponse != null &&
                                  pieTouchResponse.touchedSection != null) {
                                hoveredIndex.value = pieTouchResponse
                                    .touchedSection!.touchedSectionIndex;
                              } else {
                                hoveredIndex.value = null;
                              }
                            } else if (event is FlLongPressEnd ||
                                event is FlPanEndEvent) {
                              hoveredIndex.value = null;
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }),
      ],
    );
  }

  List<PieChartSectionData> _getPieChartSectionsFromController(
      List<Map<String, dynamic>> data, bool isDark,
      {int? hovered}) {
    final total =
        data.fold<num>(0, (sum, item) => sum + (item['value'] as num));

    return List.generate(data.length, (index) {
      final item = data[index];
      final value = (item['value'] as num).toDouble();
      final label = item['label'] as String;
      final color = item['color'] as Color;

      return PieChartSectionData(
        color: color,
        value: value,
        title: '',
        radius: hovered == index ? 35 : 25,
        badgeWidget: hovered == index
            ? _buildTooltip(
                label,
                value.toStringAsFixed(0),
                '${((value / total) * 100).toStringAsFixed(1)}%',
                color,
                isDark,
              )
            : null,
        badgePositionPercentageOffset: 0.8,
      );
    });
  }

  Widget _buildTooltip(
      String label, String value, String percentage, Color color, bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF1A1A1A) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            percentage,
            style: TextStyle(
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(List<Map<String, dynamic>> data, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: data.map((item) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: item['color'] as Color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                item['label'] as String,
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

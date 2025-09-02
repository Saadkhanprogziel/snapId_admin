import 'package:admin/controller/analytics_controller/analytics_controller.dart';
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
                    _buildStatCardsSection(isDesktop, isTablet, isMobile),

                    SizedBox(
                        height: isMobile
                            ? 16
                            : isTablet
                                ? 20
                                : 24),

                    // Chart Section - Updated to include both charts
                    _buildChartSection(analyticsController, isDesktop, isTablet,
                        isMobile, isDark),

                    SizedBox(
                        height: isMobile
                            ? 16
                            : isTablet
                                ? 20
                                : 24),

                    // Top Countries/Buyers Section LIST WIDGET
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

  Widget _buildStatCardsSection(bool isDesktop, bool isTablet, bool isMobile) {
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        if (isDesktop) {
          return Row(
            children: [
              Expanded(
                child: statCard(
                  "Top Country By Revenue",
                  "\$12,480",
                  'assets/flags/pk.svg',
                  name: "Pakistan",
                  Colors.deepPurple,
                  analytics: true,
                  flag: true,
                  isDark: isDark,
                ),
              ),
              const SpaceW10(),
              Expanded(
                child: statCard(
                  "Top Country by Orders",
                  "84,310",
                  'assets/flags/ua.svg',
                  Colors.deepPurple,
                  name: "Ukraine",
                  analytics: true,
                  flag: true,
                  isDark: isDark,
                ),
              ),
              const SpaceW10(),
              Expanded(
                child: statCard(
                  name: "Amelia Liam",
                  "Top Buyer By Revenue",
                  "318",
                  'assets/icons/revanue.svg',
                  Colors.deepPurple,
                  analytics: true,
                  isDark: isDark,
                ),
              ),
              const SpaceW10(),
              Expanded(
                child: statCard(
                  "Top Buyer by Orders",
                  "100",
                  "assets/icons/Group.svg",
                  Colors.deepPurple,
                  name: "Tripti Dimri",
                  analytics: true,
                  isDark: isDark,
                ),
              ),
            ],
          );
        } else if (isTablet) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: statCard(
                      "Top Country By Revenue",
                      "\$12,480",
                      'assets/flags/pk.svg',
                      name: "Pakistan",
                      Colors.deepPurple,
                      analytics: true,
                      flag: true,
                      isDark: isDark,
                    ),
                  ),
                  const SpaceW10(),
                  Expanded(
                    child: statCard(
                      "Top Country by Orders",
                      "84,310",
                      'assets/flags/ua.svg',
                      Colors.deepPurple,
                      name: "Ukraine",
                      analytics: true,
                      flag: true,
                      isDark: isDark,
                    ),
                  ),
                ],
              ),
              const SpaceH10(),
              Row(
                children: [
                  Expanded(
                    child: statCard(
                      name: "Amelia Liam",
                      "Top Buyer By Revenue",
                      "318",
                      'assets/icons/revanue.svg',
                      Colors.deepPurple,
                      analytics: true,
                      isDark: isDark,
                    ),
                  ),
                  const SpaceW10(),
                  Expanded(
                    child: statCard(
                      "Top Buyer by Orders",
                      "100",
                      "assets/icons/Group.svg",
                      Colors.deepPurple,
                      name: "Tripti Dimri",
                      analytics: true,
                      isDark: isDark,
                    ),
                  ),
                ],
              ),
            ],
          );
        } else {
          return Column(
            children: [
              statCard(
                "Top Country By Revenue",
                "\$12,480",
                'assets/flags/pk.svg',
                name: "Pakistan",
                Colors.deepPurple,
                analytics: true,
                flag: true,
                isDark: isDark,
              ),
              const SpaceH10(),
              statCard(
                "Top Country by Orders",
                "84,310",
                'assets/flags/ua.svg',
                Colors.deepPurple,
                name: "Ukraine",
                analytics: true,
                flag: true,
                isDark: isDark,
              ),
              const SpaceH10(),
              statCard(
                name: "Amelia Liam",
                "Top Buyer By Revenue",
                "318",
                'assets/icons/revanue.svg',
                Colors.deepPurple,
                analytics: true,
                isDark: isDark,
              ),
              const SpaceH10(),
              statCard(
                "Top Buyer by Orders",
                "100",
                "assets/icons/Group.svg",
                Colors.deepPurple,
                name: "Tripti Dimri",
                analytics: true,
                isDark: isDark,
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildChartSection(AnalyticsController analyticsController,
    bool isDesktop, bool isTablet, bool isMobile, bool isDark) {
  if (isMobile) {
    // For mobile, stack charts vertically
    return Column(
      children: [
        // Document Chart Card
        Container(
          height: 400, // increased from 350 → 400
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
                selectedPeriod: analyticsController.selectedDocTypePeriod.value,
                onPeriodChanged: (value) {
                  analyticsController.updateDocTypeFilter(value);
                },
              )),
        ),
        const SizedBox(height: 16),
        // Pie Chart Card
        Container(
          height: 400, // increased from 350 → 400
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

  // For tablet and desktop, show charts side by side with separate cards
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Document Chart Card - 70% width
      Expanded(
        flex: 70,
        child: Container(
          height: isMobile
              ? 350
              : isTablet
                  ? 400 // increased from 350 → 400
                  : 380, // increased from 320 → 380
          decoration: BoxDecoration(
            color: isDark ? Color(0xFF23272F) : Colors.white,
            border: Border.all(
                width: 0.4,
                color: isDark ? Colors.grey.shade800 : Colors.grey),
            borderRadius: BorderRadius.circular(isMobile ? 16 : 25),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: isMobile
                ? 16
                : isTablet
                    ? 24
                    : 40,
            vertical: 16,
          ),
          child: Obx(() => DocumentTypeChart(
                chartData: analyticsController
                    .topDocumentTypesCount.value!.topDocumentTypes,
                selectedPeriod: analyticsController.selectedDocTypePeriod.value,
                onPeriodChanged: (value) {
                  analyticsController.updateDocTypeFilter(value);
                },
              )),
        ),
      ),
      // Margin between cards
      SizedBox(
          width: isMobile
              ? 16
              : isTablet
                  ? 20
                  : 24),
      // Pie Chart Card - 30% width
      Expanded(
        flex: 30,
        child: Container(
          height: isMobile
              ? 350
              : isTablet
                  ? 360 // increased from 300 → 360
                  : 380, // increased from 320 → 380
          decoration: BoxDecoration(
            color: isDark ? Color(0xFF23272F) : Colors.white,
            border: Border.all(
                width: 0.4,
                color: isDark ? Colors.grey.shade800 : Colors.grey),
            borderRadius: BorderRadius.circular(isMobile ? 16 : 25),
          ),
          padding: EdgeInsets.all(isMobile
              ? 16
              : isTablet
                  ? 20
                  : 24),
          child: _buildPieChart(isDark),
        ),
      ),
    ],
  );
}


  Widget _buildPieChart(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with title and dropdown (for pie chart only)
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
                        value: 'Week',
                        child: Text('Week', style: TextStyle(fontSize: 14)),
                      ),
                      DropdownMenuItem(
                        value: 'Month',
                        child: Text('Month', style: TextStyle(fontSize: 14)),
                      ),
                      DropdownMenuItem(
                        value: 'Year',
                        child: Text('Year', style: TextStyle(fontSize: 14)),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null)
                        controller.pieChartPeriod.value = value;
                    },
                  ),
                ),
              );
            }),
          ],
        ),

        // Total count (dynamic from pieChartPeriod)
        Obx(() {
          final controller = Get.find<AnalyticsController>();
          final data = controller
                  .pieChartDataByPeriod[controller.pieChartPeriod.value] ??
              [];
          final total =
              data.fold<num>(0, (sum, item) => sum + (item['value'] as num));
          return Text(
            total.toStringAsFixed(0),
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          );
        }),

        // Legend centered below the total count
        _buildLegend(isDark),
        const SizedBox(height: 12), // Less space below legend before pie chart
        // Semi-circular donut chart
        Expanded(
          child: Stack(
            children: [
              Obx(() {
                final controller = Get.find<AnalyticsController>();
                final data = controller.pieChartDataByPeriod[
                        controller.pieChartPeriod.value] ??
                    [];
                return ValueListenableBuilder<int?>(
                  valueListenable: hoveredIndex,
                  builder: (context, value, child) {
                    return PieChart(
                      PieChartData(
                        sectionsSpace: 4,
                        centerSpaceRadius: 50,
                        startDegreeOffset: 180,
                        sections: _getPieChartSectionsFromController(
                            data, isDark,
                            hovered: value),
                        pieTouchData: PieTouchData(
                          touchCallback:
                              (FlTouchEvent event, pieTouchResponse) {
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
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  // ...existing code...

  List<PieChartSectionData> _getPieChartSectionsFromController(
      List<Map<String, dynamic>> data, bool isDark,
      {int? hovered}) {
    return List.generate(data.length, (index) {
      final item = data[index];
      return PieChartSectionData(
        color: item['color'] as Color,
        value: (item['value'] as num).toDouble(),
        title: '',
        radius: 25,
        badgeWidget: hovered == index
            ? _buildTooltip(item['label'] as String, item['value'].toString(),
                item['percentage'] as String, item['color'] as Color, isDark)
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

  Widget _buildLegend(bool isDark) {
    final legendItems = [
      {
        'color': Color(0xFFFF8A95),
        'label': 'Failed',
      },
      {
        'color': Color(0xFF81C784),
        'label': 'Successful',
      },
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: legendItems.map((item) {
        return Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 24), // Even space between legend items
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

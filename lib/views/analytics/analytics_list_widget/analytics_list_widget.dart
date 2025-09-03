import 'package:admin/controller/analytics_controller/analytics_controller.dart';
import 'package:admin/theme/text_theme.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnalyticsListWidget extends StatelessWidget {
  final AnalyticsController controller;
  final bool isMobile;
  final bool isTablet;

  const AnalyticsListWidget({
    Key? key,
    required this.controller,
    this.isMobile = false,
    this.isTablet = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(isMobile
          ? 16
          : isTablet
              ? 20
              : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderSection(isDark),
          SizedBox(
              height: isMobile
                  ? 20
                  : isTablet
                      ? 24
                      : 32),
          SizedBox(height: isMobile ? 8 : 12),
          Expanded(
            child: Obx(() {
              final topCountries = controller.topCountries;
              final topBuyers = controller.topBuyers;

              // ✅ Show loader while fetching data
           
              if (controller.isLoadingTopBuyers.value|| controller.isLoadingTopCountries.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.selectedTopTab.value == 0) {
                // ✅ Top Countries
                final showRank = topCountries.any((c) => c.rank != null);

                if (topCountries.isEmpty) {
                  return const Center(child: Text("No data available"));
                }

                return DataTable2(
                  columnSpacing: 12,
                  horizontalMargin: 12,
                  minWidth: 800,
                  dataRowHeight: 70,
                  headingRowHeight: 56,
                  columns: [
                    if (showRank)
                      DataColumn2(
                          label: _headerText('Rank'), size: ColumnSize.S),
                    DataColumn2(
                        label: _headerText('Country'), size: ColumnSize.L),
                    DataColumn2(
                        label: _headerText('Orders'), size: ColumnSize.S),
                    DataColumn2(
                        label: _headerText('Revenue'), size: ColumnSize.M),
                    DataColumn2(
                        label: _headerText('Platform Breakdown'),
                        size: ColumnSize.L),
                  ],
                  rows: topCountries.map((country) {
                    final cells = <DataCell>[];
                    if (showRank)
                      cells.add(DataCell(Text("${country.rank ?? ''}")));
                    cells.addAll([
                      DataCell(Text("${country.countryName}")),
                      DataCell(Text("${country.totalOrders}")),
                      DataCell(Text("${country.revenue}")),
                      DataCell(Text("${country.platformBreakdown}")),
                    ]);
                    return DataRow(cells: cells);
                  }).toList(),
                );
              } else {
                // ✅ Top Buyers
                final showRank = topBuyers.any((b) => b.rank != null);

                if (topBuyers.isEmpty) {
                  return const Center(child: Text("No data available"));
                }

                return DataTable2(
                  columnSpacing: 12,
                  horizontalMargin: 12,
                  minWidth: 800,
                  dataRowHeight: 70,
                  headingRowHeight: 56,
                  columns: [
                    if (showRank)
                      DataColumn2(
                          label: _headerText('Rank'), size: ColumnSize.S),
                    DataColumn2(label: _headerText('Name'), size: ColumnSize.L),
                    DataColumn2(
                        label: _headerText('Country'), size: ColumnSize.M),
                    DataColumn2(
                        label: _headerText('Email'), size: ColumnSize.L),
                    DataColumn2(
                        label: _headerText('Orders'), size: ColumnSize.M),
                    DataColumn2(
                        label: _headerText('Revenue'), size: ColumnSize.M),
                    DataColumn2(
                        label: _headerText('Action'), size: ColumnSize.M),
                  ],
                  rows: topBuyers.map((buyer) {
                    final cells = <DataCell>[];
                    if (showRank)
                      cells.add(DataCell(Text("${buyer.rank ?? ''}")));
                    cells.addAll([
                      DataCell(Text("${buyer.firstName}")),
                      DataCell(Text("${buyer.countryName}")),
                      DataCell(Text("${buyer.email}")),
                      DataCell(Text("${buyer.totalOrders}")),
                      DataCell(Text("${buyer.revenue}")),
                      DataCell(_buildActionButton(
                          Icons.remove_red_eye_outlined, "View",
                          viewBtn: true, isDark: isDark)),
                    ]);
                    return DataRow(cells: cells);
                  }).toList(),
                );
              }
            }),
          ),
        ],
      ),
    );
  }

  /// ✅ Helper for consistent header text style
  Text _headerText(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.w500, // medium-bold
        color: Colors.grey, // grey color
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label,
      {bool viewBtn = false, bool isDark = false}) {
    return GestureDetector(
      onTap: () {
        print('$label clicked');
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 6 : 8,
          vertical: isMobile ? 6 : 8,
        ),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (label.isNotEmpty && !isMobile) ...[
              Text(label,
                  style: CustomTextTheme.regular12.copyWith(
                    fontSize: isTablet ? 12 : 14,
                    color: isDark ? Colors.white : Colors.grey.shade700,
                  )),
              const SizedBox(width: 6),
            ],
            Icon(
              icon,
              color: isDark ? Colors.white : Colors.grey.shade700,
              size: isMobile ? 14 : 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(bool isDark) {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() => Text(
                controller.selectedTopTab.value == 0
                    ? "Top Countries"
                    : "Top Buyers",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              )),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    controller.selectedTopTab.value = 0;
                    controller.currentPage.value = 0;
                  },
                  child: Obx(() => _buildTab(
                      "Top Countries", 0, controller.selectedTopTab.value == 0,
                      isDark: isDark)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    controller.selectedTopTab.value = 1;
                    controller.currentPage.value = 0;
                  },
                  child: Obx(() => _buildTab(
                      "Top Buyers", 1, controller.selectedTopTab.value == 1,
                      isDark: isDark)),
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      return Row(
        children: [
          // Bold Title on Left
          Obx(() => Text(
                controller.selectedTopTab.value == 0
                    ? "Top Countries"
                    : "Top Buyers",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              )),
          const Spacer(),
          // Tabs on Right
          GestureDetector(
            onTap: () {
              controller.selectedTopTab.value = 0;
              controller.currentPage.value = 0;
            },
            child: Obx(() => _buildTab(
                "Top Countries", 0, controller.selectedTopTab.value == 0,
                isDark: isDark)),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () {
              controller.selectedTopTab.value = 1;
              controller.currentPage.value = 0;
            },
            child: Obx(() => _buildTab(
                "Top Buyers", 1, controller.selectedTopTab.value == 1,
                isDark: isDark)),
          ),
        ],
      );
    }
  }

  Widget _buildTab(String title, int index, bool isSelected,
      {bool isDark = false}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 20,
        vertical: isMobile ? 12 : 12,
      ),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF6366F1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: isSelected ? null : Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            index == 0 ? Icons.flag_outlined : Icons.person_outline,
            color: isSelected
                ? Colors.white
                : (isDark ? Colors.white : Colors.grey.shade700),
            size: isMobile ? 14 : 16,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : (isDark ? Colors.white : Colors.grey.shade700),
              fontSize: isMobile ? 12 : 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

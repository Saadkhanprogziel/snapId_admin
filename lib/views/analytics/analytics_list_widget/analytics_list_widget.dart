import 'package:admin/controller/analytics_controller/analytics_controller.dart';
import 'package:admin/theme/text_theme.dart';
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
      padding: EdgeInsets.all(isMobile ? 16 : isTablet ? 20 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderSection(isDark),
          SizedBox(height: isMobile ? 20 : isTablet ? 24 : 32),
          Obx(() => _buildTableHeader(controller.selectedTopTab.value == 1)),
          SizedBox(height: isMobile ? 8 : 12),
          Expanded(
            child: Obx(() {
              final isTopBuyers = controller.selectedTopTab.value == 1;
              final dataList = isTopBuyers
                  ? controller.dummyBuyers
                  : controller.dummyCountries; // Changed from dummyActivities to dummyCountries
              
              const itemsPerPage = 10;
              // final totalPages = (dataList.length / itemsPerPage).ceil();
              final currentPage = controller.currentPage.value;
              final startIndex = currentPage * itemsPerPage;
              final endIndex = (startIndex + itemsPerPage) > dataList.length 
                  ? dataList.length 
                  : (startIndex + itemsPerPage);
              final paginatedList = dataList.sublist(startIndex, endIndex);

              return ListView.builder(
                itemCount: paginatedList.length,
                itemBuilder: (context, index) =>
                    _buildTableRow(paginatedList[index], isTopBuyers, isDark),
              );
            }),
          ),
          Obx(() {
            final isTopBuyers = controller.selectedTopTab.value == 1;
            final dataList = isTopBuyers
                ? controller.dummyBuyers
                : controller.dummyCountries; // Changed from dummyActivities to dummyCountries
            const itemsPerPage = 10;
            final totalPages = (dataList.length / itemsPerPage).ceil();
            final currentPage = controller.currentPage.value;

            return Container(
              padding: EdgeInsets.only(top: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: currentPage > 0
                        ? () => controller.currentPage.value--
                        : null,
                    icon: Icon(
                      Icons.chevron_left,
                      color: currentPage > 0 ? Colors.grey.shade700 : Colors.grey.shade400,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Page ${currentPage + 1} of $totalPages',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: isMobile ? 12 : 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  IconButton(
                    onPressed: currentPage < totalPages - 1
                        ? () => controller.currentPage.value++
                        : null,
                    icon: Icon(
                      Icons.chevron_right,
                      color: currentPage < totalPages - 1 
                          ? Colors.grey.shade700 
                          : Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(bool isDark) {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    controller.selectedTopTab.value = 0;
                    controller.currentPage.value = 0;
                  },
                  child: Obx(() => _buildTab(
                      "Top Countries", 0, controller.selectedTopTab.value == 0, isDark: isDark  )),
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
                      "Top Buyers", 1, controller.selectedTopTab.value == 1,  isDark: isDark )),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildActionButton(Icons.download, "Export", isDark: isDark)),
              const SizedBox(width: 8),
              Expanded(child: _buildActionButton(Icons.filter_list, "Filter",isDark: isDark)),
            ],
          ),
        ],
      );
    } else {
      return Row(
        children: [
          GestureDetector(
            onTap: () {
              controller.selectedTopTab.value = 0;
              controller.currentPage.value = 0;
            },
            child: Obx(() => _buildTab(
                "Top Countries", 0, controller.selectedTopTab.value == 0, isDark: isDark)),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () {
              controller.selectedTopTab.value = 1;
              controller.currentPage.value = 0;
            },
            child: Obx(() => _buildTab(
                "Top Buyers", 1, controller.selectedTopTab.value == 1,  isDark: isDark)),
          ),
          const Spacer(),
          _buildActionButton(Icons.download, "Export",isDark: isDark),
          const SizedBox(width: 8),
          _buildActionButton(Icons.filter_list, "Filter",isDark: isDark),
        ],
      );
    }
  }

  Widget _buildTableHeader(bool isTopBuyers) {
    if (isMobile) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Row(
          children: isTopBuyers
              ? const [
                  Expanded(flex: 2, child: Text('Name', style: _headerStyle)),
                  Expanded(flex: 2, child: Text('Country', style: _headerStyle)),
                  Expanded(flex: 2, child: Text('Orders', style: _headerStyle)),
                  SizedBox(width: 60, child: Text('Actions', style: _headerStyle)),
                ]
              : const [
                  Expanded(flex: 1, child: Text('Rank', style: _headerStyle)),
                  Expanded(flex: 2, child: Text('Country', style: _headerStyle)),
                  Expanded(flex: 2, child: Text('Orders', style: _headerStyle)),
                  Expanded(flex: 2, child: Text('Revenue', style: _headerStyle)),
                ],
        ),
      );
    } else if (isTablet) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: isTopBuyers
              ? const [
                  Expanded(flex: 1, child: Text('Rank', style: _headerStyle)),
                  Expanded(flex: 2, child: Text('Name', style: _headerStyle)),
                  Expanded(flex: 2, child: Text('Country', style: _headerStyle)),
                  Expanded(flex: 2, child: Text('Orders', style: _headerStyle)),
                  Expanded(flex: 2, child: Text('Revenue', style: _headerStyle)),
                  SizedBox(width: 70, child: Text('Actions', style: _headerStyle)),
                ]
              : const [
                  Expanded(flex: 1, child: Text('Rank', style: _headerStyle)),
                  Expanded(flex: 2, child: Text('Country', style: _headerStyle)),
                  Expanded(flex: 2, child: Text('Orders', style: _headerStyle)),
                  Expanded(flex: 2, child: Text('Revenue', style: _headerStyle)),
                  Expanded(flex: 2, child: Text('Platform', style: _headerStyle)),
                ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: isTopBuyers
              ? const [
                  Expanded(flex: 1, child: Text('Rank', style: _headerStyle)),
                  Expanded(flex: 2, child: Text('Name', style: _headerStyle)),
                  Expanded(flex: 2, child: Text('Country', style: _headerStyle)),
                  Expanded(flex: 3, child: Text('Email', style: _headerStyle)),
                  Expanded(flex: 2, child: Text('Orders', style: _headerStyle)),
                  Expanded(flex: 2, child: Text('Revenue', style: _headerStyle)),
                  Expanded(flex: 2, child: Text('Platform', style: _headerStyle)),
                  SizedBox(width: 80, child: Text('Actions', style: _headerStyle)),
                ]
              : const [
                  Expanded(flex: 1, child: Text('Rank', style: _headerStyle)),
                  Expanded(flex: 2, child: Text('Target Country', style: _headerStyle)),
                  Expanded(flex: 2, child: Text('Orders', style: _headerStyle)),
                  Expanded(flex: 2, child: Text('Revenue(\$)', style: _headerStyle)),
                  Expanded(flex: 3, child: Text('Platform Breakdown', style: _headerStyle)),
                ],
        ),
      );
    }
  }

  Widget _buildTableRow(dynamic data, bool isTopBuyers, bool isDark) {
    final padding = isMobile ? 8.0 : isTablet ? 12.0 : 16.0;

    if (isMobile) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: padding, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
              top: BorderSide(
                  color: isDark ? Colors.grey.shade600 : Colors.grey,
                  width: 0.5)),
        ),
        child: Row(
          children: isTopBuyers
              ? [
                  Expanded(flex: 2, child: Text(data.name, style: _rowStyle, overflow: TextOverflow.ellipsis)),
                  Expanded(flex: 2, child: Text(data.country, style: _rowStyle)),
                  Expanded(flex: 2, child: Text('${data.orders}', style: _rowStyle)),
                  SizedBox(width: 60, child: _buildActionButton(Icons.remove_red_eye_outlined, "" , viewBtn: true, isDark: isDark)),
                ]
              : [
                  Expanded(flex: 1, child: Text('${data.rank}', style: _rowStyle)),
                  Expanded(flex: 2, child: Text(data.country, style: _rowStyle, overflow: TextOverflow.ellipsis)),
                  Expanded(flex: 2, child: Text('${data.orders}', style: _rowStyle)),
                  Expanded(flex: 2, child: Text('\$${data.revenue.toStringAsFixed(2)}', style: _rowStyle)),
                ],
        ),
      );
    } else if (isTablet) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: padding, vertical: 14),
        decoration: BoxDecoration(
          border: Border(
              top: BorderSide(
                  color: isDark ? Colors.grey.shade600 : Colors.grey,
                  width: 0.5)),
        ),
        child: Row(
          children: isTopBuyers
              ? [
                  Expanded(flex: 1, child: Text('${data.rank}', style: _rowStyle)),
                  Expanded(flex: 2, child: Text(data.name, style: _rowStyle, overflow: TextOverflow.ellipsis)),
                  Expanded(flex: 2, child: Text(data.country, style: _rowStyle)),
                  Expanded(flex: 2, child: Text('${data.orders}', style: _rowStyle)),
                  Expanded(flex: 2, child: Text('\$${data.revenue.toStringAsFixed(2)}', style: _rowStyle)),
                  SizedBox(width: 70, child: _buildActionButton(Icons.remove_red_eye_outlined, "View",  viewBtn: true, isDark: isDark)),
                ]
              : [
                  Expanded(flex: 1, child: Text('${data.rank}', style: _rowStyle)),
                  Expanded(flex: 2, child: Text(data.country, style: _rowStyle, overflow: TextOverflow.ellipsis)),
                  Expanded(flex: 2, child: Text('${data.orders}', style: _rowStyle)),
                  Expanded(flex: 2, child: Text('\$${data.revenue.toStringAsFixed(2)}', style: _rowStyle)),
                  Expanded(flex: 2, child: Text(data.platformBreakdown, style: _rowStyle, overflow: TextOverflow.ellipsis)),
                ],
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: padding, vertical: 20),
        decoration: BoxDecoration(
          border: Border(
              top: BorderSide(
                  color: isDark ? Colors.grey.shade600 : Colors.grey,
                  width: 0.5)),
        ),
        child: Row(
          children: isTopBuyers
              ? [
                  Expanded(flex: 1, child: Text('${data.rank}', style: _rowStyle)),
                  Expanded(flex: 2, child: Text(data.name, style: _rowStyle)),
                  Expanded(flex: 2, child: Text(data.country, style: _rowStyle)),
                  Expanded(flex: 3, child: Text(data.email, style: _rowStyle, overflow: TextOverflow.ellipsis)),
                  Expanded(flex: 2, child: Text('${data.orders}', style: _rowStyle)),
                  Expanded(flex: 2, child: Text('\$${data.revenue.toStringAsFixed(2)}', style: _rowStyle)),
                  Expanded(flex: 2, child: Text(data.plateform, style: _rowStyle)),
                  SizedBox(width: 80, child: _buildActionButton(Icons.remove_red_eye_outlined, "View", viewBtn: true, isDark: isDark)),
                ]
              : [
                  Expanded(flex: 1, child: Text('${data.rank}', style: _rowStyle)),
                  Expanded(flex: 2, child: Text(data.country, style: _rowStyle, overflow: TextOverflow.ellipsis)),
                  Expanded(flex: 2, child: Text('${data.orders}', style: _rowStyle)),
                  Expanded(flex: 2, child: Text('\$${data.revenue.toStringAsFixed(2)}', style: _rowStyle)),
                  Expanded(flex: 3, child: Text(data.platformBreakdown, style: _rowStyle, overflow: TextOverflow.ellipsis)),
                ],
        ),
      );
    }
  }

  Widget _buildTab(String title, int index, bool isSelected,  {bool isDark = false}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 20,
        vertical: isMobile ? 8 : 12,
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
            color: isSelected ? Colors.white : (isDark ? Colors.white : Colors.grey.shade700),
            size: isMobile ? 14 : 16,
          ),
          if (!isMobile || title.length < 12) ...[
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : (isDark ? Colors.white : Colors.grey.shade700),
                fontSize: isMobile ? 12 : 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, {bool viewBtn = false, bool isDark = false}) {
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
              Text(
                label,
                style: CustomTextTheme.regular12.copyWith(
                  fontSize: isTablet ? 12 : 14,
                  color: isDark ? Colors.white : Colors.grey.shade700,
                )
              ),
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

  static const _headerStyle = TextStyle(
    color: Colors.grey,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  static const _rowStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
}
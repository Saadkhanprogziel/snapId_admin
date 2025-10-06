import 'package:admin/controller/dashboard_controller/dashboard_controller.dart';
import 'package:admin/models/dashboard/dashboard_orders_chart_Model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';

class RequestAnalyticsChart extends StatelessWidget {
  final DashboardController controller;

  const RequestAnalyticsChart({
    super.key,
    required this.controller,
  });
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      if (controller.isTotalRequestLoading.value) {
        return Container(
          height: 300, // keep same chart height for consistency
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF23272F) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.transparent, width: 0),
          ),
          child: const CircularProgressIndicator(),
        );
      }

      final data = controller.totalOrdersChart;
      return Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF23272F) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.transparent,
            width: 0,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildChartHeader(isDark),
            const SizedBox(height: 16),
            Expanded(
              child: _buildBarChart(data, isDark),
            ),
            const SizedBox(height: 16),
            _buildChartLegend(isDark),
            const SizedBox(height: 16),
          ],
        ),
      );
    });
  }

  /// Build chart header with title and filter dropdown
  Widget _buildChartHeader(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildTitleSection(isDark),
        _buildFilterDropdown(isDark),
      ],
    );
  }

  /// Build title and total count section
  Widget _buildTitleSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Total Request",
          style: TextStyle(
            fontSize: 18,
            color: isDark ? Colors.white70 : Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "${controller.totalOrdersChartResponse.value?.filteredCount ?? 0}",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
      ],
    );
  }

  /// Build filter dropdown
  Widget _buildFilterDropdown(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade800 : Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: Obx(() {
          return DropdownButton<String>(
            value: controller.selectedRequestFilter.value,
            isDense: true,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white : Colors.grey[800],
            ),
            dropdownColor: isDark ? Colors.grey.shade800 : Colors.white,
            menuMaxHeight: 250,
            items: _buildDropdownItems(),
            onChanged: (value) {
              if (value != null) {
                controller.updateRequestFilter(value);
              }
            },
          );
        }),
      ),
    );
  }

  /// Build dropdown menu items
  List<DropdownMenuItem<String>> _buildDropdownItems() {
    return const [
      DropdownMenuItem(
        value: 'all_time',
        child: Text('All Time', style: TextStyle(fontSize: 14)),
      ),
      DropdownMenuItem(
        value: 'this_week',
        child: Text('Week', style: TextStyle(fontSize: 14)),
      ),
      DropdownMenuItem(
        value: 'this_month',
        child: Text('Month', style: TextStyle(fontSize: 14)),
      ),
      DropdownMenuItem(
        value: 'last_month',
        child: Text('Last Month', style: TextStyle(fontSize: 14)),
      ),
      DropdownMenuItem(
        value: 'last_6_months',
        child: Text('6 Month', style: TextStyle(fontSize: 14)),
      ),
      DropdownMenuItem(
        value: 'this_year',
        child: Text('Year', style: TextStyle(fontSize: 14)),
      ),
    ];
  }

  /// Build chart legend
  Widget _buildChartLegend(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem(
          'Mobile',
          const Color.fromARGB(255, 151, 135, 255),
          isDark,
        ),
        const SizedBox(width: 24),
        _buildLegendItem(
          'Web',
          const Color.fromARGB(255, 200, 147, 253),
          isDark,
        ),
      ],
    );
  }

  /// Build individual legend item
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
            color: isDark ? Colors.white70 : Colors.grey.shade600,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  /// Build main bar chart
  Widget _buildBarChart(List<TotalOrders> data, bool isDark) {
    if (data.isEmpty) {
      return _buildEmptyState(isDark);
    }

    final maxY = _calculateMaxYValue(data);

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY,
        minY: 0,
        barTouchData: _buildBarTouchData(),
        titlesData: _buildTitlesData(data, maxY, isDark),
        borderData: _buildBorderData(isDark),
        barGroups: _buildBarGroups(data),
        groupsSpace: 20,
        gridData: _buildGridData(maxY, isDark),
      ),
    );
  }

  /// Build empty state widget
  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Text(
        'No data available',
        style: TextStyle(
          color: isDark ? Colors.white70 : Colors.grey.shade600,
          fontSize: 16,
        ),
      ),
    );
  }

  /// Build bar touch data for tooltips
  BarTouchData _buildBarTouchData() {
    return BarTouchData(
      enabled: true,
      touchTooltipData: BarTouchTooltipData(
        tooltipPadding: const EdgeInsets.all(8),
        getTooltipItem: (group, groupIndex, rod, rodIndex) {
          final platform = rodIndex == 0 ? 'Mobile' : 'Web';
          return BarTooltipItem(
            '$platform: ${rod.toY.round()}',
            const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          );
        },
      ),
    );
  }

  /// Build chart titles data
  FlTitlesData _buildTitlesData(
    List<TotalOrders> data,
    double maxY,
    bool isDark,
  ) {
    return FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 35,
          getTitlesWidget: (value, meta) =>
              _buildBottomTitle(value, data, isDark),
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 50,
          interval: maxY / 5,
          getTitlesWidget: (value, meta) => _buildLeftTitle(value, isDark),
        ),
      ),
      topTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      rightTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
    );
  }

  /// Build bottom axis title
  Widget _buildBottomTitle(
    double value,
    List<TotalOrders> data,
    bool isDark,
  ) {
    if (value.toInt() >= 0 && value.toInt() < data.length) {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          data[value.toInt()].label,
          style: TextStyle(
            color: isDark ? Colors.white70 : Colors.grey.shade600,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }
    return const SizedBox.shrink();
  }

  /// Build left axis title
  Widget _buildLeftTitle(double value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Text(
        _formatYAxisValue(value),
        style: TextStyle(
          color: isDark ? Colors.white70 : Colors.grey.shade600,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.right,
      ),
    );
  }

  /// Build chart border data
  FlBorderData _buildBorderData(bool isDark) {
    return FlBorderData(
      show: true,
      border: Border.all(
        color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
        width: 1,
      ),
    );
  }

  /// Build bar chart groups
  List<BarChartGroupData> _buildBarGroups(List<TotalOrders> data) {
    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;

      return BarChartGroupData(
        x: index,
        barRods: [
          _buildBarRod(
            item.mobileApp.toDouble(),
            const Color.fromARGB(255, 151, 135, 255),
          ),
          _buildBarRod(
            item.webApp.toDouble(),
            const Color.fromARGB(255, 200, 147, 253),
          ),
        ],
        barsSpace: 6,
      );
    }).toList();
  }

  /// Build individual bar rod
  BarChartRodData _buildBarRod(double value, Color color) {
    return BarChartRodData(
      toY: value,
      color: color,
      width: 14,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(4),
        topRight: Radius.circular(4),
      ),
    );
  }

  /// Build grid data
  FlGridData _buildGridData(double maxY, bool isDark) {
    return FlGridData(
      show: true,
      drawHorizontalLine: true,
      drawVerticalLine: false,
      horizontalInterval: maxY / 5,
      getDrawingHorizontalLine: (value) => FlLine(
        color: isDark
            ? Colors.grey.shade700.withOpacity(0.3)
            : Colors.grey.shade300.withOpacity(0.5),
        strokeWidth: 1,
        dashArray: [5, 5],
      ),
    );
  }

  /// Calculate maximum Y value for chart scaling
  double _calculateMaxYValue(List<TotalOrders> data) {
    if (data.isEmpty) return 100;

    double maxMobile =
        data.map((e) => e.mobileApp.toDouble()).reduce((a, b) => a > b ? a : b);
    double maxWeb =
        data.map((e) => e.webApp.toDouble()).reduce((a, b) => a > b ? a : b);

    return (maxMobile > maxWeb ? maxMobile : maxWeb) * 1.1;
  }

  /// Format Y-axis values with appropriate units
  String _formatYAxisValue(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(value % 1000000 == 0 ? 0 : 1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(value % 1000 == 0 ? 0 : 1)}K';
    } else {
      return value.toInt().toString();
    }
  }
}

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:admin/controller/support_controller/support_controller.dart';
import 'support.dart';

class QueriesLineChart extends StatelessWidget {
  final DeviceType deviceType;
  final double width;
  final SupportController controller = Get.find<SupportController>();

  QueriesLineChart({
    Key? key,
    required this.deviceType,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = deviceType == DeviceType.mobile;
    final isTablet = deviceType == DeviceType.tablet;
    return Container(
      height: _getChartHeight(),
      width: width,
      padding: EdgeInsets.all(_getPadding()),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF23272F) : Colors.transparent,
        borderRadius: BorderRadius.circular(_getBorderRadius()),
        border: Border.all(
          width: 1,
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(isDark, isMobile, isTablet),
          SizedBox(height: _getSpacing()),
          Expanded(
            child: Obx(() => _buildChart(isDark)),
          ),
        ],
      ),
    );
  }

  Widget _buildChart(bool isDark) {
    
    if (controller.manualSupportData.isEmpty) {
      return Center(
        child: Text(
          'Data for this period is not available',
          style: TextStyle(
            color: isDark ? Colors.white70 : Colors.grey[700],
            fontSize: deviceType == DeviceType.mobile ? 13 : 15,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    
    double maxY = controller.manualSupportData.isNotEmpty
        ? controller.manualSupportData
            .map((spot) => spot.y)
            .reduce((a, b) => a > b ? a : b)
        : 100;
    
    
    maxY = (maxY * 1.2).ceilToDouble();
    if (maxY < 50) maxY = 50; 

    
    double maxX = controller.manualSupportData.isNotEmpty
        ? controller.manualSupportData.length.toDouble() - 1
        : 5;
    if (maxX < 5) maxX = 5; 

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxY / 5, 
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
              strokeWidth: 1,
            );
          },
        ),
        titlesData: _getTitlesData(maxY),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: maxX,
        minY: 0,
        maxY: maxY,
        lineBarsData: [
          LineChartBarData(
            spots: controller.manualSupportData,
            isCurved: true,
            gradient: LinearGradient(
              colors: [
                Color(0xFFD8B4FE),
                Color(0xFFD8B4FE)
              ],
            ),
            barWidth: deviceType == DeviceType.mobile ? 2 : 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) =>
                  FlDotCirclePainter(
                radius: deviceType == DeviceType.mobile ? 3 : 4,
                color: Color(0xFFD8B4FE),
                strokeWidth: 2,
                strokeColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDark, bool isMobile, bool isTablet) {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitleSection(),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLegend(),
              _buildDropdown(isDark),
            ],
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildTitleSection(),
        Row(
          children: [
            if (!isTablet) _buildLegend(),
            if (!isTablet) const SizedBox(width: 20),
            _buildDropdown(isDark),
          ],
        ),
      ],
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() => Text(
              controller.queriesChartTitle.value,
              style: TextStyle(
                fontSize: _getTitleFontSize(),
                fontWeight: FontWeight.w500,
              ),
            )),
        const SizedBox(height: 4),
        Obx(() => Text(
              controller.totalQueries.value.toString(),
              style: TextStyle(
                fontSize: _getValueFontSize(),
                fontWeight: FontWeight.bold,
              ),
            )),
      ],
    );
  }

  Widget _buildLegend() {
    return Row(
      children: [
        SizedBox(width: deviceType == DeviceType.mobile ? 12 : 16),
        _buildLegendItem(
          color:Color(0xFFD8B4FE),
          label: "Manual Support",
        ),
      ],
    );
  }

  Widget _buildDropdown(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF23272F) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 1,
          color: isDark ? Colors.white : Colors.grey.shade300,
        ),
      ),
      child: Obx(() => DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: controller.selectedQueriesPeriod.value,
              isDense: true,
              style: TextStyle(
                fontSize: deviceType == DeviceType.mobile ? 11 : 12,
                color: isDark ? Colors.white : Colors.grey[600],
              ),
              icon: Icon(
                Icons.keyboard_arrow_down,
                size: 16,
                color: isDark ? Colors.white : Colors.grey[600],
              ),
              items: const [
                      DropdownMenuItem(
                        value: 'all_time',
                        child: Text('All Time', style: TextStyle(fontSize: 14)),
                      ),
                      DropdownMenuItem(
                        value: 'this_week',
                        child: Text('This Week', style: TextStyle(fontSize: 14)),
                      ),
                      DropdownMenuItem(
                        value: 'last_month',
                        child:
                            Text('Last Month', style: TextStyle(fontSize: 14)),
                      ),
                      DropdownMenuItem(
                        value: 'this_month',
                        child:
                            Text('This Month', style: TextStyle(fontSize: 14)),
                      ),
                      DropdownMenuItem(
                        value: 'this_year',
                        child:
                            Text('This Year', style: TextStyle(fontSize: 14)),
                      ),
                    ],
              onChanged: (String? newValue) {
                if (newValue != null) {
                  controller.changeQuriesPeriod(newValue);
                }
              },
            ),
          )),
    );
  }

  FlTitlesData _getTitlesData(double maxY) {
    return FlTitlesData(
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
            final style = TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w400,
              fontSize: deviceType == DeviceType.mobile ? 10 : 12,
            );
            
            
            int index = value.toInt();
            if (index >= 0 && index < controller.monthLabels.length) {
              return Text(controller.monthLabels[index], style: style);
            }
            return Text('', style: style);
          },
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: maxY / 5, 
          getTitlesWidget: (double value, TitleMeta meta) {
            return Text(
              value.toInt().toString(),
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w400,
                fontSize: deviceType == DeviceType.mobile ? 10 : 12,
              ),
            );
          },
          reservedSize: deviceType == DeviceType.mobile ? 35 : 42,
        ),
      ),
    );
  }

  Widget _buildLegendItem({required Color color, required String label}) {
    return Row(
      children: [
        Container(
          width: deviceType == DeviceType.mobile ? 10 : 12,
          height: deviceType == DeviceType.mobile ? 10 : 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: deviceType == DeviceType.mobile ? 10 : 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  double _getChartHeight() {
    switch (deviceType) {
      case DeviceType.desktop:
        return 500;
      case DeviceType.tablet:
        return 480;
      case DeviceType.mobile:
        return 350;
    }
  }

  double _getPadding() {
    switch (deviceType) {
      case DeviceType.desktop:
        return 32;
      case DeviceType.tablet:
        return 24;
      case DeviceType.mobile:
        return 16;
    }
  }

  double _getBorderRadius() {
    switch (deviceType) {
      case DeviceType.desktop:
        return 25;
      case DeviceType.tablet:
        return 20;
      case DeviceType.mobile:
        return 16;
    }
  }

  double _getSpacing() {
    switch (deviceType) {
      case DeviceType.desktop:
        return 32;
      case DeviceType.tablet:
        return 24;
      case DeviceType.mobile:
        return 16;
    }
  }

  double _getTitleFontSize() {
    switch (deviceType) {
      case DeviceType.desktop:
        return 16;
      case DeviceType.tablet:
        return 14;
      case DeviceType.mobile:
        return 12;
    }
  }

  double _getValueFontSize() {
    switch (deviceType) {
      case DeviceType.desktop:
        return 36;
      case DeviceType.tablet:
        return 32;
      case DeviceType.mobile:
        return 24;
    }
  }
}
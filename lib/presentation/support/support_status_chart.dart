import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:admin/controller/support_controller/support_controller.dart';
import 'support.dart';

class SupportStatusChart extends StatelessWidget {
  final DeviceType deviceType;
  final double width;
  final SupportController controller = Get.find<SupportController>();

  SupportStatusChart({
    Key? key,
    required this.deviceType,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
          // Title & Filter
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Obx(() => Text(
                      controller.statusChartTitle.value,
                      style: TextStyle(
                        fontSize: _getTitleFontSize(),
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    )),
              ),
              const SizedBox(width: 12),
              _buildDropdown(isDark),
            ],
          ),
          SizedBox(height: _getSpacing()),

          // Chart content
          Expanded(
            child: _buildChartContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildChartContent() {
    if (deviceType == DeviceType.mobile) {
      return Column(
        children: [
          Expanded(flex: 3, child: _statusPie()),
          const SizedBox(height: 12),
          SizedBox(height: 60, child: _statusLegend()),
        ],
      );
    } else if (deviceType == DeviceType.tablet) {
      return Column(
        children: [
          Expanded(flex: 2, child: _statusPie()),
          const SizedBox(height: 16),
          Expanded(flex: 1, child: _statusLegend()),
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(flex: 2, child: _statusLegend()),
          const SizedBox(width: 16),
          Expanded(flex: 3, child: _statusPie()),
        ],
      );
    }
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
              value: controller.selectedStatusPeriod.value,
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
              onChanged: (String? newValue) {
                if (newValue != null) {
                  controller.changeStatusPeriod(newValue);
                }
              },
            ),
          )),
    );
  }

  Widget _statusLegend() {
    return Obx(() => deviceType == DeviceType.mobile
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCompactStatusItem(
                  controller.statusLabels['open']!,
                  controller.supportStatusesData.value?.openCount ?? 0,
                  controller.statusColors['open']!,
                ),
                _buildCompactStatusItem(
                  controller.statusLabels['pending']!,
                  controller.supportStatusesData.value?.pendingCount ?? 0,
                  controller.statusColors['pending']!,
                ),
                _buildCompactStatusItem(
                  controller.statusLabels['closed']!,
                  controller.supportStatusesData.value?.closeCount ?? 0,
                  controller.statusColors['closed']!,
                ),
              ],
            ),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStatusItem(
                controller.statusLabels['open']!,
                controller.supportStatusesData.value?.openCount ?? 0,
                controller.statusColors['open']!,
              ),
              SizedBox(height: _getItemSpacing()),
              _buildStatusItem(
                controller.statusLabels['pending']!,
                controller.supportStatusesData.value?.pendingCount ?? 0,
                controller.statusColors['pending']!,
              ),
              SizedBox(height: _getItemSpacing()),
              _buildStatusItem(
                controller.statusLabels['closed']!,
                controller.supportStatusesData.value?.closeCount ?? 0,
                controller.statusColors['closed']!,
              ),
            ],
          ));
  }

  Widget _statusPie() {
    final centerRadius = deviceType == DeviceType.mobile
        ? 35.0
        : deviceType == DeviceType.tablet
            ? 45.0
            : 60.0;
    final totalFontSize = deviceType == DeviceType.mobile
        ? 16.0
        : deviceType == DeviceType.tablet
            ? 18.0
            : 24.0;
    final labelFontSize = deviceType == DeviceType.mobile
        ? 9.0
        : deviceType == DeviceType.tablet
            ? 10.0
            : 12.0;
    return Stack(
      children: [
        Obx(() => PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: centerRadius,
                sections: controller.getPieChartSections(),
                startDegreeOffset: -90,
              ),
            )),
        Positioned.fill(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(() => Text(
                    controller.supportStatusesData.value?.totalCount
                            .toString() ??
                        "",
                    style: TextStyle(
                      fontSize: totalFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              Text(
                'Total Status',
                style: TextStyle(
                  fontSize: labelFontSize,
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
      padding: EdgeInsets.all(_getItemPadding()),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: deviceType == DeviceType.tablet ? 10 : 10,
            height: deviceType == DeviceType.tablet ? 10 : 10,
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
                fontSize: _getItemFontSize(),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: _getItemFontSize(),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactStatusItem(String label, int value, Color color) {
    return Flexible(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value.toString(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
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
        return 24;
      case DeviceType.tablet:
        return 20;
      case DeviceType.mobile:
        return 16;
    }
  }

  double _getItemSpacing() {
    switch (deviceType) {
      case DeviceType.desktop:
        return 16;
      case DeviceType.tablet:
        return 10;
      case DeviceType.mobile:
        return 8;
    }
  }

  double _getItemPadding() {
    switch (deviceType) {
      case DeviceType.desktop:
        return 12;
      case DeviceType.tablet:
        return 8;
      case DeviceType.mobile:
        return 8;
    }
  }

  double _getTitleFontSize() {
    switch (deviceType) {
      case DeviceType.desktop:
        return 18;
      case DeviceType.tablet:
        return 18;
      case DeviceType.mobile:
        return 18;
    }
  }

  double _getItemFontSize() {
    switch (deviceType) {
      case DeviceType.desktop:
        return 14;
      case DeviceType.tablet:
        return 14;
      case DeviceType.mobile:
        return 14;
    }
  }
}

import 'package:admin/controller/user_management_controller/user_management_controller.dart';

import 'package:admin/views/user_management/users_list_widget/users_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';

class UserManagement extends StatelessWidget {
  const UserManagement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserManagementController());

    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor:
          isDark ? Theme.of(context).scaffoldBackgroundColor : Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          // final isDesktop = screenWidth > 1200;
          final isTablet = screenWidth > 600 && screenWidth <= 1200;
          final isMobile = screenWidth <= 600;

          final cardWidth = isTablet
              ? (screenWidth - 48) /
                  2 // 2 cards per row: 16px padding on both sides + 16px gap
              : isMobile
                  ? screenWidth - 32 // 1 card per row: full width minus padding
                  : (screenWidth - 80) /
                      4; // 4 cards per row: 16px padding + 16px gaps

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Wrap(
                    spacing: 16, // Horizontal spacing between cards
                    runSpacing: 16, // Vertical spacing between rows
                    children: [
                      SizedBox(
                        width: cardWidth,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                              minHeight: 300), // Ensure uniform height
                          child: _buildTotalUsersCard(controller, isDark),
                        ),
                      ),
                      SizedBox(
                        width: cardWidth,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(minHeight: 300),
                          child: _buildUsersPlatformCard(controller, isDark),
                        ),
                      ),
                      SizedBox(
                        width: cardWidth,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(minHeight: 300),
                          child: _buildUserStatusCard(controller, isDark),
                        ),
                      ),
                      SizedBox(
                        width: cardWidth,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(minHeight: 300),
                          child: _buildSignupMethodsCard(controller, isDark),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
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
                          color: isDark ? Colors.grey.shade600 : Colors.grey),
                      borderRadius: BorderRadius.circular(isMobile ? 16 : 25),
                    ),
                    child: UsersListWidget(
                      controller: controller,
                      isMobile: isMobile,
                      isTablet: isTablet,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTotalUsersCard(
      UserManagementController controller, bool isDark) {
    return Obx(() => Container(
          decoration: BoxDecoration(
            color: isDark ? Color(0xFF23272F) : Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
                width: 0.4, color: isDark ? Colors.grey.shade600 : Colors.grey),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Users',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 0.4,
                                color: isDark
                                    ? Colors.grey.shade600
                                    : Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'All Time',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${controller.totalUsers.value.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(
                          Icons.arrow_upward,
                          color: Colors.green,
                          size: 16,
                        ),
                        Text(
                          '${controller.growthPercentage.value}%',
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          controller.growthPeriod.value,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
              SizedBox(
                height: 150,
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: false),
                    titlesData: const FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    minX: 0,
                    maxX: 11,
                    minY: 0,
                    maxY: 6,
                    lineBarsData: [
                      LineChartBarData(
                        spots: controller.chartSpots,
                        isCurved: true,
                        gradient: LinearGradient(
                          colors: [
                            Colors.purple.withOpacity(0.3),
                            Colors.purple.withOpacity(0.1),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [
                              Colors.purple.withOpacity(0.3),
                              isDark
                                  ? Color(0xFF23272F).withOpacity(0.1)
                                  : Colors.white.withOpacity(0.1),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildUsersPlatformCard(
      UserManagementController controller, bool isDark) {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? Color(0xFF23272F) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              width: 0.4, color: isDark ? Colors.grey.shade600 : Colors.grey),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Users Platform',
              style: TextStyle(
                // color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _buildLegendDot(
                    color: const Color(0xFF7C3AED), label: 'Mobile app'),
                const Spacer(),
                _buildLegendDot(
                    color: const Color(0xFF3B82F6), label: 'Web app'),
              ],
            ),
            const SizedBox(height: 30),
            SizedBox(
              height: 120,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 4,
                  centerSpaceRadius: 45,
                  startDegreeOffset: -90,
                  pieTouchData: PieTouchData(
                    touchCallback: (event, response) {
                      controller.setTouchedIndex(
                          response?.touchedSection?.touchedSectionIndex);
                    },
                  ),
                  sections: [
                    PieChartSectionData(
                      color: const Color(0xFF7C3AED),
                      value: controller.mobileUsers.value.toDouble(),
                      title: controller.touchedIndex.value == 0
                          ? ' ${controller.mobileUsers.value} '
                          : '',
                      radius: 40,
                      titlePositionPercentageOffset: 0.6,
                      titleStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        background: Paint()
                          ..color = Colors.black
                          ..style = PaintingStyle.fill,
                      ),
                    ),
                    PieChartSectionData(
                      color: const Color(0xFF3B82F6),
                      value: controller.webUsers.value.toDouble(),
                      title: controller.touchedIndex.value == 1
                          ? ' ${controller.webUsers.value} '
                          : '',
                      radius: 40,
                      titlePositionPercentageOffset: 0.6,
                      titleStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        background: Paint()
                          ..color = Colors.black
                          ..style = PaintingStyle.fill,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildLegendDot({required Color color, required String label}) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _buildUserStatusCard(
      UserManagementController controller, bool isDark) {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? Color(0xFF23272F) : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
              width: 0.4, color: isDark ? Colors.grey.shade600 : Colors.grey),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Overview',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    const Text(
                      'User Status',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: 140,
                      width: 140,
                      child: PieChart(
                        PieChartData(
                          sections: [
                            PieChartSectionData(
                              color: const Color.fromARGB(255, 18, 153, 68),
                              value: controller.activeUsers.value.toDouble(),
                              title: '',
                              radius: 11,
                            ),
                            PieChartSectionData(
                              color: const Color(0xFFFF6B8D),
                              value: controller.suspendedUsers.value.toDouble(),
                              title: '',
                              radius: 11,
                            ),
                          ],
                          sectionsSpace: 2,
                          centerSpaceRadius: 50,
                          startDegreeOffset: -90,
                        ),
                      ),
                    ),
                    Text(
                      '${controller.totalStatusUsers.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildUserLegendItem(const Color(0xFF4ADE80), 'Active',
                      '${controller.activeUsers.value.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}'),
                  const SizedBox(height: 8),
                  _buildUserLegendItem(const Color(0xFFFF6B8D), 'Suspended',
                      '${controller.suspendedUsers.value.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}'),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildUserLegendItem(Color color, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildSignupMethodsCard(
      UserManagementController controller, bool isDark) {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? Color(0xFF23272F) : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
              width: 0.4, color: isDark ? Colors.grey.shade600 : Colors.grey),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Signup Methods',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 150,
                  width: 150,
                  child: PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          color: const Color.fromARGB(255, 151, 135, 255),
                          value: controller.googleSignups.value.toDouble(),
                          title: '',
                          radius: 25,
                        ),
                        PieChartSectionData(
                          color: const Color.fromARGB(255, 200, 147, 253),
                          value: controller.appleSignups.value.toDouble(),
                          title: '',
                          radius: 25,
                        ),
                        PieChartSectionData(
                          color: const Color.fromARGB(255, 198, 210, 253),
                          value: controller.emailSignups.value.toDouble(),
                          title: '',
                          radius: 25,
                        ),
                      ],
                      sectionsSpace: 2,
                      centerSpaceRadius: 50,
                      startDegreeOffset: -90,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    height: 140,
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildLegendItem(Colors.blue, 'Google',
                            '${controller.googleSignups.value.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}'),
                        const SizedBox(height: 6),
                        _buildLegendItem(Colors.purple, 'Apple',
                            '${controller.appleSignups.value.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}'),
                        const SizedBox(height: 6),
                        _buildLegendItem(Colors.green, 'Email',
                            '${controller.emailSignups.value.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      );
    });
  }

  Widget _buildLegendItem(Color color, String label, String value) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

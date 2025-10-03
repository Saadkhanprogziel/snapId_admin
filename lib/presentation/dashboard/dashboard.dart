import 'package:admin/controller/dashboard_controller/dashboard_controller.dart';
import 'package:admin/models/dashboard/dashboard_stats_model.dart';
import 'package:admin/presentation/dashboard/revanue_chart/revanue_chart.dart';
import 'package:admin/presentation/dashboard/subscriber_chart/subscriber_chart.dart';
import 'package:admin/utils/custom_spaces.dart';
import 'package:admin/utils/stat_card_widget.dart';
import 'package:admin/presentation/dashboard/request_analytics_chart/request_analytics_cart.dart';
import 'package:admin/utils/jumping_dots.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
  
    final isDark = Theme.of(context).brightness == Brightness.dark;
    

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isDesktop = screenWidth > 1200;
        final isTablet = screenWidth > 600 && screenWidth <= 1200;
        final isMobile = screenWidth <= 600;

        return GetBuilder<DashboardController>(
          init: DashboardController(),
          builder: (_dashboardController) {
            return Obx(() {
              if (_dashboardController.isLoading.value) {
                return Row(
                  children:  [
                    Spacer(),
                    JumpingDots(numberOfDots: 3),
                    Spacer(),
                  ],
                );
              }

              return SingleChildScrollView(
                padding: EdgeInsets.all(
                  isMobile
                      ? 16
                      : isTablet
                          ? 20
                          : 24,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top Section: Stat Cards + Request Analytics Chart
                        _buildTopSection(_dashboardController, isDesktop,
                            isTablet, isMobile, isDark),

                        SizedBox(
                          height: isMobile
                              ? 20
                              : isTablet
                                  ? 25
                                  : 30,
                        ),

                        // Charts Section: Revenue & Subscriber Charts
                        _buildChartsSection(_dashboardController, isDesktop,
                            isTablet, isMobile, isDark),

                        SizedBox(
                          height: isMobile
                              ? 16
                              : isTablet
                                  ? 18
                                  : 20,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
          },
        );
      },
    );
  }

  Widget _buildTopSection(DashboardController controller, bool isDesktop,
      bool isTablet, bool isMobile, bool isDark) {
    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: _buildStatCardsGrid(isDesktop, isTablet, isMobile, isDark,
                stats: controller.dashboardStatsData.value),
          ),
          const SizedBox(width: 20),
          Expanded(
            flex: 2,
            child: _buildRequestAnalyticsChart(
                controller, isDesktop, isTablet, isMobile, isDark),
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatCardsGrid(isDesktop, isTablet, isMobile, isDark,
              stats: controller.dashboardStatsData.value),
          SizedBox(height: isMobile ? 16 : 20),
          _buildRequestAnalyticsChart(
              controller, isDesktop, isTablet, isMobile, isDark),
        ],
      );
    }
  }

  Widget _buildStatCardsGrid(
      bool isDesktop, bool isTablet, bool isMobile, bool isDark,
      {DashboardStatsModel? stats}) {
    if (isDesktop) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: statCard(
                  "Total Users",
                  "${stats?.users.totalUsers ?? ""}",
                  'assets/icons/users.svg',
                  Colors.deepPurple,
                  isDark: isDark,
                ),
              ),
              const SpaceW10(),
              Expanded(
                child: statCard(
                  "Total Revenue",
                  stats?.totalRevenue != null
                      ? stats!.totalRevenue.toStringAsFixed(2)
                      : "",
                  'assets/icons/revanue.svg',
                  Colors.deepPurple,
                  isDark: isDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: statCard(
                  "Total Orders",
                  "${stats?.orders.totalOrders ?? ""}",
                  'assets/icons/Group.svg',
                  Colors.deepPurple,
                  isDark: isDark,
                ),
              ),
              const SpaceW10(),
              Expanded(
                child: statCard(
                  "Support Requests",
                  "${stats?.support.totalSupport ?? ""}",
                  "assets/icons/support.svg",
                  Colors.deepPurple,
                  isDark: isDark,
                ),
              ),
            ],
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
                  "Total Users",
                  "${stats?.users.totalUsers ?? ""}",
                  'assets/icons/users.svg',
                  Colors.deepPurple,
                  isDark: isDark,
                ),
              ),
              const SpaceW10(),
              Expanded(
                child: statCard(
                  "Total Revenue",
                  stats?.totalRevenue != null
                      ? stats!.totalRevenue.toStringAsFixed(2)
                      : "",
                  'assets/icons/revanue.svg',
                  Colors.deepPurple,
                  isDark: isDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: statCard(
                  "Total Orders",
                  "${stats?.orders.totalOrders ?? ""}",
                  'assets/icons/Group.svg',
                  Colors.deepPurple,
                  isDark: isDark,
                ),
              ),
              const SpaceW10(),
              Expanded(
                child: statCard(
                  "Support Requests",
                  "${stats?.support.totalSupport ?? ""}",
                  "assets/icons/support.svg",
                  Colors.deepPurple,
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
            "Total Users",
            "${stats?.users.totalUsers ?? ""}",
            'assets/icons/users.svg',
            Colors.deepPurple,
            isDark: isDark,
          ),
          const SizedBox(height: 10),
          statCard(
            "Total Revenue",
            "${stats?.totalRevenue ?? ""}",
            'assets/icons/revanue.svg',
            Colors.deepPurple,
            isDark: isDark,
          ),
          const SizedBox(height: 10),
          statCard(
            "Total Orders",
            "${stats?.orders.totalOrders ?? ""}",
            'assets/icons/Group.svg',
            Colors.deepPurple,
            isDark: isDark,
          ),
          const SizedBox(height: 10),
          statCard(
            "Support Requests",
            "${stats?.support.totalSupport ?? ""}",
            "assets/icons/support.svg",
            Colors.deepPurple,
            isDark: isDark,
          ),
        ],
      );
    }
  }

  Widget _buildRequestAnalyticsChart(DashboardController controller,
      bool isDesktop, bool isTablet, bool isMobile, bool isDark) {
    return Container(
      height: isMobile
          ? 300
          : isTablet
              ? 340
              : 370,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF23272F) : Colors.transparent,
        border: Border.all(width: 0.4, color: Colors.grey),
        borderRadius: BorderRadius.circular(isMobile ? 16 : 25),
      ),
      padding: EdgeInsets.all(isMobile ? 12 : 16),
      child: RequestAnalyticsChart(
        controller: controller,
      ),
    );
  }

  Widget _buildChartsSection(DashboardController controller, bool isDesktop,
      bool isTablet, bool isMobile, bool isDark) {
    if (isDesktop) {
      return Row(
        children: [
          Expanded(
            child: Container(
              height: 420,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF23272F) : Colors.transparent,
                border: Border.all(width: 0.4, color: Colors.grey),
                borderRadius: BorderRadius.circular(25),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              child: RevanueChart(
                controller: controller,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Container(
              height: 420,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF23272F) : Colors.transparent,
                border: Border.all(width: 0.4, color: Colors.grey),
                borderRadius: BorderRadius.circular(25),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              child: SubscriberChart(
                controller: controller,
              ),
            ),
          ),
        ],
      );
    } else {
      // Tablet and Mobile: Stack charts vertically
      return Column(
        children: [
          Container(
            height: isMobile ? 320 : 360,
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF23272F) : Colors.transparent,
              border: Border.all(width: 0.4, color: Colors.grey),
              borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 16 : 24,
              vertical: 16,
            ),
            child: RevanueChart(
              controller: controller,
            ),
          ),
          SizedBox(height: isMobile ? 16 : 20),
          Container(
            height: isMobile ? 320 : 360,
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF23272F) : Colors.transparent,
              border: Border.all(width: 0.4, color: Colors.grey),
              borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 16 : 24,
              vertical: 16,
            ),
            child: SubscriberChart(
              controller: controller,
            ),
          ),
        ],
      );
    }
  }
}

import 'package:admin/controller/orders_management_controller/order_management.dart';
import 'package:admin/views/order_management/orders_list_widget/orders_list_widget.dart';
import 'package:admin/views/order_management/revenue_chart/order_revenue_chart.dart';
import 'package:admin/views/order_management/subscription_chart/subscription_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderManagement extends StatelessWidget {
  const OrderManagement({super.key});

  @override
  Widget build(BuildContext context) {
    final OrderManagementController controller =
        Get.put(OrderManagementController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isDesktop = screenWidth > 1200;
        final isTablet = screenWidth > 600 && screenWidth <= 1200;
        final isMobile = screenWidth <= 600;

        return SingleChildScrollView(
          padding: EdgeInsets.all(isMobile
              ? 16
              : isTablet
                  ? 20
                  : 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Obx(() => _buildStatCardsSection(controller, isDesktop, isTablet, isMobile, isDark)),
              SizedBox(
                  height: isMobile
                      ? 20
                      : isTablet
                          ? 24
                          : 30),
              _buildChartsSection(
                controller,
                isDesktop,
                isTablet,
                isMobile,
              ),
              SizedBox(
                  height: isMobile
                      ? 20
                      : isTablet
                          ? 24
                          : 30),
              Container(
                height: isMobile
                    ? 600
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
                child: OrdersListWidget(
                  controller: controller,
                  isMobile: isMobile,
                  isTablet: isTablet,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCardsSection(OrderManagementController controller,
      bool isDesktop, bool isTablet, bool isMobile, bool isDark) {
    if (controller.isLoadingStats.value) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (isDesktop) {
      return Row(
        children: [
          Expanded(
              child: _buildStatCard("Active Subscribers", "${controller.ordersStatsData.value?.activeSubscribers}", "28.4%",
                  true, "This month", Icons.group, Colors.blue, isDark)),
          SizedBox(width: isMobile ? 12 : 16),
          Expanded(
              child: _buildStatCard("Top Plan Type", "${controller.ordersStatsData.value?.topPlan.name}", "0.4%", true,
                  "This month", Icons.diamond, Colors.purple, isDark)),
        ],
      );
    } else if (isTablet) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: _buildStatCard("Active Subscribers", "2,500", "28.4%",
                      true, "All Time", Icons.group, Colors.blue, isDark)),
              SizedBox(width: 16),
              Expanded(
                  child: _buildStatCard(
                      "Expiring Soon",
                      "82",
                      "8.4%",
                      false,
                      "In next 24 hours",
                      Icons.access_time,
                      Colors.orange,
                      isDark)),
            ],
          ),
          SizedBox(height: 16),
          _buildStatCard("Top Plan Type", "Photo I", "0.4%", true, "All Time",
              Icons.diamond, Colors.purple, isDark),
        ],
      );
    } else {
      return Column(
        children: [
          _buildStatCard("Active Subscribers", "2,500", "28.4%", true,
              "All Time", Icons.group, Colors.blue, isDark),
          SizedBox(height: 12),
         
          _buildStatCard("Top Plan Type", "Photo I", "0.4%", true, "All Time",
              Icons.diamond, Colors.purple, isDark),
        ],
      );
    }
  }

  Widget _buildStatCard(
      String title,
      String value,
      String percentage,
      bool isPositive,
      String period,
      IconData icon,
      Color iconColor,
      bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF23272F) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey, width: 0.4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              // color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
             
              Text(
                period,
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartsSection(OrderManagementController controller,
      bool isDesktop, bool isTablet, bool isMobile) {
    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: RevenueChartWidget(
                controller: controller, isMobile: isMobile, isTablet: isTablet),
          ),
          const SizedBox(width: 24),
          Expanded(
            flex: 2,
            child: SubscriptionsChartWidget(
                controller: controller, isMobile: isMobile, isTablet: isTablet),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          RevenueChartWidget(
              controller: controller, isMobile: isMobile, isTablet: isTablet),
          SizedBox(height: isMobile ? 16 : 20),
          SubscriptionsChartWidget(
              controller: controller, isMobile: isMobile, isTablet: isTablet),
        ],
      );
    }
  }
}

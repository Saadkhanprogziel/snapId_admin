import 'package:admin/controller/dashboard_controller/dashboard_controller.dart';
import 'package:admin/views/dashboard/revanue_chart/revanue_chart.dart';
import 'package:admin/views/dashboard/subscriber_chart/subscriber_chart.dart';
import 'package:admin/utils/custom_spaces.dart';
import 'package:admin/utils/stat_card_widget.dart';
import 'package:admin/views/dashboard/request_analytics_chart/request_analytics_cart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController _dashboardController =
        Get.put(DashboardController());

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isDesktop = screenWidth > 1200;
        final isTablet = screenWidth > 600 && screenWidth <= 1200;
        final isMobile = screenWidth <= 600;

        return SingleChildScrollView(
          padding: EdgeInsets.all(isMobile ? 16 : isTablet ? 20 : 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Section: Stat Cards + Request Analytics Chart
                  _buildTopSection(_dashboardController, isDesktop, isTablet, isMobile),
                  
                  SizedBox(height: isMobile ? 20 : isTablet ? 25 : 30),

                  // Charts Section: Revenue & Subscriber Charts
                  _buildChartsSection(_dashboardController, isDesktop, isTablet, isMobile),
                  
                  SizedBox(height: isMobile ? 16 : isTablet ? 18 : 20),

                  // Activities Table Section
                  Container(
                    height: isMobile ? 400 : isTablet ? 450 : 500,
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.4, color: Colors.grey),
                      borderRadius: BorderRadius.circular(isMobile ? 16 : 25),
                    ),
                    child: TopCountriesWidget(
                      controller: _dashboardController,
                      isMobile: isMobile,
                      isTablet: isTablet,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopSection(DashboardController controller, bool isDesktop, bool isTablet, bool isMobile) {
    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: _buildStatCardsGrid(isDesktop, isTablet, isMobile),
          ),
          const SizedBox(width: 20),
          Expanded(
            flex: 2,
            child: _buildRequestAnalyticsChart(controller, isDesktop, isTablet, isMobile),
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatCardsGrid(isDesktop, isTablet, isMobile),
          SizedBox(height: isMobile ? 16 : 20),
          _buildRequestAnalyticsChart(controller, isDesktop, isTablet, isMobile),
        ],
      );
    }
  }

  Widget _buildStatCardsGrid(bool isDesktop, bool isTablet, bool isMobile) {
    if (isDesktop) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: statCard(
                  "Total Users",
                  "12,480",
                  'assets/icons/users.svg',
                  Colors.deepPurple,
                ),
              ),
              const SpaceW10(),
              Expanded(
                child: statCard(
                  "Total Revenue",
                  "\$84,310",
                  'assets/icons/revanue.svg',
                  Colors.deepPurple,
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
                  "318",
                  'assets/icons/Group.svg',
                  Colors.deepPurple,
                ),
              ),
              const SpaceW10(),
              Expanded(
                child: statCard(
                  "Support Requests",
                  "100",
                  "assets/icons/support.svg",
                  Colors.deepPurple,
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
                  "12,480",
                  'assets/icons/users.svg',
                  Colors.deepPurple,
                ),
              ),
              const SpaceW10(),
              Expanded(
                child: statCard(
                  "Total Revenue",
                  "\$84,310",
                  'assets/icons/revanue.svg',
                  Colors.deepPurple,
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
                  "318",
                  'assets/icons/Group.svg',
                  Colors.deepPurple,
                ),
              ),
              const SpaceW10(),
              Expanded(
                child: statCard(
                  "Support Requests",
                  "100",
                  "assets/icons/support.svg",
                  Colors.deepPurple,
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
            "12,480",
            'assets/icons/users.svg',
            Colors.deepPurple,
          ),
          const SizedBox(height: 10),
          statCard(
            "Total Revenue",
            "\$84,310",
            'assets/icons/revanue.svg',
            Colors.deepPurple,
          ),
          const SizedBox(height: 10),
          statCard(
            "Total Orders",
            "318",
            'assets/icons/Group.svg',
            Colors.deepPurple,
          ),
          const SizedBox(height: 10),
          statCard(
            "Support Requests",
            "100",
            "assets/icons/support.svg",
            Colors.deepPurple,
          ),
        ],
      );
    }
  }

  Widget _buildRequestAnalyticsChart(DashboardController controller, bool isDesktop, bool isTablet, bool isMobile) {
    return Container(
      height: isMobile ? 300 : isTablet ? 340 : 370,
      decoration: BoxDecoration(
        border: Border.all(width: 0.4, color: Colors.grey),
        borderRadius: BorderRadius.circular(isMobile ? 16 : 25),
      ),
      padding: EdgeInsets.all(isMobile ? 12 : 16),
      child: RequestAnalyticsChart(
        controller: controller,
      ),
    );
  }

  Widget _buildChartsSection(DashboardController controller, bool isDesktop, bool isTablet, bool isMobile) {
    if (isDesktop) {
      return Row(
        children: [
          Expanded(
            child: Container(
              height: 420,
              decoration: BoxDecoration(
                border: Border.all(width: 0.4, color: Colors.grey),
                borderRadius: BorderRadius.circular(25),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
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
                border: Border.all(width: 0.4, color: Colors.grey),
                borderRadius: BorderRadius.circular(25),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
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

class TopCountriesWidget extends StatelessWidget {
  final DashboardController controller;
  final bool isMobile;
  final bool isTablet;
  
  const TopCountriesWidget({
    Key? key, 
    required this.controller,
    this.isMobile = false,
    this.isTablet = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : isTablet ? 20 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Section
          if (!isMobile) ...[
            Text(
              'Recent Activities',
              style: TextStyle(
                fontSize: isTablet ? 18 : 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            SizedBox(height: isMobile ? 16 : isTablet ? 20 : 24),
          ],

          // Table Header
          _buildTableHeader(),

          SizedBox(height: isMobile ? 8 : 12),

          // Table Content
          Expanded(
            child: ListView.builder(
              itemCount: controller.dummyActivities.length,
              itemBuilder: (context, index) {
                final activity = controller.dummyActivities[index];
                return _buildTableRow(activity);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    if (isMobile) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: const Row(
          children: [
            Expanded(flex: 2, child: Text('Name', style: _headerStyle)),
            Expanded(flex: 3, child: Text('Activity', style: _headerStyle)),
            Expanded(flex: 2, child: Text('Platform', style: _headerStyle)),
            SizedBox(width: 60, child: Text('Actions', style: _headerStyle)),
          ],
        ),
      );
    } else if (isTablet) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: const Row(
          children: [
            Expanded(flex: 2, child: Text('Time', style: _headerStyle)),
            Expanded(flex: 2, child: Text('Name', style: _headerStyle)),
            Expanded(flex: 3, child: Text('Email', style: _headerStyle)),
            Expanded(flex: 2, child: Text('Activity', style: _headerStyle)),
            SizedBox(width: 80, child: Text('Actions', style: _headerStyle)),
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: const Row(
          children: [
            Expanded(flex: 2, child: Text('Time', style: _headerStyle)),
            Expanded(flex: 2, child: Text('Name', style: _headerStyle)),
            Expanded(flex: 3, child: Text('Email Address', style: _headerStyle)),
            Expanded(flex: 2, child: Text('Activity', style: _headerStyle)),
            Expanded(flex: 1, child: Text('Platform', style: _headerStyle)),
            SizedBox(width: 80, child: Text('Actions', style: _headerStyle)),
          ],
        ),
      );
    }
  }

  Widget _buildTableRow(dynamic activity) {
    final padding = isMobile ? 8.0 : isTablet ? 12.0 : 16.0;
    
    if (isMobile) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: padding, vertical: 12),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1)),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.name,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    activity.time,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                activity.activity,
                style: const TextStyle(fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                activity.plateform,
                style: const TextStyle(fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
              width: 60,
              child: _buildActionButton(activity),
            ),
          ],
        ),
      );
    } else if (isTablet) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: padding, vertical: 14),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1)),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                activity.time,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                activity.name,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                activity.email,
                style: const TextStyle(fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                activity.activity,
                style: const TextStyle(fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
              width: 80,
              child: _buildActionButton(activity),
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: padding, vertical: 16),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1)),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                activity.time,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                activity.name,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                activity.email,
                style: const TextStyle(fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                activity.activity,
                style: const TextStyle(fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                activity.plateform,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            SizedBox(
              width: 80,
              child: _buildActionButton(activity),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildActionButton(dynamic activity) {
    return GestureDetector(
      onTap: () {
        print('View ${activity.name}');
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 6 : 8,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: const Color.fromARGB(25, 96, 66, 255),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isMobile) ...[
              const Text("View", style: TextStyle(fontSize: 12)),
              const SizedBox(width: 4),
            ],
            Icon(
              isMobile ? Icons.visibility : Icons.arrow_forward_ios,
              size: isMobile ? 16 : 12,
              color: Colors.grey.shade700,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String title, int index, bool isSelected) {
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
        children: [
          if (isSelected) ...[
            const Icon(Icons.flag_outlined, color: Colors.white, size: 16),
            const SizedBox(width: 8),
          ] else ...[
            const Icon(Icons.person_outline, color: Colors.grey, size: 16),
            const SizedBox(width: 8),
          ],
          Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey.shade700,
              fontSize: isMobile ? 12 : 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtonGeneric(IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        if (label == 'Export') {
          print('Export clicked');
        } else {
          print('Filter clicked');
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 8 : 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.grey.shade600, size: 16),
            if (label.isNotEmpty && !isMobile) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 14,
                ),
              ),
            ],
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
}
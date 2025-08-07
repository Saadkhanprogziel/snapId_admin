import 'package:admin/controller/analytics_controller/analytics_controller.dart';

import 'package:admin/utils/custom_spaces.dart';
import 'package:admin/utils/stat_card_widget.dart';
import 'package:admin/views/analytics/analytics_list_widget/analytics_list_widget.dart';
import 'package:admin/views/analytics/document_chart/document_chart.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Analytics extends StatelessWidget {
  const Analytics({super.key});

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

        return SingleChildScrollView(
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

                  // Chart Section
                  _buildChartSection(
                      analyticsController, isDesktop, isTablet, isMobile),

                  SizedBox(
                      height: isMobile
                          ? 16
                          : isTablet
                              ? 20
                              : 24),

                  // Top Countries/Buyers Section LIST WIDGET
                  Container(
                    height: isMobile
                        ? 400
                        : isTablet
                            ? 450
                            : 500,
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.4, color: Colors.grey),
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
        );
      },
    );
  }

  Widget _buildStatCardsSection(bool isDesktop, bool isTablet, bool isMobile) {
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
          ),
          const SpaceH10(),
          statCard(
            name: "Amelia Liam",
            "Top Buyer By Revenue",
            "318",
            'assets/icons/revanue.svg',
            Colors.deepPurple,
            analytics: true,
          ),
          const SpaceH10(),
          statCard(
            "Top Buyer by Orders",
            "100",
            "assets/icons/Group.svg",
            Colors.deepPurple,
            name: "Tripti Dimri",
            analytics: true,
          ),
        ],
      );
    }
  }

  Widget _buildChartSection(AnalyticsController analyticsController,
      bool isDesktop, bool isTablet, bool isMobile) {
    return Container(
      height: isMobile
          ? 300
          : isTablet
              ? 300
              : 320,
      decoration: BoxDecoration(
        border: Border.all(width: 0.4, color: Colors.grey),
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
                    .allData[analyticsController.selectedPeriod.value] ??
                [],
            selectedPeriod: analyticsController.selectedPeriod.value,
            onPeriodChanged: (value) {
              analyticsController.selectedPeriod.value = value;
            },
          )),
    );
  }
}

class ManageUsersContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Manage Users Content", style: TextStyle(fontSize: 24)),
    );
  }
}

import 'package:admin/controller/app_controller.dart';
import 'package:admin/controller/recent_activities_controller/recent_activites_contoller.dart';
import 'package:admin/models/chartsTablesModel.dart';
import 'package:admin/utils/custom_spaces.dart';
import 'package:admin/views/user_management/user_details/user_detail_info_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Main Activity page
class Activity extends StatelessWidget {
  const Activity({super.key});

  @override
  Widget build(BuildContext context) {
    final RecentActivitesContoller controller =
        Get.put(RecentActivitesContoller());
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor:
          isDark ? Theme.of(context).scaffoldBackgroundColor : Colors.white,
      body: Container(
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? Color(0xFF23272F) : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
                  border: Border.all(width: 0.4, color: isDark ? Colors.grey.shade600 : Colors.grey),
),
        child: RecentActivities(
          controller: controller,
          isMobile: MediaQuery.of(context).size.width < 600,
          isTablet: MediaQuery.of(context).size.width >= 600 &&
              MediaQuery.of(context).size.width < 1024,
        ),
      ),
    );
  }
}

// Recent Activities table widget
class RecentActivities extends StatelessWidget {
  final RecentActivitesContoller controller;
  final bool isMobile;
  final bool isTablet;

  const RecentActivities({
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
          _buildHeaderSection(),
          SpaceH15(),
          // here we will add search bar and filter
          _buildTableHeader(),
          SizedBox(height: isMobile ? 8 : 12),
          Expanded(
            child: ListView.builder(
              itemCount: controller.dummyActivities.length,
              itemBuilder: (context, index) {
                final activity = controller.dummyActivities[index];
                return _buildTableRow(activity,isDark);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Row(
            children: [
          
              Expanded(child: _buildActionButton(Icons.filter_list, "Filter")),
            ],
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            children: [
              // 🔍 Search Bar
              SizedBox(
                width: 250,
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
                    hintText: 'Search users...',
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1, // thin border
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1, // thin border
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(
                        color: Colors
                            .grey.shade300, // same thin grey border on focus
                        width: 1,
                      ),
                    ),
                    isDense: true,
                  ),
                  onChanged: (value) {
                    // controller.filterUsers(value);
                  },
                ),
              ),

              const SizedBox(width: 8),
              _buildActionButton(Icons.filter_list, "Filter"),
            ],
          ),
        ],
      );
    }
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
            Expanded(
                flex: 3, child: Text('Email Address', style: _headerStyle)),
            Expanded(flex: 2, child: Text('Activity', style: _headerStyle)),
            Expanded(flex: 1, child: Text('Platform', style: _headerStyle)),
            SizedBox(width: 80, child: Text('Actions', style: _headerStyle)),
          ],
        ),
      );
    }
  }

  Widget _buildTableRow(UserActivityModel activity, bool isDark) {
    final padding = isMobile
        ? 8.0
        : isTablet
            ? 12.0
            : 16.0;

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
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(activity.name,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis),
                  Text(activity.time,
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(activity.activity,
                  style: const TextStyle(fontSize: 14),
                  overflow: TextOverflow.ellipsis),
            ),
            Expanded(
              flex: 2,
              child: Text(activity.plateform,
                  style: const TextStyle(fontSize: 14),
                  overflow: TextOverflow.ellipsis),
            ),
            SizedBox(
                width: 60, child: _buildActionButton(Icons.visibility, "View", isDark: isDark)),
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
          children: [
            Expanded(flex: 2, child: Text(activity.time)),
            Expanded(flex: 2, child: Text(activity.name)),
            Expanded(flex: 3, child: Text(activity.email)),
            Expanded(flex: 2, child: Text(activity.activity)),
            SizedBox(
                width: 80, child: _buildActionButton(Icons.visibility, "View",  isDark: isDark)),
          ],
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: padding, vertical: 16),
        decoration: BoxDecoration(
          border: Border(
              top: BorderSide(
                  color: isDark ? Colors.grey.shade600 : Colors.grey,
                  width: 0.5)),
        ),
        child: Row(
          children: [
            Expanded(flex: 2, child: Text(activity.time)),
            Expanded(flex: 2, child: Text(activity.name)),
            Expanded(flex: 3, child: Text(activity.email)),
            Expanded(flex: 2, child: Text(activity.activity)),
            Expanded(flex: 1, child: Text(activity.plateform)),
            SizedBox(
                width: 80, child: _buildActionButton(Icons.visibility, "View", isDark: isDark)),
          ],
        ),
      );
    }
  }

  Widget _buildActionButton(IconData icon, String label,{bool isDark= false}) {
    final drawerController = Get.find<AppController>();

    return InkWell(
      onTap: () {
        drawerController.setDrawerContent(UserInfoContent());
        drawerController.toggleDrawer();
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 6 : 8,
          vertical: isMobile ? 6 : 8,
        ),
        decoration: BoxDecoration(
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
                style: TextStyle(
                  // color: Colors.grey.shade700,
                  fontSize: isTablet ? 12 : 14,
                ),
              ),
              const SizedBox(width: 6),
            ],
            Icon(
              icon,
              color: isDark ? Colors.white: Colors.grey.shade600,
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
}

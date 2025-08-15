import 'package:admin/controller/app_controller.dart';
import 'package:admin/controller/user_management_controller/user_info_detail_controller/user_info_detail_controller.dart';
import 'package:admin/models/chartsTablesModel.dart';
import 'package:admin/theme/text_theme.dart';

import 'package:admin/utils/custom_spaces.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserInfoContent extends StatelessWidget {
  final UserModel? userModel;
  const UserInfoContent({super.key, this.userModel});

  @override
  Widget build(BuildContext context) {
    final UserInfoDetailController userInfoController =
        Get.put(UserInfoDetailController());
        final AppController drawerController = Get.find<AppController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? Theme.of(context).scaffoldBackgroundColor : Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
        child: Column(
          children: [
            SpaceH20(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => {
                    drawerController.closeDrawer(),
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isDark ? Color(0xFF23272F) : const Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child:  Icon(
                          Icons.arrow_forward,
                          size: 18,
                          color: isDark ? Colors.white : Color(0xFF6B7280),
                        ),
                      ),
                      SpaceW20(),
                      Text(
                        "User information",
                        style: CustomTextTheme.regular20.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Block",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.block,
                        size: 16,
                        color: Colors.red,
                      ),
                    ],
                  ),
                )
              ],
            ),
            SpaceH40(),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sidebar
                  Container(
                    width: 300,
                    child: Column(
                      children: [
                        Obx(() => _buildSidebarItem(
                              title: 'Basic Info',
                              icon: Icons.person_outline,
                              isActive:
                                  userInfoController.selectedScreen.value ==
                                      'Basic Info',
                              isDark: isDark,
                              onTap: () =>
                                  userInfoController.changeScreen('Basic Info'),
                            )),
                        const SizedBox(height: 8),
                        Obx(() => _buildSidebarItem(
                              title: 'Orders',
                              icon: Icons.receipt_long_outlined,
                              isActive:
                                  userInfoController.selectedScreen.value ==
                                      'Orders',
                              isDark: isDark,
                              onTap: () =>
                                  userInfoController.changeScreen('Orders'),
                            )),
                        const SizedBox(height: 8),
                        Obx(() => _buildSidebarItem(
                              title: 'Activity',
                              icon: Icons.trending_up_outlined,
                              isActive:
                                  userInfoController.selectedScreen.value ==
                                      'Activity',
                              isDark: isDark,
                              onTap: () =>
                                  userInfoController.changeScreen('Activity'),
                            )),
                        const SizedBox(height: 8),
                        Obx(() => _buildSidebarItem(
                              title: 'Moderation History',
                              icon: Icons.security_outlined,
                              isActive:
                                  userInfoController.selectedScreen.value ==
                                      'Moderation History',
                              isDark: isDark,
                              onTap: () => userInfoController
                                  .changeScreen('Moderation History'),
                            )),
                      ],
                    ),
                  ),

                  SizedBox(width: 20),

                  // Main Content Area
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                       color: isDark ? Color(0xFF23272F) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        
                        border:
                            Border.all(width: 0.5, color: Colors.grey.shade500),
                        
                      ),
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(() => Text(
                                userInfoController.selectedScreen.value,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1F2937),
                                ),
                              )),
                          const SizedBox(height: 30),
                          Expanded(
                            child: Obx(() {
                              if (userInfoController.selectedScreen.value ==
                                  'Basic Info') {
                                return _buildBasicInfoContent();
                              } else if (userInfoController
                                      .selectedScreen.value ==
                                  'Orders') {
                                return _buildOrdersContent(userInfoController);
                              } else if (userInfoController
                                      .selectedScreen.value ==
                                  'Activity') {
                                return _buildActivityContent(
                                    userInfoController);
                              } else if (userInfoController
                                      .selectedScreen.value ==
                                  'Moderation History') {
                                return _buildModerationHistoryContent();
                              }
                              return const SizedBox();
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebarItem({
    required String title,
    required IconData icon,
    required bool isActive,
    VoidCallback? onTap,
    bool isDark = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF6366F1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: !isActive ? Border.all(width: 0.5,color: Colors.grey.shade500) : null,
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          icon,
          size: 20,
          color: isActive || isDark ? Colors.white : Colors.grey.shade600,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isActive || isDark ? Colors.white : Colors.grey.shade700,
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildBasicInfoContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Profile Picture Section
          Center(
            child: Column(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade300, width: 2),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: Container(
                      color: Colors.grey.shade200,
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Profile picture',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 40),

          // Form Fields
          Row(
            children: [
              Expanded(
                child: _buildFormField('Full Name', userModel?.name ?? ""),
              ),
              SizedBox(width: 20),
              Expanded(
                child: _buildFormField('Email Address', userModel?.email ?? ""),
              ),
            ],
          ),

          SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: _buildFormField('Country', userModel?.country ?? "United States"),
              ),
              SizedBox(width: 20),
              Expanded(
                child: _buildFormField('Signup Date', '12 April 2025'),
              ),
            ],
          ),

          SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: _buildFormField('Subscription Plan', userModel?.subscription ?? "Photo 1"),
              ),
              SizedBox(width: 20),
              Expanded(
                child: _buildFormField('User Platform', userModel?.platform ?? ""),
              ),
            ],
          ),

          SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: _buildFormField('Signup Method', userModel?.signupMethod ?? ""),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: userModel?.status?.toLowerCase() == "block" ? Colors.redAccent: Colors.green,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          userModel?.status ?? "Active",
                          style: TextStyle(
                            fontSize: 14,
                            color: userModel?.status?.toLowerCase() == "block" ? Colors.redAccent: Colors.green,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFormField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          initialValue: value,
          enabled: false,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildOrdersContent(UserInfoDetailController controller) {
    return Column(
      children: [
        // Orders Table
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              // Table Header
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  // color: Colors.grey.shade50,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(flex: 2, child: _buildTableHeader('Order ID')),
                    Expanded(
                        flex: 2,
                        child: _buildTableHeader(
                            'Notes')), // Updated to match OrderData
                    Expanded(flex: 2, child: _buildTableHeader('Subscription')),
                    Expanded(
                        flex: 1,
                        child: _buildTableHeader(
                            'Amount')), // Updated to match OrderData
                    Expanded(flex: 1, child: _buildTableHeader('Action')),
                  ],
                ),
              ),
              Container(
                height: 400,
                child: Obx(() {
                  const itemsPerPage = 10;
                  // final totalPages =
                  //     (controller.orderList.length / itemsPerPage)
                  //         .ceil(); // Use orderList.length
                  final currentPage = controller.currentPage.value;
                  final startIndex = currentPage * itemsPerPage;
                  final endIndex =
                      (startIndex + itemsPerPage) > controller.orderList.length
                          ? controller.orderList.length
                          : (startIndex + itemsPerPage);
                  final paginatedList =
                      controller.orderList.sublist(startIndex, endIndex);

                  return ListView.builder(
                    itemCount: paginatedList.length,
                    itemBuilder: (context, index) =>
                        _buildOrderRow(paginatedList[index]),
                  );
                }),
              ),
              Obx(() {
                const itemsPerPage = 10;
                final totalPages = (controller.orderList.length / itemsPerPage)
                    .ceil(); // Use orderList.length
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
                          color: currentPage > 0
                              ? Colors.grey.shade700
                              : Colors.grey.shade400,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Page ${currentPage + 1} of $totalPages',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 12,
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
        ),
      ],
    );
  }

  Widget _buildOrderRow(OrderData data) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              data.orderId,
              style: TextStyle(
                fontSize: 14,
                // color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              data.notes, // Changed from document to notes as per OrderData class
              style: TextStyle(
                fontSize: 14,
                // color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              data.subscription,
              style: TextStyle(
                fontSize: 14,
                // color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '\$${data.amount.toStringAsFixed(2)}', // Changed to display amount
              style: TextStyle(
                fontSize: 14,
                // color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {},
              child: Row(
                children: [
                  Text(
                    'View',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6366F1),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.arrow_outward,
                    size: 14,
                    color: Color(0xFF6366F1),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityContent(UserInfoDetailController controller) {
    return Column(
      children: [
        // Activity Table
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              // Table Header
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  // color: Colors.grey.shade50,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(flex: 3, child: _buildTableHeader('Date - Time')),
                    Expanded(flex: 3, child: _buildTableHeader('Activity')),
                    Expanded(flex: 2, child: _buildTableHeader('Platform')),
                  ],
                ),
              ),
              // Table Content
              Container(
                height: 400,
                child: Obx(() {
                  const itemsPerPage = 10;
                  // final totalPages =
                  //     (controller.getActivities.length / itemsPerPage).ceil();
                  final currentPage = controller.currentPage.value;
                  final startIndex = currentPage * itemsPerPage;
                  final endIndex = (startIndex + itemsPerPage) >
                          controller.getActivities.length
                      ? controller.getActivities.length
                      : (startIndex + itemsPerPage);
                  final paginatedList =
                      controller.getActivities.sublist(startIndex, endIndex);

                  return ListView.builder(
                    itemCount: paginatedList.length,
                    itemBuilder: (context, index) =>
                        _buildActivityRow(paginatedList[index]),
                  );
                }),
              ),
              Obx(() {
                const itemsPerPage = 10;
                final totalPages =
                    (controller.getActivities.length / itemsPerPage).ceil();
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
                          color: currentPage > 0
                              ? Colors.grey.shade700
                              : Colors.grey.shade400,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Page ${currentPage + 1} of $totalPages',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 12,
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
        ),
        // Pagination Controls
      ],
    );
  }

// Updated _buildActivityRow to accept a single activity object
  Widget _buildActivityRow(dynamic activity) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              activity.dateTime ?? 'N/A', // Adjust based on your data structure
              style: TextStyle(
                fontSize: 14,
                // color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              activity.activity ?? 'N/A', // Adjust based on your data structure
              style: TextStyle(
                fontSize: 14,
                // color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              activity.platform ?? 'N/A', // Adjust based on your data structure
              style: TextStyle(
                fontSize: 14,
                // color: Colors.grey.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        // color: Colors.grey.shade800,
      ),
    );
  }

  Widget _buildModerationHistoryContent() {
    return Column(
      children: [
        // Moderation History Table
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              // Table Header
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  // color: Colors.grey.shade50,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(flex: 3, child: _buildTableHeader('Date - Time')),
                    Expanded(flex: 2, child: _buildTableHeader('Action Taken')),
                    Expanded(
                        flex: 3, child: _buildTableHeader('Reason Provided')),
                  ],
                ),
              ),
              // Table Rows
              _buildModerationRow(
                  'May 30, 2025 — 2:45 PM', 'Reactivated', '--'),
              _buildModerationRow('May 30, 2025 — 2:45 PM', 'Block',
                  'Repeated chargeback activity'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildModerationRow(String dateTime, String action, String reason) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              dateTime,
              style: TextStyle(
                fontSize: 14,
                // color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              action,
              style: TextStyle(
                fontSize: 14,
                // color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              reason,
              style: TextStyle(
                fontSize: 14,
                // color: Colors.grey.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

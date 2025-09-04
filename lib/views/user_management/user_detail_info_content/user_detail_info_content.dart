import 'package:admin/controller/app_controller.dart';
import 'package:admin/controller/user_management_controller/user_info_detail_controller/user_info_detail_controller.dart';
import 'package:admin/models/users/users_model.dart';
import 'package:admin/models/users/users_order_data.dart';
import 'package:admin/theme/text_theme.dart';
import 'package:admin/utils/custom_spaces.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserInfoContent extends StatelessWidget {
  final UsersModel? userModel;
  const UserInfoContent({super.key, this.userModel});

  @override
  Widget build(BuildContext context) {
    final UserInfoDetailController userInfoController =
        Get.put(UserInfoDetailController());
    final AppController drawerController = Get.find<AppController>();

    if (userModel != null) {
      userInfoController.setUserModel(userModel!);
    }
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor:
          isDark ? Theme.of(context).scaffoldBackgroundColor : Colors.white,
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
                          color: isDark
                              ? Color(0xFF23272F)
                              : const Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
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
                InkWell(
                  onTap: (){
                    
                  },
                  child: Container(
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
                                return _buildOrdersDataTable(
                                    userInfoController, isDark);
                              } else if (userInfoController
                                      .selectedScreen.value ==
                                  'Moderation History') {
                                return _buildModerationHistoryDataTable(
                                    userInfoController, isDark);
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
        border: !isActive
            ? Border.all(width: 0.5, color: Colors.grey.shade500)
            : null,
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
                child: _buildFormField('Full Name', userModel?.firstName ?? ""),
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
                child: _buildFormField(
                    'Country', userModel?.country ?? "United States"),
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
                child: _buildFormField('Subscription Plan', "Photo 1"),
              ),
              SizedBox(width: 20),
              Expanded(
                child:
                    _buildFormField('User Platform', userModel?.platform ?? ""),
              ),
            ],
          ),

          SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: _buildFormField(
                    'Signup Method', userModel?.authProvider ?? ""),
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
                            color: userModel?.isActive?.toLowerCase() == "block"
                                ? Colors.redAccent
                                : Colors.green,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          userModel?.isActive ?? "Active",
                          style: TextStyle(
                            fontSize: 14,
                            color: userModel?.isActive?.toLowerCase() == "block"
                                ? Colors.redAccent
                                : Colors.green,
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

  Widget _buildOrdersDataTable(
      UserInfoDetailController controller, bool isDark) {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Obx(() {
                const itemsPerPage = 10;
                final currentPage = controller.currentPage.value;
                final startIndex = currentPage * itemsPerPage;
                final endIndex = (startIndex + itemsPerPage) >
                        controller.orderList.value.length
                    ? controller.orderList.value.length
                    : (startIndex + itemsPerPage);
                final paginatedList =
                    controller.orderList.value.sublist(startIndex, endIndex);

                return Column(
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: double
                            .infinity, // 👈 Forces table to stretch horizontally
                        child: DataTable(
                          headingRowHeight: 60,
                          columnSpacing: 60,
                          horizontalMargin: 24,
                          decoration: BoxDecoration(
                            color: isDark ? Color(0xFF23272F) : Colors.white,
                          ),
                          headingRowColor: MaterialStateProperty.all(
                            isDark ? Color(0xFF1A1D23) : Colors.grey.shade50,
                          ),
                          columns: const [
                            DataColumn(label: Text('Plan')),
                            DataColumn(label: Text('Status')),
                            DataColumn(label: Text('Platform')),
                            DataColumn(label: Text('Amount'), numeric: true),
                          ],
                          rows: paginatedList.map((order) {
                            return DataRow(cells: [
                              DataCell(Text(order.planId)),
                              DataCell(Text(order.status)),
                              DataCell(Text(order.platform)),
                              DataCell(Text(
                                  '${order.currency} ${order.amount.toStringAsFixed(2)}')),
                            ]);
                          }).toList(),
                        ),
                      ),
                    ),

                    // Pagination Controls
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      decoration: BoxDecoration(
                        color: isDark ? Color(0xFF1A1D23) : Colors.grey.shade50,
                        border: Border(
                          top: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      child: Obx(() {
                        const itemsPerPage = 10;
                        final totalPages =
                            (controller.orderList.value.length / itemsPerPage)
                                .ceil();
                        final currentPage = controller.currentPage.value;

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Showing ${startIndex + 1}-${endIndex} of ${controller.orderList.value.length} results',
                              style: TextStyle(
                                color: isDark
                                    ? Colors.white70
                                    : Colors.grey.shade600,
                                fontSize: 14,
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: currentPage > 0
                                      ? () => controller.currentPage.value--
                                      : null,
                                  icon: Icon(
                                    Icons.chevron_left,
                                    color: currentPage > 0
                                        ? (isDark
                                            ? Colors.white
                                            : Colors.grey.shade700)
                                        : Colors.grey.shade400,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? Color(0xFF23272F)
                                        : Colors.white,
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    '${currentPage + 1} of $totalPages',
                                    style: TextStyle(
                                      color: isDark
                                          ? Colors.white
                                          : Colors.grey.shade700,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: currentPage < totalPages - 1
                                      ? () => controller.currentPage.value++
                                      : null,
                                  icon: Icon(
                                    Icons.chevron_right,
                                    color: currentPage < totalPages - 1
                                        ? (isDark
                                            ? Colors.white
                                            : Colors.grey.shade700)
                                        : Colors.grey.shade400,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModerationHistoryDataTable(
      UserInfoDetailController userInfoController, bool isDark) {
        
    return Column(
      children: [
        Expanded(
          child: SizedBox(
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: DataTable(
                  headingRowHeight: 60,
                  columnSpacing: 32,
                  horizontalMargin: 24,
                  decoration: BoxDecoration(
                    color: isDark ? Color(0xFF23272F) : Colors.white,
                  ),
                  headingRowColor: MaterialStateProperty.all(
                    isDark ? Color(0xFF1A1D23) : Colors.grey.shade50,
                  ),
                  columns: [
                    DataColumn(label: Text('Date - Time')),
                    DataColumn(label: Text('Action Taken')),
                    DataColumn(label: Text('Reason Provided')),
                  ],
                  rows: userInfoController.moderationList.value.map((moderation) {
                    return DataRow(cells: [
                      DataCell(Text(moderation.performedAt.toIso8601String())),
                      DataCell(Text(moderation.actionType,style:  TextStyle(color: _getStatusColor(moderation.actionType)),)),
                      DataCell(Text(moderation.reason)),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Helper method to get status color
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'unblock':
      case 's':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
      case 'cancelled' || "deleted":
        return Colors.red;
      case 'processing':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  // Helper method to get action color for moderation history
  Color _getActionColor(String action) {
    switch (action.toLowerCase()) {
      case 'reactivated' || "unblocked":
        return Colors.green;
      case 'block':
        return Colors.red;
      case 'warning':
        return Colors.orange;
      case 'temporary suspension':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}

import 'package:admin/controller/app_controller.dart';
import 'package:admin/controller/user_management_controller/user_management_controller.dart';
import 'package:admin/models/users/users_model.dart';
import 'package:admin/views/support/filter_panel.dart';
import 'package:admin/views/user_management/user_detail_info_content/user_detail_info_content.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UsersListWidget extends StatelessWidget {
  final UserManagementController controller;
  final bool isMobile;
  final bool isTablet;

   UsersListWidget({
    Key? key,
    required this.controller,
    this.isMobile = false,
    this.isTablet = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appController = Get.find<AppController>();
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(isMobile
              ? 16
              : isTablet
                  ? 20
                  : 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderSection(context),
              const SizedBox(height: 20),
        
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
        
                  if (controller.orderList.isEmpty) {
                    return const Center(
                      child: Text(
                        'No users found',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }
        
                  return Column(
                    children: [
                      Expanded(
                        child: DataTable2(
                          columnSpacing: 12,
                          horizontalMargin: 12,
                          minWidth: 800,
                          dataRowHeight: 70,
                          headingRowHeight: 56,
                          columns: [
                            DataColumn2(
                                label: const Text('Name'), size: ColumnSize.S),
                            DataColumn2(
                                label: const Text('Email'), size: ColumnSize.L),
                            DataColumn2(
                                label: const Text('Phone'), size: ColumnSize.L),
                            DataColumn2(
                                label: const Text('Created Date'),
                                size: ColumnSize.M),
                            DataColumn2(
                                label: const Text('Credits'), size: ColumnSize.S),
                            DataColumn2(
                                label: const Text('Auth Provider'),
                                size: ColumnSize.S),
                            DataColumn2(
                                label: const Text('Platform'), size: ColumnSize.S),
                            DataColumn2(
                                label: const Text('Status'), size: ColumnSize.S),
                            DataColumn2(
                                label: const Text('Actions'), size: ColumnSize.S),
                          ],
                          rows: controller.orderList.map((user) {
                            return DataRow(cells: [
                              DataCell(Text("${user.firstName} ${user.lastName}")),
                              DataCell(Text(user.email)),
                              DataCell(Text(user.phoneNo)),
                              DataCell(Text(_formatDate(user.createdAt))),
                              DataCell(Text('${user.credits}')),
                              DataCell(Text(user.authProvider)),
                              DataCell(Text(user.platform)),
                              DataCell(_buildStatusChip(user.isActive)),
                              DataCell(
                                _buildActionButton(
                                    Icons.visibility, "View", context,
                                    userModel: user),
                              ),
                            ]);
                          }).toList(),
                        ),
                      ),
        
                      // 🔹 Pagination Controls
                      Obx(() {
                        final pagination = controller.pagination.value;
                        if (pagination == null) return const SizedBox();
        
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.chevron_left),
                                onPressed: controller.currentPage.value > 0
                                    ? () {
                                        controller.currentPage.value--;
                                        controller.fetchUserStatsData();
                                      }
                                    : null,
                              ),
                              Text(
                                "Page ${controller.currentPage.value + 1} of ${pagination.totalPages}",
                                style: const TextStyle(fontSize: 14),
                              ),
                              IconButton(
                                icon: const Icon(Icons.chevron_right),
                                onPressed: controller.currentPage.value <
                                        pagination.totalPages - 1
                                    ? () {
                                        controller.currentPage.value++;
                                        controller.fetchUserStatsData();
                                      }
                                    : null,
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  );
                }),
              ),
             
            ],
          ),
        ),
         Obx(() => appController.showFilter.value
                  ? GestureDetector(
                      onTap: () => appController.showFilter.value = false,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: appController.showFilter.value ? 0.5 : 0.0,
                        child: Container(
                          color: Colors.transparent,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                    )
                  : const SizedBox.shrink()),
        
              // Filter Panel should always be topmost
              CommonFilterPanel(
                isDark: isDark,
                filterContent: _buildFilterPanel(context, isDark, appController),
              )
      ],
    );
  }


    Widget _buildFilterPanel(
      BuildContext context, bool isDark, AppController appController) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text('Status:',
              style: TextStyle(color: isDark ? Colors.white : Colors.black)),
          const SizedBox(height: 12),
          Obx(() => DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDark ? const Color(0xFF23272F) : Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                value: controller.selectedStatus.value,
                items: controller.statusFilter
                    .map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        ))
                    .toList(),
                onChanged: (value) {
                  controller.selectedStatus.value = value ?? '';
                },
              )),
          const SizedBox(height: 16),

          // 🔹 Sort filter
          Text('Sort by:',
              style: TextStyle(color: isDark ? Colors.white : Colors.black)),
          const SizedBox(height: 12),
          Obx(() => DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDark ? const Color(0xFF23272F) : Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                value: controller.selectedSort.value,
                items: controller.sortFilter
                    .map((sort) => DropdownMenuItem(
                          value: sort,
                          child: Text(sort),
                        ))
                    .toList(),
                onChanged: (value) {
                  controller.selectedSort.value = value ?? '';
                },
              )),
          const SizedBox(height: 16),

          // 🔹 Subscription filter
          Text('Subscription:',
              style: TextStyle(color: isDark ? Colors.white : Colors.black)),
          const SizedBox(height: 12),
          Obx(() => DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDark ? const Color(0xFF23272F) : Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                value: controller.selectedSubscription.value,
                items: controller.subscriptionFilter
                    .map((sub) => DropdownMenuItem(
                          value: sub,
                          child: Text(sub),
                        ))
                    .toList(),
                onChanged: (value) {
                  controller.selectedSubscription.value = value ?? '';
                },
              )),
          const SizedBox(height: 16),

          // 🔹 Date Range Picker
          Text('Date Range:',
              style: TextStyle(color: isDark ? Colors.white : Colors.black)),
          const SizedBox(height: 12),

          Obx(() {
            final range = controller.selectedDateRange.value;
            final text = range == null
                ? "Select date range"
                : "${range.start.toString().split(' ')[0]} → ${range.end.toString().split(' ')[0]}";

            return InkWell(
              onTap: () => showDateRangeDialog(context, controller),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF23272F) : Colors.white,
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      text,
                      style: TextStyle(
                        color: text == "Select date range"
                            ? Colors.grey
                            : (isDark ? Colors.white : Colors.black),
                      ),
                    ),
                    const Icon(Icons.date_range, color: Colors.grey),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 16),

          // 🔹 Platform filter
          Text('Platform:',
              style: TextStyle(color: isDark ? Colors.white : Colors.black)),
          const SizedBox(height: 12),
          Obx(() => DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDark ? const Color(0xFF23272F) : Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                value: controller.selectedPlatform.value,
                items: [
                  DropdownMenuItem(value: 'ALL', child: Text('ALL')),
                  DropdownMenuItem(
                      value: 'MOBILE_APP', child: Text('Mobile App')),
                  DropdownMenuItem(value: 'WEB_APP', child: Text('Web App')),
                ],
                onChanged: (value) {
                  controller.selectedPlatform.value = value ?? 'ALL';
                },
              )),

          const SizedBox(height: 24),

          // 🔹 Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  controller.selectedStatus.value = 'ALL';
                  controller.selectedSort.value = 'Newest';
                  controller.selectedSubscription.value = 'ALL';
                  controller.selectedPlatform.value = 'ALL';
                  controller.selectedDateRange.value = null;
                  // controller.dateRangeController.clear();

                  appController.showFilter.value = false;
                  controller.fetchUserStatsData();
                },
                child: const Row(
                  children: [
                    Icon(Icons.refresh, color: Colors.red),
                    SizedBox(width: 4),
                    Text('Reset', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  appController.showFilter.value = false;
                  // Print start and end date separately if selected
                  final range = controller.selectedDateRange.value;
                  if (range != null) {
                    print(
                        'Start Date: ${range.start.toString().split(' ')[0]}');
                    print('End Date: ${range.end.toString().split(' ')[0]}');
                  }
                  controller.fetchUserStatsData();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F46E5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Apply Filter',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> showDateRangeDialog(
      BuildContext context, UserManagementController controller) async {
    final theme = Theme.of(context);

    DateTime today = DateTime.now();
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate:
          DateTime(today.year, today.month, today.day), // Only allow past dates
      initialDateRange: controller.selectedDateRange.value,
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: const Color(0xFF4F46E5), // Brand color
              onPrimary: Colors.white,
              surface: theme.brightness == Brightness.dark
                  ? const Color(0xFF1E1E1E)
                  : Colors.white,
              onSurface: theme.brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
          ),
          child: Center(
            child: Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: 24, vertical: 24), // 👈 margin around dialog
              child: ConstrainedBox(
                constraints:
                    const BoxConstraints(maxWidth: 500, maxHeight: 600),
                child: Material(
                  borderRadius: BorderRadius.circular(12),
                  clipBehavior: Clip.antiAlias,
                  child: child!,
                ),
              ),
            ),
          ),
        );
      },
    );

    if (picked != null) {
      controller.selectedDateRange.value = picked;
    }
  }


  /// 🔹 Header with Search + Filter
  Widget _buildHeaderSection(BuildContext context) {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "All Users",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildSearchBar(),
              ),
              const SizedBox(width: 10),
              _buildActionButton(Icons.filter_list, "Filter", context),
            ],
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "All Users",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          Row(
            children: [
              SizedBox(width: 250, child: _buildSearchBar()),
              const SizedBox(width: 12),
              _buildActionButton(Icons.filter_list, "Filter", context),
            ],
          ),
        ],
      );
    }
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
        hintText: 'Search users...',
        hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade500),
        contentPadding: const EdgeInsets.symmetric(vertical: 0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
        ),
        isDense: true,
      ),
      onChanged: (value) {
        controller.filterUsers(value);
      },
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  /// 🔹 Responsive Status Chip
  Widget _buildStatusChip(String status) {
    bool isBlocked = (status.toLowerCase()) == "block";
    bool isActive = (status.toLowerCase()) == "active";

    Color bgColor;
    Color dotColor;
    Color textColor;

    if (isBlocked) {
      bgColor = Colors.red.withOpacity(0.1);
      dotColor = Colors.red;
      textColor = Colors.red.shade800;
    } else if (isActive) {
      bgColor = Colors.green.withOpacity(0.1);
      dotColor = Colors.green;
      textColor = Colors.green.shade800;
    } else {
      bgColor = Colors.grey.withOpacity(0.1);
      dotColor = Colors.grey;
      textColor = Colors.grey.shade700;
    }

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 6 : 8, vertical: isMobile ? 2 : 4),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                width: 8,
                height: 8,
                decoration:
                    BoxDecoration(color: dotColor, shape: BoxShape.circle)),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                status,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: isMobile ? 10 : 12,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Responsive Action Button
  Widget _buildActionButton(IconData icon, String label, BuildContext context,
      {UsersModel? userModel}) {
    final drawerController = Get.find<AppController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        if (label == "Filter") {
          final appController = Get.find<AppController>();
          appController.showFilter.value = true;
        }
        if (userModel != null) {
          drawerController
              .setDrawerContent(UserInfoContent(userModel: userModel));
          drawerController.toggleDrawer();
        }
      },
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 8 : 10, vertical: isMobile ? 4 : 6),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.grey.shade700,
                  fontSize: isMobile ? 12 : (isTablet ? 12 : 14),
                ),
              ),
              const SizedBox(width: 6),
              Icon(
                icon,
                color: isDark ? Colors.white : Colors.grey.shade600,
                size: isMobile ? 14 : 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

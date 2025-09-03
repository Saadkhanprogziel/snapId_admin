import 'package:admin/controller/app_controller.dart';
import 'package:admin/controller/orders_management_controller/order_management.dart';
import 'package:admin/models/chartsTablesModel.dart';
import 'package:admin/theme/text_theme.dart';
import 'package:admin/views/order_management/order_info_content/order_info_content.dart';
import 'package:admin/views/support/filter_panel.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrdersListWidget extends StatelessWidget {
  final OrderManagementController controller;
  final bool isMobile;
  final bool isTablet;

  const OrdersListWidget({
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
              // Tabs and Actions Row
              _buildHeaderSection(context),
        
              SizedBox(
                  height: isMobile
                      ? 20
                      : isTablet
                          ? 24
                          : 32),
        
          //     Expanded(
          //   child: Obx(() {
          //     // if (controller.isLoading.value) {
          //     //   return const Center(child: CircularProgressIndicator());
          //     // }

          //     if (controller.orderList.isEmpty) {
          //       return const Center(
          //         child: Text(
          //           'No users found',
          //           style: TextStyle(fontSize: 16, color: Colors.grey),
          //         ),
          //       );
          //     }

          //     return Column(
          //       children: [
          //         Expanded(
          //           child: DataTable2(
          //             columnSpacing: 12,
          //             horizontalMargin: 12,
          //             minWidth: 800,
          //             dataRowHeight: 70,
          //             headingRowHeight: 56,
          //             columns: [
          //               DataColumn2(label: const Text('Name'), size: ColumnSize.S),
          //               DataColumn2(label: const Text('Email'), size: ColumnSize.L),
          //               DataColumn2(label: const Text('Phone'), size: ColumnSize.L),
          //               DataColumn2(label: const Text('Created Date'), size: ColumnSize.M),
          //               DataColumn2(label: const Text('Credits'), size: ColumnSize.S),
          //               DataColumn2(label: const Text('Auth Provider'), size: ColumnSize.S),
          //               DataColumn2(label: const Text('Platform'), size: ColumnSize.S),
          //               DataColumn2(label: const Text('Status'), size: ColumnSize.S),
          //               DataColumn2(label: const Text('Actions'), size: ColumnSize.S),
          //             ],
          //             rows: controller.orderList.map((user) {
          //               return DataRow(cells: [
          //                 DataCell(Text("${user.firstName} ${user.lastName}")),
          //                 DataCell(Text(user.email)),
          //                 DataCell(Text(user.phoneNo)),
          //                 DataCell(Text(_formatDate(user.createdAt))),
          //                 DataCell(Text('${user.credits}')),
          //                 DataCell(Text(user.authProvider)),
          //                 DataCell(Text(user.platform)),
          //                 DataCell(_buildStatusChip(user.isActive)),
          //                 DataCell(
          //                   _buildActionButton(Icons.visibility, "View", context, userModel: user),
          //                 ),
          //               ]);
          //             }).toList(),
          //           ),
          //         ),

          //         // 🔹 Pagination Controls
          //         Obx(() {
          //           final pagination = controller.pagination.value;
          //           if (pagination == null) return const SizedBox();

          //           return Padding(
          //             padding: const EdgeInsets.symmetric(vertical: 12),
          //             child: Row(
          //               mainAxisAlignment: MainAxisAlignment.center,
          //               children: [
          //                 IconButton(
          //                   icon: const Icon(Icons.chevron_left),
          //                   onPressed: controller.currentPage.value > 0
          //                       ? () {
          //                           controller.currentPage.value--;
          //                           controller.fetchUserStatsData();
          //                         }
          //                       : null,
          //                 ),
          //                 Text(
          //                   "Page ${controller.currentPage.value + 1} of ${pagination.totalPages}",
          //                   style: const TextStyle(fontSize: 14),
          //                 ),
          //                 IconButton(
          //                   icon: const Icon(Icons.chevron_right),
          //                   onPressed: controller.currentPage.value < pagination.totalPages - 1
          //                       ? () {
          //                           controller.currentPage.value++;
          //                           controller.fetchUserStatsData();
          //                         }
          //                       : null,
          //                 ),
          //               ],
          //             ),
          //           );
          //         }),
          //       ],
          //     );
          //   }),
          // ),
             
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
          filterContent: _buildFilterPanel(isDark, appController),
        )
      ],
    );
  }

  Widget _buildFilterButton(BuildContext context) {
    final drawerController = Get.find<AppController>();
    return InkWell(
      onTap: () {
        drawerController.showFilter.value = true;
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
            if (!isMobile) ...[
              Text(
                "Filter",
                style: TextStyle(
                  fontSize: isTablet ? 12 : 14,
                ),
              ),
              const SizedBox(width: 6),
            ],
            Icon(
              Icons.filter_list,
              size: isMobile ? 14 : 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterPanel(bool isDark, AppController appController) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Status:',
            style: TextStyle(color: isDark ? Colors.white : Colors.black)),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            filled: true,
            fillColor: isDark ? const Color(0xFF23272F) : Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          value: controller.selectedStatus.value,
          items:controller.status_filter
              .map((status) => DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  ))
              .toList(),
          onChanged: (value) {
            controller.selectedStatus.value = value ?? '';
          },
        ),
        const SizedBox(height: 16),
        Text('Sort by:',
            style: TextStyle(color: isDark ? Colors.white : Colors.black)),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            filled: true,
            fillColor: isDark ? const Color(0xFF23272F) : Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          value: controller.selectedSort.value,
          items: controller.sort_filter
              .map((sort) => DropdownMenuItem(
                    value: sort,
                    child: Text(sort),
                  ))
              .toList(),
          onChanged: (value) {
            controller.selectedSort.value = value ?? '';
          },
        ),
        const SizedBox(height: 16),
        Text('Subscription:',
            style: TextStyle(color: isDark ? Colors.white : Colors.black)),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            filled: true,
            fillColor: isDark ? const Color(0xFF23272F) : Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          value: controller.selectedSubscription.value,
          items: controller.subscription_filter
              .map((sub) => DropdownMenuItem(
                    value: sub,
                    child: Text(sub),
                  ))
              .toList(),
          onChanged: (value) {
            controller.selectedSubscription.value = value ?? '';
          },
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                // Reset filters logic here
                appController.showFilter.value = false;
              },
              child: Row(
                children: const [
                  Icon(Icons.refresh, color: Colors.red),
                  SizedBox(width: 4),
                  Text('Reset', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Apply filter logic here
                appController.showFilter.value = false;
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
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                  child: _buildFilterButton(context)),
            ],
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Orders",
            style: CustomTextTheme.regular20,
          ),
          Row(
            children: [
              // 🔍 Search Bar
              SizedBox(
                width: 250,
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
                    hintText: 'Search users...',
                    hintStyle:
                        TextStyle(fontSize: 12, color: Colors.grey.shade500),
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
              const SizedBox(width: 12),
              _buildFilterButton(context),
            ],
          ),
        ],
      );
    }
  }

  

  Widget _buildStatusChip(String? status) {
    bool isBlocked = (status ?? "").toLowerCase() == "failed";
    bool isActive = (status ?? "").toLowerCase() == "success" ||
        (status ?? "").toLowerCase() == "completed";

    Color bgColor;
    Color dotColor;
    Color textColor;

    if (isBlocked) {
      bgColor = Colors.red.withOpacity(0.1);
      dotColor = Colors.red;
      textColor = Colors.red;
    } else if (isActive) {
      bgColor = Colors.green.withOpacity(0.1);
      dotColor = Colors.green;
      textColor = Colors.green.shade800;
    } else {
      bgColor = Colors.grey.withOpacity(0.1);
      dotColor = Colors.grey;
      textColor = Colors.grey.shade700;
    }

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                status ?? "",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String label,
    BuildContext context, {
    OrderData? orderData,
  }) {    
    final drawerController = Get.find<AppController>();

    return InkWell(
      onTap: () {
        drawerController.setDrawerContent(OrderDetailScreen(orderData: orderData,));
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
                  fontSize: isTablet ? 12 : 14,
                ),
              ),
              const SizedBox(width: 6),
            ],
            Icon(
              icon,
              size: isMobile ? 14 : 16,
            ),
          ],
        ),
      ),
    );
  }

}
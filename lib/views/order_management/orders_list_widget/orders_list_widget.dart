import 'package:admin/controller/app_controller.dart';
import 'package:admin/controller/orders_management_controller/order_management_controller.dart';
import 'package:admin/models/orders/order_list_model.dart';
import 'package:admin/theme/text_theme.dart';
import 'package:admin/views/order_management/order_info_content/order_info_content.dart';
import 'package:admin/widgets/filter_panel.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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

              Expanded(
                child: Obx(() {
                  if (controller.isLoadingOrders.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (controller.isLoadingStats.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (controller.ordersData.isEmpty) {
                    return const Center(
                      child: Text(
                        'No orders found',
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
                          columns: const [
                            DataColumn2(
                                label: Text('Email'), size: ColumnSize.L),
                            DataColumn2(
                                label: Text('Plan Name'), size: ColumnSize.M),
                            DataColumn2(
                                label: Text('Amount'), size: ColumnSize.S),
                            DataColumn2(
                                label: Text('Currency'), size: ColumnSize.S),
                            DataColumn2(
                                label: Text('Platform'), size: ColumnSize.S),
                            DataColumn2(
                                label: Text('Created Date'),
                                size: ColumnSize.M),
                            DataColumn2(
                                label: Text('Status'), size: ColumnSize.L),
                            DataColumn2(
                                label: Text('Actions'), size: ColumnSize.S),
                          ],
                          rows: controller.ordersData.map((order) {
                            return DataRow(cells: [
                              DataCell(Text(order.email)),
                              DataCell(Text(order.planName.isEmpty
                                  ? "Single Purchase"
                                  : order.planName)),
                              DataCell(
                                  Text('\$${order.amount.toStringAsFixed(2)}')),
                              DataCell(Text(order.currency.toUpperCase())),
                              DataCell(Text(order.platform == "MOBILE_APP"
                                  ? "Mobile App"
                                  : "Web App")),
                              DataCell(Text(_formatDate(order.createdAt))),
                              DataCell(_buildStatusChip(order.status)),
                              DataCell(
                                _buildActionButton(
                                    Icons.visibility, "View", context,
                                    orderData: order),
                              ),
                            ]);
                          }).toList(),
                        ),
                      ),
                      // Pagination Controls
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
                                        controller.fetchOrdersStatsData();
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
                                        controller.fetchOrdersStatsData();
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
            Text(
              "Filter",
              style: TextStyle(
                fontSize: isTablet ? 12 : 14,
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              Icons.filter_list,
              size: isMobile ? 14 : 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterPanel(
      BuildContext context, bool isDark, AppController appController) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Status filter
          // Text('Status:',
          //     style: TextStyle(color: isDark ? Colors.white : Colors.black)),
          // const SizedBox(height: 12),
          // Obx(() => DropdownButtonFormField<String>(
          //       decoration: InputDecoration(
          //         filled: true,
          //         fillColor: isDark ? const Color(0xFF23272F) : Colors.white,
          //         border: OutlineInputBorder(
          //             borderRadius: BorderRadius.circular(8)),
          //       ),
          //       value: controller.selectedStatus.value,
          //       items: controller.statusFilter
          //           .map((status) => DropdownMenuItem(
          //                 value: status,
          //                 child: Text(status),
          //               ))
          //           .toList(),
          //       onChanged: (value) {
          //         controller.selectedStatus.value = value ?? '';
          //       },
          //     )),
          // const SizedBox(height: 16),

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
                  DropdownMenuItem(value: 'ALL', child: Text('All')),
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
                  controller.selectedSort.value = 'ALL';
                  controller.selectedSubscription.value = 'ALL';
                  controller.selectedPlatform.value = 'ALL';
                  controller.selectedDateRange.value = null;
                  controller.dateRangeController.clear();

                  appController.showFilter.value = false;
                  controller.fetchOrdersStatsData();
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
                  controller.fetchOrdersStatsData();
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
      BuildContext context, OrderManagementController controller) async {
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

  Widget _buildHeaderSection(BuildContext context) {
    return isMobile
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Row(
                children: [
                  // Search Bar
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
                          hintText: 'Search orders...',
                          hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                          contentPadding: const EdgeInsets.symmetric(vertical: 0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                          ),
                          isDense: true,
                        ),
                        onChanged: (value) {
                          controller.searchOrders(value);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildFilterButton(context),
                ],
              ),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Orders",
                style: CustomTextTheme.regular20,
              ),
              Row(
                children: [
                  // Search Bar
                  SizedBox(
                    width: 250,
                    child: TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
                        hintText: 'Search orders...',
                        hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        isDense: true,
                      ),
                      onChanged: (value) {
                        controller.searchOrders(value);
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

  // Helper method to format date
  String _formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  Widget _buildStatusChip(String status) {
    bool isFailed = status.toLowerCase() == "failed";
    bool isCompleted = status.toLowerCase() == "completed" ||
        status.toLowerCase() == "succeeded";
    bool isPending = status.toLowerCase() == "pending";
    bool isCancelled = status.toLowerCase() == "cancelled";

    Color bgColor;
    Color dotColor;
    Color textColor;

    if (isFailed || isCancelled) {
      bgColor = Colors.red.withOpacity(0.1);
      dotColor = Colors.red;
      textColor = Colors.red;
    } else if (isCompleted) {
      bgColor = Colors.green.withOpacity(0.1);
      dotColor = Colors.green;
      textColor = Colors.green.shade800;
    } else if (isPending) {
      bgColor = Colors.orange.withOpacity(0.1);
      dotColor = Colors.orange;
      textColor = Colors.orange.shade800;
    } else {
      bgColor = Colors.grey.withOpacity(0.1);
      dotColor = Colors.grey;
      textColor = Colors.grey.shade700;
    }

    return Container(
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
            status.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String label,
    BuildContext context, {
    OrdersData? orderData,
  }) {
    final drawerController = Get.find<AppController>();

    return InkWell(
      onTap: () {
        // Pass the order data to the detail screen
        drawerController
            .setDrawerContent(OrderDetailScreen(orderData: orderData));
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
            if (label.isNotEmpty) ...[
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

import 'package:admin/controller/app_controller.dart';
import 'package:admin/controller/orders_management_controller/order_management.dart';
import 'package:admin/models/chartsTablesModel.dart';
import 'package:admin/theme/text_theme.dart';
import 'package:admin/views/order_management/order_info_content/order_info_content.dart';
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

    return Container(
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

          // Table Header
          _buildTableHeader(),

          SizedBox(height: isMobile ? 8 : 12),

          // Table Content
          Expanded(
            child: Obx(() {
              // Calculate pagination
              const itemsPerPage = 10;
              // final totalPages =
              //     (controller.orderList.length / itemsPerPage).ceil();
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
                    _buildTableRow(paginatedList[index], isDark, context),
              );
            }),
          ),

          // Pagination Controls
          Obx(() {
            const itemsPerPage = 10;
            final totalPages =
                (controller.orderList.length / itemsPerPage).ceil();
            final currentPage = controller.currentPage.value;

            return Container(
              padding: EdgeInsets.symmetric(vertical: 16),
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
                        fontSize: isMobile ? 12 : 14,
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
                  child: _buildActionButton(Icons.download, "Export", context)),
              const SizedBox(width: 8),
              Expanded(
                  child:
                      _buildActionButton(Icons.filter_list, "Filter", context)),
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
              _buildActionButton(Icons.download, "Export", context),
              const SizedBox(width: 8),
              _buildActionButton(Icons.filter_list, "Filter", context),
            ],
          ),
        ],
      );
    }
  }

  Widget _buildTableHeader() {
    if (isMobile) {
      // Mobile: Show simplified header
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Row(
          children: const [
            Expanded(flex: 2, child: Text('Order ID', style: _headerStyle)),
            Expanded(flex: 3, child: Text('Amount', style: _headerStyle)),
            Expanded(flex: 2, child: Text('Status', style: _headerStyle)),
            SizedBox(width: 60, child: Text('Actions', style: _headerStyle)),
          ],
        ),
      );
    } else if (isTablet) {
      // Tablet: Show medium complexity header
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(children: const [
          Expanded(flex: 1, child: Text('Order ID', style: _headerStyle)),
          Expanded(flex: 2, child: Text('Email', style: _headerStyle)),
          Expanded(flex: 2, child: Text('Amount', style: _headerStyle)),
          Expanded(flex: 2, child: Text('Status', style: _headerStyle)),
          Expanded(flex: 2, child: Text('Subscription', style: _headerStyle)),
          SizedBox(width: 70, child: Text('Actions', style: _headerStyle)),
        ]),
      );
    } else {
      // Desktop: Show full header
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(children: const [
          Expanded(flex: 1, child: Text('Order ID', style: _headerStyle)),
          Expanded(flex: 2, child: Text('Date', style: _headerStyle)),
          Expanded(flex: 2, child: Text('Status', style: _headerStyle)),
          Expanded(flex: 3, child: Text('Email', style: _headerStyle)),
          Expanded(flex: 2, child: Text('Subscription', style: _headerStyle)),
          Expanded(flex: 2, child: Text('Amount', style: _headerStyle)),
          Expanded(flex: 2, child: Text('Note', style: _headerStyle)),
          SizedBox(width: 80, child: Text('Actions', style: _headerStyle)),
        ]),
      );
    }
  }

  Widget _buildTableRow(
    OrderData data,
    bool isDark,
    BuildContext context,
  ) {
    final padding = isMobile
        ? 8.0
        : isTablet
            ? 12.0
            : 16.0;

    if (isMobile) {
      // Mobile: Simplified row
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
                child: Text(data.orderId,
                    style: _rowStyle, overflow: TextOverflow.ellipsis)),
            Expanded(
                flex: 3,
                child: Text("${data.amount}",
                    style: _rowStyle, overflow: TextOverflow.ellipsis)),
            Expanded(flex: 2, child: _buildStatusChip(data.status)),
            SizedBox(
                width: 60,
              child: _buildActionButton(Icons.visibility, "View", context,orderData: data)),
          ],
        ),
      );
    } else if (isTablet) {
      // Tablet: Medium complexity row
      return Container(
        padding: EdgeInsets.symmetric(horizontal: padding, vertical: 14),
        decoration: BoxDecoration(
          border: Border(
              top: BorderSide(
                  color: isDark ? Colors.grey.shade600 : Colors.grey,
                  width: 0.5)),
        ),
        child: Row(children: [
          Expanded(flex: 1, child: Text('${data.orderId}', style: _rowStyle)),
          Expanded(
              flex: 2,
              child: Text(data.userEmail,
                  style: _rowStyle, overflow: TextOverflow.ellipsis)),
          Expanded(
              flex: 2, child: Text(data.amount.toString(), style: _rowStyle)),
          Expanded(flex: 2, child: _buildStatusChip(data.status)),
          Expanded(flex: 2, child: Text(data.subscription, style: _rowStyle)),
          SizedBox(
              width: 70,
              child: _buildActionButton(Icons.visibility, "View", context,orderData: data)),
        ]),
      );
    } else {
      // Desktop: Full row
      return Container(
        padding: EdgeInsets.symmetric(horizontal: padding, vertical: 16),
        decoration: BoxDecoration(
          border: Border(
              top: BorderSide(
                  color: isDark ? Colors.grey.shade600 : Colors.grey,
                  width: 0.5)),
        ),
        child: Row(children: [
          Expanded(flex: 1, child: Text('${data.orderId}', style: _rowStyle)),
          Expanded(flex: 2, child: Text(data.date, style: _rowStyle)),
          Expanded(flex: 2, child: _buildStatusChip(data.status)),
          Expanded(
              flex: 3,
              child: Text(data.userEmail,
                  style: _rowStyle, overflow: TextOverflow.ellipsis)),
          Expanded(
              flex: 2, child: Text('${data.subscription}', style: _rowStyle)),
          Expanded(
              flex: 2,
              child: Text('\$${data.amount.toStringAsFixed(2)}',
                  style: _rowStyle)),
          Expanded(
              flex: 2,
              child: Text(data.notes,
                  style: _rowStyle, overflow: TextOverflow.ellipsis)),
          SizedBox(
              width: 80,
              child: _buildActionButton(Icons.visibility, "View", context,orderData: data)),
        ]),
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
}) {    final drawerController = Get.find<AppController>();

    final isDark = Theme.of(context).brightness == Brightness.dark;
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
                  color: isDark && label == "View"
                      ? Colors.white
                      : Colors.grey.shade700,
                  fontSize: isTablet ? 12 : 14,
                ),
              ),
              const SizedBox(width: 6),
            ],
            Icon(
              icon,
              color: isDark && label == "View"
                  ? Colors.white
                  : Colors.grey.shade600,
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

  static const _rowStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
}

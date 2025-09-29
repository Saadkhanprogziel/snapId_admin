import 'package:admin/controller/user_management_controller/user_info_detail_controller/user_info_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrdersScreen extends StatelessWidget {
  final UserInfoDetailController userInfoController;
  final bool isDark;

  const OrdersScreen({
    super.key,
    required this.userInfoController,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
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
                final currentPage = userInfoController.currentPage.value;
                final startIndex = currentPage * itemsPerPage;
                final endIndex =
                    (startIndex + itemsPerPage) > userInfoController.orderList.length
                        ? userInfoController.orderList.length
                        : (startIndex + itemsPerPage);
                final paginatedList =
                    userInfoController.orderList.sublist(startIndex, endIndex);

                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: MediaQuery.of(context).size.width,
                          ),
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
                    ),
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
                            (userInfoController.orderList.length / itemsPerPage).ceil();
                        final currentPage = userInfoController.currentPage.value;

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Showing ${startIndex + 1}-${endIndex} of ${userInfoController.orderList.length} results',
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
                                      ? () => userInfoController.currentPage.value--
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
                                      ? () => userInfoController.currentPage.value++
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
}
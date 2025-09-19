import 'package:admin/controller/app_controller.dart';
import 'package:admin/controller/support_controller/support_controller.dart';
import 'package:admin/models/support_model/tickets_model.dart';
import 'package:admin/theme/text_theme.dart';
import 'package:admin/views/support/support_chat/support_chat_screen.dart';
import 'package:admin/widgets/filter_panel.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SupportListWidget extends StatelessWidget {
  final SupportController controller;
  final bool isMobile;
  final bool isTablet;

  SupportListWidget({
    Key? key,
    required this.controller,
    this.isMobile = false,
    this.isTablet = false,
  }) : super(key: key);

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
          items: controller.status_filter
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
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                controller.resetFilters();
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
                controller.applyFilters();
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
              _buildHeaderSection(isDark),
              SizedBox(
                  height: isMobile
                      ? 20
                      : isTablet
                          ? 24
                          : 32),
              Expanded(
                child: Obx(() {
                  if (controller.ticketListData.value == null) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final ticketsData = controller.ticketListData.value!;
                  final tickets = ticketsData.tickets;

                  if (tickets.isEmpty) {
                    return const Center(
                      child: Text('No support tickets found'),
                    );
                  }

                  return DataTable2(
                    columnSpacing: 16,
                    horizontalMargin: 12,
                    minWidth: 900,
                    dataRowHeight: 70,
                    headingRowHeight: 56,
                    columns: [
                      DataColumn(label: Text('Ticket ID')),
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Subject')),
                      DataColumn(label: Text('Date')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Email Address')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: tickets.map((ticket) {
                      return DataRow(cells: [
                        DataCell(Text('#${ticket.id.substring(0, 8)}')),
                        DataCell(Text(
                            '${ticket.user.firstName} ${ticket.user.lastName}')),
                        DataCell(
                          Container(
                            width: 200,
                            child: Text(
                              ticket.title,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ),
                        DataCell(Text(_formatDate(ticket.createdAt))),
                        DataCell(_buildStatusChip(ticket.status)),
                        DataCell(Text(ticket.user.email)),
                        DataCell(_buildActionButton(
                            ticket, Icons.visibility, "View", isDark, context)),
                      ]);
                    }).toList(),
                  );
                }),
              ),
              Obx(() {
                if (controller.ticketListData.value == null) {
                  return const SizedBox.shrink();
                }

                final pagination = controller.ticketListData.value!.pagination;
                final currentPage = pagination.currentPage;
                final totalPages = pagination.totalPages;

                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: currentPage > 1
                            ? () => controller.loadPage(currentPage - 1)
                            : null,
                        icon: Icon(
                          Icons.chevron_left,
                          color: currentPage > 1
                              ? Colors.grey.shade700
                              : Colors.grey.shade400,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Page $currentPage of $totalPages (${pagination.totalTickets} total)',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: isMobile ? 12 : 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      IconButton(
                        onPressed: currentPage < totalPages
                            ? () => controller.loadPage(currentPage + 1)
                            : null,
                        icon: Icon(
                          Icons.chevron_right,
                          color: currentPage < totalPages
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
        CommonFilterPanel(
          isDark: isDark,
          filterContent: _buildFilterPanel(isDark, appController),
        )
      ],
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }

  Widget _buildStatusChip(String status) {
    bool isBlocked = status.toLowerCase() == "closed";
    bool isActive = status.toLowerCase() == "open";
    bool isPending = status.toLowerCase() == "pending";

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
    } else if (isPending) {
      bgColor = Colors.orange.withOpacity(0.1);
      dotColor = Colors.orange;
      textColor = Colors.orange.shade700;
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

  Widget _buildHeaderSection(bool isDark) {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                  child:
                      _buildFilterButton(Icons.filter_list, "Filter", isDark)),
            ],
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "All Support Messages",
            style: CustomTextTheme.regular20,
          ),
          Row(
            children: [
              SizedBox(
                width: 400,
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
                    hintText: 'Search by user name or email...',
                    hintStyle:
                        TextStyle(fontSize: 12, color: Colors.grey.shade500),
                    fillColor: isDark ? const Color(0xFF23272F) : Colors.white,
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
                    controller.searchTickets(value);
                  },
                ),
              ),
              const SizedBox(width: 8),
              _buildFilterButton(Icons.filter_list, "Filter", isDark),
            ],
          ),
        ],
      );
    }
  }

  Widget _buildFilterButton(IconData icon, String label, bool isDark) {
    return GestureDetector(
      onTap: () {
        final appController = Get.find<AppController>();
        appController.showFilter.value = !appController.showFilter.value;
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
                  color: isDark ? Colors.white : Colors.grey.shade700,
                  fontSize: isTablet ? 12 : 14,
                ),
              ),
              const SizedBox(width: 6),
            ],
            Icon(
              icon,
              color: isDark ? Colors.white : Colors.grey.shade600,
              size: isMobile ? 14 : 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    TicketDetails ticket,
    IconData icon,
    String label,
    bool isDark,
    BuildContext context,
  ) {
    final drawerController = Get.find<AppController>();

    return InkWell(
      onTap: () {
        drawerController.setDrawerContent(SupportChatScreen(
          ticket: ticket, key: ValueKey(ticket.id), // unique per ticket
        ));
        drawerController.toggleDrawer();
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 6 : 8,
          vertical: isMobile ? 6 : 8,
        ),
        decoration: BoxDecoration(
          border: Border.all(
              color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
          color: isDark ? const Color(0xFF23272F) : Colors.white,
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
                  color: isDark ? Colors.white : Colors.grey.shade700,
                  fontSize: isTablet ? 12 : 14,
                ),
              ),
              const SizedBox(width: 6),
            ],
            Icon(
              icon,
              color: isDark ? Colors.white : Colors.grey.shade700,
              size: isMobile ? 14 : 16,
            ),
          ],
        ),
      ),
    );
  }
}

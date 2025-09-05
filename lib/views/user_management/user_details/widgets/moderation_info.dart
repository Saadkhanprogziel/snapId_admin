import 'package:admin/controller/user_management_controller/user_info_detail_controller/user_info_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ModerationHistoryScreen extends StatelessWidget {
  final UserInfoDetailController userInfoController;
  final bool isDark;
  final String Function(DateTime) formatDateTime;

  const ModerationHistoryScreen({
    super.key,
    required this.userInfoController,
    required this.isDark,
    required this.formatDateTime,
  });

  Color _getStatusColor(String actionType) {
    switch (actionType.toLowerCase()) {
      case 'block':
      case 'blocked':
        return Colors.red;
      case 'unblock':
      case 'unblocked':
        return Colors.green;
      case 'warning':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    const itemsPerPage = 10;
    return Column(
      children: [
        Expanded(
          child: Obx(() {
            final currentPage = userInfoController.moderationCurrentPage.value;
            final moderationList = userInfoController.moderationList;
            final startIndex = currentPage * itemsPerPage;
            final endIndex = (startIndex + itemsPerPage) > moderationList.length
                ? moderationList.length
                : (startIndex + itemsPerPage);
            final paginatedList = moderationList.sublist(startIndex, endIndex);
            return SizedBox(
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
                    dataRowMaxHeight: 64,
                    horizontalMargin: 24,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF23272F) : Colors.white,
                    ),
                    headingRowColor: MaterialStateProperty.all(
                      isDark ? const Color(0xFF1A1D23) : Colors.grey.shade50,
                    ),
                    columns: const [
                      DataColumn(label: Text('Date - Time')),
                      DataColumn(label: Text('Action Taken')),
                      DataColumn(label: Text('Reason Provided')),
                    ],
                    rows: paginatedList.map((moderation) {
                      return DataRow(cells: [
                        DataCell(Text(formatDateTime(moderation.performedAt))),
                        DataCell(Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: _getStatusColor(moderation.actionType),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                          ),
                          child: Text(
                            moderation.actionType,
                            style: const TextStyle(color: Colors.white),
                          ),
                        )),
                        DataCell(Text(moderation.reason)),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
            );
          }),
        ),
        Obx(() {
          final moderationList = userInfoController.moderationList;
          final totalPages = (moderationList.length / itemsPerPage).ceil();
          final currentPage = userInfoController.moderationCurrentPage.value;
          final startIndex = currentPage * itemsPerPage;
          final endIndex = (startIndex + itemsPerPage) > moderationList.length
              ? moderationList.length
              : (startIndex + itemsPerPage);

          if (moderationList.isEmpty) {
            return const SizedBox();
          }

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1A1D23) : Colors.grey.shade50,
              border: Border(
                top: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Showing ${startIndex + 1}–$endIndex of ${moderationList.length} results',
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: currentPage > 0
                          ? () =>
                              userInfoController.moderationCurrentPage.value--
                          : null,
                      icon: Icon(
                        Icons.chevron_left,
                        color: currentPage > 0
                            ? (isDark ? Colors.white : Colors.grey.shade700)
                            : Colors.grey.shade400,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF23272F) : Colors.white,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${currentPage + 1} of $totalPages',
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.grey.shade700,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: currentPage < totalPages - 1
                          ? () =>
                              userInfoController.moderationCurrentPage.value++
                          : null,
                      icon: Icon(
                        Icons.chevron_right,
                        color: currentPage < totalPages - 1
                            ? (isDark ? Colors.white : Colors.grey.shade700)
                            : Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

import 'package:admin/models/chartsTablesModel.dart';
import 'package:admin/theme/text_theme.dart';
import 'package:admin/utils/custom_spaces.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:admin/controller/app_controller.dart';

class OrderDetailScreen extends StatefulWidget {
  final OrderData? orderData;
  const OrderDetailScreen({Key? key, this.orderData}) : super(key: key);

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final TextEditingController _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final order = widget.orderData;
    return Scaffold(
      backgroundColor:
          isDark ? Theme.of(context).scaffoldBackgroundColor : Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    final appController = Get.find<AppController>();
                    appController.closeDrawer();
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isDark ? Color(0xFF23272F) : Colors.white,
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
                ),
                const SizedBox(width: 16),
                Text(
                  'Order Detail',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Color(0xFF111827),
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.person_outline,
                    size: 16,
                    color: Color(0xFF6366F1),
                  ),
                  label: Text(
                    'View Profile',
                    style: TextStyle(
                      color: Color(0xFF6366F1),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ],
            ),
            SpaceH40(),
            Container(
              padding: EdgeInsets.symmetric(vertical: 40),
              decoration: BoxDecoration(
                  color: isDark ? Color(0xFF23272F) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      width: 0.3,
                      color: isDark ? Colors.grey.shade700 : Colors.grey)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order ID and Date
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildDetailItem(
                              'Order ID:', order?.orderId ?? '-',
                              isDark: isDark),
                        ),
                        Expanded(
                          child: _buildDetailItem('Date:', order?.date ?? '-',
                              isDark: isDark),
                        ),
                      ],
                    ),
                  ),

                  Divider(
                      color:
                          isDark ? Colors.grey.shade700 : Colors.grey.shade300),

                  // Email and Amount
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildDetailItem(
                              'Email:', order?.userEmail ?? '-',
                              isDark: isDark),
                        ),
                        Expanded(
                          child: _buildDetailItem(
                              'Amount (USD):',
                              order != null
                                  ? '\$${order.amount.toStringAsFixed(2)}'
                                  : '-',
                              isDark: isDark),
                        ),
                      ],
                    ),
                  ),

                  Divider(
                      color:
                          isDark ? Colors.grey.shade700 : Colors.grey.shade300),

                  // Status and Subscription
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildDetailItem(
                              'Status:', order?.status ?? '-',
                              status: true, isDark: isDark),
                        ),
                        Expanded(
                          child: _buildDetailItem(
                              'Subscription:', order?.subscription ?? '-',
                              isDark: isDark),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                      color:
                          isDark ? Colors.grey.shade700 : Colors.grey.shade300),

                  // Invoice (dummy link)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildDetailItem('Invoice:', 'View',
                              link: true, isDark: isDark),
                        ),
                        Expanded(child: Container()),
                      ],
                    ),
                  ),

                  SpaceH20(),
                  // Note Section
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 20),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Text(
                  //         'Note:',
                  //         style: CustomTextTheme.regular18.copyWith(
                  //             color: isDark ? Colors.white : Colors.grey,
                  //             fontWeight: FontWeight.w400),
                  //       ),
                  //       const SizedBox(height: 16),

                  //       // Note Input
                  //       Container(
                  //         width: double.infinity,
                  //         height: 120,
                  //         decoration: BoxDecoration(
                  //           color: isDark ? Color(0xFF23272F) : null,
                  //           border: Border.all(
                  //               color: isDark
                  //                   ? Colors.grey.shade700
                  //                   : const Color(0xFFE5E7EB)),
                  //           borderRadius: BorderRadius.circular(8),
                  //         ),
                  //         child: TextField(
                  //           controller: _noteController,
                  //           maxLines: null,
                  //           expands: true,
                  //           textAlignVertical: TextAlignVertical.top,
                  //           decoration: InputDecoration(
                  //             hintText: order?.notes ?? 'Write note...',
                  //             hintStyle: TextStyle(
                  //               color: isDark
                  //                   ? Colors.grey.shade400
                  //                   : Color(0xFFA1A1AA),
                  //               fontSize: 16,
                  //               fontWeight: FontWeight.w400,
                  //             ),
                  //             border: InputBorder.none,
                  //             contentPadding: EdgeInsets.all(16),
                  //           ),
                  //           style: TextStyle(
                  //             fontSize: 16,
                  //             color: isDark ? Colors.white : Color(0xFF374151),
                  //           ),
                  //         ),
                  //       ),
                  //       const SizedBox(height: 24),

                  //       // Save Note Button
                  //       Container(
                  //         decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(8),
                  //           gradient: const LinearGradient(
                  //             colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
                  //             begin: Alignment.topLeft,
                  //             end: Alignment.bottomRight,
                  //           ),
                  //         ),
                  //         child: ElevatedButton(
                  //           onPressed: () {},
                  //           style: ElevatedButton.styleFrom(
                  //             backgroundColor: Colors.transparent,
                  //             shadowColor: Colors.transparent,
                  //             padding: const EdgeInsets.symmetric(
                  //                 horizontal: 24, vertical: 16),
                  //             shape: RoundedRectangleBorder(
                  //               borderRadius: BorderRadius.circular(8),
                  //             ),
                  //           ),
                  //           child: const Text(
                  //             'Save Note',
                  //             style: TextStyle(
                  //               fontSize: 16,
                  //               fontWeight: FontWeight.w600,
                  //               color: Colors.white,
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value,
      {bool status = false, bool link = false, bool isDark = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 140,
          child: Text(
            label,
            style: CustomTextTheme.regular18
                .copyWith(color: isDark ? Colors.white : Colors.grey),
          ),
        ),
        const SizedBox(width: 16),
        _buildValue(value, status: status, link: link, isDark: isDark),
      ],
    );
  }

  Widget _buildValue(String value,
      {bool status = false, bool link = false, bool isDark = false}) {
    if (status) {
      final isFailed = value.trim().toLowerCase() == 'failed';
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isFailed
              ? (isDark
                  ? const Color(0xFFDC2626).withOpacity(0.2)
                  : const Color(0xFFFECACA))
              : (isDark
                  ? Color(0xFF16A34A).withOpacity(0.2)
                  : Color(0xFFDCFCE7)),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: isFailed ? const Color(0xFFDC2626) : Color(0xFF16A34A),
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    } else if (link) {
      return InkWell(
        onTap: () {},
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.visibility_outlined,
              size: 16,
              color: Color(0xFF6366F1),
            ),
            const SizedBox(width: 4),
            Text(
              value,
              style: TextStyle(
                color: Color(0xFF6366F1),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    } else {
      return Text(
        value,
        style: CustomTextTheme.regular18
            .copyWith(color: isDark ? Colors.white : null),
      );
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }
}

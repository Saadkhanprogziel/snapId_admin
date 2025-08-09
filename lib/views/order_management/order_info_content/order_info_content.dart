import 'package:admin/theme/text_theme.dart';
import 'package:admin/utils/custom_spaces.dart';
import 'package:flutter/material.dart';

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({Key? key}) : super(key: key);

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final TextEditingController _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.arrow_forward,
                    size: 18,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Order Detail',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.person_outline,
                    size: 16,
                    color: Color(0xFF6366F1),
                  ),
                  label: const Text(
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(width: 0.3, color: Colors.grey)),
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
                          child: _buildDetailItem('Order ID:', 'ORD1024'),
                        ),
                        Expanded(
                          child: _buildDetailItem('Date:', '09/08/2025'),
                        ),
                      ],
                    ),
                  ),

                  Divider(color: Colors.grey.shade300),

                  // Name and Amount
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildDetailItem('Name:', 'John Smith'),
                        ),
                        Expanded(
                          child: _buildDetailItem('Amount (USD):', '\$4.99'),
                        ),
                      ],
                    ),
                  ),

                  Divider(color: Colors.grey.shade300),

                  // Email and Status
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildDetailItem('Email:', 'john@gmail.com'),
                        ),
                        Expanded(
                          child: _buildDetailItem('Status:', 'Success',
                              status: true),
                        ),
                      ],
                    ),
                  ),
                  Divider(color: Colors.grey.shade300),

                  // Subscription and Invoice
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildDetailItem('Subscription:', 'Photo 1'),
                        ),
                        Expanded(
                          child:
                              _buildDetailItem('Invoice:', 'View', link: true),
                        ),
                      ],
                    ),
                  ),

                  SpaceH20(),
                  // Note Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Note:',
                          style: CustomTextTheme.regular18.copyWith(
                              color: Colors.grey, fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(height: 16),

                        // Note Input
                        Container(
                          width: double.infinity,
                          height: 120,
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextField(
                            controller: _noteController,
                            maxLines: null,
                            expands: true,
                            textAlignVertical: TextAlignVertical.top,
                            decoration: const InputDecoration(
                              hintText: 'Write note...',
                              hintStyle: TextStyle(
                                color: Color(0xFFA1A1AA),
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(16),
                            ),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF374151),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Save Note Button
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Save Note',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value,
      {bool status = false, bool link = false}) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.center, // Changed to center for better alignment
      children: [
        SizedBox(
          width: 140, // Increased width to accommodate longer labels
          child: Text(
            label,
            style: CustomTextTheme.regular18.copyWith(color: Colors.grey),
          ),
        ),
        const SizedBox(width: 16), // Consistent spacing
        _buildValue(value,
            status: status, link: link), // Removed Expanded wrapper
      ],
    );
  }

  Widget _buildValue(String value, {bool status = false, bool link = false}) {
    if (status) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFDCFCE7),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF16A34A),
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
            const Icon(
              Icons.visibility_outlined,
              size: 16,
              color: Color(0xFF6366F1),
            ),
            const SizedBox(width: 4),
            Text(
              value,
              style: const TextStyle(
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
        style: CustomTextTheme.regular18,
      );
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }
}

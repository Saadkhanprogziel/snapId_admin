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
                  width: 32,
                  height: 32,
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
                    Icons.arrow_back,
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
            SpaceH20(),
            Container(
              padding: EdgeInsets.symmetric(vertical: 40),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(width: 0.3, color: Colors.grey)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Order ID:",
                              style: CustomTextTheme.regular18
                                  .copyWith(color: Colors.grey),
                            ),
                            SpaceW30(),
                            Text(
                              "ORD1024",
                              style: CustomTextTheme.regular18,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Date:",
                              style: CustomTextTheme.regular18
                                  .copyWith(color: Colors.grey),
                            ),
                            SpaceW30(),
                            Text(
                              "09/08/2025",
                              style: CustomTextTheme.regular18,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.grey.shade300,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Email:",
                              style: CustomTextTheme.regular18
                                  .copyWith(color: Colors.grey),
                            ),
                            SpaceW30(),
                            Text(
                              "john@gmail.com",
                              style: CustomTextTheme.regular18,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Status",
                              style: CustomTextTheme.regular18
                                  .copyWith(color: Colors.grey),
                            ),
                            SpaceW30(),
                            Text(
                              "Success",
                              style: CustomTextTheme.regular18,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.grey.shade300,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Subscription:",
                              style: CustomTextTheme.regular18
                                  .copyWith(color: Colors.grey),
                            ),
                            SpaceW30(),
                            Text(
                              "Photo 1",
                              style: CustomTextTheme.regular18,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Invoice:",
                              style: CustomTextTheme.regular18
                                  .copyWith(color: Colors.grey),
                            ),
                            SpaceW30(),
                            Text(
                              "View",
                              style: CustomTextTheme.regular18,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.grey.shade300,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Name:",
                              style: CustomTextTheme.regular18
                                  .copyWith(color: Colors.grey),
                            ),
                            SpaceW30(),
                            Text(
                              "John Smith",
                              style: CustomTextTheme.regular18,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Amount (USD):",
                              style: CustomTextTheme.regular18
                                  .copyWith(color: Colors.grey),
                            ),
                            SpaceW30(),
                            Text(
                              "ORD1024",
                              style: CustomTextTheme.regular18,
                            ),
                          ],
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
                          style: CustomTextTheme.regular18
                              .copyWith(color: Colors.grey,fontWeight: FontWeight.w400),
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
            // const SizedBox(height: 32),

            // // Order Details Card
            // Container(
            //   decoration: BoxDecoration(
            //       color: Colors.white,
            //       borderRadius: BorderRadius.circular(12),
            //       border: Border.all(width: 0.3, color: Colors.grey)),
            //   child: Padding(
            //     padding: const EdgeInsets.all(30.0),
            //     child: Column(
            //       children: [
            //         // First Row
            //         Row(
            //           children: [
            //             Expanded(
            //               child: _buildDetailItem('Order ID:', 'ORD10245'),
            //             ),
            //             Expanded(
            //               child: _buildDetailItem('Date:', '09/08/2025'),
            //             ),
            //           ],
            //         ),
            //         const SizedBox(height: 24),

            //         // Second Row
            //         Row(
            //           children: [
            //             Expanded(
            //               child: _buildDetailItem('Name:', 'John Smith'),
            //             ),
            //             Expanded(
            //               child: _buildDetailItem('Amount (USD):', '\$4.99'),
            //             ),
            //           ],
            //         ),
            //         const SizedBox(height: 24),

            //         // Third Row
            //         Row(
            //           children: [
            //             Expanded(
            //               child: _buildDetailItem('Email:', 'john@gmail.com'),
            //             ),
            //             Expanded(
            //               child: _buildDetailItem('Status:', 'Success',
            //                   status: true),
            //             ),
            //           ],
            //         ),
            //         const SizedBox(height: 24),

            //         // Fourth Row
            //         Row(
            //           children: [
            //             Expanded(
            //               child: _buildDetailItem('Subscription:', 'Photo 1'),
            //             ),
            //             Expanded(
            //               child: _buildDetailItem('Invoice:', 'View',
            //                   link: true),
            //             ),
            //           ],
            //         ),
            //         const SizedBox(height: 32),

            //         // Note Section - Now following the same pattern
            //         Row(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             Expanded(
            //               child: Column(
            //                 crossAxisAlignment: CrossAxisAlignment.start,
            //                 children: [
            //                   const Text(
            //                     'Note:',
            //                     style: TextStyle(
            //                       fontSize: 14,
            //                       color: Color(0xFF6B7280),
            //                       fontWeight: FontWeight.w500,
            //                     ),
            //                   ),
            //                   const SizedBox(height: 8),
            //                   Container(
            //                     height: 120,
            //                     decoration: BoxDecoration(
            //                       border: Border.all(
            //                           color: const Color(0xFFE5E7EB)),
            //                       borderRadius: BorderRadius.circular(8),
            //                     ),
            //                     child: TextField(
            //                       controller: _noteController,
            //                       maxLines: null,
            //                       expands: true,
            //                       textAlignVertical: TextAlignVertical.top,
            //                       decoration: const InputDecoration(
            //                         hintText: 'Write note...',
            //                         hintStyle: TextStyle(
            //                           color: Color(0xFFA1A1AA),
            //                           fontSize: 14,
            //                         ),
            //                         border: InputBorder.none,
            //                         contentPadding: EdgeInsets.all(12),
            //                       ),
            //                       style: const TextStyle(
            //                         fontSize: 14,
            //                         color: Color(0xFF374151),
            //                       ),
            //                     ),
            //                   ),
            //                   const SizedBox(height: 16),

            //                   // Save Note Button
            //                   ElevatedButton(
            //                     onPressed: () {},
            //                     style: ElevatedButton.styleFrom(
            //                       backgroundColor: const Color(0xFF6366F1),
            //                       foregroundColor: Colors.white,
            //                       padding: const EdgeInsets.symmetric(
            //                           horizontal: 24, vertical: 12),
            //                       shape: RoundedRectangleBorder(
            //                         borderRadius: BorderRadius.circular(8),
            //                       ),
            //                       elevation: 0,
            //                     ),
            //                     child: const Text(
            //                       'Save Note',
            //                       style: TextStyle(
            //                         fontSize: 14,
            //                         fontWeight: FontWeight.w500,
            //                       ),
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //             // Empty expanded widget to maintain the two-column layout
            //             const Expanded(child: SizedBox()),
            //           ],
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value,
      {bool status = false, bool link = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100, // Fixed width for label to align values
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 8),
        if (status)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFDCFCE7),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF16A34A),
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        else if (link)
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(
              Icons.visibility_outlined,
              size: 14,
              color: Color(0xFF6366F1),
            ),
            label: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF6366F1),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          )
        else
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }
}

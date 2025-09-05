import 'package:admin/models/orders/order_list_model.dart'; // Updated import
import 'package:admin/theme/text_theme.dart';
import 'package:admin/utils/custom_spaces.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:admin/controller/app_controller.dart';
import 'package:intl/intl.dart'; // Added for date formatting

class OrderDetailScreen extends StatefulWidget {
  final OrdersData? orderData; // Changed from OrderData to OrdersData
  const OrderDetailScreen({Key? key, this.orderData}) : super(key: key);

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final TextEditingController _noteController = TextEditingController();

  // Helper method to determine if it's mobile layout
  bool _isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 768;
  }

  // Helper method to determine if it's tablet layout
  bool _isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 768 && width < 1024;
  }

  // Get responsive padding
  EdgeInsets _getResponsivePadding(BuildContext context) {
    if (_isMobile(context)) {
      return const EdgeInsets.symmetric(horizontal: 16, vertical: 20);
    } else if (_isTablet(context)) {
      return const EdgeInsets.symmetric(horizontal: 32, vertical: 30);
    } else {
      return const EdgeInsets.symmetric(horizontal: 60, vertical: 40);
    }
  }

  // Get responsive content padding
  EdgeInsets _getContentPadding(BuildContext context) {
    if (_isMobile(context)) {
      return const EdgeInsets.symmetric(horizontal: 16, vertical: 16);
    } else {
      return const EdgeInsets.symmetric(horizontal: 20, vertical: 20);
    }
  }

  // Get responsive label width
  double _getLabelWidth(BuildContext context) {
    if (_isMobile(context)) {
      return 100;
    } else if (_isTablet(context)) {
      return 120;
    } else {
      return 140;
    }
  }

  // Get responsive header font size
  double _getHeaderFontSize(BuildContext context) {
    if (_isMobile(context)) {
      return 20;
    } else if (_isTablet(context)) {
      return 22;
    } else {
      return 24;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final order = widget.orderData;
    final isMobile = _isMobile(context);

    return Scaffold(
      backgroundColor:
          isDark ? Theme.of(context).scaffoldBackgroundColor : Colors.white,
      body: Padding(
        padding: _getResponsivePadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header - Responsive
            isMobile 
              ? _buildMobileHeader(isDark)
              : _buildDesktopHeader(isDark),
            
            SizedBox(height: isMobile ? 20 : 40),
            
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: isMobile ? 20 : 40,
                  ),
                  decoration: BoxDecoration(
                      color: isDark ? Color(0xFF23272F) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          width: 0.3,
                          color: isDark ? Colors.grey.shade700 : Colors.grey)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Order details - responsive layout
                      _buildResponsiveOrderDetails(order, isDark),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileHeader(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                final appController = Get.find<AppController>();
                appController.closeDrawer();
              },
              child: Container(
                width: 36,
                height: 36,
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
                  Icons.arrow_back,
                  size: 18,
                  color: isDark ? Colors.white : Color(0xFF6B7280),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Order Detail',
                style: TextStyle(
                  fontSize: _getHeaderFontSize(context),
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Color(0xFF111827),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextButton.icon(
          onPressed: () {
            // You can implement profile viewing logic here
          },
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
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopHeader(bool isDark) {
    return Row(
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
            fontSize: _getHeaderFontSize(context),
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Color(0xFF111827),
          ),
        ),
        const Spacer(),
        TextButton.icon(
          onPressed: () {
            // You can implement profile viewing logic here
          },
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ],
    );
  }

  Widget _buildResponsiveOrderDetails(OrdersData? order, bool isDark) {
    final isMobile = _isMobile(context);
    
    final List<Map<String, dynamic>> detailItems = [
      {
        'label': 'Order ID:',
        'value': order?.id ?? '-',
        'pair': {
          'label': 'Date:',
          'value': order != null
              ? DateFormat('MMM dd, yyyy').format(order.createdAt)
              : '-',
        }
      },
      {
        'label': 'Email:',
        'value': order?.email ?? '-',
        'pair': {
          'label': 'Amount:',
          'value': order != null
              ? '\$${order.amount.toStringAsFixed(2)} ${order.currency.toUpperCase()}'
              : '-',
        }
      },
      {
        'label': 'Status:',
        'value': order?.status ?? '-',
        'isStatus': true,
        'pair': {
          'label': 'Plan:',
          'value': order?.planName ?? '-',
        }
      },
      {
        'label': 'Platform:',
        'value': order?.platform ?? '-',
        'pair': {
          'label': 'Currency:',
          'value': order?.currency.toUpperCase() ?? '-',
        }
      },
      {
        'label': 'Created At:',
        'value': order != null
            ? DateFormat('MMM dd, yyyy - hh:mm a').format(order.createdAt)
            : '-',
        'pair': {
          'label': '',
          'value': '',
        }
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: detailItems.map((item) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: _getContentPadding(context),
              child: isMobile
                  ? _buildMobileDetailRow(item, isDark)
                  : _buildDesktopDetailRow(item, isDark),
            ),
            if (detailItems.indexOf(item) < detailItems.length - 1)
              Divider(
                color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                height: 1,
              ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildMobileDetailRow(Map<String, dynamic> item, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // First item
        _buildDetailItem(
          item['label'], 
          item['value'],
          status: item['isStatus'] ?? false,
          isDark: isDark,
        ),
        const SizedBox(height: 16),
        // Second item (pair)
        if ((item['pair']['label'] as String).isNotEmpty)
          _buildDetailItem(
            item['pair']['label'],
            item['pair']['value'],
            link: item['pair']['isLink'] ?? false,
            isDark: isDark,
          ),
      ],
    );
  }

  Widget _buildDesktopDetailRow(Map<String, dynamic> item, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: _buildDetailItem(
            item['label'], 
            item['value'],
            status: item['isStatus'] ?? false,
            isDark: isDark,
          ),
        ),
        if ((item['pair']['label'] as String).isNotEmpty)
          Expanded(
            child: _buildDetailItem(
              item['pair']['label'],
              item['pair']['value'],
              link: item['pair']['isLink'] ?? false,
              isDark: isDark,
            ),
          ),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value,
      {bool status = false, bool link = false, bool isDark = false}) {
    final isMobile = _isMobile(context);
    
    return isMobile 
      ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: CustomTextTheme.regular18.copyWith(
                color: isDark ? Colors.white70 : Colors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            _buildValue(value, status: status, link: link, isDark: isDark),
          ],
        )
      : Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: _getLabelWidth(context),
              child: Text(
                label,
                style: CustomTextTheme.regular18.copyWith(
                  color: isDark ? Colors.white : Colors.grey,
                  fontSize: _isTablet(context) ? 16 : 18,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: _buildValue(value, status: status, link: link, isDark: isDark),
              ),
            ),
          ],
        );
  }

  Widget _buildValue(String value,
      {bool status = false, bool link = false, bool isDark = false}) {
    final isMobile = _isMobile(context);
    final fontSize = isMobile ? 16.0 : (_isTablet(context) ? 16.0 : 18.0);
    
    if (status) {
      final isFailed = value.trim().toLowerCase() == 'failed';
      final isCancelled = value.trim().toLowerCase() == 'cancelled';
      final isCompleted = value.trim().toLowerCase() == 'completed' ||
          value.trim().toLowerCase() == 'succeeded';
      final isPending = value.trim().toLowerCase() == 'pending';

      Color bgColor;
      Color textColor;

      if (isFailed || isCancelled) {
        bgColor = isDark
            ? const Color(0xFFDC2626).withOpacity(0.2)
            : const Color(0xFFFECACA);
        textColor = const Color(0xFFDC2626);
      } else if (isCompleted) {
        bgColor =
            isDark ? Color(0xFF16A34A).withOpacity(0.2) : Color(0xFFDCFCE7);
        textColor = Color(0xFF16A34A);
      } else if (isPending) {
        bgColor =
            isDark ? Color(0xFFEA580C).withOpacity(0.2) : Color(0xFFFED7AA);
        textColor = Color(0xFFEA580C);
      } else {
        bgColor = isDark ? Colors.grey.withOpacity(0.2) : Colors.grey.shade200;
        textColor = Colors.grey.shade700;
      }

      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 10 : 12, 
          vertical: isMobile ? 4 : 6,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          value.toUpperCase(),
          style: TextStyle(
            fontSize: isMobile ? 12 : 14,
            color: textColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }  else {
      return Text(
        value,
        style: TextStyle(
          fontSize: fontSize,
          color: isDark ? Colors.white : Color(0xFF374151),
          fontWeight: FontWeight.w400,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: isMobile ? 2 : 1,
      );
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }
}
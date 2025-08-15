import 'package:admin/controller/app_controller.dart';
import 'package:admin/controller/price_setting/price_setting.dart';
import 'package:admin/models/price_item.dart';
import 'package:admin/theme/text_theme.dart';
import 'package:admin/views/price_setting/edit_price/edit_price.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PriceListWidget extends StatelessWidget {
  final PriceSettingController controller;
  final bool isMobile;
  final bool isTablet;

  const PriceListWidget({
    Key? key,
    required this.controller,
    this.isMobile = false,
    this.isTablet = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : isTablet ? 20 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderSection(context),
          SizedBox(height: isMobile ? 20 : isTablet ? 24 : 32),
          _buildTableHeader(),
          SizedBox(height: isMobile ? 8 : 12),

          Expanded(
            child: Obx(() {
              const itemsPerPage = 10;
              final currentPage = controller.currentPage.value;
              final startIndex = currentPage * itemsPerPage;
              final endIndex = (startIndex + itemsPerPage) > controller.priceList.length
                  ? controller.priceList.length
                  : (startIndex + itemsPerPage);
              final paginatedList = controller.priceList.sublist(startIndex, endIndex);

              return ListView.builder(
                itemCount: paginatedList.length,
                itemBuilder: (context, index) =>
                    _buildTableRow(paginatedList[index], isDark, context),
              );
            }),
          ),

          // Obx(() {
          //   const itemsPerPage = 10;
          //   final totalPages = (controller.priceList.length / itemsPerPage).ceil();
          //   final currentPage = controller.currentPage.value;

          //   return Container(
          //     padding: const EdgeInsets.symmetric(vertical: 16),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         IconButton(
          //           onPressed: currentPage > 0
          //               ? () => controller.currentPage.value--
          //               : null,
          //           icon: Icon(
          //             Icons.chevron_left,
          //             color: currentPage > 0
          //                 ? Colors.grey.shade700
          //                 : Colors.grey.shade400,
          //           ),
          //         ),
          //         Expanded(
          //           child: Text(
          //             'Page ${currentPage + 1} of $totalPages',
          //             style: TextStyle(
          //               color: Colors.grey.shade700,
          //               fontSize: isMobile ? 12 : 14,
          //             ),
          //             textAlign: TextAlign.center,
          //           ),
          //         ),
          //         IconButton(
          //           onPressed: currentPage < totalPages - 1
          //               ? () => controller.currentPage.value++
          //               : null,
          //           icon: Icon(
          //             Icons.chevron_right,
          //             color: currentPage < totalPages - 1
          //                 ? Colors.grey.shade700
          //                 : Colors.grey.shade400,
          //           ),
          //         ),
          //       ],
          //     ),
          //   );
          // }),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
   
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("All Pricing Settings", style: CustomTextTheme.regular20),
          
        ],
      );
    
  }

  Widget _buildTableHeader() {
    if (isMobile) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Row(
          children: const [
            Expanded(flex: 2, child: Text('Package', style: _headerStyle)),
            Expanded(flex: 2, child: Text('Price', style: _headerStyle)),
            Expanded(flex: 2, child: Text('Tag', style: _headerStyle)),
            SizedBox(width: 60, child: Text('Actions', style: _headerStyle)),
          ],
        ),
      );
    } else if (isTablet) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(children: const [
          Expanded(flex: 2, child: Text('Package', style: _headerStyle)),
          Expanded(flex: 2, child: Text('Price', style: _headerStyle)),
          Expanded(flex: 2, child: Text('Tag', style: _headerStyle)),
          Expanded(flex: 2, child: Text('Button Label', style: _headerStyle)),
          SizedBox(width: 70, child: Text('Actions', style: _headerStyle)),
        ]),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(children: const [
          Expanded(flex: 2, child: Text('Package', style: _headerStyle)),
          Expanded(flex: 2, child: Text('Price', style: _headerStyle)),
          Expanded(flex: 2, child: Text('Tag', style: _headerStyle)),
          Expanded(flex: 2, child: Text('Button Label', style: _headerStyle)),
          SizedBox(width: 80, child: Text('Actions', style: _headerStyle)),
        ]),
      );
    }
  }

  Widget _buildTableRow(PriceItem data, bool isDark, BuildContext context) {
    final padding = isMobile ? 8.0 : isTablet ? 12.0 : 16.0;
    if (isMobile) {
      return _rowContainer(
        isDark,
        padding,
        [
          Expanded(flex: 2, child: Text(data.package, style: _rowStyle)),
          Expanded(flex: 2, child: Text("\$${data.price}", style: _rowStyle)),
          Expanded(flex: 2, child: Text(data.tag)),
          SizedBox(width: 60, child: _buildViewActionButton(Icons.visibility, "View", context, data: data)),
        ],
      );
    } else if (isTablet) {
      return _rowContainer(
        isDark,
        padding,
        [
          Expanded(flex: 2, child: Text(data.package, style: _rowStyle)),
          Expanded(flex: 2, child: Text("\$${data.price}", style: _rowStyle)),
          Expanded(flex: 2, child: Text(data.tag)),
          Expanded(flex: 2, child: Text(data.buttonLabel, style: _rowStyle)),
          SizedBox(width: 70, child: _buildViewActionButton(Icons.visibility, "View", context, data: data)),
        ],
      );
    } else {
      return _rowContainer(
        isDark,
        padding,
        [
          Expanded(flex: 2, child: Text(data.package, style: _rowStyle)),
          Expanded(flex: 2, child: Text("\$${data.price}", style: _rowStyle)),
          Expanded(flex: 2, child: Text(data.tag)),
          Expanded(flex: 2, child: Text(data.buttonLabel, style: _rowStyle)),
          SizedBox(width: 80, child: _buildViewActionButton(Icons.visibility, "View", context, data: data)),
        ],
      );
    }
  }

  Widget _rowContainer(bool isDark, double padding, List<Widget> children) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.grey.shade600 : Colors.grey,
            width: 0.5,
          ),
        ),
      ),
      child: Row(children: children),
    );
  }


  Widget _buildViewActionButton(IconData icon, String label, BuildContext context, {required PriceItem data}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final drawerController = Get.find<AppController>();
    return GestureDetector(
      onTap: () {
        drawerController.toggleDrawer(content: EditPriceScreen(data: data,));
        print("Edit price item: ${data.package}");
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 6 : 8, vertical: isMobile ? 6 : 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (label.isNotEmpty && !isMobile) ...[
              Text(label, style: TextStyle(color: isDark ? Colors.white : Colors.grey.shade700)),
              const SizedBox(width: 6),
            ],
            Icon(icon, color: isDark ? Colors.white : Colors.grey.shade600, size: isMobile ? 14 : 16),
          ],
        ),
      ),
    );
  }

  static const _headerStyle = TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w600);
  static const _rowStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.w500);
}

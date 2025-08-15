import 'package:admin/controller/price_setting/price_setting.dart';
import 'package:admin/views/price_setting/pricing_list_widget/price_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PricingSetting extends StatelessWidget {
  const PricingSetting({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PriceSettingController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        // final isDesktop = screenWidth > 1200;
        final isTablet = screenWidth > 600 && screenWidth <= 1200;
        final isMobile = screenWidth <= 600;

        return Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                horizontal:  40,
                vertical: 30,
              )   ,
              height: 400,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF23272F) : Colors.white,
                border: Border.all(
                  width: 0.4,
                  color: isDark ? Colors.grey.shade600 : Colors.grey,
                ),
                borderRadius: BorderRadius.circular(isMobile ? 16 : 25),
              ),
              child: PriceListWidget(
                controller: controller,
                isMobile: isMobile,
                isTablet: isTablet,
              ),
            ),
          ],
        );
      },
    );
  }
}

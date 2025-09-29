import 'package:admin/controller/app_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonFilterPanel extends StatelessWidget {
  final bool isDark;
  final Widget? filterContent;

  const CommonFilterPanel({
    Key? key,
    required this.isDark,
    this.filterContent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppController appController = Get.find<AppController>();

    return Obx(
      () => AnimatedPositioned(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        top: 80,
        right: appController.showFilter.value ? 40 : -400, // Increased width accommodation
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(12),
          shadowColor: Colors.black.withOpacity(0.15),
          child: Container(
            width: 350, // Increased width for better UX
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? const Color(0xFF313244) : Colors.grey.shade200,
                width: 1,
              ),
            ),
            child: Theme(
              data: Theme.of(context).copyWith(
                canvasColor: isDark ? const Color(0xFF1E1E2E) : Colors.white,
                cardColor: isDark ? const Color(0xFF1E1E2E) : Colors.white,
                textTheme: Theme.of(context).textTheme.apply(
                      bodyColor: isDark ? Colors.white : Colors.black,
                      displayColor: isDark ? Colors.white : Colors.black,
                    ),
                dropdownMenuTheme: DropdownMenuThemeData(
                  textStyle: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF313244) : Colors.grey.shade50,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.tune,
                              color: isDark ? Colors.white : Colors.black,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Filters',
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () => appController.showFilter.value = false,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            child: Icon(
                              Icons.close,
                              color: isDark ? Colors.white70 : Colors.black54,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Content
                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: filterContent ??
                          Column(
                            children: [
                              Icon(
                                Icons.filter_list_off,
                                size: 48,
                                color: isDark ? Colors.white38 : Colors.black38,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No filters available',
                                style: TextStyle(
                                  color: isDark ? Colors.white70 : Colors.black54,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
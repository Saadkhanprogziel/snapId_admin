import 'package:admin/controller/app_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonFilterPanel extends StatelessWidget {
  final bool isDark;
  final Widget? filterContent; // <-- must be final

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
        right: appController.showFilter.value ? 40 : -320,
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 320,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF23272F) : Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Theme(
              data: Theme.of(context).copyWith(
                canvasColor: isDark ? const Color(0xFF23272F) : Colors.white,
                cardColor: isDark ? const Color(0xFF23272F) : Colors.white,
                textTheme: Theme.of(context).textTheme.apply(
                      bodyColor: isDark ? Colors.white : Colors.black,
                      displayColor: isDark ? Colors.white : Colors.black,
                    ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filters',
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        onPressed: () =>
                            appController.showFilter.value = false,
                        icon: Icon(
                          Icons.close,
                          color: isDark ? Colors.white : Colors.black,
                          size: 20,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  filterContent ??
                      Text(
                        'No filters applied',
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black54,
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

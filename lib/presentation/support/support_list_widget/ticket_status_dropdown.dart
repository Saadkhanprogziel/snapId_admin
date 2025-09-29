
import 'package:admin/controller/support_controller/support_chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StatusDropdown extends StatelessWidget {
  final SupportChatController controller = Get.find<SupportChatController>();

  StatusDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(
      () => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? Colors.grey.shade600 : Colors.grey.shade300,
            width: 0.5,
          ),
          color: isDark ? const Color(0xFF374151) : Colors.white,
        ),
        child: DropdownButton<String>(
          value: controller.chatStatus.value,
          underline: const SizedBox(),
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: isDark ? Colors.white : Colors.grey.shade700,
          ),
          style: TextStyle(
            color: isDark ? Colors.white : Colors.grey.shade700,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          borderRadius: BorderRadius.circular(12),
          dropdownColor:  isDark ? Color(0xFF23272F) : Colors.white,
          items: controller.statuses.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: value == 'OPEN'
                          ? Colors.green
                          : value == 'PENDING'
                              ? Colors.orange
                              : Colors.red,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    value,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
           
              controller.updateTicketStatus(newValue.toString());
           
          },
        ),
      ),
    );
  }
}

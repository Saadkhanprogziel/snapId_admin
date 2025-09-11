import 'package:admin/controller/app_controller.dart';
import 'package:admin/controller/support_controller/support_chat_controller.dart';
import 'package:admin/models/support_model/tickets_model.dart';
import 'package:admin/views/support/support_chat/widgets/chat_section.dart';
import 'package:admin/views/support/support_chat/widgets/ticketDetailsCard.dart';
import 'package:admin/views/support/support_list_widget/ticket_status_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SupportChatScreen extends StatelessWidget {
  final TicketDetails ticket;
  SupportChatScreen({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final SupportChatController controller = Get.put(SupportChatController());

    controller.setTicketModel(ticket);

    return Scaffold(
      backgroundColor:
          isDark ? Theme.of(context).scaffoldBackgroundColor : Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    final appController = Get.find<AppController>();
                    appController.closeDrawer();
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF374151) : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isDark
                            ? Colors.grey.shade600
                            : Colors.grey.shade300,
                        width: 0.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.arrow_forward,
                      size: 18,
                      color: isDark ? Colors.white : const Color(0xFF6B7280),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'Support Ticket',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF111827),
                  ),
                ),
                const Spacer(),
                StatusDropdown(),
              ],
            ),
            const SizedBox(height: 24),
            TicketDetailsCard(isDark: isDark, controller: controller),
            const SizedBox(height: 20),
            Expanded(
              child: ChatSection(isDark: isDark, controller: controller),
            ),
          ],
        ),
      ),
    );
  }
}



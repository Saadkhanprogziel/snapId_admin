import 'package:admin/controller/support_controller/support_chat_controller.dart';
import 'package:admin/views/support/support_chat/widgets/chat_messages.dart';
import 'package:admin/views/support/support_chat/widgets/message_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatSection extends StatelessWidget {
  final bool isDark;
  final SupportChatController controller;
  final FocusNode _messageFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  ChatSection({
    super.key,
    required this.isDark,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          width: 0.5,
          color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          ChatHeader(isDark: isDark, controller: controller),
          Expanded(
            child: ChatMessages(
              isDark: isDark,
              controller: controller,
              scrollController: _scrollController,
            ),
          ),
          MessageInput(
            isDark: isDark,
            controller: controller,
            messageFocusNode: _messageFocusNode,
          ),
        ],
      ),
    );
  }
}

class ChatHeader extends StatelessWidget {
  final bool isDark;
  final SupportChatController controller;

  const ChatHeader({
    super.key,
    required this.isDark,
    required this.controller,
  });

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;

      case 'offline':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 20,
            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
          ),
          const SizedBox(width: 12),
          Text(
            "Conversation",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF111827),
            ),
          ),
          const SizedBox(width: 8),
          Obx(() => Text(
                "(${controller.messageCount})",
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                ),
              )),
          const Spacer(),
          Obx(() => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(controller.chatStatus.value)
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Active",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: _getStatusColor("active"),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

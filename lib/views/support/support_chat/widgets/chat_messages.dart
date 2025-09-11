
import 'package:admin/controller/support_controller/support_chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatMessages extends StatelessWidget {
  final bool isDark;
  final SupportChatController controller;
  final ScrollController scrollController;

  const ChatMessages({
    super.key,
    required this.isDark,
    required this.controller,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        }
      });

      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (controller.messages.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.chat_bubble_outline,
                size: 48,
                color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                "No messages yet",
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        );
      }

      return SingleChildScrollView(
        controller: scrollController,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: controller.messages.map((message) {
            final isLast = message == controller.messages.last;
            return Column(
              children: [
                MessageBubble(
                  message: message.content,
                  isCustomer: message.isCustomer,
                  time: message.formattedTime,
                  senderInitial: message.senderInitial,
                  isDark: isDark,
                ),
                if (!isLast) const SizedBox(height: 16),
              ],
            );
          }).toList(),
        ),
      );
    });
  }
}

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isCustomer;
  final String time;
  final String senderInitial;
  final bool isDark;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isCustomer,
    required this.time,
    required this.senderInitial,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final isSupport = !isCustomer;
    return Row(
      mainAxisAlignment:
          isSupport ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isSupport) ...[
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.green,
            child: Text(
              senderInitial,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
        Flexible(
          child: Column(
            crossAxisAlignment:
                isSupport ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                constraints: const BoxConstraints(maxWidth: 300),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSupport
                      ? const Color(0xFF3B82F6)
                      : isDark
                          ? const Color(0xFF374151)
                          : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  message,
                  style: TextStyle(
                    fontSize: 14,
                    color: isSupport
                        ? Colors.white
                        : isDark
                            ? Colors.white
                            : Colors.black87,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
        if (isSupport) ...[
          const SizedBox(width: 12),
          CircleAvatar(
            radius: 16,
            backgroundColor: const Color(0xFF3B82F6),
            child: Text(
              senderInitial,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

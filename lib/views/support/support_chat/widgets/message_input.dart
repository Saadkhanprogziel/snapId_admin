import 'package:admin/controller/support_controller/support_chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessageInput extends StatelessWidget {
  final bool isDark;
  final SupportChatController controller;
  final FocusNode messageFocusNode;

  const MessageInput({
    super.key,
    required this.isDark,
    required this.controller,
    required this.messageFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
            width: 0.5,
          ),
        ),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF374151) : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? Colors.grey.shade600 : Colors.grey.shade300,
                width: 0.5,
              ),
            ),
            child: TextField(
              controller: controller.messageTextController,
              focusNode: messageFocusNode,
              maxLines: 3,
              minLines: 1,
              textInputAction: TextInputAction.send,
              style: TextStyle(
                fontSize: 15,
                color: isDark ? Colors.white : Colors.black87,
              ),
              decoration: InputDecoration(
                hintText: "Type your reply...",
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
              ),
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  controller.sendMessage();
                  messageFocusNode.requestFocus();
                }
              },
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Spacer(),
              Obx(() => ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 20),
                      elevation: 0,
                    ),
                    onPressed: controller.isSendingMessage.value
                        ? null
                        : () {
                            controller.sendMessage();
                          },
                    icon: controller.isSendingMessage.value
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.send, color: Colors.white, size: 16),
                    label: Text(
                      controller.isSendingMessage.value
                          ? "Sending..."
                          : "Send Reply",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}

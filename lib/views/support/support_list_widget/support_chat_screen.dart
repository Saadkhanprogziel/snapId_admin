import 'package:admin/controller/app_controller.dart';
import 'package:admin/controller/support_controller/support_chat_controller.dart';
import 'package:admin/models/support_model/tickets_model.dart';
import 'package:admin/views/support/support_list_widget/ticket_status_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SupportChatScreen extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();
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
            header(isDark, controller),
            const SizedBox(height: 24),
            _buildDetailsCard(isDark, controller),
            const SizedBox(height: 20),
            Expanded(
              child: _buildChatSection(isDark, controller),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsCard(bool isDark, SupportChatController controller) {
    return Obx(() => Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Ticket Details",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildDetailItem(
                      "Customer Name",
                      controller.ticketDetails.value?.user.firstName ?? "",
                      Icons.person_outline,
                      isDark,
                    ),
                  ),
                  Expanded(
                    child: _buildDetailItem(
                      "Date Created",
                      controller.ticketDetails.value != null
                          ? controller.formatDate(
                              controller.ticketDetails.value!.createdAt)
                          : "",
                      Icons.calendar_today_outlined,
                      isDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildDetailItem(
                "Subject",
                controller.ticketDetails.value?.description ?? "",
                Icons.subject_outlined,
                isDark,
              ),
            ],
          ),
        ));
  }

  Widget _buildDetailItem(
      String label, String value, IconData icon, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.grey.shade700.withOpacity(0.3)
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 22,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF111827),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatSection(bool isDark, SupportChatController controller) {
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
          Container(
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
                        color: isDark
                            ? Colors.grey.shade400
                            : Colors.grey.shade600,
                      ),
                    )),
                const Spacer(),
                Obx(() => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(controller.chatStatus.value)
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        controller.chatStatus.value,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: _getStatusColor(controller.chatStatus.value),
                        ),
                      ),
                    )),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (_scrollController.hasClients) {
                  _scrollController
                      .jumpTo(_scrollController.position.maxScrollExtent);
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
                        color: isDark
                            ? Colors.grey.shade600
                            : Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "No messages yet",
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark
                              ? Colors.grey.shade400
                              : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: controller.messages.map((message) {
                    final isLast = message == controller.messages.last;
                    return Column(
                      children: [
                        _buildMessageBubble(
                          message.content,
                          message.isCustomer,
                          message.formattedTime,
                          message.senderInitial,
                          isDark,
                        ),
                        if (!isLast) const SizedBox(height: 16),
                      ],
                    );
                  }).toList(),
                ),
              );
            }),
          ),
          Container(
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
                    color:
                        isDark ? const Color(0xFF374151) : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          isDark ? Colors.grey.shade600 : Colors.grey.shade300,
                      width: 0.5,
                    ),
                  ),
                  child: TextField(
                    controller: controller.messageTextController,
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
                        color: isDark
                            ? Colors.grey.shade400
                            : Colors.grey.shade500,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                    ),
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        controller.sendMessage();
                      }
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        // Handle file attachment
                      },
                      icon: Icon(
                        Icons.attach_file,
                        size: 18,
                        color: isDark
                            ? Colors.grey.shade400
                            : Colors.grey.shade600,
                      ),
                      label: Text(
                        "Attach Files",
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark
                              ? Colors.grey.shade400
                              : Colors.grey.shade600,
                        ),
                      ),
                    ),
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
                              : const Icon(Icons.send,
                                  color: Colors.white, size: 16),
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
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(String message, bool isCustomer, String time,
      String senderInitial, bool isDark) {
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'closed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget header(bool isDark, SupportChatController controller) {
    return Row(
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
                color: isDark ? Colors.grey.shade600 : Colors.grey.shade300,
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
    );
  }
}

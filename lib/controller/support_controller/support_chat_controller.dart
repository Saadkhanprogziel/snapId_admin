import 'package:admin/models/support_model/message.dart';
import 'package:admin/models/support_model/tickets_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SupportChatController extends GetxController {
  var chatStatus = 'Open'.obs;
  final List<String> statuses = ['Open', 'Pending', 'Closed'];
  var ticketDetails = Rxn<TicketDetails>();

  var isLoading = false.obs;
  var isSendingMessage = false.obs;

  final messageTextController = TextEditingController();

  var messages = <Message>[].obs;

  void setTicketModel(TicketDetails? ticket) {
    ticketDetails.value = ticket;
    if (ticketDetails.value?.id != null) {
      loadMessages();
    }
  }

  String formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }

  @override
  void onInit() {
    super.onInit();

    loadMessages();
  }

  @override
  void onClose() {
    messageTextController.dispose();
    super.onClose();
  }

  void updateTicketStatus(String value) {
    chatStatus.value = value;
  }

  Future<void> loadMessages() async {
    if (ticketDetails.value?.id == null) return;

    try {
      isLoading.value = true;

      await Future.delayed(const Duration(milliseconds: 500));

      final List<Map<String, dynamic>> sampleData = [
        {
          'id': '1',
          'content':
              "Hi, I'm having trouble with my payment. It keeps getting declined even though my card is valid.",
          'isCustomer': true,
          'timestamp': '2:30 PM',
          'senderName': ticketDetails.value!.user.firstName,
          'createdAt': DateTime.now()
              .subtract(const Duration(hours: 2, minutes: 30))
              .toIso8601String(),
        },
        {
          'id': '2',
          'content':
              "Hello ${ticketDetails.value!.user.firstName}! I'm sorry to hear about the payment issue. Let me help you with that. Can you please tell me which payment method you're trying to use?",
          'isCustomer': false,
          'timestamp': '2:32 PM',
          'senderName': 'Support',
          'createdAt': DateTime.now()
              .subtract(const Duration(hours: 2, minutes: 28))
              .toIso8601String(),
        },
        {
          'id': '3',
          'content':
              "I'm using my Visa card ending in 1234. It worked fine last month.",
          'isCustomer': true,
          'timestamp': '2:35 PM',
          'senderName': ticketDetails.value!.user.firstName,
          'createdAt': DateTime.now()
              .subtract(const Duration(hours: 2, minutes: 25))
              .toIso8601String(),
        },
        {
          'id': '4',
          'content':
              "Thank you for that information. Let me check your payment method on our end. Can you please verify the billing address associated with this card?",
          'isCustomer': false,
          'timestamp': '2:38 PM',
          'senderName': 'Support',
          'createdAt': DateTime.now()
              .subtract(const Duration(hours: 2, minutes: 22))
              .toIso8601String(),
        },
        {
          'id': '5',
          'content':
              "Sure! The billing address is 123 Main Street, New York, NY 10001",
          'isCustomer': true,
          'timestamp': '2:40 PM',
          'senderName': ticketDetails.value!.user.firstName,
          'createdAt': DateTime.now()
              .subtract(const Duration(hours: 2, minutes: 20))
              .toIso8601String(),
        },
        {
          'id': '6',
          'content':
              "I can see the issue now. There seems to be a mismatch in the ZIP code. Please try updating your payment method with the correct ZIP code and try again.",
          'isCustomer': false,
          'timestamp': '2:42 PM',
          'senderName': 'Support',
          'createdAt': DateTime.now()
              .subtract(const Duration(hours: 2, minutes: 18))
              .toIso8601String(),
        },
        {
          'id': '7',
          'content':
              "Oh, I see! Let me update that right now. Thank you for your help!",
          'isCustomer': true,
          'timestamp': '2:45 PM',
          'senderName': ticketDetails.value!.user.firstName,
          'createdAt': DateTime.now()
              .subtract(const Duration(hours: 2, minutes: 15))
              .toIso8601String(),
        },
        {
          'id': '8',
          'content':
              "You're welcome! Please let me know if you need any further assistance. I'll keep this ticket open until you confirm the payment is working.",
          'isCustomer': false,
          'timestamp': '2:47 PM',
          'senderName': 'Support',
          'createdAt': DateTime.now()
              .subtract(const Duration(hours: 2, minutes: 13))
              .toIso8601String(),
        },
      ];

      messages.value =
          sampleData.map((data) => Message.fromJson(data)).toList();
    } catch (e) {
      print('Error loading messages: $e');
      Get.snackbar(
        'Error',
        'Failed to load messages',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendMessage() async {
    final messageContent = messageTextController.text.trim();
    if (messageContent.isEmpty) return;

    try {
      isSendingMessage.value = true;

      final newMessage = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: messageContent,
        isCustomer: false,
        timestamp: _formatCurrentTime(),
        senderName: 'Support',
        createdAt: DateTime.now(),
      );

      messageTextController.clear();

      messages.add(newMessage);

      await Future.delayed(const Duration(milliseconds: 300));
    } catch (e) {
      print('Error sending message: $e');
      Get.snackbar(
        'Error',
        'Failed to send message',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSendingMessage.value = false;
    }
  }

  void addMessage(Message message) {
    messages.add(message);
  }

  void removeMessage(String messageId) {
    messages.removeWhere((message) => message.id == messageId);
  }

  void updateMessage(String messageId, String newContent) {
    final index = messages.indexWhere((message) => message.id == messageId);
    if (index != -1) {
      messages[index] = messages[index].copyWith(content: newContent);
    }
  }

  int get messageCount => messages.length;

  int get customerMessageCount => messages.where((m) => m.isCustomer).length;

  int get supportMessageCount => messages.where((m) => !m.isCustomer).length;

  String _formatCurrentTime() {
    final now = DateTime.now();
    final hour = now.hour > 12
        ? now.hour - 12
        : now.hour == 0
            ? 12
            : now.hour;
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  Future<void> refreshMessages() async {
    await loadMessages();
  }

  void markAsRead() {}
}

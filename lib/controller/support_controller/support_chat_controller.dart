import 'dart:developer';

import 'package:admin/controller/support_controller/support_controller.dart';
import 'package:admin/main.dart';
import 'package:admin/models/support_model/message.dart';
import 'package:admin/models/support_model/tickets_model.dart';
import 'package:admin/repositories/chat_repository/chat_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SupportChatController extends GetxController {
  final chatRepository = ChatRepository();
  final supportController = Get.find<SupportController>();

  var chatStatus = 'OPEN'.obs;
  final List<String> statuses = ['OPEN', 'PENDING', 'CLOSED'];
  var ticketDetails = Rxn<TicketDetails>();

  var isLoading = false.obs;
  var isSendingMessage = false.obs;
  var isTyping = false.obs;

  final messageTextController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  var messages = <ChatMessage>[].obs;
  var currentChatId = ''.obs;
  var currentTicketId = ''.obs;
  var isInitialized = false.obs;

  void setTicketModel(TicketDetails? ticket) async {
    ticketDetails.value = ticket;
    if (ticketDetails.value?.id != null) {
      chatStatus.value = ticket!.status;
      currentChatId.value = ticketDetails.value?.chatId ?? "";
      currentTicketId.value = ticketDetails.value?.id ?? "";

      await _initializeChat();
    }
  }

  
  Future<void> _initializeChat() async {
    if (currentChatId.value.isEmpty || isInitialized.value) return;

    log("[_initializeChat] Initializing chat with ID: ${currentChatId.value}");

    try {
      
      joinRoom();

      
      await loadMessages();

      
      isInitialized.value = true;
    } catch (e) {
      log("[_initializeChat] Error during initialization: $e");
    }
  }

  String formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }

  @override
  void onInit() {
    super.onInit();
    
    
  }

  @override
  void onClose() {
    messageTextController.dispose();
    scrollController.dispose();

    leaveRoom();
    super.onClose();
  }

  void updateTicketStatus(String value) {
    print("Updating ticket ${currentTicketId.value} to $value");
    chatStatus.value = value;

    _updateTicketStatusOnServer(value);
  }

  Future<void> _updateTicketStatusOnServer(String status) async {
    try {
      String eventName;

      
      switch (status.toUpperCase()) {
        case 'OPEN':
          eventName = 'admin_open_ticket';
          break;
        case 'PENDING':
          eventName = 'admin_pending_ticket';
          break;
        case 'CLOSED':
          eventName = 'admin_close_ticket';
          break;
        default:
          eventName = 'admin_update_ticket_status';
          break;
      }

      appSocket.fireEvent(eventName, {
        'ticketId': currentTicketId.value,

        
      });

      

      log("[_updateTicketStatusOnServer] Fired event: $eventName with status: $status");
    } catch (e) {
      log("[_updateTicketStatusOnServer] Error updating status: $e");
    }
  }

  Future<void> loadMessages() async {
    if (currentChatId.value.isEmpty) {
      log("[loadMessages] No chat ID available");
      return;
    }

    try {
      isLoading.value = true;
      log("[loadMessages] Loading messages for chat: ${currentChatId.value}");

      await chatRepository
          .fetchAllMessages(chatId: currentChatId.value, limit: 50)
          .then((response) {
        response.fold((error) {
          log("[loadMessages] Error from repository: $error");
          Get.snackbar(
            'Error',
            'Failed to load messages: $error',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }, (success) {
          messages.value = success;

          
          _scrollToBottom();
        });
      });
    } catch (e) {
      log("[loadMessages] Error loading messages: $e");
      Get.snackbar(
        'Error',
        'Failed to load messages: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendMessage() async {
    final messageContent = messageTextController.text.trim();

    if (messageContent.isEmpty) {
      log("[sendMessage] Message content is empty");
      return;
    }

    if (currentChatId.value.isEmpty) {
      log("[sendMessage] No chat ID available");
      Get.snackbar(
        'Error',
        'No active chat session',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isSendingMessage.value = true;
      log("[sendMessage] Sending message: $messageContent");

      appSocket.fireEvent('send_message', {
        'chatID': currentChatId.value,
        'content': messageContent,
      });

      messageTextController.clear();

      _scrollToBottom();
    } catch (e) {
      log("[sendMessage] Error sending message: $e");
      Get.snackbar(
        'Error',
        'Failed to send message: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSendingMessage.value = false;
    }
  }

  void listenEvents() {
    log("[listenEvents] Setting up socket event listeners");

    appSocket.listenToRecieveMessageEvent((data) {
      log("[listenEvents] Message received: $data");
      try {
        final message = ChatMessage.fromJson(data);
        addNewMessage(message);
      } catch (e) {
        log("[listenEvents] Error parsing received message: $e");
      }
    });

    appSocket.listenToEvent('user_typing', (data) {
      log("[listenEvents] User typing event: $data");
      if (data['chatID'] == currentChatId.value) {
        isTyping.value = data['isTyping'] ?? false;
      }
    });

    appSocket.listenToEvent('status_updated', (data) {
      log("[listenEvents] Status updated: $data");
      if (data['chatID'] == currentChatId.value) {
        chatStatus.value = data['status'] ?? 'Open';
      }
    });
    appSocket.listenToEvent('ticket_error', (data) {
      log("[listenEvents] Status updated: $data");
     
    });

    
    appSocket.listenToEvent('ticket_opened_success', (data) {
      log("[listenEvents] Ticket opened successfully: ${data['ticket']['id']}");

      final ticketData = data['ticket'];
      if (ticketData == null) return;

      final ticketId = ticketData['id'];

      if (ticketId == currentTicketId.value) {
        final tickets = supportController.ticketListData.value?.tickets;
        if (tickets != null) {
          for (var t in tickets) {
            if (t.id == ticketId) {
              t.status = 'OPEN'; 
              break;
            }
          }
          supportController.ticketListData.refresh(); 
        }
      }
    });
    appSocket.listenToEvent('ticket_closed_success', (data) {
      log("[listenEvents] Ticket closeed successfully: ${data['ticket']['id']}");

      final ticketData = data['ticket'];
      if (ticketData == null) return;

      final ticketId = ticketData['id'];

      if (ticketId == currentTicketId.value) {
        final tickets = supportController.ticketListData.value?.tickets;
        if (tickets != null) {
          for (var t in tickets) {
            if (t.id == ticketId) {
              t.status = 'CLOSED'; 
              break;
            }
          }
          supportController.ticketListData.refresh(); 
        }
      }
    });
  }

  void addNewMessage(ChatMessage message) {
    log("[addNewMessage] Adding new message: ${message.content}");

    bool messageExists = messages.any((msg) => msg.id == message.id);

    if (!messageExists) {
      messages.add(message);

      messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));

      _scrollToBottom();

      log("[addNewMessage] Message added successfully. Total messages: ${messages.length}");
    } else {
      log("[addNewMessage] Message already exists, skipping duplicate");
    }
  }

  void joinRoom() {
    if (currentChatId.value.isEmpty) {
      log("[joinRoom] No chat ID available");
      return;
    }

    log("[joinRoom] Joining room with chatId: ${currentChatId.value}");

    try {
      appSocket.fireEvent('join_chat', {
        'chatID': currentChatId.value,
      });

      listenEvents();

      log("[joinRoom] Successfully joined room and set up listeners");
    } catch (e) {
      log("[joinRoom] Error joining room: $e");
    }
  }

  void leaveRoom() {
    if (currentChatId.value.isEmpty) return;

    log("[leaveRoom] Leaving room with chatId: ${currentChatId.value}");

    try {
      appSocket.fireEvent('leave_chat', {
        'chatID': currentChatId.value,
      });
    } catch (e) {
      log("[leaveRoom] Error leaving room: $e");
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        Future.delayed(const Duration(milliseconds: 100), () {
          if (scrollController.hasClients) {
            scrollController.animateTo(
              scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      }
    });
  }

  int get messageCount => messages.length;

  int get customerMessageCount =>
      messages.where((m) => m.sender.role.toLowerCase() == 'user').length;

  int get supportMessageCount =>
      messages.where((m) => m.sender.role.toLowerCase() != 'user').length;

  String formatCurrentTime() {
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
    messages.clear();
    await loadMessages();
  }

  void cleanup() {
    messages.clear();
    messageTextController.clear();
    isLoading.value = false;
    isSendingMessage.value = false;
    isTyping.value = false;
    isInitialized.value = false;
  }

  
  Future<void> initializeChatIfNeeded() async {
    if (!isInitialized.value && currentChatId.value.isNotEmpty) {
      await _initializeChat();
    }
  }
}

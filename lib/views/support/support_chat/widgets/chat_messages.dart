import 'package:admin/constants/colors.dart';
import 'package:admin/controller/support_controller/support_chat_controller.dart';
import 'package:admin/models/support_model/message.dart';
import 'package:admin/theme/text_theme.dart';
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
        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
          ),
        );
      }

      if (controller.messages.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.chat_bubble_outline,
                size: 64,
                color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                "No messages yet",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Start a conversation with the customer",
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.grey.shade500 : Colors.grey.shade500,
                ),
              ),
            ],
          ),
        );
      }

      return Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  ...controller.messages.asMap().entries.map((entry) {
                    final index = entry.key;
                    final message = entry.value;
                    final isLast = index == controller.messages.length - 1;
                    final previousMessage = index > 0 ? controller.messages[index - 1] : null;
                    final showSenderInfo = previousMessage == null || 
                        previousMessage.sender.id != message.sender.id;
                    
                    return Column(
                      children: [
                        MessageBubble(
                          message: message,
                          isLargeScreen: MediaQuery.of(context).size.width > 600,
                          isDark: isDark,
                          showSenderInfo: showSenderInfo,
                        ),
                        SizedBox(height: isLast ? 8 : 12),
                      ],
                    );
                  }).toList(),
                  // Show typing indicator if someone is typing
                  if (controller.isTyping.value)
                    TypingIndicator(isDark: isDark),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isLargeScreen;
  final bool isDark;
  final bool showSenderInfo;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.isLargeScreen,
    required this.isDark,
    required this.showSenderInfo,
  }) : super(key: key);

  // Since you're the admin, your messages (admin role) should be on the right
  // Customer messages (user role) should be on the left
  bool get isAdminMessage => message.sender.role.toLowerCase() == 'admin' || 
                           message.sender.role.toLowerCase() == 'support';

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isAdminMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          left: isAdminMessage ? 40 : 0,
          right: isAdminMessage ? 0 : 40,
          top: 2,
          bottom: 2,
        ),
        child: Column(
          crossAxisAlignment: isAdminMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (showSenderInfo && !isAdminMessage) ...[
              Padding(
                padding: const EdgeInsets.only(left: 12, bottom: 4),
                child: Text(
                  '${message.sender.firstName} ${message.sender.lastName}',
                  style: TextStyle(
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isLargeScreen ? 16 : 14,
                vertical: isLargeScreen ? 12 : 10,
              ),
              decoration: BoxDecoration(
                color: _getBubbleColor(),
                borderRadius: _getBorderRadius(),
                boxShadow: _getBoxShadow(),
                border: _getBorder(),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.content,
                    style: _getMessageTextStyle(),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTime(message.createdAt),
                        style: _getTimeTextStyle(),
                      ),
                      if (isAdminMessage) ...[
                        const SizedBox(width: 4),
                        Icon(
                          _getStatusIcon(),
                          size: 12,
                          color: _getTimeTextColor(),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getBubbleColor() {
    if (isAdminMessage) {
      return AppColors.primaryColor;
    }
    
    // Customer message bubble color
    if (isDark) {
      return Colors.grey[800]?.withOpacity(0.8) ?? Colors.grey[800]!;
    } else {
      return Colors.grey[100]!;
    }
  }

  Border? _getBorder() {
    if (isAdminMessage) {
      return null; // No border for admin messages
    }
    
    return Border.all(
      color: isDark 
          ? Colors.grey.withOpacity(0.3) 
          : Colors.grey.withOpacity(0.2),
      width: 1,
    );
  }

  Color _getMessageTextColor() {
    if (isAdminMessage) {
      return Colors.white;
    }
    return isDark ? Colors.white : Colors.black87;
  }

  Color _getTimeTextColor() {
    if (isAdminMessage) {
      return Colors.white.withOpacity(0.7);
    }
    return isDark 
        ? Colors.white.withOpacity(0.6) 
        : Colors.black54;
  }

  TextStyle _getMessageTextStyle() {
    return CustomTextTheme.regular16.copyWith(
      color: _getMessageTextColor(),
      fontWeight: FontWeight.w400,
      fontSize: 14,
      height: 1.4,
    );
  }

  TextStyle _getTimeTextStyle() {
    return TextStyle(
      color: _getTimeTextColor(),
      fontSize: 10,
      fontWeight: FontWeight.w400,
    );
  }

  BorderRadius _getBorderRadius() {
    if (isAdminMessage) {
      // Admin message bubble (right side)
      return const BorderRadius.only(
        topLeft: Radius.circular(18),
        bottomLeft: Radius.circular(18),
        topRight: Radius.circular(4),
        bottomRight: Radius.circular(18),
      );
    } else {
      // Customer message bubble (left side)
      return const BorderRadius.only(
        topLeft: Radius.circular(4),
        bottomLeft: Radius.circular(18),
        topRight: Radius.circular(18),
        bottomRight: Radius.circular(18),
      );
    }
  }

  List<BoxShadow>? _getBoxShadow() {
    if (!isLargeScreen) return null;

    if (isAdminMessage) {
      return [
        BoxShadow(
          color: AppColors.primaryColor.withOpacity(0.2),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];
    }
    
    return [
      BoxShadow(
        color: isDark 
            ? Colors.black.withOpacity(0.2)
            : Colors.grey.withOpacity(0.1),
        blurRadius: 4,
        offset: const Offset(0, 1),
      ),
    ];
  }

  IconData _getStatusIcon() {
    switch (message.status.toLowerCase()) {
      case 'sent':
        return Icons.check;
      case 'delivered':
        return Icons.done_all;
      case 'read':
        return Icons.done_all;
      default:
        return Icons.access_time;
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      if (difference.inDays == 1) {
        return 'Yesterday';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      } else {
        return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
      }
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

class TypingIndicator extends StatefulWidget {
  final bool isDark;
  
  const TypingIndicator({
    Key? key,
    required this.isDark,
  }) : super(key: key);

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationController);
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: widget.isDark ? Colors.grey[800]?.withOpacity(0.8) : Colors.grey[200],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              bottomLeft: Radius.circular(18),
              topRight: Radius.circular(18),
              bottomRight: Radius.circular(18),
            ),
            border: Border.all(
              color: widget.isDark 
                  ? Colors.grey.withOpacity(0.3) 
                  : Colors.grey.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Customer is typing',
                style: TextStyle(
                  color: widget.isDark ? Colors.grey[400] : Colors.grey[600],
                  fontStyle: FontStyle.italic,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 8),
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Row(
                    children: List.generate(3, (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: (widget.isDark ? Colors.grey[400] : Colors.grey[600])!
                              .withOpacity(
                            (_animation.value + (index * 0.3)) % 1.0,
                          ),
                          shape: BoxShape.circle,
                        ),
                      );
                    }),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
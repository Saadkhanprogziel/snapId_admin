class Message {
  final String id;
  final String content;
  final bool isCustomer;
  final String timestamp;
  final String senderName;
  final String? senderAvatar;
  final DateTime createdAt;

  Message({
    required this.id,
    required this.content,
    required this.isCustomer,
    required this.timestamp,
    required this.senderName,
    this.senderAvatar,
    required this.createdAt,
  });

  // Factory constructor to create a Message from JSON
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] ?? '',
      content: json['content'] ?? '',
      isCustomer: json['isCustomer'] ?? false,
      timestamp: json['timestamp'] ?? '',
      senderName: json['senderName'] ?? '',
      senderAvatar: json['senderAvatar'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  // Method to convert Message to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'isCustomer': isCustomer,
      'timestamp': timestamp,
      'senderName': senderName,
      'senderAvatar': senderAvatar,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Helper method to get sender initial
  String get senderInitial {
    return senderName.isNotEmpty ? senderName[0].toUpperCase() : '?';
  }

  // Helper method to format timestamp for display
  String get formattedTime {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(createdAt.year, createdAt.month, createdAt.day);
    
    if (messageDate == today) {
      // Today - show time only
      final hour = createdAt.hour > 12 ? createdAt.hour - 12 : createdAt.hour == 0 ? 12 : createdAt.hour;
      final minute = createdAt.minute.toString().padLeft(2, '0');
      final period = createdAt.hour >= 12 ? 'PM' : 'AM';
      return '$hour:$minute $period';
    } else {
      // Other days - show date and time
      final month = createdAt.month.toString().padLeft(2, '0');
      final day = createdAt.day.toString().padLeft(2, '0');
      return '$month/$day/${createdAt.year}';
    }
  }

  // Copy with method for immutable updates
  Message copyWith({
    String? id,
    String? content,
    bool? isCustomer,
    String? timestamp,
    String? senderName,
    String? senderAvatar,
    DateTime? createdAt,
  }) {
    return Message(
      id: id ?? this.id,
      content: content ?? this.content,
      isCustomer: isCustomer ?? this.isCustomer,
      timestamp: timestamp ?? this.timestamp,
      senderName: senderName ?? this.senderName,
      senderAvatar: senderAvatar ?? this.senderAvatar,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
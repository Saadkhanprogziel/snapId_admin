import 'dart:convert';

class UsersModerationHistory {
  final String id;
  final String userId;
  final String actionType;
  final String reason;
  final String? performedBy;
  final DateTime performedAt;

  UsersModerationHistory({
    required this.id,
    required this.userId,
    required this.actionType,
    required this.reason,
    this.performedBy,
    required this.performedAt,
  });

  factory UsersModerationHistory.fromJson(Map<String, dynamic> json) {
    return UsersModerationHistory(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      actionType: json['actionType'] ?? '',
      reason: json['reason'] ?? '',
      performedBy: json['performedBy'],
      performedAt: json['performedAt'] != null
          ? DateTime.parse(json['performedAt'])
          : DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'actionType': actionType,
      'reason': reason,
      'performedBy': performedBy,
      'performedAt': performedAt.toIso8601String(),
    };
  }

  static List<UsersModerationHistory> listFromJson(String str) =>
      List<UsersModerationHistory>.from(json.decode(str).map((x) => UsersModerationHistory.fromJson(x)));
}

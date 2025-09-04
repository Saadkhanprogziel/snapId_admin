import 'dart:convert';

class UsersOrderData {
  final String id;
  final String userId;
  final String planId;
  final double amount;
  final String currency;
  final String status;
  final String platform;
  final DateTime createdAt;

  UsersOrderData({
    required this.id,
    required this.userId,
    required this.planId,
    required this.amount,
    required this.currency,
    required this.status,
    required this.platform,
    required this.createdAt,
  });

  factory UsersOrderData.fromJson(Map<String, dynamic> json) {
    return UsersOrderData(
      id: json['id'] as String,
      userId: json['userId'] as String,
      planId: json['plan'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      status: json['status'] as String,
      platform: json['platform'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'plan': planId,
      'amount': amount,
      'currency': currency,
      'status': status,
      'platform': platform,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  static List<UsersOrderData> listFromJson(String str) {
    final data = json.decode(str) as List<dynamic>;
    return data.map((e) => UsersOrderData.fromJson(e)).toList();
  }

  static String listToJson(List<UsersOrderData> payments) {
    final data = payments.map((e) => e.toJson()).toList();
    return json.encode(data);
  }
}

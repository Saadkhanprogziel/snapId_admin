
class UserActivityModel {
  final String time;
  final String name;
  final String email;
  final String activity;
  final String plateform;

  UserActivityModel({
    required this.time,
    required this.name,
    required this.email,
    required this.activity,
    required this.plateform,
  });
}

class BuyerData {
  final int rank;
  final String name;
  final String country;
  final String email;
  final int orders;
  final double revenue;
  final String plateform;

  BuyerData({
    required this.rank,
    required this.name,
    required this.country,
    required this.email,
    required this.orders,
    required this.revenue,
    required this.plateform,
  });
}

class OrderData {
  final String orderId;
  final String userEmail;
  final String notes;
  final String date;
  final String subscription;
  final double amount;
  final String status;

  OrderData({
    required this.orderId,
    required this.userEmail,
    required this.notes,
    required this.date,
    required this.subscription,
    required this.amount,
    required this.status,
  });
}

class UserTableModel {
  final String? userId;
  final String? name;
  final String? email;
  final DateTime? signupDate;
  final String? subscription;
  final String? signupMethod;
  final String? platform;
  final String? status; // Added status field

  UserTableModel({
    this.userId,
    this.name,
    this.email,
    this.signupDate,
    this.subscription,
    this.signupMethod,
    this.platform,
    this.status, // Included in constructor
  });

  // Factory method to create a User from a map (e.g., from JSON)
  factory UserTableModel.fromMap(Map<String, dynamic> map) {
    return UserTableModel(
      userId: map['userId'],
      name: map['name'],
      email: map['email'],
      signupDate: map['signupDate'] != null
          ? DateTime.tryParse(map['signupDate'])
          : null,
      subscription: map['subscription'],
      signupMethod: map['signupMethod'],
      platform: map['platform'],
      status: map['status'], // Added here
    );
  }

  // Convert User instance to a map (e.g., for API or database)
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'signupDate': signupDate?.toIso8601String(),
      'subscription': subscription,
      'signupMethod': signupMethod,
      'platform': platform,
      'status': status, // Added here
    };
  }
}

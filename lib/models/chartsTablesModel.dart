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

class UserModel {
  final String? userId;
  final String? name;
  final String? email;
  final DateTime? signupDate;
  final String? subscription;
  final String? signupMethod;
  final String? platform;
  final String? country;
  final String? status; // Added status field

  UserModel({
    this.userId,
    this.name,
    this.email,
    this.signupDate,
    this.subscription,
    this.signupMethod,
    this.platform,
    this.country,
    this.status,
  });
}

class SupportDataModel {
  final String userId;
  final String name;
  final String subject;
  final String date;
  final String status;
  final String emailAddress;

  SupportDataModel({
    required this.userId,
    required this.name,
    required this.subject,
    required this.date,
    required this.status,
    required this.emailAddress,
  });
}

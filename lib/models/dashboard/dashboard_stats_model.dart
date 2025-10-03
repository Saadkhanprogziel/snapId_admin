// models/dashboard_model.dart
class DashboardStatsModel {
  final Users users;
  final double totalRevenue;
  final Orders orders;
  final Support support;

  DashboardStatsModel({
    required this.users,
    required this.totalRevenue,
    required this.orders,
    required this.support,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return DashboardStatsModel(
      users: Users.fromJson(json['users']),
      totalRevenue: double.parse(json['totalRevenue'].toString()),

      orders: Orders.fromJson(json['orders']),
      support: Support.fromJson(json['support']),
    );
  }
}

class Users {
  final int totalUsers;
  final UserIncrease userIncreaseThisMonth;

  Users({
    required this.totalUsers,
    required this.userIncreaseThisMonth,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      totalUsers: json['totalUsers'],
      userIncreaseThisMonth: UserIncrease.fromJson(json['userIncreaseThisMonth']),
    );
  }
}

class UserIncrease {
  final DateTime month;
  final int newUsersCount;

  UserIncrease({required this.month, required this.newUsersCount});

  factory UserIncrease.fromJson(Map<String, dynamic> json) {
    return UserIncrease(
      month: DateTime.parse(json['month']),
      newUsersCount: json['newUsersCount'],
    );
  }
}

class Orders {
  final int totalOrders;
  final OrderIncrease ordersIncreaseThisMonth;

  Orders({required this.totalOrders, required this.ordersIncreaseThisMonth});

  factory Orders.fromJson(Map<String, dynamic> json) {
    return Orders(
      totalOrders: json['totalOrders'],
      ordersIncreaseThisMonth: OrderIncrease.fromJson(json['ordersIncreaseThisMonth']),
    );
  }
}

class OrderIncrease {
  final DateTime month;
  final int newOrdersCount;

  OrderIncrease({required this.month, required this.newOrdersCount});

  factory OrderIncrease.fromJson(Map<String, dynamic> json) {
    return OrderIncrease(
      month: DateTime.parse(json['month']),
      newOrdersCount: json['newOrdersCount'],
    );
  }
}

class Support {
  final int totalSupport;
  final SupportIncrease supportIncreaseThisMonth;

  Support({required this.totalSupport, required this.supportIncreaseThisMonth});

  factory Support.fromJson(Map<String, dynamic> json) {
    return Support(
      totalSupport: json['totalSupport'],
      supportIncreaseThisMonth: SupportIncrease.fromJson(json['supportIncreaseThisMonth']),
    );
  }
}

class SupportIncrease {
  final DateTime month;
  final int newSupportCount;

  SupportIncrease({required this.month, required this.newSupportCount});

  factory SupportIncrease.fromJson(Map<String, dynamic> json) {
    return SupportIncrease(
      month: DateTime.parse(json['month']),
      newSupportCount: json['newSupportCount'],
    );
  }
}

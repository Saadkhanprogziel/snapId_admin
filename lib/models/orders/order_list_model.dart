class OrdersResponse {
  final List<OrdersData> orders;
  final OrderPagination pagination;

  OrdersResponse({required this.orders, required this.pagination});

  factory OrdersResponse.fromJson(Map<String, dynamic> json) {
    return OrdersResponse(
      orders: (json['orders'] as List)
          .map((order) => OrdersData.fromJson(order))
          .toList(),
      pagination: OrderPagination.fromJson(json['pagination']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orders': orders.map((order) => order.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }
}

class OrdersData {
  final String id;
  final String email;
  final String planName;
  final double amount;
  final String currency;
  final String status;
  final String platform;
  final DateTime createdAt;

  OrdersData({
    required this.id,
    required this.email,
    required this.planName,
    required this.amount,
    required this.currency,
    required this.status,
    required this.platform,
    required this.createdAt,
  });

  factory OrdersData.fromJson(Map<String, dynamic> json) {
    return OrdersData(
      id: json['id'],
      email: json['email'],
      planName: json['planName'],
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'],
      status: json['status'],
      platform: json['platform'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'planName': planName,
      'amount': amount,
      'currency': currency,
      'status': status,
      'platform': platform,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class OrderPagination {
  final int totalOrders;
  final int currentPage;
  final int totalPages;

  OrderPagination({
    required this.totalOrders,
    required this.currentPage,
    required this.totalPages,
  });

  factory OrderPagination.fromJson(Map<String, dynamic> json) {
    return OrderPagination(
      totalOrders: json['totalOrders'],
      currentPage: json['currentPage'],
      totalPages: json['totalPages'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalOrders': totalOrders,
      'currentPage': currentPage,
      'totalPages': totalPages,
    };
  }
}

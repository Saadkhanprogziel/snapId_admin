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
  final String? planName; // ✅ optional now
  final double amount;
  final String currency;
  final String status;
  final String userType;
  final String platform;
  final DateTime createdAt;

  OrdersData({
    required this.id,
    required this.email,
    this.planName,
    required this.amount,
    required this.currency,
    required this.status,
    required this.userType,
    required this.platform,
    required this.createdAt,
  });

 factory OrdersData.fromJson(Map<String, dynamic> json) {
  return OrdersData(
    id: (json['id'] as String?) ?? "",
    email: (json['email'] as String?) ?? "guest",
    planName: json['planName'] as String?, // already nullable
    amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
    currency: (json['currency'] as String?) ?? "",
    status: (json['status'] as String?) ?? "",
    userType: (json['userType'] as String?) ?? "",
    platform: (json['platform'] as String?) ?? "",
    createdAt: DateTime.tryParse(json['createdAt'] ?? "") ?? DateTime.now(),
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
      'userType': userType,
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

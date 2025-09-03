class OrdersStatsData {
  final int activeSubscribers;
  final TopPlan topPlan;

  OrdersStatsData({
    required this.activeSubscribers,
    required this.topPlan,
  });

  factory OrdersStatsData.fromJson(Map<String, dynamic> json) {
    return OrdersStatsData(
      activeSubscribers: json['activeSubscribers'] as int,
      topPlan: TopPlan.fromJson(json['topPlan']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'activeSubscribers': activeSubscribers,
      'topPlan': topPlan.toJson(),
    };
  }
}

class TopPlan {
  final String planId;
  final String name;
  final int totalTransactions;

  TopPlan({
    required this.planId,
    required this.name,
    required this.totalTransactions,
  });

  factory TopPlan.fromJson(Map<String, dynamic> json) {
    return TopPlan(
      planId: json['planId'] as String,
      name: json['name'] as String,
      totalTransactions: json['totalTransactions'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'planId': planId,
      'name': name,
      'totalTransactions': totalTransactions,
    };
  }
}

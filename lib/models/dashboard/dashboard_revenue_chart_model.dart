class RevenueChartModel {
  final double total;
  final List<RevenueItem> revenue;

  RevenueChartModel({
    required this.total,
    required this.revenue,
  });

  factory RevenueChartModel.fromJson(Map<String, dynamic> json) {
    return RevenueChartModel(
      total: (json['annualRevenue'] as num).toDouble(),
      revenue: (json['revenue'] as List<dynamic>)
          .map((e) => RevenueItem.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'annualRevenue': total,
      'revenue': revenue.map((e) => e.toJson()).toList(),
    };
  }
}

class RevenueItem {
  final String label; // replaces "period"
  final double totalRevenue;

  RevenueItem({
    required this.label,
    required this.totalRevenue,
  });

  factory RevenueItem.fromJson(Map<String, dynamic> json) {
    return RevenueItem(
      label: json['label'] as String, // map "period" -> "label"
      totalRevenue: (json['totalRevenue'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label, // use "label" instead of "period"
      'totalRevenue': totalRevenue,
    };
  }
}

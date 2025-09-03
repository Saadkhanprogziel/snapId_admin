class SummaryRevenue {
  final double totalRevenue;
  final List<RevenueSummary> revenueSummary;

  SummaryRevenue({
    required this.totalRevenue,
    required this.revenueSummary,
  });

  factory SummaryRevenue.fromJson(Map<String, dynamic> json) {
    return SummaryRevenue(
      totalRevenue: (json['totalRevenue'] as num).toDouble(),
      revenueSummary: (json['revenueSummary'] as List)
          .map((e) => RevenueSummary.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalRevenue': totalRevenue,
      'revenueSummary': revenueSummary.map((e) => e.toJson()).toList(),
    };
  }
}

class RevenueSummary {
  final String label;
  final Map<String, RevenueItem> items;

  RevenueSummary({
    required this.label,
    required this.items,
  });

  factory RevenueSummary.fromJson(Map<String, dynamic> json) {
    final items = <String, RevenueItem>{};

    json.forEach((key, value) {
      if (key != 'label' && value is Map<String, dynamic>) {
        items[key] = RevenueItem.fromJson(value);
      }
    });

    return RevenueSummary(
      label: json['label'] as String,
      items: items,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'label': label,
    };

    items.forEach((key, value) {
      data[key] = value.toJson();
    });

    return data;
  }
}

class RevenueItem {
  final double revenue;
  final int count;

  RevenueItem({
    required this.revenue,
    required this.count,
  });

  factory RevenueItem.fromJson(Map<String, dynamic> json) {
    return RevenueItem(
      revenue: (json['revenue'] as num).toDouble(),
      count: (json['count'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'revenue': revenue,
      'count': count,
    };
  }
}

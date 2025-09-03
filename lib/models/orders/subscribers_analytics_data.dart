class SubscriptionAnalyticsData {
  final int totalSubscription;
  final List<SubscriptionSummary> subscriptionSummary;

  SubscriptionAnalyticsData({
    required this.totalSubscription,
    required this.subscriptionSummary,
  });

  factory SubscriptionAnalyticsData.fromJson(Map<String, dynamic> json) {
    return SubscriptionAnalyticsData(
      totalSubscription: (json['totalSubscription'] as num).toInt(),
      subscriptionSummary: (json['subscriptionSummary'] as List)
          .map((e) => SubscriptionSummary.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalSubscription': totalSubscription,
      'subscriptionSummary': subscriptionSummary.map((e) => e.toJson()).toList(),
    };
  }
}

class SubscriptionSummary {
  final String label;
  final Map<String, SubscriptionItem> items;

  SubscriptionSummary({
    required this.label,
    required this.items,
  });

  factory SubscriptionSummary.fromJson(Map<String, dynamic> json) {
    final items = <String, SubscriptionItem>{};

    json.forEach((key, value) {
      if (key != 'label' && value is Map<String, dynamic>) {
        items[key] = SubscriptionItem.fromJson(value);
      }
    });

    return SubscriptionSummary(
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

class SubscriptionItem {
  final int count;

  SubscriptionItem({
    required this.count,
  });

  factory SubscriptionItem.fromJson(Map<String, dynamic> json) {
    return SubscriptionItem(
      count: (json['count'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
    };
  }
}

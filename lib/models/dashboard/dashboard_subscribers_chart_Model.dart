// ============================================
// MODEL FILE - Use this for your model
// ============================================

class SubscriptionChartData {
  final int planCount;
  final List<SubscriptionItem> plansWithNames;

  SubscriptionChartData({
    required this.planCount,
    required this.plansWithNames,
  });

  factory SubscriptionChartData.fromJson(Map<String, dynamic> json) {
    return SubscriptionChartData(
      planCount: json['planCount'] ?? 0,
      plansWithNames: (json['plansWithNames'] as List? ?? [])
          .map((e) => SubscriptionItem.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'planCount': planCount,
      'plansWithNames': plansWithNames.map((e) => e.toJson()).toList(),
    };
  }
}

class SubscriptionItem {
  final String label;
  final int? singlePhoto;
  final int? standardPack;
  final int? familyPack;
  final int? guestPurchase;

  SubscriptionItem({
    required this.label,
    this.singlePhoto,
    this.standardPack,
    this.familyPack,
    this.guestPurchase,
  });

  factory SubscriptionItem.fromJson(Map<String, dynamic> json) {
    return SubscriptionItem(
      label: json['label'] ?? '',
      singlePhoto: _parseValue(json['Single Photo']),
      standardPack: _parseValue(json['Standard Pack']),
      familyPack: _parseValue(json['Family Pack']),
      guestPurchase: _parseValue(json['Guest Purchase']),
    );
  }

  // Helper method to parse values that might be String or int
  static int? _parseValue(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      if (singlePhoto != null) 'Single Photo': singlePhoto,
      if (standardPack != null) 'Standard Pack': standardPack,
      if (familyPack != null) 'Family Pack': familyPack,
      if (guestPurchase != null) 'Guest Purchase': guestPurchase,
    };
  }
}

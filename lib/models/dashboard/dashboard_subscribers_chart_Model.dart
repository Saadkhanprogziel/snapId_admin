class SubscriptionChartData {
  final int planCount;
  final List<SubscriptionItem> plansWithNames;

  SubscriptionChartData({
    required this.planCount,
    required this.plansWithNames,
  });

  factory SubscriptionChartData.fromJson(Map<String, dynamic> json) {
    return SubscriptionChartData(
      planCount: json['planCount'],
      plansWithNames: (json['plansWithNames'] as List)
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

  SubscriptionItem({
    required this.label,
    this.singlePhoto,
    this.standardPack,
    this.familyPack,
  });

  factory SubscriptionItem.fromJson(Map<String, dynamic> json) {
    return SubscriptionItem(
      label: json['label'],
      singlePhoto: json['Single Photo'],
      standardPack: json['Standard Pack'],
      familyPack: json['Family Pack'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      if (singlePhoto != null) 'Single Photo': singlePhoto,
      if (standardPack != null) 'Standard Pack': standardPack,
      if (familyPack != null) 'Family Pack': familyPack,
    };
  }
}

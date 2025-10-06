class TotalOrdersChartModel {
  final int filteredCount;
  final List<TotalOrders> data;

  TotalOrdersChartModel({
    required this.filteredCount,
    required this.data,
  });

  factory TotalOrdersChartModel.fromJson(Map<String, dynamic> json) {
    return TotalOrdersChartModel(
      filteredCount: json['filteredCount'] ?? 0,
      data: (json['data'] as List<dynamic>)
          .map((item) => TotalOrders.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'filteredCount': filteredCount,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class TotalOrders {
  final String label;
  final int webApp;
  final int mobileApp;

  TotalOrders({
    required this.label,
    required this.webApp,
    required this.mobileApp,
  });

  factory TotalOrders.fromJson(Map<String, dynamic> json) {
    return TotalOrders(
      label: json['label'] ?? '',
      webApp: json['WEB_APP'] ?? 0,
      mobileApp: json['MOBILE_APP'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'WEB_APP': webApp,
      'MOBILE_APP': mobileApp,
    };
  }
}

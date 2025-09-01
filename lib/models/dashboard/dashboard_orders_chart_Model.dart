class TotalOrdersChartModel {
  final String label;
  final int webApp;
  final int mobileApp;

  TotalOrdersChartModel({
    required this.label,
    this.webApp = 0,
    this.mobileApp = 0,
  });

  // Factory constructor for creating an instance from JSON
  factory TotalOrdersChartModel.fromJson(Map<String, dynamic> json) {
    return TotalOrdersChartModel(
      label: json['label'] ?? '',
      webApp: json['WEB_APP'] ?? 0,
      mobileApp: json['MOBILE_APP'] ?? 0,
    );
  }

  // Method for converting instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'WEB_APP': webApp,
      'MOBILE_APP': mobileApp,
    };
  }

  @override
  String toString() {
    return 'TotalOrderCard(label: $label, webApp: $webApp, mobileApp: $mobileApp)';
  }
}

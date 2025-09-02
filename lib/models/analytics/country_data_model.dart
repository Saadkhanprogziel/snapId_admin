class CountryData {
  final int rank;
  final String countryName;
  final int totalOrders;
  final double revenue;
  final String platformBreakdown;

  CountryData({
    required this.rank,
    required this.countryName,
    required this.totalOrders,
    required this.revenue,
    required this.platformBreakdown,
  });

  factory CountryData.fromJson(Map<String, dynamic> json) {
    return CountryData(
      rank: json['rank'] as int,
      countryName: json['countryName'] as String,
      totalOrders: json['totalOrders'] as int,
      revenue: (json['revenue'] as num).toDouble(),
      platformBreakdown: json['platformBreakdown'] as String,
    );
  }
}

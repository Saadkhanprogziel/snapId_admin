class CountryData {
  final int? rank;
  final String countryName;
  final int totalOrders;
  final String revenue;
  final String platformBreakdown;

  CountryData({
    this.rank,
    required this.countryName,
    required this.totalOrders,
    required this.revenue,
    required this.platformBreakdown,
  });

  factory CountryData.fromJson(Map<String, dynamic> json) {
    return CountryData(
      rank: json['rank'] as int?,
      countryName: json['countryName'] as String,
      totalOrders: json['totalOrders'] as int,
      revenue: (json['revenue'] ),
      platformBreakdown: json['platformBreakdown'] as String,
    );
  }

  @override
  String toString() {
    return 'CountryData(rank: $rank, countryName: $countryName, totalOrders: $totalOrders, revenue: $revenue, platformBreakdown: $platformBreakdown)';
  }
}

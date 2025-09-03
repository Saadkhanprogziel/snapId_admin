class TopBuyerModel {
  final int? rank; // Optional field
  final String userId;
  final int totalOrders;
  final double revenue;
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String profilePicture;
  final String countryName; // renamed for readability
  final int credits;
  final String gender;
  final String isActive;
  final String phoneNo;

  TopBuyerModel({
    this.rank,
    required this.userId,
    required this.totalOrders,
    required this.revenue,
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.profilePicture,
    required this.countryName, // updated
    required this.credits,
    required this.gender,
    required this.isActive,
    required this.phoneNo,
  });

  factory TopBuyerModel.fromJson(Map<String, dynamic> json) {
    return TopBuyerModel(
      rank: json['rank'],
      userId: json['userId'] ?? '',
      totalOrders: json['totalOrders'] ?? 0,
      revenue: (json['totalRevenue'] is int)
          ? (json['totalRevenue'] as int).toDouble()
          : (json['totalRevenue'] ?? 0.0).toDouble(),
      id: json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      profilePicture: json['profilePicture'] ?? '',
      countryName: json['country'] ?? '', // map JSON "country" to "countryName"
      credits: json['credits'] ?? 0,
      gender: json['gender'] ?? '',
      isActive: json['isActive'] ?? '',
      phoneNo: json['phoneNo'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rank': rank,
      'userId': userId,
      'totalOrders': totalOrders,
      'totalRevenue': revenue,
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'profilePicture': profilePicture,
      'country': countryName, // still exports as "country"
      'credits': credits,
      'gender': gender,
      'isActive': isActive,
      'phoneNo': phoneNo,
    };
  }
}
  
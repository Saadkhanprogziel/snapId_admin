class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String country;
  final String role;
  final String profilePicture;
  final String phoneNo;
  final String gender;
  final String isActive;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.country,
    required this.role,
    required this.profilePicture,
    required this.phoneNo,
    required this.gender,
    required this.isActive,
  });

  /// Create a UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      country: json['country'] ?? '',
      role: json['role'] ?? '',
      profilePicture: json['profilePicture'] ?? '',
      phoneNo: json['phoneNo'] ?? '',
      gender: json['gender'] ?? '',
      isActive: json['isActive'] ?? '',
    );
  }

  /// Convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'country': country,
      'role': role,
      'profilePicture': profilePicture,
      'phoneNo': phoneNo,
      'gender': gender,
      'isActive': isActive,
    };
  }
}

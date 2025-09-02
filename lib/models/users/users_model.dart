import 'dart:convert';

class UsersModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String profilePicture;
  final String phoneNo;
  final String country;
  final String gender;
  final String authProvider;
  final int credits;
  final String isActive;
  final String platform;
  final DateTime createdAt;
  final DateTime updatedAt;

  UsersModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.profilePicture,
    required this.phoneNo,
    required this.country,
    required this.gender,
    required this.authProvider,
    required this.credits,
    required this.isActive,
    required this.platform,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UsersModel.fromMap(Map<String, dynamic> map) {
    return UsersModel(
      id: map['id'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] ?? '',
      profilePicture: map['profilePicture'] ?? '',
      phoneNo: map['phoneNo'] ?? '',
      country: map['country'] ?? '',
      gender: map['gender'] ?? '',
      authProvider: map['authProvider'] ?? '',
      credits: map['credits'] ?? 0,
      isActive: map['isActive'] ?? '',
      platform: map['platform'] ?? '',
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(map['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'profilePicture': profilePicture,
      'phoneNo': phoneNo,
      'country': country,
      'gender': gender,
      'authProvider': authProvider,
      'credits': credits,
      'isActive': isActive,
      'platform': platform,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory UsersModel.fromJson(String source) =>
      UsersModel.fromMap(json.decode(source));

  String toJson() => json.encode(toMap());
}

class PaginationModel {
  final int totalUsers;
  final int currentPage;
  final int totalPages;

  PaginationModel({
    required this.totalUsers,
    required this.currentPage,
    required this.totalPages,
  });

  factory PaginationModel.fromMap(Map<String, dynamic> map) {
    return PaginationModel(
      totalUsers: map['totalUsers'] ?? 0,
      currentPage: map['currentPage'] ?? 1,
      totalPages: map['totalPages'] ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalUsers': totalUsers,
      'currentPage': currentPage,
      'totalPages': totalPages,
    };
  }
}

class GetAllUsersResponse {
  final List<UsersModel> users;
  final PaginationModel pagination;

  GetAllUsersResponse({
    required this.users,
    required this.pagination,
  });

  factory GetAllUsersResponse.fromMap(Map<String, dynamic> map) {
    return GetAllUsersResponse(
      users: List<UsersModel>.from(
        (map['users'] as List).map((x) => UsersModel.fromMap(x)),
      ),
      pagination: PaginationModel.fromMap(map['pagination']),
    );
  }
}

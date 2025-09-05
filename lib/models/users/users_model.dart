import 'dart:convert';

class UsersModel {
  String id;
  String firstName;
  String lastName;
  String email;
  String profilePicture;
  String phoneNo;
  String country;
  String gender;
  String authProvider;
  int credits;
  String isActive;
  String platform;
  DateTime createdAt;
  DateTime updatedAt;

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

  /// ✅ Added copyWith
  UsersModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? profilePicture,
    String? phoneNo,
    String? country,
    String? gender,
    String? authProvider,
    int? credits,
    String? isActive,
    String? platform,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UsersModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      profilePicture: profilePicture ?? this.profilePicture,
      phoneNo: phoneNo ?? this.phoneNo,
      country: country ?? this.country,
      gender: gender ?? this.gender,
      authProvider: authProvider ?? this.authProvider,
      credits: credits ?? this.credits,
      isActive: isActive ?? this.isActive,
      platform: platform ?? this.platform,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
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

class UserStatsModel {
  final TotalUsers totalUsers;
  final UserPlatforms userPlatforms;
  final UserStatus userStatus;
  final UserSignUpMethods userSignUpMethods;

  UserStatsModel({
    required this.totalUsers,
    required this.userPlatforms,
    required this.userStatus,
    required this.userSignUpMethods,
  });

  factory UserStatsModel.fromJson(Map<String, dynamic> json) {
    return UserStatsModel(
      totalUsers: TotalUsers.fromJson(json['totalUsers']),
      userPlatforms: UserPlatforms.fromJson(json['userPlatforms']),
      userStatus: UserStatus.fromJson(json['userStatus']),
      userSignUpMethods:
          UserSignUpMethods.fromJson(json['userSignUpMethods']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "totalUsers": totalUsers.toJson(),
      "userPlatforms": userPlatforms.toJson(),
      "userStatus": userStatus.toJson(),
      "userSignUpMethods": userSignUpMethods.toJson(),
    };
  }
}

class TotalUsers {
  final int totalCount;

  TotalUsers({required this.totalCount});

  factory TotalUsers.fromJson(Map<String, dynamic> json) {
    return TotalUsers(totalCount: json['totalCount'] ?? 0);
  }

  Map<String, dynamic> toJson() {
    return {"totalCount": totalCount};
  }
}

class UserPlatforms {
  final int mobileApp;
  final int webApp;

  UserPlatforms({required this.mobileApp, required this.webApp});

  factory UserPlatforms.fromJson(Map<String, dynamic> json) {
    return UserPlatforms(
      mobileApp: json['MOBILE_APP'] ?? 0,
      webApp: json['WEB_APP'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "MOBILE_APP": mobileApp,
      "WEB_APP": webApp,
    };
  }
}

class UserStatus {
  final int active;
  final int suspended;

  UserStatus({required this.active, required this.suspended});

  factory UserStatus.fromJson(Map<String, dynamic> json) {
    return UserStatus(
      active: json['Active'] ?? 0,
      suspended: json['Suspended'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "Active": active,
      "Suspended": suspended,
    };
  }
}

class UserSignUpMethods {
  final int google;
  final int apple;
  final int email;

  UserSignUpMethods({
    required this.google,
    required this.apple,
    required this.email,
  });

  factory UserSignUpMethods.fromJson(Map<String, dynamic> json) {
    return UserSignUpMethods(
      google: json['Google'] ?? 0,
      apple: json['Apple'] ?? 0,
      email: json['Email'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "Google": google,
      "Apple": apple,
      "Email": email,
    };
  }
}

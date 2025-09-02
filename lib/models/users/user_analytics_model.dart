class UserAnalytics {
  final TotalUsers totalUsers;
  final Map<String, int> userPlatforms;
  final Map<String, int> userStatus;
  final Map<String, int> userSignUpMethods;

  UserAnalytics({
    required this.totalUsers,
    required this.userPlatforms,
    required this.userStatus,
    required this.userSignUpMethods,
  });

  factory UserAnalytics.fromJson(Map<String, dynamic> json) {
    return UserAnalytics(
      totalUsers: TotalUsers.fromJson(json['totalUsers']),
      userPlatforms: Map<String, int>.from(json['userPlatforms']),
      userStatus: Map<String, int>.from(json['userStatus']),
      userSignUpMethods: Map<String, int>.from(json['userSignUpMethods']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalUsers': totalUsers.toJson(),
      'userPlatforms': userPlatforms,
      'userStatus': userStatus,
      'userSignUpMethods': userSignUpMethods,
    };
  }

  // 🔹 Convenience getters (avoid repeating string keys in controller)
  int get mobileUsers => userPlatforms['MOBILE_APP'] ?? 0;
  int get webUsers => userPlatforms['WEB_APP'] ?? 0;

  int get activeUsers => userStatus['Active'] ?? 0;
  int get suspendedUsers => userStatus['Suspended'] ?? 0;

  int get googleSignups => userSignUpMethods['Google'] ?? 0;
  int get appleSignups => userSignUpMethods['Apple'] ?? 0;
  int get emailSignups => userSignUpMethods['Email'] ?? 0;
}

class TotalUsers {
  final int totalCount;
  final String listFrom;
  final String listTo;

  TotalUsers({
    required this.totalCount,
    required this.listFrom,
    required this.listTo,
  });

  factory TotalUsers.fromJson(Map<String, dynamic> json) {
    return TotalUsers(
      totalCount: json['totalCount'],
      listFrom: json['listfrom'],
      listTo: json['listto'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalCount': totalCount,
      'listfrom': listFrom,
      'listto': listTo,
    };
  }
}

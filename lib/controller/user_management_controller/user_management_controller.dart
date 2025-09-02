import 'package:admin/models/chartsTablesModel.dart';
import 'package:admin/models/users/user_analytics_model.dart';
import 'package:admin/models/users/user_stats_model.dart';
import 'package:admin/models/users/users_model.dart';
import 'package:admin/repositories/users_repository/users_repository.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';

class UserManagementController extends GetxController {
  var currentPage = 0.obs;
  var userStatsData = Rxn<UserStatsModel>();
  var usersData = <UsersModel>[].obs;
  var pagination = Rxn<PaginationModel>(); // Add pagination observable
  final userRepo = UserRepository();
  final userAnalytics = Rxn<UserAnalytics>();
  var isLoading = false.obs;
  @override
  void onInit() {
    super.onInit();
    fetchUserData();
    fetchUserStatsData();
    fetchUserAnalytics();
  }

  fetchUserStatsData() async {
    isLoading.value = true;
    final result = await userRepo.getAllUsers(
      page: currentPage.value + 1, // API pages usually start from 1
      pageSize: 10,
      status: "ALL",
    );

    result.fold(
      (failure) {
        print("❌ Error: ${failure.message}");
        isLoading.value = false;
      },
      (response) {
        usersData.value = response.users;
        orderList
            .assignAll(response.users); // Use real data instead of mock data
        pagination.value = response.pagination; // Store pagination info
        isLoading.value = false;
      },
    );
  }

  fetchUserAnalytics() async {
    isLoading.value = true;
    final result = await userRepo.getUserAlalytics(
      page: currentPage.value + 1, // API pages usually start from 1
      pageSize: 10,
      status: "ALL",
    );

    result.fold(
      (failure) {
        print("❌ Error: ${failure.message}");
        isLoading.value = false;
      },
      (response) {
        userAnalytics.value = response;
        isLoading.value = false;

        // ✅ Update observables directly from API response

        updatePlatformUsers(response.mobileUsers, response.webUsers);
        updateUserStatus(response.activeUsers, response.suspendedUsers);
        updateSignupMethods(response.googleSignups, response.appleSignups,
            response.emailSignups);
        totalUsers.value = response.totalUsers.totalCount;
      },
    );
  }

  // This will now hold the filtered UsersModel data
  final RxList<UsersModel> orderList = <UsersModel>[].obs;

  // Observable variables for stats
  final RxInt totalUsers = 12480.obs;
  final RxDouble growthPercentage = 28.4.obs;
  final RxString growthPeriod = 'Since Mar 2025'.obs;

  final RxInt mobileUsers = 3780.obs;
  final RxInt webUsers = 2520.obs;

  final RxInt activeUsers = 11350.obs;
  final RxInt suspendedUsers = 1190.obs;

  final RxInt googleSignups = 6300.obs;
  final RxInt appleSignups = 3000.obs;
  final RxInt emailSignups = 3240.obs;

  final RxList<FlSpot> chartSpots = <FlSpot>[
    const FlSpot(0, 3),
    const FlSpot(1, 1),
    const FlSpot(2, 4),
    const FlSpot(3, 2),
    const FlSpot(4, 3),
    const FlSpot(5, 1),
    const FlSpot(6, 4),
    const FlSpot(7, 3),
    const FlSpot(8, 2),
    const FlSpot(9, 4),
    const FlSpot(10, 5),
    const FlSpot(11, 4),
  ].obs;

  final RxnInt touchedIndex = RxnInt();

  // Computed getters
  int get totalPlatformUsers => mobileUsers.value + webUsers.value;
  int get totalStatusUsers => activeUsers.value + suspendedUsers.value;
  int get totalSignupUsers =>
      googleSignups.value + appleSignups.value + emailSignups.value;

  // Updated filtering method for UsersModel
  void filterUsers(String query) {
    if (query.isEmpty) {
      orderList.assignAll(usersData);
    } else {
      final lowerQuery = query.toLowerCase();
      orderList.assignAll(usersData.where((user) {
        final fullName = '${user.firstName} ${user.lastName}';
        return fullName.toLowerCase().contains(lowerQuery) ||
            user.email.toLowerCase().contains(lowerQuery) ||
            user.id.toLowerCase().contains(lowerQuery) ||
            user.phoneNo.toLowerCase().contains(lowerQuery);
      }));
    }
    currentPage.value = 0; // Reset pagination
  }

  void updatePlatformUsers(int mobile, int web) {
    mobileUsers.value = mobile;
    webUsers.value = web;
  }

  void updateUserStatus(int active, int suspended) {
    activeUsers.value = active;
    suspendedUsers.value = suspended;
  }

  void updateSignupMethods(int google, int apple, int email) {
    googleSignups.value = google;
    appleSignups.value = apple;
    emailSignups.value = email;
  }

  void updateChartData(List<FlSpot> newSpots) {
    chartSpots.assignAll(newSpots);
  }

  void setTouchedIndex(int? index) {
    touchedIndex.value = index;
  }

  // Simulated API call for stats
  Future<void> fetchUserData() async {}
}

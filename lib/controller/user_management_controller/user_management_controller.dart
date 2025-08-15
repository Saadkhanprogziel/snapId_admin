import 'package:admin/models/chartsTablesModel.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';

class UserManagementController extends GetxController {
  var currentPage = 0.obs;

  // Master list (all users, unfiltered)
  final RxList<UserModel> allUsers = <UserModel>[
    UserModel(
      userId: '001',
      name: 'Alice Smith',
      email: 'alice@example.com',
      signupDate: DateTime(2023, 1, 10),
      subscription: 'Free',
      signupMethod: 'Email',
      platform: 'iOS',
      status: 'active',
      country: 'United States',
    ),
    UserModel(
      userId: '002',
      name: 'Bob Johnson',
      email: 'bob@example.com',
      signupDate: DateTime(2023, 2, 15),
      subscription: 'Premium',
      signupMethod: 'Google',
      platform: 'Android',
      status: 'active',
      country: 'Canada',
    ),
    UserModel(
      userId: '003',
      name: 'Charlie Davis',
      email: 'charlie@example.com',
      signupDate: DateTime(2023, 3, 20),
      subscription: 'Basic',
      signupMethod: 'Facebook',
      platform: 'Web',
      status: 'Block',
      country: 'United Kingdom',
    ),
    UserModel(
      userId: '004',
      name: 'Diana Moore',
      email: 'diana@example.com',
      signupDate: DateTime(2023, 4, 5),
      subscription: 'Free',
      signupMethod: 'Apple',
      platform: 'iOS',
      status: 'Block',
      country: 'Australia',
    ),
    UserModel(
      userId: '005',
      name: 'Ethan Hall',
      email: 'ethan@example.com',
      signupDate: DateTime(2023, 5, 12),
      subscription: 'Premium',
      signupMethod: 'Email',
      platform: 'Android',
      status: 'active',
      country: 'Germany',
    ),
    UserModel(
      userId: '006',
      name: 'Fiona Clark',
      email: 'fiona@example.com',
      signupDate: DateTime(2023, 6, 18),
      subscription: 'Basic',
      signupMethod: 'Google',
      platform: 'Web',
      status: 'Block',
      country: 'France',
    ),
    UserModel(
      userId: '007',
      name: 'George Lee',
      email: 'george@example.com',
      signupDate: DateTime(2023, 7, 22),
      subscription: 'Free',
      signupMethod: 'Facebook',
      platform: 'iOS',
      status: 'active',
      country: 'Japan',
    ),
    UserModel(
      userId: '008',
      name: 'Hannah King',
      email: 'hannah@example.com',
      signupDate: DateTime(2023, 8, 3),
      subscription: 'Premium',
      signupMethod: 'Apple',
      platform: 'Android',
      status: 'pending',
      country: 'India',
    ),
    UserModel(
      userId: '009',
      name: 'Ivan Petrov',
      email: 'ivan@example.com',
      signupDate: DateTime(2023, 9, 14),
      subscription: 'Basic',
      signupMethod: 'Email',
      platform: 'Web',
      status: 'active',
      country: 'Russia',
    ),
    UserModel(
      userId: '010',
      name: 'Julia Rossi',
      email: 'julia@example.com',
      signupDate: DateTime(2023, 10, 21),
      subscription: 'Premium',
      signupMethod: 'Google',
      platform: 'Android',
      status: 'active',
      country: 'Italy',
    ),
    UserModel(
      userId: '011',
      name: 'Kevin Wu',
      email: 'kevin@example.com',
      signupDate: DateTime(2023, 11, 8),
      subscription: 'Free',
      signupMethod: 'Facebook',
      platform: 'iOS',
      status: 'Block',
      country: 'China',
    ),
    UserModel(
      userId: '012',
      name: 'Laura Gomez',
      email: 'laura@example.com',
      signupDate: DateTime(2023, 12, 2),
      subscription: 'Premium',
      signupMethod: 'Apple',
      platform: 'Web',
      status: 'active',
      country: 'Spain',
    ),
  ].obs;

  // Filtered list (used in UI)
  final RxList<UserModel> orderList = <UserModel>[].obs;

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

  // Filtering method
  void filterUsers(String query) {
    if (query.isEmpty) {
      orderList.assignAll(allUsers);
    } else {
      final lowerQuery = query.toLowerCase();
      orderList.assignAll(allUsers.where((user) {
        return (user.name ?? '').toLowerCase().contains(lowerQuery) ||
               (user.email ?? '').toLowerCase().contains(lowerQuery) ||
               (user.userId ?? '').toLowerCase().contains(lowerQuery);
      }));
    }
    currentPage.value = 0; // Reset pagination
  }

  // Data update methods
  void updateTotalUsers(int users, double growth, String period) {
    totalUsers.value = users;
    growthPercentage.value = growth;
    growthPeriod.value = period;
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

  // Simulated API call
  Future<void> fetchUserData() async {
    await Future.delayed(const Duration(seconds: 1));
    updateTotalUsers(15230, 32.1, 'Since Apr 2025');
    updatePlatformUsers(4200, 2800);
    updateUserStatus(13500, 980);
    updateSignupMethods(7200, 3500, 3800);
  }

  @override
  void onInit() {
    super.onInit();
    orderList.assignAll(allUsers); // Initially show all users
    fetchUserData();
  }
}

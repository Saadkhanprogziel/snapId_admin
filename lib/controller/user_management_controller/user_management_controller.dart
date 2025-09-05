import 'package:admin/models/users/user_analytics_model.dart';
import 'package:admin/models/users/user_stats_model.dart';
import 'package:admin/models/users/users_model.dart';
import 'package:admin/repositories/users_repository/users_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';

import 'package:fl_chart/fl_chart.dart';

class UserManagementController extends GetxController {
  
  var selectedStatus = 'ALL'.obs;
  var selectedSort = 'Newest'.obs;
  var selectedSubscription = 'ALL'.obs;
  var selectedPlatform = 'ALL'.obs;
  var selectedDateRange = Rxn<DateTimeRange>();
  final dateRangeController = Rxn<String>();
  var searchQuery = ''.obs;
  final debouncer = Debouncer(delay: Duration(milliseconds: 300));

  
  final List<String> statusFilter = [
    'ALL',
    'ACTIVE',
    'BLOCKED',
    'DELETED',
  ];
  final List<String> sortFilter = [
    'Newest',
    'Oldest',
  ];
  final List<String> subscriptionFilter = [
    'ALL',
    'Family Pack',
    'Standard Pack',
    'Single Photo',
  ];
  final List<String> platformFilter = [
    'ALL',
    'MOBILE_APP',
    'WEB_APP',
  ];

  
  void applyFilters() {
    currentPage.value = 0;
    fetchUserStatsData();
  }

  void resetFilters() {
    selectedStatus.value = 'ALL';
    selectedSort.value = 'ALL';
    selectedSubscription.value = 'ALL';
    selectedPlatform.value = 'ALL';
    selectedDateRange.value = null;
    dateRangeController.value = null;
    currentPage.value = 0;
    fetchUserStatsData();
  }

  void goToNextPage() {
    if (pagination.value != null &&
        currentPage.value < pagination.value!.totalPages - 1) {
      currentPage.value++;
      fetchUserStatsData();
    }
  }

  void goToPreviousPage() {
    if (currentPage.value > 0) {
      currentPage.value--;
      fetchUserStatsData();
    }
  }

  var currentPage = 0.obs;
  var userStatsData = Rxn<UserStatsModel>();
  var usersData = <UsersModel>[].obs;
  var pagination = Rxn<PaginationModel>(); 
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


  void checkMethod(int index, UsersModel userModel) {
  print("checkinggggg");
  
  
  
  if (index != -1 && index < usersData.length) {
    usersData[index] = userModel; 

    print(usersData[index].isActive);

  }
  
  
  int orderIndex = orderList.indexWhere((u) => u.id == userModel.id);
  if (orderIndex != -1) {
    orderList[orderIndex] = userModel; 
  }
  
  
  usersData.refresh();
  orderList.refresh();
}

  void searchOrders(String query) {
    searchQuery.value = query;
    currentPage.value = 0; 
    debouncer.call(() {
      fetchUserStatsData();
    });
  }

  fetchUserStatsData() async {
    isLoading.value = true;
    
    String status = selectedStatus.value;
    String sortBy = selectedSort.value;
    String subscription = selectedSubscription.value;
    String platform = selectedPlatform.value;
    String startDate = '';
    String endDate = '';
    final range = selectedDateRange.value;
    if (range != null) {
      startDate = range.start.toString().split(' ')[0];
      endDate = range.end.toString().split(' ')[0];
    }
    final result = await userRepo.getAllUsers(
      page: currentPage.value + 1,
      pageSize: 10,
      status: status,
      sortBy: sortBy,
      subscription: subscription,
      platform: platform,
      startDate: startDate,
      endDate: endDate,
      searchQuery: searchQuery.value,
    );

    result.fold(
      (failure) {
        isLoading.value = false;
      },
      (response) {
        usersData.value = response.users;
        orderList
            .assignAll(response.users); 
        pagination.value = response.pagination; 
        isLoading.value = false;
      },
    );
  }

  fetchUserAnalytics() async {
    isLoading.value = true;
    final result = await userRepo.getUserAlalytics(
      page: currentPage.value + 1, 
      pageSize: 10,
      status: "ALL",
    );

    result.fold(
      (failure) {
        isLoading.value = false;
      },
      (response) {
        userAnalytics.value = response;
        isLoading.value = false;

        

        updatePlatformUsers(response.mobileUsers, response.webUsers);
        updateUserStatus(response.activeUsers, response.suspendedUsers);
        updateSignupMethods(response.googleSignups, response.appleSignups,
            response.emailSignups);
        totalUsers.value = response.totalUsers.totalCount;
      },
    );
  }

  
  final RxList<UsersModel> orderList = <UsersModel>[].obs;

  
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

  
  int get totalPlatformUsers => mobileUsers.value + webUsers.value;
  int get totalStatusUsers => activeUsers.value + suspendedUsers.value;
  int get totalSignupUsers =>
      googleSignups.value + appleSignups.value + emailSignups.value;

  
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
    currentPage.value = 0; 
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

  
  Future<void> fetchUserData() async {}
}

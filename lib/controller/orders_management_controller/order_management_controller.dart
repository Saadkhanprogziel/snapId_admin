// Updated OrderManagementController with working filters
import 'package:admin/models/orders/order_list_model.dart';
import 'package:admin/models/orders/orders_stats_data.dart';
import 'package:admin/models/orders/revenue_summary.dart';
import 'package:admin/models/orders/subscribers_analytics_data.dart';
import 'package:admin/repositories/orders_repository/orders_repository.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';

class OrderManagementController extends GetxController {
  final isLoadingStats = false.obs;
  final isLoadingOrders = false.obs;
  final isLoadingRevenue = false.obs;
  final isLoadingSubscriberAnalytics = false.obs;
  OrdersRepository ordersRepository = OrdersRepository();
  final debouncer = Debouncer(delay: Duration(milliseconds: 300));

  final ordersStatsData = Rxn<OrdersStatsData>();
  final summaryRevenue = Rxn<SummaryRevenue>();
  final subscriberAnalytics = Rxn<SubscriptionAnalyticsData>();
  final ordersData = <OrdersData>[].obs;
  var pagination = Rxn<OrderPagination>();
  var selectedDateRange = Rxn<DateTimeRange>(); // nullable Rx
  final dateRangeController = TextEditingController();
  var selectedPlatform = 'ALL'.obs;

  // Filter variables
  var selectedStatus = 'ALL'.obs;
  var selectedRevenueRange = 'last_month'.obs;
  var selectedSubscriptionRange = 'last_month'.obs;
  var selectedSort = 'ALL'.obs;
  var selectedSubscription = 'ALL'.obs;
  var searchQuery = ''.obs;

  // Filter options - these should match your API expectations
  // final List<String> statusFilter = [
  //   'ALL',
  //   'completed',
  //   'pending',
  //   'failed',
  //   'cancelled'
  // ];

  final List<String> sortFilter = [
    'ALL',
    'Newest', // Newest first
    'Oldest', // Newest first
  ];

  final List<String> subscriptionFilter = [
    'ALL',
    'Family Pack',
    'Standard Pack',
    'Single Photo'
  ];

  var currentPage = 0.obs;
  var isRightDrawerOpen = true.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeDashboard();
  }

  /// Initialize data
  void _initializeDashboard() {
    fetchOrderStatsData();
    fetchRevenueSummery();
    fetchSubscriberAnalyticsData();
    fetchOrdersStatsData();
  }

  void fetchOrderStatsData() {
    isLoadingStats.value = true;
    ordersRepository.getOrdersStatsData().then((response) {
      response.fold((error) {
        isLoadingStats.value = false;
      }, (success) {
        ordersStatsData.value = success;
        isLoadingStats.value = false;
      });
    });
  }

  void fetchRevenueSummery() {
    isLoadingRevenue.value = true;
    ordersRepository
        .getRevenueSummary(selectedRevenueRange.value)
        .then((response) {
      response.fold((error) {
        isLoadingRevenue.value = false;
      }, (success) {
        summaryRevenue.value = success;
        isLoadingRevenue.value = false;
      });
    });
  }

  void fetchSubscriberAnalyticsData() {
    isLoadingSubscriberAnalytics.value = true;
    ordersRepository
        .getSubscriberAnalyticsData(selectedSubscriptionRange.value)
        .then((response) {
      response.fold((error) {
        isLoadingSubscriberAnalytics.value = false;
      }, (success) {
        subscriberAnalytics.value = success;
        isLoadingSubscriberAnalytics.value = false;
      });
    });
  }

  // Updated fetchOrdersStatsData with filter parameters
  fetchOrdersStatsData() async {
    isLoadingOrders.value = true;

    // Prepare filter parameters
    String status =
        selectedStatus.value == 'All' ? 'ALL' : selectedStatus.value;
    String sortBy = selectedSort.value == 'All' ? '' : selectedSort.value;
    String subscription =
        selectedSubscription.value == 'All' ? '' : selectedSubscription.value;
    final range = selectedDateRange.value;
    String startDate = '';
    String endDate = '';
    if (range != null) {
      startDate = range.start.toString().split(' ')[0];
      endDate = range.end.toString().split(' ')[0];
      print('Start Date: $startDate');
      print('End Date: $endDate');
    }
    final result = await ordersRepository.getAllOrders(
      page: currentPage.value + 1,
      pageSize: 10,
      status: status,
      sortBy: sortBy,
      subscription: subscription,
      startDate: startDate,
      endDate: endDate,
      platform: selectedPlatform.value,
      searchQuery: searchQuery.value,
    );

    result.fold(
      (failure) {
        print("❌ Error: ${failure}");
        isLoadingOrders.value = false;
      },
      (response) {
        ordersData.value = response.orders;
        pagination.value = response.pagination;
        isLoadingOrders.value = false;
      },
    );
  }

  // Search functionality
  void searchOrders(String query) {
    searchQuery.value = query;
    currentPage.value = 0; // Reset to first page
    debouncer.call(() {
      fetchOrdersStatsData();
    });
  }

  // Apply filters
  void applyFilters() {
    currentPage.value = 0; // Reset to first page when applying filters
    fetchOrdersStatsData();
  }

  // Reset filters
  void resetFilters() {
    selectedStatus.value = 'All';
    selectedSort.value = 'All';
    selectedSubscription.value = 'All';
    searchQuery.value = '';
    currentPage.value = 0;
    fetchOrdersStatsData();
  }

  // Navigation methods
  void goToNextPage() {
    if (pagination.value != null &&
        currentPage.value < pagination.value!.totalPages - 1) {
      currentPage.value++;
      fetchOrdersStatsData();
    }
  }

  void goToPreviousPage() {
    if (currentPage.value > 0) {
      currentPage.value--;
      fetchOrdersStatsData();
    }
  }

  void updateRevenueFilter(String filter) {
    selectedRevenueRange.value = filter;
    fetchRevenueSummery();
  }

  void updateSubscriberFilter(String filter) {
    selectedSubscriptionRange.value = filter;
    fetchSubscriberAnalyticsData();
  }

  /// ---------------- Revenue Chart ----------------
  List<BarChartGroupData> getRevenueBarGroups() {
    final summary = summaryRevenue.value;
    if (summary == null) return [];

    final Map<String, Color> productColors = {
      "Family Pack": const Color(0xFF9787FF),
      "Single Photo": const Color(0xFFC6D2FD),
      "Standard Pack": const Color(0xFFC893FD),
    };

    final barGroups = <BarChartGroupData>[];

    for (int i = 0; i < summary.revenueSummary.length; i++) {
      final revenueSummary = summary.revenueSummary[i];
      final barRods = <BarChartRodData>[];

      revenueSummary.items.forEach((key, value) {
        barRods.add(
          BarChartRodData(
            toY: value.revenue,
            color: productColors[key] ?? Colors.grey,
            width: 14,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      });

      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: barRods,
        ),
      );
    }

    return barGroups;
  }

  List<String> getRevenueLabels() {
    final summary = summaryRevenue.value;
    if (summary == null) return [];
    return summary.revenueSummary.map((e) => e.label).toList();
  }

  List<BarChartGroupData> getSubscriptionBarGroups() {
    final summaryList = subscriberAnalytics.value?.subscriptionSummary ?? [];
    final barGroups = <BarChartGroupData>[];
    for (int i = 0; i < summaryList.length; i++) {
      final summary = summaryList[i];
      final familyPack = summary.items['Family Pack']?.count ?? 0;
      final standardPack = summary.items['Standard Pack']?.count ?? 0;
      final singlePhoto = summary.items['Single Photo']?.count ?? 0;
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
                toY: familyPack.toDouble(),
                color: const Color.fromARGB(255, 151, 135, 255)),
            BarChartRodData(
                toY: standardPack.toDouble(),
                color: const Color.fromARGB(255, 200, 147, 253)),
            BarChartRodData(
                toY: singlePhoto.toDouble(),
                color: const Color.fromARGB(255, 198, 210, 253)),
          ],
        ),
      );
    }
    return barGroups;
  }

  String getLabels(int index, bool isRevenue) {
    if (isRevenue) {
      final revenueData = summaryRevenue.value?.revenueSummary;
      if (revenueData == null || index < 0 || index >= revenueData.length) {
        return '';
      }
      return revenueData[index].label;
    } else {
      final summaryList = subscriberAnalytics.value?.subscriptionSummary ?? [];
      if (index < 0 || index >= summaryList.length) {
        return '';
      }
      return summaryList[index].label;
    }
  }
}

import 'package:admin/models/chartsTablesModel.dart';
import 'package:admin/models/orders/order_list_model.dart';
import 'package:admin/models/orders/orders_stats_data.dart';
import 'package:admin/models/orders/revenue_summary.dart';
import 'package:admin/models/orders/subscribers_analytics_data.dart';
import 'package:admin/repositories/orders_repository/orders_repository.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';


class OrderManagementController extends GetxController {
  final isLoadingStats = false.obs;
  OrdersRepository ordersRepository = OrdersRepository();

  final ordersStatsData = Rxn<OrdersStatsData>();
  final summaryRevenue = Rxn<SummaryRevenue>();
  final subscriberAnalytics = Rxn<SubscriptionAnalyticsData>();
    final ordersData = <OrdersData>[].obs;
      var pagination = Rxn<OrderPagination>(); // Add pagination observable

  var selectedStatus = 'All'.obs;

  var selectedRevenueRange = 'last_month'.obs;
  var selectedSubscriptionRange = 'last_month'.obs;
  var selectedSort = 'All'.obs;
  var selectedSubscription = 'All'.obs;
  var showFilter = false.obs; // Moved showFilter to SupportController
  final List<String> status_filter = ['All', 'Open', 'Closed'];
  final List<String> sort_filter = ['All', 'Newest', 'Oldest'];
  final List<String> subscription_filter = [
    'All',
    'photo 1',
    'photo 3',
    'photo 6'
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
    ordersRepository.getRevenueSummary(selectedRevenueRange.value).then((response) {
      response.fold((error) {}, (success) {
        summaryRevenue.value = success;
      });
    });
  }
  void fetchSubscriberAnalyticsData() {
    ordersRepository.getSubscriberAnalyticsData(selectedSubscriptionRange.value).then((response) {
      response.fold((error) {}, (success) {
        subscriberAnalytics.value = success;

      });
    });
  }

fetchUserStatsData() async {
    final result = await ordersRepository.getAllOrders(
      page: currentPage.value + 1, // API pages usually start from 1
      pageSize: 10,
      status: "ALL",
    );

    result.fold(
      (failure) {
        print("❌ Error: ${failure}");
      },
      (response) {
        ordersData.value = response.orders;
      
        pagination.value = response.pagination; // Store pagination info
        // isLoading.value = false;
      },
    );
  }

  void updateRevenueFilter(String filter) {
    selectedRevenueRange.value = filter;
    fetchRevenueSummery();
  }
  void updateSubscriberFilter(String filter) {
    selectedSubscriptionRange.value = filter;
    fetchSubscriberAnalyticsData();
  }


  final RxList<OrderData> orderList = <OrderData>[
    OrderData(
      orderId: 'ORD-1001',
      userEmail: 'john.doe@example.com',
      notes: 'Please deliver ASAP',
      date: '2025-08-01',
      subscription: 'Gold',
      amount: 150.00,
      status: 'success',
    ),
    OrderData(
      orderId: 'ORD-1001',
      userEmail: 'john.doe@example.com',
      notes: 'Please deliver ASAP',
      date: '2025-08-01',
      subscription: 'Gold',
      amount: 150.00,
      status: 'failed',
    ),
    OrderData(
      orderId: 'ORD-1001',
      userEmail: 'john.doe@example.com',
      notes: 'Please deliver ASAP',
      date: '2025-08-01',
      subscription: 'Gold',
      amount: 150.00,
      status: 'success',
    ),
    OrderData(
      orderId: 'ORD-1001',
      userEmail: 'john.doe@example.com',
      notes: 'Please deliver ASAP',
      date: '2025-08-01',
      subscription: 'Gold',
      amount: 150.00,
      status: 'success',
    ),
    OrderData(
      orderId: 'ORD-1001',
      userEmail: 'john.doe@example.com',
      notes: 'Please deliver ASAP',
      date: '2025-08-01',
      subscription: 'Gold',
      amount: 150.00,
      status: 'failed',
    ),
    OrderData(
      orderId: 'ORD-1001',
      userEmail: 'john.doe@example.com',
      notes: 'Please deliver ASAP',
      date: '2025-08-01',
      subscription: 'Gold',
      amount: 150.00,
      status: 'success',
    ),
    OrderData(
      orderId: 'ORD-1001',
      userEmail: 'john.doe@example.com',
      notes: 'Please deliver ASAP',
      date: '2025-08-01',
      subscription: 'Gold',
      amount: 150.00,
      status: 'success',
    ),
    OrderData(
      orderId: 'ORD-1001',
      userEmail: 'john.doe@example.com',
      notes: 'Please deliver ASAP',
      date: '2025-08-01',
      subscription: 'Gold',
      amount: 150.00,
      status: 'success',
    ),
    OrderData(
      orderId: 'ORD-1001',
      userEmail: 'john.doe@example.com',
      notes: 'Please deliver ASAP',
      date: '2025-08-01',
      subscription: 'Gold',
      amount: 150.00,
      status: 'success',
    ),
    OrderData(
      orderId: 'ORD-1002',
      userEmail: 'jane.smith@example.com',
      notes: 'Gift item, handle with care',
      date: '2025-08-02',
      subscription: 'Silver',
      amount: 89.99,
      status: 'success',
    ),
    OrderData(
      orderId: 'ORD-1003',
      userEmail: 'mark.brown@example.com',
      notes: 'Leave at doorstep',
      date: '2025-08-03',
      subscription: 'Platinum',
      amount: 299.49,
      status: 'Failed',
    ),
  ].obs;

  /// Load dummy data for testing

 



  /// ---------------- Revenue Chart ----------------
  List<BarChartGroupData> getRevenueBarGroups() {
  final summary = summaryRevenue.value;
  if (summary == null) return [];

  // Fixed color mapping per product
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
          color: productColors[key] ?? Colors.grey, // fallback if unknown
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

  // Subscription bar groups using SubscriptionAnalyticsData model
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
            BarChartRodData(toY: familyPack.toDouble(), color: const Color.fromARGB(255, 151, 135, 255)),
            BarChartRodData(toY: standardPack.toDouble(), color: const Color.fromARGB(255, 200, 147, 253)),
            BarChartRodData(toY: singlePhoto.toDouble(), color: const Color.fromARGB(255, 198, 210, 253)),
          ],
        ),
      );
    }
    return barGroups;
  }

  // Safe label getter using new model
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

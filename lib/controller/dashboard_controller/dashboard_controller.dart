import 'package:admin/models/dashboard/dashboard_revenue_chart_model.dart';
import 'package:admin/models/dashboard/dashboard_stats_model.dart';
import 'package:admin/models/dashboard/dashboard_orders_chart_Model.dart';
import 'package:admin/models/dashboard/dashboard_subscribers_chart_Model.dart';
import 'package:admin/repositories/dashboard_repository/dashboard_repository.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  // Dependencies
  final DashboardRepository _dashboardRepository = DashboardRepository();

  // Loading states
  final isLoading = false.obs;
  final isTotalRequestLoading = false.obs;
  final isRevenueChartLoading = false.obs;
  final isSubscriberChartLoading = false.obs;

  // Data observables
  final dashboardStatsData = Rxn<DashboardStatsModel>();
  final totalOrdersChartResponse = Rxn<TotalOrdersChartModel>();
  final totalOrdersChart = <TotalOrders>[].obs;
  final revenueChartData = Rxn<RevenueChartModel>();
  final subscriberChartData = Rxn<SubscriptionChartData>();

  // Filter observables
  final selectedRevenueFilter = 'last_month'.obs;
  final selectedRequestFilter = 'last_month'.obs;
  final selectedSubscriberFilter = 'last_month'.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeDashboard();
  }

  /// Initialize dashboard data
  void _initializeDashboard() {
    fetchDashboardStats();
    fetchRequestsChartData();
    fetchRevenueChartData();
    fetchSubscriberChartData();
  }

  /// Fetch main dashboard statistics
  Future<void> fetchDashboardStats() async {

    isLoading.value = true;
    try {
      final response = await _dashboardRepository.getDashboardStats();
      response.fold(
        (error) {
          isLoading.value = false;
        },
        (success) {

          dashboardStatsData.value = success;
          isLoading.value = false;
        },
      );
    } catch (e) {
      isLoading.value = false;
    }
  }

  /// Fetch total orders chart data
  Future<void> fetchRequestsChartData() async {
    isTotalRequestLoading.value = true;
    try {
      final response =
          await _dashboardRepository.getRequestChartData(selectedRequestFilter);
      response.fold(
        (error) => isTotalRequestLoading.value = false,
        (success) {
         
          totalOrdersChartResponse.value = success;
          totalOrdersChart.value = success.data;
          isTotalRequestLoading.value = false;
        },
      );
    } catch (e) {
      isTotalRequestLoading.value = false;
      // TODO: Handle error properly
    }
  }

  /// Fetch revenue chart data
  Future<void> fetchRevenueChartData() async {
    isRevenueChartLoading.value = true;
    try {
      final response =
          await _dashboardRepository.getRevenueChartData(selectedRevenueFilter);
      print("yssss ");

      response.fold(
        (error) => isRevenueChartLoading.value = false,
        (success) {
          revenueChartData.value = success;
          isRevenueChartLoading.value = false;
        },
      );
    } catch (e) {
      isRevenueChartLoading.value = false;
      // TODO: Handle error properly
    }
  }

  /// Fetch Subscriber Chart data
  Future<void> fetchSubscriberChartData() async {
    isSubscriberChartLoading.value = true;
    try {
      final response = await _dashboardRepository
          .getSubscriberData(selectedSubscriberFilter);
      response.fold(
        (error) => isSubscriberChartLoading.value = false,
        (success) {
          subscriberChartData.value = success;
          isSubscriberChartLoading.value = false;
        },
      );
    } catch (e) {
      isSubscriberChartLoading.value = false;
      // TODO: Handle error properly
    }
  }

  /// Update revenue filter and reload data
  void updateRevenueFilter(String filter) {
    selectedRevenueFilter.value = filter;
    fetchRevenueChartData();
  }

  /// Update request filter and reload data
  void updateRequestFilter(String filter) {
    selectedRequestFilter.value = filter;
    fetchRequestsChartData();
  }

  /// Update subscriber filter and reload data
  void updateSubscriberFilter(String filter) {
    selectedSubscriberFilter.value = filter;
    fetchSubscriberChartData();
    // loadSubscriberDataFor(filter);
  }
}

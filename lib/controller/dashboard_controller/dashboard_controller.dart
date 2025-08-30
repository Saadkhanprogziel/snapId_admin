import 'package:admin/models/dashboard/dashboard_stats_model.dart';
import 'package:admin/models/plateform_request_data.dart';
import 'package:admin/models/revanue_data.dart';
import 'package:admin/models/subscriber_data.dart';
import 'package:admin/repositories/dashboard_repository/dashboard_repository.dart';

import 'package:get/get.dart';

class DashboardController extends GetxController {
  var isWeeklyView = true.obs;
  var isLoading = true.obs;
  DashboardRepository dashboardRepository = DashboardRepository();

  var dashboardStatsData = Rxn<DashboardStatsModel>();

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
    loadRevanueDataFor(selectedRevanueFilter.value); // initial load
    loadSubscriberDataFor(selectedSubscriberFilter.value); // initial load
    // fetchDashboardData();
  }

  void fetchDashboardData() {
    isLoading.value = true;
    try {
      dashboardRepository.getDashboardStats().then((response) {
        response.fold((error) {
          isLoading.value = false;
        }, (success) {
          print("ye len janab apki data ${success.orders.totalOrders}");
          dashboardStatsData.value = success;
          isLoading.value = false;
        });
      });
    } on Exception catch (e) {
      // TODO
      isLoading.value = false;
    }
  }

  final Map<String, List<PlatformRequestData>> sampleData = {
    'weekly': [
      PlatformRequestData('Mon', 45000, 32000),
      PlatformRequestData('Tue', 37000, 29000),
      PlatformRequestData('Wed', 62000, 41000),
      PlatformRequestData('Thu', 84000, 50000),
      PlatformRequestData('Fri', 128000, 80000),
      PlatformRequestData('Sat', 79000, 56000),
      PlatformRequestData('Sun', 60000, 47000),
    ],
    'monthly': [
      PlatformRequestData('Week 1', 280000, 195000),
      PlatformRequestData('Week 2', 355000, 262000),
      PlatformRequestData('Week 3', 442000, 319000),
      PlatformRequestData('Week 4', 226000, 183000),
    ],
  };

  var selectedRevanueFilter = 'month'.obs;
  final revanueData = <RevanueData>[].obs;

  void updateFilter(String filter) {
    selectedRevanueFilter.value = filter;
    loadRevanueDataFor(filter);
  }

  void loadRevanueDataFor(String filter) {
    List<RevanueData> data;

    switch (filter) {
      case 'day':
        data = [
          RevanueData(label: '12AM', amount: 250),
          RevanueData(label: '6AM', amount: 450),
          RevanueData(label: '12PM', amount: 900),
          RevanueData(label: '6PM', amount: 350),
        ];
        break;
      case 'week':
        data = [
          RevanueData(label: 'Mon', amount: 4600),
          RevanueData(label: 'Tue', amount: 6300),
          RevanueData(label: 'Wed', amount: 4100),
          RevanueData(label: 'Thu', amount: 5400),
          RevanueData(label: 'Fri', amount: 7800),
          RevanueData(label: 'Sat', amount: 6900),
          RevanueData(label: 'Sun', amount: 5000),
        ];
        break;
      case '3month':
        data = [
          RevanueData(label: 'Apr', amount: 1900),
          RevanueData(label: 'May', amount: 2300),
          RevanueData(label: 'Jun', amount: 2150),
        ];
        break;
      case 'six month':
        data = [
          RevanueData(label: 'Jan', amount: 1100),
          RevanueData(label: 'Feb', amount: 1600),
          RevanueData(label: 'Mar', amount: 1300),
          RevanueData(label: 'Apr', amount: 1900),
          RevanueData(label: 'May', amount: 2300),
          RevanueData(label: 'Jun', amount: 2150),
        ];
        break;
      case 'year':
        data = [
          RevanueData(label: 'Jan', amount: 1100),
          RevanueData(label: 'Feb', amount: 1600),
          RevanueData(label: 'Mar', amount: 1300),
          RevanueData(label: 'Apr', amount: 1900),
          RevanueData(label: 'May', amount: 2300),
          RevanueData(label: 'Jun', amount: 2150),
          RevanueData(label: 'Jul', amount: 2550),
          RevanueData(label: 'Aug', amount: 2450),
          RevanueData(label: 'Sep', amount: 2050),
          RevanueData(label: 'Oct', amount: 2750),
          RevanueData(label: 'Nov', amount: 2950),
          RevanueData(label: 'Dec', amount: 3200),
        ];
        break;
      case 'month':
      default:
        data = [
          RevanueData(label: 'Week 1', amount: 550),
          RevanueData(label: 'Week 2', amount: 1550),
          RevanueData(label: 'Week 3', amount: 1350),
          RevanueData(label: 'Week 4', amount: 2050),
        ];
        break;
    }

    revanueData.value = data;
  }

  var selectedSubscriberFilter = 'month'.obs;
  final subscriberData = <SubscriberData>[].obs;

  void updateSubscriberFilter(String filter) {
    selectedSubscriberFilter.value = filter;
    loadSubscriberDataFor(filter);
  }

  void loadSubscriberDataFor(String filter) {
    List<SubscriberData> data;

    switch (filter) {
      case 'day':
        data = [
          SubscriberData(
              label: '12AM', package1: 100, package2: 50, package3: 30),
          SubscriberData(
              label: '6AM', package1: 200, package2: 100, package3: 75),
          SubscriberData(
              label: '12PM', package1: 350, package2: 300, package3: 150),
          SubscriberData(
              label: '6PM', package1: 120, package2: 100, package3: 80),
        ];
        break;
      case 'week':
        data = [
          SubscriberData(
              label: 'Mon', package1: 1500, package2: 1800, package3: 1200),
          SubscriberData(
              label: 'Tue', package1: 1700, package2: 1900, package3: 1400),
          SubscriberData(
              label: 'Wed', package1: 1600, package2: 1500, package3: 900),
          SubscriberData(
              label: 'Thu', package1: 1800, package2: 1700, package3: 1000),
          SubscriberData(
              label: 'Fri', package1: 2200, package2: 1900, package3: 1100),
          SubscriberData(
              label: 'Sat', package1: 2100, package2: 1800, package3: 900),
          SubscriberData(
              label: 'Sun', package1: 1900, package2: 1700, package3: 1300),
        ];
        break;
      case '3month':
        data = [
          SubscriberData(
              label: 'Apr', package1: 700, package2: 600, package3: 500),
          SubscriberData(
              label: 'May', package1: 900, package2: 800, package3: 600),
          SubscriberData(
              label: 'Jun', package1: 850, package2: 700, package3: 650),
        ];
        break;
      case 'six month':
        data = [
          SubscriberData(
              label: 'Jan', package1: 400, package2: 300, package3: 200),
          SubscriberData(
              label: 'Feb', package1: 600, package2: 500, package3: 400),
          SubscriberData(
              label: 'Mar', package1: 550, package2: 450, package3: 350),
          SubscriberData(
              label: 'Apr', package1: 700, package2: 600, package3: 500),
          SubscriberData(
              label: 'May', package1: 900, package2: 800, package3: 600),
          SubscriberData(
              label: 'Jun', package1: 850, package2: 700, package3: 650),
        ];
        break;
      case 'year':
        data = [
          SubscriberData(
              label: 'Jan', package1: 400, package2: 300, package3: 200),
          SubscriberData(
              label: 'Feb', package1: 600, package2: 500, package3: 400),
          SubscriberData(
              label: 'Mar', package1: 550, package2: 450, package3: 350),
          SubscriberData(
              label: 'Apr', package1: 700, package2: 600, package3: 500),
          SubscriberData(
              label: 'May', package1: 900, package2: 800, package3: 600),
          SubscriberData(
              label: 'Jun', package1: 850, package2: 700, package3: 650),
          SubscriberData(
              label: 'Jul', package1: 950, package2: 850, package3: 700),
          SubscriberData(
              label: 'Aug', package1: 1000, package2: 900, package3: 800),
          SubscriberData(
              label: 'Sep', package1: 1100, package2: 950, package3: 850),
          SubscriberData(
              label: 'Oct', package1: 1150, package2: 1000, package3: 900),
          SubscriberData(
              label: 'Nov', package1: 1200, package2: 1050, package3: 950),
          SubscriberData(
              label: 'Dec', package1: 1250, package2: 1100, package3: 1000),
        ];
        break;
      case 'month':
      default:
        data = [
          SubscriberData(
              label: 'Week 1', package1: 300, package2: 250, package3: 200),
          SubscriberData(
              label: 'Week 2', package1: 400, package2: 350, package3: 300),
          SubscriberData(
              label: 'Week 3', package1: 350, package2: 300, package3: 250),
          SubscriberData(
              label: 'Week 4', package1: 500, package2: 450, package3: 400),
        ];
        break;
    }

    subscriberData.value = data;
  }

  List<PlatformRequestData> get currentData =>
      isWeeklyView.value ? sampleData['weekly']! : sampleData['monthly']!;
}

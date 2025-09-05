import 'package:admin/models/chartsTablesModel.dart';
import 'package:admin/repositories/support_repository/support_repository.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SupportController extends GetxController {
  SupportRepository supportRepository = SupportRepository();
  var selectedStatus = 'All'.obs;
  var selectedSort = 'All'.obs;
  var selectedSubscription = 'All'.obs;
  final List<String> status_filter = ['All','Open', 'Closed'];
  final List<String> sort_filter = ['All','Newest', 'Oldest'];
  final List<String> subscription_filter = ['All','photo 1', 'photo 3', 'photo 6'];

  var selectedQueriesPeriod = 'This Week'.obs;
  var selectedStatusPeriod = 'This Week'.obs;
  final List<String> periods = ['This Week', 'This Month', 'This Year'];

  var currentPage = 0.obs;

  final RxList<SupportDataModel> ticketList = <SupportDataModel>[
    SupportDataModel(
        userId: "#00102",
        name: "John Smith",
        subject: "Can't download it",
        date: "Aug 9,2025",
        status: "Pending",
        emailAddress: "John@gmail.com",
        subscription: "Free"),
    SupportDataModel(
        userId: "#00103",
        name: "Jane Doe",
        subject: "Login issue",
        date: "Aug 8,2025",
        status: "Open",
        emailAddress: "Jane@gmail.com",
        subscription: "Premium"),
    SupportDataModel(
        userId: "#00104",
        name: "Bob Johnson",
        subject: "Payment failed",
        date: "Aug 7,2025",
        status: "Closed",
        emailAddress: "Bob@gmail.com",
        subscription: "Enterprise"),
    SupportDataModel(
        userId: "#00105",
        name: "Alice Brown",
        subject: "App crash",
        date: "Aug 6,2025",
        status: "Open",
        emailAddress: "Alice@gmail.com",
        subscription: "Free"),
    SupportDataModel(
        userId: "#00106",
        name: "Tom Wilson",
        subject: "Feature request",
        date: "Aug 5,2025",
        status: "Pending",
        emailAddress: "Tom@gmail.com",
        subscription: "Premium"),
  ].obs;

  final List<SupportDataModel> _originalTicketList = [];

  @override
  void onInit() {
    super.onInit();
    _originalTicketList.addAll(ticketList);
  }

  void applyFilters() {
    var filteredList = _originalTicketList.toList();

    if (selectedStatus.value.isNotEmpty) {
      filteredList = filteredList
          .where((ticket) =>
              ticket.status.toLowerCase() == selectedStatus.value.toLowerCase())
          .toList();
    }

    if (selectedSubscription.value.isNotEmpty) {
      filteredList = filteredList
          .where((ticket) => ticket.subscription.toLowerCase() ==
              selectedSubscription.value.toLowerCase())
          .toList();
    }

    if (selectedSort.value.isNotEmpty) {
      switch (selectedSort.value) {
        case 'Newest':
          filteredList.sort((a, b) => DateTime.parse(b.date).compareTo(DateTime.parse(a.date)));
          break;
        case 'Oldest':
          filteredList.sort((a, b) => DateTime.parse(a.date).compareTo(DateTime.parse(b.date)));
          break;
        case 'Status':
          filteredList.sort((a, b) => a.status.compareTo(b.status));
          break;
      }
    }

    ticketList.value = filteredList;
  }

  // void fetchAllTickets(){
  //   supportRepository.getAllTickets(page: currentPage.value, pageSize: 10, status: selectedStatus.value, startDate: startDate, endDate: endDate, sortBy: sortBy, platform: platform, searchQuery: searchQuery).then(onValue)
  // }

  void resetFilters() {
    selectedStatus.value = '';
    selectedSort.value = '';
    selectedSubscription.value = '';
    ticketList.value = _originalTicketList.toList();
  }

  var totalQueries = 182.obs;
  var queriesChartTitle = 'Total Queries'.obs;

  var aiAssistantData = <FlSpot>[
    const FlSpot(0, 80),
    const FlSpot(1, 90),
    const FlSpot(2, 40),
    const FlSpot(3, 150),
    const FlSpot(4, 120),
    const FlSpot(5, 50),
  ].obs;

  var manualSupportData = <FlSpot>[
    const FlSpot(0, 50),
    const FlSpot(1, 70),
    const FlSpot(2, 30),
    const FlSpot(3, 60),
    const FlSpot(4, 45),
    const FlSpot(5, 20),
  ].obs;

  var statusChartTitle = 'Support by Status'.obs;
  var openCount = 43.obs;
  var pendingCount = 45.obs;
  var closedCount = 112.obs;

  var chartColors = {
    'aiAssistant': const Color(0xFF8B7CF6),
    'manualSupport': const Color(0xFFD8B4FE),
  };

  var legendLabels = {
    'aiAssistant': 'AI Assistant Used',
    'manualSupport': 'Manual Support',
  };

  var statusColors = {
    'open': const Color(0xFF4ADE80),
    'pending': const Color(0xFFFBBF24),
    'closed': const Color(0xFF9CA3AF),
  };

  var statusLabels = {
    'open': 'Open',
    'pending': 'Pending',
    'closed': 'Closed',
  };

  var monthLabels = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];

  int get computedTotal => openCount.value + pendingCount.value + closedCount.value;

  void changeQueriesPeriod(String period) {
    selectedQueriesPeriod.value = period;
    _updateQueriesDataForPeriod(period);
  }

  void changeStatusPeriod(String period) {
    selectedStatusPeriod.value = period;
    _updateStatusDataForPeriod(period);
  }

  void _updateQueriesDataForPeriod(String period) {
    switch (period) {
      case 'This Week':
        aiAssistantData.value = [
          const FlSpot(0, 80),
          const FlSpot(1, 90),
          const FlSpot(2, 40),
          const FlSpot(3, 150),
          const FlSpot(4, 120),
          const FlSpot(5, 50),
        ];
        manualSupportData.value = [
          const FlSpot(0, 50),
          const FlSpot(1, 70),
          const FlSpot(2, 30),
          const FlSpot(3, 60),
          const FlSpot(4, 45),
          const FlSpot(5, 20),
        ];
        totalQueries.value = 182;
        break;
      case 'This Month':
        aiAssistantData.value = [
          const FlSpot(0, 120),
          const FlSpot(1, 110),
          const FlSpot(2, 80),
          const FlSpot(3, 180),
          const FlSpot(4, 160),
          const FlSpot(5, 90),
        ];
        manualSupportData.value = [
          const FlSpot(0, 70),
          const FlSpot(1, 90),
          const FlSpot(2, 50),
          const FlSpot(3, 80),
          const FlSpot(4, 65),
          const FlSpot(5, 40),
        ];
        totalQueries.value = 395;
        break;
      case 'This Year':
        aiAssistantData.value = [
          const FlSpot(0, 200),
          const FlSpot(1, 180),
          const FlSpot(2, 160),
          const FlSpot(3, 220),
          const FlSpot(4, 190),
          const FlSpot(5, 170),
        ];
        manualSupportData.value = [
          const FlSpot(0, 100),
          const FlSpot(1, 120),
          const FlSpot(2, 90),
          const FlSpot(3, 110),
          const FlSpot(4, 95),
          const FlSpot(5, 80),
        ];
        totalQueries.value = 795;
        break;
    }
  }

  void _updateStatusDataForPeriod(String period) {
    switch (period) {
      case 'This Week':
        openCount.value = 43;
        pendingCount.value = 45;
        closedCount.value = 112;
        break;
      case 'This Month':
        openCount.value = 78;
        pendingCount.value = 92;
        closedCount.value = 245;
        break;
      case 'This Year':
        openCount.value = 156;
        pendingCount.value = 189;
        closedCount.value = 467;
        break;
    }
  }

  List<PieChartSectionData> getPieChartSections() {
    const fontSize = 12.0;
    const radius = 35.0;

    return [
      PieChartSectionData(
        color: statusColors['open']!,
        value: openCount.value.toDouble(),
        title: '',
        radius: radius,
        titleStyle: const TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: statusColors['pending']!,
        value: pendingCount.value.toDouble(),
        title: '',
        radius: radius,
        titleStyle: const TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: statusColors['closed']!,
        value: closedCount.value.toDouble(),
        title: '',
        radius: radius,
        titleStyle: const TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ];
  }

  Future<void> fetchQueriesData(String period) async {
    try {
      print('Fetching queries data for period: $period');
      _updateQueriesDataForPeriod(period);
    } catch (e) {
      print('Error fetching queries data: $e');
    }
  }

  Future<void> fetchStatusData(String period) async {
    try {
      print('Fetching status data for period: $period');
      _updateStatusDataForPeriod(period);
    } catch (e) {
      print('Error fetching status data: $e');
    }
  }

  Future<void> refreshQueriesData() async {
    await fetchQueriesData(selectedQueriesPeriod.value);
  }

  Future<void> refreshStatusData() async {
    await fetchStatusData(selectedStatusPeriod.value);
  }

  void refreshAllData() {
    refreshQueriesData();
    refreshStatusData();
  }
}
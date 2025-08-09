
// Controller
import 'package:admin/models/chartsTablesModel.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SupportController extends GetxController {
  // Separate period selections for each chart
  
  
  var selectedQueriesPeriod = 'This Week'.obs;
  var selectedStatusPeriod = 'This Week'.obs;
  final List<String> periods = ['This Week', 'This Month', 'This Year'];

var currentPage = 0.obs;

  final RxList<SupportDataModel> ticketList = <SupportDataModel>[
    SupportDataModel(userId: "#00102", name: "John Smith", subject: "Can't download it", date: "Aug 9,2025", status: "Panding", emailAddress: "John@gmail.com"),
    SupportDataModel(userId: "#00102", name: "John Smith", subject: "Can't download it", date: "Aug 9,2025", status: "open", emailAddress: "John@gmail.com"),
    SupportDataModel(userId: "#00102", name: "John Smith", subject: "Can't download it", date: "Aug 9,2025", status: "closed", emailAddress: "John@gmail.com"),
    SupportDataModel(userId: "#00102", name: "John Smith", subject: "Can't download it", date: "Aug 9,2025", status: "open", emailAddress: "John@gmail.com"),
    SupportDataModel(userId: "#00102", name: "John Smith", subject: "Can't download it", date: "Aug 9,2025", status: "Panding", emailAddress: "John@gmail.com"),
    SupportDataModel(userId: "#00102", name: "John Smith", subject: "Can't download it", date: "Aug 9,2025", status: "Panding", emailAddress: "John@gmail.com"),
    SupportDataModel(userId: "#00102", name: "John Smith", subject: "Can't download it", date: "Aug 9,2025", status: "close", emailAddress: "John@gmail.com"),
    SupportDataModel(userId: "#00102", name: "John Smith", subject: "Can't download it", date: "Aug 9,2025", status: "Panding", emailAddress: "John@gmail.com"),
    SupportDataModel(userId: "#00102", name: "John Smith", subject: "Can't download it", date: "Aug 9,2025", status: "Panding", emailAddress: "John@gmail.com"),
    SupportDataModel(userId: "#00102", name: "John Smith", subject: "Can't download it", date: "Aug 9,2025", status: "Panding", emailAddress: "John@gmail.com"),
    SupportDataModel(userId: "#00102", name: "John Smith", subject: "Can't download it", date: "Aug 9,2025", status: "Panding", emailAddress: "John@gmail.com"),
    SupportDataModel(userId: "#00102", name: "John Smith", subject: "Can't download it", date: "Aug 9,2025", status: "Panding", emailAddress: "John@gmail.com"),
    SupportDataModel(userId: "#00102", name: "John Smith", subject: "Can't download it", date: "Aug 9,2025", status: "Panding", emailAddress: "John@gmail.com"),
  ].obs;


  // Queries Line Chart Data
  var totalQueries = 182.obs;
  var queriesChartTitle = 'Total Queries'.obs;

  // Line chart data
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

  // Support Status Pie Chart Data
  var statusChartTitle = 'Support by Status'.obs;
  var openCount = 43.obs;
  var pendingCount = 45.obs;
  var closedCount = 112.obs;

  // Chart configuration
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

  // Computed properties
  int get computedTotal => openCount.value + pendingCount.value + closedCount.value;

  // Separate methods for changing periods
  void changeQueriesPeriod(String period) {
    selectedQueriesPeriod.value = period;
    _updateQueriesDataForPeriod(period);
  }

  void changeStatusPeriod(String period) {
    selectedStatusPeriod.value = period;
    _updateStatusDataForPeriod(period);
  }

  // Separate data update methods for each chart
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

  // Separate API methods for each chart
  Future<void> fetchQueriesData(String period) async {
    try {
      // TODO: Implement API call to fetch queries data based on period
      // Example API call:
      // final response = await ApiService.getQueriesData(period: period);
      // 
      // Update the data based on API response:
      // aiAssistantData.value = response.aiAssistantData;
      // manualSupportData.value = response.manualSupportData;
      // totalQueries.value = response.totalQueries;
      
      print('Fetching queries data for period: $period');
      
      // For now, update with existing logic
      _updateQueriesDataForPeriod(period);
    } catch (e) {
      print('Error fetching queries data: $e');
      // Handle error - maybe show snackbar or keep existing data
    }
  }

  Future<void> fetchStatusData(String period) async {
    try {
      // TODO: Implement API call to fetch status data based on period
      // Example API call:
      // final response = await ApiService.getStatusData(period: period);
      // 
      // Update the data based on API response:
      // openCount.value = response.openCount;
      // pendingCount.value = response.pendingCount;
      // closedCount.value = response.closedCount;
      
      print('Fetching status data for period: $period');
      
      // For now, update with existing logic
      _updateStatusDataForPeriod(period);
    } catch (e) {
      print('Error fetching status data: $e');
      // Handle error - maybe show snackbar or keep existing data
    }
  }

  // Method to refresh queries chart data
  Future<void> refreshQueriesData() async {
    await fetchQueriesData(selectedQueriesPeriod.value);
  }

  // Method to refresh status chart data
  Future<void> refreshStatusData() async {
    await fetchStatusData(selectedStatusPeriod.value);
  }

  // Method to refresh both charts
  void refreshAllData() {
    refreshQueriesData();
    refreshStatusData();
  }
}

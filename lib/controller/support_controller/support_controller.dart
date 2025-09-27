import 'package:admin/main.dart';
import 'package:admin/models/support_model/support_status.dart';
import 'package:admin/models/support_model/ticket_graph.dart';
import 'package:admin/models/support_model/tickets_model.dart';
import 'package:admin/repositories/support_repository/support_repository.dart';
import 'package:admin/services/socket_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SupportController extends GetxController {
  SupportRepository supportRepository = SupportRepository();

  var selectedStatus = 'ALL'.obs;
  var selectedSort = 'ALL'.obs;
  var selectedQur = 'ALL'.obs;
  var selectedSubscription = 'All'.obs;

  final List<String> status_filter = ['ALL', 'OPEN', 'PENDING', 'CLOSED'];
  final List<String> sort_filter = ['ALL', 'Newest', 'Oldest'];

  var totalQueries = 0.obs;
  var queriesGraphData = Rxn<TicketGraph>();
  var supportStatusesData = Rxn<SupportStatuses>();
  var ticketListData = Rxn<TicketsData>();

  var searchQuery = ''.obs;

  // 🔹 Separate loaders
  var isTicketsLoading = false.obs;
  var isGraphLoading = false.obs;
  var isStatusLoading = false.obs;

  var selectedQueriesPeriod = 'this_year'.obs;
  var selectedStatusPeriod = 'this_year'.obs;

  var chatStatus = 'Open'.obs;
  final List<String> statuses = ['Open', 'Pending', 'Closed'];

  void updateTicketStatus(String value) {
    chatStatus.value = value;
  }

  var queriesChartTitle = 'Total Queries'.obs;
  var manualSupportData = <FlSpot>[].obs;
  var statusChartTitle = 'Support by Status'.obs;

  var statusLabels = {
    'open': 'Open',
    'pending': 'Pending',
    'closed': 'Closed',
  };

  var monthLabels = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    appSocket = SocketService();
    appSocket.initializeSocketService();

    fetchTicketList();
    fetchSupportStatusData();
    fetchQuriesData();
  }

  void fetchTicketList({int page = 1, int pageSize = 10}) {
    isTicketsLoading.value = true;

    supportRepository
        .getAllTickets(
      page: page,
      pageSize: pageSize,
      status: selectedStatus.value,
      searchQuery: searchQuery.value,
    )
        .then((response) {
      response.fold((error) {
        print('Error fetching tickets: $error');
      }, (success) {
        ticketListData.value = success;
      });
    }).whenComplete(() {
      isTicketsLoading.value = false;
    });
  }

  void searchTickets(String query) {
    searchQuery.value = query;
    _debounce(() {
      fetchTicketList(page: 1);
    });
  }

  void _debounce(VoidCallback callback) {
    if (_debounceTimer != null) {}
    _debounceTimer =
        Future.delayed(const Duration(milliseconds: 500), callback);
  }

  Future? _debounceTimer;

  void loadPage(int page) {
    fetchTicketList(page: page);
  }

  void applyFilters() {
    fetchTicketList(page: 1);
  }

  void resetFilters() {
    selectedStatus.value = 'ALL';
    selectedSort.value = 'ALL';
    selectedSubscription.value = 'ALL';
    searchQuery.value = '';
    fetchTicketList(page: 1);
  }

  void viewTicketDetails(String ticketId) {
    print('Viewing ticket: $ticketId');
  }

  void fetchQuriesData() {
    isGraphLoading.value = true;

    supportRepository
        .getTicketGraphData(filterType: selectedQueriesPeriod.value)
        .then((response) {
      response.fold((error) {}, (success) {
        queriesGraphData.value = success;
        totalQueries.value = success.totalTickets;
        isGraphLoading.value = false;
        update();
        _updateManualSupportData(success.allTickets);
      });
    });
  }

  void fetchSupportStatusData() {
    isStatusLoading.value = true;

    supportRepository
        .getSupportStatus(filterType: selectedStatusPeriod.value)
        .then((response) {
      response.fold((error) {}, (success) {
        supportStatusesData.value = success;
      });
    }).whenComplete(() {
      isStatusLoading.value = false;
    });
  }

  void _updateManualSupportData(List<Ticket> tickets) {
    List<FlSpot> spots = [];

    for (int i = 0; i < tickets.length; i++) {
      spots.add(FlSpot(i.toDouble(), tickets[i].manualSupport.toDouble()));
    }

    manualSupportData.value = spots;
    _updateMonthLabels(tickets);
  }

  void _updateMonthLabels(List<Ticket> tickets) {
    monthLabels.clear();
    for (var ticket in tickets) {
      monthLabels.add(ticket.label);
    }
  }

  void changeStatusPeriod(String period) {
    selectedStatusPeriod.value = period;
    fetchSupportStatusData();
  }

  void changeQuriesPeriod(String period) {
    selectedQueriesPeriod.value = period;
    fetchQuriesData();
  }

  List<PieChartSectionData> getPieChartSections() {
    const fontSize = 12.0;
    const radius = 35.0;

    return [
      PieChartSectionData(
        color: statusColors['open']!,
        value: supportStatusesData.value?.openCount.toDouble(),
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
        value: supportStatusesData.value?.pendingCount.toDouble(),
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
        value: supportStatusesData.value?.closeCount.toDouble(),
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

  @override
  void onClose() {
    if (_debounceTimer != null) {}
    super.onClose();
  }

  var statusColors = {
    'open': const Color(0xFF4ADE80),
    'pending': const Color(0xFFFBBF24),
    'closed': const Color(0xFF9CA3AF),
  };
}

import 'package:admin/models/chartsTablesModel.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';

enum DataRange { weekly, monthly, }

class OrderManagementController extends GetxController {
var currentPage = 0.obs;
  var isRightDrawerOpen = true.obs;
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
  
  var selectedSubscriptionRange = Rx<DataRange>(DataRange.weekly);
  var selectedRevenueRange = Rx<DataRange>(DataRange.weekly);

  final Map<DataRange, List<Map<String, dynamic>>> revenueData = {
    DataRange.weekly: [
      {'label': 'MON', 'photo1': 2000, 'photo2': 5000, 'photo3': 1500, 'all': 8500},
      {'label': 'TUE', 'label': 'TUE', 'photo1': 1000, 'photo2': 3000, 'photo3': 2000, 'all': 6000},
      {'label': 'WED', 'photo1': 6000, 'photo2': 8000, 'photo3': 5000, 'all': 19000},
      {'label': 'THU', 'photo1': 3000, 'photo2': 4000, 'photo3': 2000, 'all': 9000},
      {'label': 'FRI', 'photo1': 1000, 'photo2': 2000, 'photo3': 1500, 'all': 4500},
      {'label': 'SAT', 'photo1': 8000, 'photo2': 10000, 'photo3': 6000, 'all': 24000},
      {'label': 'SUN', 'photo1': 5000, 'photo2': 7000, 'photo3': 3000, 'all': 15000},
    ],
    DataRange.monthly: [
      {'label': 'JAN', 'photo1': 45000, 'photo2': 65000, 'photo3': 35000, 'all': 145000},
      {'label': 'FEB', 'photo1': 52000, 'photo2': 58000, 'photo3': 42000, 'all': 152000},
      {'label': 'MAR', 'photo1': 48000, 'photo2': 72000, 'photo3': 38000, 'all': 158000},
      {'label': 'APR', 'photo1': 55000, 'photo2': 68000, 'photo3': 45000, 'all': 168000},
      {'label': 'MAY', 'photo1': 62000, 'photo2': 75000, 'photo3': 48000, 'all': 185000},
      {'label': 'JUN', 'photo1': 58000, 'photo2': 70000, 'photo3': 42000, 'all': 170000},
      {'label': 'JUL', 'photo1': 65000, 'photo2': 82000, 'photo3': 52000, 'all': 199000},
      {'label': 'AUG', 'photo1': 70000, 'photo2': 85000, 'photo3': 55000, 'all': 210000},
      {'label': 'SEP', 'photo1': 68000, 'photo2': 78000, 'photo3': 48000, 'all': 194000},
      {'label': 'OCT', 'photo1': 72000, 'photo2': 88000, 'photo3': 58000, 'all': 218000},
      {'label': 'NOV', 'photo1': 75000, 'photo2': 92000, 'photo3': 62000, 'all': 229000},
      {'label': 'DEC', 'photo1': 80000, 'photo2': 95000, 'photo3': 65000, 'all': 240000},
    ],
    
  };

  final Map<DataRange, List<Map<String, dynamic>>> subscriptionData = {
    DataRange.weekly: [
      {'label': 'MON', 'photo1': 25, 'photo2': 18, 'photo3': 12},
      {'label': 'TUE', 'photo1': 32, 'photo2': 24, 'photo3': 15},
      {'label': 'WED', 'photo1': 28, 'photo2': 22, 'photo3': 18},
      {'label': 'THU', 'photo1': 35, 'photo2': 28, 'photo3': 20},
      {'label': 'FRI', 'photo1': 42, 'photo2': 35, 'photo3': 25},
      {'label': 'SAT', 'photo1': 38, 'photo2': 30, 'photo3': 22},
      {'label': 'SUN', 'photo1': 30, 'photo2': 25, 'photo3': 18},
    ],
    DataRange.monthly: [
      {'label': 'JAN', 'photo1': 150, 'photo2': 100, 'photo3': 50},
      {'label': 'FEB', 'photo1': 200, 'photo2': 150, 'photo3': 80},
      {'label': 'MAR', 'photo1': 300, 'photo2': 250, 'photo3': 120},
      {'label': 'APR', 'photo1': 350, 'photo2': 400, 'photo3': 300},
      {'label': 'MAY', 'photo1': 400, 'photo2': 450, 'photo3': 350},
      {'label': 'JUN', 'photo1': 300, 'photo2': 350, 'photo3': 280},
      {'label': 'JUL', 'photo1': 450, 'photo2': 500, 'photo3': 380},
      {'label': 'AUG', 'photo1': 520, 'photo2': 580, 'photo3': 420},
      {'label': 'SEP', 'photo1': 480, 'photo2': 520, 'photo3': 390},
      {'label': 'OCT', 'photo1': 600, 'photo2': 650, 'photo3': 480},
      {'label': 'NOV', 'photo1': 680, 'photo2': 720, 'photo3': 550},
      {'label': 'DEC', 'photo1': 750, 'photo2': 800, 'photo3': 620},
    ],
   
  };

  


  List<Map<String, dynamic>> getCurrentRevenueData() {
    return revenueData[selectedRevenueRange.value] ?? [];
  }

  List<Map<String, dynamic>> getCurrentSubscriptionData() {
    return subscriptionData[selectedSubscriptionRange.value] ?? [];
  }

  List<BarChartGroupData> getRevenueBarGroups() {
    final currentData = getCurrentRevenueData();
    
    return List.generate(currentData.length, (index) {
      final data = currentData[index];
      
      return BarChartGroupData(
        x: index,
        barsSpace: 4,
        barRods: [
          BarChartRodData(
            toY: (data['photo1'] ?? 0).toDouble(),
            width: 12,
            color: const Color.fromARGB(255, 151, 135, 255),
            borderRadius: const BorderRadius.all(Radius.circular(2)),
          ),
          BarChartRodData(
            toY: (data['photo2'] ?? 0).toDouble(),
            width: 12,
            color: const Color.fromARGB(255, 200, 147, 253),
            borderRadius: const BorderRadius.all(Radius.circular(2)),
          ),
          BarChartRodData(
            toY: (data['photo3'] ?? 0).toDouble(),
            width: 12,
            color: const Color.fromARGB(255, 198, 210, 253),
            borderRadius: const BorderRadius.all(Radius.circular(2)),
          ),
        ],
      );
    });
  }

  // Subscription bar groups
  List<BarChartGroupData> getSubscriptionBarGroups() {
    final currentData = getCurrentSubscriptionData();
    
    return List.generate(currentData.length, (index) {
      final data = currentData[index];
      final photo1 = (data['photo1'] ?? 0).toDouble();
      final photo2 = (data['photo2'] ?? 0).toDouble();
      final photo3 = (data['photo3'] ?? 0).toDouble();
      
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: photo1 + photo2 + photo3,
            width: 22,
            color: Colors.purple.shade400,
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            rodStackItems: [
              BarChartRodStackItem(0, photo1, const Color.fromARGB(255, 151, 135, 255)),
              BarChartRodStackItem(photo1, photo1 + photo2, const Color.fromARGB(255, 200, 147, 253)),
              BarChartRodStackItem(photo1 + photo2, photo1 + photo2 + photo3, const Color.fromARGB(255, 198, 210, 253)),
            ],
          ),
        ],
      );
    });
  }




  void updateRevenueRange(DataRange range) {
    selectedRevenueRange.value = range;
  }

  void updateSubscriptionRange(DataRange range) {
    selectedSubscriptionRange.value = range;
  }

  // Safe label getter
  String getLabel(int index, DataRange range, bool isRevenue) {
    final data = isRevenue ? revenueData[range] : subscriptionData[range];
    if (data == null || index < 0 || index >= data.length) return '';
    return data[index]['label'] ?? '';
  }
}
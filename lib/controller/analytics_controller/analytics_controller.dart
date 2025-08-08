import 'package:admin/models/country_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnalyticsController extends GetxController {
  var selectedPeriod = 'Monthly'.obs;

var selectedTopTab = 0.obs; // 0 = Top Countries, 1 = Top Buyers

  var currentPage = 0.obs;


List<UserActivityModel> dummyActivities = [
    UserActivityModel(
      time: "2023-05-15 10:30 AM",
      name: "John Doe",
      email: "john.doe@example.com",
      activity: "Uploaded Photo",
      plateform: "Android", 
    ),
    UserActivityModel(
      time: "2023-05-15 11:15 AM",
      name: "Alice Smith",
      email: "alice.smith@example.com",
      activity: "Signed Up (Google)",
      plateform: "iOS",
    ),
    UserActivityModel(
      time: "2023-05-15 12:45 PM",
      name: "Bob Johnson",
      email: "bob.johnson@example.com",
      activity: "Made a payment (\$29.99)",
      plateform: "Android",
    ),
    UserActivityModel(
      time: "2023-05-16 09:20 AM",
      name: "Emma Wilson",
      email: "emma.wilson@example.com",
      activity: "Uploaded Photo",
      plateform: "iOS",
    ),
    UserActivityModel(
      time: "2023-05-16 02:10 PM",
      name: "Michael Brown",
      email: "michael.brown@example.com",
      activity: "Signed Up (Email)",
      plateform: "Android",
    ),
    UserActivityModel(
      time: "2023-05-17 03:45 PM",
      name: "Sarah Davis",
      email: "sarah.davis@example.com",
      activity: "Made a payment (\$9.99)",
      plateform: "iOS",
    ),
    UserActivityModel(
      time: "2023-05-15 12:45 PM",
      name: "Bob Johnson",
      email: "bob.johnson@example.com",
      activity: "Made a payment (\$29.99)",
      plateform: "Android",
    ),
    UserActivityModel(
      time: "2023-05-16 09:20 AM",
      name: "Emma Wilson",
      email: "emma.wilson@example.com",
      activity: "Uploaded Photo",
      plateform: "iOS",
    ),
    UserActivityModel(
      time: "2023-05-16 02:10 PM",
      name: "Michael Brown",
      email: "michael.brown@example.com",
      activity: "Signed Up (Email)",
      plateform: "Android",
    ),
    UserActivityModel(
      time: "2023-05-17 03:45 PM",
      name: "Sarah Davis",
      email: "sarah.davis@example.com",
      activity: "Made a payment (\$9.99)",
      plateform: "iOS",
    ),
    UserActivityModel(
      time: "2023-05-18 08:30 AM",
      name: "David Miller",
      email: "david.miller@example.com",
      activity: "Uploaded Photo",
      plateform: "Android",
    ),
    UserActivityModel(
      time: "2023-05-18 01:15 PM",
      name: "Olivia Taylor",
      email: "olivia.taylor@example.com",
      activity: "Signed Up (Apple)",
      plateform: "iOS",
    ),
    UserActivityModel(
      time: "2023-05-19 04:50 PM",
      name: "James Wilson",
      email: "james.wilson@example.com",
      activity: "Made a payment (\$49.99)",
      plateform: "Android",
    ),
    UserActivityModel(
      time: "2023-05-20 10:05 AM",
      name: "Sophia Martinez",
      email: "sophia.martinez@example.com",
      activity: "Uploaded Photo",
      plateform: "iOS",
    ),
  ];
  

  List<BuyerData> dummyBuyers = [
  BuyerData(
    rank: 1,
    name: 'John Joe',
    country: 'United States',
    email: 'johnjoe@example.com',
    orders: 122,
    revenue: 4350.75,
    plateform: 'Web',
  ),
  BuyerData(
    rank: 2,
    name: 'Sarah Khan',
    country: 'Pakistan',
    email: 'sarah.k@example.com',
    orders: 98,
    revenue: 3920.50,
    plateform: 'Mobile',
  ),
  BuyerData(
    rank: 3,
    name: 'Olga Petrova',
    country: 'Ukraine',
    email: 'olga.p@example.com',
    orders: 87,
    revenue: 3550.00,
    plateform: 'Desktop',
  ),
  BuyerData(
    rank: 4,
    name: 'Mohammed Ali',
    country: 'UAE',
    email: 'm.ali@example.com',
    orders: 80,
    revenue: 3400.25,
    plateform: 'Web',
  ),
  BuyerData(
    rank: 5,
    name: 'Ava Brown',
    country: 'UK',
    email: 'ava.b@example.com',
    orders: 72,
    revenue: 3200.00,
    plateform: 'Mobile',
  ),
];


  
  final Map<String, List<Map<String, dynamic>>> allData = {
    'Daily': [
      {
        'label': 'US Passport',
        'count': 123,
        'color': const Color(0xFF6366F1),
      },
      {
        'label': 'Canada Visa',
        'count': 111,
        'color': Colors.grey,
      },
      {
        'label': 'US Driving licence',
        'count': 40,
        'color': Colors.grey,
      },
      {
        'label': 'Singapore Passport',
        'count': 50,
        'color': Colors.grey,
      },
    ],
    'Weekly': [
      {
        'label': 'US Passport',
        'count': 4567,
        'color': const Color(0xFF6366F1),
      },
      {
        'label': 'Canada Visa',
        'count': 2134,
        'color': Colors.grey,
      },
    ],
    'Monthly': [
      {
        'label': 'US Passport',
        'count': 27799,
        'color': const Color(0xFF6366F1),
      },
      {
        'label': 'Canada Visa',
        'count': 15799,
        'color': Colors.grey,
      },
      {
        'label': 'US Driving licence',
        'count': 5567,
        'color': Colors.grey,
      },
      {
        'label': 'Singapore Passport',
        'count': 1789,
        'color': Colors.grey,
      },
    ],
    'Yearly': [
      {
        'label': 'US Passport',
        'count': 130000,
        'color': const Color(0xFF6366F1),
      },
      {
        'label': 'Canada Visa',
        'count': 87000,
        'color': Colors.grey,
      },
    ],
  };
}

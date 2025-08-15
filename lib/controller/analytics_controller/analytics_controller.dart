import 'package:admin/models/chartsTablesModel.dart';
import 'package:admin/models/country_data_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnalyticsController extends GetxController {
  // Pie chart period and data
  final pieChartPeriod = 'Week'.obs;
  final Map<String, List<Map<String, dynamic>>> pieChartDataByPeriod = {
    'Week': [
      {
        'label': 'Failed Requests',
        'value': 500,
        'color': const Color(0xFFFF8A95),
        'percentage': '10%',
      },
      {
        'label': 'Successful Requests',
        'value': 4500,
        'color': const Color(0xFF81C784),
        'percentage': '90%',
      },
    ],
    'Month': [
      {
        'label': 'Failed Requests',
        'value': 2050,
        'color': const Color(0xFFFF8A95),
        'percentage': '17%', // 2050/12050
      },
      {
        'label': 'Successful Requests',
        'value': 10000,
        'color': const Color(0xFF81C784),
        'percentage': '83%', // 10000/12050
      },
    ],
    'Year': [
      {
        'label': 'Failed Requests',
        'value': 12000,
        'color': const Color(0xFFFF8A95),
        'percentage': '20%', // 12000/60000
      },
      {
        'label': 'Successful Requests',
        'value': 48000,
        'color': const Color(0xFF81C784),
        'percentage': '80%', // 48000/60000
      },
    ],
  };
  var selectedPeriod = 'Monthly'.obs;

var selectedTopTab = 0.obs; // 0 = Top Countries, 1 = Top Buyers

  var currentPage = 0.obs;


  final List<CountryData> dummyCountries = [
    CountryData(
      rank: 1,
      country: "United States",
      orders: 1250,
      revenue: 125000.50,
      platformBreakdown: "iOS: 60%, Android: 35%, Web: 5%",
    ),
    CountryData(
      rank: 2,
      country: "United Kingdom",
      orders: 890,
      revenue: 89500.75,
      platformBreakdown: "iOS: 45%, Android: 40%, Web: 15%",
    ),
    CountryData(
      rank: 3,
      country: "Germany",
      orders: 750,
      revenue: 75200.00,
      platformBreakdown: "Android: 55%, iOS: 35%, Web: 10%",
    ),
    CountryData(
      rank: 4,
      country: "Canada",
      orders: 620,
      revenue: 62800.25,
      platformBreakdown: "iOS: 50%, Android: 45%, Web: 5%",
    ),
    CountryData(
      rank: 5,
      country: "Australia",
      orders: 580,
      revenue: 58900.80,
      platformBreakdown: "iOS: 65%, Android: 30%, Web: 5%",
    ),
    CountryData(
      rank: 6,
      country: "France",
      orders: 520,
      revenue: 52700.40,
      platformBreakdown: "Android: 48%, iOS: 42%, Web: 10%",
    ),
    CountryData(
      rank: 7,
      country: "Japan",
      orders: 480,
      revenue: 48300.60,
      platformBreakdown: "iOS: 70%, Android: 25%, Web: 5%",
    ),
    CountryData(
      rank: 8,
      country: "Netherlands",
      orders: 420,
      revenue: 42500.90,
      platformBreakdown: "Android: 52%, iOS: 38%, Web: 10%",
    ),
    CountryData(
      rank: 9,
      country: "Sweden",
      orders: 380,
      revenue: 38700.20,
      platformBreakdown: "iOS: 55%, Android: 35%, Web: 10%",
    ),
    CountryData(
      rank: 10,
      country: "Italy",
      orders: 350,
      revenue: 35800.15,
      platformBreakdown: "Android: 58%, iOS: 32%, Web: 10%",
    ),
    CountryData(
      rank: 11,
      country: "Spain",
      orders: 320,
      revenue: 32900.45,
      platformBreakdown: "Android: 54%, iOS: 36%, Web: 10%",
    ),
    CountryData(
      rank: 12,
      country: "Brazil",
      orders: 290,
      revenue: 29400.80,
      platformBreakdown: "Android: 75%, iOS: 20%, Web: 5%",
    ),
    CountryData(
      rank: 13,
      country: "South Korea",
      orders: 270,
      revenue: 27600.30,
      platformBreakdown: "Android: 65%, iOS: 30%, Web: 5%",
    ),
    CountryData(
      rank: 14,
      country: "Mexico",
      orders: 250,
      revenue: 25300.60,
      platformBreakdown: "Android: 68%, iOS: 27%, Web: 5%",
    ),
    CountryData(
      rank: 15,
      country: "India",
      orders: 220,
      revenue: 22800.40,
      platformBreakdown: "Android: 82%, iOS: 15%, Web: 3%",
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

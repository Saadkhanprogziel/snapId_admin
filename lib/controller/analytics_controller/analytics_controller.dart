import 'package:admin/models/analytics/processed_count.dart';
import 'package:admin/models/chartsTablesModel.dart';
import 'package:admin/models/analytics/country_data_model.dart';
import 'package:admin/models/analytics/top_documents_type.dart';
import 'package:admin/repositories/analytics_repository/analytics_repository.dart';
import 'package:get/get.dart';

class AnalyticsController extends GetxController {
  AnalyticsRepository analyticsRepository = AnalyticsRepository();

  var topDocumentTypesCount = Rxn<TopDocumentTypesResponse>();
  var processedDocumentCount= Rxn<ProcessedDocCountModel>();
  var topCountries= <CountryData>[].obs;
  final pieChartPeriod = 'last_month'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTopDocuments();
    fetchProcessedDocCount();
    fetchTopCountries();
  }


  
  var selectedDocTypePeriod = 'last_month'.obs;
  var selectedTopTab = 0.obs; // 0 = Top Countries, 1 = Top Buyers
  var currentPage = 0.obs;

  void updatePieChartFilter(String filter) {
    pieChartPeriod.value = filter;
    fetchProcessedDocCount();
  }
  void updateDocTypeFilter(String filter) {
    selectedDocTypePeriod.value = filter;
    fetchTopDocuments();
    
  }

  void fetchTopDocuments() async {
    analyticsRepository.getTopDocumentTypesCount(selectedDocTypePeriod.value).then((response) {
      response.fold((error) {
        print("error $error");
      }, (success) {
        topDocumentTypesCount.value = success;
      });
    });
  }

  void fetchProcessedDocCount() async {
    analyticsRepository.getProcessedDocumentCount(pieChartPeriod.value).then((response) {
      response.fold((error) {
        print("error $error");
      }, (success) {
        processedDocumentCount.value = success;
      });
    });
  }
  void fetchTopCountries() async {
    analyticsRepository.getTopCountries().then((response) {
      response.fold((error) {
        print("errrrrrrrrrror $error");
      }, (success) {
        print("janab");
        topCountries.value = success; 
      });
    });
  }

  
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
}
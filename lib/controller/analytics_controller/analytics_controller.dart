import 'package:admin/models/analytics/processed_count.dart';
import 'package:admin/models/analytics/top_buyer_model.dart';
import 'package:admin/models/analytics/country_data_model.dart';
import 'package:admin/models/analytics/top_documents_type.dart';
import 'package:admin/repositories/analytics_repository/analytics_repository.dart';
import 'package:get/get.dart';

class AnalyticsController extends GetxController {
  AnalyticsRepository analyticsRepository = AnalyticsRepository();

  var topDocumentTypesCount = Rxn<TopDocumentTypesResponse>();
  var processedDocumentCount = Rxn<ProcessedDocCountModel>();
  var topCountries = <CountryData>[].obs;
  var topBuyers = <TopBuyerModel>[].obs;

  /// Loading flags
  var isLoadingTopCountries = false.obs;
  var isLoadingTopBuyers = false.obs;
  var isLoadingDocTypes = false.obs;
  var isLoadingProcessedDocs = false.obs;

  final pieChartPeriod = 'all_time'.obs;
  var selectedDocTypePeriod = 'all_time'.obs;
  var selectedTopTab = 0.obs;
  var currentPage = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTopDocuments();
    fetchProcessedDocCount();
    fetchTopCountries();
    fetchTopBuyers();
  }

  

  void updatePieChartFilter(String filter) {
    pieChartPeriod.value = filter;
    fetchProcessedDocCount();
  }

  void updateDocTypeFilter(String filter) {
    selectedDocTypePeriod.value = filter;
    fetchTopDocuments();
  }

  /// Fetch Top Documents
  void fetchTopDocuments() async {
    isLoadingDocTypes.value = true;
    analyticsRepository
        .getTopDocumentTypesCount(selectedDocTypePeriod.value)
        .then((response) {
      response.fold((error) {
        isLoadingDocTypes.value = false;
      }, (success) {
        topDocumentTypesCount.value = success;
        isLoadingDocTypes.value = false;
      });
    });
  }

  /// Fetch Processed Documents
  void fetchProcessedDocCount() async {
    isLoadingProcessedDocs.value = true;
    analyticsRepository.getProcessedDocumentCount(pieChartPeriod.value).then((response) {
      response.fold((error) {
        print("error $error");
        isLoadingProcessedDocs.value = false;
      }, (success) {
        processedDocumentCount.value = success;
        isLoadingProcessedDocs.value = false;
      });
    });
  }

  /// Fetch Top Countries
  void fetchTopCountries() async {
    isLoadingTopCountries.value = true;
    analyticsRepository.getTopCountries().then((response) {
      response.fold((error) {
        isLoadingTopCountries.value = false;
      }, (success) {
        topCountries.value = success;
        isLoadingTopCountries.value = false;
      });
    });
  }

  /// Fetch Top Buyers
  void fetchTopBuyers() async {
    isLoadingTopBuyers.value = true;
    analyticsRepository.getTopBuyers().then((response) {
      response.fold((error) {
        isLoadingTopBuyers.value = false;
      }, (success) {
        topBuyers.value = success;
        isLoadingTopBuyers.value = false;
      });
    });
  }
}

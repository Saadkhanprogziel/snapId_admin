import 'package:admin/main.dart';
import 'package:admin/models/analytics/country_data_model.dart';
import 'package:admin/models/analytics/processed_count.dart';
import 'package:admin/models/analytics/top_buyer_model.dart';
import 'package:admin/models/analytics/top_documents_type.dart';
import 'package:dartz/dartz.dart';

class AnalyticsRepository {
  Future<Either<String, TopDocumentTypesResponse>> getTopDocumentTypesCount(
      period) async {
    final response = await networkRepository.get(
        url: "admin/analytics/get-top-documents?date=$period");

    if (!response.failed) {
      final topDocumentType =
          TopDocumentTypesResponse.fromJson(response.data['data']);
      return Right(topDocumentType);
    } else
      return left(response.message);
  }

  Future<Either<String, ProcessedDocCountModel>> getProcessedDocumentCount(
      period) async {
    final response = await networkRepository.get(
        url: "admin/analytics/get-processing-request?date=$period");

    if (!response.failed) {
      final topDocumentType =
          ProcessedDocCountModel.fromJson(response.data['data']);
      return Right(topDocumentType);
    } else
      return left(response.message);
  }

  Future<Either<String, List<CountryData>>> getTopCountries() async {
    final response = await networkRepository.get(
      url: "admin/analytics/get-top-countries",
    );

    if (!response.failed) {
      final List<dynamic> data = response.data['data'];
      final countries = data.map((e) => CountryData.fromJson(e)).toList();
   
      return Right(countries);
    } else {
      return Left(response.message);
    }
  }
  Future<Either<String, List<TopBuyerModel>>> getTopBuyers() async {
    final response = await networkRepository.get(
      url: "admin/analytics/get-top-buyers",
    );

    if (!response.failed) {
      final List<dynamic> data = response.data['data'];
      final buyers = data.map((e) => TopBuyerModel.fromJson(e)).toList();
   
      return Right(buyers);
    } else {
      return Left(response.message);
    }
  }
}

import 'package:admin/main.dart';
import 'package:admin/models/top_documents_type/top_documents_type.dart';
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
}

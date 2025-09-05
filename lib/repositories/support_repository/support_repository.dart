import 'package:admin/main.dart';
import 'package:admin/models/tickets_model/tickets_model.dart';
import 'package:dartz/dartz.dart';

class SupportRepository {
  
  Future<Either<String, TicketsData>> getAllTickets({
    required int page,
    required int pageSize,
    required String status,
    required String startDate,
    required String endDate,
    required String sortBy,
    required String platform,
    required String searchQuery,
  }) async {
    try {
      final extraQuery = {
        "page": page,
        "pageSize": pageSize,
        "status": status,
        "startDate": startDate,
        "endDate": endDate,
        "sortBy": sortBy,
        "platform": platform,
        "searchQuery": searchQuery
      };
      final response = await networkRepository.get(
        url: "admin/support/get-all-tickets",
        extraQuery: extraQuery,
      );

      if (!response.failed && response.data != null) {
        final ordersResponse = TicketsData.fromJson(response.data['data']);

        return Right(ordersResponse);
      } else {
        return Left(response.message);
      }
    } catch (e) {
      return Left(e.toString());
    }
  } 
}
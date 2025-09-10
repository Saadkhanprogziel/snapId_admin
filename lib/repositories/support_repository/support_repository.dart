import 'package:admin/main.dart';
import 'package:admin/models/support_model/support_status.dart';
import 'package:admin/models/support_model/ticket_graph.dart';
import 'package:admin/models/support_model/tickets_model.dart';
import 'package:dartz/dartz.dart';

class SupportRepository {
  Future<Either<String, TicketsData>> getAllTickets({
    required int page,
    required int pageSize,
    required String status,
    required String searchQuery,
  }) async {
    try {
      final extraQuery = {
        "page": page,
        "pageSize": pageSize,
        "status": status,
        "searchQuery": searchQuery,
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

  Future<Either<String, TicketGraph>> getTicketGraphData({
    required String filterType,
  }) async {
    try {
      final extraQuery = {
        "filterType": filterType,
      };
      final response = await networkRepository.get(
        url: "admin/support/get-support-tickets-graph",
        extraQuery: extraQuery,
      );

      if (!response.failed && response.data != null) {
        final ticketGraphData = TicketGraph.fromJson(response.data['data']);
        return Right(ticketGraphData);
      } else {
        return Left(response.message);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, SupportStatuses>> getSupportStatus({
    required String filterType,
  }) async {
    try {
      final extraQuery = {
        "filterType": filterType,
      };
      final response = await networkRepository.get(
        url: "admin/support/get-all-tickets-count",
        extraQuery: extraQuery,
      );

      if (!response.failed && response.data != null) {
        final supportStatus = SupportStatuses.fromJson(response.data['data']);
        return Right(supportStatus);
      } else {
        return Left(response.message);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }
}

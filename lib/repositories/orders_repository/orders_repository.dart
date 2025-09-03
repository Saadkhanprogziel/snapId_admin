import 'package:admin/main.dart';
import 'package:admin/models/orders/order_list_model.dart';
import 'package:admin/models/orders/orders_stats_data.dart';
import 'package:admin/models/orders/revenue_summary.dart';
import 'package:admin/models/orders/subscribers_analytics_data.dart';
import 'package:dartz/dartz.dart';

class OrdersRepository {
  Future<Either<String, OrdersStatsData>> getOrdersStatsData() async {
    final response =
        await networkRepository.get(url: "admin/orders/get-order-counts");

    if (!response.failed) {
      final ordersStatsData = OrdersStatsData.fromJson(response.data['data']);
      return Right(ordersStatsData);
    } else
      return left(response.message);
  }

  Future<Either<String, SummaryRevenue>> getRevenueSummary(filter) async {
    final response = await networkRepository.get(
        url: "admin/orders/get-total-revenue?filterType=$filter");
    if (!response.failed) {
      final subscriberChartData = response.data['data'];

      // ✅ Parse JSON to model
      final data = SummaryRevenue.fromJson(subscriberChartData);

      return right(data);
    } else {
      return left(response.message);
    }
  }

  Future<Either<String, SubscriptionAnalyticsData>> getSubscriberAnalyticsData(filter) async {
    final response = await networkRepository.get(
        url: "admin/orders/get-total-subscription-count?filterType=$filter");
    if (!response.failed) {
      final subscriberChartData = response.data['data'];

      // ✅ Parse JSON to model
      final data = SubscriptionAnalyticsData.fromJson(subscriberChartData);

      return right(data);
    } else {
      return left(response.message);
    }
  }

Future<Either<String, OrdersResponse>> getAllOrders({
  required int page,
  required int pageSize,
  required String status,
}) async {
  try {
    final response = await networkRepository.get(
      url: "admin/orders/get-all-orders",
      extraQuery: {
        "page": page,
        "pageSize": pageSize,
        "status": status,
      },
    );

    if (!response.failed && response.data != null) {
      // Parse JSON into OrdersResponse
      final ordersResponse = OrdersResponse.fromJson(response.data['data']);
      return Right(ordersResponse);
    } else {
      return Left(response.message ?? "Unknown error");
    }
  } catch (e) {
    return Left(e.toString());
  }
}

}

import 'package:admin/models/dashboard/dashboard_revenue_chart_model.dart';
import 'package:admin/models/dashboard/dashboard_stats_model.dart';
import 'package:admin/models/dashboard/dashboard_orders_chart_Model.dart';
import 'package:admin/models/dashboard/dashboard_subscribers_chart_Model.dart';
import 'package:admin/network/network_repository.dart';
import 'package:dartz/dartz.dart';

class DashboardRepository {
  NetworkRepository networkRepository = NetworkRepository();

  Future<Either<String, DashboardStatsModel>> getDashboardStats() async {
    final response =
        await networkRepository.get(url: "admin/dashboard/get-total-counts");

    if (!response.failed) {
      final data = DashboardStatsModel.fromJson(response.data['data']);
      return right(data);
    } else {
      return left(response.message);
    }
  }

  Future<Either<String, List<TotalOrdersChartModel>>> getRequestChartData(
      filter) async {
    final response = await networkRepository.get(
        url: "dashboard/get-total-orders?filterType=$filter");
    final List<dynamic> totalOrders = response.data['data'];
    if (!response.failed) {
      List<TotalOrdersChartModel> data = totalOrders
          .map((item) => TotalOrdersChartModel.fromJson(item))
          .toList();
      return right(data);
    } else {
      return left(response.message);
    }
  }

  Future<Either<String, SubscriptionChartData>> getSubscriberData(
      filter) async {
    final response = await networkRepository.get(
        url: "dashboard/get-plan-subscribers?filterType=$filter");
  if (!response.failed) {
    final subscriberChartData = response.data['data'];

    // ✅ Parse JSON to model
    final data = SubscriptionChartData.fromJson(subscriberChartData);

   

    return right(data);
  } else {
    return left(response.message);
  }
}

Future<Either<String, RevenueChartModel>> getRevenueChartData(filter) async {
  final response = await networkRepository.get(
    url: "dashboard/get-total-revenue?filterType=$filter",
  );

  if (!response.failed) {
    final revanueChartData = response.data['data'];

    // ✅ Parse JSON to model
    final data = RevenueChartModel.fromJson(revanueChartData);

   

    return right(data);
  } else {
    return left(response.message);
  }
}

}

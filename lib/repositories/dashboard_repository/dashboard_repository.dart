import 'package:admin/models/dashboard/dashboard_stats_model.dart';
import 'package:admin/network/network_repository.dart';
import 'package:dartz/dartz.dart';

class DashboardRepository {
  NetworkRepository networkRepository =  NetworkRepository();

  Future<Either<String,DashboardStatsModel>> getDashboardStats() async{
    final response = await networkRepository.get(url: "admin/dashboard/get-total-counts");

    if (!response.failed) {
      final data = DashboardStatsModel.fromJson(response.data['data']);
      return right(data);
    }
    else{
      return left(response.message);
    }
  }
  
}
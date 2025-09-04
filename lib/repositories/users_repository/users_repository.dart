import 'package:admin/main.dart';
import 'package:admin/models/users/user_analytics_model.dart';
import 'package:admin/models/users/users_model.dart';
import 'package:admin/network/network_response.dart';
import 'package:dartz/dartz.dart';

class Failure {
  final String message;
  Failure(this.message);
}

class UserRepository {
  Future<Either<Failure, GetAllUsersResponse>> getAllUsers({
    required int page,
    required int pageSize,
    required String status,
    required String startDate,
    required String endDate,
    required String sortBy,
    required String subscription,
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
        "searchQuery":searchQuery
      };
      final response = await networkRepository.get(
          url: "admin/users/get-all-users", extraQuery: extraQuery);

      if (!response.failed) {
        final usersResponse =
            GetAllUsersResponse.fromMap(response.data['data']);
        print("maheen ${usersResponse.users.length}");
        return Right(usersResponse);
      } else {
        return Left(Failure(response.message));
      }
    } on NetworkResponse catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, UserAnalytics>> getUserAlalytics({
    required int page,
    required int pageSize,
    required String status,
  }) async {
    try {
      final response = await networkRepository.get(
        url: "admin/users/get-user-counts?date=last_month",
        // extraQuery: {
        //   "page": page,
        //   "pageSize": pageSize,
        //   "status": status,
        // },
      );

      if (!response.failed) {
        final userAnalytics = UserAnalytics.fromJson(response.data['data']);
        return Right(userAnalytics);
      } else {
        return Left(Failure(response.message));
      }
    } on NetworkResponse catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}

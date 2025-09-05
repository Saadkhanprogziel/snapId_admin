import 'package:admin/models/users/users_moderation_history.dart';
import 'package:admin/models/users/users_order_data.dart';
import 'package:dartz/dartz.dart';
import 'package:admin/main.dart';

class UsersInfoRepository {
  Future<Either<String, List<UsersOrderData>>> getUsersOrderData(id) async {
    final response = await networkRepository.get(
        url:
            "admin/users/get-orders-history/0e2267f2-b5de-405b-acd2-3551286b3c73");
    final List<dynamic> totalOrders = response.data['data'];
    print(totalOrders);
    List<UsersOrderData> data =
        totalOrders.map((item) => UsersOrderData.fromJson(item)).toList();
    if (!response.failed) {
      return Right(data);
    }
    return Left(response.message);
  }
  Future<Either<String, List<UsersModerationHistory>>> getUsersModerationData(id) async {
    final response = await networkRepository.get(
        url:
            "admin/users/get-moderation-history/$id");
    final List<dynamic> moderations = response.data['data'];
    print(moderations);
    List<UsersModerationHistory> data =
        moderations.map((item) => UsersModerationHistory.fromJson(item)).toList();
    if (!response.failed) {
      return Right(data);
    }
    return Left(response.message);
  }
  
  Future<Either<String, bool>> blockUser(id,reason) async {
    final response = await networkRepository.post(
        data: {
           "reason": reason
          },
        url:
            "admin/users/block-user/$id");
  
   
    if (!response.failed) {
      return Right(true);
    }
    return Left(response.message);
  }
  
  Future<Either<String, bool>> unblockUser(id) async {
    final response = await networkRepository.post(
        url:
            "admin/users/unblock-user/$id");
  
   
    if (!response.failed) {
      return Right(true);
    }
    return Left(response.message);
  }
}

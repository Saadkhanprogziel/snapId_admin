import 'dart:convert';

import 'package:admin/main.dart';
import 'package:admin/models/users/user_stats_model.dart';
import 'package:dartz/dartz.dart';

class UserRepository {

Future<Either<String, UserStatsModel>> getUserStats() async{
  final response = await networkRepository.get(url: "admin/users/get-user-counts");
  if(!response.failed){
    final data = UserStatsModel.fromJson(response.data['data']);
    return right(data);
  }
  return left(response.message);
}



//   Future<Either<String, Paginate<UserModel>>> getAllUsers({
//     required Paginate<UserModel> previousData,
//     required Status status,
//     Map<String, dynamic>? extraQuery,
//   }) async {
//     final response = await networkRepository.get(
//       url: "/user/",
//       extraQuery: {
//         "status": fromStatus(status),
//         ...?extraQuery,
//       },
//     );
//     if (!response.failed) {
//       final parsedData = Paginate<UserModel>.mergePagination(
//         previousData: previousData,
//         newData: response.data,
//         dataFromJson: UserModel.fromJson,
//         dataKey: "users",
//       );
//       return right(parsedData);
//     }
//     return left(response.message);
//   }

//   Future<Either<String, UserModel>> updateUser({
//     String? fullName,
//     String? url,
//     String? phoneNumber,
//     String? deviceToken,
//   }) async {
//     final response =
//         await networkRepository.put(url: "/user/update-profile", data: {
//       "id": localStorage.getUser().id,
//       'fullName': fullName,
//       'phoneNumber': phoneNumber,
//       'url': url,
//       'deviceToken': deviceToken
//     });
//     if (!response.failed) {
//       final data = UserModel.fromJson(response.data["data"]);
//       localStorage.setString("user", jsonEncode(data.toJson()));
//       return right(data);
//     }
//     return left(response.message);
//   }

//   void updateFcmToken() async {
//     final fcm = FirebaseMessaging.instance;
//     updateUser(
//       fullName: localStorage.getUser().fullName,
//       deviceToken: await fcm.getToken(),
//     );
//   }

//   Future<Either<String, DashBoardHeaderStats>> getUserDashboardStats(
//       {Map<String, dynamic>? extraQuery}) async {
//     final response =
//         await networkRepository.get(url: "/user/stats", extraQuery: extraQuery);
//     if (!response.failed) {
//       final data = response.data["data"]["totalCounts"];
//       final parsedData = DashBoardHeaderStats.fromJson(data);
//       return right(parsedData);
//     }
//     return left(response.message);
//   }

//   Future<Either<String, SellerDetailModel>> getSellerDetail(
//       {required String id}) async {
//     final response =
//         await networkRepository.get(url: "/admin/get-seller-detail/$id");
//     if (!response.failed) {
//       final data = response.data["data"];
//       final parsedData = SellerDetailModel.fromJson(data);
//       return right(parsedData);
//     }
//     return left(response.message);
//   }

//   Future<Either<String, bool>> getSellerOrderCsv({required String id}) async {
//     final response = await networkRepository.downloadFile(
//         url: "$apiUrl/admin/get-seller-order-csv/$id");
//     if (!response.failed) {
//       return right(true);
//     }
//     return left(response.message);
//   }

//   Future<Either<String, BuyerDetailModel>> getBuyerDetail(
//       {required String id}) async {
//     final response =
//         await networkRepository.get(url: "/admin/get-buyer-detail/$id");
//     if (!response.failed) {
//       final data = response.data["data"];
//       final parsedData = BuyerDetailModel.fromJson(data);
//       return right(parsedData);
//     }
//     return left(response.message);
//   }

//   Future<Either<String, RevenueModel>> getSellerRevenueStats({
//     required String userId,
//     String filter = "month",
//   }) async {
//     final response = await networkRepository.get(
//       url: "/admin/seller/revenue/$userId",
//       extraQuery: {"filter": filter},
//     );
//     if (!response.failed) {
//       final data = response.data["data"];
//       final parsedData = RevenueModel.fromJson(data);
//       return right(parsedData);
//     }
//     return left(response.message);
//   }

//   Future<Either<String, bool>> changePassword({
//     required String currentPassword,
//     required String newPassword,
//   }) async {
//     final response = await networkRepository.put(
//         url: "/user/change-password",
//         data: {"currentPassword": currentPassword, "newPassword": newPassword});
//     if (!response.failed) {
//       return right(true);
//     }
//     return left(response.message);
//   }

//   Future<Either<String, bool>> updateUserStatus(
//       {required String id, required Status status}) async {
//     final response = await networkRepository.put(
//         url: "/user/update-user-status/$id",
//         data: {"status": fromStatus(status)});
//     if (!response.failed) {
//       return right(true);
//     }
//     return left(response.message);
//   }
}

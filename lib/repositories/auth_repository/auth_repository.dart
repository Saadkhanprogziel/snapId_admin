import 'dart:convert';
import 'package:admin/main.dart';
import 'package:admin/models/user_model/user_model.dart';
import 'package:dartz/dartz.dart';

class AuthRepository {
  Future<Either<String, UserModel>> login({
    required String email,
    required String password,
  }) async {
    final response = await networkRepository.post(
        url: "admin/auth/login",
        data: {"emailORphone": email, "password": password});
    if (!response.failed) {
      final data = UserModel.fromJson(response.data["data"]);
      print("ye lo ${response.data['data']['accessToken']}");

      localStorage.setString("user", jsonEncode(data.toJson()));

      return right(data);
    }
    return left(response.message);
  }

  Future<Either<String, bool>> forgotPassowrd({required String email}) async {
    final response = await networkRepository
        .put(url: "/auth/forget-password", data: {"email": email});
    if (!response.failed) {
      return right(true);
    }
    return left(response.message);
  }

  Future<Either<String, UserModel>> verifyOtp(
      {required String email, required int otp}) async {
    final response =
        await networkRepository.post(url: "/auth/verified-email", data: {
      "email": email,
      "otp": otp,
    });
    if (!response.failed) {
      final data = response.data["data"];
      final user = UserModel.fromJson(data);
      localStorage.setString("user", jsonEncode(user.toJson()));
      return right(user);
    }
    return left(response.message);
  }

  Future<Either<String, bool>> updatePassword(
      {required String password}) async {
    final response = await networkRepository
        .post(url: "/auth/update-password", data: {"newPassword": password});
    if (!response.failed) {
      return right(true);
    }
    return left(response.message);
  }
}

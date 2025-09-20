import 'dart:convert';
import 'package:admin/constants/constants.dart';
import 'package:admin/main.dart';
import 'package:admin/models/admin_model/admin_model.dart';
import 'package:dartz/dartz.dart';
import 'dart:typed_data';

class AuthRepository {
  Future<Either<String, AdminUserModel>> updateProfile({
    required String firstName,
    required String lastName,
    required String phoneNumber,
    Uint8List? profileImageBytes,
    String? profileImageName,
  }) async {
    try {
      // Prepare form fields
      final fields = {
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
      };

      // Create FormData using NetworkRepository utility
      final formData = await networkRepository.createFormData(
        fields: fields,
        fileField: profileImageBytes != null ? 'profilePicLocalPath' : null,
        fileBytes: profileImageBytes,
        fileName: profileImageName,
      );

      // Prepare headers
      final token = localStorage.getString('token');
      final headers = token != null ? {'Authorization': 'Bearer $token'} : null;

      // Send multipart request
      final response = await networkRepository.postMultipart(
        url: '${apiUrl}admin/auth/update-admin-profile',
        formData: formData,
        headers: headers,
      );

      if (response.success && response.data != null) {
        final updatedUser = AdminUserModel.fromJson(response.data['data']);
        localStorage.setString("user", jsonEncode(updatedUser.toJson()));
        return Right(updatedUser);
      } else {
        return Left(response.message);
      }
    } catch (e) {
      return Left('Failed to update profile: $e');
    }
  }


  Future<Either<String, AdminUserModel>> login({
    required String email,
    required String password,
  }) async {
    final response = await networkRepository.post(
        url: "admin/auth/login",
        data: {"emailORphone": email, "password": password});
    if (!response.failed) {
      final data = AdminUserModel.fromJson(response.data["data"]);
      localStorage.setString("user", jsonEncode(data.toJson()));
      return right(data);
    }
    return left(response.message);
  }

  Future<Either<String, bool>> logout() async {
    final response = await networkRepository.post(url: "/admin/auth/logout");
    if (!response.failed) {
      localStorage.remove('token');
      localStorage.remove('user');
      return right(true);
    }
    return left(response.message);
  }


  Future<Either<String, AdminUserModel>> getProfile() async {
    try {
      final response = await networkRepository.get(
        url: '${apiUrl}admin/auth/get-profile-data',
      );

      if (response.success) {
        final userData = AdminUserModel.fromJson(response.data['data']);
        localStorage.setString("user", jsonEncode(userData.toJson()));
        return Right(userData);
      } else {
        return Left(response.message);
      }
    } catch (e) {
      return Left('Failed to fetch profile: $e');
    }
  }

  Future<Either<String, bool>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword
  }) async {
    try {
      final response = await networkRepository.post(
        url: '${apiUrl}admin/auth/change-admin-password',
        data: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
          'confirmNewPassword': confirmNewPassword,
        },
      );

      if (response.success) {
        return Right(true);
      } else {
        return Left(response.message);
      }
    } catch (e) {
      return Left('Failed to change password: $e');
    }
  }

  AdminUserModel? getCurrentUser() {
    try {
      final userJson = localStorage.getString("user");
      if (userJson != null) {
        return AdminUserModel.fromJson(jsonDecode(userJson));
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}

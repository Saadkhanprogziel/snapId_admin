import 'package:admin/main.dart';
import 'package:universal_html/html.dart' as html;
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';

import 'dio/dio_client.dart';
import 'network_monitor.dart';
import 'network_response.dart';

class NetworkRepository {
  final dioClient = DioClient();
  final networkMonitor = NetworkMonitor();

  Future<NetworkResponse> request({
    required String method,
    required String url,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    if (!await networkMonitor.checkConnection()) {
      throw NetworkResponse(
        message: "No internet connection",
        data: null,
        success: "false",
      );
    }

    final completer = Completer<NetworkResponse>();
    late NetworkResponse networkResponse;
    StreamSubscription? networkSubscription;

    networkSubscription = networkMonitor.onConnectivityChanged.listen(
      (hasConnection) {
        if (!hasConnection && !completer.isCompleted) {
          networkResponse = NetworkResponse(
            message: "Internet connection lost",
            data: null,
            failed: true,
            success: "false",
          );
          completer.completeError(networkResponse);
        }
      },
    );
    try {
      final response = await dioClient.dio.request(
        url,
        data: data,
        queryParameters: queryParameters,
        options: Options(method: method),
      );

      networkResponse = _handleResponse(response);
      completer.complete(networkResponse);
    } on DioException catch (e) {
      log("Caught in DIO CATCH!");
      if (!completer.isCompleted) {
        networkResponse = DioClient.handleDioError(e);
        networkResponse.failed = true;
        completer.completeError(networkResponse);
        return networkResponse;
      }
    } on NetworkResponse catch (e) {
      log("Caught in NETWORK CATCH!");
      if (!completer.isCompleted) {
        networkResponse = e;
        networkResponse.failed = true;
        completer.completeError(networkResponse);
        return networkResponse;
      }
    } catch (e) {
      if (!completer.isCompleted) {
        log("Caught in NORMAL CATCH!");
        networkResponse = NetworkResponse(
          message: "An unexpected error occurred",
          data: null,
          success: "false",
          failed: true,
        );
        completer.completeError(networkResponse);
        return networkResponse;
      }
    } finally {
      await networkSubscription.cancel();
    }

    return networkResponse;
  }

  Future<NetworkResponse> get({
    required String url,
    Map<String, dynamic>? extraQuery,
  }) =>
      request(
        method: 'GET',
        url: url,
        queryParameters: extraQuery,
      );

  Future<NetworkResponse> post({
    required String url,
    Map<String, dynamic>? data,
  }) =>
      request(
        method: 'POST',
        url: url,
        data: data,
      );

  Future<NetworkResponse> patch({
    required String url,
    Map<String, dynamic>? data,
  }) =>
      request(
        method: 'PATCH',
        url: url,
        data: data,
      );

  Future<NetworkResponse> put({
    required String url,
    Map<String, dynamic>? data,
  }) =>
      request(
        method: 'PUT',
        url: url,
        data: data,
      );

  Future<NetworkResponse> delete({required String url}) => request(
        method: 'DELETE',
        url: url,
      );

  Future<NetworkResponse> downloadFile({required String url}) async {
    try {
      final token = localStorage.getString("token");
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "text/csv",
        },
      );
      if (response.statusCode == 200) {
        final blob = html.Blob([response.bodyBytes], 'text/csv');
        final url = html.Url.createObjectUrlFromBlob(blob);
        html.AnchorElement(href: url)
          ..setAttribute("download", "SellerOrderList.csv")
          ..click();
        html.Url.revokeObjectUrl(url);
        return NetworkResponse(
            data: blob, message: "File downloaded successfully");
      } else {
        return NetworkResponse(failed: true, message: "Something went wrong");
      }
    } catch (e) {
      log("Error downloading file: $e");
      return NetworkResponse(failed: true, message: "Something went wrong");
    }
  }
}

NetworkResponse _handleResponse(Response response) {
  final body = response.data;

  if (response.statusCode == 200 || response.statusCode == 201) {
    return NetworkResponse(
      data: body,
      message: body["message"] ?? "",
    );
  }
  throw NetworkResponse(
    failed: true,
    message: body["message"] ?? "Something went wrong",
  );
}

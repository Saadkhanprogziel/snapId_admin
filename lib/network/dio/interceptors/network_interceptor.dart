import 'package:admin/main.dart';
import 'package:dio/dio.dart';


class NetworkInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final body = response.data;
    if (body != null) {
      final data = body['data'];
      if (data != null && data is Map<String, dynamic>) {
        final token = data["token"];
        if (token != null && token is String) {
          localStorage.setString('token', token);
        }
      }
    }
    return handler.next(response);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = localStorage.getString("token")?.toString() ?? "";
    if (token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }
}

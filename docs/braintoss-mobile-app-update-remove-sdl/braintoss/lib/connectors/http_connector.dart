import 'package:braintoss/connectors/reconnect_retry_interceptor.dart';
import 'package:braintoss/constants/api_path.dart';
import 'package:dio/dio.dart';

class HttpConnector {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseURL,
      contentType: 'application/json',
    ),
  );

  HttpConnector() {
    _dio.interceptors.add(ReconnectRetryInterceptor(dio: _dio));
  }

  Future<Response?> get(String endpoint) async {
    return await _dio.get(endpoint);
  }

  Future<Response?> post(String endpoint, dynamic payload) async {
    return await _dio.post(
      endpoint,
      data: payload,
    );
  }
}

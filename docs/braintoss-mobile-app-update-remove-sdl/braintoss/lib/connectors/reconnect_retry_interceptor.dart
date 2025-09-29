import 'dart:async';
import 'dart:io';

//import 'package:connectivity/connectivity.dart'; //for iOS
import 'package:connectivity_plus/connectivity_plus.dart'; //for Android

import 'package:dio/dio.dart';

extension _AsOptions on RequestOptions {
  Options asOptions() {
    return Options(
      method: method,
      sendTimeout: sendTimeout,
      receiveTimeout: receiveTimeout,
      extra: extra,
      headers: headers,
      responseType: responseType,
      contentType: contentType,
      validateStatus: validateStatus,
      receiveDataWhenStatusError: receiveDataWhenStatusError,
      followRedirects: followRedirects,
      maxRedirects: maxRedirects,
      requestEncoder: requestEncoder,
      responseDecoder: responseDecoder,
      listFormat: listFormat,
    );
  }
}

class ReconnectRetryInterceptor extends Interceptor {
  final Dio dio;
  final Connectivity _connectivity = Connectivity();

  ReconnectRetryInterceptor({
    required this.dio,
  });

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err)) {
      try {
        return _scheduleRequestRetry(err.requestOptions);
      } catch (e) {
        handler.reject(err);
      }
    } else {
      handler.next(err);
    }
  }

  Future<Response> _scheduleRequestRetry(RequestOptions requestOptions) async {
    StreamSubscription? streamSubscription;
    final responseCompleter = Completer<Response>();

    streamSubscription = _connectivity.onConnectivityChanged.listen(
      (connectivityResult) {
        if (!connectivityResult.contains(ConnectivityResult.none)) {
          //for Android
          //if (connectivityResult != ConnectivityResult.none) {
          //for iOS
          streamSubscription?.cancel();
          responseCompleter.complete(
            dio.request(
              requestOptions.path,
              cancelToken: requestOptions.cancelToken,
              data: requestOptions.data,
              onReceiveProgress: requestOptions.onReceiveProgress,
              onSendProgress: requestOptions.onSendProgress,
              queryParameters: requestOptions.queryParameters,
              options: requestOptions.asOptions(),
            ),
          );
        }
      },
    );

    return responseCompleter.future;
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.unknown &&
        err.error != null &&
        err.error is SocketException;
  }
}

import 'dart:async';
import 'package:dio/dio.dart';

class DataAdapter {
  String apiBaseUrl = "https://api.tvmaze.com/";
  Completer _readyCompleter = Completer();
  Dio _dio = new Dio();

  DataAdapter() {
    BaseOptions options = BaseOptions(baseUrl: apiBaseUrl);
    _dio = new Dio(options);
    _readyCompleter.complete();
  }

  Future<void> ready() {
    return _readyCompleter.future;
  }

  Future<Response> get<T>(String path, {Map<String, dynamic> query}) async {
    CancelToken token = CancelToken();
    Future<Response> request =
        _dio.get<T>(path, queryParameters: query, cancelToken: token);

    return request;
  }
}

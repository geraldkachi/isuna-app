import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:misau/exceptions/error_handling.dart';
import 'package:misau/interceptors/app_interceptors.dart';

class NetworkService with ErrorHandling {
  late final Dio dio;

  late final Dio? altDio;

  final String url = "https://misau-gateway.fly.dev";

  NetworkService() {
    dio = Dio(
      BaseOptions(
        baseUrl: url,
        connectTimeout: const Duration(minutes: 1),
      ),
    );
    if (kDebugMode) {
      dio.interceptors.addAll([
        LogInterceptor(
          responseBody: true,
          error: true,
          requestHeader: true,
          responseHeader: false,
          request: false,
          requestBody: true,
        ),
        AppInterceptor(),
      ]);
    }
    dio.interceptors.add(AppInterceptor());

    altDio = Dio();
  }

  Future getAlt(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      Response response = await altDio!.get(
        path,
        queryParameters: queryParameters,
      );

      return response.data;
    } on DioException catch (e) {
      handleError(e);
    }
  }

  Future get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      Response response = await dio.get(
        path,
        queryParameters: queryParameters,
      );

      return response.data;
    } on DioException catch (e) {
      handleError(e);
    }
  }

  Future delete(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      Response response = await dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
      );

      return response.data;
    } on DioException catch (e) {
      handleError(e);
    }
  }

  Future post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      Response response = await dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );

      return response.data;
    } on DioException catch (e) {
      handleError(e);
    }
  }
}

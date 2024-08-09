import 'dart:io';

import 'package:dio/dio.dart';
import 'package:misau/app/locator.dart';
import 'package:misau/service/secure_storage_service.dart';
import 'package:misau/utils/string_utils.dart';

class AppInterceptor extends Interceptor {
    final SecureStorageService _secureStorageService = getIt<SecureStorageService>();

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
  
      String? token = await _secureStorageService.readAccessToken();

    if (StringUtils.isNotEmpty(token)) {
      options.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
    }
        
    options.headers.addAll({
      HttpHeaders.contentTypeHeader: 'application/json',
      'User-Agent': 'insomnia/2023.5.8'
    });
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {}
    super.onError(err, handler);
  }
}

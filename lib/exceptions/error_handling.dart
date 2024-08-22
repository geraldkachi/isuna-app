import 'package:dio/dio.dart';
import 'package:isuna/exceptions/misau_exception.dart';

mixin ErrorHandling {
  void handleError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      throw MisauException(
          message:
              "Opps, this is taking too long. Check your network and try again.");
    }

    if (e.type == DioExceptionType.connectionError) {
      throw MisauException(
          message: "Please check your internet connection and try again.");
    }

    if (e.type == DioExceptionType.unknown) {
      throw MisauException(
          message: "Something occured at this time. Please try again.");
    }

    if (e.response?.statusCode == 500) {
      throw MisauException(message: "Service is unavailable at this time.");
    }

    if (e.response!.statusCode! >= 400) {
      throw MisauException(message: e.response?.data['message']);
    }
  }
}

import 'dart:async';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:pokemon_explorer/core/constants/api_config.dart';
import 'package:pokemon_explorer/core/constants/error_constants.dart';
import 'package:pokemon_explorer/core/network/network_exceptions.dart';

/// Base network client with global interceptors and error handling
class ApiClient extends GetConnect {
  static ApiClient get to => Get.find();

  @override
  void onInit() {
    baseUrl = ApiConfig.baseUrl;
    timeout = const Duration(seconds: ApiConfig.receiveTimeout);
    
    // Request interceptor: check connectivity before each call
    httpClient.addRequestModifier<dynamic>((request) async {
      final List<ConnectivityResult> connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
        throw NoInternetException(ErrorConstants.errorNoInternet);
      }
      return request;
    });

    // Response interceptor: centralize error handling
    httpClient.addResponseModifier((request, response) {
      return _handleResponse(response);
    });

    super.onInit();
  }

  /// Map HTTP status codes to custom network exceptions
  Response _handleResponse(Response response) {
    if (response.status.hasError) {
      if (response.status.connectionError) {
        throw NoInternetException(ErrorConstants.errorNetwork);
      }
      
      final int statusCode = response.statusCode ?? 500;
      switch (statusCode) {
        case 400:
          throw BadRequestException(ErrorConstants.errorBadRequest, statusCode);
        case 401:
        case 403:
          throw UnauthorizedException(ErrorConstants.errorUnauthorized, statusCode);
        case 404:
          throw NotFoundException(ErrorConstants.errorNotFound, statusCode);
        case 408:
          throw ApiTimeoutException(ErrorConstants.errorTimeout);
        case 500:
        default:
          throw FetchDataException(ErrorConstants.errorServer, statusCode);
      }
    }
    return response;
  }

  /// Safe request wrapper with enforced timeouts
  Future<Response> safeGet(String url, {Map<String, dynamic>? query}) async {
    try {
      final Response response = await get(url, query: query).timeout(
        const Duration(seconds: ApiConfig.connectTimeout),
      );
      return response;
    } on TimeoutException {
      throw ApiTimeoutException(ErrorConstants.errorTimeout);
    } catch (e) {
      rethrow;
    }
  }
}

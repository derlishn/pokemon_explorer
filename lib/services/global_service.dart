import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../helpers/constants.dart';

class GlobalService extends GetxService {
  final http.Client _client = http.Client();

  Future<GlobalService> init() async {
    return this;
  }

  Future<dynamic> get(String endpoint, {Map<String, String>? queryParams}) async {
    try {
      final uri = Uri.parse('${AppConstants.baseUrl}$endpoint').replace(
        queryParameters: queryParams,
      );
      
      final response = await _client.get(uri).timeout(const Duration(seconds: 10));
      
      return _handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  dynamic _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return jsonDecode(response.body);
      case 404:
        throw Exception('Resource not found (404)');
      case 500:
        throw Exception('Internal server error (500)');
      default:
        throw Exception('Failed to load data: ${response.statusCode}');
    }
  }

  @override
  void onClose() {
    _client.close();
    super.onClose();
  }
}

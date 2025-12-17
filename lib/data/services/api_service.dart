import 'dart:convert';

import 'package:http/http.dart' as http;

/// Generic API service for HTTP operations.
///
/// Provides a unified interface for making HTTP requests with:
/// - GET, POST, PUT, DELETE methods
/// - Automatic JSON parsing
/// - Custom headers support
/// - Timeout handling
/// - Error handling and friendly error messages
///
/// Example:
/// ```dart
/// final api = ApiService(
///   baseUrl: 'https://api.example.com',
///   defaultHeaders: {'Content-Type': 'application/json'},
/// );
/// final data = await api.get('/users');
/// ```
class ApiService {
  final http.Client _client;
  final String baseUrl;
  final Map<String, String>? defaultHeaders;

  ApiService({required this.baseUrl, this.defaultHeaders, http.Client? client})
    : _client = client ?? http.Client();

  /// GET request
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? headers,
    Duration timeout = const Duration(seconds: 30),
  }) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final response = await _client
          .get(url, headers: {...?defaultHeaders, ...?headers})
          .timeout(timeout);

      return _handleResponse(response);
    } catch (e) {
      throw Exception('GET request failed: $e');
    }
  }

  /// POST request
  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Duration timeout = const Duration(seconds: 30),
  }) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final response = await _client
          .post(
            url,
            headers: {...?defaultHeaders, ...?headers},
            body: body != null ? json.encode(body) : null,
          )
          .timeout(timeout);

      return _handleResponse(response);
    } catch (e) {
      throw Exception('POST request failed: $e');
    }
  }

  /// PUT request
  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Duration timeout = const Duration(seconds: 30),
  }) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final response = await _client
          .put(
            url,
            headers: {...?defaultHeaders, ...?headers},
            body: body != null ? json.encode(body) : null,
          )
          .timeout(timeout);

      return _handleResponse(response);
    } catch (e) {
      throw Exception('PUT request failed: $e');
    }
  }

  /// DELETE request
  Future<Map<String, dynamic>> delete(
    String endpoint, {
    Map<String, String>? headers,
    Duration timeout = const Duration(seconds: 30),
  }) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final response = await _client
          .delete(url, headers: {...?defaultHeaders, ...?headers})
          .timeout(timeout);

      return _handleResponse(response);
    } catch (e) {
      throw Exception('DELETE request failed: $e');
    }
  }

  /// Handle HTTP response
  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return {};
      }
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception(
        'HTTP ${response.statusCode}: ${response.reasonPhrase}\n${response.body}',
      );
    }
  }

  /// Check API health
  Future<bool> checkHealth() async {
    try {
      await _client.get(Uri.parse(baseUrl)).timeout(const Duration(seconds: 5));
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Dispose client
  void dispose() {
    _client.close();
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ApiService {
  // Base URL for your API
  final String baseUrl = 'http://10.0.60.26:8001';

  // Singleton pattern for API service
  static final ApiService _instance = ApiService._internal();

  factory ApiService() => _instance;

  ApiService._internal();

  // Headers that will be used in all requests
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    // Add auth token if available
    if (_authToken != null) 'Authorization': 'Bearer $_authToken',
  };

  // Auth token storage
  String? _authToken;

  // Set auth token
  void setAuthToken(String token) {
    _authToken = token;
  }

  // Clear auth token (for logout)
  void clearAuthToken() {
    _authToken = null;
  }

  Future<bool> checkInternetConnection({
    Duration timeout = const Duration(seconds: 5),
  }) async {
    try {
      final result = await InternetAddress.lookup(
        'google.com',
      ).timeout(timeout);

      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      logger.e('❌ No internet connection (SocketException)');
      return false;
    } catch (e) {
      logger.e('Unexpected error: $e');
      return false;
    }
  }

  // Generic HTTP request method
  Future<dynamic> request({
    required String endpoint,
    required String method,
    Map<String, dynamic>? body,
    Map<String, String>? queryParams,
    bool useAuth = true,
  }) async {
    bool isConnected = true /* await checkInternetConnection()*/;
    if (!isConnected) {
      return {'success': false, 'message': 'No internet connection'};
    }

    // Build the URL with query parameters if provided
    var uri = Uri.parse('$baseUrl/$endpoint');
    if (queryParams != null && queryParams.isNotEmpty) {
      uri = uri.replace(queryParameters: queryParams);
    }
    // logger.d(uri.toString());
    http.Response response;
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (useAuth && _authToken != null) 'Authorization': 'Bearer $_authToken',
    };
    try {
      switch (method) {
        case 'GET':
          response = await http.get(uri, headers: headers);
          break;
        case 'POST':
          response = await http.post(
            uri,
            headers: headers,
            body: body != null ? json.encode(body) : null,
          );
          break;
        case 'PUT':
          response = await http.put(
            uri,
            headers: headers,
            body: body != null ? json.encode(body) : null,
          );
          break;
        case 'PATCH':
          response = await http.patch(
            uri,
            headers: headers,
            body: body != null ? json.encode(body) : null,
          );
          break;
        case 'DELETE':
          response = await http.delete(
            uri,
            headers: headers,
            body: body != null ? json.encode(body) : null,
          );
          break;
        default:
          throw Exception('Unsupported HTTP method: $method');
      }
      if (body != null) {
        logger.d(body);
        logger.d(uri.toString());
      }

      // Parse response
      var responseData = json.decode(response.body);
      // logger.d(responseData);
      // Check status code
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return responseData;
      } else {
        return {
          'success': false,
          'message':
              responseData['message'] ??
              'Request failed with status: ${response.statusCode}',
          'statusCode': response.statusCode,
          'data': responseData,
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Request failed: ${e.toString()}'};
    }
  }

  Future<dynamic> multipartRequest({
    required String endpoint,
    required String method,
    required Map<String, String> fields,
    required Map<String, dynamic>
    files, // Use dynamic to support both single files and lists
  }) async {
    // Check internet connection first
    bool isConnected = await checkInternetConnection();
    if (!isConnected) {
      return {'success': false, 'message': AppStaticStrings.noInternet};
    }

    var uri = Uri.parse('$baseUrl/$endpoint');
    var request = http.MultipartRequest(method, uri);

    // Add headers (including auth token if available)
    request.headers.addAll(_headers);

    // Add fields (text data)
    fields.forEach((key, value) {
      request.fields[key] = value;
    });
    logger.d('Sending Multipart Request:');
    logger.d('➡️ URL: $uri');
    logger.d('➡️ Method: $method');
    logger.d('➡️ Headers: ${request.headers}');
    logger.d('➡️ Fields: ${request.fields}');
    logger.d('➡️ Files:');
    for (var f in request.files) {
      print(
        '  - Field: ${f.field}, Filename: ${f.filename}, Length: ${f.length}',
      );
    }
    // Function to determine MediaType based on file extension
    MediaType getMediaType(String path) {
      final extension = path.split('.').last.toLowerCase();
      switch (extension) {
        case 'pdf':
          return MediaType('application', 'pdf');
        case 'jpg':
        case 'jpeg':
          return MediaType('image', 'jpeg');
        case 'png':
          return MediaType('image', 'png');
        case 'gif':
          return MediaType('image', 'gif');
        case 'webp':
          return MediaType('image', 'webp');
        case 'doc':
          return MediaType('application', 'msword');
        case 'docx':
          return MediaType(
            'application',
            'vnd.openxmlformats-officedocument.wordprocessingml.document',
          );
        default:
          return MediaType(
            'application',
            'octet-stream',
          ); // Default binary data
      }
    }

    // Add files
    for (var key in files.keys) {
      var value = files[key];

      if (value is File) {
        // Single file
        var fileStream = http.ByteStream(value.openRead());
        var length = await value.length();
        var fileName = value.path.split('/').last;

        var multipartFile = http.MultipartFile(
          key,
          fileStream,
          length,
          filename: fileName,
          contentType: getMediaType(value.path),
        );
        request.files.add(multipartFile);
      } else if (value is List) {
        // List of files
        for (var file in value) {
          if (file is File) {
            var fileStream = http.ByteStream(file.openRead());
            var length = await file.length();
            var fileName = file.path.split('/').last;

            var multipartFile = http.MultipartFile(
              key, // Use the same key for all files in the list
              fileStream,
              length,
              filename: fileName,
              contentType: getMediaType(file.path),
            );
            request.files.add(multipartFile);
          }
        }
      }
    }

    try {
      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseData);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonResponse;
      } else {
        return {
          'success': false,
          'message':
              jsonResponse['message'] ??
              'Request failed with status: ${response.statusCode}',
          'statusCode': response.statusCode,
          'data': jsonResponse,
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Request failed: ${e.toString()}'};
    }
  }
}

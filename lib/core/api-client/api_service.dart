import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:e_hailing_app/core/service/internet_service.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ApiService {
final String baseUrl = 'http://18.211.171.8:8002';

  // final String baseUrl = 'http://10.10.20.44:8001';

  static final ApiService _instance = ApiService._internal();

  factory ApiService() => _instance;

  ApiService._internal() {
    _connectionManager = ConnectionManager();
    _setupConnectionMonitoring();
  }

  // Enhanced connection management
  late ConnectionManager _connectionManager;
  bool _isOnline = true;
  Timer? _retryTimer;
  static const int _maxRetries = 3;
  static const Duration _retryDelay = Duration(seconds: 1);

  // Original headers getter - keeping exact structure
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    // Add auth token if available
    if (_authToken != null) 'Authorization': 'Bearer $_authToken',
  };

  // Original auth token storage - keeping exact
  String? _authToken;

  /// Setup connection monitoring
  void _setupConnectionMonitoring() {
    _connectionManager.addConnectionStateListener((isConnected) {
      _isOnline = isConnected;
      if (isConnected) {
        logger.i('Internet connection restored');
      } else {
        logger.w('Internet connection lost');
      }
    });
  }

  // Original setAuthToken method - keeping exact
  void setAuthToken(String token) {
    _authToken = token;
  }

  // Original clearAuthToken method - keeping exact
  void clearAuthToken() {
    _authToken = null;
  }

  /// Enhanced checkInternetConnection - keeping original method name and signature
  Future<bool> checkInternetConnection({
    Duration timeout = const Duration(seconds: 5),
  }) async {
    try {
      // Use enhanced connection manager but keep original behavior
      return await _connectionManager.checkConnection(timeout: timeout);
    } catch (e) {
      logger.e('Connection check error: $e');
      return false;
    }
  }

  /// Original request method with enhanced connection handling
  Future<dynamic> request({
    required String endpoint,
    required String method,
    Map<String, dynamic>? body,
    Map<String, String>? queryParams,
    bool useAuth = true,
  }) async {
    // Enhanced connection check that doesn't immediately fail on slow connections
    bool isConnected = await _connectionManager.checkConnection(
      timeout: Duration(seconds: 8), // Longer timeout for slow connections
    );

    if (!isConnected) {
      return {'success': false, 'message': 'No internet connection'};
    }

    // Build the URL with query parameters if provided - keeping original logic
    var uri = Uri.parse('$baseUrl/$endpoint');
    if (queryParams != null && queryParams.isNotEmpty) {
      uri = uri.replace(queryParameters: queryParams);
    }
// logger.i(uri);
    // Enhanced retry logic for better reliability
    for (int attempt = 0; attempt < _maxRetries; attempt++) {
      try {
        if (attempt > 0) {
          // Wait before retry with exponential backoff
          await Future.delayed(_retryDelay * (attempt + 1));

          // Recheck connection before retry
          if (!await _connectionManager.quickCheck()) {
            return {
              'success': false,
              'message': 'Connection lost during retry',
            };
          }

          logger.i('Retrying request (attempt ${attempt + 1}/$_maxRetries)');
        }

        http.Response response;
        final headers = {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (useAuth && _authToken != null)
            'Authorization': 'Bearer $_authToken',
        };

        // Original request logic with timeout
        final httpClient = http.Client();
        try {
          switch (method) {
            case 'GET':
              response = await httpClient
                  .get(uri, headers: headers)
                  .timeout(Duration(seconds: 30));
              break;
            case 'POST':
              response = await httpClient
                  .post(
                    uri,
                    headers: headers,
                    body: body != null ? json.encode(body) : null,
                  )
                  .timeout(Duration(seconds: 30));
              break;
            case 'PUT':
              response = await httpClient
                  .put(
                    uri,
                    headers: headers,
                    body: body != null ? json.encode(body) : null,
                  )
                  .timeout(Duration(seconds: 30));
              break;
            case 'PATCH':
              response = await httpClient
                  .patch(
                    uri,
                    headers: headers,
                    body: body != null ? json.encode(body) : null,
                  )
                  .timeout(Duration(seconds: 30));
              break;
            case 'DELETE':
              response = await httpClient
                  .delete(
                    uri,
                    headers: headers,
                    body: body != null ? json.encode(body) : null,
                  )
                  .timeout(Duration(seconds: 30));
              break;
            default:
              throw Exception('Unsupported HTTP method: $method');
          }
        } finally {
          httpClient.close();
        }

        // Original logging - keeping exact
        if (body != null) {
          logger.d(body);
          logger.d(uri.toString());
        }

        // Original response parsing - keeping exact
        var responseData = json.decode(response.body);
        // logger.d(responseData);

        // Original status code checking - keeping exact
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
        logger.e('Request attempt ${attempt + 1} failed: $e');

        // Don't retry on certain errors
        if (e is FormatException || e.toString().contains('401')) {
          return {
            'success': false,
            'message': 'Request failed: ${e.toString()}',
          };
        }

        // Return error on last attempt
        if (attempt == _maxRetries - 1) {
          return {
            'success': false,
            'message': 'Request failed: ${e.toString()}',
          };
        }
      }
    }

    return {'success': false, 'message': 'Request failed after all attempts'};
  }

  /// Original multipartRequest method with enhanced connection handling
  Future<dynamic> multipartRequest({
    required String endpoint,
    required String method,
    required Map<String, String> fields,
    required Map<String, dynamic>
    files, // Use dynamic to support both single files and lists
  }) async {
    // Enhanced connection check first
    bool isConnected = await _connectionManager.checkConnection(
      timeout: Duration(seconds: 8), // Longer timeout for slow connections
    );

    if (!isConnected) {
      return {'success': false, 'message': 'No internet connection'};
    }

    // Enhanced retry logic
    for (int attempt = 0; attempt < _maxRetries; attempt++) {
      try {
        if (attempt > 0) {
          await Future.delayed(_retryDelay * (attempt + 1));

          // Recheck connection before retry
          if (!await _connectionManager.quickCheck()) {
            return {
              'success': false,
              'message': 'Connection lost during retry',
            };
          }

          logger.i(
            'Retrying multipart request (attempt ${attempt + 1}/$_maxRetries)',
          );
        }

        var uri = Uri.parse('$baseUrl/$endpoint');
        var request = http.MultipartRequest(method, uri);

        // Add headers (including auth token if available) - keeping original
        request.headers.addAll(_headers);

        // Add fields (text data) - keeping original
        fields.forEach((key, value) {
          request.fields[key] = value;
        });

        // Original logging - keeping exact
        logger.d('Sending Multipart Request:');
        logger.d('➡️ URL: $uri');
        logger.d('➡️ Method: $method');
        logger.d('➡️ Headers: ${request.headers}');
        logger.d('➡️ Fields: ${request.fields}');
        logger.d('➡️ Files:');

        // Original MediaType function - keeping exact
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
              return MediaType('application', 'octet-stream');
          }
        }

        // Original file handling - keeping exact logic
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

        // Original logging after files added
        for (var f in request.files) {
          logger.d(
            '  - Field: ${f.field}, Filename: ${f.filename}, Length: ${f.length}',
          );
        }

        // Send request with timeout
        var response = await request.send().timeout(Duration(seconds: 120));
        var responseData = await response.stream.bytesToString();
        var jsonResponse = json.decode(responseData);

        // Original response handling - keeping exact
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
        logger.e('Multipart request attempt ${attempt + 1} failed: $e');

        // Return error on last attempt
        if (attempt == _maxRetries - 1) {
          return {
            'success': false,
            'message': 'Request failed: ${e.toString()}',
          };
        }
      }
    }

    return {
      'success': false,
      'message': 'Multipart request failed after all attempts',
    };
  }

  /// Additional helper methods
  bool get isOnline => _isOnline;

  /// Quick connection check
  Future<bool> quickConnectionCheck() async {
    return await _connectionManager.quickCheck();
  }

  /// Dispose resources
  void dispose() {
    _connectionManager.dispose();
    _retryTimer?.cancel();
  }
}

import 'dart:async';
import 'dart:io';

import 'package:e_hailing_app/core/utils/variables.dart';

/// Enhanced Internet Connection Manager with sophisticated connectivity detection
class ConnectionManager {
  static final ConnectionManager _instance = ConnectionManager._internal();

  factory ConnectionManager() => _instance;

  ConnectionManager._internal();

  // Connection state management
  bool _isConnected = true;
  bool _isChecking = false;
  Timer? _periodicCheckTimer;
  Timer? _retryTimer;

  // Configuration
  static const Duration _defaultTimeout = Duration(seconds: 8);
  static const Duration _quickTimeout = Duration(seconds: 3);
  static const Duration _periodicCheckInterval = Duration(seconds: 30);
  static const Duration _retryDelay = Duration(seconds: 2);
  static const int _maxRetries = 3;

  // Multiple fallback servers for reliability
  static const List<String> _testServers = [
    'google.com',
    'cloudflare.com',
    '8.8.8.8',
    'apple.com',
    'microsoft.com',
  ];

  // Getters
  bool get isConnected => _isConnected;

  bool get isChecking => _isChecking;

  // Connection state change callbacks
  final List<Function(bool)> _connectionStateCallbacks = [];

  void addConnectionStateListener(Function(bool) callback) {
    _connectionStateCallbacks.add(callback);
  }

  void removeConnectionStateListener(Function(bool) callback) {
    _connectionStateCallbacks.remove(callback);
  }

  void _notifyConnectionStateChange(bool isConnected) {
    if (_isConnected != isConnected) {
      _isConnected = isConnected;
      for (final callback in _connectionStateCallbacks) {
        try {
          callback(isConnected);
        } catch (e) {
          logger.e(e.toString());
        }
      }
    }
  }

  /// Start periodic connectivity monitoring
  void startPeriodicCheck() {
    stopPeriodicCheck();
    _periodicCheckTimer = Timer.periodic(_periodicCheckInterval, (_) {
      checkConnection(timeout: _quickTimeout);
    });
  }

  /// Stop periodic connectivity monitoring
  void stopPeriodicCheck() {
    _periodicCheckTimer?.cancel();
    _periodicCheckTimer = null;
  }

  /// Enhanced connection check with multiple fallbacks and retry logic
  Future<bool> checkConnection({
    Duration timeout = _defaultTimeout,
    bool updateState = true,
    int maxRetries = _maxRetries,
  }) async {
    if (_isChecking) return _isConnected;

    _isChecking = true;
    bool connectionResult = false;

    try {
      // Try multiple servers with exponential backoff
      for (int attempt = 0; attempt < maxRetries; attempt++) {
        if (attempt > 0) {
          await Future.delayed(_retryDelay * (attempt + 1));
        }

        connectionResult = await _testMultipleServers(timeout);
        if (connectionResult) break;

        // Reduce timeout for subsequent attempts
        timeout = Duration(
          milliseconds: (timeout.inMilliseconds * 0.8).round(),
        );
      }

      if (updateState) {
        _notifyConnectionStateChange(connectionResult);
      }
    } catch (e) {
      connectionResult = false;
    } finally {
      _isChecking = false;
    }

    return connectionResult;
  }

  /// Test multiple servers simultaneously for faster detection
  Future<bool> _testMultipleServers(Duration timeout) async {
    final List<Future<bool>> futures =
        _testServers
            .map((server) => _testSingleServer(server, timeout))
            .toList();

    try {
      // Wait for first successful response or all failures
      final results = await Future.wait(futures, eagerError: false);
      return results.any((result) => result);
    } catch (e) {
      return false;
    }
  }

  /// Test connection to a single server
  Future<bool> _testSingleServer(String server, Duration timeout) async {
    try {
      final result = await InternetAddress.lookup(server).timeout(timeout);
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Quick connection check for immediate feedback
  Future<bool> quickCheck() async {
    return await checkConnection(
      timeout: _quickTimeout,
      updateState: false,
      maxRetries: 1,
    );
  }

  /// Wait for connection to be available
  Future<bool> waitForConnection({
    Duration maxWait = const Duration(seconds: 30),
    Duration checkInterval = const Duration(seconds: 2),
  }) async {
    final stopwatch = Stopwatch()..start();

    while (stopwatch.elapsed < maxWait) {
      if (await quickCheck()) {
        return true;
      }
      await Future.delayed(checkInterval);
    }

    return false;
  }

  /// Dispose resources
  void dispose() {
    stopPeriodicCheck();
    _retryTimer?.cancel();
    _connectionStateCallbacks.clear();
  }
}

import 'dart:async';

import 'package:e_hailing_app/core/api-client/api_service.dart';
import 'package:e_hailing_app/core/service/internet_service.dart';
import 'package:e_hailing_app/core/service/socket-service/socket_events_variable.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();

  factory SocketService() => _instance;

  SocketService._internal() {
    _connectionManager = ConnectionManager();
    _setupConnectionMonitoring();
  }

  // Original properties - keeping your exact structure
  IO.Socket? socket;
  bool isConnected = false;
  bool isDriverActive = false;

  // Enhanced connection management
  late ConnectionManager _connectionManager;
  bool _isConnecting = false;
  bool _shouldReconnect = false;
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 5;
  static const Duration _reconnectDelay = Duration(seconds: 2);

  // Original callback functions - keeping your exact names
  Function(String)? onSocketError;
  Function()? onConnected;
  Function()? onDriverRegister;
  Function()? onDisconnected;
  Function(Map<String, dynamic>)? onAvailableTrip;
  final Map<String, Function> _customEventHandlers = {};

  /// Setup connection monitoring
  void _setupConnectionMonitoring() {
    _connectionManager.addConnectionStateListener((hasInternet) {
      if (!hasInternet && isConnected) {
        logger.w('Internet connection lost, socket may disconnect');
      } else if (hasInternet && !isConnected && _shouldReconnect) {
        logger.i(
          'Internet connection restored, attempting to reconnect socket',
        );
        _attemptReconnect();
      }
    });
  }

  /// Original connect method with enhanced connection checking
  void connect(String userId, bool isDriver) {
    if (_isConnecting) {
      logger.d('Connection already in progress');
      return;
    }

    if (isConnected) {
      logger.d('Socket already connected');
      return;
    }

    _isConnecting = true;
    _shouldReconnect = true;

    // Check internet connection first with your original timeout
    _connectionManager.checkConnection(timeout: Duration(seconds: 8)).then((
      hasInternet,
    ) {
      if (!hasInternet) {
        logger.e('No internet connection available');
        onSocketError?.call('No internet connection');
        _isConnecting = false;
        _scheduleReconnect();
        return;
      }

      try {
        socket = IO.io(ApiService().baseUrl, <String, dynamic>{
          'transports': ['websocket'],
          'autoConnect': false,
          'timeout': 10000,
          'reconnection': false, // We handle reconnection manually
          'query': {'userId': userId},
        });

        _setupCommonEventListeners(isDriver);
        socket?.connect();
      } catch (e) {
        logger.e('Error connecting to socket: $e');
        onSocketError?.call(e.toString());
        _isConnecting = false;
        _scheduleReconnect();
      }
    });
  }

  /// Original _setupCommonEventListeners with enhanced error handling
  void _setupCommonEventListeners(bool isDriver) {
    socket?.on('connect', (data) {
      logger.d('Connected to socket server');
      isConnected = true;
      _isConnecting = false;
      _reconnectAttempts = 0;
      onConnected?.call();
    });

    if (isDriver) {
      socket?.on(DriverEvent.driverOnlineStatus, (data) {
        logger.d(
          '---------------------------driver----------------------$data',
        );
        try {
          isDriverActive = data['data']['isOnline'];
          logger.w("-------driver active-----$isDriverActive");
          onDriverRegister?.call();
        } catch (e) {
          logger.e('Error processing driver status: $e');
        }
      });

      // Your commented code - keeping as is
      // socket?.on(DriverEvent.tripAvailableStatus, (data) {
      //   logger.d('--------------available trip------------\n$data');
      //   if (data['success'] == true) {
      //     logger.i("calling from controller");
      //     onAvailableTrip?.call(data);
      //   }
      // });
    }

    socket?.on('disconnect', (data) {
      logger.t('Disconnected from socket server');
      isConnected = false;
      _isConnecting = false;
      onDisconnected?.call();

      if (_shouldReconnect) {
        _scheduleReconnect();
      }
    });

    socket?.on('connect_error', (error) {
      logger.e('Connection error: $error');
      isConnected = false;
      _isConnecting = false;
      onSocketError?.call(error.toString());
      _scheduleReconnect();
    });

    socket?.on('error', (data) {
      logger.e('Socket error: $data');
      onSocketError?.call(data.toString());
    });

    _setupCustomEventListeners();
  }

  /// Original listenDriverOnlineStatus method - keeping exact structure
  bool listenDriverOnlineStatus() {
    bool isActive = false;

    socket?.on("online_status", (data) {
      logger.d('---------------------------driver$data');
      isConnected = true;
      onDriverRegister?.call();
      isActive = data['data']["isOnline"];
    });
    return isActive;
  }

  /// Schedule reconnection attempt
  void _scheduleReconnect() {
    if (!_shouldReconnect || _reconnectAttempts >= _maxReconnectAttempts) {
      logger.e('Max reconnection attempts reached');
      return;
    }

    _reconnectTimer?.cancel();
    final delay = _reconnectDelay * (_reconnectAttempts + 1);

    logger.i(
      'Scheduling reconnection attempt ${_reconnectAttempts + 1} in ${delay.inSeconds}s',
    );

    _reconnectTimer = Timer(delay, () {
      _attemptReconnect();
    });
  }

  /// Attempt to reconnect
  Future<void> _attemptReconnect() async {
    if (!_shouldReconnect || _isConnecting) return;

    _reconnectAttempts++;
    logger.i('Reconnection attempt $_reconnectAttempts');

    // Check internet connection before attempting reconnect
    if (!await _connectionManager.checkConnection()) {
      logger.w(
        'No internet connection, will retry when connection is restored',
      );
      return;
    }

    try {
      socket?.connect();
    } catch (e) {
      logger.e('Reconnection failed: $e');
      _scheduleReconnect();
    }
  }

  /// Original _setupCustomEventListeners - keeping exact structure
  void _setupCustomEventListeners() {
    for (var eventName in _customEventHandlers.keys) {
      _setupCustomEventListener(eventName);
    }
  }

  /// Original _setupCustomEventListener with enhanced error handling
  void _setupCustomEventListener(String eventName) {
    socket?.on(eventName, (data) {
      logger.d('Custom event [$eventName]: $data');
      final handler = _customEventHandlers[eventName];
      if (handler != null) {
        try {
          if (data is Map<String, dynamic>) {
            if (handler is Function(Map<String, dynamic>)) {
              handler(data);
            } else if (handler is Function(dynamic)) {
              handler(data);
            }
          } else if (handler is Function()) {
            handler();
          } else if (handler is Function(String)) {
            handler(data.toString());
          } else if (handler is Function(dynamic)) {
            handler(data);
          }
        } catch (e) {
          logger.e('Error handling event [$eventName]: $e');
        }
      }
    });
  }

  /// Original on method - keeping exact structure
  void on(String eventName, Function handler) {
    _customEventHandlers[eventName] = handler;
    if (isConnected && socket != null) {
      _setupCustomEventListener(eventName);
    }
  }

  /// Original off method - keeping exact structure
  void off(String eventName) {
    _customEventHandlers.remove(eventName);
    socket?.off(eventName);
  }

  /// Original emit method with enhanced connection checking
  void emit(String eventName, [dynamic data]) {
    if (!isConnected) {
      // Check if we can reconnect
      _connectionManager.quickCheck().then((hasInternet) {
        if (hasInternet && _shouldReconnect) {
          logger.w(
            'Socket disconnected but internet available, attempting reconnect...',
          );
          _attemptReconnect();
        }
      });
      logger.e('Socket not connected');
      return;
    }

    socket?.emit(eventName, data);
    logger.d('Emitted [$eventName] with data: $data');

    // Your original debug code - keeping as is
    if (kDebugMode) {
      // showCustomSnackbar(
      //   position: SnackPosition.TOP,
      //   title: eventName.toString(),
      //   message: data.toString(),
      // );
    }
  }

  /// Original disconnect method - keeping exact structure
  void disconnect() {
    _shouldReconnect = false;
    _reconnectTimer?.cancel();

    if (socket != null) {
      socket?.disconnect();
      socket?.dispose();
      socket = null;
    }
    isConnected = false;
    _isConnecting = false;
    _reconnectAttempts = 0;
    _customEventHandlers.clear();
  }

  /// Original clearCustomEventHandlers method - keeping exact structure
  void clearCustomEventHandlers() {
    for (var eventName in _customEventHandlers.keys) {
      socket?.off(eventName);
    }
    _customEventHandlers.clear();
  }

  /// Original getRegisteredEvents method - keeping exact structure
  List<String> getRegisteredEvents() {
    return _customEventHandlers.keys.toList();
  }

  /// Additional helper methods for connection management
  bool get hasInternet => _connectionManager.isConnected;

  Map<String, dynamic> getConnectionInfo() {
    return {
      'isConnected': isConnected,
      'isConnecting': _isConnecting,
      'shouldReconnect': _shouldReconnect,
      'reconnectAttempts': _reconnectAttempts,
      'isDriverActive': isDriverActive,
      'hasInternet': _connectionManager.isConnected,
    };
  }
}

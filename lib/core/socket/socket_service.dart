import 'package:e_hailing_app/core/api-client/api_service.dart';
import 'package:e_hailing_app/core/utils/enum.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();

  factory SocketService() => _instance;

  SocketService._internal();

  IO.Socket? _socket;
  bool isConnected = false;

  Function(String)? onSocketError;
  Function()? onConnected;
  Function()? onDisconnected;
  final Map<String, Function> _customEventHandlers = {};

  void connect(String userId) {
    if (isConnected) {
      logger.d('Socket already connected');
      return;
    }
    try {
      _socket = IO.io(ApiService().baseUrl, <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
        'query': {'userId': userId},
      });

      _setupCommonEventListeners();
      _socket?.connect();
    } catch (e) {
      logger.e('Error connecting to socket: $e');
      onSocketError?.call(e.toString());
    }
  }

  void _setupCommonEventListeners() {
    _socket?.on(DefaultSocketEvent.connect.value, (data) {
      logger.d('Connected to socket server');
      isConnected = true;
      onConnected?.call();
    });

    _socket?.on(DefaultSocketEvent.disconnect.value, (data) {
      logger.d('Disconnected from socket server');
      isConnected = false;
      onDisconnected?.call();
    });

    _socket?.on(DefaultSocketEvent.connectError.value, (error) {
      logger.e('Connection error: $error');
      onSocketError?.call(error.toString());
    });

    _socket?.on(DefaultSocketEvent.socketError.value, (data) {
      logger.e('Socket error: $data');
      onSocketError?.call(data.toString());
    });

    _setupCustomEventListeners();
  }

  void _setupCustomEventListeners() {
    for (var eventName in _customEventHandlers.keys) {
      _setupCustomEventListener(eventName);
    }
  }

  void _setupCustomEventListener(String eventName) {
    _socket?.on(eventName, (data) {
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

  void on(String eventName, Function handler) {
    _customEventHandlers[eventName] = handler;
    if (isConnected && _socket != null) {
      _setupCustomEventListener(eventName);
    }
  }

  void off(String eventName) {
    _customEventHandlers.remove(eventName);
    _socket?.off(eventName);
  }

  void emit(String eventName, [dynamic data]) {
    if (!isConnected) {
      logger.e('Socket not connected');
      return;
    }
    _socket?.emit(eventName, data);
    logger.d('Emitted [$eventName] with data: $data');
  }

  void disconnect() {
    if (_socket != null) {
      _socket?.disconnect();
      _socket?.dispose();
      _socket = null;
    }
    isConnected = false;
    _customEventHandlers.clear();
  }

  void clearCustomEventHandlers() {
    for (var eventName in _customEventHandlers.keys) {
      _socket?.off(eventName);
    }
    _customEventHandlers.clear();
  }

  List<String> getRegisteredEvents() {
    return _customEventHandlers.keys.toList();
  }
}

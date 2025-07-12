import 'package:e_hailing_app/core/api-client/api_service.dart';
import 'package:e_hailing_app/core/service/socket-service/socket_events_variable.dart';
import 'package:e_hailing_app/core/utils/enum.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();

  factory SocketService() => _instance;

  SocketService._internal();

  IO.Socket? socket;
  bool isConnected = false;
  bool isDriverActive = false;

  Function(String)? onSocketError;
  Function()? onConnected;

  Function()? onDriverRegister;
  Function()? onDisconnected;
  Function(Map<String, dynamic>)? onAvailableTrip;
  final Map<String, Function> _customEventHandlers = {};

  void connect(String userId, bool isDriver) {
    if (isConnected) {
      logger.d('Socket already connected');
      return;
    }
    try {
      socket = IO.io(ApiService().baseUrl, <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
        'query': {'userId': userId},
      });
      _setupCommonEventListeners(isDriver);
      socket?.connect();
    } catch (e) {
      logger.e('Error connecting to socket: $e');
      onSocketError?.call(e.toString());
    }
  }

  void _setupCommonEventListeners(bool isDriver) {
    socket?.on(DefaultSocketEvent.connect.value, (data) {
      logger.d('Connected to socket server');
      isConnected = true;
      onConnected?.call();
    });
    if (isDriver) {
      socket?.on(DriverEvent.driverOnlineStatus, (data) {
        logger.d(
          '---------------------------driver----------------------$data',
        );

        isDriverActive = data['data']['isOnline'];
        logger.w("-------driver active-----$isDriverActive");
        onDriverRegister?.call();
      });
      // socket?.on(DriverEvent.tripAvailableStatus, (data) {
      //   logger.d('--------------available trip------------\n$data');
      //   if (data['success'] == true) {
      //     logger.i("calling from controller");
      //
      //     onAvailableTrip?.call(data);
      //   }
      // });
    }
    socket?.on(DefaultSocketEvent.disconnect.value, (data) {
      logger.t('Disconnected from socket server');
      isConnected = false;
      onDisconnected?.call();
    });

    socket?.on(DefaultSocketEvent.connectError.value, (error) {
      logger.e('Connection error: $error');
      onSocketError?.call(error.toString());
    });

    socket?.on(DefaultSocketEvent.socketError.value, (data) {
      logger.e('Socket error: $data');
      onSocketError?.call(data.toString());
    });

    _setupCustomEventListeners();
  }

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

  void _setupCustomEventListeners() {
    for (var eventName in _customEventHandlers.keys) {
      _setupCustomEventListener(eventName);
    }
  }

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

  void on(String eventName, Function handler) {
    _customEventHandlers[eventName] = handler;
    if (isConnected && socket != null) {
      _setupCustomEventListener(eventName);
    }
  }

  void off(String eventName) {
    _customEventHandlers.remove(eventName);
    socket?.off(eventName);
  }

  void emit(String eventName, [dynamic data]) {
    if (!isConnected) {
      logger.e('Socket not connected');
      return;
    }
    socket?.emit(eventName, data);
    logger.d('Emitted [$eventName] with data: $data');
    if (kDebugMode) {
      // showCustomSnackbar(
      //   position: SnackPosition.TOP,
      //   title: eventName.toString(),
      //   message: data.toString(),
      // );
    }
  }

  void disconnect() {
    if (socket != null) {
      socket?.disconnect();
      socket?.dispose();
      socket = null;
    }
    isConnected = false;
    _customEventHandlers.clear();
  }

  void clearCustomEventHandlers() {
    for (var eventName in _customEventHandlers.keys) {
      socket?.off(eventName);
    }
    _customEventHandlers.clear();
  }

  List<String> getRegisteredEvents() {
    return _customEventHandlers.keys.toList();
  }
}

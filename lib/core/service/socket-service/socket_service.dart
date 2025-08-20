import 'dart:ui';

import 'package:e_hailing_app/core/api-client/api_service.dart';
import 'package:e_hailing_app/core/service/socket-service/socket_events_variable.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/driver-dashboard/controllers/dashboard_controller.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;

  SocketService._internal();

  IO.Socket? socket;
  VoidCallback? onConnected;
  VoidCallback? onDisconnected;
  void connect(String userId, bool isDriver) {
    if (socket != null) {
      try {
        socket!.clearListeners();
        socket!.disconnect();
        socket!.destroy();
      } catch (e) {
        logger.d('Error while cleaning old socket: $e');
      }
      socket = null;
      logger.d('🔥 Old socket destroyed');
    }
    final Map<String, dynamic> options = {
      'transports': ['websocket'],
      'autoConnect': true,       // Equivalent to .disableAutoConnect()
      'query': {'userId': userId},
      'forceNew': true,           // 👈 THE FIX: Pass 'forceNew' as a key in the map
    };
    socket = IO.io(
     ApiService().baseUrl,
options
    );

    socket!.connect();

    socket!.once('connect', (_) {
      logger.d('✅ Connected to socket with userId: ${socket?.io.uri}');
      logger.d('✅ Connected to socket with userId: ${socket?.io.options?['query']}');
      if (onConnected != null) onConnected!();

    });

    socket!.once('disconnect', (_) {
      logger.d('❌ Disconnected from socket');
      if (onDisconnected != null) onDisconnected!();

    });

    if (isDriver) {
      socket?.on(DriverEvent.driverOnlineStatus, (data) {
        logger.d(
          '---------------------------driver----------------------$data',
        );
        try {
          // isDriverActive = data['data']['isOnline'];
          logger.w("-------driver active-----${data['data']['isOnline']}");
          DashBoardController.to.isDriverActive.value=data['data']['isOnline'];
          // onDriverRegister?.call();
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
  }
  void emit(String event, dynamic data) {
    if (socket != null && socket!.connected) {
      socket!.emit(event, data);
    } else {
      logger.d('⚠️ Cannot emit, socket not connected');
    }
  }

  void on(String event, Function(dynamic) handler) {
    socket?.on(event, handler);
  }

  void off(String event) {
    socket?.off(event);
  }
  void disconnect() {
    if (socket != null) {
      try {
        socket!.clearListeners();
        socket!.disconnect();
        socket!.destroy();
      } catch (e) {
        logger.d('Error while disconnecting: $e');
      }
      socket = null;
      logger.d('❌ Disconnected from socket server');
    }
  }
}

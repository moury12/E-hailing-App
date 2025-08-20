import 'dart:ui';

import 'package:e_hailing_app/core/api-client/api_service.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
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

    socket = IO.io(
      ApiService().baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setQuery({'userId': userId})
          .disableAutoConnect()
          .build(),
    );

    socket!.connect();

    socket!.once('connect', (_) {
      logger.d('✅ Connected to socket with userId: ${socket?.io.uri}');
      if (onConnected != null) onConnected!();

    });

    socket!.once('disconnect', (_) {
      logger.d('❌ Disconnected from socket');
      if (onDisconnected != null) onDisconnected!();

    });


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

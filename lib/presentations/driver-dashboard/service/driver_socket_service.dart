import 'package:e_hailing_app/core/api-client/api_service.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class DriverSocketService {
  static final DriverSocketService _instance = DriverSocketService._internal();

  factory DriverSocketService() => _instance;

  DriverSocketService._internal();

  IO.Socket? socket;
  bool isConnected = false;
  Function()? onlineStatus;
  Function(String)? onSocketError;
  Function()? onConnected;
  Function()? onDisconnected;

  void connect(String userId) {
    try {
      socket = IO.io(ApiService().baseUrl, <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
        'query': {'userId': userId},
      });
      socket?.connect();
      socket?.on("connect", (data) {
        logger.d('Connected to socket server');
        isConnected = true;
        onConnected?.call();
      });
      socket?.on("disconnect", (data) {
        logger.d('disConnected to socket server');
        isConnected = false;
        onDisconnected?.call();
      });
      socket?.on('connect_error', (error) {
        logger.d('Connection error: $error');
        onSocketError?.call(error.toString());
      });
      socket?.on('online_status', (data) {
        logger.d('online_status: $data');
        if (data is Map<String, dynamic>) {
          onlineStatus?.call();
        }
      });
    } catch (e) {
      logger.e('Error connecting to socket: $e');
    }
  }
}

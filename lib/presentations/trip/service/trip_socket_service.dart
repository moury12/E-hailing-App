import 'package:e_hailing_app/core/api-client/api_service.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class TripSocketService {
  static final TripSocketService _instance = TripSocketService._internal();

  factory TripSocketService() => _instance;

  TripSocketService._internal();

  IO.Socket? _socket;
  bool _isConnected = false;
  Function(Map<String, dynamic>)? onTripRequested;
  Function(String)? onSocketError;
  Function()? onConnected;
  Function()? onDisconnected;

  void connect(String userId) {
    try {
      _socket = IO.io(ApiService().baseUrl, <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
        'query': {'userId': userId},
      });
      _socket?.connect();
      _socket?.on("connect", (data) {
        logger.d('Connected to socket server');
        _isConnected = true;
        onConnected?.call();
      });
      _socket?.on("disconnect", (data) {
        logger.d('disConnected to socket server');
        _isConnected = false;
        onDisconnected?.call();
      });
      _socket?.on('connect_error', (error) {
        logger.d('Connection error: $error');
        onSocketError?.call(error.toString());
      });
      // Trip-related events
      _socket?.on('trip_requested', (data) {
        logger.d('Trip requested: $data');
        if (data is Map<String, dynamic>) {
          onTripRequested?.call(data);
        }
      });
    } catch (e) {}
  }
}

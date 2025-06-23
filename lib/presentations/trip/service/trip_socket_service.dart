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
  Function(Map<String, dynamic>)? onTripNoDriverFound;
  Function(Map<String, dynamic>)? onTripAccepted;
  Function(Map<String, dynamic>)? onTripDriverLocationUpdate;
  Function(Map<String, dynamic>)? onTripUpdateStatus;
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
      _socket?.on('trip_no_driver_found', (data) {
        logger.d('No driver found: $data');
        if (data is Map<String, dynamic>) {
          onTripNoDriverFound?.call(data);
        }
      });
      _socket?.on('trip_accepted', (data) {
        logger.d('Trip accepted: $data');
        if (data is Map<String, dynamic>) {
          onTripAccepted?.call(data);
        }
      });
      _socket?.on('trip_driver_location_update', (data) {
        logger.d('Driver location update: $data');
        if (data is Map<String, dynamic>) {
          onTripDriverLocationUpdate?.call(data);
        }
      });

      _socket?.on('trip_update_status', (data) {
        logger.d('Trip status update: $data');
        if (data is Map<String, dynamic>) {
          onTripUpdateStatus?.call(data);
        }
      });
      _socket?.on('socket_error', (data) {
        logger.d('Socket error: $data');
        onSocketError?.call(data.toString());
      });
    } catch (e) {
      logger.e('Error connecting to socket: $e');
    }
  }

  void requestTrip({required Map<String, dynamic> body}) {
    if (!_isConnected) {
      logger.e('Socket not connected');
      return;
    }
    final tripData = body;
    _socket?.emit("trip_requested", tripData);
    logger.d('Trip requested with data: $tripData');
  }

  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _isConnected = false;
  }

  bool get isConnected => _isConnected;
}

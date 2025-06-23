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

  void requestTrip({
    required String pickupAddress,
    required double pickupLat,
    required double pickupLong,
    required String dropOffAddress,
    required double dropOffLat,
    required double dropOffLong,
    required int duration,
    required int distance,
    String? coupon,
  }) {
    if (!_isConnected) {
      logger.e('Socket not connected');
      return;
    }
    final tripData = {
      'pickupAddress': pickupAddress,
      'pickupLat': pickupLat,
      'pickupLong': pickupLong,
      'dropOffAddress': dropOffAddress,
      'dropOffLat': dropOffLat,
      'dropOffLong': dropOffLong,
      'duration': duration,
      'distance': distance,
      if (coupon != null && coupon.isNotEmpty) 'coupon': coupon,
    };
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

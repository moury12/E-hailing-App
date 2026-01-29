class TripEvents {
  static const String tripRequested = 'trip_requested';
  static const String tripNoDriverFound = 'trip_no_driver_found';
  static const String tripAccepted = 'trip_accepted';
  static const String tripDriverLocationUpdate = 'trip_driver_location_update';
  static const String tripUpdateStatus = 'trip_update_status';
  static const String tripCancelled = 'trip_cancelled';
  static const String tripCompleted = 'trip_completed';
}

class PaymentEvent {
  static const String paymentPaid = 'payment_paid';
  static const String paymentReceived = 'payment_received';
}

class DriverEvent {
  static const String driverOnlineStatus = 'online_status';
  static const String driverLocationUpdate = 'trip_driver_location_update';
  static const String updateLocation = 'update_location';
  static const String tripAvailableStatus = 'trip_available';
  static const String tripAcceptedStatus = 'trip_accepted';
  static const String tripUpdateStatus = 'trip_update_status';
}

class ChatEvent {
  static const String startChat = 'start-chat';
  static const String error = 'error';
  static const String sendMessage = 'send_message';
  static const String onlineStatus = 'online_status';
}

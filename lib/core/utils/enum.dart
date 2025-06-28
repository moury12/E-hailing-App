enum AuthProcess {
  signUp,
  login,
  logout,
  activateAccount,
  forgetPassword,
  resetPassword,
  verifyOtp,
  packageGet,
  none,
}

enum DefaultSocketEvent {
  connect('connect'),
  disconnect('disconnect'),
  connectError('connect_error'),
  socketError('socket_error');

  const DefaultSocketEvent(this.value);

  final String value;
}

enum RideState {
  findingRide,
  rideRequest,
  pickup,
  arrived,
  tripStarted,
  tripEnd,
  paymentRequest,
}

enum TripStateDriver {
  requested,
  accepted,
  on_the_way,
  arrived,
  picked_up,
  started,
  completed,
  cancelled,
}

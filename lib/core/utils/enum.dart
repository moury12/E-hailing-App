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

enum RideFlowState {
  findingRide,
  rideRequest,
  pickup,
  isArrived,
  isTripStarted,
  isTripEnd,
  destinationReached,
  arrive,
}

enum DriverTripStatus {
  requested,
  accepted,
  on_the_way,
  arrived,
  picked_up,
  completed,
  started,
  destination_reached,
  cancelled,
}

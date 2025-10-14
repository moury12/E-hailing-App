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
enum NrcVerificationStatus {
  unverified,
  submitted,
  accepted,
  rejected;

  // Parse from API string to enum
  static NrcVerificationStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'submitted':
        return NrcVerificationStatus.submitted;
      case 'accepted':
        return NrcVerificationStatus.accepted;
      case 'rejected':
        return NrcVerificationStatus.rejected;
      case 'unverified':
      default:
        return NrcVerificationStatus.unverified;
    }
  }

  // Convert back to string (if needed)
  String get name {
    switch (this) {
      case NrcVerificationStatus.submitted:
        return 'submitted';
      case NrcVerificationStatus.accepted:
        return 'accepted';
      case NrcVerificationStatus.rejected:
        return 'rejected';
      case NrcVerificationStatus.unverified:
        return 'unverified';
    }
  }
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

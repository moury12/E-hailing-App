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

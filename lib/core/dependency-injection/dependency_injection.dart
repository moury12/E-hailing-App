import 'package:e_hailing_app/core/service/socket-service/socket_service.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupDependencyInjection() async {
  getIt.registerLazySingleton<SocketService>(() => SocketService());

  // You can register other services here as needed
}

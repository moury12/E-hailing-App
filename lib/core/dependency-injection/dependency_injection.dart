import 'package:get_it/get_it.dart';
import '../socket/socket_service.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupDependencyInjection() async {
  getIt.registerLazySingleton<SocketService>(() => SocketService());

  // You can register other services here as needed
}

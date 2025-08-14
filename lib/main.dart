import 'package:e_hailing_app/core/dependency-injection/dependency_injection.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/firebase_options.dart';
import 'package:e_hailing_app/presentations/splash/views/splash_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/bindings/bindings.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

}
String? fcmToken;
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessaging.instance.requestPermission();
  fcmToken = await FirebaseMessaging.instance.getToken();
  logger.i("-------------fcm token----------------$fcmToken");
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await initLocalNotification();
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel', // Channel ID
            'High Importance Notifications', // Channel name
            channelDescription: 'This channel is used for important notifications.',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker',
          ),
        ),
        payload: message.data['payload'], // Optional: pass custom data
      );
    }
  });



  setupDependencyInjection();
  await Hive.initFlutter();
  await Hive.openBox(userRole);
  await Hive.openBox(userBoxName);
  await Hive.openBox(authBox);

  await ScreenUtil.ensureScreenSize();
  runApp(
    /* DevicePreview(enabled: !kReleaseMode, builder: (context) =>*/
    const MyApp() /*),*/,
  );
}
Future<void> initLocalNotification() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher'); // Your app icon

  const DarwinInitializationSettings initializationSettingsIOS =
  DarwinInitializationSettings(
    requestSoundPermission: true,
    requestBadgePermission: true,
    requestAlertPermission: true,
  );

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      // Handle notification tapped logic here
      logger.i('Notification Tapped: ${response.payload}');
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 888),
      minTextAdapt: true,
      // useInheritedMediaQuery: true,
      builder: (context, child) => GetMaterialApp(
            title: 'Dudu Car',
            theme: AppTheme.lightTheme,
            themeMode: ThemeMode.dark,
            initialRoute: SplashPage.routeName,
            getPages: AppRoutes.route(),
            initialBinding: CommonBinding(),
            debugShowCheckedModeBanner: false,
          ),
    );
  }
}

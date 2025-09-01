import 'dart:io';

import 'package:e_hailing_app/core/service/notification-service/notification_service.dart';
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


Future<void> _initLocalNotifs() async {
  const DarwinInitializationSettings iosInit = DarwinInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
  );

  const InitializationSettings initSettings =
  InitializationSettings(iOS: iosInit);

  await flutterLocalNotificationsPlugin.initialize(initSettings);
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await _initLocalNotifs();



  // iOS foreground presentation (CRITICAL FOR YOUR ISSUE)
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  // Handle messages when app is in foreground
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {

    if (message.notification == null && Platform.isIOS) {
      await flutterLocalNotificationsPlugin.show(
        message.hashCode,
        message.data['title'] ?? 'Notification',
        message.data['body'] ?? '',
        const NotificationDetails(
          iOS: DarwinNotificationDetails(presentAlert: true, presentSound: true, presentBadge: true),
        ),
        payload: message.data['payload'],
      );
    }});
  await FirebaseMessaging.instance.requestPermission(  alert: true,
    badge: true,
    sound: true,);
  fcmToken = await FirebaseMessaging.instance.getToken();
  logger.i("-------------fcm token----------------$fcmToken");
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await NotificationService.instance.init();
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  // Show foreground notifications
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  await Hive.initFlutter();
  await Hive.openBox(userRole);
  await Hive.openBox(userBoxName);
  await Hive.openBox(authBox);
  await Hive.openBox("ratingData");

  await ScreenUtil.ensureScreenSize();
  runApp(
    /* DevicePreview(enabled: !kReleaseMode, builder: (context) =>*/
    const MyApp() /*),*/,
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

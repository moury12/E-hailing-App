import 'dart:io';

import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/firebase_options.dart';
import 'package:e_hailing_app/presentations/splash/views/splash_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
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

Future<void> initFCM() async {
  try {
    // Request permission first (critical on iOS)
    NotificationSettings settings =
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      // Only now get the token
      fcmToken = await FirebaseMessaging.instance.getToken();
      logger.i("-------------fcm token----------------$fcmToken");
    } else {
      logger.w("User declined notification permissions");
    }
  } catch (e) {
    print("Error getting FCM token: $e");
  }
}

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Keep splash visible during async setup
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await _initLocalNotifs();
    await initFCM();

    // iOS foreground notification options
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    await Hive.initFlutter();
    await Hive.openBox(userRole);
    await Hive.openBox(userBoxName);
    await Hive.openBox(authBox);
    await Hive.openBox("ratingData");

    await ScreenUtil.ensureScreenSize();
  } catch (e) {
    print("Initialization error: $e");
  } finally {
    // MUST remove splash screen
    FlutterNativeSplash.remove();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 888),
      minTextAdapt: true,
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

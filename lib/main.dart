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



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(
    widgetsBinding: WidgetsFlutterBinding.ensureInitialized(),
  );

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    await Hive.initFlutter();
  Future.wait([
   Hive.openBox(userRole),
     Hive.openBox(userBoxName),
     Hive.openBox(authBox),
     Hive.openBox("ratingData"),
  ]);

    await ScreenUtil.ensureScreenSize();
  } catch (e) {
    print("Initialization error: $e");
  } finally {

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
        initialBinding: SplashBinding(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

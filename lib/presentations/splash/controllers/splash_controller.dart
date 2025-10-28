import 'package:e_hailing_app/core/constants/hive_boxes.dart';
import 'package:e_hailing_app/core/service/internet_service.dart';
import 'package:e_hailing_app/core/service/location-service/location_service.dart';
import 'package:e_hailing_app/core/service/notification-service/notification_service.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/main.dart';
import 'package:e_hailing_app/presentations/auth/views/login_page.dart';
import 'package:e_hailing_app/presentations/navigation/views/navigation_page.dart';
import 'package:e_hailing_app/presentations/splash/views/no_internet_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';


class SplashController extends GetxController {
  static SplashController get to => Get.find();
  final locationService = LocationTrackingService();

  @override
  void onInit() {
    _initSplashLogic();
    super.onInit();
  }
  Future<void> _initLocalNotifs() async {
    const DarwinInitializationSettings iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,

    );
    const AndroidInitializationSettings androidInit =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings =
    InitializationSettings(iOS: iosInit,android: androidInit, );

    await flutterLocalNotificationsPlugin.initialize(initSettings);
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // name
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      // sound: RawResourceAndroidNotificationSound('notification'), // from res/raw/notification.mp3
    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
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
      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true, // ✅ this enables sound
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
  Future<void> _initSplashLogic() async {
    FlutterNativeSplash.remove();
    await _initLocalNotifs();

    // Request FCM + permissions
    await initFCM();

await NotificationService.instance.init();
await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    if(Boxes.getUserData().get(tokenKey)==null){

      await locationService.handleLocationPermission();
   }   // Check internet
    bool hasInternet = await ConnectionManager().checkConnection();
    if (!hasInternet) {
      Get.offAll(() => const NoInternetPage());
      return;
    }


    if (Boxes.getUserData().get(tokenKey)?.toString().isNotEmpty ?? false) {
      Get.offAllNamed(
        NavigationPage.routeName,
        arguments: {'reconnectSocket': true},
      );
    } else {
      Get.offAllNamed(LoginPage.routeName);
    }
  }
}

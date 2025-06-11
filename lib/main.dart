 import 'package:device_preview/device_preview.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/splash/views/splash_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/bindings/bindings.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox(userRole);
  await Hive.openBox(userBoxName);
  await Hive.openBox(authBox);

  await ScreenUtil.ensureScreenSize();
  runApp(DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) =>const MyApp()));
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
        title: 'E-hailing',
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



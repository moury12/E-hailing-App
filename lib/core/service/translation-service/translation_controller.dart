import 'dart:convert';
import 'dart:ui';
import 'package:e_hailing_app/core/constants/hive_boxes.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class TranslationController extends GetxController implements Translations {
  RxMap<String, Map<String, String>> translations =
      <String, Map<String, String>>{}.obs;
  RxBool isLoading = true.obs;
  Rx<Locale> appLocale = const Locale('en', 'US').obs;

  // Hive box name for storing language preference
  static const String _languageKey = 'selectedLanguage';

  @override
  void onInit() {
    super.onInit();
    loadTranslations();
    loadSavedLocale();
  }

  Future<void> loadTranslations() async {
    try {
      final enJson = await rootBundle.loadString('assets/lang/en.json');
      final msJson = await rootBundle.loadString('assets/lang/ms.json');
      final zhJson = await rootBundle.loadString('assets/lang/zh.json');

      translations.value = {
        'en_US': Map<String, String>.from(json.decode(enJson)),
        'ms_MY': Map<String, String>.from(json.decode(msJson)),
        'zh_CN': Map<String, String>.from(json.decode(zhJson)),
      };

      isLoading.value = false;
      update();
    } catch (e) {
      print('Error loading translations: $e');
      isLoading.value = false;
    }
  }

  // Save selected language to Hive
  Future<void> changeLanguage(String languageCode, String countryCode) async {
    final locale = Locale(languageCode, countryCode);
    appLocale.value = locale;
    await Boxes.getLanguage().put(_languageKey, '${languageCode}_$countryCode');
    Get.updateLocale(locale);
  }

  Future<void> loadSavedLocale() async {
    final savedLanguage = Boxes.getLanguage().get(
      _languageKey,
      defaultValue: 'en_US',
    );
    final parts = savedLanguage.split('_');
    appLocale.value = Locale(parts[0], parts[1]);
  }

  // Get saved language from Hive
  static Future<Locale> getSavedLanguage() async {
    try {
      final savedLanguage =
          Boxes.getLanguage().get(_languageKey, defaultValue: 'en_US')
              as String;
      logger.d('--------------------${savedLanguage}');
      final parts = savedLanguage.split('_');
      return Locale(parts[0], parts[1]);
    } catch (e) {
      print('Error getting saved language: $e');
      return const Locale('en', 'US'); // Default fallback
    }
  }

  @override
  Map<String, Map<String, String>> get keys => translations.value;
}

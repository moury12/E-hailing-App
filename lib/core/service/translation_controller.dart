import 'dart:convert';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TranslationController extends GetxController implements Translations {
  RxMap<String, Map<String, String>> translations = <String, Map<String, String>>{}.obs;
  RxBool isLoading = true.obs;

  // Hive box name for storing language preference
  static const String _languageBoxName = 'languageBox';
  static const String _languageKey = 'selectedLanguage';

  @override
  void onInit() {
    super.onInit();
    loadTranslations();
  }

  Future<void> loadTranslations() async {
    try {
      final enJson = await rootBundle.loadString('assets/lang/en.json');
      final msJson = await rootBundle.loadString('assets/lang/ms.json');

      translations.value = {
        'en_US': Map<String, String>.from(json.decode(enJson)),
        'ms_MY': Map<String, String>.from(json.decode(msJson)),
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
    Get.updateLocale(locale);

    // Save to Hive
    final box = await Hive.openBox(_languageBoxName);
    await box.put(_languageKey, '${languageCode}_$countryCode');

    update();
  }

  // Get saved language from Hive
  static Future<Locale> getSavedLanguage() async {
    try {
      final box = await Hive.openBox(_languageBoxName);
      final savedLanguage = box.get(_languageKey, defaultValue: 'en_US') as String;

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

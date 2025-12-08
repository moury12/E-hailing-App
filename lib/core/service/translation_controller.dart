import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class TranslationController extends GetxController implements Translations {
  RxMap<String, Map<String, String>> translations = <String, Map<String, String>>{}.obs;
  RxBool isLoading = true.obs;

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
      update(); // Force GetX to update
    } catch (e) {
      print('Error loading translations: $e');
      isLoading.value = false;
    }
  }

  @override
  Map<String, Map<String, String>> get keys => translations.value;
}


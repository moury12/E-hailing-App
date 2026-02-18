import 'dart:convert';

import 'package:e_hailing_app/core/utils/google_map_api_key.dart';
import 'package:http/http.dart' as http;

class TranslationService {
  final String apiKey = GoogleClient.googleMapUrl; // Add your API Key here

  // Function to translate text using Google Translate API

  Future<String> translate(String text, String targetLanguage) async {
    final url = Uri.parse(
      'https://translation.googleapis.com/language/translate/v2?key=$apiKey',
    );

    final response = await http.post(
      url,
      body: {'q': text, 'target': targetLanguage},
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      return data['data']['translations'][0]['translatedText'];
    } else {
      throw Exception('Failed to translate text');
    }
  }
}

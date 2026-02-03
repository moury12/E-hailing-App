import 'dart:convert';

import 'package:http/http.dart' as http;

class TranslationService {
  final String apiKey = String.fromEnvironment(
    'MAPS_API_KEY',
  ); // Add your API Key here

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

import 'package:e_hailing_app/core/service/translation-service/translation_service.dart';
import 'package:flutter/material.dart';

class TranslationTestScreen extends StatefulWidget {
  @override
  _TranslationTestScreenState createState() => _TranslationTestScreenState();
}

class _TranslationTestScreenState extends State<TranslationTestScreen> {
  final TranslationService _translationService = TranslationService();
  String _translatedText = '';
  String _inputText = 'tumi kemon aso?';

  void _translateText() async {
    try {
      // Translating to Spanish (es)
      String translated = await _translationService.translate(_inputText, 'es');
      setState(() {
        _translatedText = translated;
      });
    } catch (e) {
      setState(() {
        _translatedText = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Google Translate Test")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Original Text:'),
            SizedBox(height: 10),
            Text(_inputText, style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _translateText,
              child: Text('Translate to Spanish'),
            ),
            SizedBox(height: 20),
            Text('Translated Text:'),
            SizedBox(height: 10),
            Text(
              _translatedText,
              style: TextStyle(fontSize: 20, color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}

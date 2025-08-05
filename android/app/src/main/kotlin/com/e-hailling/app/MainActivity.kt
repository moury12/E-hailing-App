package com.e-hailling.app

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Note: Flutter doesn't have Log.setMinimumLoggingLevel
        // The console messages are from native Android, not Flutter
    }
}

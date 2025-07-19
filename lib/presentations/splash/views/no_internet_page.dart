import 'package:e_hailing_app/core/service/internet_service.dart';
import 'package:e_hailing_app/presentations/splash/views/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoInternetPage extends StatelessWidget {
  const NoInternetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off, size: 80, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              "No Internet Connection",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final connected = await ConnectionManager().checkConnection();
                if (connected) {
                  Get.offAllNamed(SplashPage.routeName); // restart splash
                }
              },
              child: const Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }
}

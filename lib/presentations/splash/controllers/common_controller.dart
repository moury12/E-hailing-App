import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class CommonController extends GetxController{
static CommonController get to =>Get.find();
@override
  void onInit() {
    requestLocationPermission();
    super.onInit();
  }
Future<void> requestLocationPermission() async {
  var status = await Permission.location.request();
  if (status.isGranted) {
    debugPrint("Location permission granted.");
  } else {
    debugPrint("Location permission denied.");
  }
}
}
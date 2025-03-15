import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyRideController extends GetxController {
  static MyRideController get to => Get.find();
  RxList<String> tabLabels =
      [
        AppStaticStrings.ongoing,
        AppStaticStrings.upcoming,
        AppStaticStrings.completed,
      ].obs;
  var tabContent = <Widget>[].obs;
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_static_strings_constant.dart';

class DriverSettingsController extends GetxController{
  static DriverSettingsController get to =>Get.find();
  RxList<String> tabLabels =
      [
        AppStaticStrings.general,
        AppStaticStrings.licensePlate,

      ].obs;
  var tabContent = <Widget>[].obs;
}
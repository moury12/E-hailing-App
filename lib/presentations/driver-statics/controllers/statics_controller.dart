import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_static_strings_constant.dart';

class StaticsController extends GetxController{
  static StaticsController get to => Get.find();
  RxList<String> tabLabels =
      [
        AppStaticStrings.today,
        AppStaticStrings.thisWeek,
        AppStaticStrings.thisMonth,
      ].obs;
  var tabContent = <Widget>[].obs;
}
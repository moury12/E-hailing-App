import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_static_strings_constant.dart';

class MessageController extends GetxController{
  static MessageController get to => Get.find();
  RxList<String> tabLabels =
      [
        AppStaticStrings.allMessages,
        AppStaticStrings.newMessages,

      ].obs;
  var tabContent = <Widget>[].obs;
}
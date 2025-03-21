import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AccountInformationController extends GetxController{
  static AccountInformationController get to => Get.find();
  RxList<String> tabs =[
    AppStaticStrings.general,
    AppStaticStrings.driving,
    AppStaticStrings.document,
  ].obs;
  var tabContent = <Widget>[].obs;
}
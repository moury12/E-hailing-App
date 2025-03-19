
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SaveLocationController extends GetxController{
  static SaveLocationController get to => Get.find();
  Rx<TextEditingController> searchFieldController = TextEditingController().obs;
  RxString lat = ''.obs;
  RxString lng = ''.obs;
  RxString selectedAddress = ''.obs;
}
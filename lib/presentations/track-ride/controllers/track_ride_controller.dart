import 'package:get/get.dart';

class TrackRideController extends GetxController{
  static TrackRideController get to => Get.find();
  RxBool isDestination = false.obs;

}
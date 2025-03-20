import 'package:get/get.dart';

class DashBoardController extends GetxController{
  static DashBoardController get to => Get.find();
  RxBool findingRide= true.obs;
  RxBool rideRequest= false.obs;
  RxBool acceptRideRequest= false.obs;
  RxBool isPreBookRequest = false.obs;
  RxBool pickup = false.obs;
  RxBool arrive = false.obs;
  RxBool isTripStarted = false.obs;
  RxBool isTripEnd = false.obs;
  RxBool isArrived = false.obs;

}
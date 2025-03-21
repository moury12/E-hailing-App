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
  bool handleBackNavigation() {
    if (arrive.value) {
      // From payment request back to trip end
      arrive.value = false;
      isTripEnd.value = true;
      return false;
    }
    else if (isTripEnd.value) {
      // From trip end back to trip started
      isTripEnd.value = false;
      isTripStarted.value = true;
      return false;
    }
    else if (isTripStarted.value) {
      // From trip started back to pickup started
      isTripStarted.value = false;
      isArrived.value = true;
      return false;
    }
    else if (isArrived.value) {
      // From pickup started back to pickup
      isArrived.value = false;
      pickup.value = true;
      return false;
    }
    else if (pickup.value) {
      // From pickup back to ride request
      pickup.value = false;
      rideRequest.value = true;
      return false;
    }
    else if (rideRequest.value) {
      // From ride request back to finding ride
      rideRequest.value = false;
      findingRide.value = true;
      return false;
    }
    else if (findingRide.value) {
      return false;
    }

    // Default case: allow the back navigation to occur normally
    return true;
  }
  void resetRideFlow(DashBoardController controller) {
    // Reset all flow states to their default values
    findingRide.value = false;
    rideRequest.value = false;
    pickup.value = false;
    isArrived.value = false;
    isTripStarted.value = false;
    isTripEnd.value = false;
    arrive.value = false;


  }
}


import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/image_constant.dart';
import 'package:e_hailing_app/presentations/navigation/model/navigation_model.dart';
import 'package:e_hailing_app/presentations/splash/controllers/common_controller.dart';
import 'package:e_hailing_app/presentations/trip/model/trip_cancellation_model.dart';
import 'package:get/get.dart';



String dummyProfileImage = 'https://picsum.photos/200/300.jpg';
List<TripCancellationModel> tripCancellationList = [
  TripCancellationModel(
    title: AppStaticStrings.riderNoShow,
    isChecked: false.obs,
  ),
  TripCancellationModel(
    title: AppStaticStrings.wrongPickupLocation,
    isChecked: false.obs,
  ),
  TripCancellationModel(
    title: AppStaticStrings.safetyConcerns,
    isChecked: false.obs,
  ),
  TripCancellationModel(
    title: AppStaticStrings.vehicleIssue,
    isChecked: false.obs,
  ),
  TripCancellationModel(
    title: AppStaticStrings.tripRequestError,
    isChecked: false.obs,
  ),
];
String pickupDestination = 'Pickup destination';
String userRole = 'User Role';
String role = 'role';
String driver = 'driver';
String user = 'user';

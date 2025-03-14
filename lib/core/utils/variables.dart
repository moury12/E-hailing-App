import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/image_constant.dart';
import 'package:e_hailing_app/presentations/navigation/model/navigation_model.dart';
import 'package:e_hailing_app/presentations/trip/model/trip_cancellation_model.dart';
import 'package:get/get.dart';

List<NavigationModel> navList = [
  NavigationModel(title: AppStaticStrings.home, img: homeIcon, index: 0),
  NavigationModel(title: AppStaticStrings.myRides, img: rideIcon, index: 1),
  NavigationModel(
    title: AppStaticStrings.trackRides,
    img: locationIcon,
    index: 2,
  ),
  NavigationModel(title: AppStaticStrings.messages, img: messageIcon, index: 3),
  NavigationModel(title: AppStaticStrings.profile, img: profileIcon, index: 4),
];

String dummyProfileImage ='https://picsum.photos/200/300.jpg';
List<TripCancellationModel> tripCancellationList =[
  TripCancellationModel(title: AppStaticStrings.riderNoShow,
      isChecked: false.obs),
  TripCancellationModel(title: AppStaticStrings.wrongPickupLocation,
      isChecked: false.obs),
  TripCancellationModel(title: AppStaticStrings.safetyConcerns,
      isChecked: false.obs),
  TripCancellationModel(title: AppStaticStrings.vehicleIssue,
      isChecked: false.obs),
  TripCancellationModel(title: AppStaticStrings.tripRequestError,
      isChecked: false.obs),
];
String pickupDestination ='Pickup destination';
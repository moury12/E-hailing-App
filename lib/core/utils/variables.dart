import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/image_constant.dart';
import 'package:e_hailing_app/presentations/driver-statics/model/StaticModel.dart';
import 'package:e_hailing_app/presentations/splash/controllers/common_controller.dart';
import 'package:e_hailing_app/presentations/trip/model/trip_cancellation_model.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';

var logger = Logger(printer: PrettyPrinter());
const String authBox = 'auth';
const String verifyEmail = 'verifyEmail';
String roleKey = 'role';
String userBoxName = 'user';
String initialKey = 'initial';
String tokenKey = 'token';
String verifyTokenKey = 'verify token';
String dummyProfileImage = 'https://picsum.photos/200/300.jpg';
String fromHome = "Home";
List<TripCancellationModel> tripCancellationList =CommonController.to.isDriver.value? [
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
]: [
  TripCancellationModel(
    title: AppStaticStrings.waitingTimeIsLong,
    isChecked: false.obs,
  ),
  TripCancellationModel(
    title: AppStaticStrings.changeOfTravelPlan,
    isChecked: false.obs,
  ),
  TripCancellationModel(
    title: AppStaticStrings.tripReqError,
    isChecked: false.obs,
  ),

];
class AddressModel{
  final String title;
  final LatLng latLng;
  final double latitude;
  final double longitutde;

  AddressModel({required this.title, required this.latLng, required this.latitude, required this.longitutde});


}
String pickupDestination = 'Pickup destination';
String userRole = 'User Role';
String role = 'role';
String driver = 'driver';
String user = 'user';
List<StaticModel> staticList = [
  StaticModel(
    img: totalEarnIcon,
    title: AppStaticStrings.totalEarn,
    val: 'RM 600',
  ),
  StaticModel(
    img: handCash1Icon,
    title: AppStaticStrings.handCash,
    val: 'RM 600',
  ),
  StaticModel(img: coinIcon, title: AppStaticStrings.dCoin, val: 'RM 600'),
  StaticModel(
    img: onlineCashIcon,
    title: AppStaticStrings.onlineCash,
    val: 'RM 600',
  ),
  StaticModel(
    img: tripTodayIcon,
    title: AppStaticStrings.tripToday,
    val: 'RM 600',
  ),
  StaticModel(
    img: activeHourIcon,
    title: AppStaticStrings.activeHour,
    val: 'RM 600',
  ),
  StaticModel(
    img: distanceTodayIcon,
    title: AppStaticStrings.tripDistanceToday,
    val: 'RM 600',
  ),
];

List<String> paymentMethodList = [
  AppStaticStrings.creditDebitCards,
  AppStaticStrings.handCash,
  AppStaticStrings.dCoin,
];

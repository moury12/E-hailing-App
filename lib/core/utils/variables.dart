import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
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
String today = "today";
String thisWeek = "last-7-days";
String thisMonth = "this-month";
String preBook= "pre_book";
String nrcVerificationField= "nrc_verification_status";
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

final List<Map<String, String>> paymentMethodList = [
   {"value": "online", "label":AppStaticStrings.creditDebitCards.tr},
  {"value": "cash", "label":AppStaticStrings.handCash.tr},
  {"value": "coin", "label":AppStaticStrings.dCoin.tr},
];



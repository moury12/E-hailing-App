import 'dart:async';
import 'dart:convert';

import 'package:e_hailing_app/core/api-client/api_endpoints.dart';
import 'package:e_hailing_app/core/api-client/api_service.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/hive_boxes.dart';
import 'package:e_hailing_app/core/helper/helper_function.dart';
import 'package:e_hailing_app/core/service/location-service/location_service.dart';
import 'package:e_hailing_app/core/service/socket-service/socket_events_variable.dart';
import 'package:e_hailing_app/core/service/socket-service/socket_service.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/profile/controllers/account_information_controller.dart';
import 'package:e_hailing_app/presentations/profile/model/user_profile_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

import '../../../core/utils/google_map_api_key.dart';

class CommonController extends GetxController {
  static CommonController get to => Get.find();
  RxBool isLoadingProfile = false.obs;
  final SocketService socketService = SocketService();

  RxString socketStatus = "Disconnected".obs;
  final locationService = LocationTrackingService();
  Rx<LatLng> markerPositionDriver = Rx<LatLng>(LatLng(0.0, 0.0));
  Rx<LatLng> markerPositionRider = Rx<LatLng>(LatLng(0.0, 0.0));
  GoogleMapController? mapControllerDriver;
  GoogleMapController? mapControllerRider;

  void setMapControllerRider(GoogleMapController controller) {
    mapControllerRider = controller;
    startTrackingLocationMethod();
  }

  void setMapControllerDriver(GoogleMapController controller) {
    mapControllerDriver = controller;
    startTrackingLocationMethod();
  }

  Rx<UserProfileModel> userModel = UserProfileModel().obs;
  var selectedRoleOption =
      Boxes.getUserData().get(roleKey) != null
          ? Boxes.getUserData().get(roleKey) == 'USER'
              ? 0.obs
              : 1.obs
          : 0.obs;
  RxBool isDriver =
      (Boxes.getUserRole().get(role, defaultValue: user).toString() == driver)
          .obs;
  RxBool isLoadingOnLocationSuggestion = false.obs;
  RxList<dynamic> addressSuggestion = [].obs;

  @override
  void onInit() async {
    logger.d(
      "--check role----${Boxes.getUserRole().get(role, defaultValue: user).toString()}",
    );
    if (Boxes.getUserData().get(tokenKey) != null &&
        Boxes.getUserData().get(tokenKey).toString().isNotEmpty) {
      initialSetUp();
    }

    // Only setup socket if we have a valid user ID

    super.onInit();
  }

  Future<void> requestLocationPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      debugPrint("Location permission granted.");
    } else {
      debugPrint("Location permission denied.");
    }
  }

  Future<void> fetchSuggestedPlaces(String input) async {
    isLoadingOnLocationSuggestion.value = true;
    final url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${Uri.encodeComponent(input)}&key=${GoogleClient.googleMapUrl}';
    final response = await http.get(Uri.parse(url));
    debugPrint(url);
    debugPrint(response.body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      addressSuggestion.value = data['predictions'];
      isLoadingOnLocationSuggestion.value = false;
    } else {
      isLoadingOnLocationSuggestion.value = false;
    }
  }

  Future<void> setupGlobalSocketListeners() async {
    socketService.onConnected = () {
      socketStatus.value = 'Connected';
      logger.i('Socket connected');
    };

    socketService.onDisconnected = () {
      socketStatus.value = 'Disconnected';
      logger.w('Socket disconnected');
    };

    socketService.onSocketError = (error) {
      socketStatus.value = 'Error: $error';
      logger.e('Socket error: $error');
      showCustomSnackbar(title: "Error", message: 'Socket error: $error');
    };

    // You can even auto-connect here if you want:
    final userId = userModel.value.sId ?? "";
    logger.d(userId);
    if (userId.isNotEmpty) {
      socketService.connect(userId, userModel.value.role == "DRIVER");
    }
  }

  Future<void> fetchSuggestedPlacesWithRadius(
    String input, {
    double radiusInMeters = 5000,
  }) async {
    isLoadingOnLocationSuggestion.value = true;
    Rx<LatLng> markerPosition =
        isDriver.value ? markerPositionDriver : markerPositionRider;

    String url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${Uri.encodeComponent(input)}&key=${GoogleClient.googleMapUrl}';

    // Add location bias if current location is available
    if (markerPosition.value.latitude != 0.0 &&
        markerPosition.value.longitude != 0.0) {
      url +=
          '&location=${markerPosition.value.latitude},${markerPosition.value.longitude}';
      url += '&radius=${radiusInMeters.toInt()}';
    }

    final response = await http.get(Uri.parse(url));
    debugPrint(url);
    debugPrint(response.body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      addressSuggestion.value = data['predictions'];
      if (data['predictions'].isEmpty) {
        await fetchCurrentLocationMethod();
      }
      isLoadingOnLocationSuggestion.value = false;
    } else {
      isLoadingOnLocationSuggestion.value = false;
    }
  }

  Future<void> fetchCurrentLocationMethod() async {
    Rx<LatLng> markerPosition =
        isDriver.value ? markerPositionDriver : markerPositionRider;

    await locationService.fetchCurrentLocation(markerPosition: markerPosition);
  }

  Future<void> startTrackingLocationMethod() async {
    Rx<LatLng> markerPosition =
        isDriver.value ? markerPositionDriver : markerPositionRider;
    GoogleMapController? mapController =
        isDriver.value ? mapControllerDriver : mapControllerRider;

    if (mapController == null) {
      logger.e("❌ Map controller not initialized yet.");
      return;
    }
    await locationService.startTrackingLocation(
      markerPosition: markerPosition,
      mapController: mapController,
    );
  }

  Future<void> checkUserRole() async {
    logger.d("token - ${Boxes.getUserData().get(tokenKey)}");
    if (Boxes.getUserData().get(tokenKey) != null &&
        Boxes.getUserData().get(tokenKey).toString().isNotEmpty) {
      Boxes.getUserRole().put(role, userModel.value.role!.toLowerCase());
      isDriver.value = userModel.value.role!.toLowerCase() == driver;
    }
  }

  ///------------------------------ get User profile method -------------------------///

  Future<void> getUserProfileRequest({bool needReinitilaize = false}) async {
    try {
      isLoadingProfile.value = true;
      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());

      final response = await ApiService().request(
        endpoint: getProfileEndPoint,
        method: 'GET',
      );
      isLoadingProfile.value = false;
      if (response['success'] == true) {
        logger.d(response);
        userModel.value = UserProfileModel.fromJson(response['data']);

        if (userModel.value.img != null && userModel.value.img!.isNotEmpty) {
          preloadImagesFromUrls([
            userModel.value.img.toString(),
            userModel.value.drivingLicenseImage.toString(),
            userModel.value.idOrPassportImage.toString(),
            userModel.value.psvLicenseImage.toString(),
          ]);
        }
        if (needReinitilaize) {
          reinitializeProfileControllers();
        }
      } else {
        logger.e(response);
        if (kDebugMode) {
          showCustomSnackbar(
            title: 'Failed',
            message: response['message'],
            type: SnackBarType.failed,
          );
        }
      }
    } catch (e) {
      logger.e(e.toString());
      isLoadingProfile.value = false;
    }
  }

  reinitializeProfileControllers() {
    AccountInformationController.to.nameController.value.text =
        userModel.value.name ?? AppStaticStrings.noDataFound;

    ///=====================add dynmic email ====================///
    AccountInformationController.to.placeController.value.text =
        userModel.value.address ?? AppStaticStrings.noDataFound;

    ///=====================add dynmic contactNumber ====================///
    AccountInformationController.to.contactNumberController.value.text =
        userModel.value.phoneNumber ?? AppStaticStrings.noDataFound;
  }

  void onLogout() {
    Boxes.getUserData().delete(tokenKey);
    Boxes.getUserData().delete(roleKey);
    Boxes.getUserRole().delete(role);
    socketService.off(DriverEvent.driverOnlineStatus);
    socketService.disconnect();
  }

  Future<void> initialSetUp() async {
    await getUserProfileRequest();

    Future.wait([checkUserRole(), fetchCurrentLocationMethod()]);
    if (userModel.value.sId != null) {
      await setupGlobalSocketListeners();
    }
  }

  @override
  void onClose() {
    locationService.stopTracking();
    // socketService.disconnect();
    if (mapControllerDriver != null) {
      mapControllerDriver!.dispose();
    } else if (mapControllerRider != null) {
      mapControllerRider!.dispose();
    }
    super.onClose();
  }
}

import 'dart:async';
import 'dart:convert';

import 'package:e_hailing_app/core/api-client/api_endpoints.dart';
import 'package:e_hailing_app/core/api-client/api_service.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/hive_boxes.dart';
import 'package:e_hailing_app/core/helper/helper_function.dart';
import 'package:e_hailing_app/core/socket/socket_events_variable.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/profile/controllers/account_information_controller.dart';
import 'package:e_hailing_app/presentations/profile/model/user_profile_model.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

import '../../../core/socket/socket_service.dart';
import '../../../core/utils/google_map_api_key.dart';

class CommonController extends GetxController {
  static CommonController get to => Get.find();
  RxBool isLoadingProfile = false.obs;
  Rx<LatLng> markerPosition = LatLng(23.8168, 90.3675).obs;
  final SocketService socketService = SocketService();

  RxString socketStatus = "Disconnected".obs;

  // Rx<LatLng> marketPosition = LatLng(23.8168, 90.3675).obs;
  // GoogleMapController? mapController;
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
    requestLocationPermission();

    super.onInit();
  }

  GoogleMapController? mapController;

  void onMapCreated(GoogleMapController controller) {
    mapController ??= controller;
    CommonController.to
        .fetchCurrentLocation(); // Store and reuse the same controller
  }

  Future<void> requestLocationPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      debugPrint("Location permission granted.");
    } else {
      debugPrint("Location permission denied.");
    }
  }

  StreamSubscription<Position>? positionStream;

  Future<void> startTrackingUserLocation({String? tripId}) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar('Location Disabled', 'Please enable location services');
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar('Permission Denied', 'Location permission denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar(
        'Permission Denied',
        'Please enable location permission from settings',
      );
      await Geolocator.openAppSettings();
      return;
    }

    // Cancel any existing stream to avoid duplicates
    positionStream?.cancel();

    positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // minimum movement (in meters) before update
      ),
    ).listen((Position position) {
      markerPosition.value = LatLng(position.latitude, position.longitude);
      // showCustomSnackbar(
      //   title: "update lat lng ",
      //   message: ":${markerPosition.value}",
      // );
      if (tripId != null) {
        socketService.emit(TripEvents.tripDriverLocationUpdate, {
          "tripId": tripId,
          "lat": position.latitude,
          "long": position.longitude,
        });
      }
      mapController?.animateCamera(
        CameraUpdate.newLatLng(markerPosition.value),
      );
    });
  }

  Future<void> fetchCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar('Location Disabled', 'Please enable location services');
      await Geolocator.openLocationSettings();
      return;
    }

    // Check for permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar('Permission Denied', 'Location permission denied');
        await Geolocator.openAppSettings();

        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar(
        'Permission Denied',
        'Location permission permanently denied. Please enable in settings.',
      );
      await Geolocator.openAppSettings();

      openAppSettings();
      return;
    }

    try {
      // Get the current position - THIS WAS MISSING
      Position position = await Geolocator.getCurrentPosition(
        // Add timeout
      );

      // Set new position - THIS WAS MISSING
      markerPosition.value = LatLng(position.latitude, position.longitude);
      await getAddressFromLatLng(markerPosition.value);
      mapController?.animateCamera(
        CameraUpdate.newLatLng(markerPosition.value),
      );
    } catch (e) {
      Get.snackbar('Error', 'Could not get current location: ${e.toString()}');

      // Use fallback if error occurs
      markerPosition.value = LatLng(23.8168, 90.3675); // Dhaka, Bangladesh
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
    await getUserProfileRequest();
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

  // Future<void> setupGlobalSocketListeners() async {
  //   await getUserProfileRequest();
  //
  //   socketService.onConnected = () {
  //     socketStatus.value = 'Connected';
  //     logger.i('Socket connected');
  //   };
  //
  //   socketService.onDisconnected = () {
  //     socketStatus.value = 'Disconnected';
  //     logger.w('Socket disconnected');
  //   };
  //
  //   socketService.onSocketError = (error) {
  //     socketStatus.value = 'Error: $error';
  //     logger.e('Socket error: $error');
  //   };
  //
  //   // Connect and wait for connection
  //   final userId = userModel.value.sId ?? "";
  //   if (userId.isNotEmpty) {
  //     socketService.connect(userId);
  //     //
  //     // // Wait for connection to be established
  //     // int retryCount = 0;
  //     // while (!socketService.isConnected && retryCount < 10) {
  //     //   await Future.delayed(Duration(milliseconds: 500));
  //     //   retryCount++;
  //     // }
  //
  //     if (socketService.isConnected) {
  //       logger.i('Socket connection established successfully');
  //     } else {
  //       logger.e('Failed to establish socket connection after retries');
  //     }
  //   }
  // }

  Future<void> fetchSuggestedPlacesWithRadius(
    String input, {
    double radiusInMeters = 5000,
  }) async {
    isLoadingOnLocationSuggestion.value = true;

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
        fetchCurrentLocation();
      }
      isLoadingOnLocationSuggestion.value = false;
    } else {
      isLoadingOnLocationSuggestion.value = false;
    }
  }

  Future<String> getAddressFromLatLng(LatLng latLng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );

      if (placemarks.isNotEmpty) {
        final Placemark place = placemarks.first;
        final address =
            "${place.subLocality},${place.subAdministrativeArea}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
        return address;
      } else {
        return "No address found";
      }
    } catch (e) {
      return "Error retrieving address";
    }
  }

  Future<void> checkUserRole() async {
    logger.d("token - ${Boxes.getUserData().get(tokenKey)}");
    if (Boxes.getUserData().get(tokenKey) != null &&
        Boxes.getUserData().get(tokenKey).toString().isNotEmpty) {
      await getUserProfileRequest();
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

  Future<void> getLatLngFromPlace(
    String placeId, {
    RxString? lat,
    RxString? lng,
    Rx<LatLng?>? latLng,
    required RxString selectedAddress,
  }) async {
    final String url =
        'https://maps.googleapis.com/maps/api/geocode/json?place_id=$placeId&key=${GoogleClient.googleMapUrl}';

    try {
      final response = await http.get(Uri.parse(url));
      // logger.d(response.body);
      if (response.statusCode == 200) {
        // Parse response
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['results'].isNotEmpty) {
          final location = data['results'][0]['geometry']['location'];

          // Update RxString values
          selectedAddress.value = data['results'][0]['formatted_address'];
          if (lat != null && lng != null) {
            lat.value = location['lat'].toString();
            lng.value = location['lng'].toString();
          } else if (latLng != null) {
            latLng.value = LatLng(location['lat'], location['lng']);
          }
        } else {
          debugPrint("No results found for the provided placeId.");
        }
      } else {
        debugPrint(
          "HTTP Error: ${response.statusCode} - ${response.reasonPhrase}",
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void onClose() {
    socketService.disconnect();
    super.onClose();
  }

  void onLogout() {
    Boxes.getUserData().delete(tokenKey);
    Boxes.getUserData().delete(roleKey);
    Boxes.getUserRole().delete(role);
    socketService.off(DriverEvent.driverOnlineStatus);
    socketService.disconnect();
  }

  Future<void> initialSetUp() async {
    await checkUserRole();
    await setupGlobalSocketListeners();
    await fetchCurrentLocation();
  }
}

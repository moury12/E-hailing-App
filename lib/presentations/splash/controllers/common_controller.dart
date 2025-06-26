import 'dart:convert';
import 'dart:math' as math;

import 'package:e_hailing_app/core/api-client/api_endpoints.dart';
import 'package:e_hailing_app/core/api-client/api_service.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/hive_boxes.dart';
import 'package:e_hailing_app/core/helper/helper_function.dart';
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

import '../../../core/dependency-injection/dependency_injection.dart';
import '../../../core/socket/socket_service.dart';
import '../../../core/utils/google_map_api_key.dart';

class CommonController extends GetxController {
  static CommonController get to => Get.find();
  RxBool isLoadingProfile = false.obs;
  Rx<LatLng> marketPosition = LatLng(23.8168, 90.3675).obs;
  final SocketService socketService = getIt<SocketService>();

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
    debugPrint(Boxes.getUserRole().get(role, defaultValue: user).toString());
    requestLocationPermission();

    // Register AppController here directly — not inside a method
    // Get.put(AppController(), permanent: true);
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

  Future<void> fetchCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar('Location Disabled', 'Please enable location services');
      return;
    }

    // Check for permissions
    permission = await Geolocator.checkPermission();
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
        'Location permission permanently denied. Please enable in settings.',
      );
      return;
    }

    try {
      // Get the current position - THIS WAS MISSING
      Position position = await Geolocator.getCurrentPosition(
        // Add timeout
      );

      // Set new position - THIS WAS MISSING
      marketPosition.value = LatLng(position.latitude, position.longitude);
      await getAddressFromLatLng(marketPosition.value);
      mapController?.animateCamera(
        CameraUpdate.newLatLng(marketPosition.value),
      );
    } catch (e) {
      Get.snackbar('Error', 'Could not get current location: ${e.toString()}');

      // Use fallback if error occurs
      marketPosition.value = LatLng(23.8168, 90.3675); // Dhaka, Bangladesh
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

  void setupGlobalSocketListeners() {
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
    };

    // You can even auto-connect here if you want:
    final userId = userModel.value.sId ?? "";
    if (userId.isNotEmpty) {
      socketService.connect(userId);
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
    if (marketPosition.value.latitude != 0.0 &&
        marketPosition.value.longitude != 0.0) {
      url +=
          '&location=${marketPosition.value.latitude},${marketPosition.value.longitude}';
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
      print("Error getting address: $e");
      return "Error retrieving address";
    }
  }

  Future<bool> drawPolylineBetweenPoints(
    LatLng start,
    LatLng end,
    RxSet routePolylines, {
    required RxInt distance,
    required RxInt duration,
  }) async {
    try {
      final apiKey = GoogleClient.googleMapUrl;
      final url =
          'https://maps.googleapis.com/maps/api/directions/json?origin=${start.latitude},${start.longitude}&destination=${end.latitude},${end.longitude}&key=$apiKey';

      final response = await http.get(Uri.parse(url));
      logger.d("------------------------------");
      logger.d(response.body);
      logger.d(response.statusCode.toString());

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['routes'] != null && data['routes'].isNotEmpty) {
          final points = data['routes'][0]['overview_polyline']['points'];
          List<LatLng> polylinePoints = decodePolyline(points);
          final leg = data['routes'][0]['legs'][0];

          final polyline = Polyline(
            polylineId: const PolylineId('route_line'),
            color: AppColors.kPrimaryColor,
            width: 2,
            points: polylinePoints,
          );
          distance.value = leg['distance']['value']; // e.g., 4690

          // ✅ Duration in seconds
          duration.value = (leg['duration']['value'] / 60).ceil();
          // Alternative if you still have issues:
          Set<Polyline> newPolylines = <Polyline>{};
          newPolylines.add(polyline);
          routePolylines.value = newPolylines;
          // Animate camera to show the route
          await _animateCameraToRoute(polylinePoints);

          return true; // Successfully drew polyline
        } else {
          showCustomSnackbar(
            title: "Sorry!!",
            message: "No route found between selected locations.",
          );
          return false;
        }
      } else {
        print("Failed to fetch directions: ${response.body}");
        showCustomSnackbar(
          title: "Error!!",
          message: "Failed to get route. Please try again.",
        );
        return false;
      }
    } catch (e) {
      debugPrint("Error in drawPolylineBetweenPoints: $e");
      showCustomSnackbar(
        title: "Error!!",
        message: "Something went wrong. Please try again.",
      );
      return false;
    }
  }

  // Separate method for camera animation with better error handling
  Future<void> _animateCameraToRoute(List<LatLng> polylinePoints) async {
    // Wait a bit to ensure map controller is ready
    await Future.delayed(const Duration(milliseconds: 500));

    // Check if map controller is available
    if (CommonController.to.mapController != null) {
      try {
        LatLngBounds bounds = getBoundsFromPoints(polylinePoints);

        await CommonController.to.mapController!.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, 100),
        );

        debugPrint("Camera animated successfully");
      } catch (e) {
        debugPrint("Error animating camera: $e");
        // Fallback: Calculate center and appropriate zoom level
        try {
          LatLng center = _calculateCenter(polylinePoints);
          double zoom = _calculateZoomLevel(
            getBoundsFromPoints(polylinePoints),
          );

          await CommonController.to.mapController!.animateCamera(
            CameraUpdate.newLatLngZoom(center, zoom),
          );
        } catch (fallbackError) {
          debugPrint("Fallback camera animation also failed: $fallbackError");
        }
      }
    } else {
      debugPrint("Map controller is null");
    }
  }

  // Improved bounds calculation with validation
  LatLngBounds getBoundsFromPoints(List<LatLng> points) {
    if (points.isEmpty) {
      throw ArgumentError('Points list cannot be empty');
    }

    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (LatLng point in points) {
      minLat = math.min(minLat, point.latitude);
      maxLat = math.max(maxLat, point.latitude);
      minLng = math.min(minLng, point.longitude);
      maxLng = math.max(maxLng, point.longitude);
    }

    // Add proportional padding for better centering
    double latPadding = (maxLat - minLat) * 0.1; // 20% padding
    double lngPadding = (maxLng - minLng) * 0.1; // 20% padding

    // Minimum padding to avoid too tight bounds
    latPadding = math.max(latPadding, 0.002);
    lngPadding = math.max(lngPadding, 0.002);

    return LatLngBounds(
      southwest: LatLng(minLat - latPadding, minLng - lngPadding),
      northeast: LatLng(maxLat + latPadding, maxLng + lngPadding),
    );
  }

  // Helper function to calculate center point
  LatLng _calculateCenter(List<LatLng> points) {
    double centerLat =
        points.map((p) => p.latitude).reduce((a, b) => a + b) / points.length;
    double centerLng =
        points.map((p) => p.longitude).reduce((a, b) => a + b) / points.length;
    return LatLng(centerLat, centerLng);
  }

  // Helper function to calculate appropriate zoom level
  double _calculateZoomLevel(LatLngBounds bounds) {
    double latDiff = bounds.northeast.latitude - bounds.southwest.latitude;
    double lngDiff = bounds.northeast.longitude - bounds.southwest.longitude;

    double maxDiff = math.max(latDiff, lngDiff);

    // Adjust zoom based on the route distance
    if (maxDiff > 0.1) return 11.0;
    if (maxDiff > 0.05) return 12.0;
    if (maxDiff > 0.02) return 13.0;
    if (maxDiff > 0.01) return 14.0;
    if (maxDiff > 0.005) return 15.0;
    return 16.0;
  }

  List<LatLng> decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      polyline.add(LatLng(lat / 1e5, lng / 1e5));
    }
    return polyline;
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
          preloadImagesFromUrls([userModel.value.img.toString()]);
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
      logger.d(response.body);
      if (response.statusCode == 200) {
        // Parse response
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['results'].isNotEmpty) {
          final location = data['results'][0]['geometry']['location'];

          // Update RxString values
          selectedAddress.value = data['results'][0]['formatted_address'];
          latLng!.value = LatLng(location['lat'], location['lng']);
          lat!.value = location['lat'].toString();
          lng!.value = location['lng'].toString();
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
    socketService.disconnect();
  }
}

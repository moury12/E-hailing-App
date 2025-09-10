import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:math';

import 'package:e_hailing_app/core/components/custom_button.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/custom_space.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/fontsize_constant.dart';
import 'package:e_hailing_app/core/constants/text_style_constant.dart';
import 'package:e_hailing_app/core/helper/helper_function.dart';
import 'package:e_hailing_app/core/service/socket-service/socket_events_variable.dart';
import 'package:e_hailing_app/core/service/socket-service/socket_service.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/splash/controllers/common_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../../utils/google_map_api_key.dart';

class LocationTrackingService {
  static final LocationTrackingService _instance =
      LocationTrackingService._internal();

  factory LocationTrackingService() => _instance;

  LocationTrackingService._internal();

  StreamSubscription<Position>? _positionStream;
  String? _lastTripId;
  final SocketService socketService = SocketService();
bool isRunning=false;
  Future<void> startTrackingLocation({
    String? tripId,
    required Rx<LatLng> markerPosition,
    required GoogleMapController? mapController,
    bool emitToSocket = true,
  })
  async {
    try{
      if(isRunning){
        return;
      }
      isRunning=true;
      // bool serviceEnabled = await handleLocationPermission();
      // if (!serviceEnabled) {
      //   Get.snackbar('Location Disabled', 'Please enable location services');
      //   await Geolocator.openLocationSettings();
      //   return;
      // }

      // LocationPermission permission = await Geolocator.checkPermission();
      // if (permission == LocationPermission.denied) {
      //   permission = await Geolocator.requestPermission();
      //   if (permission == LocationPermission.denied) {
      //     Get.snackbar('Permission Denied', 'Location permission denied');
      //     return;
      //   }
      // }
      //
      // if (permission == LocationPermission.deniedForever) {
      //   Get.snackbar('Permission Denied', 'Enable from settings');
      //   await Geolocator.openAppSettings();
      //   return;
      // }

      // Prevent duplicate tracking
      if (tripId != null && _lastTripId == tripId && _positionStream != null) {
        return;
      }

      _positionStream?.cancel(); // Cancel previous

      _positionStream = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      ).listen((Position position) {
        final newPosition = LatLng(position.latitude, position.longitude);
        markerPosition.value = newPosition;

        if (emitToSocket && tripId != null) {
          socketService.socket?.emit(TripEvents.tripDriverLocationUpdate, {
            "tripId": tripId,
            "lat": position.latitude,
            "long": position.longitude,
          });
        }

        mapController?.animateCamera(CameraUpdate.newLatLng(newPosition));
      });

      _lastTripId = tripId;
    }catch(_){

    }finally{
      isRunning= false;
    }
  }
  Future<bool> handleLocationPermission() async {
    LocationPermission permission;

    // Check if location services are enabled
    // bool shouldRequestPermission = await showPermissionExplanationDialog();
    // if (!shouldRequestPermission) {
    //   showCustomSnackbar(
    //       title: 'Location Disabled',
    //       message: 'Please enable location services to use this feature.',
    //       type: SnackBarType.alert
    //   );
    //   return false;
    // }

    // // Check current permission status
    permission = await Geolocator.checkPermission();
logger.d(permission.name);
    // // If permission is denied, show an explanation dialog
    // if (permission == LocationPermission.denied) {
      bool shouldRequestPermission = await showPermissionExplanationDialog();
      if (shouldRequestPermission) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          showCustomSnackbar(
              title: 'Permission Denied',
              message: 'Location permission denied. Some features will be unavailable.',
              type: SnackBarType.alert
          );
          // Handle denial and allow fallback logic here if necessary
          return false;
        }
       else {
        // User declined permission, show a fallback or show the map with default location
        fallbackToDefaultLocation();
        return false;
      }
    }

    // If permission is permanently denied
    if (permission == LocationPermission.deniedForever) {
      showCustomSnackbar(
          title: 'Permission Denied Forever',
          message: 'Location permission is permanently denied. Please enable it in settings.',
          type: SnackBarType.alert
      );
      fallbackToDefaultLocation();

      await Geolocator.openAppSettings();  // Open settings to allow the user to grant permission
      return false;
    }

    return true;  // Permission granted
  }
  void fallbackToDefaultLocation() {
    // Fallback logic if location permission is denied (or user chooses to proceed with limited functionality)
    // Hardcoding the fallback location (Malaysia coordinates in this example)
   if(!CommonController.to.isDriver.value) {
      CommonController.to.markerPositionRider.value = LatLng(3.139, 101.6869);
    } else{
     CommonController.to.markerPositionDriver.value = LatLng(3.139, 101.6869);   }

  }
//   Future<bool> handleLocationPermission() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     // Check if location services are enabled
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       showCustomSnackbar(
//           title:   'Location Disabled',
//           message: 'Please enable location services',
//           type: SnackBarType.alert
//       );
//       await Geolocator.openLocationSettings();
//       return false;
//     }
//
//     // Check permission
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//        bool shouldRequestPermission = await showPermissionExplanationDialog();
// if(shouldRequestPermission){
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         showCustomSnackbar(
//             title:   'Permission Denied',
//             message: 'Location permission denied',
//             type: SnackBarType.alert
//         );
//         return false;
//       }}else{
//         return false;
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       showCustomSnackbar(
//           title:   'Permission Denied',
//           message: 'Location permission permanently denied. Please enable in settings.',
//           type: SnackBarType.alert
//       );
//       await Geolocator.openAppSettings();
//       return false;
//     }
//
//     return true;
//   }

  Future<bool> showPermissionExplanationDialog() async {
    bool? result = await Get.dialog(
      AlertDialog(
        content: SizedBox(
          width: ScreenUtil().screenWidth*.8,
          child: Column(
            spacing: 6.h,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText(text: 'Location Permission Required',fontSize: getFontSizeDefault(),style: poppinsSemiBold,),
              CustomText(
                textAlign: TextAlign.center,
               text:  'We need your location to show nearby trips and help you navigate during the trip. Please grant location access to proceed.',
              style: poppinsRegular,
                fontSize: getFontSizeSmall(),
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      textColor: AppColors.kPrimaryColor,
                      fillColor: Colors.transparent,
                      onTap: () =>               Get.back(result: false)// Return false when user cancels
                      ,
                      title: AppStaticStrings.cancel,
                    ),
                  ),
                  space12W,
                  Expanded(
                    child: CustomButton(
                      // textColor: AppColors.kPrimaryColor,
                      // fillColor: Colors.transparent,
                      onTap: () =>               Get.back(result: true)// Return false when user cancels
                      ,
                      title: "Allow",
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
     

      ),
    );

    // Return the result (true or false) based on the user action
    return result ?? false; // If the result is null (dialog dismissed without choice), return false
  }

  Future<void> fetchCurrentLocation({
    required Rx<LatLng> markerPosition,
  })
  async {

    try {
      // final hasPermission = await handleLocationPermission();
      // if (!hasPermission) return;
      Position position = await Geolocator.getCurrentPosition(
        // Add timeout
      );

      // Set new position - THIS WAS MISSING
      markerPosition.value = LatLng(position.latitude, position.longitude);
      await getAddressFromLatLng(markerPosition.value);
    } catch (e) {
      showCustomSnackbar(title: 'Error',message:  'Could not get current location: ${e.toString()}',
      type: SnackBarType.failed);

      // Use fallback if error occurs
      markerPosition.value = LatLng(3.139, 101.6869); // Dhaka, Bangladesh
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

  // Future<void> getLatLngFromPlace(
  //   String placeId, {
  //   RxString? lat,
  //   RxString? lng,
  //   Rx<LatLng?>? latLng,
  //   required RxString selectedAddress,
  // })
  // async {
  //   final String url =
  //       'https://maps.googleapis.com/maps/api/geocode/json?place_id=$placeId&key=${GoogleClient.googleMapUrl}';
  //
  //   try {
  //     final response = await http.get(Uri.parse(url));
  //     // logger.d(response.body);
  //     if (response.statusCode == 200) {
  //       // Parse response
  //       final Map<String, dynamic> data = json.decode(response.body);
  //
  //       if (data['results'].isNotEmpty) {
  //         final location = data['results'][0]['geometry']['location'];
  //
  //         // Update RxString values
  //         selectedAddress.value = data['results'][0]['formatted_address'];
  //         if (lat != null && lng != null) {
  //           lat.value = location['lat'].toString();
  //           lng.value = location['lng'].toString();
  //         } else if (latLng != null) {
  //           latLng.value = LatLng(location['lat'], location['lng']);
  //         }
  //       } else {
  //         debugPrint("No results found for the provided placeId.");
  //       }
  //     } else {
  //       debugPrint(
  //         "HTTP Error: ${response.statusCode} - ${response.reasonPhrase}",
  //       );
  //     }
  //   } catch (e) {
  //     debugPrint(e.toString());
  //   }
  // }
  LatLng offsetByDistance(LatLng start, double distanceInKm, double bearingInDegrees) {
    const double earthRadius = 6371.0; // 🌍 in km

    double distRad = distanceInKm / earthRadius;
    double bearingRad = bearingInDegrees * pi / 180;

    double lat1 = start.latitude * pi / 180;
    double lon1 = start.longitude * pi / 180;

    double lat2 = asin(sin(lat1) * cos(distRad) +
        cos(lat1) * sin(distRad) * cos(bearingRad));

    double lon2 = lon1 +
        atan2(sin(bearingRad) * sin(distRad) * cos(lat1),
            cos(distRad) - sin(lat1) * sin(lat2));

    return LatLng(lat2 * 180 / pi, lon2 * 180 / pi);
  }
  Future<bool> drawPolylineBetweenPoints(
    LatLng start,
    LatLng end,
    RxSet routePolylines, {
    RxInt? distance,
    RxInt? duration,
    required LatLng userPosition,
    GoogleMapController? mapController,
  })
  async {
    try {
      final apiKey = GoogleClient.googleMapUrl;
      final url =
          'https://maps.googleapis.com/maps/api/directions/json?origin=${start.latitude},${start.longitude}&destination=${end.latitude},${end.longitude}&key=$apiKey';

      final response = await http.get(Uri.parse(url));
      // logger.d("------------------------------");
      // logger.d(response.body);
      // logger.d(response.statusCode.toString());

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['routes'] != null && data['routes'].isNotEmpty) {
          final points = data['routes'][0]['overview_polyline']['points'];
          List<LatLng> polylinePoints = decodePolyline(points);
          final leg = data['routes'][0]['legs'][0];

          final polyline = Polyline(
            polylineId: const PolylineId('route_line'),
            color: AppColors.kPrimaryColor,
            width: 4,
            // startCap: Cap.customCapFromBitmap(
            //   await BitmapDescriptor.asset(
            //     ImageConfiguration(size: Size(48, 48)),
            //     "assets/icons/circle_icon.png",
            //   ),
            // ),
            // endCap: Cap.customCapFromBitmap(
            //   await BitmapDescriptor.asset(
            //     ImageConfiguration(size: Size(48, 48)),
            //     "assets/icons/circle_icon.png",
            //   ),
            // ),
            points: polylinePoints,
          );
          if (distance != null && duration != null) {
            distance.value = leg['distance']['value']; // e.g., 4690

            // ✅ Duration in seconds
            duration.value = (leg['duration']['value'] / 60).ceil();
          }
          // Alternative if you still have issues:
          Set<Polyline> newPolylines = <Polyline>{};
          newPolylines.add(polyline);
          routePolylines.value = newPolylines;
          // Animate camera to show the route
          await _animateCameraToRoute(
            polylinePoints,
            userPosition: userPosition,
            mapController: mapController,
          );

          return true; // Successfully drew polyline
        } else {
          showCustomSnackbar(
            title: "Sorry!!",
            message: "No route found between selected locations.",
          );
          return false;
        }
      } else {
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

  Future<void> _animateCameraToRoute(
    List<LatLng> polylinePoints, {
    required LatLng userPosition,
    GoogleMapController? mapController,
  })
  async {
    if (mapController == null || polylinePoints.isEmpty) return;

    try {
      // Include user position in the bounds calculation
      List<LatLng> allPoints = List.from(polylinePoints)..add(userPosition);
      LatLngBounds bounds = getBoundsFromPoints(allPoints);
      double padding = _calculateOptimalPadding(bounds);

      await mapController.animateCamera(
        CameraUpdate.newLatLngBounds(
          bounds,
          padding.roundToDouble(),
        ), // 100px padding
      );
    } catch (e) {
      debugPrint("Error animating camera to route: $e");
      // Fallback to center calculation
      try {
        LatLng center = _calculateCenter(polylinePoints);
        double zoom = _calculateZoomLevel(getBoundsFromPoints(polylinePoints));
        await mapController.animateCamera(
          CameraUpdate.newLatLngZoom(center, zoom),
        );
      } catch (fallbackError) {
        debugPrint("Fallback camera animation failed: $fallbackError");
      }
    }
  }

  double _calculateOptimalPadding(LatLngBounds bounds) {
    double latDiff = bounds.northeast.latitude - bounds.southwest.latitude;
    double lngDiff = bounds.northeast.longitude - bounds.southwest.longitude;

    // For very large distances, use smaller padding to keep more content visible
    if (latDiff > 20 || lngDiff > 20) return 20; // Very large routes
    if (latDiff > 10 || lngDiff > 10) return 50; // Large routes
    if (latDiff > 5 || lngDiff > 5) return 80; // Medium routes
    return 100; // Default padding for local routes
  }

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

  LatLngBounds getBoundsFromPoints(List<LatLng> points) {
    if (points.isEmpty) {
      return LatLngBounds(
        northeast: const LatLng(0, 0),
        southwest: const LatLng(0, 0),
      );
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

    // Dynamic padding calculation based on bounds size
    double latPadding = (maxLat - minLat) * 0.2;
    double lngPadding = (maxLng - minLng) * 0.2;

    // Ensure minimum padding for very small bounds
    latPadding = math.max(latPadding, 0.001);
    lngPadding = math.max(lngPadding, 0.001);

    // Ensure maximum padding for very large bounds
    latPadding = math.min(latPadding, 5.0);
    lngPadding = math.min(lngPadding, 5.0);

    return LatLngBounds(
      southwest: LatLng(minLat - latPadding, minLng - lngPadding),
      northeast: LatLng(maxLat + latPadding, maxLng + lngPadding),
    );
  }

  void stopTracking() {
    _positionStream?.cancel();
    _positionStream = null;
    _lastTripId = null;
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
}

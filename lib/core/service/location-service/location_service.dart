import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:math';

import 'package:e_hailing_app/core/components/custom_button.dart';
import 'package:e_hailing_app/core/components/custom_text_button.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/fontsize_constant.dart';
import 'package:e_hailing_app/core/constants/hive_boxes.dart';
import 'package:e_hailing_app/core/constants/text_style_constant.dart';
import 'package:e_hailing_app/core/helper/helper_function.dart';
import 'package:e_hailing_app/core/service/socket-service/socket_events_variable.dart';
import 'package:e_hailing_app/core/service/socket-service/socket_service.dart';
import 'package:e_hailing_app/core/utils/enum.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/splash/controllers/common_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../utils/google_map_api_key.dart';

class LocationTrackingService {
  static final LocationTrackingService _instance =
      LocationTrackingService._internal();

  factory LocationTrackingService() => _instance;

  LocationTrackingService._internal();

  StreamSubscription<Position>? _positionStream;
  String? _lastTripId;
  final SocketService socketService = SocketService();
  bool isRunning = false;
  Future<void> startTrackingLocation({
    String? tripId,
    required Rx<LatLng> markerPosition,
    required GoogleMapController? mapController,
    bool emitToSocket = true,
  }) async {
    try {
      if (isRunning) {
        return;
      }
      isRunning = true;

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
        if (Boxes.getUserData().get(tokenKey) != null &&
            Boxes.getUserData().get(tokenKey).toString().isNotEmpty) {
          Map<String, dynamic> decodedToken = JwtDecoder.decode(
            Boxes.getUserData().get(tokenKey).toString(),
          );
          if (decodedToken['role'] == "DRIVER" &&
              emitToSocket &&
              tripId != null) {
            socketService.socket?.emit(TripEvents.tripDriverLocationUpdate, {
              "tripId": tripId,
              "lat": position.latitude,
              "long": position.longitude,
            });
          }

          if (decodedToken['role'] == "DRIVER") {
            if (socketService.socket != null &&
                socketService.socket!.connected) {
              // logger.d("🚀 Emitting updateLocation: ${decodedToken['userId']}");
              socketService.socket?.emit(DriverEvent.updateLocation, {
                "lat": position.latitude,
                "long": position.longitude,
                "userId": decodedToken['userId'],
              });
            } else {
              logger.w("⚠️ Socket not connected, cannot emit updateLocation");
            }
          }
        }

        mapController?.animateCamera(CameraUpdate.newLatLng(newPosition));
      });

      _lastTripId = tripId;
    } catch (_) {
    } finally {
      isRunning = false;
    }
  }

  Future<bool> handleLocationPermission() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();

      switch (permission) {
        case LocationPermission.always:
        case LocationPermission.whileInUse:
          bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
          if (!serviceEnabled) {
            showCustomSnackbar(
              title: 'Location Services Disabled',
              message:
                  'Please enable location services in your device settings.',
              type: SnackBarType.alert,
            );
            return false;
          }
          return true;

        case LocationPermission.denied:
          // Request permission normally
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            // ❌ এখানে Settings-এ পাঠানো যাবে না
            fallbackToDefaultLocation();
            return false;
          }
          if (permission == LocationPermission.deniedForever) {
            _showSettingsDialog();
            return false;
          }
          return true;

        case LocationPermission.deniedForever:
          // ✅ User-driven option to go to settings
          _showSettingsDialog();
          return false;

        case LocationPermission.unableToDetermine:
          fallbackToDefaultLocation();
          return false;
      }
    } catch (e) {
      logger.e("Error in handleLocationPermission: $e");
      fallbackToDefaultLocation();
      return false;
    }
  }

  void _showSettingsDialog() {
    showDialog(
      context: Get.context!,
      builder: (context) {
        return AlertDialog(
          title: const Text("Location Required"),
          content: const Text(
            "Location access is required to show your current position on the map and process trip requests. "
            "You can enable location permission from your Profile > Account Settings > Location Permission, "
            "or open the device Settings to allow access.",
          ),
          actions: [
            CustomTextButton(
              onPressed: () => Navigator.of(context).pop(), // dismiss only
              title: AppStaticStrings.cancel.tr,
            ),
            CustomTextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Geolocator.openAppSettings();
              },
              title: "Open Settings",
            ),
          ],
        );
      },
    );
  }

  void fallbackToDefaultLocation() {
    // Fallback logic if location permission is denied (or user chooses to proceed with limited functionality)
    // Hardcoding the fallback location (Malaysia coordinates in this example)
    if (!CommonController.to.isDriver.value) {
      CommonController.to.markerPositionRider.value = LatLng(
        37.33272,
        -122.08740,
      ); // Example fallback coordinates
    } else {
      CommonController.to.markerPositionDriver.value = LatLng(
        37.33272,
        -122.08740,
      ); // Example fallback coordinates
    }
  }

  Future<bool> showPermissionExplanationDialog() async {
    try {
      bool? result = await showDialog<bool>(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SizedBox(
              width: ScreenUtil().screenWidth * 0.8,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomText(
                    text: 'Location Permission Required',
                    fontSize: getFontSizeDefault(),
                    style: poppinsSemiBold,
                  ),
                  CustomText(
                    textAlign: TextAlign.center,
                    text:
                        'Allow location access so we can show you on the map and make sure trip requests work only inside your country.',
                    style: poppinsRegular,
                    fontSize: getFontSizeSmall(),
                  ),
                  SizedBox(height: 12.h),
                  CustomButton(
                    onTap: () => Navigator.of(context).pop(true),
                    title: "Continue",
                  ),
                ],
              ),
            ),
          );
        },
      );
      return result ?? false;
    } catch (e) {
      logger.e("Error showing permission dialog: $e");
      return false;
    }
  }

  Future<void> fetchCurrentLocation({
    required Rx<LatLng> markerPosition,
  }) async {
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
      // showCustomSnackbar(title: 'Error',message:  'Could not get current location: ${e.toString()}',
      // type: SnackBarType.failed);
      logger.e(e);
      // Use fallback if error occurs
      markerPosition.value = LatLng(37.33272, -122.08740); // Dhaka, Bangladesh
    }
  }

  Future<String> getAddressFromLatLng(LatLng latLng) async {
    try {
      // Requesting the placemarks from coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );

      // Check if we got any placemarks
      if (placemarks.isNotEmpty) {
        // Logging the first placemark for debugging purposes
        logger.d(placemarks.first);

        // Getting address details
        final Placemark place = placemarks.first;
        final address =
            "${place.name ?? ""}, ${place.subLocality ?? ""} ${place.administrativeArea ?? ""}, ${place.country ?? ""}";

        return address;
      } else {
        return "No address found";
      }
    } on PlatformException catch (e) {
      // Catching platform-specific errors
      logger.e("Platform error: ${e.message}");
      return "Error retrieving address from platform";
    } on Exception catch (e) {
      // Catching generic errors
      logger.e("General error: $e");
      return "Error retrieving address";
    } catch (e) {
      // Catching any other unhandled errors
      logger.e("Unknown error: $e");
      return "Unknown error occurred";
    }
  }

  LatLng offsetByDistance(
    LatLng start,
    double distanceInKm,
    double bearingInDegrees,
  ) {
    const double earthRadius = 6371.0; // 🌍 in km

    double distRad = distanceInKm / earthRadius;
    double bearingRad = bearingInDegrees * pi / 180;

    double lat1 = start.latitude * pi / 180;
    double lon1 = start.longitude * pi / 180;

    double lat2 = asin(
      sin(lat1) * cos(distRad) + cos(lat1) * sin(distRad) * cos(bearingRad),
    );

    double lon2 =
        lon1 +
        atan2(
          sin(bearingRad) * sin(distRad) * cos(lat1),
          cos(distRad) - sin(lat1) * sin(lat2),
        );

    return LatLng(lat2 * 180 / pi, lon2 * 180 / pi);
  }

  Future<bool> drawPolylineBetweenPoints(
    LatLng start,
    LatLng end,
    RxSet<Polyline> routePolylines, {
    RxInt? distance,
    RxInt? duration,
    required LatLng userPosition,
    GoogleMapController? mapController,
    required PolylineType type,
  }) async {
    final apiKey = GoogleClient.googleMapUrl;
    final needsTraffic = distance != null && duration != null;

    // ✅ Routes API — Essentials plan-এ covered!
    final url = 'https://routes.googleapis.com/directions/v2:computeRoutes';

    final body = {
      "origin": {
        "location": {
          "latLng": {"latitude": start.latitude, "longitude": start.longitude},
        },
      },
      "destination": {
        "location": {
          "latLng": {"latitude": end.latitude, "longitude": end.longitude},
        },
      },
      "travelMode": "DRIVE",
      "routingPreference": needsTraffic ? "TRAFFIC_AWARE" : "TRAFFIC_UNAWARE",
      "computeAlternativeRoutes": false, // false = 1 route only = less cost
      if (needsTraffic)
        "departureTime": DateTime.now().toUtc().toIso8601String(),
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'X-Goog-Api-Key': apiKey,
        // Only request fields you need — reduces cost
        'X-Goog-FieldMask':
            needsTraffic
                ? 'routes.polyline,routes.legs.distanceMeters,routes.legs.duration,routes.legs.staticDuration'
                : 'routes.polyline',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final route = data['routes'][0];

      // Decode polyline
      final points = decodePolyline(route['polyline']['encodedPolyline']);

      if (distance != null && duration != null) {
        final leg = route['legs'][0];
        distance.value = leg['distanceMeters'];

        // duration = traffic-aware, staticDuration = no traffic
        final durationStr = leg['duration'] ?? leg['staticDuration'];
        // Format: "123s" → remove 's' → parse int
        final seconds = int.parse(
          durationStr.toString().replaceAll('s', ''), // 👈 .toString() নতুন
        );
        duration.value = (seconds / 60).ceil();
      }

      // Add polyline to map (same as before)
      Color polylineColor;
      switch (type) {
        case PolylineType.driverToPickup:
          polylineColor = AppColors.kBlueColor;
          break;
        case PolylineType.pickupToDropoff:
          polylineColor = AppColors.kPrimaryColor;
          break;
      }

      routePolylines.add(
        Polyline(
          polylineId: PolylineId(
            'route_${DateTime.now().millisecondsSinceEpoch}',
          ),
          color: polylineColor,
          width: 5.w.toInt(),
          points: points,
        ),
      );
      routePolylines.refresh();

      await _animateCameraToRoute(
        points,
        userPosition: userPosition,
        mapController: mapController,
      );

      return true;
    }
    return false;
  }

  Future<void> _animateCameraToRoute(
    List<LatLng> polylinePoints, {
    required LatLng userPosition,
    GoogleMapController? mapController,
  }) async {
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

import 'package:e_hailing_app/core/constants/image_constant.dart';
import 'package:e_hailing_app/core/helper/helper_function.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/driver-dashboard/controllers/dashboard_controller.dart';
import 'package:e_hailing_app/presentations/home/controllers/home_controller.dart';
import 'package:e_hailing_app/presentations/splash/controllers/boundary_controller.dart';
import 'package:e_hailing_app/presentations/splash/controllers/common_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../navigation/controllers/navigation_controller.dart';

class GoogleMapWidgetForRider extends StatefulWidget {
  const GoogleMapWidgetForRider({super.key});

  @override
  State<GoogleMapWidgetForRider> createState() =>
      _GoogleMapWidgetForRiderState();
}

class _GoogleMapWidgetForRiderState extends State<GoogleMapWidgetForRider>
    with AutomaticKeepAliveClientMixin {
  final Rx<BitmapDescriptor?> customIcon = Rx<BitmapDescriptor?>(null);

  Future<void> loadCustomMarker() async {
    try {
      final bitmap = await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(30, 30)),
        purpleCarImage2,
      );
      customIcon.value = bitmap;
    } catch (e) {
      debugPrint('Error loading custom marker: $e');
      // Fallback to default marker if custom marker fails
      customIcon.value = BitmapDescriptor.defaultMarker;
    }
  }

  @override
  void initState() {
    super.initState();

    loadCustomMarker();
  }

  void _onMapCreated(GoogleMapController controller) {
    CommonController.to.setMapControllerRider(controller);

    // Initial camera position based on whether we have a route or not
    if (NavigationController.to.routePolylines.isEmpty) {
      final userPosition = CommonController.to.markerPositionRider.value;
      if (userPosition != const LatLng(0, 0)) {
        controller.animateCamera(CameraUpdate.newLatLngZoom(userPosition, 14));
      }
    } else {
      // If we already have a polyline, ensure it's properly visible
      WidgetsBinding.instance.addPostFrameCallback((_) {
        HomeController.to.polyLineShow();
      });
    }
  } LatLng? lastValidPosition;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(() {
      final position = CommonController.to.markerPositionRider.value;
logger.i(BoundaryController.to.bounds.toString());
      return GoogleMap(
        zoomGesturesEnabled: true,
        scrollGesturesEnabled: true,
        cameraTargetBounds: BoundaryController.to.bounds.value!= null
            ? CameraTargetBounds(BoundaryController.to.bounds.value)
            : CameraTargetBounds.unbounded,

        onCameraMove: (position) {
          if (BoundaryController.to.bounds.value!= null && !BoundaryController.to.bounds.value!.contains(position.target)) {
            // If the camera moves outside bounds, move it back
            final clampedLat = position.target.latitude.clamp(
              BoundaryController.to.bounds.value!.southwest.latitude,
              BoundaryController.to.bounds.value!.northeast.latitude,
            );
            final clampedLng = position.target.longitude.clamp(
              BoundaryController.to.bounds.value!.southwest.longitude,
              BoundaryController.to.bounds.value!.northeast.longitude,
            );

            // Move the camera back to a valid position
            CommonController.to.mapControllerRider?.animateCamera(
              CameraUpdate.newLatLng(LatLng(clampedLat, clampedLng)),
            );
          }
        },      onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(target: position, zoom: 13),
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: true,
        minMaxZoomPreference: const MinMaxZoomPreference(3, 20),
        mapToolbarEnabled: false,
        compassEnabled: true,
        rotateGesturesEnabled: true,
        tiltGesturesEnabled: true,
onTap: (argument) {
  if (!BoundaryController.to.contains(argument)) {
 showCustomSnackbar(title: "Failed", message: "Please select a location within the country.",type: SnackBarType.alert);
    return;
  }
},
        markers:
            NavigationController.to.routePolylines.isNotEmpty
                ? {
                  if (HomeController.to.driverPosition.value != null &&
                      customIcon.value != null)
                    Marker(
                      markerId: const MarkerId("driver_marker"),
                      position: HomeController.to.driverPosition.value!,
                      icon: customIcon.value!,
                    ),
                }
                : {
                  Marker(
                    markerId: const MarkerId("selected_location"),
                    position:
                        HomeController.to.dropoffLatLng.value ??
                        CommonController.to.markerPositionRider.value,
                    draggable: HomeController.to.mapDragable.value,
                       // Variable to store last valid position

                      onTap: () {
                NavigationController.to.markerDraging.value = true;
      },

        onDragStart: (value) {
          NavigationController.to.markerDraging.value = true;
        },

        onDragEnd: (value) async {
          // 1. Boundary check (inside or outside country boundary)
          if (!BoundaryController.to.contains(value)) {
            // 2. Show custom snackbar if the point is outside the country's boundary
            showCustomSnackbar(
              title: "Failed",
              message: 'Outside country boundary.',
              type: SnackBarType.alert,
            );

            // 3. Snap back to last valid location
            if (lastValidPosition != null) {
              CommonController.to.markerPositionRider.value = lastValidPosition!;
            }
            return;
          }

          // 4. If the marker is within the boundary, proceed with normal operations
          try {
            // Update the last valid position to the current one
            lastValidPosition = value;

            // Update the marker position
            CommonController.to.markerPositionRider.value = value;

            // Set either the dropoff or pickup location based on the state
            if (HomeController.to.setDestination.value) {
              HomeController.to.dropoffLatLng.value = value;
            } else {
              HomeController.to.pickupLatLng.value = value;
            }

            // 5. Reverse geocode the new position (optional, based on your app)
            await HomeController.to.getPlaceName(
              value,
              HomeController.to.setDestination.value
                  ? HomeController.to.dropOffLocationController.value
                  : HomeController.to.pickupLocationController.value,
            );

            // 6. Marker dragging is finished
            NavigationController.to.markerDraging.value = false;
          } catch (e) {
            debugPrint('Error in marker drag end: $e');
            // Handle any error that occurs during the process
            NavigationController.to.markerDraging.value = false;
          }
        },

        infoWindow: const InfoWindow(
                      title: "Selected Location",
                      snippet: "This is the chosen spot.",
                    ),
                  ),
                },
      );
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

///-------------------------------------------------------------------------------------////

class GoogleMapWidgetForDriver extends StatefulWidget {
  const GoogleMapWidgetForDriver({super.key});

  @override
  State<GoogleMapWidgetForDriver> createState() =>
      _GoogleMapWidgetForDriverState();
}

class _GoogleMapWidgetForDriverState extends State<GoogleMapWidgetForDriver> {
  final Rx<BitmapDescriptor?> customIcon = Rx<BitmapDescriptor?>(null);

  Future<void> loadCustomMarker() async {
    try {
      final bitmap = await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(30, 30)),
        purpleCarImage2,
      );
      customIcon.value = bitmap;
    } catch (e) {
      debugPrint('Error loading custom marker: $e');
      // Fallback to default marker if custom marker fails
      customIcon.value = BitmapDescriptor.defaultMarker;
    }
  }

  @override
  void initState() {
    super.initState();
    loadCustomMarker();
  }

  void _onMapCreated(GoogleMapController controller) {

    CommonController.to.setMapControllerDriver(controller);
    if (NavigationController.to.routePolylines.isEmpty) {
      final userPosition = CommonController.to.markerPositionDriver.value;
      if (userPosition != const LatLng(0, 0)) {
        controller.animateCamera(CameraUpdate.newLatLngZoom(userPosition, 14));
      }
    } else {
      // If we already have a polyline, ensure it's properly visible
      WidgetsBinding.instance.addPostFrameCallback((_) {
        DashBoardController.to.drawPolylineMethod();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // logger.d("---------------------------------------");
    return Obx(() {
      final position = CommonController.to.markerPositionDriver.value;
      return GoogleMap(
        zoomGesturesEnabled: true,
        scrollGesturesEnabled: true,
        polylines: NavigationController.to.routePolylines.value,

        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(target: position, zoom: 13),
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: true,
        markers: {
          Marker(
            markerId: const MarkerId("driver_marker"),
            position: CommonController.to.markerPositionDriver.value,
            icon: customIcon.value ?? BitmapDescriptor.defaultMarker,

            onTap: () {
              NavigationController.to.markerDraging.value = true;
            },
            onDragStart: (value) {
              NavigationController.to.markerDraging.value = true;
            },
            onDragEnd: (value) async {
              //   CommonController.to.marketPosition.value = value;
              //   if (HomeController.to.setDestination.value) {
              //     HomeController.to.dropoffLatLng.value = value;
              //   } else {
              //     HomeController.to.pickupLatLng.value = value;
              //   }
              //
              //   await HomeController.to.getPlaceName(
              //     value,
              //     HomeController.to.setDestination.value
              //         ? HomeController.to.dropOffLocationController.value
              //         : HomeController.to.pickupLocationController.value,
              //   );
              //   NavigationController.to.markerDraging.value = false;
            },
            infoWindow: const InfoWindow(
              title: "Selected Location",
              snippet: "This is the chosen spot.",
            ),
          ),
        },
      );
    });
  }
}

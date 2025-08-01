import 'package:e_hailing_app/core/constants/image_constant.dart';
import 'package:e_hailing_app/presentations/driver-dashboard/controllers/dashboard_controller.dart';
import 'package:e_hailing_app/presentations/home/controllers/home_controller.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(() {
      final position = CommonController.to.markerPositionRider.value;

      return GoogleMap(
        zoomGesturesEnabled: true,
        scrollGesturesEnabled: true,

        // polylines: NavigationController.to.routePolylines.value,
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(target: position, zoom: 13),
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: true,
        // Add these properties for better stability
        mapToolbarEnabled: false,
        compassEnabled: true,
        rotateGesturesEnabled: true,
        tiltGesturesEnabled: true,

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
                    onTap: () {
                      NavigationController.to.markerDraging.value = true;
                    },
                    onDragStart: (value) {
                      NavigationController.to.markerDraging.value = true;
                    },
                    onDragEnd: (value) async {
                      try {
                        CommonController.to.markerPositionRider.value = value;
                        if (HomeController.to.setDestination.value) {
                          HomeController.to.dropoffLatLng.value = value;
                        } else {
                          HomeController.to.pickupLatLng.value = value;
                        }

                        await HomeController.to.getPlaceName(
                          value,
                          HomeController.to.setDestination.value
                              ? HomeController
                                  .to
                                  .dropOffLocationController
                                  .value
                              : HomeController
                                  .to
                                  .pickupLocationController
                                  .value,
                        );
                        NavigationController.to.markerDraging.value = false;
                      } catch (e) {
                        debugPrint('Error in marker drag end: $e');
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
  GoogleMapController? _mapController;

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
    _mapController = controller;

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

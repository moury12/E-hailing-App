import 'package:e_hailing_app/core/constants/image_constant.dart';
import 'package:e_hailing_app/presentations/home/controllers/home_controller.dart';
import 'package:e_hailing_app/presentations/splash/controllers/common_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../navigation/controllers/navigation_controller.dart';

class GoogleMapWidget extends StatefulWidget {
  const GoogleMapWidget({super.key});

  @override
  State<GoogleMapWidget> createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget>
    with AutomaticKeepAliveClientMixin {
  Rxn<BitmapDescriptor> customIcon = Rxn<BitmapDescriptor>();
  GoogleMapController? _mapController;
  bool _isMapReady = false;

  Future<void> loadCustomMarker() async {
    try {
      final bitmap = await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(50, 50)),
        purpleCarImage2,
      );
      customIcon.value = bitmap;
    } catch (e) {
      print('Error loading custom marker: $e');
      // Fallback to default marker if custom marker fails
      customIcon.value = BitmapDescriptor.defaultMarker;
    }
  }

  @override
  void initState() {
    super.initState();
    loadCustomMarker();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _isMapReady = true;

    // Call the original onMapCreated if it exists
    if (CommonController.to.onMapCreated != null) {
      CommonController.to.onMapCreated!(controller);
    }
  }

  // Safe method to animate camera with error handling
  Future<void> _animateCameraToPosition(LatLng position) async {
    if (!_isMapReady || _mapController == null) return;

    try {
      await _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: position, zoom: 13),
        ),
      );
    } catch (e) {
      print('Error animating camera: $e');
      // Fallback to moving camera without animation
      try {
        await _mapController!.moveCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: position, zoom: 13),
          ),
        );
      } catch (e2) {
        print('Error moving camera: $e2');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(() {
      final position = CommonController.to.markerPosition.value;

      return GoogleMap(
        zoomGesturesEnabled: true,
        scrollGesturesEnabled: true,
        polylines: NavigationController.to.routePolylines.value,
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
                        CommonController.to.markerPosition.value,
                    draggable: HomeController.to.mapDragable.value,
                    onTap: () {
                      NavigationController.to.markerDraging.value = true;
                    },
                    onDragStart: (value) {
                      NavigationController.to.markerDraging.value = true;
                    },
                    onDragEnd: (value) async {
                      try {
                        CommonController.to.markerPosition.value = value;
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
                        print('Error in marker drag end: $e');
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

class GoogleMapWidgetForDriver extends StatelessWidget {
  const GoogleMapWidgetForDriver({super.key});

  @override
  Widget build(BuildContext context) {
    // logger.d("---------------------------------------");
    return Obx(() {
      final position = CommonController.to.markerPosition.value;
      return GoogleMap(
        zoomGesturesEnabled: true,
        scrollGesturesEnabled: true,
        polylines: NavigationController.to.routePolylines.value,

        onMapCreated: CommonController.to.onMapCreated,
        initialCameraPosition: CameraPosition(target: position, zoom: 13),
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: true,
        markers: {
          Marker(
            markerId: const MarkerId("selected_location"),
            position:
                // HomeController.to.dropoffLatLng.value ??
                CommonController.to.markerPosition.value,
            // draggable: HomeController.to.mapDragable.value,
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

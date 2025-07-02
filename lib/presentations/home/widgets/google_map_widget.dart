import 'package:e_hailing_app/presentations/home/controllers/home_controller.dart';
import 'package:e_hailing_app/presentations/splash/controllers/common_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../navigation/controllers/navigation_controller.dart';

class GoogleMapWidget extends StatelessWidget {
  const GoogleMapWidget({super.key});

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
              CommonController.to.markerPosition.value = value;
              if (HomeController.to.setDestination.value) {
                HomeController.to.dropoffLatLng.value = value;
              } else {
                HomeController.to.pickupLatLng.value = value;
              }

              await HomeController.to.getPlaceName(
                value,
                HomeController.to.setDestination.value
                    ? HomeController.to.dropOffLocationController.value
                    : HomeController.to.pickupLocationController.value,
              );
              NavigationController.to.markerDraging.value = false;
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../navigation/controllers/navigation_controller.dart';

class GoogleMapWidget extends StatelessWidget {

  const GoogleMapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GoogleMap(
        zoomGesturesEnabled: true,
        scrollGesturesEnabled: true,
        onMapCreated: NavigationController.to.onMapCreated,
        initialCameraPosition: CameraPosition(
          target: NavigationController.to.marketPosition.value,
          zoom: 14,
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: true,
        markers: {
          Marker(
            markerId: const MarkerId("selected_location"),
            position: NavigationController.to.marketPosition.value,
            draggable: false,
            onTap: () {
              NavigationController.to.markerDraging.value = true;
            },
            onDragStart: (value) {
              NavigationController.to.markerDraging.value = true;
            },
            onDragEnd: (value) {
              NavigationController.to.marketPosition.value = value;
              NavigationController.to.getPlaceName(value);
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

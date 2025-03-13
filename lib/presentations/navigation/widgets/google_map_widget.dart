import 'package:e_hailing_app/presentations/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapWidget extends StatelessWidget {
  const GoogleMapWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
    () {
        return GoogleMap(
          zoomGesturesEnabled:HomeController.to.markerDraging.value?false: true,
          scrollGesturesEnabled: HomeController.to.markerDraging.value?false:true,
          initialCameraPosition: CameraPosition(
            target: HomeController.to.marketPosition.value,
            zoom: 14, // Set a more focused zoom level
          ),
          myLocationEnabled: true,
          myLocationButtonEnabled: false, // Custom button added
          zoomControlsEnabled: true, // Custom zoom controls added
          markers: {
            Marker(
              markerId: const MarkerId("selected_location"),
              position: HomeController.to.marketPosition.value,
              draggable: true,
              onTap: () {
                HomeController.to.markerDraging.value=true;
              },
              onDragStart: (value) {
                HomeController.to.markerDraging.value=true;
              },
              onDragEnd: (value) {

                HomeController.to.marketPosition.value= value;
                HomeController.to.getPlaceName(value);
                HomeController.to.markerDraging.value=false;
              },
              infoWindow: const InfoWindow(
                title: "Selected Location",
                snippet: "This is the chosen spot.",
              ),
            ),
          },
        );
      }
    );
  }
}

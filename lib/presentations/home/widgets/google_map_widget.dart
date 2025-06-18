import 'package:e_hailing_app/presentations/splash/controllers/common_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../navigation/controllers/navigation_controller.dart';

class GoogleMapWidget extends StatefulWidget {
  const GoogleMapWidget({super.key});

  @override
  State<GoogleMapWidget> createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  @override
  void initState() {
    CommonController.to.drawPolylineBetweenPoints(
      CommonController.to.marketPosition.value,
      LatLng(23.8168, 90.3675),
      NavigationController.to.routePolylines,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // logger.d("---------------------------------------");
    return GoogleMap(
      zoomGesturesEnabled: true,
      scrollGesturesEnabled: true,
      polylines: NavigationController.to.routePolylines,

      onMapCreated: CommonController.to.onMapCreated,
      initialCameraPosition: CameraPosition(
        target: CommonController.to.marketPosition.value,
        zoom: 13,
      ),
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: true,
      markers: {
        Marker(
          markerId: const MarkerId("selected_location"),
          position: CommonController.to.marketPosition.value,
          draggable: false,
          onTap: () {
            NavigationController.to.markerDraging.value = true;
          },
          onDragStart: (value) {
            NavigationController.to.markerDraging.value = true;
          },
          onDragEnd: (value) {
            CommonController.to.marketPosition.value = value;
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
  }
}

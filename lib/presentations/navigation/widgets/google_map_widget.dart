import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapWidget extends StatelessWidget {
  const GoogleMapWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      zoomGesturesEnabled: true,
      scrollGesturesEnabled: true,
      initialCameraPosition: CameraPosition(
        target: LatLng(23.8168, 90.3675),
        zoom: 14, // Set a more focused zoom level
      ),
      myLocationEnabled: true,
      myLocationButtonEnabled: false, // Custom button added
      zoomControlsEnabled: true, // Custom zoom controls added
      markers: {
        Marker(
          markerId: const MarkerId("selected_location"),
          position: LatLng(23.8168, 90.3675),
          infoWindow: const InfoWindow(
            title: "Selected Location",
            snippet: "This is the chosen spot.",
          ),
        ),
      },
    );
  }
}

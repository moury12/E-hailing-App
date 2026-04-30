import 'dart:async';

import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/image_constant.dart';
import 'package:e_hailing_app/core/helper/helper_function.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/driver-dashboard/controllers/dashboard_controller.dart';
import 'package:e_hailing_app/presentations/home/controllers/home_controller.dart';
import 'package:e_hailing_app/presentations/splash/controllers/boundary_controller.dart';
import 'package:e_hailing_app/presentations/home/model/station_model.dart';
import 'package:e_hailing_app/presentations/splash/controllers/common_controller.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:geolocator/geolocator.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/text_style_constant.dart';
import 'package:e_hailing_app/core/components/custom_button.dart';

import '../../navigation/controllers/navigation_controller.dart';

class GoogleMapWidgetForUser extends StatefulWidget {
  const GoogleMapWidgetForUser({super.key});

  @override
  State<GoogleMapWidgetForUser> createState() => _GoogleMapWidgetForUserState();
}

class _GoogleMapWidgetForUserState extends State<GoogleMapWidgetForUser>
    with AutomaticKeepAliveClientMixin {
  final Rx<BitmapDescriptor?> customIcon = Rx<BitmapDescriptor?>(null);
  final Rx<BitmapDescriptor?> sourceIcon = Rx<BitmapDescriptor?>(null);
  final Rx<BitmapDescriptor?> destinationIcon = Rx<BitmapDescriptor?>(null);
  final Rx<BitmapDescriptor?> currentLocationIcon = Rx<BitmapDescriptor?>(null);

  // Debounce timer for onCameraIdle — prevents rapid getPlaceName() calls
  Timer? _cameraIdleDebounce;

  Future<void> loadCustomMarker() async {
    try {
      final bitmap = await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(30, 15)),
        purpleCarImage2,
      );
      customIcon.value = bitmap;
      final sIcon = await BitmapDescriptor.asset(
        ImageConfiguration(size: Size(30.w, 30.w)),
        sourceLocationIcon,
      );
      sourceIcon.value = sIcon;
      final dIcon = await BitmapDescriptor.asset(
        ImageConfiguration(size: Size(30.w, 30.w)),
        destinationLocationIcon,
      );
      destinationIcon.value = dIcon;
      currentLocationIcon.value = await BitmapDescriptor.asset(
        ImageConfiguration(size: Size(30.w, 30.w)),
        currentLocationUserIcon,
      );
    } catch (e) {
      debugPrint('Error loading custom marker: $e');
      // Fallback to default marker if custom marker fails
      customIcon.value = BitmapDescriptor.defaultMarker;
      sourceIcon.value = BitmapDescriptor.defaultMarker;
      destinationIcon.value = BitmapDescriptor.defaultMarker;
      currentLocationIcon.value = BitmapDescriptor.defaultMarker;
    }
  }

  @override
  void initState() {
    super.initState();
    loadCustomMarker();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      logger.i("Boundary ready: ${BoundaryController.to.isReady}");
      logger.i("Detected city: ${BoundaryController.to.detectedCity}");
      logger.i("Bounds: ${BoundaryController.to.bounds.value}");
    });
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

  LatLng? _pickupCenter;
  LatLng? _dropoffCenter;

  LatLng? lastValidPosition;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(() {
      final position = CommonController.to.markerPositionRider.value;

      return Stack(
        alignment: AlignmentGeometry.center,
        children: [
          GoogleMap(
            zoomGesturesEnabled: true,
            scrollGesturesEnabled: true,
            onCameraMove: (position) {
              if (HomeController.to.setPickup.value) {
                _pickupCenter = position.target;
              } else if (HomeController.to.setDestination.value) {
                _dropoffCenter = position.target;
              }
            },
            onCameraMoveStarted: () {
              HomeController.to.mapDraging.value = true;
            },

            onCameraIdle: () {
              HomeController.to.mapDraging.value = false;

              // Debounce: wait 500ms after last camera movement before calling getPlaceName()
              // This prevents rapid Reverse Geocoding API calls during map dragging
              _cameraIdleDebounce?.cancel();
              _cameraIdleDebounce = Timer(
                const Duration(milliseconds: 500),
                () async {
                  final LatLng? current =
                      HomeController.to.setDestination.value
                          ? _dropoffCenter
                          : _pickupCenter;
                  if (current == null) return;

                  logger.d("onCameraIdle: checking boundary for $current");

                  if (!BoundaryController.to.contains(current)) {
                    logger.w(
                      "onCameraIdle: Boundary check failed for $current",
                    );
                    showCustomSnackbar(
                      title: "Failed",
                      message: AppStaticStrings.outsideCountryBoundary.tr,
                      type: SnackBarType.alert,
                    );
                    if (lastValidPosition != null) {
                      CommonController.to.mapControllerRider?.animateCamera(
                        CameraUpdate.newLatLng(lastValidPosition!),
                      );
                    }
                    return;
                  }

                  lastValidPosition = current;

                  if (HomeController.to.setDestination.value) {
                    HomeController.to.dropoffLatLng.value = current;
                  } else {
                    HomeController.to.pickupLatLng.value = current;
                  }

                  await HomeController.to.getPlaceName(
                    current,
                    HomeController.to.setDestination.value
                        ? HomeController.to.dropOffLocationController.value
                        : HomeController.to.pickupLocationController.value,
                  );

                  HomeController.to.mapDragable.value = false;
                },
              );
            },

            // cameraTargetBounds:
            //     BoundaryController.to.bounds.value != null
            //         ? CameraTargetBounds(BoundaryController.to.bounds.value)
            //         : CameraTargetBounds.unbounded,
            polylines: {
              ...NavigationController.to.routePolylines,
              ...NavigationController.to.routePolylinesDrivers,
            },
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(target: position, zoom: 13),
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: true,
            minMaxZoomPreference: const MinMaxZoomPreference(3, 20),
            mapToolbarEnabled: false,
            compassEnabled: true,
            rotateGesturesEnabled: true,
            tiltGesturesEnabled: true,
            onTap: (argument) {
              if (!BoundaryController.to.contains(argument)) {
                showCustomSnackbar(
                  title: "Failed",
                  message: "Please select a location within the country.",
                  type: SnackBarType.alert,
                );
                return;
              }
            },
            markers: {
              if (HomeController.to.driverPosition.value != null &&
                  customIcon.value != null)
                Marker(
                  markerId: const MarkerId("driver_marker"),
                  position: HomeController.to.driverPosition.value!,
                  icon: customIcon.value ?? BitmapDescriptor.defaultMarker,
                ),

              Marker(
                markerId: const MarkerId("selected_location"),
                position: CommonController.to.markerPositionRider.value,

                icon:
                    currentLocationIcon.value ?? BitmapDescriptor.defaultMarker,

                // Variable to store last valid position
              ),

              if (HomeController.to.pickupLatLng.value != null &&
                  HomeController.to.pickupLatLng.value !=
                      CommonController.to.markerPositionRider.value &&
                  !HomeController.to.setPickup.value)
                Marker(
                  markerId: MarkerId("source Marker"),
                  position: HomeController.to.pickupLatLng.value!,
                  icon: sourceIcon.value ?? BitmapDescriptor.defaultMarker,
                ),
              if (HomeController.to.dropoffLatLng.value != null &&
                  !HomeController.to.setDestination.value)
                Marker(
                  markerId: MarkerId("destination Marker"),
                  position: HomeController.to.dropoffLatLng.value!,
                  icon: destinationIcon.value ?? BitmapDescriptor.defaultMarker,
                ),
            },
          ),
          if (HomeController.to.setPickup.value)
            IgnorePointer(
              child: Image.asset(sourceLocationIcon, height: 30.sp),
            ),
          if (HomeController.to.setDestination.value)
            IgnorePointer(
              child: Image.asset(destinationLocationIcon, height: 30.sp),
            ),
        ],
      );
    });
  }

  @override
  void dispose() {
    _cameraIdleDebounce?.cancel();
    super.dispose();
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
  final Rx<BitmapDescriptor?> sourceIcon = Rx<BitmapDescriptor?>(null);
  final Rx<BitmapDescriptor?> destinationIcon = Rx<BitmapDescriptor?>(null);
  final Rx<BitmapDescriptor?> stationIcon = Rx<BitmapDescriptor?>(null);
  Future<void> loadCustomMarker() async {
    try {
      customIcon.value = await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(30, 15)),
        purpleCarImage2,
      );
    } catch (e) {
      debugPrint('Error loading customIcon: $e');
      customIcon.value = BitmapDescriptor.defaultMarker;
    }

    try {
      sourceIcon.value = await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(40, 40)),
        sourceLocationIcon,
      );
    } catch (e) {
      debugPrint('Error loading sourceIcon: $e');
      sourceIcon.value = BitmapDescriptor.defaultMarker;
    }

    try {
      destinationIcon.value = await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(40, 40)),
        destinationLocationIcon,
      );
    } catch (e) {
      debugPrint('Error loading destinationIcon: $e');
      destinationIcon.value = BitmapDescriptor.defaultMarker;
    }

    try {
      stationIcon.value = await BitmapDescriptor.asset(
        ImageConfiguration(size: Size(30.w, 30.w)),
        gasStationIcon,
      );
    } catch (e) {
      debugPrint('Error loading stationIcon: $e');
      stationIcon.value = BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueOrange,
      );
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
      final trip = DashBoardController.to.currentTrip.value;
      final coords = trip.pickUpCoordinates?.coordinates;
      final dropCoords = trip.dropOffCoordinates?.coordinates;
      return GoogleMap(
        zoomGesturesEnabled: true,
        scrollGesturesEnabled: true,
        polylines: {
          ...NavigationController.to.routePolylines.value,
          ...NavigationController.to.routePolylinesDrivers.value,
          ...NavigationController.to.routePolylinesStation.value,
        },

        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(target: position, zoom: 13),
        myLocationEnabled: false,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: true,
        markers: {
          Marker(
            markerId: const MarkerId("driver_marker"),
            position: CommonController.to.markerPositionDriver.value,
            icon: customIcon.value ?? BitmapDescriptor.defaultMarker,
          ),
          if (coords != null)
            Marker(
              markerId: MarkerId("source Marker"),
              position: LatLng(coords.last.toDouble(), coords.first.toDouble()),
              icon: sourceIcon.value ?? BitmapDescriptor.defaultMarker,
            ),
          if (dropCoords != null)
            Marker(
              markerId: MarkerId("destination Marker"),
              position: LatLng(
                dropCoords.last.toDouble(),
                dropCoords.first.toDouble(),
              ),
              icon: destinationIcon.value ?? BitmapDescriptor.defaultMarker,
            ),
          ...DashBoardController.to.gasStations.map((station) {
            final stationCoords = station.location?.coordinates;
            if (stationCoords != null && stationCoords.length >= 2) {
              return Marker(
                markerId: MarkerId("station_${station.sId}"),
                position: LatLng(
                  stationCoords.last.toDouble(),
                  stationCoords.first.toDouble(),
                ),
                icon:
                    stationIcon.value ??
                    BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueOrange,
                    ),

                onTap: () {
                  final driverPos = CommonController.to.markerPositionDriver.value;
                  final stationPos = LatLng(
                    stationCoords.last.toDouble(),
                    stationCoords.first.toDouble(),
                  );
                  
                  double distanceInMeters = Geolocator.distanceBetween(
                    driverPos.latitude,
                    driverPos.longitude,
                    stationPos.latitude,
                    stationPos.longitude,
                  );
                  String distanceText = (distanceInMeters / 1000).toStringAsFixed(1) + " km";

                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        child: Container(
                          padding: EdgeInsets.all(20.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: EdgeInsets.all(16.w),
                                decoration: BoxDecoration(
                                  color: AppColors.kPrimaryColor.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.local_gas_station_rounded,
                                  color: AppColors.kPrimaryColor,
                                  size: 40.w,
                                ),
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                station.title ?? "Gas Station",
                                style: poppinsSemiBold.copyWith(
                                  fontSize: 18.sp,
                                  color: AppColors.kTextColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                station.address ?? "Unknown Address",
                                style: poppinsRegular.copyWith(
                                  fontSize: 14.sp,
                                  color: AppColors.kBorderColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 16.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.route_outlined, color: AppColors.kPrimaryColor, size: 20.w),
                                  SizedBox(width: 8.w),
                                  Text(
                                    "Distance: $distanceText",
                                    style: poppinsMedium.copyWith(
                                      fontSize: 14.sp,
                                      color: AppColors.kPrimaryColor,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 24.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () => Navigator.pop(context),
                                      style: OutlinedButton.styleFrom(
                                        padding: EdgeInsets.symmetric(vertical: 12.h),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.r),
                                        ),
                                        side: BorderSide(color: AppColors.kPrimaryColor),
                                      ),
                                      child: Text(
                                        "Close",
                                        style: poppinsMedium.copyWith(color: AppColors.kPrimaryColor),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        DashBoardController.to.drawPolylineForStation(stationPos);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.kPrimaryColor,
                                        padding: EdgeInsets.symmetric(vertical: 12.h),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.r),
                                        ),
                                        elevation: 0,
                                      ),
                                      child: Text(
                                        "Directions",
                                        style: poppinsMedium.copyWith(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                infoWindow: InfoWindow(
                  title: station.title,
                  snippet: station.address,
                ),
              );
            }
            return null;
          }).whereType<Marker>(),
        },
      );
    });
  }
}

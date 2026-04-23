import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_hailing_app/core/components/custom_appbar.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/presentations/driver-dashboard/controllers/dashboard_controller.dart';
import 'package:e_hailing_app/presentations/driver-dashboard/widgets/ride_request_card_widget.dart';
import 'package:e_hailing_app/core/api-client/api_service.dart';
import 'package:e_hailing_app/core/helper/helper_function.dart';

class AllNearbyTripsPage extends StatelessWidget {
  static const String routeName = '/all-nearby-trips';

  const AllNearbyTripsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = DashBoardController.to;

    return Scaffold(
      appBar: const CustomAppBar(title: "Nearby Trips"),
      body: RefreshIndicator(
        onRefresh: () => controller.getNearbyTrips(),
        child: Obx(() {
          if (controller.isLoadingNearbyTrips.value && controller.availableTrips.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.availableTrips.isEmpty) {
            return Center(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                   height: Get.height * 0.8,
                  child: Center(child: Text(AppStaticStrings.noDataFound.tr))
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: controller.availableTrips.length,
            physics: const AlwaysScrollableScrollPhysics(),
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final availableTrip = controller.availableTrips[index];
              return RideRequestCardWidget(
                tripId: availableTrip.sId,
                userName: availableTrip.user?.name,
                userImg: "${ApiService().baseUrl}/${availableTrip.user?.profileImage}",
                fare: availableTrip.estimatedFare.toString(),
                dateTime: formatDateTime(availableTrip.createdAt ?? ""),
                distance: availableTrip.distance.toString(),
                fromAddress: availableTrip.pickUpAddress,
                rideType: availableTrip.tripType,
                tripClass: availableTrip.tripClass,
                toAddress: availableTrip.dropOffAddress,
              );
            },
          );
        }),
      ),
    );
  }
}

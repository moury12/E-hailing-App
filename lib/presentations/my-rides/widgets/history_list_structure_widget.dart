import 'package:e_hailing_app/presentations/driver-dashboard/model/driver_current_trip_model.dart';
import 'package:e_hailing_app/presentations/save-location/widgets/empty_widget.dart';
import 'package:e_hailing_app/presentations/trip/model/trip_response_model.dart';
import 'package:flutter/cupertino.dart';

import 'my_rides_history_card_item_widget.dart';

class HistoryListStructureWidget extends StatelessWidget {
  final List<dynamic>? myRides;
  final bool isSingleItem;
  final dynamic rideModel;
  final bool isDriver;

  const HistoryListStructureWidget({
    super.key,
    this.myRides,
    this.isSingleItem = false,
    this.rideModel,
    required this.isDriver,
  });

  @override
  Widget build(BuildContext context) {
    if (!isSingleItem) {
      if (myRides == null || myRides!.isEmpty) {
        return EmptyWidget(text: "No Ride Found!!");
      }
    } else {
      if ((isDriver &&
              rideModel is DriverCurrentTripModel &&
              rideModel.sId == null) ||
          (!isDriver &&
              rideModel is TripResponseModel &&
              rideModel.sId == null)) {
        return EmptyWidget(text: "No Ride Found!!");
      }
    }

    return Column(
      children: List.generate(
        isSingleItem ? 1 : myRides!.length,
        (index) => MyRidesHistoryCardItemWidget(
          isDriver: isDriver,
          rideModel: isSingleItem ? rideModel : myRides![index],
        ),
      ),
    );
  }
}

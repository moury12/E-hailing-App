import 'package:e_hailing_app/presentations/trip/model/trip_response_model.dart';
import 'package:flutter/cupertino.dart';

import 'my_rides_history_card_item_widget.dart';

class HistoryListStructureWidget extends StatelessWidget {
  final List<dynamic>? myRides; // Can accept either type
  final bool isSingleItem;
  final TripResponseModel? rideModel;

  const HistoryListStructureWidget({
    super.key,
    this.myRides,
    this.isSingleItem = false,
    this.rideModel,
  });

  @override
  Widget build(BuildContext context) {
    return myRides == null
        ? SizedBox.shrink()
        : Column(
      children: List.generate(
        isSingleItem ? 1 : myRides!.length,
            (index) =>
            MyRidesHistoryCardItemWidget(
              rideModel:
              isSingleItem
                  ? rideModel
                  : myRides![index],
            ),
      ),
    );
  }
}

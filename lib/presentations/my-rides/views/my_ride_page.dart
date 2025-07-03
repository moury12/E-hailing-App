import 'package:e_hailing_app/core/components/tab-bar/dynamic_tab_widget.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/presentations/driver-dashboard/controllers/dashboard_controller.dart';
import 'package:e_hailing_app/presentations/home/controllers/home_controller.dart';
import 'package:e_hailing_app/presentations/my-rides/controllers/my_ride_controller.dart';
import 'package:e_hailing_app/presentations/splash/controllers/common_controller.dart';
import 'package:flutter/cupertino.dart';

import '../widgets/history_list_structure_widget.dart';

class MyRidePage extends StatelessWidget {
  static const String routeName = '/my-ride';

  const MyRidePage({super.key});

  @override
  Widget build(BuildContext context) {
    MyRideController.to.tabContent.add(
      HistoryListStructureWidget(
        rideModel:
            CommonController.to.isDriver.value
                ? DashBoardController.to.currentTrip.value
                : HomeController.to.tripAcceptedModel.value,

        isSingleItem: true,
      ),
    );
    MyRideController.to.tabContent.add(HistoryListStructureWidget());
    MyRideController.to.tabContent.add(
      HistoryListStructureWidget(myRides: MyRideController.to.myRides),
    );
    return SingleChildScrollView(
      child: Padding(
        padding: padding16.copyWith(top: 0),
        child: Column(
          children: [
            DynamicTabWidget(
              tabs: MyRideController.to.tabLabels,
              tabContent: MyRideController.to.tabContent,
            ),
          ],
        ),
      ),
    );
  }
}

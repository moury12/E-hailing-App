import 'package:e_hailing_app/core/components/tab-bar/dynamic_tab_widget.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/presentations/my-rides/controllers/my_ride_controller.dart';
import 'package:flutter/cupertino.dart';

import '../widgets/history_list_structure_widget.dart';

class MyRidePage extends StatelessWidget {
  static const String routeName = '/my-ride';
  const MyRidePage({super.key});

  @override
  Widget build(BuildContext context) {
    MyRideController.to.tabContent.add(HistoryListStructureWidget(length: 1));
    MyRideController.to.tabContent.add(HistoryListStructureWidget(length: 2));
    MyRideController.to.tabContent.add(HistoryListStructureWidget(length:5));
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

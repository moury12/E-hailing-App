import 'package:e_hailing_app/core/components/custom_button.dart';
import 'package:e_hailing_app/core/components/custom_refresh_indicator.dart';
import 'package:e_hailing_app/core/components/tab-bar/dynamic_tab_widget.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/presentations/driver-dashboard/controllers/dashboard_controller.dart';
import 'package:e_hailing_app/presentations/home/controllers/home_controller.dart';
import 'package:e_hailing_app/presentations/my-rides/controllers/my_ride_controller.dart';
import 'package:e_hailing_app/presentations/my-rides/widgets/my_rides_history_card_item_widget.dart';
import 'package:e_hailing_app/presentations/save-location/widgets/empty_widget.dart';
import 'package:e_hailing_app/presentations/splash/controllers/common_controller.dart';
import 'package:e_hailing_app/presentations/trip/model/trip_response_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../widgets/history_list_structure_widget.dart';

class MyRidePage extends StatefulWidget {
  static const String routeName = '/my-ride';

  const MyRidePage({super.key});

  @override
  State<MyRidePage> createState() => _MyRidePageState();
}

class _MyRidePageState extends State<MyRidePage>
    with AutomaticKeepAliveClientMixin {
  late final PageStorageBucket _pageStorageBucket = PageStorageBucket();

  Widget _buildOngoingTab() {
    return Obx(() {
      final isDriver = CommonController.to.isDriver.value;
      final rideModel =
          isDriver
              ? DashBoardController.to.currentTrip.value
              : HomeController.to.tripAcceptedModel.value;

      return HistoryListStructureWidget(
        key: const PageStorageKey('ongoing_tab'),
        rideModel: rideModel,
        isSingleItem: true,
        isDriver: isDriver,
      );
    });
  }

  Widget _buildUpcomingTab() {
    return Obx(() {
      return HistoryListStructureWidget(
        key: const PageStorageKey('upcoming_tab'),
        isDriver: CommonController.to.isDriver.value,
      );
    });
  }

  Widget _buildCompletedTab() {
    return PageStorage(
      bucket: _pageStorageBucket,
      child: PagedListView<int, TripResponseModel>(
        key: const PageStorageKey('completed_tab'),
        pagingController: MyRideController.to.pagingController,
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        builderDelegate: PagedChildBuilderDelegate<TripResponseModel>(
          itemBuilder:
              (context, item, index) => MyRidesHistoryCardItemWidget(
                rideModel: item,
                isDriver: CommonController.to.isDriver.value,
              ),
          firstPageProgressIndicatorBuilder:
              (_) => const DefaultProgressIndicator(),
          newPageProgressIndicatorBuilder:
              (_) => const DefaultProgressIndicator(),
          noItemsFoundIndicatorBuilder:
              (_) => const EmptyWidget(text: "No rides found"),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    return CustomRefreshIndicator(
      onRefresh: () async {
        MyRideController.to.pagingController.refresh();
        final isDriver = CommonController.to.isDriver.value;
        if (isDriver) {
        } else {
          HomeController.to.getUserCurrentTrip();
        }
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: padding12H,
          child: Column(
            children: [
              DynamicTabWidget(
                tabs: MyRideController.to.tabLabels,
                tabContent: [
                  _buildOngoingTab(),
                  _buildUpcomingTab(),
                  _buildCompletedTab(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // @override
  // void dispose() {
  //   MyRideController.to.disposeResources();
  //   super.dispose();
  // }

  @override
  bool get wantKeepAlive => true; // Preserve tab state
}

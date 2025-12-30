import 'package:e_hailing_app/core/components/custom_refresh_indicator.dart';
import 'package:e_hailing_app/core/components/tab-bar/dynamic_tab_widget.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/driver-statics/controllers/statics_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/color_constants.dart';

import '../widgets/static_gridview_widget.dart';

class StaticsPage extends StatelessWidget {
  const StaticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tabs = StaticsController.to.tabLabels;

    return /*ComingSoonWidget()*/ CustomRefreshIndicator(
      onRefresh: () async {
        final index = StaticsController.to.currentTabIndex.value;
        String filter = today;
        if (index == 1) filter = thisWeek;
        if (index == 2) filter = thisMonth;
        await StaticsController.to.getDriverStaticsRequest(
          filter: filter,
          isRefresh: true,
        );
      },
      child: DefaultTabController(
        length: tabs.length,
        child: SingleChildScrollView(
          child: Padding(
            padding: padding12.copyWith(top: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                DynamicTabWidget(
                  onTabChanged: (value) {
                    StaticsController.to.currentTabIndex.value = value;
                    switch (value) {
                      case 0:
                        StaticsController.to.getDriverStaticsRequest(
                          filter: today,
                        );
                      case 1:
                        StaticsController.to.getDriverStaticsRequest(
                          filter: thisWeek,
                        );
                      case 2:
                        StaticsController.to.getDriverStaticsRequest(
                          filter: thisMonth,
                        );
                    }
                  },
                  tabs: tabs,
                  tabContent: [
                    Obx(
                      () =>
                          StaticsController.to.isLoadingStatics.value
                              ? const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.kPrimaryColor,
                                ),
                              )
                              : StaticsGridViewWidget(),
                    ),
                    Obx(
                      () =>
                          StaticsController.to.isLoadingStatics.value
                              ? const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.kPrimaryColor,
                                ),
                              )
                              : StaticsGridViewWidget(),
                    ),
                    Obx(
                      () =>
                          StaticsController.to.isLoadingStatics.value
                              ? const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.kPrimaryColor,
                                ),
                              )
                              : StaticsGridViewWidget(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

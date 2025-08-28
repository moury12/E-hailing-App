import 'package:e_hailing_app/core/components/comming_soon_widget.dart';
import 'package:e_hailing_app/core/components/tab-bar/dynamic_tab_widget.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/core/constants/text_style_constant.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/driver-statics/controllers/statics_controller.dart';
import 'package:flutter/material.dart';

import '../widgets/static_gridview_widget.dart';

class StaticsPage extends StatelessWidget {
  const StaticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tabs = StaticsController.to.tabLabels;

    return /*ComingSoonWidget()*/  DefaultTabController(


      length: tabs.length,
      child: SingleChildScrollView(
        child: Padding(
          padding: padding12.copyWith(top: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [

              DynamicTabWidget(
                onTabChanged: (value) {
                  switch(value){
                    case 0:
                      StaticsController.to.getDriverStaticsRequest(filter: today);
                    case 1:
                    StaticsController.to.getDriverStaticsRequest(filter: thisWeek);
                    case 2:
                      StaticsController.to.getDriverStaticsRequest(filter: thisMonth);
                  }
                },
                tabs: tabs,
                tabContent: [
                  StaticsGridViewWidget(),
                  StaticsGridViewWidget(),
                  StaticsGridViewWidget(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


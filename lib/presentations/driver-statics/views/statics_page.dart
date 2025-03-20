import 'package:e_hailing_app/presentations/driver-statics/controllers/statics_controller.dart';
import 'package:e_hailing_app/presentations/driver-statics/controllers/statics_controller.dart';
import 'package:e_hailing_app/presentations/driver-statics/controllers/statics_controller.dart';
import 'package:e_hailing_app/presentations/driver-statics/controllers/statics_controller.dart';
import 'package:e_hailing_app/presentations/driver-statics/controllers/statics_controller.dart';
import 'package:flutter/material.dart';

import '../../../core/components/tab-bar/dynamic_tab_widget.dart';
import '../../../core/constants/padding_constant.dart';
import '../widgets/static_gridview_widget.dart';

class StaticsPage extends StatelessWidget {
  const StaticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    StaticsController.to.tabContent.add(
      StaticsGridViewWidget(),
    );
    StaticsController.to.tabContent.add(  StaticsGridViewWidget(),);
    StaticsController.to.tabContent.add(  StaticsGridViewWidget(),);
    return SingleChildScrollView(
      child: Padding(
        padding: padding16.copyWith(top: 0),
        child: Column(
          children: [
            DynamicTabWidget(
              tabs: StaticsController.to.tabLabels,
              tabContent: StaticsController.to.tabContent,
            ),
          ],
        ),
      ),
    );
  }
}



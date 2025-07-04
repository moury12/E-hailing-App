import 'package:e_hailing_app/core/components/tab-bar/dynamic_tab_widget.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/presentations/driver-statics/controllers/statics_controller.dart';
import 'package:flutter/material.dart';

import '../widgets/static_gridview_widget.dart';

class StaticsPage extends StatelessWidget {
  const StaticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tabs = StaticsController.to.tabLabels;

    return DefaultTabController(
      length: tabs.length,
      child: SingleChildScrollView(
        child: Padding(
          padding: padding12.copyWith(top: 0),
          child: Column(
            children: [
              DynamicTabWidget(
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

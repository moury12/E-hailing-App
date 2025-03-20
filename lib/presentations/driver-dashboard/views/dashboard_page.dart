import 'package:e_hailing_app/core/components/custom_appbar.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
CustomAppBarForHomeWidget(isDriver: true,)
      ],
    );
  }
}

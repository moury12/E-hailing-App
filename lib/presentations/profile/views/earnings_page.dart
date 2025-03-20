import 'package:e_hailing_app/core/components/custom_appbar.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:flutter/material.dart';

class EarningsPage extends StatelessWidget {
  static const String routeName ='/earnings';
  const EarningsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: CustomAppBar(title: AppStaticStrings.earnings),

    );
  }
}

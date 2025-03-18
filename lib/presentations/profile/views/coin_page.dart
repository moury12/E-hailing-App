import 'package:flutter/material.dart';

import '../../../core/components/custom_appbar.dart';
import '../../../core/constants/app_static_strings_constant.dart';

class CoinPage extends StatelessWidget {
  static const String routeName ='/coin';
  const CoinPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AppStaticStrings.duduCoinWallet),

    );
  }
}
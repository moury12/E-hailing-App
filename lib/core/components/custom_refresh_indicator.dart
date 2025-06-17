import 'package:flutter/material.dart';

import '../constants/color_constants.dart';

class CustomRefreshIndicator extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;

  const CustomRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: AppColors.kPrimaryColor,
      backgroundColor: Colors.transparent,
      elevation: 0,
      displacement: 40.0,
      strokeWidth: 1,
      // Adjust the distance the indicator moves
      child: child,
    );
  }
}

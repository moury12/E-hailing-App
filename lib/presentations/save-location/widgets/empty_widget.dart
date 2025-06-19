import 'package:flutter/material.dart';

import '../../../core/constants/custom_text.dart';

class EmptyWidget extends StatelessWidget {
  final String text;

  const EmptyWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(child: Column(children: [CustomText(text: text)]));
  }
}

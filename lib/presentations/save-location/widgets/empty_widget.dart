import 'package:e_hailing_app/core/constants/image_constant.dart';
import 'package:e_hailing_app/core/constants/text_style_constant.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../core/constants/custom_text.dart';

class EmptyWidget extends StatelessWidget {
  final String text;

  const EmptyWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Lottie.asset(emptyLottie),
        CustomText(text: text, style: poppinsSemiBold),
      ],
    );
  }
}

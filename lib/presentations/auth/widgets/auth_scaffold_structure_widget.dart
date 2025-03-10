import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:flutter/material.dart';

class AuthScaffoldStructureWidget extends StatelessWidget {
  final String? title;
  final double? space;
  final List<Widget> children;
  const AuthScaffoldStructureWidget({
    super.key,
    this.title,
    this.space,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: CustomText(text: title ?? '')),
      body: SingleChildScrollView(
        child: Padding(padding: padding16, child: Column(
          spacing: space??0,
            children: children)),
      ),
    );
  }
}

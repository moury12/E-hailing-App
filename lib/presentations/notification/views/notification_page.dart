import 'package:e_hailing_app/core/components/custom_appbar.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/notification_card_item_widget.dart';

class NotificationPage extends StatelessWidget {
  static const String routeName = '/notification';
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AppStaticStrings.notification),
      body: SingleChildScrollView(
        child: Padding(
          padding: padding16H,
          child: Column(
            spacing: 12.h,
            children: List.generate(
              10,
              (index) => NotificationCardItemWidget(index: index,),
            ),
          ),
        ),
      ),
    );
  }
}

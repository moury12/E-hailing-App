import 'package:e_hailing_app/core/components/custom_appbar.dart';
import 'package:e_hailing_app/core/components/custom_network_image.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/profile/controllers/driver_settings_controller.dart';
import 'package:e_hailing_app/presentations/profile/controllers/driver_settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/components/tab-bar/dynamic_tab_widget.dart';
import '../widgets/profile_card_item_widget.dart';

class VehicleDetailsPage extends StatelessWidget {
  static const String routeName = '/vehicle-details';
  const VehicleDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    DriverSettingsController.to.tabContent.add(Column(
      spacing: 8.h,
      children: [
        ProfileCardItemWidget(
          title: AppStaticStrings.carBrand,
          value: 'Robert Smith',
        ),ProfileCardItemWidget(
          title: AppStaticStrings.carModel,
          value: 'Robert Smith',
        ),ProfileCardItemWidget(
          title: AppStaticStrings.carType,
          value: 'Robert Smith',
        ),ProfileCardItemWidget(
          title: AppStaticStrings.carColor,
          value: 'Robert Smith',
        ),
      ],
    ));
    DriverSettingsController.to.tabContent.add(Column(
      spacing: 8.h,
      children: [ ProfileCardItemWidget(
        title: AppStaticStrings.licensePlate,
        value: 'Robert Smith',
      ),ProfileCardItemWidget(
        title: AppStaticStrings.vin,
        value: 'Robert Smith',
      ),ProfileCardItemWidget(
        title: AppStaticStrings.registrationDate,
        value: 'Robert Smith',
      ),ProfileCardItemWidget(
        title: AppStaticStrings.insuranceStatus,
        value: 'Robert Smith',
      ),],
    ));
    return Scaffold(
      appBar: CustomAppBar(title: AppStaticStrings.vehicleDetails),
      body: SingleChildScrollView(
        child: Padding(
          padding: padding16,
          child: Column(spacing: 8.h,
            children: [
              SingleChildScrollView(scrollDirection: Axis.horizontal,
                child: Row( spacing: 8.w,
                  children: List.generate(
                    5,
                    (index) => CustomNetworkImage(
                      imageUrl: dummyProfileImage,
                      radius: 8.r,
                      height: 110.w,
                      width: 110.w,
                    ),
                  ),
                ),

              ),
              DynamicTabWidget(
                tabs: DriverSettingsController.to.tabLabels,
                tabContent: DriverSettingsController.to.tabContent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

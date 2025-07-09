import 'package:e_hailing_app/core/api-client/api_service.dart';
import 'package:e_hailing_app/core/components/custom_appbar.dart';
import 'package:e_hailing_app/core/components/custom_network_image.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/custom_space.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/presentations/profile/controllers/driver_settings_controller.dart';
import 'package:e_hailing_app/presentations/profile/widgets/vehicel_car_img_shimmer.dart';
import 'package:e_hailing_app/presentations/save-location/widgets/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/components/tab-bar/dynamic_tab_widget.dart';
import '../widgets/profile_card_item_widget.dart';

class VehicleDetailsPage extends StatelessWidget {
  static const String routeName = '/vehicle-details';

  const VehicleDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AppStaticStrings.vehicleDetails),
      body: SingleChildScrollView(
        child: Padding(
          padding: padding16.copyWith(top: 0),
          child: Column(
            spacing: 12.h,
            children: [
              Obx(() {
                final car = DriverSettingsController.to.assignCarModel.value;

                return DriverSettingsController.to.isLoadingCar.value
                    ? buildVehicelImageShimmerRow()
                    : car.carImage == null
                    ? EmptyWidget(text: "No Car Image Found")
                    : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        spacing: 8.w,
                        children: List.generate(
                          car.carImage!.length,
                          (index) => CustomNetworkImage(
                            imageUrl:
                                "${ApiService().baseUrl}/${car.carImage![index]}",
                            radius: 8.r,
                            height: 110.w,
                            width: 110.w,
                          ),
                        ),
                      ),
                    );
              }),
              DynamicTabWidget(
                tabs: DriverSettingsController.to.tabLabels,
                tabContent: [DriverPersonalDetails(), DriverCarInfoWidget()],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DriverCarInfoWidget extends StatelessWidget {
  const DriverCarInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final car = DriverSettingsController.to.assignCarModel.value;
      final isLoading = DriverSettingsController.to.isLoadingCar.value;
      return Column(
        spacing: 8.h,
        children: [
          space8H,
          ProfileCardItemWidget(
            title: AppStaticStrings.licensePlate,
            value: isLoading ? "Loading..." : car.carLicensePlate.toString(),
          ),
          ProfileCardItemWidget(
            title: AppStaticStrings.vin,
            value: isLoading ? "Loading..." : car.vin.toString(),
          ),
          ProfileCardItemWidget(
            title: AppStaticStrings.registrationDate,
            value: isLoading ? "Loading..." : car.registrationDate.toString(),
          ),
          ProfileCardItemWidget(
            title: AppStaticStrings.insuranceStatus,
            value: isLoading ? "Loading..." : car.insuranceStatus.toString(),
          ),
        ],
      );
    });
  }
}

class DriverPersonalDetails extends StatelessWidget {
  const DriverPersonalDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final car = DriverSettingsController.to.assignCarModel.value;
      final isLoading = DriverSettingsController.to.isLoadingCar.value;
      return Column(
        spacing: 8.h,
        children: [
          space8H,
          ProfileCardItemWidget(
            title: AppStaticStrings.carBrand,
            value: isLoading ? "Loading..." : car.brand.toString(),
          ),
          ProfileCardItemWidget(
            title: AppStaticStrings.carModel,
            value: isLoading ? "Loading..." : car.model.toString(),
          ),
          ProfileCardItemWidget(
            title: AppStaticStrings.carType,
            value: isLoading ? "Loading..." : car.type.toString(),
          ),
          ProfileCardItemWidget(
            title: AppStaticStrings.carColor,
            value: isLoading ? "Loading..." : car.color.toString(),
          ),
        ],
      );
    });
  }
}

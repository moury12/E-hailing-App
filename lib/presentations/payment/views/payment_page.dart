import 'package:e_hailing_app/core/components/custom_appbar.dart';
import 'package:e_hailing_app/core/components/custom_button.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/custom_space.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/fontsize_constant.dart';
import 'package:e_hailing_app/core/constants/image_constant.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/core/constants/text_style_constant.dart';
import 'package:e_hailing_app/core/utils/enum.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/driver-dashboard/controllers/dashboard_controller.dart';
import 'package:e_hailing_app/presentations/driver-dashboard/model/driver_current_trip_model.dart';
import 'package:e_hailing_app/presentations/navigation/views/navigation_page.dart';
import 'package:e_hailing_app/presentations/trip/model/trip_response_model.dart';
import 'package:e_hailing_app/presentations/trip/widgets/car_information_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../core/helper/helper_function.dart';
import '../widgets/payment_card_item.dart';

class PaymentPage extends StatelessWidget {
  static const String routeName = '/payment';

  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final arg = Get.arguments;
    DriverCurrentTripModel driverTripResponseModel =
        arg['driver'] ?? DriverCurrentTripModel();
    TripResponseModel userTripResponse = arg['user'] ?? TripResponseModel();
    String role = arg['role'] ?? "";
    logger.i(driverTripResponseModel.toJson().toString());
    // String rent =
    //     "${(driverTripResponseModel.finalFare ?? 0) - (driverTripResponseModel.extraCharge ?? 0)}";
    String rent =
        role == driver
            ? "${driverTripResponseModel.estimatedFare ?? 0}"
            : "${userTripResponse.estimatedFare ?? 0}";
    String? paymentType =
        role == driver ? "${driverTripResponseModel.paymentType ?? 0}" : null;
    String tollFee =
        role == driver
            ? "${driverTripResponseModel.tollFee ?? 0}"
            : "${userTripResponse.tollFee ?? 0}";
    String extraCharge =
        role == driver
            ? "${driverTripResponseModel.extraCharge ?? 0}"
            : "${userTripResponse.extraCharge ?? 0}";
    String finalFee =
        "${double.parse(rent).toInt() + int.parse(tollFee) + int.parse(extraCharge)}";
    return Scaffold(
      appBar: CustomAppBar(title: AppStaticStrings.payment),
      body: SingleChildScrollView(
        child: Padding(
          padding: padding16.copyWith(top: 0),
          child: Center(
            child: Column(
              spacing: 8.h,
              children: [
                SvgPicture.asset(successfulIcon),

                CustomText(
                  text: AppStaticStrings.rideEnded,
                  color: AppColors.kExtraLightBlackColor,
                  style: poppinsRegular,
                  fontSize: getFontSizeSmall(),
                ),
                CustomText(
                  text: AppStaticStrings.arriveOnLocation,

                  style: poppinsBold,
                  fontSize: getFontSizeExtraLarge(),
                ),
                CarInformationWidget(
                  title: AppStaticStrings.rent,
                  value: 'RM $rent',
                ),
                CarInformationWidget(
                  title: AppStaticStrings.tollFee,
                  value: 'RM $tollFee',
                ),
                CarInformationWidget(
                  title: AppStaticStrings.extraCharge,
                  value: 'RM $extraCharge',
                ),
                Divider(color: AppColors.kGreyColor, height: 2, thickness: 2),
                CarInformationWidget(
                  title: AppStaticStrings.totalPayment,
                  value: 'RM $finalFee',
                ),
                space12H,
                if (paymentType != null) buildPaymentItem(paymentType),
                space6H,
                role == driver
                    ? Column(
                      spacing: 8.h,
                      children: [
                        CustomButton(
                          onTap: () {
                            DashBoardController.to.driverTripUpdateStatus(
                              tripId: driverTripResponseModel.sId.toString(),

                              newStatus:
                                  DriverTripStatus.completed.name.toString(),
                            );
                          },
                          title: AppStaticStrings.confirm,
                        ),
                        CustomButton(
                          onTap: () {
                            Get.offAllNamed(
                              NavigationPage.routeName,
                              arguments: {'reconnectSocket': true},
                            );
                          },
                          fillColor: Colors.transparent,
                          textColor: AppColors.kPrimaryColor,
                          title: AppStaticStrings.notYet,
                        ),
                      ],
                    )
                    : SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPaymentItem(String? paymentType) {
    switch (paymentType) {
      case 'cash':
        return PaymentCardItem(
          img: handCashIcon,
          title: AppStaticStrings.handCash,
          onTap: () {
            // handle cash tap
          },
        );

      case 'coin':
        return PaymentCardItem(
          img: coinIcon,
          title: AppStaticStrings.dCoin,
          onTap: () {
            // handle coin tap
          },
        );

      case 'online':
        return PaymentCardItem(
          img: cardsIcon,
          title: AppStaticStrings.creditDebitCards,
          onTap: () {
            // handle online tap
          },
        );

      default:
        return SizedBox.shrink(); // nothing if null or unknown
    }
  }
}

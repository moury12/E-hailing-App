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
import 'package:e_hailing_app/presentations/payment/widgets/coin_dialog_payment_widget.dart';
import 'package:e_hailing_app/presentations/splash/controllers/common_controller.dart';
import 'package:e_hailing_app/presentations/trip/model/trip_response_model.dart';
import 'package:e_hailing_app/presentations/trip/widgets/car_information_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../widgets/payment_card_item.dart';

class PaymentPage extends StatefulWidget {
  static const String routeName = '/payment';

  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late DriverCurrentTripModel driverTripResponseModel;
  late TripResponseModel userTripResponse;
  late String role;
  @override
  void initState() {
    final arg = Get.arguments;
    driverTripResponseModel = arg['driver'] ?? DriverCurrentTripModel();
    userTripResponse = arg['user'] ?? TripResponseModel();
    role = arg['role'] ?? "";
    CommonController.to.isPaid.value =
        role == driver
            ? (driverTripResponseModel.paymentStatus == "paid")
            : (userTripResponse.paymentStatus == "paid");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // String rent =
    //     "${(driverTripResponseModel.finalFare ?? 0) - (driverTripResponseModel.extraCharge ?? 0)}";
    double rentValue =
        role == driver
            ? (driverTripResponseModel.estimatedFare?.toDouble() ?? 0)
            : (userTripResponse.estimatedFare?.toDouble() ?? 0);
    double tollValue =
        role == driver
            ? (driverTripResponseModel.tollFee?.toDouble() ?? 0)
            : (userTripResponse.tollFee?.toDouble() ?? 0);
    double extraValue =
        role == driver
            ? (driverTripResponseModel.extraCharge?.toDouble() ?? 0)
            : (userTripResponse.extraCharge?.toDouble() ?? 0);
    double waitingValue =
        role == driver
            ? (driverTripResponseModel.waitingFee?.toDouble() ?? 0)
            : (userTripResponse.waitingFee?.toDouble() ?? 0);

    String paymentType =
        role == driver
            ? "${driverTripResponseModel.paymentType ?? "cash"}"
            : "${userTripResponse.paymentType ?? "cash"}";

    String rent = "${rentValue.round()}";
    String tollFee =
        tollValue % 1 == 0
            ? tollValue.toInt().toString()
            : tollValue.toStringAsFixed(2);
    // ignore: unused_local_variable
    String extraCharge =
        extraValue % 1 == 0
            ? extraValue.toInt().toString()
            : extraValue.toStringAsFixed(2);
    String waitingFee =
        waitingValue % 1 == 0
            ? waitingValue.toInt().toString()
            : waitingValue.toStringAsFixed(2);

    String finalFee =
        "${(rentValue + tollValue + extraValue + waitingValue).round()}";

    return Scaffold(
      appBar: CustomAppBar(title: AppStaticStrings.payment.tr),
      body: SingleChildScrollView(
        child: Padding(
          padding: padding16.copyWith(top: 0),
          child: Center(
            child: Column(
              spacing: 8.h,
              children: [
                SvgPicture.asset(successfulIcon),

                CustomText(
                  text: AppStaticStrings.rideEnded.tr,
                  color: AppColors.kExtraLightBlackColor,
                  style: poppinsRegular,
                  fontSize: getFontSizeSmall(),
                ),
                CustomText(
                  text: AppStaticStrings.arriveOnLocation.tr,

                  style: poppinsBold,
                  fontSize: getFontSizeExtraLarge(),
                ),
                CarInformationWidget(
                  title: AppStaticStrings.rent.tr,
                  value: 'RM $rent',
                ),
                CarInformationWidget(
                  title: AppStaticStrings.tollFee.tr,
                  value: 'RM $tollFee',
                ),
                // CarInformationWidget(
                //   title: AppStaticStrings.extraCharge.tr,
                //   value: 'RM $extraCharge',
                // ),
                CarInformationWidget(
                  title: AppStaticStrings.waitingFee.tr,
                  value: 'RM $waitingFee',
                ),
                Divider(color: AppColors.kGreyColor, height: 2, thickness: 2),
                CarInformationWidget(
                  title: AppStaticStrings.totalPayment.tr,
                  value: 'RM $finalFee',
                ),
                space12H,

                Obx(() {
                  logger.i("isPaid => ${CommonController.to.isPaid.value}");
                  return CommonController.to.isPaid.value
                      ? PaymentCardItem(
                        img: "assets/icons/toast_check_icon.svg",
                        title: "payment succeeded",
                        onTap: () {
                          // handle cash tap
                        },
                      )
                      : buildPaymentItem(
                        paymentType,
                        finalFee,
                        userTripResponse,
                      );
                }),

                space6H,
                role == driver && paymentType != "online"
                    ? Column(
                      spacing: 8.h,
                      children: [
                        Obx(() {
                          return CustomButton(
                            isLoading:
                                DashBoardController
                                    .to
                                    .isLoadingTripStatus
                                    .value,
                            onTap: () {
                              DashBoardController.to.driverTripUpdateStatus(
                                tripId: driverTripResponseModel.sId.toString(),

                                newStatus:
                                    DriverTripStatus.completed.name.toString(),
                              );
                            },
                            title: AppStaticStrings.confirm.tr,
                          );
                        }),
                        CustomButton(
                          onTap: () {
                            Get.offAllNamed(
                              NavigationPage.routeName,
                              arguments: {'reconnectSocket': true},
                            );
                          },
                          fillColor: Colors.transparent,
                          textColor: AppColors.kPrimaryColor,
                          title: AppStaticStrings.notYet.tr,
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

  Widget buildPaymentItem(
    String? paymentType,
    String? totalFee,
    TripResponseModel userTripResponse,
  ) {
    switch (paymentType) {
      case 'cash':
        return PaymentCardItem(
          img: handCashIcon,
          title: AppStaticStrings.handCash.tr,
          onTap: () {
            // handle cash tap
          },
        );

      case 'coin':
        return PaymentCardItem(
          img: coinIcon,
          title: AppStaticStrings.dCoin.tr,
          onTap: () {
            if (role != driver) {
              Get.dialog(
                DCoinDialogPaymentWidget(
                  tripId: userTripResponse.sId.toString(),
                  extraCost: totalFee ?? "0",
                ),
              );
            }
          },
        );

      case 'online':
        return Obx(() {
          return PaymentCardItem(
            img: cardsIcon,
            isLoading: CommonController.to.isLoadingPayment.value,
            title: AppStaticStrings.creditDebitCards.tr,
            onTap: () {
              if (role != driver) {
                CommonController.to.postPaymentRequest(
                  tripId: userTripResponse.sId,
                );
              }
            },
          );
        });

      default:
        return SizedBox.shrink(); // nothing if null or unknown
    }
  }
}

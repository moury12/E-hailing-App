import 'package:e_hailing_app/core/components/custom_appbar.dart';
import 'package:e_hailing_app/core/components/custom_button.dart';
import 'package:e_hailing_app/core/components/custom_textfield.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/fontsize_constant.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/core/constants/text_style_constant.dart';
import 'package:e_hailing_app/core/helper/helper_function.dart';
import 'package:e_hailing_app/presentations/profile/controllers/account_information_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CashPayoutPage extends StatefulWidget {
  static const String routeName = '/cash-payout';
  const CashPayoutPage({super.key});

  @override
  State<CashPayoutPage> createState() => _CashPayoutPageState();
}

class _CashPayoutPageState extends State<CashPayoutPage> {
  final TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AccountInformationController.to.getPayoutHistoryRequest();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AppStaticStrings.cashPayout.tr),
      body: SingleChildScrollView(
        child: Padding(
          padding: padding14,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRequestSection(),
              SizedBox(height: 20.h),
              CustomText(
                text: AppStaticStrings.payoutHistory.tr,
                style: poppinsSemiBold,
                fontSize: getFontSizeLarge(),
              ),
              SizedBox(height: 10.h),
              _buildHistoryList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRequestSection() {
    return Container(
      padding: padding12,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: AppStaticStrings.requestPayout.tr,
            style: poppinsMedium,
            fontSize: getFontSizeDefault(),
          ),
          SizedBox(height: 12.h),
          CustomTextField(
            textEditingController: amountController,
            hintText: AppStaticStrings.enterAmount.tr,
            keyboardType: TextInputType.number,
            fillColor: AppColors.kWhiteColor,
          ),
          SizedBox(height: 16.h),
          Obx(
            () => CustomButton(
              title: AppStaticStrings.cashOut.tr,
              isLoading: AccountInformationController.to.isLoadingCashOut.value,
              onTap: () async {
                if (amountController.text.isEmpty) return;
                bool isSuccess = await AccountInformationController.to
                    .cashOutRequest(amount: amountController.text);
                if (isSuccess) {
                  amountController.clear();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList() {
    return Obx(() {
      if (AccountInformationController.to.isLoadingCashOutHistory.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (AccountInformationController.to.payoutHistoryList.isEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.only(top: 20.h),
            child: CustomText(
              text: AppStaticStrings.noDataFound.tr,
              color: AppColors.kLightTextColor,
            ),
          ),
        );
      }

      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: AccountInformationController.to.payoutHistoryList.length,
        separatorBuilder: (context, index) => SizedBox(height: 10.h),
        itemBuilder: (context, index) {
          final item = AccountInformationController.to.payoutHistoryList[index];
          return Container(
            padding: padding12,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: AppColors.kBorderColor),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: "${AppStaticStrings.amount.tr}: ${item.amount}",
                      style: poppinsSemiBold,
                    ),
                    SizedBox(height: 4.h),
                    CustomText(
                      text:
                          item.createdAt != null
                              ? formatDateTime(item.createdAt!)
                              : "",
                      fontSize: getFontSizeSmall(),
                      color: AppColors.kLightTextColor,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(item.status),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: CustomText(
                        text: item.status?.toUpperCase() ?? "",
                        color: Colors.white,
                        fontSize: 10.sp,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    CustomText(
                      text: item.paymentMethod ?? "",
                      fontSize: getFontSizeSmall(),
                      color: AppColors.kLightTextColor,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    });
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'approved':
      case 'completed':
        return Colors.green;
      case 'rejected':
      case 'failed':
        return Colors.red;
      default:
        return AppColors.kPrimaryColor;
    }
  }
}

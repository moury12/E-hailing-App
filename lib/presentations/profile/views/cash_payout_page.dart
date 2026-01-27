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
import 'package:e_hailing_app/core/components/custom_refresh_indicator.dart';
import 'package:e_hailing_app/presentations/profile/controllers/account_information_controller.dart';
import 'package:e_hailing_app/presentations/save-location/widgets/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../model/payout_history_model.dart';

class CashPayoutPage extends StatefulWidget {
  static const String routeName = '/cash-payout';
  const CashPayoutPage({super.key});

  @override
  State<CashPayoutPage> createState() => _CashPayoutPageState();
}

class _CashPayoutPageState extends State<CashPayoutPage> {
  final TextEditingController amountController = TextEditingController(
    text: '100',
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AppStaticStrings.cashPayout.tr),
      body: CustomRefreshIndicator(
        onRefresh: () async {
          AccountInformationController.to.payoutPagingController.refresh();
          AccountInformationController.to.getUserProfileRequest();
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: padding14,
                child: Column(
                  spacing: 8,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      spacing: 8,
                      children: [
                        Obx(() {
                          return gridWidget(
                            AppStaticStrings.balance.tr,
                            (AccountInformationController
                                        .to
                                        .userModel
                                        .value
                                        .balance ??
                                    AppStaticStrings.noDataFound.tr)
                                .toString(),
                          );
                        }),
                        Obx(() {
                          return gridWidget(
                            AppStaticStrings.commission.tr,
                            (AccountInformationController
                                        .to
                                        .userModel
                                        .value
                                        .commission ??
                                    AppStaticStrings.noDataFound.tr)
                                .toString(),
                          );
                        }),
                      ],
                    ),
                    Row(
                      children: [
                        Obx(() {
                          return gridWidget(
                            AppStaticStrings.lastPayoutRequest.tr,
                            AccountInformationController
                                        .to
                                        .userModel
                                        .value
                                        .lastPayoutRequest !=
                                    null
                                ? formatDateTime(
                                  AccountInformationController
                                      .to
                                      .userModel
                                      .value
                                      .lastPayoutRequest
                                      .toString(),
                                )
                                : AppStaticStrings.noDataFound.tr,
                          );
                        }),
                      ],
                    ),

                    _buildRequestSection(),

                    CustomText(
                      text: AppStaticStrings.payoutHistory.tr,
                      style: poppinsSemiBold,
                      fontSize: getFontSizeLarge(),
                    ),
                  ],
                ),
              ),
            ),
            PagedSliverList<int, PayoutHistoryModel>(
              // padding: padding1,
              pagingController:
                  AccountInformationController.to.payoutPagingController,
              builderDelegate: PagedChildBuilderDelegate<PayoutHistoryModel>(
                itemBuilder: (context, item, index) {
                  return Padding(
                    padding: paddingH12V4,
                    child: _buildHistoryItem(item),
                  );
                },
                firstPageProgressIndicatorBuilder:
                    (_) => DefaultProgressIndicator(),
                newPageProgressIndicatorBuilder:
                    (_) => DefaultProgressIndicator(),
                noItemsFoundIndicatorBuilder:
                    (_) =>
                        Center(child: EmptyWidget(text: "No history found.")),
                firstPageErrorIndicatorBuilder:
                    (_) => Center(
                      child: EmptyWidget(text: "Failed to load history."),
                    ),
                newPageErrorIndicatorBuilder:
                    (_) => Center(
                      child: EmptyWidget(
                        text: "Failed to load more. Pull to retry.",
                      ),
                    ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 20.h)),
          ],
        ),
      ),
    );
  }

  Expanded gridWidget(String title, String value) {
    return Expanded(
      child: Container(
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
          spacing: 8,
          children: [
            CustomText(
              text: title,
              style: poppinsBold,
              fontSize: getFontSizeDefault(),
              color: AppColors.kPrimaryColor,
            ),
            CustomText(text: value),
          ],
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

  Widget _buildHistoryItem(PayoutHistoryModel item) {
    return Container(
      padding: padding12,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
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
                color: AppColors.kLightBlackColor,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
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
                color: AppColors.kLightBlackColor,
              ),
            ],
          ),
        ],
      ),
    );
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

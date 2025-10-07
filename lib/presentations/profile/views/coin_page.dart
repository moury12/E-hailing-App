import 'package:e_hailing_app/core/components/custom_button.dart';
import 'package:e_hailing_app/core/components/custom_button_tap.dart';
import 'package:e_hailing_app/core/components/custom_refresh_indicator.dart';
import 'package:e_hailing_app/core/components/custom_textfield.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/fontsize_constant.dart';
import 'package:e_hailing_app/core/constants/image_constant.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/core/constants/text_style_constant.dart';
import 'package:e_hailing_app/core/helper/helper_function.dart';
import 'package:e_hailing_app/presentations/profile/controllers/account_information_controller.dart';
import 'package:e_hailing_app/presentations/profile/controllers/d_coin_controller.dart';
import 'package:e_hailing_app/presentations/profile/model/d_coin_model.dart';
import 'package:e_hailing_app/presentations/save-location/widgets/empty_widget.dart';
import 'package:e_hailing_app/presentations/splash/controllers/common_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../core/components/custom_appbar.dart';
import '../../../core/constants/app_static_strings_constant.dart';
import '../../../core/constants/color_constants.dart';
import '../widgets/coin_container_widget.dart';

class CoinPage extends StatelessWidget {
  static const String routeName = '/coin';

  const CoinPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(title: AppStaticStrings.duduCoinWallet),
      body: CustomRefreshIndicator(
        onRefresh: () async {
          DCoinController.to.dCoinsPagingController.refresh();
          // CommonController.to.getUserProfileRequest();
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: padding16,
                child: Column(
                  spacing: 12.h,
                  children: [
                    Obx(() {
                      return CoinWidget(
                        coin:
                        (AccountInformationController.to.userModel.value
                            .coins ?? 0).toString(),
                      );
                    }),
                    CustomButton(
                      onTap: () {
                        Get.dialog(
                          AlertDialog(
                            // scrollable: true,
                            contentPadding: padding12,
                            content: SizedBox(
                              width: Get.width * .8,
                              height: 200.h,
                              child: PagedListView<int, DcoinModel>(
                                // shrinkWrap: true,
                                // primary: false,
                                pagingController:
                                DCoinController
                                    .to
                                    .dCoinsPagingController,
                                builderDelegate: PagedChildBuilderDelegate(
                                  itemBuilder:
                                      (context,
                                      item,
                                      index,) =>
                                      ButtonTapWidget(
                                        onTap: () {
                                          DCoinController.to.selectedPacket
                                              .value = item.sId!;
                                        },
                                        child: Obx(() {
                                          return Padding(
                                            padding: padding6V,
                                            child: CoinWidget(
                                              fillColor: DCoinController.to
                                                  .selectedPacket.value ==
                                                  item.sId.toString()
                                                  ? AppColors
                                                  .kPrimaryExtraLightColor
                                                  : null,
                                              coin: item.coin.toString(),
                                              title:
                                              "RM ${item.mYR.toString()}",
                                            ),
                                          );
                                        }),
                                      ),
                                  firstPageProgressIndicatorBuilder:
                                      (_) =>
                                      DefaultProgressIndicator(),
                                  newPageProgressIndicatorBuilder:
                                      (_) =>
                                      DefaultProgressIndicator(),
                                  noItemsFoundIndicatorBuilder:
                                      (_) =>
                                      Center(
                                        child: EmptyWidget(
                                          text: "No chats found.",
                                        ),
                                      ),
                                  firstPageErrorIndicatorBuilder:
                                      (_) =>
                                      Center(
                                        child: EmptyWidget(
                                          text:
                                          "Failed to load Notifications.",
                                        ),
                                      ),
                                  newPageErrorIndicatorBuilder:
                                      (_) =>
                                      Center(
                                        child: EmptyWidget(
                                          text:
                                          "Failed to load more. Pull to retry.",
                                        ),
                                      ),
                                ),
                              ),
                            ),
                            actions: [Obx(() {
                              return CustomButton(
                                isLoading: CommonController.to.isLoadingPayment
                                    .value,
                                onTap: () {
                                  Get.back();
                                  CommonController.to.postPaymentRequest(
                                      dCoinId: DCoinController.to.selectedPacket
                                          .value);

                                  // showCustomSnackbar(
                                  //   title:
                                  //   AppStaticStrings.featureComingSoon,
                                  //   message:
                                  //   AppStaticStrings
                                  //       .featureNotImplemented,
                                  // );
                                },
                                title: 'Buy Now',
                              );
                            }),
                            ],
                          ),
                        );
                      },
                      img: addIcon,
                      child: Row(
                        spacing: 12.w,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(addWhiteIcon),
                          CustomText(
                            text: AppStaticStrings.addMoreCoin,
                            style: poppinsSemiBold,
                            color: AppColors.kWhiteColor,
                            fontSize: getFontSizeSemiSmall(),
                          ),
                        ],
                      ),
                    ),
                    // CustomTextField(
                    //   title: AppStaticStrings.addCoin,
                    // ),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CoinWidget extends StatelessWidget {
  final String? title;
  final String? coin;
  final Color? fillColor;

  const CoinWidget({super.key, this.title, this.coin, this.fillColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding12,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: fillColor ?? AppColors.kWhiteColor,
        boxShadow: [
          BoxShadow(
            color: AppColors.kExtraLightGreyTextColor.withValues(alpha: .3),
            blurRadius: 6.r,
          ),
        ],
      ),
      child: Row(
        children: [
          CustomText(text: title ?? AppStaticStrings.totalCoin),
          Spacer(),
          CoinContainerWidget(coin: coin,),
        ],
      ),
    );
  }
}

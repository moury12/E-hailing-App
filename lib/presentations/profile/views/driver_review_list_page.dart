import 'package:e_hailing_app/core/components/custom_appbar.dart';
import 'package:e_hailing_app/core/components/custom_refresh_indicator.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/presentations/profile/controllers/account_information_controller.dart';
import 'package:e_hailing_app/presentations/profile/widgets/review_card_widget.dart';
import 'package:e_hailing_app/presentations/save-location/widgets/empty_widget.dart';
import 'package:e_hailing_app/presentations/splash/controllers/common_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DriverReviewListPage extends StatelessWidget {
  const DriverReviewListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Reviews"),
      body: CustomRefreshIndicator(
        onRefresh: () =>
            CommonController.to.getReviewListRequest(
                driverId: AccountInformationController.to.userModel.value.sId
                    .toString()),
        child: Obx(() {
          final isLoading=CommonController.to.isLoadingReview.value;
          return CommonController.to.reviewList.isEmpty?
              EmptyWidget(text: "Review List is Empty!!"): ListView.builder(


            padding: padding12H,
            itemCount:isLoading?4: CommonController.to.reviewList.length,
            itemBuilder: (context, index) {
              return isLoading?ReviewCardShimmer():ReviewCardWidget(
                  reviewModel: CommonController.to.reviewList[index]);
            },);
        }),
      ),);
  }
}

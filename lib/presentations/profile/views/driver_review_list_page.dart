import 'package:e_hailing_app/core/components/custom_appbar.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/presentations/profile/widgets/review_card_widget.dart';
import 'package:e_hailing_app/presentations/splash/controllers/common_controller.dart';
import 'package:flutter/material.dart';

class DriverReviewListPage extends StatelessWidget {
  const DriverReviewListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Reviews"),
body: ListView.builder(
  padding: padding12H,
  itemCount: CommonController.to.reviewList.length,
  itemBuilder: (context, index) {
  return ReviewCardWidget(reviewModel: CommonController.to.reviewList[index]);
},),    );
  }
}

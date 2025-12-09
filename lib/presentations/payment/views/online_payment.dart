import 'package:e_hailing_app/core/components/custom_appbar.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/presentations/splash/controllers/common_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class OnlinePaymentScreen extends StatefulWidget {
  static const String routeName = '/payment';

  const OnlinePaymentScreen({super.key});

  @override
  State<OnlinePaymentScreen> createState() => _OnlinePaymentScreenState();
}

class _OnlinePaymentScreenState extends State<OnlinePaymentScreen> {
  @override
  Widget build(BuildContext context) {
    final commonController = CommonController.to;

    // Initialize WebViewController if not already done
    if (commonController.webController == null) {
      commonController.initializeWebViewController();
    }

    return Scaffold(
      appBar:CustomAppBar( title:AppStaticStrings.payment.tr,),
      body: Stack(
        children: [
          WebViewWidget(controller: commonController.webController!),
          Obx(
                () => commonController.isLoading.value
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
  @override
  void dispose() {
    CommonController.to.webController=null;
    CommonController.to.stripeUrl.value='';
    // TODO: implement dispose
    super.dispose();
  }
}
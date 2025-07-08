import 'package:e_hailing_app/core/api-client/api_endpoints.dart';
import 'package:e_hailing_app/core/components/custom_appbar.dart';
import 'package:e_hailing_app/core/components/custom_button.dart';
import 'package:e_hailing_app/core/components/custom_refresh_indicator.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/presentations/profile/controllers/terms_policy_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';

class TermsPolicyHelpPage extends StatefulWidget {
  static const String routeName = '/terms-policy';

  const TermsPolicyHelpPage({super.key});

  @override
  State<TermsPolicyHelpPage> createState() => _TermsPolicyHelpPageState();
}

class _TermsPolicyHelpPageState extends State<TermsPolicyHelpPage> {
  final arg = Get.arguments;

  @override
  void initState() {
    fetchInitialData();
    super.initState();
  }

  fetchInitialData() {
    if (arg == AppStaticStrings.termsAndCondition) {
      TermsPolicyController.to.getTermsPrivacyRequest(
        endPoint: getTermsEndpoint,
      );
    } else {
      TermsPolicyController.to.getTermsPrivacyRequest(
        endPoint: getPrivacyEndpoint,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: arg),
      body: CustomRefreshIndicator(
        onRefresh: () async {
          fetchInitialData();
        },
        child: Padding(
          padding: padding12,
          child: Obx(() {
            return TermsPolicyController.to.isLoadingTerms.value
                ? DefaultProgressIndicator()
                : HtmlWidget(
                  '''${TermsPolicyController.to.termsModel.value.description}''',
                );
          }),
        ),
      ),
    );
  }
}

import 'package:e_hailing_app/core/components/custom_appbar.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/custom_space.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/fontsize_constant.dart';
import 'package:e_hailing_app/core/constants/image_constant.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/core/constants/text_style_constant.dart';
import 'package:e_hailing_app/core/helper/helper_function.dart';
import 'package:e_hailing_app/presentations/profile/widgets/feedback_content_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FeedbackPage extends StatelessWidget {
  static const String routeName = '/feedback';

  const FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AppStaticStrings.feedback),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: FeedbackContentWidget(
              title: "${AppStaticStrings.mailUs} ()",
              img: mailUsIcon,
              onTap: () {
                launchEmail(
                  "support@yourapp.com",
                  subject: "Help/Support Need For DUDU Car APP"
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: FeedbackContentWidget(
              title: "${AppStaticStrings.contactUs} ()",
              img: whatsappIcon,
              onTap: () {
                launchWhatsApp(
                  "8801712345678",
                  message: "Hello, I need support.",
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

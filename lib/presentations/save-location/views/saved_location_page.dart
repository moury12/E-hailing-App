import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/image_constant.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/core/constants/text_style_constant.dart';
import 'package:e_hailing_app/presentations/save-location/views/add_place_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../core/components/custom_appbar.dart';
import '../widgets/saved_location_item_widget.dart';

class SavedLocationPage extends StatelessWidget {
  static const String routeName = '/save-location';
  const SavedLocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AppStaticStrings.savedLocation),
      body: Column(
        children: [
          ...List.generate(5, (index) => SavedLocationItemWidget(subText: 'Tongi, Bangladesh',),),
          SavedLocationItemWidget(
            trailingImg: addIcon,
            title: AppStaticStrings.addLocation,
            img: saveLocationIcon,
            onTap: () {
Get.toNamed(AddPlacePage.routeName);
            },
          )
        ],
      )
    );
  }
}


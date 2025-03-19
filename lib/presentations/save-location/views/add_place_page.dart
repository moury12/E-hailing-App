import 'package:e_hailing_app/core/components/custom_appbar.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/presentations/save-location/controllers/save_location_controller.dart';
import 'package:e_hailing_app/presentations/save-location/controllers/save_location_controller.dart';
import 'package:e_hailing_app/presentations/save-location/controllers/save_location_controller.dart';
import 'package:e_hailing_app/presentations/save-location/controllers/save_location_controller.dart';
import 'package:e_hailing_app/presentations/save-location/controllers/save_location_controller.dart';
import 'package:e_hailing_app/presentations/save-location/controllers/save_location_controller.dart';
import 'package:flutter/material.dart';


import '../../../core/components/custom_button.dart';
import '../../../core/components/custom_textfield.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/custom_space.dart';
import '../../splash/controllers/common_controller.dart';

class AddPlacePage extends StatelessWidget {
  static const String routeName = '/add-place';
  const AddPlacePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: CustomAppBar(title: AppStaticStrings.addPlace),

    body: SingleChildScrollView(
      child: Padding(
        padding: padding16,
        child: Column(
          children: [
            CustomTextField(
              title: AppStaticStrings.placeAddress,
              textEditingController:
              SaveLocationController.to.searchFieldController.value,
              onChanged: (val) {
                CommonController.to.fetchSuggestedPlaces(val);
              },
              hintText: 'search here...',

            ),
            space12H,
            CommonController.to.isLoadingOnLocationSuggestion.value
                ? DefaultProgressIndicator(
              color: AppColors.kPrimaryColor,
            )
                : Column(
              children: List.generate(
                CommonController.to.addressSuggestion.length,
                    (index) {
                  final address =
                  CommonController.to.addressSuggestion[index];
                  return SearchAddress(
                    onTap: () async {
                      final placeId = address['place_id'];
                      await CommonController.to.getLatLngFromPlace(
                          placeId,
                          lat: SaveLocationController.to.lat,
                          lng: SaveLocationController.to.lng,
                          selectedAddress:
                          SaveLocationController.to.selectedAddress);
                      SaveLocationController
                          .to.searchFieldController.value.text =
                          SaveLocationController.to.selectedAddress.value;

                      CommonController.to.addressSuggestion.clear();

                    },
                    title: address['description'],
                  );
                },
              ),
            ),
            CustomTextField(
              title: AppStaticStrings.placeName,

            ),
            space12H,
            CustomButton(onTap: () {

            },
            title: AppStaticStrings.save,)
          ],
        ),
      ),
    ),);
  }
}
class SearchAddress extends StatelessWidget {
  final Function()? onTap;
  final String title;
  const SearchAddress({
    super.key, this.onTap, required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:onTap ,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: padding12V,
            child: CustomText(
             text:  title ,

            ),
          ),
        Divider()
        ],
      ),
    );
  }
}
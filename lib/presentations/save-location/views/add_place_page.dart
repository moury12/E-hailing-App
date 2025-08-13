import 'package:e_hailing_app/core/components/custom_appbar.dart';
import 'package:e_hailing_app/core/components/custom_button_tap.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/core/service/location-service/location_service.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/save-location/controllers/save_location_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/components/custom_button.dart';
import '../../../core/components/custom_textfield.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/custom_space.dart';
import '../../splash/controllers/common_controller.dart';

class AddPlacePage extends StatelessWidget {
  static const String routeName = '/add-place';

  AddPlacePage({super.key});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AppStaticStrings.addPlace),

      body: SingleChildScrollView(
        child: Padding(
          padding: padding16,
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Obx(() {
                  return CustomTextField(
                    title: AppStaticStrings.placeAddress,
                    textEditingController:
                        SaveLocationController.to.searchFieldController.value,
                    onChanged: (val) {
                      CommonController.to.fetchSuggestedPlacesWithRadius(val);
                    },
                    hintText: 'search here...',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppStaticStrings.placeAddressRequired;
                      }
                      return null;
                    },
                    isRequired: true,
                  );
                }),
                space12H,
                Obx(() {
                  return CommonController.to.isLoadingOnLocationSuggestion.value
                      ? DefaultProgressIndicator(color: AppColors.kPrimaryColor)
                      : Column(
                        children: List.generate(
                          CommonController.to.addressSuggestion.length,
                          (index) {
                            final address =
                                CommonController.to.addressSuggestion[index];
                            return SearchAddress(
                              onTap: () async {
                                var location =
                                    address['geometry']['location'];
                                SaveLocationController.to.lat.value =
                                    location['lat'].toString();
                                SaveLocationController.to.lng.value =
                                    location['lng'].toString();

                                SaveLocationController
                                    .to
                                    .selectedAddress
                                    .value = address['formatted_address'];

                                logger.d("----------------------");
                                logger.d(
                                  SaveLocationController
                                      .to
                                      .selectedAddress
                                      .value,
                                );
                                logger.d(
                                  SaveLocationController
                                      .to
                                      .searchFieldController
                                      .value
                                      .text,
                                );
                                SaveLocationController
                                    .to
                                    .searchFieldController
                                    .value
                                    .text = SaveLocationController
                                        .to
                                        .selectedAddress
                                        .value;
                                CommonController.to.addressSuggestion.clear();
                              },
                              title: address['formatted_address'],
                            );
                          },
                        ),
                      );
                }),
                CustomTextField(
                  title: AppStaticStrings.placeName,
                  textEditingController: SaveLocationController.to.placeName,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppStaticStrings.placeNameRequired;
                    }
                    return null;
                  },
                  isRequired: true,
                ),
                space12H,
                Obx(() {
                  return CustomButton(
                    isLoading:
                        SaveLocationController.to.isLoadingSaveLocation.value,
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        logger.d(SaveLocationController.to.lat.value);
                        SaveLocationController.to.savePlaceRequest(
                          locationName:
                              SaveLocationController.to.placeName.text,
                          locationAddress:
                              SaveLocationController
                                  .to
                                  .searchFieldController
                                  .value
                                  .text,
                          lat: double.parse(
                            SaveLocationController.to.lat.value.toString(),
                          ),
                          lng: double.parse(
                            SaveLocationController.to.lng.value.toString(),
                          ),
                        );
                      }
                    },
                    title: AppStaticStrings.save,
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SearchAddress extends StatelessWidget {
  final Function()? onTap;
  final String title;

  const SearchAddress({super.key, this.onTap, required this.title});

  @override
  Widget build(BuildContext context) {
    return ButtonTapWidget(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: padding6V, child: CustomText(text: title)),
          Divider(),
        ],
      ),
    );
  }
}

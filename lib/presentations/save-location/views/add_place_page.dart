import 'dart:async';

import 'package:e_hailing_app/core/components/custom_appbar.dart';
import 'package:e_hailing_app/core/components/custom_button_tap.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/fontsize_constant.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/core/helper/helper_function.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/save-location/controllers/save_location_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/components/custom_button.dart';
import '../../../core/components/custom_textfield.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/custom_space.dart';
import '../../splash/controllers/common_controller.dart';

class AddPlacePage extends StatefulWidget {
  static const String routeName = '/add-place';

  const AddPlacePage({super.key});

  @override
  State<AddPlacePage> createState() => _AddPlacePageState();
}

class _AddPlacePageState extends State<AddPlacePage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (value.isNotEmpty) {
        CommonController.to.fetchSuggestedPlacesWithRadius(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AppStaticStrings.addPlace.tr),

      body: SingleChildScrollView(
        child: Padding(
          padding: padding16,
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Obx(() {
                  return CustomTextField(
                    title: AppStaticStrings.placeAddress.tr,
                    textEditingController:
                        SaveLocationController.to.searchFieldController.value,
                    onChanged: _onSearchChanged,
                    hintText: 'search here...',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppStaticStrings.placeAddressRequired.tr;
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
                                final String placeId = address['placeId'];
                                final String name = address['name'];

                                // Fetch geometry only for the selected place
                                final latLng = await CommonController.to
                                    .fetchPlaceDetailOnSelect(placeId);

                                if (latLng != null) {
                                  SaveLocationController.to.lat.value =
                                      latLng.latitude.toString();
                                  SaveLocationController.to.lng.value =
                                      latLng.longitude.toString();
                                  SaveLocationController
                                      .to
                                      .selectedAddress
                                      .value = name;
                                  SaveLocationController
                                      .to
                                      .searchFieldController
                                      .value
                                      .text = name;
                                } else {
                                  showCustomSnackbar(
                                    title: "Warning!!",
                                    message:
                                        "This location is outside the service area.",
                                  );
                                }

                                CommonController.to.addressSuggestion.clear();
                              },
                              title: address['name'],
                            );
                          },
                        ),
                      );
                }),
                CustomTextField(
                  title: AppStaticStrings.placeName.tr,
                  textEditingController: SaveLocationController.to.placeName,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppStaticStrings.placeNameRequired.tr;
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
                    title: AppStaticStrings.save.tr,
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
          Padding(
            padding: padding8,
            child: CustomText(
              text: title,
              overflow: TextOverflow.ellipsis,
              fontSize: getFontSizeSmall(),
              maxLines: 2,
            ),
          ),
          Divider(height: 1),
        ],
      ),
    );
  }
}

import 'package:e_hailing_app/core/components/custom_button.dart';
import 'package:e_hailing_app/core/components/custom_refresh_indicator.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/image_constant.dart';
import 'package:e_hailing_app/core/constants/pagination_loading_widget.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/save-location/controllers/save_location_controller.dart';
import 'package:e_hailing_app/presentations/save-location/model/save_location_model.dart';
import 'package:e_hailing_app/presentations/save-location/views/add_place_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../core/components/custom_appbar.dart';
import '../widgets/empty_widget.dart';
import '../widgets/saved_location_item_widget.dart';
import '../widgets/shimmer_save_location_item_widget.dart';

class SavedLocationPage extends StatefulWidget {
  static const String routeName = '/save-location';

  const SavedLocationPage({super.key});

  @override
  State<SavedLocationPage> createState() => _SavedLocationPageState();
}

class _SavedLocationPageState extends State<SavedLocationPage> {
  final arg = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AppStaticStrings.savedLocation),
      body: CustomRefreshIndicator(
        onRefresh: () async{
          SaveLocationController.to.saveLocationPagingController.refresh();
        },
        child: Column(
          children: [
            SavedLocationItemWidget(
              saveLocationModel: SaveLocationModel(),
              trailingImg: addIcon,
              title: AppStaticStrings.addLocation,
              img: saveLocationIcon,
              onTap: () => Get.toNamed(AddPlacePage.routeName),
            ),
            Expanded(
              child: PagedListView<int, SaveLocationModel>(
                pagingController:
                SaveLocationController.to.saveLocationPagingController,
                builderDelegate: PagedChildBuilderDelegate<SaveLocationModel>(
                  itemBuilder: (context, item, index) {
                    return SavedLocationItemWidget(
                      saveLocationModel: item,
                      isLoading: SaveLocationController
                          .to.isLoadingSpecificSaveLocation.value,
                      onTap: arg != null && arg == fromHome
                          ? () {
                        SaveLocationController.to
                            .selectLatlngFromSaveLocation(
                          id: item.sId.toString(),
                        );
                      }
                          : null,
                    );
                  }, firstPageProgressIndicatorBuilder:
                    (_) => Column(
                      children: List.generate(6, (index) =>  shimmerSavedLocationItem(),),
                    ),

                  // Show when loading next page
                  newPageProgressIndicatorBuilder: (_) => DefaultProgressIndicator(),
                  firstPageErrorIndicatorBuilder: (_) => CustomText(text: 'Failed to load'),
                  noItemsFoundIndicatorBuilder: (_) => EmptyWidget(
                      text: "Saved Location not available!!"),

                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

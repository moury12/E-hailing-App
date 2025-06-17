import 'package:e_hailing_app/core/components/custom_refresh_indicator.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/image_constant.dart';
import 'package:e_hailing_app/core/constants/pagination_loading_widget.dart';
import 'package:e_hailing_app/presentations/save-location/controllers/save_location_controller.dart';
import 'package:e_hailing_app/presentations/save-location/model/save_location_model.dart';
import 'package:e_hailing_app/presentations/save-location/views/add_place_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/components/custom_appbar.dart';
import '../widgets/saved_location_item_widget.dart';

class SavedLocationPage extends StatefulWidget {
  static const String routeName = '/save-location';

  const SavedLocationPage({super.key});

  @override
  State<SavedLocationPage> createState() => _SavedLocationPageState();
}

class _SavedLocationPageState extends State<SavedLocationPage> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        SaveLocationController.to.getSaveLocationListRequest(loadMore: true);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AppStaticStrings.savedLocation),
      body: CustomRefreshIndicator(
        onRefresh: () {
          return SaveLocationController.to.getSaveLocationListRequest();
        },
        child: CustomScrollView(
          controller: scrollController,
          physics: AlwaysScrollableScrollPhysics(),

          slivers: [
            SliverToBoxAdapter(
              child: SavedLocationItemWidget(
                saveLocationModel: SaveLocationModel(),
                trailingImg: addIcon,
                title: AppStaticStrings.addLocation,
                img: saveLocationIcon,
                onTap: () {
                  Get.toNamed(AddPlacePage.routeName);
                },
              ),
            ),
            Obx(() {
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: SaveLocationController.to.saveLocationList.length,
                  (context, index) {
                    return SavedLocationItemWidget(
                      saveLocationModel:
                          SaveLocationController.to.saveLocationList[index],
                    );
                  },
                ),
              );
            }),
            SliverToBoxAdapter(
              child: Obx(() {
                return SaveLocationController.to.isLoadingMore.value
                    ? PaginationLoadingWidget()
                    : SizedBox.shrink();
              }),
            ),
          ],
        ),
      ),
    );
  }
}

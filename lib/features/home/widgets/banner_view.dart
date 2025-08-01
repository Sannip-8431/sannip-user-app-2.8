import 'package:carousel_slider/carousel_slider.dart';
import 'package:sannip/features/banner/controllers/banner_controller.dart';
import 'package:sannip/features/item/controllers/item_controller.dart';
import 'package:sannip/features/splash/controllers/splash_controller.dart';
import 'package:sannip/features/item/domain/models/basic_campaign_model.dart';
import 'package:sannip/features/item/domain/models/item_model.dart';
import 'package:sannip/common/models/module_model.dart';
import 'package:sannip/features/store/domain/models/store_model.dart';
import 'package:sannip/features/location/domain/models/zone_response_model.dart';
import 'package:sannip/helper/address_helper.dart';
import 'package:sannip/helper/route_helper.dart';
import 'package:sannip/util/dimensions.dart';
import 'package:sannip/common/widgets/custom_image.dart';
import 'package:sannip/common/widgets/custom_snackbar.dart';
import 'package:sannip/features/store/screens/store_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:url_launcher/url_launcher_string.dart';

class BannerView extends StatelessWidget {
  final bool isFeatured;
  const BannerView({
    super.key,
    required this.isFeatured,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BannerController>(builder: (bannerController) {
      List<String?>? bannerList = isFeatured
          ? bannerController.featuredBannerList
          : bannerController.bannerImageList;
      List<dynamic>? bannerDataList = isFeatured
          ? bannerController.featuredBannerDataList
          : bannerController.bannerDataList;

      return (bannerList != null && bannerList.isEmpty)
          ? const SizedBox()
          : Container(
              margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              width: MediaQuery.of(context).size.width,
              height: GetPlatform.isDesktop
                  ? 500
                  : MediaQuery.of(context).size.width * 0.38,
              child: bannerList != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: CarouselSlider.builder(
                            options: CarouselOptions(
                              autoPlay: true,
                              enlargeCenterPage: true,
                              disableCenter: true,
                              viewportFraction: 0.8,
                              autoPlayInterval: const Duration(seconds: 7),
                              onPageChanged: (index, reason) {
                                bannerController.setCurrentIndex(index, true);
                              },
                            ),
                            itemCount:
                                bannerList.isEmpty ? 1 : bannerList.length,
                            itemBuilder: (context, index, _) {
                              return InkWell(
                                onTap: () async {
                                  if (bannerDataList![index] is Item) {
                                    Item? item = bannerDataList[index];
                                    Get.find<ItemController>()
                                        .navigateToItemPage(item, context);
                                  } else if (bannerDataList[index] is Store) {
                                    Store? store = bannerDataList[index];
                                    if (isFeatured &&
                                        (AddressHelper.getUserAddressFromSharedPref()!
                                                    .zoneData !=
                                                null &&
                                            AddressHelper
                                                    .getUserAddressFromSharedPref()!
                                                .zoneData!
                                                .isNotEmpty)) {
                                      for (ModuleModel module
                                          in Get.find<SplashController>()
                                              .moduleList!) {
                                        if (module.id == store!.moduleId) {
                                          Get.find<SplashController>()
                                              .setModule(module);
                                          break;
                                        }
                                      }
                                      ZoneData zoneData = AddressHelper
                                              .getUserAddressFromSharedPref()!
                                          .zoneData!
                                          .firstWhere((data) =>
                                              data.id == store!.zoneId);

                                      Modules module = zoneData.modules!
                                          .firstWhere((module) =>
                                              module.id == store!.moduleId);
                                      Get.find<SplashController>().setModule(
                                          ModuleModel(
                                              id: module.id,
                                              moduleName: module.moduleName,
                                              moduleType: module.moduleType,
                                              themeId: module.themeId,
                                              storesCount: module.storesCount));
                                    }
                                    Get.toNamed(
                                      RouteHelper.getStoreRoute(
                                          id: store!.id,
                                          page:
                                              isFeatured ? 'module' : 'banner'),
                                      arguments: StoreScreen(
                                          store: store, fromModule: isFeatured),
                                    );
                                  } else if (bannerDataList[index]
                                      is BasicCampaignModel) {
                                    BasicCampaignModel campaign =
                                        bannerDataList[index];
                                    Get.toNamed(
                                        RouteHelper.getBasicCampaignRoute(
                                            campaign));
                                  } else {
                                    String url = bannerDataList[index];
                                    if (await canLaunchUrlString(url)) {
                                      await launchUrlString(url,
                                          mode: LaunchMode.externalApplication);
                                    } else {
                                      showCustomSnackBar(
                                          'unable_to_found_url'.tr);
                                    }
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.radiusLarge),
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 5,
                                          spreadRadius: 0)
                                    ],
                                  ),
                                  child: GetBuilder<SplashController>(
                                      builder: (splashController) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.radiusLarge),
                                      child: CustomImage(
                                        image: '${bannerList[index]}',
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                  }),
                                ),
                              );
                            },
                          ),
                        ),
                        /*const SizedBox(
                            height: Dimensions.paddingSizeExtraSmall),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: bannerList.map((bnr) {
                            int index = bannerList.indexOf(bnr);
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              height: 10,
                              width: 10,
                              decoration: BoxDecoration(
                                color: index == bannerController.currentIndex
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context).disabledColor,
                                shape: BoxShape.circle,
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(
                            height: Dimensions.paddingSizeExtraSmall),*/
                      ],
                    )
                  : Shimmer(
                      duration: const Duration(seconds: 2),
                      enabled: bannerList == null,
                      child: Container(
                        color: Colors.grey[300],
                      ),
                    ),
            );
      /*Container(
                  width: MediaQuery.of(context).size.width,
                  height: GetPlatform.isDesktop
                      ? 500
                      : MediaQuery.of(context).size.width * 0.45,
                  padding:
                      const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
                  child: bannerList != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: CarouselSlider.builder(
                                options: CarouselOptions(
                                  autoPlay: true,
                                  enlargeCenterPage: true,
                                  disableCenter: true,
                                  viewportFraction: 0.8,
                                  autoPlayInterval: const Duration(seconds: 7),
                                  onPageChanged: (index, reason) {
                                    bannerController.setCurrentIndex(
                                        index, true);
                                  },
                                ),
                                itemCount:
                                    bannerList.isEmpty ? 1 : bannerList.length,
                                itemBuilder: (context, index, _) {
                                  return InkWell(
                                    onTap: () async {
                                      if (bannerDataList![index] is Item) {
                                        Item? item = bannerDataList[index];
                                        Get.find<ItemController>()
                                            .navigateToItemPage(item, context);
                                      } else if (bannerDataList[index]
                                          is Store) {
                                        Store? store = bannerDataList[index];
                                        if (isFeatured &&
                                            (AddressHelper.getUserAddressFromSharedPref()!
                                                        .zoneData !=
                                                    null &&
                                                AddressHelper
                                                        .getUserAddressFromSharedPref()!
                                                    .zoneData!
                                                    .isNotEmpty)) {
                                          for (ModuleModel module
                                              in Get.find<SplashController>()
                                                  .moduleList!) {
                                            if (module.id == store!.moduleId) {
                                              Get.find<SplashController>()
                                                  .setModule(module);
                                              break;
                                            }
                                          }
                                          ZoneData zoneData = AddressHelper
                                                  .getUserAddressFromSharedPref()!
                                              .zoneData!
                                              .firstWhere((data) =>
                                                  data.id == store!.zoneId);

                                          Modules module = zoneData.modules!
                                              .firstWhere((module) =>
                                                  module.id == store!.moduleId);
                                          Get.find<SplashController>()
                                              .setModule(ModuleModel(
                                                  id: module.id,
                                                  moduleName: module.moduleName,
                                                  moduleType: module.moduleType,
                                                  themeId: module.themeId,
                                                  storesCount:
                                                      module.storesCount));
                                        }
                                        Get.toNamed(
                                          RouteHelper.getStoreRoute(
                                              id: store!.id,
                                              page: isFeatured
                                                  ? 'module'
                                                  : 'banner'),
                                          arguments: StoreScreen(
                                              store: store,
                                              fromModule: isFeatured),
                                        );
                                      } else if (bannerDataList[index]
                                          is BasicCampaignModel) {
                                        BasicCampaignModel campaign =
                                            bannerDataList[index];
                                        Get.toNamed(
                                            RouteHelper.getBasicCampaignRoute(
                                                campaign));
                                      } else {
                                        String url = bannerDataList[index];
                                        if (await canLaunchUrlString(url)) {
                                          await launchUrlString(url,
                                              mode: LaunchMode
                                                  .externalApplication);
                                        } else {
                                          showCustomSnackBar(
                                              'unable_to_found_url'.tr);
                                        }
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).cardColor,
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.radiusDefault),
                                        boxShadow: const [
                                          BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 5,
                                              spreadRadius: 0)
                                        ],
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                          vertical:
                                              Dimensions.paddingSizeExtraSmall),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.radiusDefault),
                                        child: GetBuilder<SplashController>(
                                            builder: (splashController) {
                                          return CustomImage(
                                            image: '${bannerList[index]}',
                                            fit: BoxFit.cover,
                                          );
                                        }),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(
                                height: Dimensions.paddingSizeExtraSmall),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: bannerList.map((bnr) {
                                int index = bannerList.indexOf(bnr);
                                int totalBanner = bannerList.length;
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 3),
                                  child: index == bannerController.currentIndex
                                      ? Container(
                                          decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimensions
                                                          .radiusDefault)),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4, vertical: 1),
                                          child: Text(
                                              '${(index) + 1}/$totalBanner',
                                              style: robotoRegular.copyWith(
                                                  color: Theme.of(context)
                                                      .cardColor,
                                                  fontSize: 12)),
                                        )
                                      : Container(
                                          height: 5,
                                          width: 6,
                                          decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .primaryColor
                                                  .withOpacity(0.5),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimensions
                                                          .radiusDefault)),
                                        ),
                                );
                              }).toList(),
                            ),
                          ],
                        )
                      : Shimmer(
                          duration: const Duration(seconds: 2),
                          enabled: bannerList == null,
                          child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    Dimensions.radiusSmall),
                                color: Colors.grey[300],
                              )),
                        ),
                )*/
    });
  }
}

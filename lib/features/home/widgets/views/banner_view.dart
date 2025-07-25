import 'package:carousel_slider/carousel_slider.dart';
import 'package:sannip/features/banner/controllers/banner_controller.dart';
import 'package:sannip/features/item/controllers/item_controller.dart';
import 'package:sannip/features/splash/controllers/splash_controller.dart';
import 'package:sannip/features/item/domain/models/basic_campaign_model.dart';
import 'package:sannip/features/item/domain/models/item_model.dart';
import 'package:sannip/common/models/module_model.dart';
import 'package:sannip/features/store/domain/models/store_model.dart';
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
  const BannerView({super.key, required this.isFeatured});

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
              width: MediaQuery.of(context).size.width,
              height: GetPlatform.isDesktop
                  ? 500
                  : MediaQuery.of(context).size.width * 0.38,
              margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
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
                                        Get.find<SplashController>()
                                                .moduleList !=
                                            null) {
                                      for (ModuleModel module
                                          in Get.find<SplashController>()
                                              .moduleList!) {
                                        if (module.id == store!.moduleId) {
                                          Get.find<SplashController>()
                                              .setModule(module);
                                          break;
                                        }
                                      }
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
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.radiusLarge),
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
                        /* const SizedBox(
                            height: Dimensions.paddingSizeExtraSmall),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:
                              bannerController.bannerImageList!.map((bnr) {
                            int index =
                                bannerController.bannerImageList!.indexOf(bnr);
                            // int totalBanner =
                            //     bannerController.bannerImageList!.length;
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
    });
  }
}

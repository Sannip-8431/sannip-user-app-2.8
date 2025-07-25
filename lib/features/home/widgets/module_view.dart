import 'package:cached_network_image/cached_network_image.dart';
import 'package:sannip/util/images.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sannip/common/widgets/address_widget.dart';
import 'package:sannip/common/widgets/custom_ink_well.dart';
import 'package:sannip/features/banner/controllers/banner_controller.dart';
import 'package:sannip/features/location/controllers/location_controller.dart';
import 'package:sannip/features/splash/controllers/splash_controller.dart';
import 'package:sannip/features/address/controllers/address_controller.dart';
import 'package:sannip/features/address/domain/models/address_model.dart';
import 'package:sannip/helper/address_helper.dart';
import 'package:sannip/helper/auth_helper.dart';
import 'package:sannip/helper/responsive_helper.dart';
import 'package:sannip/util/dimensions.dart';
import 'package:sannip/util/styles.dart';
import 'package:sannip/common/widgets/custom_loader.dart';
import 'package:sannip/common/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sannip/features/home/widgets/banner_view.dart';
import 'package:sannip/features/home/widgets/popular_store_view.dart';

class ModuleView extends StatelessWidget {
  final SplashController splashController;
  final String? searchedText;
  const ModuleView(
      {super.key, required this.splashController, this.searchedText});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      GetBuilder<BannerController>(builder: (bannerController) {
        return const BannerView(isFeatured: true);
      }),
      splashController.moduleList != null
          ? splashController.moduleList!.isNotEmpty
              ? GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: Dimensions.paddingSizeSmall,
                    crossAxisSpacing: Dimensions.paddingSizeSmall,
                    childAspectRatio: (1 / 1),
                  ),
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  itemCount: splashController.moduleList!.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(Dimensions.radiusDefault),
                        color: Theme.of(context).cardColor,
                        border: Border.all(
                            color: Theme.of(context).primaryColor, width: 0.15),
                        boxShadow: [
                          BoxShadow(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 3)
                        ],
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: CachedNetworkImageProvider(
                            splashController.moduleList![index].iconFullUrl !=
                                    null
                                ? '${splashController.moduleList![index].iconFullUrl}'
                                : Images.placeholder,
                            errorListener: (error) => Image.asset(
                                Images.placeholder,
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover),
                            // maxHeight: 50,
                            // maxWidth: 50,
                          ),
                        ),
                      ),
                      child: CustomInkWell(
                        onTap: () => splashController.switchModule(index, true),
                        radius: Dimensions.radiusDefault,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ClipRRect(
                              //   borderRadius: BorderRadius.circular(
                              //       Dimensions.radiusSmall),
                              //   child: CustomImage(
                              //     image:
                              //         '${splashController.moduleList![index].iconFullUrl}',
                              //     height: 50,
                              //     width: 50,
                              //   ),
                              // ),
                              // const SizedBox(
                              //     height: Dimensions.paddingSizeSmall),
                              Padding(
                                  padding: const EdgeInsets.only(
                                      top: Dimensions.paddingSizeSmall,
                                      left: Dimensions.paddingSizeExtraSmall),
                                  child: Text(
                                    splashController
                                        .moduleList![index].moduleName!,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: robotoMedium.copyWith(
                                        fontSize: Dimensions.fontSizeSmall),
                                  )),
                            ]),
                      ),
                    );
                  },
                )
              : Center(
                  child: Padding(
                  padding:
                      const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                  child: Text('no_module_found'.tr),
                ))
          : ModuleShimmer(isEnabled: splashController.moduleList == null),
      GetBuilder<AddressController>(builder: (locationController) {
        List<AddressModel?> addressList = [];
        if (AuthHelper.isLoggedIn() && locationController.addressList != null) {
          addressList = [];
          bool contain = false;
          if (AddressHelper.getUserAddressFromSharedPref()!.id != null) {
            for (int index = 0;
                index < locationController.addressList!.length;
                index++) {
              if (locationController.addressList![index].id ==
                  AddressHelper.getUserAddressFromSharedPref()!.id) {
                contain = true;
                break;
              }
            }
          }
          if (!contain) {
            addressList.add(AddressHelper.getUserAddressFromSharedPref());
          }
          addressList.addAll(locationController.addressList!);
        }
        return (!AuthHelper.isLoggedIn() ||
                locationController.addressList != null)
            ? addressList.isNotEmpty
                ? Column(
                    children: [
                      const SizedBox(height: Dimensions.paddingSizeLarge),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeSmall),
                        child: TitleWidget(title: 'deliver_to'.tr),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                      SizedBox(
                        height: 80,
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: addressList.length,
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(
                              left: Dimensions.paddingSizeSmall,
                              right: Dimensions.paddingSizeSmall,
                              top: Dimensions.paddingSizeExtraSmall),
                          itemBuilder: (context, index) {
                            return Container(
                              width: 300,
                              padding: const EdgeInsets.only(
                                  right: Dimensions.paddingSizeSmall),
                              child: AddressWidget(
                                address: addressList[index],
                                fromAddress: false,
                                onTap: () {
                                  if (AddressHelper
                                              .getUserAddressFromSharedPref()!
                                          .id !=
                                      addressList[index]!.id) {
                                    Get.dialog(const CustomLoader(),
                                        barrierDismissible: false);
                                    Get.find<LocationController>()
                                        .saveAddressAndNavigate(
                                      addressList[index],
                                      false,
                                      null,
                                      false,
                                      ResponsiveHelper.isDesktop(context),
                                    );
                                  }
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  )
                : const SizedBox()
            : AddressShimmer(
                isEnabled: AuthHelper.isLoggedIn() &&
                    locationController.addressList == null);
      }),
      PopularStoreView(
          isPopular: false, isFeatured: true, searchedText: searchedText),
      const SizedBox(height: 40),
    ]);
  }
}

class ModuleShimmer extends StatelessWidget {
  final bool isEnabled;
  const ModuleShimmer({super.key, required this.isEnabled});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: Dimensions.paddingSizeSmall,
        crossAxisSpacing: Dimensions.paddingSizeSmall,
        childAspectRatio: (1 / 1),
      ),
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      itemCount: 6,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            color: Theme.of(context).cardColor,
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)
            ],
          ),
          child: Shimmer(
            duration: const Duration(seconds: 2),
            enabled: isEnabled,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    color: Colors.grey[300]),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              Center(
                  child: Container(
                      height: 15, width: 50, color: Colors.grey[300])),
            ]),
          ),
        );
      },
    );
  }
}

class AddressShimmer extends StatelessWidget {
  final bool isEnabled;
  const AddressShimmer({super.key, required this.isEnabled});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: Dimensions.paddingSizeLarge),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeSmall),
          child: TitleWidget(title: 'deliver_to'.tr),
        ),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
        SizedBox(
          height: 70,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: 5,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeSmall),
            itemBuilder: (context, index) {
              return Container(
                width: 300,
                padding:
                    const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                child: Container(
                  padding: EdgeInsets.all(ResponsiveHelper.isDesktop(context)
                      ? Dimensions.paddingSizeDefault
                      : Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black12, blurRadius: 5, spreadRadius: 1)
                    ],
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(
                      Icons.location_on,
                      size: ResponsiveHelper.isDesktop(context) ? 50 : 40,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),
                    Expanded(
                      child: Shimmer(
                        duration: const Duration(seconds: 2),
                        enabled: isEnabled,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  height: 15,
                                  width: 100,
                                  color: Colors.grey[300]),
                              const SizedBox(
                                  height: Dimensions.paddingSizeExtraSmall),
                              Container(
                                  height: 10,
                                  width: 150,
                                  color: Colors.grey[300]),
                            ]),
                      ),
                    ),
                  ]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

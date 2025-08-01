import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sannip/common/widgets/custom_ink_well.dart';
import 'package:sannip/common/widgets/custom_snackbar.dart';
import 'package:sannip/features/favourite/controllers/favourite_controller.dart';
import 'package:sannip/features/language/controllers/language_controller.dart';
import 'package:sannip/features/splash/controllers/splash_controller.dart';
import 'package:sannip/features/store/controllers/store_controller.dart';
import 'package:sannip/features/store/domain/models/store_model.dart';
import 'package:sannip/helper/auth_helper.dart';
import 'package:sannip/helper/responsive_helper.dart';
import 'package:sannip/helper/route_helper.dart';
import 'package:sannip/util/app_constants.dart';
import 'package:sannip/util/dimensions.dart';
import 'package:sannip/util/styles.dart';
import 'package:sannip/common/widgets/custom_image.dart';
import 'package:sannip/features/store/screens/store_screen.dart';

class VisitAgainCard extends StatelessWidget {
  final Store store;
  final bool fromFood;
  const VisitAgainCard(
      {super.key, required this.store, required this.fromFood});

  @override
  Widget build(BuildContext context) {
    bool isPharmacy = Get.find<SplashController>().module != null &&
        Get.find<SplashController>().module!.moduleType.toString() ==
            AppConstants.pharmacy;
    bool isFood = Get.find<SplashController>().module != null &&
        Get.find<SplashController>().module!.moduleType.toString() ==
            AppConstants.food;
    double distance = Get.find<StoreController>().getRestaurantDistance(
      LatLng(double.parse(store.latitude!), double.parse(store.longitude!)),
    );

    return ResponsiveHelper.isDesktop(context)
        ? Stack(children: [
            Container(
              margin: const EdgeInsets.only(
                  top: Dimensions.paddingSizeLarge,
                  bottom: Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                color: Theme.of(context).cardColor,
                border: Border.all(
                    color: Theme.of(context).primaryColor.withOpacity(0.2),
                    width: 1),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12, blurRadius: 5, spreadRadius: 1)
                ],
              ),
              child: CustomInkWell(
                onTap: () {
                  Get.toNamed(
                    RouteHelper.getStoreRoute(id: store.id, page: 'store'),
                    arguments: StoreScreen(store: store, fromModule: false),
                  );
                },
                radius: Dimensions.radiusDefault,
                padding: const EdgeInsets.only(
                    top: 40, bottom: Dimensions.paddingSizeSmall),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                          child: Text(store.name ?? '',
                              style: robotoBold,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis)),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.star,
                                size: 15,
                                color: Theme.of(context).primaryColor),
                            const SizedBox(
                                width: Dimensions.paddingSizeExtraSmall),
                            Text(store.avgRating!.toStringAsFixed(1),
                                style: robotoRegular),
                            const SizedBox(
                                width: Dimensions.paddingSizeExtraSmall),
                            Text("(${store.ratingCount})",
                                style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall,
                                    color: Theme.of(context).disabledColor)),
                          ]),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeSmall),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.storefront_outlined,
                                  size: 20,
                                  color: Theme.of(context).disabledColor),
                              const SizedBox(
                                  width: Dimensions.paddingSizeExtraSmall),
                              Flexible(
                                child: Text(
                                  store.address ?? '',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: robotoRegular.copyWith(
                                      color: Theme.of(context).disabledColor),
                                ),
                              ),
                            ]),
                      ),
                      store.items != null
                          ? Container(
                              alignment: Alignment.center,
                              height: 25,
                              width: 200,
                              child: ListView.builder(
                                itemCount: store.items!.length,
                                scrollDirection: Axis.horizontal,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        right:
                                            Dimensions.paddingSizeExtraSmall),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              (isPharmacy || isFood)
                                                  ? 100
                                                  : Dimensions.radiusSmall),
                                          child: CustomImage(
                                            image:
                                                '${store.items![index].imageFullUrl}',
                                            fit: BoxFit.cover,
                                            height: 25,
                                            width: 25,
                                          ),
                                        ),
                                        index == store.items!.length - 1
                                            ? Positioned(
                                                top: 0,
                                                left: 0,
                                                right: 0,
                                                bottom: 0,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius
                                                        .circular((isPharmacy ||
                                                                isFood)
                                                            ? 100
                                                            : Dimensions
                                                                .radiusSmall),
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                  ),
                                                  child: Center(
                                                      child: Text(
                                                    (store.itemCount! > 20)
                                                        ? '20+'
                                                        : '${store.itemCount}',
                                                    style: robotoMedium.copyWith(
                                                        color: Colors.white,
                                                        fontSize: Dimensions
                                                            .fontSizeExtraSmall),
                                                  )),
                                                ),
                                              )
                                            : const SizedBox(),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            )
                          : const SizedBox(),
                    ]),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 54,
                width: 54,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      fromFood ? 100 : Dimensions.radiusDefault),
                  color: Theme.of(context).cardColor,
                  border: Border.all(
                      color: Theme.of(context).primaryColor.withOpacity(0.2),
                      width: 2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                      fromFood ? 100 : Dimensions.radiusDefault),
                  child: CustomImage(
                    image: '${store.coverPhotoFullUrl}',
                    fit: BoxFit.cover,
                    height: 54,
                    width: 54,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 30,
              left: Get.find<LocalizationController>().isLtr ? null : 10,
              right: Get.find<LocalizationController>().isLtr ? 10 : null,
              child: GetBuilder<FavouriteController>(
                  builder: (favouriteController) {
                bool isWished =
                    favouriteController.wishStoreIdList.contains(store.id);
                return InkWell(
                  onTap: () {
                    if (AuthHelper.isLoggedIn()) {
                      isWished
                          ? favouriteController.removeFromFavouriteList(
                              store.id, true)
                          : favouriteController.addToFavouriteList(
                              null, store, true);
                    } else {
                      showCustomSnackBar('you_are_not_logged_in'.tr);
                    }
                  },
                  child: Icon(
                    isWished ? Icons.favorite : Icons.favorite_border,
                    size: 20,
                    color: Theme.of(context).primaryColor,
                  ),
                );
              }),
            ),
          ])
        : Container(
            width: 250,
            margin: const EdgeInsets.only(
                top: Dimensions.paddingSizeLarge,
                bottom: Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
              color: Theme.of(context).cardColor,
            ),
            child: CustomInkWell(
              onTap: () {
                Get.toNamed(
                  RouteHelper.getStoreRoute(id: store.id, page: 'store'),
                  arguments: StoreScreen(store: store, fromModule: false),
                );
              },
              child: Column(children: [
                Expanded(
                  flex: 6,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(Dimensions.radiusLarge),
                            topLeft: Radius.circular(Dimensions.radiusLarge)),
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            Get.find<StoreController>().isOpenNow(store)
                                ? Colors.transparent
                                : Colors.grey,
                            BlendMode.saturation,
                          ),
                          child: CustomImage(
                            image: '${store.coverPhotoFullUrl}',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 5,
                        right: 5,
                        child: GetBuilder<FavouriteController>(
                            builder: (favouriteController) {
                          bool isWished = favouriteController.wishStoreIdList
                              .contains(store.id);
                          return InkWell(
                            onTap: () {
                              if (AuthHelper.isLoggedIn()) {
                                isWished
                                    ? favouriteController
                                        .removeFromFavouriteList(store.id, true)
                                    : favouriteController.addToFavouriteList(
                                        null, store, true);
                              } else {
                                showCustomSnackBar('you_are_not_logged_in'.tr);
                              }
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 5,
                                      spreadRadius: 1,
                                    )
                                  ]),
                              padding: const EdgeInsets.all(3),
                              child: Icon(
                                isWished
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                size: 20,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeExtraSmall),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                                flex: 8,
                                child: Text(store.name ?? '',
                                    style: robotoBold.copyWith(
                                        fontSize:
                                            Dimensions.fontSizeExtraLarge),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis)),
                            Expanded(
                              flex: 4,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(Icons.star,
                                        size: 15,
                                        color: Theme.of(context).primaryColor),
                                    const SizedBox(
                                        width:
                                            Dimensions.paddingSizeExtraSmall),
                                    Text(store.avgRating!.toStringAsFixed(1),
                                        style: robotoRegular),
                                    const SizedBox(
                                        width:
                                            Dimensions.paddingSizeExtraSmall),
                                    Text("(${store.ratingCount})",
                                        style: robotoRegular.copyWith(
                                            fontSize: Dimensions.fontSizeSmall,
                                            color: Theme.of(context)
                                                .disabledColor)),
                                  ]),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                '${distance > 100 ? '100+' : distance.toStringAsFixed(2)} ${'km'.tr}',
                                style: robotoRegular.copyWith(
                                    color: Theme.of(context).disabledColor),
                              ),
                            ),
                            Row(children: [
                              Icon(Icons.timer_outlined,
                                  size: 18,
                                  color: Theme.of(context).disabledColor),
                              const SizedBox(
                                  width: Dimensions.paddingSizeExtraSmall),
                              Text(
                                '${store.deliveryTime}',
                                style: robotoRegular.copyWith(
                                    color: Theme.of(context).disabledColor),
                              ),
                            ]),
                          ],
                        ),
                        Row(children: [
                          Icon(Icons.location_on_outlined,
                              size: 18, color: Theme.of(context).disabledColor),
                          const SizedBox(
                              width: Dimensions.paddingSizeExtraSmall),
                          Flexible(
                            child: Text(
                              store.address ?? '',
                              style: robotoRegular.copyWith(
                                  color: Theme.of(context).disabledColor),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ]),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
          );
  }
}

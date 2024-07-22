import 'package:sannip/common/widgets/cart_count_view.dart';
import 'package:sannip/common/widgets/custom_ink_well.dart';
import 'package:sannip/features/item/controllers/item_controller.dart';
import 'package:sannip/features/language/controllers/language_controller.dart';
import 'package:sannip/features/splash/controllers/splash_controller.dart';
import 'package:sannip/features/favourite/controllers/favourite_controller.dart';
import 'package:sannip/features/item/domain/models/item_model.dart';
import 'package:sannip/common/models/module_model.dart';
import 'package:sannip/features/store/domain/models/store_model.dart';
import 'package:sannip/helper/auth_helper.dart';
import 'package:sannip/helper/date_converter.dart';
import 'package:sannip/helper/price_converter.dart';
import 'package:sannip/helper/responsive_helper.dart';
import 'package:sannip/helper/route_helper.dart';
import 'package:sannip/util/dimensions.dart';
import 'package:sannip/util/images.dart';
import 'package:sannip/util/styles.dart';
import 'package:sannip/common/widgets/custom_image.dart';
import 'package:sannip/common/widgets/custom_snackbar.dart';
import 'package:sannip/common/widgets/not_available_widget.dart';
import 'package:sannip/common/widgets/organic_tag.dart';
import 'package:sannip/common/widgets/rating_bar.dart';
import 'package:sannip/features/store/screens/store_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemWidget extends StatelessWidget {
  final Item? item;
  final Store? store;
  final bool isStore;
  final int index;
  final int? length;
  final bool inStore;
  final bool isCampaign;
  final bool isFeatured;
  final bool fromCartSuggestion;
  final double? imageHeight;
  final double? imageWidth;
  final bool? isCornerTag;
  const ItemWidget(
      {super.key,
      required this.item,
      required this.isStore,
      required this.store,
      required this.index,
      required this.length,
      this.inStore = false,
      this.isCampaign = false,
      this.isFeatured = false,
      this.fromCartSuggestion = false,
      this.imageHeight,
      this.imageWidth,
      this.isCornerTag = false});

  @override
  Widget build(BuildContext context) {
    final bool ltr = Get.find<LocalizationController>().isLtr;
    bool desktop = ResponsiveHelper.isDesktop(context);
    double? discount;
    String? discountType;
    bool isAvailable;
    // bool haveItemImage = (isStore ? true : item!.image != null);
    if (isStore) {
      discount = store!.discount != null ? store!.discount!.discount : 0;
      discountType =
          store!.discount != null ? store!.discount!.discountType : 'percent';
      isAvailable = store!.open == 1 && store!.active!;
    } else {
      discount = (item!.storeDiscount == 0 || isCampaign)
          ? item!.discount
          : item!.storeDiscount;
      discountType = (item!.storeDiscount == 0 || isCampaign)
          ? item!.discountType
          : 'percent';
      isAvailable = DateConverter.isAvailable(
          item!.availableTimeStarts, item!.availableTimeEnds);
    }

    return Stack(
      children: [
        Container(
          margin: ResponsiveHelper.isDesktop(context)
              ? null
              : const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            color: Theme.of(context).cardColor,
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 1, spreadRadius: 1)
            ],
          ),
          child: CustomInkWell(
            onTap: () {
              if (isStore) {
                if (store != null) {
                  if (isFeatured &&
                      Get.find<SplashController>().moduleList != null) {
                    for (ModuleModel module
                        in Get.find<SplashController>().moduleList!) {
                      if (module.id == store!.moduleId) {
                        Get.find<SplashController>().setModule(module);
                        break;
                      }
                    }
                  }
                  Get.toNamed(
                    RouteHelper.getStoreRoute(
                        id: store!.id, page: isFeatured ? 'module' : 'item'),
                    arguments:
                        StoreScreen(store: store, fromModule: isFeatured),
                  );
                }
              } else {
                if (isFeatured &&
                    Get.find<SplashController>().moduleList != null) {
                  for (ModuleModel module
                      in Get.find<SplashController>().moduleList!) {
                    if (module.id == item!.moduleId) {
                      Get.find<SplashController>().setModule(module);
                      break;
                    }
                  }
                }
                Get.find<ItemController>().navigateToItemPage(item, context,
                    inStore: inStore, isCampaign: isCampaign);
              }
            },
            radius: Dimensions.radiusDefault,
            padding: ResponsiveHelper.isDesktop(context)
                ? EdgeInsets.all(fromCartSuggestion
                    ? Dimensions.paddingSizeExtraSmall
                    : Dimensions.paddingSizeSmall)
                : EdgeInsets.zero,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Expanded(
                  child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical:
                        desktop ? 0 : /* Dimensions.paddingSizeExtraSmall */ 0),
                child: Column(children: [
                  Stack(children: [
                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusDefault),
                      child: CustomImage(
                        image:
                            '${isStore ? store != null ? store!.logoFullUrl : '' : item!.imageFullUrl}',
                        height: imageHeight ??
                            (desktop
                                ? 120
                                : length == null
                                    ? 100
                                    : 178),
                        width: imageWidth ?? (desktop ? 120 : 190),
                        fit: BoxFit.cover,
                      ),
                    ),
                    /* (isStore || isCornerTag!)
                        ? DiscountTag(
                            discount: discount,
                            discountType: discountType,
                            freeDelivery: isStore ? store!.freeDelivery : false,
                          )
                        : const SizedBox(), */
                    !isStore
                        ? OrganicTag(item: item!, placeInImage: true)
                        : const SizedBox(),
                    isAvailable
                        ? const SizedBox()
                        : NotAvailableWidget(isStore: isStore),
                  ]),
                  !isStore ? const SizedBox(height: 5) : const SizedBox(),
                  const SizedBox(width: Dimensions.paddingSizeSmall),
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingSizeExtraSmall),
                            child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(
                                    isStore ? store!.name! : item!.name!,
                                    style: robotoMedium.copyWith(
                                        fontSize: Dimensions.fontSizeSmall),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(
                                      width: Dimensions.paddingSizeExtraSmall),
                                  (!isStore &&
                                          Get.find<SplashController>()
                                              .configModel!
                                              .moduleConfig!
                                              .module!
                                              .vegNonVeg! &&
                                          Get.find<SplashController>()
                                              .configModel!
                                              .toggleVegNonVeg!)
                                      ? Image.asset(
                                          item != null && item!.veg == 0
                                              ? Images.nonVegImage
                                              : Images.vegImage,
                                          height: 10,
                                          width: 10,
                                          fit: BoxFit.contain)
                                      : const SizedBox(),
                                  /* SizedBox(
                                      width: item!.isStoreHalalActive! &&
                                              item!.isHalalItem!
                                          ? Dimensions.paddingSizeExtraSmall
                                          : 0),
                                  !isStore &&
                                          item!.isStoreHalalActive! &&
                                          item!.isHalalItem!
                                      ? const CustomAssetImageWidget(
                                          Images.halalTag,
                                          height: 13,
                                          width: 13)
                                      : const SizedBox(), */
                                  const SizedBox(),
                                ]),
                          ),
                          SizedBox(
                              height: isStore
                                  ? Dimensions.paddingSizeExtraSmall
                                  : 0),
                          (isStore
                                  ? store!.address != null
                                  : item!.storeName != null)
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal:
                                          Dimensions.paddingSizeExtraSmall),
                                  child: Text(
                                    isStore
                                        ? store!.address ?? ''
                                        : item!.storeName ?? '',
                                    style: robotoRegular.copyWith(
                                      fontSize: Dimensions.fontSizeExtraSmall,
                                      color: Theme.of(context).disabledColor,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              : const SizedBox(),
                          SizedBox(
                              height: ((desktop || isStore) &&
                                      (isStore
                                          ? store!.address != null
                                          : item!.storeName != null))
                                  ? 5
                                  : 0),
                          // !isStore
                          //     ? RatingBar(
                          //         rating: isStore
                          //             ? store!.avgRating
                          //             : item!.avgRating,
                          //         size: desktop ? 15 : 12,
                          //         ratingCount: isStore
                          //             ? store!.ratingCount
                          //             : item!.ratingCount,
                          //       )
                          //     : const SizedBox(),
                          SizedBox(
                              height: (!isStore && desktop)
                                  ? Dimensions.paddingSizeExtraSmall
                                  : Dimensions.paddingSizeExtraSmall),
                          (Get.find<SplashController>()
                                      .configModel!
                                      .moduleConfig!
                                      .module!
                                      .unit! &&
                                  item != null &&
                                  item!.unitType != null)
                              ? Text(
                                  '(${item!.unitType ?? ''})',
                                  style: robotoRegular.copyWith(
                                      fontSize: Dimensions.fontSizeExtraSmall,
                                      color: Theme.of(context).hintColor),
                                )
                              : const SizedBox(),
                          // !isStore ? const Spacer() : const SizedBox(),
                          isStore
                              ? RatingBar(
                                  rating: isStore
                                      ? store!.avgRating
                                      : item!.avgRating,
                                  size: desktop ? 15 : 12,
                                  ratingCount: isStore
                                      ? store!.ratingCount
                                      : item!.ratingCount,
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal:
                                              Dimensions.paddingSizeExtraSmall),
                                      child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              PriceConverter.convertPrice(
                                                  item!.price,
                                                  discount: discount,
                                                  discountType: discountType),
                                              style: robotoMedium.copyWith(
                                                  fontSize: Dimensions
                                                      .fontSizeDefault),
                                              textDirection: TextDirection.ltr,
                                            ),
                                            SizedBox(
                                                width: discount! > 0 ? 2 : 0),
                                            discount > 0
                                                ? Text(
                                                    PriceConverter.convertPrice(
                                                        item!.price),
                                                    style:
                                                        robotoMedium.copyWith(
                                                      fontSize: Dimensions
                                                          .fontSizeDefault,
                                                      color: Theme.of(context)
                                                          .disabledColor,
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                    ),
                                                    textDirection:
                                                        TextDirection.ltr,
                                                  )
                                                : const SizedBox(),
                                          ]),
                                    ),
                                    Column(
                                        mainAxisAlignment: isStore
                                            ? MainAxisAlignment.center
                                            : MainAxisAlignment.spaceBetween,
                                        children: [
                                          const SizedBox(),
                                          // fromCartSuggestion
                                          //     ? Container(
                                          //         decoration: BoxDecoration(
                                          //           color: Theme.of(context)
                                          //               .primaryColor,
                                          //           shape: BoxShape.circle,
                                          //         ),
                                          //         padding: const EdgeInsets.all(
                                          //             Dimensions
                                          //                 .paddingSizeExtraSmall),
                                          //         child: Icon(Icons.add,
                                          //             color: Theme.of(context)
                                          //                 .cardColor,
                                          //             size: 12),
                                          //       )
                                          //     : GetBuilder<FavouriteController>(
                                          //         builder:
                                          //             (favouriteController) {
                                          //         bool isWished = isStore
                                          //             ? favouriteController
                                          //                 .wishStoreIdList
                                          //                 .contains(store!.id)
                                          //             : favouriteController
                                          //                 .wishItemIdList
                                          //                 .contains(item!.id);
                                          //         return InkWell(
                                          //           onTap:
                                          //               !favouriteController
                                          //                       .isRemoving
                                          //                   ? () {
                                          //                       if (AuthHelper
                                          //                           .isLoggedIn()) {
                                          //                         isWished
                                          //                             ? favouriteController.removeFromFavouriteList(
                                          //                                 isStore
                                          //                                     ? store!
                                          //                                         .id
                                          //                                     : item!
                                          //                                         .id,
                                          //                                 isStore)
                                          //                             : favouriteController.addToFavouriteList(
                                          //                                 item,
                                          //                                 store,
                                          //                                 isStore);
                                          //                       } else {
                                          //                         showCustomSnackBar(
                                          //                             'you_are_not_logged_in'
                                          //                                 .tr);
                                          //                       }
                                          //                     }
                                          //                   : null,
                                          //           child: Padding(
                                          //             padding: EdgeInsets.symmetric(
                                          //                 vertical: desktop
                                          //                     ? Dimensions
                                          //                         .paddingSizeSmall
                                          //                     : 0),
                                          //             child: Icon(
                                          //               isWished
                                          //                   ? Icons.favorite
                                          //                   : Icons
                                          //                       .favorite_border,
                                          //               size: desktop ? 30 : 25,
                                          //               color: isWished
                                          //                   ? Theme.of(context)
                                          //                       .primaryColor
                                          //                   : Theme.of(context)
                                          //                       .disabledColor,
                                          //             ),
                                          //           ),
                                          //         );
                                          //       }),
                                          CartCountView(
                                            item: item!,
                                            child: Stack(
                                              clipBehavior: Clip.none,
                                              children: [
                                                Container(
                                                  width: 90,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            Dimensions
                                                                .radiusSmall),
                                                    color: Theme.of(context)
                                                        .cardColor,
                                                    border: Border.all(
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                    boxShadow: const [
                                                      BoxShadow(
                                                          color: Colors.black12,
                                                          blurRadius: 5,
                                                          spreadRadius: 1)
                                                    ],
                                                  ),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    vertical: Dimensions
                                                        .paddingSizeExtraSmall,
                                                  ),
                                                  child: Text(
                                                    'add'.tr,
                                                    style:
                                                        robotoMedium.copyWith(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                    ),
                                                  ),
                                                ),
                                                item?.choiceOptions
                                                            ?.isNotEmpty ??
                                                        false
                                                    ? Positioned(
                                                        left: 20,
                                                        right: 20,
                                                        bottom: -6,
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 02,
                                                                  horizontal:
                                                                      1),
                                                          color:
                                                              Theme.of(context)
                                                                  .cardColor,
                                                          child: Text(
                                                            '${item?.choiceOptions?.length} ${((item!.choiceOptions!.length > 1) ? "options" : "option")}',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: robotoMedium
                                                                .copyWith(
                                                              fontSize: 8,
                                                              height: 1.2,
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : const SizedBox(),
                                              ],
                                            ),
                                          )
                                        ]),
                                  ],
                                ),
                        ]),
                  ),
                  /* Column(
                      mainAxisAlignment: isStore
                          ? MainAxisAlignment.center
                          : MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(),
                        fromCartSuggestion
                            ? Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(
                                    Dimensions.paddingSizeExtraSmall),
                                child: Icon(Icons.add,
                                    color: Theme.of(context).cardColor,
                                    size: 12),
                              )
                            : GetBuilder<FavouriteController>(
                                builder: (favouriteController) {
                                bool isWished = isStore
                                    ? favouriteController.wishStoreIdList
                                        .contains(store!.id)
                                    : favouriteController.wishItemIdList
                                        .contains(item!.id);
                                return InkWell(
                                  onTap: !favouriteController.isRemoving
                                      ? () {
                                          if (AuthHelper.isLoggedIn()) {
                                            isWished
                                                ? favouriteController
                                                    .removeFromFavouriteList(
                                                        isStore
                                                            ? store!.id
                                                            : item!.id,
                                                        isStore)
                                                : favouriteController
                                                    .addToFavouriteList(
                                                        item, store, isStore);
                                          } else {
                                            showCustomSnackBar(
                                                'you_are_not_logged_in'.tr);
                                          }
                                        }
                                      : null,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: desktop
                                            ? Dimensions.paddingSizeSmall
                                            : 0),
                                    child: Icon(
                                      isWished
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      size: desktop ? 30 : 25,
                                      color: isWished
                                          ? Theme.of(context).primaryColor
                                          : Theme.of(context).disabledColor,
                                    ),
                                  ),
                                );
                              }),
                      ]), */
                ]),
              )),
            ]),
          ),
        ),
        (!isStore && isCornerTag! == false && discount! > 0)
            ? Positioned(
                right: /* ltr ? 0 : null, */ ltr ? null : 0,
                left: /* ltr ? null : 0, */ ltr ? 0 : null,
                child: /* CornerDiscountTag(
                  bannerPosition: ltr
                      ? CornerBannerPosition.topRight
                      : CornerBannerPosition.topLeft,
                  elevation: 0,
                  discount: discount,
                  discountType: discountType,
                  freeDelivery: isStore ? store!.freeDelivery : false,
                )  */
                    ClipPath(
                  clipper: TagClipper(),
                  child: Container(
                    color: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 5.0),
                    child: Text(
                      '${discount.toStringAsFixed(0)}${discountType == 'percent' ? '%' : Get.find<SplashController>().configModel!.currencySymbol}\n${'off'.tr}',
                      style: robotoMedium.copyWith(
                        color: Colors.white,
                        fontSize:
                            (ResponsiveHelper.isMobile(Get.context) ? 9 : 12),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ))
            : const SizedBox(),
        isStore
            ? const SizedBox()
            : Positioned(
                right: 3,
                top: 3,
                child: fromCartSuggestion
                    ? Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(
                            Dimensions.paddingSizeExtraSmall),
                        child: Icon(Icons.add,
                            color: Theme.of(context).cardColor, size: 12),
                      )
                    : GetBuilder<FavouriteController>(
                        builder: (favouriteController) {
                        bool isWished = isStore
                            ? favouriteController.wishStoreIdList
                                .contains(store!.id)
                            : favouriteController.wishItemIdList
                                .contains(item!.id);
                        return InkWell(
                          onTap: !favouriteController.isRemoving
                              ? () {
                                  if (AuthHelper.isLoggedIn()) {
                                    isWished
                                        ? favouriteController
                                            .removeFromFavouriteList(
                                                isStore ? store!.id : item!.id,
                                                isStore)
                                        : favouriteController
                                            .addToFavouriteList(
                                                item, store, isStore);
                                  } else {
                                    showCustomSnackBar(
                                        'you_are_not_logged_in'.tr);
                                  }
                                }
                              : null,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical:
                                    desktop ? Dimensions.paddingSizeSmall : 0),
                            child: Icon(
                              isWished ? Icons.favorite : Icons.favorite_border,
                              size: desktop ? 30 : 25,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        );
                      }),
              )
      ],
    );
  }
}

class TagClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, size.height - 5);

    // Creating sharp waves
    final double waveWidth = size.width / 3;

    path.lineTo(waveWidth / 2, size.height);
    path.lineTo(waveWidth, size.height - 6);
    path.lineTo(waveWidth * 1.6, size.height);
    path.lineTo(waveWidth * 2.1, size.height - 6);
    path.lineTo(waveWidth * 2.6, size.height);
    path.lineTo(size.width, size.height - 6);

    path.lineTo(size.width, 0);
    path.lineTo(10, 0);
    path.arcToPoint(
      const Offset(0, 10),
      radius: const Radius.circular(10),
      clockwise: false,
    );
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class ListViewItemWidget extends StatelessWidget {
  final Item? item;
  final Store? store;
  final bool isStore;
  final int index;
  final int? length;
  final bool inStore;
  final bool isCampaign;
  final bool isFeatured;
  final bool fromCartSuggestion;
  final double? imageHeight;
  final double? imageWidth;
  final bool? isCornerTag;
  const ListViewItemWidget(
      {super.key,
      required this.item,
      required this.isStore,
      required this.store,
      required this.index,
      required this.length,
      this.inStore = false,
      this.isCampaign = false,
      this.isFeatured = false,
      this.fromCartSuggestion = false,
      this.imageHeight,
      this.imageWidth,
      this.isCornerTag = false});

  @override
  Widget build(BuildContext context) {
    double? discount;
    String? discountType;
    bool isAvailable;
    // bool haveItemImage = (isStore ? true : item!.image != null);
    if (isStore) {
      discount = store!.discount != null ? store!.discount!.discount : 0;
      discountType =
          store!.discount != null ? store!.discount!.discountType : 'percent';
      isAvailable = store!.open == 1 && store!.active!;
    } else {
      discount = (item!.storeDiscount == 0 || isCampaign)
          ? item!.discount
          : item!.storeDiscount;
      discountType = (item!.storeDiscount == 0 || isCampaign)
          ? item!.discountType
          : 'percent';
      isAvailable = DateConverter.isAvailable(
          item!.availableTimeStarts, item!.availableTimeEnds);
    }
    return CustomInkWell(
      onTap: () {
        if (isStore) {
          if (store != null) {
            if (isFeatured && Get.find<SplashController>().moduleList != null) {
              for (ModuleModel module
                  in Get.find<SplashController>().moduleList!) {
                if (module.id == store!.moduleId) {
                  Get.find<SplashController>().setModule(module);
                  break;
                }
              }
            }
            Get.toNamed(
              RouteHelper.getStoreRoute(
                  id: store!.id, page: isFeatured ? 'module' : 'item'),
              arguments: StoreScreen(store: store, fromModule: isFeatured),
            );
          }
        } else {
          if (isFeatured && Get.find<SplashController>().moduleList != null) {
            for (ModuleModel module
                in Get.find<SplashController>().moduleList!) {
              if (module.id == item!.moduleId) {
                Get.find<SplashController>().setModule(module);
                break;
              }
            }
          }
          Get.find<ItemController>().navigateToItemPage(item, context,
              inStore: inStore, isCampaign: isCampaign);
        }
      },
      radius: Dimensions.radiusDefault,
      padding: ResponsiveHelper.isDesktop(context)
          ? EdgeInsets.all(fromCartSuggestion
              ? Dimensions.paddingSizeExtraSmall
              : Dimensions.paddingSizeSmall)
          : EdgeInsets.zero,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 2.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Veg/Non-Veg icon
                  (!isStore &&
                          Get.find<SplashController>()
                              .configModel!
                              .moduleConfig!
                              .module!
                              .vegNonVeg! &&
                          Get.find<SplashController>()
                              .configModel!
                              .toggleVegNonVeg!)
                      ? Image.asset(
                          item != null && item!.veg == 0
                              ? Images.nonVegImage
                              : Images.vegImage,
                          height: 10,
                          width: 10,
                          fit: BoxFit.contain)
                      : const SizedBox(),
                  // Food details
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Food title
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Text(
                          item!.name!,
                          style: robotoMedium.copyWith(
                              fontSize: Dimensions.fontSizeDefault),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                      // Restaurant name
                      (isStore
                              ? store!.address != null
                              : item!.storeName != null)
                          ? Container(
                              decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .disabledColor
                                      .withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radiusSmall)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.paddingSizeExtraSmall),
                              child: Text(
                                isStore
                                    ? store!.address ?? ''
                                    : item!.storeName ?? '',
                                style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeSmall,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          : const SizedBox(),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                      // Rating and reviews
                      !isStore
                          ? Row(
                              mainAxisAlignment: isFeatured
                                  ? MainAxisAlignment.start
                                  : MainAxisAlignment.center,
                              children: [
                                  Icon(Icons.star,
                                      size: 14,
                                      color: Theme.of(context).primaryColor),
                                  const SizedBox(width: 3),
                                  Text(item!.avgRating!.toStringAsFixed(1),
                                      style: robotoRegular.copyWith(
                                          fontSize: Dimensions.fontSizeSmall)),
                                  const SizedBox(
                                      width: Dimensions.paddingSizeExtraSmall),
                                  Text("(${item!.ratingCount})",
                                      style: robotoRegular.copyWith(
                                          fontSize: Dimensions.fontSizeSmall,
                                          color:
                                              Theme.of(context).disabledColor)),
                                ])
                          : const SizedBox(),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                      // Price
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeExtraSmall),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                PriceConverter.convertPrice(item!.price,
                                    discount: discount,
                                    discountType: discountType),
                                style: robotoMedium.copyWith(
                                    fontSize: Dimensions.fontSizeLarge),
                                textDirection: TextDirection.ltr,
                              ),
                              SizedBox(
                                  width: discount! > 0
                                      ? Dimensions.paddingSizeExtraSmall
                                      : 0),
                              discount > 0
                                  ? Text(
                                      PriceConverter.convertPrice(item!.price),
                                      style: robotoMedium.copyWith(
                                        fontSize: Dimensions.fontSizeDefault,
                                        color: Theme.of(context).disabledColor,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                      textDirection: TextDirection.ltr,
                                    )
                                  : const SizedBox(),
                            ]),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(width: Dimensions.paddingSizeSmall),
              // Image and Add button
              Column(
                children: <Widget>[
                  Stack(clipBehavior: Clip.none, children: [
                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusDefault),
                      child: CustomImage(
                        image:
                            '${isStore ? store != null ? store!.logoFullUrl : '' : item!.imageFullUrl}',
                        height: imageHeight ?? 85,
                        width: imageWidth ?? 160,
                        fit: BoxFit.cover,
                      ),
                    ),
                    !isStore
                        ? OrganicTag(item: item!, placeInImage: true)
                        : const SizedBox(),
                    isAvailable
                        ? const SizedBox()
                        : NotAvailableWidget(isStore: isStore),
                    Positioned(
                      bottom: -15,
                      left: 35,
                      right: 35,
                      child: CartCountView(
                        item: item!,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 90,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    Dimensions.radiusSmall),
                                color: Theme.of(context).cardColor,
                                border: Border.all(
                                    color: Theme.of(context).primaryColor),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 5,
                                      spreadRadius: 1)
                                ],
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: Dimensions.paddingSizeExtraSmall,
                              ),
                              child: Text(
                                'add'.tr,
                                style: robotoMedium.copyWith(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                            item?.choiceOptions?.isNotEmpty ?? false
                                ? Positioned(
                                    left: 20,
                                    right: 20,
                                    bottom: -6,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 02, horizontal: 1),
                                      color: Theme.of(context).cardColor,
                                      child: Text(
                                        '${item?.choiceOptions?.length} ${((item!.choiceOptions!.length > 1) ? "options" : "option")}',
                                        textAlign: TextAlign.center,
                                        style: robotoMedium.copyWith(
                                          fontSize: 8,
                                          height: 1.2,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    )
                  ]),
                  const SizedBox(height: Dimensions.paddingSizeLarge),
                  (item?.foodVariations?.isNotEmpty ?? false)
                      ? Text(
                          'Customisable',
                          style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color: Theme.of(context).disabledColor),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      : const SizedBox(height: Dimensions.paddingSizeSmall),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

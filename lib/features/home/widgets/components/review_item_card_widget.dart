import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sannip/common/widgets/custom_ink_well.dart';
import 'package:sannip/features/item/controllers/item_controller.dart';
import 'package:sannip/features/splash/controllers/splash_controller.dart';
import 'package:sannip/features/item/domain/models/item_model.dart';
import 'package:sannip/helper/price_converter.dart';
import 'package:sannip/util/app_constants.dart';
import 'package:sannip/util/dimensions.dart';
import 'package:sannip/util/images.dart';
import 'package:sannip/util/styles.dart';
import 'package:sannip/common/widgets/add_favourite_view.dart';
import 'package:sannip/common/widgets/cart_count_view.dart';
import 'package:sannip/common/widgets/custom_image.dart';
import 'package:sannip/common/widgets/hover/on_hover.dart';
import 'package:sannip/common/widgets/organic_tag.dart';

class ReviewItemCard extends StatelessWidget {
  final bool isFeatured;
  final Item? item;
  const ReviewItemCard({super.key, this.isFeatured = false, this.item});

  @override
  Widget build(BuildContext context) {
    bool isShop = Get.find<SplashController>().module != null &&
        Get.find<SplashController>().module!.moduleType.toString() ==
            AppConstants.ecommerce;
    bool isFood = Get.find<SplashController>().module != null &&
        Get.find<SplashController>().module!.moduleType.toString() ==
            AppConstants.food;

    double? discount =
        item?.storeDiscount == 0 ? item?.discount : item?.storeDiscount;
    String? discountType =
        item?.storeDiscount == 0 ? item?.discountType : 'percent';

    return OnHover(
      isItem: true,
      child: isShop
          ? Container(
              width: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 1))
                ],
              ),
              child: CustomInkWell(
                onTap: () => Get.find<ItemController>()
                    .navigateToItemPage(item, context),
                radius: Dimensions.radiusDefault,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 5,
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: Dimensions.paddingSizeSmall,
                                  left: Dimensions.paddingSizeSmall,
                                  right: Dimensions.paddingSizeSmall),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(Dimensions.radiusDefault)),
                                child: CustomImage(
                                  placeholder: Images.placeholder,
                                  image: '${item!.imageFullUrl}',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                            ),
                            AddFavouriteView(
                              item: item!,
                            ),
                            /* DiscountTag(
                              isFloating: true,
                              discount:
                                  Get.find<ItemController>().getDiscount(item!),
                              discountType: Get.find<ItemController>()
                                  .getDiscountType(item!),
                            ), */
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding:
                              const EdgeInsets.all(Dimensions.paddingSizeSmall),
                          child: Column(
                              crossAxisAlignment: isFeatured
                                  ? CrossAxisAlignment.start
                                  : CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item!.storeName!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: robotoRegular.copyWith(
                                      color: Theme.of(context).disabledColor,
                                      fontSize: Dimensions.fontSizeSmall),
                                ),

                                Text(item!.name!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: robotoBold),

                                Row(
                                    mainAxisAlignment: isFeatured
                                        ? MainAxisAlignment.start
                                        : MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.star,
                                          size: 14,
                                          color:
                                              Theme.of(context).primaryColor),
                                      const SizedBox(
                                          width:
                                              Dimensions.paddingSizeExtraSmall),
                                      Text(item!.avgRating!.toStringAsFixed(1),
                                          style: robotoRegular.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeSmall)),
                                      const SizedBox(
                                          width:
                                              Dimensions.paddingSizeExtraSmall),
                                      Text("(${item!.ratingCount})",
                                          style: robotoRegular.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeSmall,
                                              color: Theme.of(context)
                                                  .disabledColor)),
                                    ]),

                                Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    alignment: WrapAlignment.start,
                                    children: [
                                      item!.discount != null &&
                                              item!.discount! > 0
                                          ? Text(
                                              PriceConverter.convertPrice(
                                                  Get.find<ItemController>()
                                                      .getStartingPrice(item!)),
                                              style: robotoRegular.copyWith(
                                                fontSize: Dimensions
                                                    .fontSizeExtraSmall,
                                                color: Theme.of(context)
                                                    .disabledColor,
                                                decoration:
                                                    TextDecoration.lineThrough,
                                              ),
                                            )
                                          : const SizedBox(),
                                      SizedBox(
                                          width: item!.discount != null &&
                                                  item!.discount! > 0
                                              ? Dimensions.paddingSizeExtraSmall
                                              : 0),
                                      Text(
                                        PriceConverter.convertPrice(
                                            Get.find<ItemController>()
                                                .getStartingPrice(item!),
                                            discount: item!.discount,
                                            discountType: item!.discountType),
                                        style: robotoMedium,
                                        textDirection: TextDirection.ltr,
                                      ),
                                    ]),
                                // SizedBox(height: item!.discount != null && item!.discount! > 0 ? Dimensions.paddingSizeExtraSmall : 0),
                              ]),
                        ),
                      ),
                    ]),
              ),
            )
          : Container(
              width: 210,
              height: 285,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 1))
                ],
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Stack(children: [
                        Padding(
                          padding: const EdgeInsets.all(
                              Dimensions.paddingSizeExtraSmall),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                                Radius.circular(Dimensions.radiusDefault)),
                            child: CustomImage(
                              placeholder: Images.placeholder,
                              image: '${item!.imageFullUrl}',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                        ),
                        AddFavouriteView(
                          top: 10,
                          right: 10,
                          item: item!,
                        ),
                        /* item!.isStoreHalalActive! && item!.isHalalItem!
                            ? const Positioned(
                                top: 35,
                                right: 10,
                                child: CustomAssetImageWidget(
                                  Images.halalTag,
                                  height: 20,
                                  width: 20,
                                ),
                              )
                            : const SizedBox(), */
                        const SizedBox(),
                        /* DiscountTag(
                          isFloating: true,
                          discount:
                              Get.find<ItemController>().getDiscount(item!),
                          discountType:
                              Get.find<ItemController>().getDiscountType(item!),
                        ), */
                        OrganicTag(item: item!, placeInImage: false),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingSizeDefault),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(
                                      Dimensions.paddingSizeSmall),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(
                                            Dimensions.radiusDefault),
                                        topRight: Radius.circular(
                                            Dimensions.radiusDefault)),
                                    color: Theme.of(context).cardColor,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          spreadRadius: 1,
                                          blurRadius: 5,
                                          offset: const Offset(0, 1))
                                    ],
                                  ),
                                  child: isFood
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const SizedBox(
                                                height: Dimensions
                                                    .paddingSizeExtraSmall),
                                            Text(
                                              item!.storeName!,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: robotoRegular.copyWith(
                                                  color: Theme.of(context)
                                                      .disabledColor,
                                                  fontSize:
                                                      Dimensions.fontSizeSmall),
                                            ),
                                            Text(item!.name!,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: robotoBold),
                                            Row(
                                                mainAxisAlignment: isFeatured
                                                    ? MainAxisAlignment.start
                                                    : MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.star,
                                                      size: 14,
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                                  const SizedBox(
                                                      width: Dimensions
                                                          .paddingSizeExtraSmall),
                                                  Text(
                                                      item!.avgRating!
                                                          .toStringAsFixed(1),
                                                      style: robotoRegular.copyWith(
                                                          fontSize: Dimensions
                                                              .fontSizeSmall)),
                                                  const SizedBox(
                                                      width: Dimensions
                                                          .paddingSizeExtraSmall),
                                                  Text("(${item!.ratingCount})",
                                                      style: robotoRegular.copyWith(
                                                          fontSize: Dimensions
                                                              .fontSizeSmall,
                                                          color: Theme.of(
                                                                  context)
                                                              .disabledColor)),
                                                ]),
                                            Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  discount != null &&
                                                          discount > 0
                                                      ? Text(
                                                          PriceConverter
                                                              .convertPrice(
                                                            Get.find<
                                                                    ItemController>()
                                                                .getStartingPrice(
                                                                    item!),
                                                          ),
                                                          style: robotoRegular
                                                              .copyWith(
                                                            fontSize: Dimensions
                                                                .fontSizeExtraSmall,
                                                            color: Theme.of(
                                                                    context)
                                                                .disabledColor,
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough,
                                                          ),
                                                        )
                                                      : const SizedBox(),
                                                  SizedBox(
                                                      width: item!.discount! > 0
                                                          ? Dimensions
                                                              .paddingSizeExtraSmall
                                                          : 0),
                                                  Text(
                                                    PriceConverter.convertPrice(
                                                      Get.find<ItemController>()
                                                          .getStartingPrice(
                                                              item!),
                                                      discount: discount,
                                                      discountType:
                                                          discountType,
                                                    ),
                                                    style: robotoMedium,
                                                    textDirection:
                                                        TextDirection.ltr,
                                                  ),
                                                ]),
                                          ],
                                        )
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const SizedBox(
                                                height: Dimensions
                                                    .paddingSizeExtraSmall),
                                            Text(item!.name!,
                                                style: robotoBold,
                                                maxLines: 1,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.star,
                                                    size: 15,
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                                const SizedBox(
                                                    width: Dimensions
                                                        .paddingSizeExtraSmall),
                                                Text(
                                                    item!.avgRating!
                                                        .toStringAsFixed(1),
                                                    style: robotoRegular),
                                                const SizedBox(
                                                    width: Dimensions
                                                        .paddingSizeExtraSmall),
                                                Text("(${item!.ratingCount})",
                                                    style:
                                                        robotoRegular.copyWith(
                                                            fontSize: Dimensions
                                                                .fontSizeSmall,
                                                            color: Theme.of(
                                                                    context)
                                                                .disabledColor)),
                                              ],
                                            ),
                                            (Get.find<SplashController>()
                                                        .configModel!
                                                        .moduleConfig!
                                                        .module!
                                                        .unit! &&
                                                    item!.unitType != null)
                                                ? Text(
                                                    '(${item!.unitType ?? ''})',
                                                    style: robotoRegular.copyWith(
                                                        fontSize: Dimensions
                                                            .fontSizeExtraSmall,
                                                        color: Theme.of(context)
                                                            .disabledColor),
                                                  )
                                                : const SizedBox(),
                                            Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  discount != null &&
                                                          discount > 0
                                                      ? Text(
                                                          PriceConverter
                                                              .convertPrice(
                                                            Get.find<
                                                                    ItemController>()
                                                                .getStartingPrice(
                                                                    item!),
                                                          ),
                                                          style: robotoRegular
                                                              .copyWith(
                                                            fontSize: Dimensions
                                                                .fontSizeExtraSmall,
                                                            color: Theme.of(
                                                                    context)
                                                                .disabledColor,
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough,
                                                          ),
                                                        )
                                                      : const SizedBox(),
                                                  // SizedBox(height: item!.discount! > 0 ? Dimensions.paddingSizeExtraSmall : 0),

                                                  Text(
                                                    PriceConverter.convertPrice(
                                                      Get.find<ItemController>()
                                                          .getStartingPrice(
                                                              item!),
                                                      discount: discount,
                                                      discountType:
                                                          discountType,
                                                    ),
                                                    style: robotoMedium,
                                                    textDirection:
                                                        TextDirection.ltr,
                                                  ),
                                                ]),
                                          ],
                                        ),
                                ),
                                Positioned(
                                  top: -15,
                                  left: 0,
                                  right: 0,
                                  child: CartCountView(
                                    item: item!,
                                    child: Center(
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: 65,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(112),
                                          color: Theme.of(context).cardColor,
                                          boxShadow: [
                                            BoxShadow(
                                                color: Theme.of(context)
                                                    .primaryColor
                                                    .withOpacity(0.1),
                                                spreadRadius: 1,
                                                blurRadius: 5,
                                                offset: const Offset(0, 1))
                                          ],
                                        ),
                                        child: Text("add".tr,
                                            style: robotoBold.copyWith(
                                                color: Theme.of(context)
                                                    .primaryColor)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ]),
            ),
    );
  }
}

class BestReviewItemCard extends StatelessWidget {
  final bool isFeatured;
  final Item? item;
  const BestReviewItemCard({super.key, this.isFeatured = false, this.item});

  @override
  Widget build(BuildContext context) {
    bool isShop = Get.find<SplashController>().module != null &&
        Get.find<SplashController>().module!.moduleType.toString() ==
            AppConstants.ecommerce;
    bool isFood = Get.find<SplashController>().module != null &&
        Get.find<SplashController>().module!.moduleType.toString() ==
            AppConstants.food;

    double? discount =
        item?.storeDiscount == 0 ? item?.discount : item?.storeDiscount;
    String? discountType =
        item?.storeDiscount == 0 ? item?.discountType : 'percent';

    return OnHover(
      isItem: true,
      child: isShop
          ? Container(
              width: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 1))
                ],
              ),
              child: CustomInkWell(
                onTap: () => Get.find<ItemController>()
                    .navigateToItemPage(item, context),
                radius: Dimensions.radiusDefault,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 5,
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: Dimensions.paddingSizeSmall,
                                  left: Dimensions.paddingSizeSmall,
                                  right: Dimensions.paddingSizeSmall),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(Dimensions.radiusDefault)),
                                child: CustomImage(
                                  placeholder: Images.placeholder,
                                  image: '${item!.imageFullUrl}',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                            ),
                            AddFavouriteView(
                              item: item!,
                            ),
                            /* DiscountTag(
                              isFloating: true,
                              discount:
                                  Get.find<ItemController>().getDiscount(item!),
                              discountType: Get.find<ItemController>()
                                  .getDiscountType(item!),
                            ), */
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding:
                              const EdgeInsets.all(Dimensions.paddingSizeSmall),
                          child: Column(
                              crossAxisAlignment: isFeatured
                                  ? CrossAxisAlignment.start
                                  : CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item!.storeName!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: robotoRegular.copyWith(
                                      color: Theme.of(context).disabledColor,
                                      fontSize: Dimensions.fontSizeSmall),
                                ),

                                Text(item!.name!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: robotoBold),

                                Row(
                                    mainAxisAlignment: isFeatured
                                        ? MainAxisAlignment.start
                                        : MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.star,
                                          size: 14,
                                          color:
                                              Theme.of(context).primaryColor),
                                      const SizedBox(
                                          width:
                                              Dimensions.paddingSizeExtraSmall),
                                      Text(item!.avgRating!.toStringAsFixed(1),
                                          style: robotoRegular.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeSmall)),
                                      const SizedBox(
                                          width:
                                              Dimensions.paddingSizeExtraSmall),
                                      Text("(${item!.ratingCount})",
                                          style: robotoRegular.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeSmall,
                                              color: Theme.of(context)
                                                  .disabledColor)),
                                    ]),

                                Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    alignment: WrapAlignment.start,
                                    children: [
                                      item!.discount != null &&
                                              item!.discount! > 0
                                          ? Text(
                                              PriceConverter.convertPrice(
                                                  Get.find<ItemController>()
                                                      .getStartingPrice(item!)),
                                              style: robotoRegular.copyWith(
                                                fontSize: Dimensions
                                                    .fontSizeExtraSmall,
                                                color: Theme.of(context)
                                                    .disabledColor,
                                                decoration:
                                                    TextDecoration.lineThrough,
                                              ),
                                            )
                                          : const SizedBox(),
                                      SizedBox(
                                          width: item!.discount != null &&
                                                  item!.discount! > 0
                                              ? Dimensions.paddingSizeExtraSmall
                                              : 0),
                                      Text(
                                        PriceConverter.convertPrice(
                                            Get.find<ItemController>()
                                                .getStartingPrice(item!),
                                            discount: item!.discount,
                                            discountType: item!.discountType),
                                        style: robotoMedium,
                                        textDirection: TextDirection.ltr,
                                      ),
                                    ]),
                                // SizedBox(height: item!.discount != null && item!.discount! > 0 ? Dimensions.paddingSizeExtraSmall : 0),
                              ]),
                        ),
                      ),
                    ]),
              ),
            )
          : Container(
              width: 135,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                  )
                ],
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Stack(children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(Dimensions.radiusDefault),
                            topRight: Radius.circular(Dimensions.radiusDefault),
                          ),
                          child: CustomImage(
                            placeholder: Images.placeholder,
                            image: '${item!.imageFullUrl}',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                        AddFavouriteView(
                          top: 12,
                          right: 2,
                          item: item!,
                        ),
                        OrganicTag(
                          item: item!,
                          placeBottom: true,
                        ),
                        if (isFood)
                          Positioned(
                              bottom: 0,
                              right: 2,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal:
                                        Dimensions.paddingSizeExtraSmall),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.4),
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radiusExtraLarge),
                                  color: Theme.of(context).cardColor,
                                ),
                                child: Row(
                                    mainAxisAlignment: isFeatured
                                        ? MainAxisAlignment.start
                                        : MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.star,
                                          size: 14,
                                          color:
                                              Theme.of(context).primaryColor),
                                      const SizedBox(
                                          width:
                                              Dimensions.paddingSizeExtraSmall),
                                      Text(item!.avgRating!.toStringAsFixed(1),
                                          style: robotoRegular.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeSmall)),
                                      const SizedBox(
                                          width:
                                              Dimensions.paddingSizeExtraSmall),
                                      Text("(${item!.ratingCount})",
                                          style: robotoRegular.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeSmall,
                                              color: Theme.of(context)
                                                  .disabledColor)),
                                    ]),
                              )),
                        if (isFood &&
                            Get.find<SplashController>()
                                .configModel!
                                .moduleConfig!
                                .module!
                                .vegNonVeg! &&
                            Get.find<SplashController>()
                                .configModel!
                                .toggleVegNonVeg!)
                          Positioned(
                              left: 2,
                              bottom: 0,
                              child: Container(
                                padding: const EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(2)),
                                child: Image.asset(
                                    item?.veg == 0
                                        ? Images.nonVegImage
                                        : Images.vegImage,
                                    height: 12,
                                    width: 12,
                                    fit: BoxFit.contain),
                              ))
                      ]),
                    ),
                    Expanded(
                      flex: !isFood ? 6 : 5,
                      child: Padding(
                        padding: const EdgeInsets.all(
                            Dimensions.paddingSizeExtraSmall),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item!.storeName!,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: robotoRegular.copyWith(
                                  color: Theme.of(context).disabledColor,
                                  fontSize: Dimensions.fontSizeSmall),
                            ),
                            Text(item!.name!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: robotoMedium.copyWith(
                                    fontSize: Dimensions.fontSizeSmall)),
                            if (!isFood)
                              Row(
                                  mainAxisAlignment: isFeatured
                                      ? MainAxisAlignment.start
                                      : MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.star,
                                        size: 14,
                                        color: Theme.of(context).primaryColor),
                                    const SizedBox(
                                        width:
                                            Dimensions.paddingSizeExtraSmall),
                                    Text(item!.avgRating!.toStringAsFixed(1),
                                        style: robotoRegular.copyWith(
                                            fontSize:
                                                Dimensions.fontSizeSmall)),
                                    const SizedBox(
                                        width:
                                            Dimensions.paddingSizeExtraSmall),
                                    Text("(${item!.ratingCount})",
                                        style: robotoRegular.copyWith(
                                            fontSize: Dimensions.fontSizeSmall,
                                            color: Theme.of(context)
                                                .disabledColor)),
                                  ]),
                            /*if (!isFood)
                              (Get.find<SplashController>()
                                          .configModel!
                                          .moduleConfig!
                                          .module!
                                          .unit! &&
                                      item!.unitType != null)
                                  ? Text(
                                      '(${item!.unitType ?? ''})',
                                      style: robotoRegular.copyWith(
                                          fontSize:
                                              Dimensions.fontSizeExtraSmall,
                                          color: Theme.of(context)
                                              .disabledColor),
                                    )
                                  : const SizedBox(),*/
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  PriceConverter.convertPrice(
                                    Get.find<ItemController>()
                                        .getStartingPrice(item!),
                                    discount: discount,
                                    discountType: discountType,
                                  ),
                                  style: robotoMedium.copyWith(
                                    fontSize: Dimensions.fontSizeSmall,
                                  ),
                                  textDirection: TextDirection.ltr,
                                ),
                                if (discount != null && discount > 0) ...[
                                  const SizedBox(
                                      width: Dimensions.paddingSizeExtraSmall),
                                  Text(
                                    PriceConverter.convertPrice(
                                      Get.find<ItemController>()
                                          .getStartingPrice(item!),
                                    ),
                                    style: robotoRegular.copyWith(
                                      fontSize: Dimensions.fontSizeOverSmall,
                                      color: Theme.of(context).disabledColor,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                ]
                              ],
                            ),
                            CartCountView(
                              item: item!,
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    width: 85,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.radiusSmall),
                                      color: Theme.of(context).cardColor,
                                      border: Border.all(
                                          color:
                                              Theme.of(context).primaryColor),
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 5,
                                            spreadRadius: 1)
                                      ],
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical:
                                          Dimensions.paddingSizeExtraSmall,
                                    ),
                                    child: Text(
                                      'add'.tr,
                                      style: robotoMedium.copyWith(
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                  item?.foodVariations?.isNotEmpty ?? false
                                      ? Positioned(
                                          left: 15,
                                          right: 15,
                                          bottom: -6,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 02, horizontal: 1),
                                            color: Theme.of(context).cardColor,
                                            child: Text(
                                              'customisable'.tr,
                                              textAlign: TextAlign.center,
                                              style: robotoMedium.copyWith(
                                                fontSize: 8,
                                                height: 1.2,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                          ),
                                        )
                                      : item?.choiceOptions?.isNotEmpty ?? false
                                          ? Positioned(
                                              left: 15,
                                              right: 15,
                                              bottom: -6,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 02,
                                                        horizontal: 1),
                                                color:
                                                    Theme.of(context).cardColor,
                                                child: Text(
                                                  '${item?.choiceOptions?.length} ${(((item?.choiceOptions!.length ?? 0) > 1) ? "options" : "option")}',
                                                  textAlign: TextAlign.center,
                                                  style: robotoMedium.copyWith(
                                                    fontSize: 8,
                                                    height: 1.2,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : const SizedBox(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ]),
            ),
    );
  }
}

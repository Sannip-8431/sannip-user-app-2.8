import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sannip/common/widgets/custom_ink_well.dart';
import 'package:sannip/common/widgets/item_widget.dart';
import 'package:sannip/features/item/controllers/item_controller.dart';
import 'package:sannip/features/splash/controllers/splash_controller.dart';
import 'package:sannip/features/item/domain/models/item_model.dart';
import 'package:sannip/helper/price_converter.dart';
import 'package:sannip/helper/responsive_helper.dart';
import 'package:sannip/util/dimensions.dart';
import 'package:sannip/util/images.dart';
import 'package:sannip/util/styles.dart';
import 'package:sannip/common/widgets/add_favourite_view.dart';
import 'package:sannip/common/widgets/cart_count_view.dart';
import 'package:sannip/common/widgets/custom_image.dart';
import 'package:sannip/common/widgets/hover/on_hover.dart';
import 'package:sannip/common/widgets/not_available_widget.dart';
import 'package:sannip/common/widgets/organic_tag.dart';

class ItemCard extends StatelessWidget {
  final Item item;
  final bool isPopularItem;
  final bool isFood;
  final bool isShop;
  final bool isPopularItemCart;
  const ItemCard(
      {super.key,
      required this.item,
      this.isPopularItem = false,
      required this.isFood,
      required this.isShop,
      this.isPopularItemCart = false});

  @override
  Widget build(BuildContext context) {
    double? discount =
        item.storeDiscount == 0 ? item.discount : item.storeDiscount;
    String? discountType =
        item.storeDiscount == 0 ? item.discountType : 'percent';

    return OnHover(
      isItem: true,
      child: Stack(children: [
        SizedBox(
          width: 160,
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
          //   color: Theme.of(context).cardColor,
          // ),
          child: CustomInkWell(
            onTap: () =>
                Get.find<ItemController>().navigateToItemPage(item, context),
            radius: Dimensions.radiusLarge,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                flex: 5,
                child: Stack(children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).hintColor.withOpacity(0.3)),
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusLarge),
                      color: Theme.of(context).cardColor,
                    ),
                    padding: EdgeInsets.only(
                        top: isPopularItem
                            ? Dimensions.paddingSizeExtraSmall
                            : 0,
                        left: isPopularItem
                            ? Dimensions.paddingSizeExtraSmall
                            : 0,
                        right: isPopularItem
                            ? Dimensions.paddingSizeExtraSmall
                            : 0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.radiusLarge
                          // topLeft: const Radius.circular(Dimensions.radiusLarge),
                          // topRight: const Radius.circular(Dimensions.radiusLarge),
                          // bottomLeft: Radius.circular(
                          //     isPopularItem ? Dimensions.radiusLarge : 0),
                          // bottomRight: Radius.circular(
                          //     isPopularItem ? Dimensions.radiusLarge : 0),
                          ),
                      child: CustomImage(
                        placeholder: Images.placeholder,
                        image: '${item.imageFullUrl}',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  ),
                  AddFavouriteView(
                    item: item,
                    top: 3,
                    right: 3,
                  ),
                  /*  item.isStoreHalalActive! && item.isHalalItem!
                      ? const Positioned(
                          bottom: 3,
                          right: 3,
                          child: CustomAssetImageWidget(
                            Images.halalTag,
                            height: 25,
                            width: 25,
                          ),
                        )
                      : const SizedBox(), */
                  const SizedBox(),
                  // DiscountTag(
                  //   discount: discount,
                  //   discountType: discountType,
                  //   freeDelivery: false,
                  // ),
                  if (discount! > 0)
                    Positioned(
                        left: 0,
                        child: ClipPath(
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
                                    (ResponsiveHelper.isMobile(Get.context)
                                        ? 9
                                        : 12),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )),
                  OrganicTag(
                    item: item,
                    placeInImage: false,
                    placeBottom: true,
                  ),
                  (item.stock != null && item.stock! < 0)
                      ? Positioned(
                          bottom: 45,
                          left: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingSizeSmall,
                                vertical: Dimensions.paddingSizeExtraSmall),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.5),
                              borderRadius: const BorderRadius.only(
                                topRight:
                                    Radius.circular(Dimensions.radiusLarge),
                                bottomRight:
                                    Radius.circular(Dimensions.radiusLarge),
                              ),
                            ),
                            child: Text('out_of_stock'.tr,
                                style: robotoRegular.copyWith(
                                    color: Theme.of(context).cardColor,
                                    fontSize: Dimensions.fontSizeSmall)),
                          ),
                        )
                      : const SizedBox(),
                  // isShop
                  //     ? const SizedBox()
                  //     : Positioned(
                  //         bottom: 10,
                  //         right: 20,
                  //         child: CartCountView(
                  //           item: item,
                  //         ),
                  //       ),
                  Get.find<ItemController>().isAvailable(item)
                      ? const SizedBox()
                      : NotAvailableWidget(
                          radius: Dimensions.radiusLarge,
                          isAllSideRound: isPopularItem),
                ]),
              ),
              Expanded(
                flex: (isFood || isShop) ? 6 : 5,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: Dimensions.paddingSizeSmall,
                      right: isShop ? 0 : Dimensions.paddingSizeSmall,
                      top: Dimensions.paddingSizeSmall,
                      bottom: isShop ? 0 : Dimensions.paddingSizeSmall),
                  child: Stack(clipBehavior: Clip.none, children: [
                    Column(
                        crossAxisAlignment: isPopularItem
                            ? CrossAxisAlignment.center
                            : CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          (isFood || isShop)
                              ? Text(item.storeName ?? '',
                                  style: robotoRegular.copyWith(
                                      color: Theme.of(context).disabledColor))
                              : Text(item.name ?? '',
                                  style: robotoBold,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                          (isFood || isShop)
                              ? Flexible(
                                  child: Text(
                                    item.name ?? '',
                                    style: robotoBold,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: isPopularItem
                                      ? MainAxisAlignment.center
                                      : MainAxisAlignment.start,
                                  children: [
                                      Icon(Icons.star,
                                          size: 14,
                                          color:
                                              Theme.of(context).primaryColor),
                                      const SizedBox(
                                          width:
                                              Dimensions.paddingSizeExtraSmall),
                                      Text(item.avgRating!.toStringAsFixed(1),
                                          style: robotoRegular.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeSmall)),
                                      const SizedBox(
                                          width:
                                              Dimensions.paddingSizeExtraSmall),
                                      Text("(${item.ratingCount})",
                                          style: robotoRegular.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeSmall,
                                              color: Theme.of(context)
                                                  .disabledColor)),
                                    ]),
                          (isFood || isShop)
                              ? Row(
                                  mainAxisAlignment: isPopularItem
                                      ? MainAxisAlignment.center
                                      : MainAxisAlignment.start,
                                  children: [
                                      Icon(Icons.star,
                                          size: 14,
                                          color:
                                              Theme.of(context).primaryColor),
                                      const SizedBox(
                                          width:
                                              Dimensions.paddingSizeExtraSmall),
                                      Text(item.avgRating!.toStringAsFixed(1),
                                          style: robotoRegular.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeSmall)),
                                      const SizedBox(
                                          width:
                                              Dimensions.paddingSizeExtraSmall),
                                      Text("(${item.ratingCount})",
                                          style: robotoRegular.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeSmall,
                                              color: Theme.of(context)
                                                  .disabledColor)),
                                    ])
                              : (Get.find<SplashController>()
                                          .configModel!
                                          .moduleConfig!
                                          .module!
                                          .unit! &&
                                      item.unitType != null)
                                  ? Text(
                                      '(${item.unitType ?? ''})',
                                      style: robotoRegular.copyWith(
                                          fontSize:
                                              Dimensions.fontSizeExtraSmall,
                                          color: Theme.of(context).hintColor),
                                    )
                                  : const SizedBox(),

                          /*  discount > 0
                              ? Text(
                                  PriceConverter.convertPrice(
                                      Get.find<ItemController>()
                                          .getStartingPrice(item)),
                                  style: robotoMedium.copyWith(
                                    fontSize: Dimensions.fontSizeExtraSmall,
                                    color: Theme.of(context).disabledColor,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                  textDirection: TextDirection.ltr,
                                )
                              : const SizedBox(),
                          // SizedBox(height: item.discount != null && item.discount! > 0 ? Dimensions.paddingSizeExtraSmall : 0),

                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  PriceConverter.convertPrice(
                                    Get.find<ItemController>()
                                        .getStartingPrice(item),
                                    discount: discount,
                                    discountType: discountType,
                                  ),
                                  textDirection: TextDirection.ltr,
                                  style: robotoMedium,
                                ),
                              ),
                              isShop
                                  ? const SizedBox()
                                  : CartCountView(
                                      item: item,
                                      child: Container(
                                        width: 90,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.radiusSmall),
                                          color: Theme.of(context).cardColor,
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
                                        padding: const EdgeInsets.symmetric(
                                          vertical:
                                              Dimensions.paddingSizeExtraSmall,
                                        ),
                                        child: Text(
                                          'add'.tr,
                                          style: robotoMedium.copyWith(
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ),
                                    ),
                            ],
                          ), */

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      PriceConverter.convertPrice(item.price,
                                          discount: discount,
                                          discountType: discountType),
                                      style: robotoMedium.copyWith(
                                          fontSize: Dimensions.fontSizeDefault),
                                      textDirection: TextDirection.ltr,
                                    ),
                                    SizedBox(width: discount > 0 ? 2 : 0),
                                    discount > 0
                                        ? Text(
                                            PriceConverter.convertPrice(
                                                item.price),
                                            style: robotoMedium.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeDefault,
                                              color: Theme.of(context)
                                                  .disabledColor,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                            ),
                                            textDirection: TextDirection.ltr,
                                          )
                                        : const SizedBox(),
                                  ]),
                              isShop
                                  ? const SizedBox()
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                          const SizedBox(),
                                          CartCountView(
                                            item: item,
                                            child: Stack(
                                              clipBehavior: Clip.none,
                                              children: [
                                                Container(
                                                  width: 80,
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
                                                item.choiceOptions
                                                            ?.isNotEmpty ??
                                                        false
                                                    ? Positioned(
                                                        left: 15,
                                                        right: 15,
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
                                                            '${item.choiceOptions?.length} ${((item.choiceOptions!.length > 1) ? "options" : "option")}',
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
                          const SizedBox(
                              height: Dimensions.paddingSizeExtraSmall),
                        ]),
                    isShop
                        ? Positioned(
                            bottom: 0,
                            right: 0,
                            child: CartCountView(
                              item: item,
                              child: Container(
                                height: 35,
                                width: 38,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: const BorderRadius.only(
                                    topLeft:
                                        Radius.circular(Dimensions.radiusLarge),
                                    bottomRight:
                                        Radius.circular(Dimensions.radiusLarge),
                                  ),
                                ),
                                child: Icon(
                                    isPopularItemCart
                                        ? Icons.add_shopping_cart
                                        : Icons.add,
                                    color: Theme.of(context).cardColor,
                                    size: 20),
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ]),
                ),
              ),
            ]),
          ),
        ),
      ]),
    );
  }
}

class SpecialOfferItemCard extends StatelessWidget {
  final Item item;
  final bool isPopularItem;
  final bool isFood;
  final bool isShop;
  final bool isPopularItemCart;
  const SpecialOfferItemCard(
      {super.key,
      required this.item,
      this.isPopularItem = false,
      required this.isFood,
      required this.isShop,
      this.isPopularItemCart = false});

  @override
  Widget build(BuildContext context) {
    double? discount =
        item.storeDiscount == 0 ? item.discount : item.storeDiscount;
    String? discountType =
        item.storeDiscount == 0 ? item.discountType : 'percent';

    return OnHover(
      isItem: true,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          color: Theme.of(context).cardColor,
        ),
        width: 90,
        child: CustomInkWell(
          onTap: () =>
              Get.find<ItemController>().navigateToItemPage(item, context),
          radius: Dimensions.radiusSmall,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              flex: 3,
              child: Stack(children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(Dimensions.radiusSmall),
                      topLeft: Radius.circular(Dimensions.radiusSmall)),
                  child: CustomImage(
                    placeholder: Images.placeholder,
                    image: '${item.imageFullUrl}',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
                AddFavouriteView(
                  item: item,
                  top: 0,
                  right: 0,
                ),
                const SizedBox(),
                if (discount! > 0)
                  Positioned(
                      left: 0,
                      child: ClipPath(
                        clipper: TagClipper(radius: Dimensions.radiusSmall),
                        child: Container(
                          color: Theme.of(context).primaryColor,
                          padding: const EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 3.0),
                          child: Text(
                            '${discount.toStringAsFixed(0)}${discountType == 'percent' ? '%' : Get.find<SplashController>().configModel!.currencySymbol}\n${'off'.tr}',
                            style: robotoMedium.copyWith(
                              color: Colors.white,
                              fontSize: (ResponsiveHelper.isMobile(Get.context)
                                  ? 7
                                  : 10),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )),
                OrganicTag(
                  item: item,
                  placeInImage: false,
                  placeBottom: true,
                ),
                (item.stock != null && item.stock! < 0)
                    ? Positioned(
                        bottom: 45,
                        left: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.paddingSizeSmall,
                              vertical: Dimensions.paddingSizeExtraSmall),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.5),
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(Dimensions.radiusSmall),
                              bottomRight:
                                  Radius.circular(Dimensions.radiusSmall),
                            ),
                          ),
                          child: Text('out_of_stock'.tr,
                              style: robotoRegular.copyWith(
                                  color: Theme.of(context).cardColor,
                                  fontSize: Dimensions.fontSizeSmall)),
                        ),
                      )
                    : const SizedBox(),
                Get.find<ItemController>().isAvailable(item)
                    ? const SizedBox()
                    : NotAvailableWidget(
                        radius: Dimensions.radiusSmall,
                        isAllSideRound: isPopularItem),
                if (isFood &&
                    Get.find<SplashController>()
                        .configModel!
                        .moduleConfig!
                        .module!
                        .vegNonVeg! &&
                    Get.find<SplashController>().configModel!.toggleVegNonVeg!)
                  Positioned(
                      left: 2,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(2)),
                        child: Image.asset(
                            item.veg == 0
                                ? Images.nonVegImage
                                : Images.vegImage,
                            height: 12,
                            width: 12,
                            fit: BoxFit.contain),
                      ))
              ]),
            ),
            Expanded(
              flex: (isFood || isShop) ? 5 : 4,
              child: Padding(
                padding: EdgeInsets.only(
                    left: Dimensions.paddingSizeExtraSmall,
                    right: isShop ? 0 : Dimensions.paddingSizeExtraSmall,
                    top: Dimensions.paddingSizeExtraSmall,
                    bottom: isShop ? 0 : Dimensions.paddingSizeSmall),
                child: Stack(clipBehavior: Clip.none, children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (isFood || isShop)
                          Text(item.storeName ?? '',
                              style: robotoRegular.copyWith(
                                  color: Theme.of(context).disabledColor,
                                  fontSize: Dimensions.fontSizeSmall)),
                        Text(
                          item.name ?? '',
                          style: robotoMedium,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        /*(isFood || isShop)
                            ? const SizedBox()
                            : (Get.find<SplashController>()
                                        .configModel!
                                        .moduleConfig!
                                        .module!
                                        .unit! &&
                                    item.unitType != null)
                                ? Text(
                                    '(${item.unitType ?? ''})',
                                    style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeExtraSmall,
                                        color: Theme.of(context).hintColor),
                                  )
                                : const SizedBox(),*/
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                PriceConverter.convertPrice(item.price,
                                    discount: discount,
                                    discountType: discountType),
                                style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall),
                                textDirection: TextDirection.ltr,
                                maxLines: 1,
                              ),
                            ),
                            if (discount > 0) ...[
                              const SizedBox(
                                width: 3,
                              ),
                              Flexible(
                                child: Text(
                                  PriceConverter.convertPrice(item.price),
                                  style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeExtraSmall,
                                    color: Theme.of(context).disabledColor,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textDirection: TextDirection.ltr,
                                ),
                              )
                            ],
                          ],
                        ),
                        const SizedBox(
                            height: Dimensions.paddingSizeExtraSmall),
                        isShop
                            ? const SizedBox()
                            : CartCountView(
                                item: item,
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      width: 80,
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
                                    item.choiceOptions?.isNotEmpty ?? false
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
                                                '${item.choiceOptions?.length} ${((item.choiceOptions!.length > 1) ? "options" : "option")}',
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
                                        : item.foodVariations?.isNotEmpty ??
                                                false
                                            ? Positioned(
                                                left: 10,
                                                right: 10,
                                                bottom: -6,
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 02,
                                                      horizontal: 1),
                                                  color: Theme.of(context)
                                                      .cardColor,
                                                  child: Text(
                                                    'customisable'.tr,
                                                    textAlign: TextAlign.center,
                                                    style:
                                                        robotoMedium.copyWith(
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
                              )
                      ]),
                  isShop
                      ? Positioned(
                          bottom: 0,
                          right: 0,
                          child: CartCountView(
                            item: item,
                            child: Container(
                              height: 35,
                              width: 38,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: const BorderRadius.only(
                                  topLeft:
                                      Radius.circular(Dimensions.radiusSmall),
                                  bottomRight:
                                      Radius.circular(Dimensions.radiusSmall),
                                ),
                              ),
                              child: Icon(
                                  isPopularItemCart
                                      ? Icons.add_shopping_cart
                                      : Icons.add,
                                  color: Theme.of(context).cardColor,
                                  size: 20),
                            ),
                          ),
                        )
                      : const SizedBox(),
                ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class MostPopularItemCard extends StatelessWidget {
  final Item item;
  final bool isPopularItem;
  final bool isFood;
  final bool isShop;
  final bool isPopularItemCart;
  const MostPopularItemCard(
      {super.key,
      required this.item,
      this.isPopularItem = false,
      required this.isFood,
      required this.isShop,
      this.isPopularItemCart = false});

  @override
  Widget build(BuildContext context) {
    double? discount =
        item.storeDiscount == 0 ? item.discount : item.storeDiscount;
    String? discountType =
        item.storeDiscount == 0 ? item.discountType : 'percent';

    return OnHover(
      isItem: true,
      child: Stack(children: [
        Container(
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.all(
                  Radius.circular(Dimensions.radiusDefault))),
          width: 150,
          child: CustomInkWell(
            onTap: () =>
                Get.find<ItemController>().navigateToItemPage(item, context),
            radius: Dimensions.radiusLarge,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                flex: 6,
                child: Stack(children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).hintColor.withOpacity(0.3)),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(Dimensions.radiusDefault),
                          topRight: Radius.circular(Dimensions.radiusDefault)),
                      color: Theme.of(context).cardColor,
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(Dimensions.radiusDefault),
                          topRight: Radius.circular(Dimensions.radiusDefault)),
                      child: CustomImage(
                        placeholder: Images.placeholder,
                        image: '${item.imageFullUrl}',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  ),
                  AddFavouriteView(
                    item: item,
                    top: 3,
                    right: 3,
                  ),
                  const SizedBox(),
                  if (discount! > 0)
                    Positioned(
                        left: 0,
                        child: ClipPath(
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
                                    (ResponsiveHelper.isMobile(Get.context)
                                        ? 9
                                        : 12),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )),
                  OrganicTag(
                    item: item,
                    placeInImage: false,
                    placeBottom: true,
                  ),
                  (item.stock != null && item.stock! < 0)
                      ? Positioned(
                          bottom: 45,
                          left: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingSizeSmall,
                                vertical: Dimensions.paddingSizeExtraSmall),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.5),
                              borderRadius: const BorderRadius.only(
                                topRight:
                                    Radius.circular(Dimensions.radiusLarge),
                                bottomRight:
                                    Radius.circular(Dimensions.radiusLarge),
                              ),
                            ),
                            child: Text('out_of_stock'.tr,
                                style: robotoRegular.copyWith(
                                    color: Theme.of(context).cardColor,
                                    fontSize: Dimensions.fontSizeSmall)),
                          ),
                        )
                      : const SizedBox(),
                  Get.find<ItemController>().isAvailable(item)
                      ? const SizedBox()
                      : const NotAvailableWidget(
                          radius: Dimensions.radiusLarge,
                          isAllSideRound: false),
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
                              item.veg == 0
                                  ? Images.nonVegImage
                                  : Images.vegImage,
                              height: 12,
                              width: 12,
                              fit: BoxFit.contain),
                        ))
                ]),
              ),
              Expanded(
                flex: 6,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: Dimensions.paddingSizeSmall,
                      right: isShop ? 0 : Dimensions.paddingSizeSmall,
                      top: Dimensions.paddingSizeSmall,
                      bottom: isShop ? 0 : Dimensions.paddingSizeSmall),
                  child: Stack(clipBehavior: Clip.none, children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        (isFood || isShop)
                            ? Text(item.storeName ?? '',
                                style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeExtraSmall))
                            : Text(item.name ?? '',
                                style: robotoBold.copyWith(
                                    fontSize: Dimensions.fontSizeSmall),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis),
                        (isFood || isShop)
                            ? Flexible(
                                child: Text(
                                  item.name ?? '',
                                  style: robotoBold.copyWith(
                                      fontSize: Dimensions.fontSizeSmall),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            : /* Row(
                                mainAxisAlignment: isPopularItem
                                    ? MainAxisAlignment.center
                                    : MainAxisAlignment.start,
                                children: [
                                    Icon(Icons.star,
                                        size: 12,
                                        color: Theme.of(context).primaryColor),
                                    const SizedBox(
                                        width:
                                            Dimensions.paddingSizeExtraSmall),
                                    Text(item.avgRating!.toStringAsFixed(1),
                                        style: robotoRegular.copyWith(
                                            fontSize:
                                                Dimensions.fontSizeExtraSmall)),
                                    const SizedBox(
                                        width:
                                            Dimensions.paddingSizeExtraSmall),
                                    Text("(${item.ratingCount})",
                                        style: robotoRegular.copyWith(
                                            fontSize:
                                                Dimensions.fontSizeExtraSmall,
                                            color: Theme.of(context)
                                                .disabledColor)),
                                  ]), */
                            const SizedBox(),
                        (isFood || isShop)
                            ? /* Row(
                                  mainAxisAlignment: isPopularItem
                                      ? MainAxisAlignment.center
                                      : MainAxisAlignment.start,
                                  children: [
                                      Icon(Icons.star,
                                          size: 12,
                                          color:
                                              Theme.of(context).primaryColor),
                                      const SizedBox(
                                          width:
                                              Dimensions.paddingSizeExtraSmall),
                                      Text(item.avgRating!.toStringAsFixed(1),
                                          style: robotoRegular.copyWith(
                                              fontSize: Dimensions
                                                  .fontSizeExtraSmall)),
                                      const SizedBox(
                                          width:
                                              Dimensions.paddingSizeExtraSmall),
                                      Text("(${item.ratingCount})",
                                          style: robotoRegular.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeExtraSmall,
                                              color: Theme.of(context)
                                                  .disabledColor)),
                                    ]) */
                            const SizedBox()
                            : (Get.find<SplashController>()
                                        .configModel!
                                        .moduleConfig!
                                        .module!
                                        .unit! &&
                                    item.unitType != null)
                                ? Text(
                                    '(${item.unitType ?? ''})',
                                    style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeExtraSmall,
                                        color: Theme.of(context).hintColor),
                                  )
                                : const SizedBox(),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      PriceConverter.convertPrice(item.price,
                                          discount: discount,
                                          discountType: discountType),
                                      style: robotoMedium.copyWith(
                                          fontSize: Dimensions.fontSizeDefault),
                                      textDirection: TextDirection.ltr,
                                    ),
                                    SizedBox(width: discount > 0 ? 2 : 0),
                                    discount > 0
                                        ? Text(
                                            PriceConverter.convertPrice(
                                                item.price),
                                            style: robotoMedium.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeSmall,
                                              color: Theme.of(context)
                                                  .disabledColor,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                            ),
                                            textDirection: TextDirection.ltr,
                                          )
                                        : const SizedBox(),
                                  ]),
                              Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const SizedBox(),
                                    CartCountView(
                                      item: item,
                                      child: Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          Container(
                                            width: 80,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimensions.radiusSmall),
                                              color: Theme.of(context)
                                                  .primaryColor,
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
                                            padding: const EdgeInsets.symmetric(
                                              vertical: Dimensions
                                                  .paddingSizeExtraSmall,
                                            ),
                                            child: Text(
                                              'add'.tr,
                                              style: robotoMedium.copyWith(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          item.choiceOptions?.isNotEmpty ??
                                                  false
                                              ? Positioned(
                                                  left: 15,
                                                  right: 15,
                                                  bottom: -6,
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 02,
                                                        horizontal: 1),
                                                    color: Theme.of(context)
                                                        .cardColor,
                                                    child: Text(
                                                      '${item.choiceOptions?.length} ${((item.choiceOptions!.length > 1) ? "options" : "option")}',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style:
                                                          robotoMedium.copyWith(
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
                                    const SizedBox(
                                      height: 6,
                                    ),
                                  ]),
                              // const SizedBox(
                              //     height: Dimensions.paddingSizeExtraSmall),
                            ]),
                      ],
                    )
                  ]),
                ),
              ),
            ]),
          ),
        ),
      ]),
    );
  }
}

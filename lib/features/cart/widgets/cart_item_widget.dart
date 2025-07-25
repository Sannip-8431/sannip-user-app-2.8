import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sannip/common/widgets/custom_asset_image_widget.dart';
import 'package:sannip/common/widgets/custom_ink_well.dart';
import 'package:sannip/features/cart/controllers/cart_controller.dart';
import 'package:sannip/features/language/controllers/language_controller.dart';
import 'package:sannip/features/splash/controllers/splash_controller.dart';
import 'package:sannip/features/cart/domain/models/cart_model.dart';
import 'package:sannip/features/item/domain/models/item_model.dart';
import 'package:sannip/helper/price_converter.dart';
import 'package:sannip/helper/responsive_helper.dart';
import 'package:sannip/util/dimensions.dart';
import 'package:sannip/util/images.dart';
import 'package:sannip/util/styles.dart';
import 'package:sannip/common/widgets/custom_image.dart';
import 'package:sannip/common/widgets/item_bottom_sheet.dart';
import 'package:sannip/common/widgets/rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartItemWidget extends StatelessWidget {
  final CartModel cart;
  final int cartIndex;
  final List<AddOns> addOns;
  final bool isAvailable;
  const CartItemWidget(
      {super.key,
      required this.cart,
      required this.cartIndex,
      required this.isAvailable,
      required this.addOns});

  @override
  Widget build(BuildContext context) {
    double? startingPrice = _calculatePriceWithVariation(item: cart.item);
    double? endingPrice =
        _calculatePriceWithVariation(item: cart.item, isStartingPrice: false);
    String? variationText = _setupVariationText(cart: cart);
    String addOnText = _setupAddonsText(cart: cart) ?? '';

    double? discount = cart.item!.storeDiscount == 0
        ? cart.item!.discount
        : cart.item!.storeDiscount;
    String? discountType =
        cart.item!.storeDiscount == 0 ? cart.item!.discountType : 'percent';

    return Padding(
      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
      child: Slidable(
        key: UniqueKey(),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: 0.2,
          children: [
            SlidableAction(
              onPressed: (context) {
                Get.find<CartController>()
                    .removeFromCart(cartIndex, item: cart.item);
              },
              backgroundColor: Theme.of(context).colorScheme.error,
              borderRadius: BorderRadius.horizontal(
                  right: Radius.circular(
                      Get.find<LocalizationController>().isLtr
                          ? Dimensions.radiusDefault
                          : 0),
                  left: Radius.circular(Get.find<LocalizationController>().isLtr
                      ? 0
                      : Dimensions.radiusDefault)),
              foregroundColor: Colors.white,
              icon: Icons.delete_outline,
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            boxShadow: !ResponsiveHelper.isMobile(context)
                ? [const BoxShadow()]
                : [
                    const BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      spreadRadius: 1,
                    )
                  ],
          ),
          child: CustomInkWell(
            onTap: () {
              ResponsiveHelper.isMobile(context)
                  ? showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (con) => ItemBottomSheet(
                          item: cart.item, cartIndex: cartIndex, cart: cart),
                    )
                  : showDialog(
                      context: context,
                      builder: (con) => Dialog(
                            child: ItemBottomSheet(
                                item: cart.item,
                                cartIndex: cartIndex,
                                cart: cart),
                          ));
            },
            radius: Dimensions.radiusDefault,
            padding: const EdgeInsets.symmetric(
                vertical: Dimensions.paddingSizeSmall,
                horizontal: Dimensions.paddingSizeSmall),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(Dimensions.radiusDefault),
                        child: CustomImage(
                          image: '${cart.item!.imageFullUrl}',
                          height: ResponsiveHelper.isDesktop(context) ? 90 : 70,
                          width: ResponsiveHelper.isDesktop(context) ? 90 : 70,
                          fit: BoxFit.cover,
                        ),
                      ),
                      isAvailable
                          ? const SizedBox()
                          : Positioned(
                              top: 0,
                              left: 0,
                              bottom: 0,
                              right: 0,
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.radiusSmall),
                                    color: Colors.black.withOpacity(0.6)),
                                child: Text('not_available_now_break'.tr,
                                    textAlign: TextAlign.center,
                                    style: robotoRegular.copyWith(
                                      color: Colors.white,
                                      fontSize: 8,
                                    )),
                              ),
                            ),
                    ],
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall),
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(children: [
                            if ((Get.find<SplashController>()
                                        .configModel!
                                        .moduleConfig!
                                        .module!
                                        .unit! &&
                                    cart.item!.unitType != null &&
                                    !Get.find<SplashController>()
                                        .getModuleConfig(cart.item!.moduleType)
                                        .newVariation!) ||
                                (Get.find<SplashController>()
                                        .configModel!
                                        .moduleConfig!
                                        .module!
                                        .vegNonVeg! &&
                                    Get.find<SplashController>()
                                        .configModel!
                                        .toggleVegNonVeg!))
                              if (!Get.find<SplashController>()
                                  .configModel!
                                  .moduleConfig!
                                  .module!
                                  .unit!) ...[
                                CustomAssetImageWidget(
                                  cart.item!.veg == 0
                                      ? Images.nonVegImage
                                      : Images.vegImage,
                                  height: 11,
                                  width: 11,
                                ),
                                const SizedBox(
                                    width: Dimensions.paddingSizeExtraSmall),
                              ],
                            /*: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: Dimensions
                                                .paddingSizeExtraSmall,
                                            horizontal:
                                                Dimensions.paddingSizeSmall),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.radiusSmall),
                                          color: Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.1),
                                        ),
                                        child: Text(
                                          cart.item!.unitType ?? '',
                                          style: robotoMedium.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeExtraSmall,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        ),
                                      )
                                    : const SizedBox()
                                : const SizedBox(),
                            const SizedBox(
                                width: Dimensions.paddingSizeExtraSmall),*/
                            Flexible(
                              child: Text(
                                cart.item!.name!,
                                style: robotoMedium.copyWith(
                                    fontSize: Dimensions.fontSizeDefault),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            /* SizedBox(
                                width: cart.item!.isStoreHalalActive! &&
                                        cart.item!.isHalalItem!
                                    ? Dimensions.paddingSizeExtraSmall
                                    : 0),
                            cart.item!.isStoreHalalActive! &&
                                    cart.item!.isHalalItem!
                                ? const CustomAssetImageWidget(Images.halalTag,
                                    height: 13, width: 13)
                                : const SizedBox(), */
                            const SizedBox(),
                          ]),
                          const SizedBox(height: 2),
                          if ((Get.find<SplashController>()
                                      .configModel!
                                      .moduleConfig!
                                      .module!
                                      .unit! &&
                                  cart.item!.unitType != null &&
                                  !Get.find<SplashController>()
                                      .getModuleConfig(cart.item!.moduleType)
                                      .newVariation!) ||
                              (Get.find<SplashController>()
                                      .configModel!
                                      .moduleConfig!
                                      .module!
                                      .vegNonVeg! &&
                                  Get.find<SplashController>()
                                      .configModel!
                                      .toggleVegNonVeg!))
                            if (!Get.find<SplashController>()
                                .configModel!
                                .moduleConfig!
                                .module!
                                .unit!)
                              const SizedBox()
                            else
                              Text(
                                cart.item!.unitType ?? '',
                                style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeExtraSmall,
                                ),
                              )
                          else
                            const SizedBox(),
                          const SizedBox(height: 2),
                          RatingBar(
                              rating: cart.item!.avgRating,
                              size: 12,
                              ratingCount: cart.item!.ratingCount),
                          const SizedBox(height: 5),
                          Row /*Wrap*/ (children: [
                            Text(
                              '${PriceConverter.convertPrice(startingPrice, discount: discount, discountType: discountType)}'
                              '${endingPrice != null ? ' - ${PriceConverter.convertPrice(endingPrice, discount: discount, discountType: discountType)}' : ''}',
                              style: robotoBold.copyWith(
                                  fontSize: Dimensions.fontSizeSmall),
                              textDirection: TextDirection.ltr,
                            ),
                            SizedBox(
                                width: discount! > 0
                                    ? Dimensions.paddingSizeExtraSmall
                                    : 0),
                            discount > 0
                                ? Text(
                                    '${PriceConverter.convertPrice(startingPrice)}'
                                    '${endingPrice != null ? ' - ${PriceConverter.convertPrice(endingPrice)}' : ''}',
                                    textDirection: TextDirection.ltr,
                                    style: robotoRegular.copyWith(
                                      color: Theme.of(context).disabledColor,
                                      decoration: TextDecoration.lineThrough,
                                      fontSize: Dimensions.fontSizeExtraSmall,
                                    ),
                                  )
                                : const SizedBox(),
                            const Spacer(),
                            GetBuilder<CartController>(
                                builder: (cartController) {
                              /*return Row(children: [
                                QuantityButton(
                                  onTap: cartController.isLoading
                                      ? null
                                      : () {
                                          if (cart.quantity! > 1) {
                                            Get.find<CartController>()
                                                .setQuantity(
                                                    false,
                                                    cartIndex,
                                                    cart.stock,
                                                    cart.quantityLimit);
                                          } else {
                                            Get.find<CartController>()
                                                .removeFromCart(cartIndex,
                                                    item: cart.item);
                                          }
                                        },
                                  isIncrement: false,
                                  showRemoveIcon: cart.quantity! == 1,
                                ),
                                Text(
                                  cart.quantity.toString(),
                                  style: robotoMedium.copyWith(
                                      fontSize: Dimensions.fontSizeExtraLarge),
                                ),
                                QuantityButton(
                                  onTap: cartController.isLoading
                                      ? null
                                      : () {
                                          Get.find<CartController>()
                                              .forcefullySetModule(
                                                  Get.find<CartController>()
                                                      .cartList[0]
                                                      .item!
                                                      .moduleId!);
                                          Get.find<CartController>()
                                              .setQuantity(
                                                  true,
                                                  cartIndex,
                                                  cart.stock,
                                                  cart.quantityLimit);
                                        },
                                  isIncrement: true,
                                  color: cartController.isLoading
                                      ? Theme.of(context).disabledColor
                                      : null,
                                ),
                              ]);*/
                              return Center(
                                child: Container(
                                  width: 90,
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
                                  // decoration: BoxDecoration(
                                  //   color: Theme.of(context).primaryColor,
                                  //   borderRadius:
                                  //       BorderRadius.circular(Dimensions.radiusExtraLarge),
                                  // ),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          onTap: cartController.isLoading
                                              ? null
                                              : () {
                                                  if (cart.quantity! > 1) {
                                                    Get.find<CartController>()
                                                        .setQuantity(
                                                            false,
                                                            cartIndex,
                                                            cart.stock,
                                                            cart.quantityLimit);
                                                  } else {
                                                    Get.find<CartController>()
                                                        .removeFromCart(
                                                            cartIndex,
                                                            item: cart.item);
                                                  }
                                                },
                                          child: Padding(
                                            padding: const EdgeInsets.all(
                                                Dimensions
                                                    .paddingSizeExtraSmall),
                                            child: Icon(Icons.remove,
                                                size: 18,
                                                color: Theme.of(context)
                                                    .primaryColor),
                                          ),
                                        ),
                                        !cartController.isLoading
                                            ? Text(
                                                cart.quantity.toString(),
                                                style: robotoMedium.copyWith(
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                              )
                                            : const SizedBox(
                                                height: 18,
                                                width: 18,
                                                child:
                                                    CircularProgressIndicator()),
                                        InkWell(
                                          onTap: cartController.isLoading
                                              ? null
                                              : () {
                                                  Get.find<CartController>()
                                                      .forcefullySetModule(
                                                          Get.find<
                                                                  CartController>()
                                                              .cartList[0]
                                                              .item!
                                                              .moduleId!);
                                                  Get.find<CartController>()
                                                      .setQuantity(
                                                          true,
                                                          cartIndex,
                                                          cart.stock,
                                                          cart.quantityLimit);
                                                },
                                          child: Padding(
                                            padding: const EdgeInsets.all(
                                                Dimensions
                                                    .paddingSizeExtraSmall),
                                            child: Icon(Icons.add,
                                                size: 18,
                                                color: Theme.of(context)
                                                    .primaryColor),
                                          ),
                                        ),
                                      ]),
                                ),
                              );
                            }),
                          ]),
                          cart.item!.isPrescriptionRequired!
                              ? Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical:
                                          ResponsiveHelper.isDesktop(context)
                                              ? Dimensions.paddingSizeExtraSmall
                                              : 2),
                                  child: Text(
                                    '* ${'prescription_required'.tr}',
                                    style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeExtraSmall,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .error),
                                  ),
                                )
                              : const SizedBox(),
                          ResponsiveHelper.isDesktop(context)
                              ? (Get.find<SplashController>()
                                          .configModel!
                                          .moduleConfig!
                                          .module!
                                          .addOn! &&
                                      addOnText.isNotEmpty)
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          top:
                                              Dimensions.paddingSizeExtraSmall),
                                      child: Row(children: [
                                        Text('${'addons'.tr}: ',
                                            style: robotoMedium.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeSmall)),
                                        Flexible(
                                            child: Text(
                                          addOnText,
                                          style: robotoRegular.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeSmall,
                                              color: Theme.of(context)
                                                  .disabledColor),
                                        )),
                                      ]),
                                    )
                                  : const SizedBox()
                              : const SizedBox(),
                          ResponsiveHelper.isDesktop(context)
                              ? variationText!.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          top:
                                              Dimensions.paddingSizeExtraSmall),
                                      child: Row(children: [
                                        Text('${'variations'.tr}: ',
                                            style: robotoMedium.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeSmall)),
                                        Flexible(
                                            child: Text(
                                          variationText,
                                          style: robotoRegular.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeSmall,
                                              color: Theme.of(context)
                                                  .disabledColor),
                                        )),
                                      ]),
                                    )
                                  : const SizedBox()
                              : const SizedBox(),
                        ]),
                  ),
                ]),
                !ResponsiveHelper.isDesktop(context)
                    ? (Get.find<SplashController>()
                                .configModel!
                                .moduleConfig!
                                .module!
                                .addOn! &&
                            addOnText.isNotEmpty)
                        ? Padding(
                            padding: const EdgeInsets.only(
                                top: Dimensions.paddingSizeExtraSmall),
                            child: Row(children: [
                              SizedBox(
                                  width: ResponsiveHelper.isDesktop(context)
                                      ? 100
                                      : 80),
                              Text('${'addons'.tr}: ',
                                  style: robotoMedium.copyWith(
                                      fontSize: Dimensions.fontSizeSmall)),
                              Flexible(
                                  child: Text(
                                addOnText,
                                style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall,
                                    color: Theme.of(context).disabledColor),
                              )),
                            ]),
                          )
                        : const SizedBox()
                    : const SizedBox(),
                !ResponsiveHelper.isDesktop(context)
                    ? variationText!.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(
                                top: Dimensions.paddingSizeExtraSmall),
                            child: Row(children: [
                              SizedBox(
                                  width: ResponsiveHelper.isDesktop(context)
                                      ? 100
                                      : 80),
                              Text(
                                  ResponsiveHelper.isDesktop(context)
                                      ? ''
                                      : '${'variations'.tr}: ',
                                  style: robotoMedium.copyWith(
                                      fontSize: Dimensions.fontSizeSmall)),
                              Flexible(
                                  child: Text(
                                variationText,
                                style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall,
                                    color: Theme.of(context).disabledColor),
                              )),
                            ]),
                          )
                        : const SizedBox()
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double? _calculatePriceWithVariation(
      {required Item? item, bool isStartingPrice = true}) {
    double? startingPrice;
    double? endingPrice;

    if (item!.variations!.isNotEmpty) {
      List<double?> priceList = [];
      for (var variation in item.variations!) {
        priceList.add(variation.price);
      }
      priceList.sort((a, b) => a!.compareTo(b!));
      startingPrice = priceList[0];
      if (priceList[0]! < priceList[priceList.length - 1]!) {
        endingPrice = priceList[priceList.length - 1];
      }
    } else {
      startingPrice = item.price;
    }
    if (isStartingPrice) {
      return startingPrice;
    } else {
      return endingPrice;
    }
  }

  String? _setupVariationText({required CartModel cart}) {
    String? variationText = '';

    if (Get.find<SplashController>()
        .getModuleConfig(cart.item!.moduleType)
        .newVariation!) {
      if (cart.foodVariations!.isNotEmpty) {
        for (int index = 0; index < cart.foodVariations!.length; index++) {
          if (cart.foodVariations![index].contains(true)) {
            variationText =
                '${variationText!}${variationText.isNotEmpty ? ', ' : ''}${cart.item!.foodVariations![index].name} (';
            for (int i = 0; i < cart.foodVariations![index].length; i++) {
              if (cart.foodVariations![index][i]!) {
                variationText =
                    '${variationText!}${variationText.endsWith('(') ? '' : ', '}${cart.item!.foodVariations![index].variationValues![i].level}';
              }
            }
            variationText = '${variationText!})';
          }
        }
      }
    } else {
      if (cart.variation!.isNotEmpty) {
        List<String> variationTypes = cart.variation![0].type!.split('-');
        if (variationTypes.length == cart.item!.choiceOptions!.length) {
          int index0 = 0;
          for (var choice in cart.item!.choiceOptions!) {
            variationText =
                '${variationText!}${(index0 == 0) ? '' : ',  '}${choice.title} - ${variationTypes[index0]}';
            index0 = index0 + 1;
          }
        } else {
          variationText = cart.item!.variations![0].type;
        }
      }
    }
    return variationText;
  }

  String? _setupAddonsText({required CartModel cart}) {
    String addOnText = '';
    int index0 = 0;
    List<int?> ids = [];
    List<int?> qtys = [];
    for (var addOn in cart.addOnIds!) {
      ids.add(addOn.id);
      qtys.add(addOn.quantity);
    }
    for (var addOn in cart.item!.addOns!) {
      if (ids.contains(addOn.id)) {
        addOnText =
            '$addOnText${(index0 == 0) ? '' : ',  '}${addOn.name} (${qtys[index0]})';
        index0 = index0 + 1;
      }
    }
    return addOnText;
  }
}

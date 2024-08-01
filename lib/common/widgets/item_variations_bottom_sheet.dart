// ignore_for_file: unused_local_variable

import 'package:sannip/features/cart/controllers/cart_controller.dart';
import 'package:sannip/features/item/controllers/item_controller.dart';
import 'package:sannip/features/splash/controllers/splash_controller.dart';
import 'package:sannip/features/checkout/domain/models/place_order_body_model.dart';
import 'package:sannip/features/cart/domain/models/cart_model.dart';
import 'package:sannip/features/item/domain/models/item_model.dart';
import 'package:sannip/common/models/module_model.dart';
import 'package:sannip/features/store/controllers/store_controller.dart';
import 'package:sannip/features/store/domain/models/store_model.dart';
import 'package:sannip/helper/date_converter.dart';
import 'package:sannip/helper/price_converter.dart';
import 'package:sannip/helper/responsive_helper.dart';
import 'package:sannip/helper/route_helper.dart';
import 'package:sannip/util/app_constants.dart';
import 'package:sannip/util/dimensions.dart';
import 'package:sannip/util/styles.dart';
import 'package:sannip/common/widgets/custom_button.dart';
import 'package:sannip/common/widgets/custom_snackbar.dart';
import 'package:sannip/common/widgets/quantity_button.dart';
import 'package:sannip/features/checkout/screens/checkout_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'custom_ink_well.dart';

class ItemVariationsBottomSheet extends StatefulWidget {
  final Item? item;
  final bool isCampaign;
  final CartModel? cart;
  final int? cartIndex;
  final bool inStorePage;
  const ItemVariationsBottomSheet(
      {super.key,
      required this.item,
      this.isCampaign = false,
      this.cart,
      this.cartIndex,
      this.inStorePage = false});

  @override
  State<ItemVariationsBottomSheet> createState() =>
      _ItemVariationsBottomSheetState();
}

class _ItemVariationsBottomSheetState extends State<ItemVariationsBottomSheet> {
  bool _newVariation = false;
  Store? store;

  getStoreData() async {
    store = await Get.find<StoreController>()
        .getStoreDetails(Store(id: widget.item!.storeId), false);
  }

  @override
  void initState() {
    super.initState();

    if (Get.find<SplashController>().module == null) {
      if (Get.find<SplashController>().cacheModule != null) {
        Get.find<SplashController>()
            .setCacheConfigModule(Get.find<SplashController>().cacheModule);
      }
    }
    _newVariation = Get.find<SplashController>()
            .getModuleConfig(widget.item!.moduleType)
            .newVariation ??
        false;
    Get.find<ItemController>().initData(widget.item, widget.cart);
    getStoreData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 550,
      margin: EdgeInsets.only(top: GetPlatform.isWeb ? 0 : 30),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: GetPlatform.isWeb
            ? const BorderRadius.all(Radius.circular(Dimensions.radiusDefault))
            : const BorderRadius.vertical(
                top: Radius.circular(Dimensions.radiusExtraLarge)),
      ),
      child: GetBuilder<ItemController>(builder: (itemController) {
        double? startingPrice;
        double? endingPrice;
        if (widget.item!.choiceOptions!.isNotEmpty &&
            widget.item!.foodVariations!.isEmpty) {
          List<double?> priceList = [];
          for (var variation in widget.item!.variations!) {
            priceList.add(variation.price);
          }
          priceList.sort((a, b) => a!.compareTo(b!));
          startingPrice = priceList[0];
          if (priceList[0]! < priceList[priceList.length - 1]!) {
            endingPrice = priceList[priceList.length - 1];
          }
        } else {
          startingPrice = widget.item!.price;
        }

        double? price = widget.item!.price;
        double variationPrice = 0;
        Variation? variation;
        double? initialDiscount =
            (widget.isCampaign || widget.item!.storeDiscount == 0)
                ? widget.item!.discount
                : widget.item!.storeDiscount;
        double? discount =
            (widget.isCampaign || widget.item!.storeDiscount == 0)
                ? widget.item!.discount
                : widget.item!.storeDiscount;
        String? discountType =
            (widget.isCampaign || widget.item!.storeDiscount == 0)
                ? widget.item!.discountType
                : 'percent';
        int? stock = widget.item!.stock ?? 0;

        if (discountType == 'amount') {
          discount = discount! * itemController.quantity!;
        }

        if (_newVariation) {
          for (int index = 0;
              index < widget.item!.foodVariations!.length;
              index++) {
            for (int i = 0;
                i < widget.item!.foodVariations![index].variationValues!.length;
                i++) {
              if (itemController.selectedVariations[index][i]!) {
                variationPrice += widget.item!.foodVariations![index]
                    .variationValues![i].optionPrice!;
              }
            }
          }
        } else {
          List<String> variationList = [];
          for (int index = 0;
              index < widget.item!.choiceOptions!.length;
              index++) {
            variationList.add(widget.item!.choiceOptions![index]
                .options![itemController.variationIndex![index]]
                .replaceAll(' ', ''));
          }
          String variationType = '';
          bool isFirst = true;
          for (var variation in variationList) {
            if (isFirst) {
              variationType = '$variationType$variation';
              isFirst = false;
            } else {
              variationType = '$variationType-$variation';
            }
          }

          for (Variation variations in widget.item!.variations!) {
            if (variations.type == variationType) {
              price = variations.price;
              variation = variations;
              stock = variations.stock;
              break;
            }
          }
        }

        price = price! + variationPrice;
        double priceWithDiscount =
            PriceConverter.convertWithDiscount(price, discount, discountType)!;
        double addonsCost = 0;
        List<AddOn> addOnIdList = [];
        List<AddOns> addOnsList = [];
        for (int index = 0; index < widget.item!.addOns!.length; index++) {
          if (itemController.addOnActiveList[index]) {
            addonsCost = addonsCost +
                (widget.item!.addOns![index].price! *
                    itemController.addOnQtyList[index]!);
            addOnIdList.add(AddOn(
                id: widget.item!.addOns![index].id,
                quantity: itemController.addOnQtyList[index]));
            addOnsList.add(widget.item!.addOns![index]);
          }
        }
        priceWithDiscount = priceWithDiscount;
        double? priceWithDiscountAndAddons = priceWithDiscount + addonsCost;
        bool isAvailable = DateConverter.isAvailable(
            widget.item!.availableTimeStarts, widget.item!.availableTimeEnds);

        return ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.9),
          child: Stack(
            children: [
              Column(mainAxisSize: MainAxisSize.min, children: [
                const SizedBox(height: Dimensions.paddingSizeLarge),

                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(
                        left: Dimensions.paddingSizeDefault,
                        bottom: Dimensions.paddingSizeDefault),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              right: Dimensions.paddingSizeDefault,
                              top: ResponsiveHelper.isDesktop(context)
                                  ? 0
                                  : Dimensions.paddingSizeDefault,
                            ),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Variation
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount:
                                        widget.item?.choiceOptions?.length,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                widget
                                                        .item
                                                        ?.choiceOptions?[index]
                                                        .title ??
                                                    '',
                                                style: robotoMedium.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: Dimensions
                                                        .fontSizeExtraLarge)),
                                            const SizedBox(
                                                height: Dimensions
                                                    .paddingSizeExtraSmall),
                                            GridView.builder(
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 4,
                                                crossAxisSpacing: 20,
                                                mainAxisSpacing: 10,
                                                childAspectRatio: (1 / 0.55),
                                              ),
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: widget
                                                  .item
                                                  ?.choiceOptions?[index]
                                                  .options
                                                  ?.length,
                                              itemBuilder: (context, i) {
                                                /* double? startingPrice;
                                                if (widget.item!.variations!
                                                    .isNotEmpty) {
                                                  List<double?> priceList = [];
                                                  for (var variation in widget
                                                      .item!.variations!) {
                                                    priceList
                                                        .add(variation.price);
                                                  }
                                                  priceList.sort((a, b) =>
                                                      a!.compareTo(b!));
                                                  startingPrice = priceList[i];
                                                } else {
                                                  startingPrice =
                                                      widget.item!.price;
                                                }

                                                double? discount = (widget.item!
                                                                .availableDateStarts !=
                                                            null ||
                                                        widget.item!
                                                                .storeDiscount ==
                                                            0)
                                                    ? widget.item!.discount
                                                    : widget
                                                        .item!.storeDiscount;
                                                String? discountType = (widget
                                                                .item!
                                                                .availableDateStarts !=
                                                            null ||
                                                        widget.item!
                                                                .storeDiscount ==
                                                            0)
                                                    ? widget.item!.discountType
                                                    : 'percent';*/
                                                return InkWell(
                                                  onTap: () {
                                                    itemController
                                                        .setCartVariationIndex(
                                                            index,
                                                            i,
                                                            widget.item);
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                Dimensions
                                                                    .radiusDefault),
                                                        border: Border.all(
                                                            color: itemController.variationIndex![index] == i
                                                                ? Theme.of(context)
                                                                    .primaryColor
                                                                : Theme.of(context)
                                                                    .hintColor),
                                                        color: itemController.variationIndex![
                                                                    index] ==
                                                                i
                                                            ? Theme.of(context)
                                                                .primaryColor
                                                                .withOpacity(
                                                                    0.2)
                                                            : Theme.of(context)
                                                                .cardColor),
                                                    alignment: Alignment.center,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          widget
                                                              .item!
                                                              .choiceOptions![
                                                                  index]
                                                              .options![i]
                                                              .trim(),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: robotoMedium
                                                              .copyWith(
                                                            fontSize: Dimensions
                                                                .fontSizeLarge,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        // Text(
                                                        //   PriceConverter
                                                        //       .convertPrice(
                                                        //           startingPrice,
                                                        //           discount:
                                                        //               discount,
                                                        //           discountType:
                                                        //               discountType),
                                                        //   maxLines: 1,
                                                        //   overflow: TextOverflow
                                                        //       .ellipsis,
                                                        //   style: robotoMedium
                                                        //       .copyWith(
                                                        //     fontSize: Dimensions
                                                        //         .fontSizeLarge,
                                                        //     fontWeight:
                                                        //         FontWeight.w700,
                                                        //   ),
                                                        // ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                            SizedBox(
                                                height: index !=
                                                        widget
                                                                .item!
                                                                .choiceOptions!
                                                                .length -
                                                            1
                                                    ? Dimensions
                                                        .paddingSizeLarge
                                                    : 0),
                                          ]);
                                    },
                                  ),

                                  // SizedBox(
                                  //     height: (Get.find<SplashController>()
                                  //                 .configModel!
                                  //                 .moduleConfig!
                                  //                 .module!
                                  //                 .addOn! &&
                                  //             widget.item!.addOns!.isNotEmpty)
                                  //         ? Dimensions.paddingSizeLarge
                                  //         : 0),

                                  // // Addons
                                  // (Get.find<SplashController>()
                                  //             .configModel!
                                  //             .moduleConfig!
                                  //             .module!
                                  //             .addOn! &&
                                  //         widget.item!.addOns!.isNotEmpty)
                                  //     ? AddonView(
                                  //         itemController: itemController,
                                  //         item: widget.item!)
                                  //     : const SizedBox(),

                                  isAvailable
                                      ? const SizedBox()
                                      : Container(
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.all(
                                              Dimensions.paddingSizeSmall),
                                          margin: const EdgeInsets.only(
                                              bottom:
                                                  Dimensions.paddingSizeSmall),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                Dimensions.radiusSmall),
                                            color: Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.1),
                                          ),
                                          child: Column(children: [
                                            Text('not_available_now'.tr,
                                                style: robotoMedium.copyWith(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontSize:
                                                      Dimensions.fontSizeLarge,
                                                )),
                                            Text(
                                              '${'available_will_be'.tr} ${DateConverter.convertTimeToTime(widget.item!.availableTimeStarts!)} '
                                              '- ${DateConverter.convertTimeToTime(widget.item!.availableTimeEnds!)}',
                                              style: robotoRegular,
                                            ),
                                          ]),
                                        ),
                                ]),
                          ),
                        ]),
                  ),
                ),

                ///Bottom side..
                (!widget.item!.scheduleOrder! && !isAvailable)
                    ? const SizedBox()
                    : Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: GetPlatform.isWeb
                              ? const BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(40))
                              : const BorderRadius.all(Radius.circular(0)),
                          boxShadow: ResponsiveHelper.isDesktop(context)
                              ? null
                              : const [
                                  BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 5,
                                      spreadRadius: 1)
                                ],
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeDefault,
                            vertical: Dimensions.paddingSizeDefault),
                        child: Column(children: [
                          Builder(builder: (context) {
                            double? cost = PriceConverter.convertWithDiscount(
                                (price! * itemController.quantity!),
                                discount,
                                discountType);
                            double withAddonCost = cost! + addonsCost;
                            return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${'total_amount'.tr}:',
                                      style: robotoMedium.copyWith(
                                          fontSize: Dimensions.fontSizeDefault,
                                          color:
                                              Theme.of(context).primaryColor)),
                                  const SizedBox(
                                      width: Dimensions.paddingSizeExtraSmall),
                                  Row(children: [
                                    discount! > 0
                                        ? PriceConverter.convertAnimationPrice(
                                            (price * itemController.quantity!) +
                                                addonsCost,
                                            textStyle: robotoMedium.copyWith(
                                                color: Theme.of(context)
                                                    .disabledColor,
                                                fontSize:
                                                    Dimensions.fontSizeSmall,
                                                decoration:
                                                    TextDecoration.lineThrough),
                                          )
                                        : const SizedBox(),
                                    const SizedBox(
                                        width:
                                            Dimensions.paddingSizeExtraSmall),
                                    PriceConverter.convertAnimationPrice(
                                      withAddonCost,
                                      textStyle: robotoBold.copyWith(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                  ]),
                                ]);
                          }),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          SafeArea(
                            child: Row(children: [
                              // Quantity
                              Row(children: [
                                QuantityButton(
                                  onTap: () {
                                    if (itemController.quantity! > 1) {
                                      itemController.setQuantity(false, stock,
                                          widget.item!.quantityLimit,
                                          getxSnackBar: true);
                                    }
                                  },
                                  isIncrement: false,
                                  fromSheet: true,
                                ),
                                Text(itemController.quantity.toString(),
                                    style: robotoMedium.copyWith(
                                        fontSize: Dimensions.fontSizeLarge)),
                                QuantityButton(
                                  onTap: () => itemController.setQuantity(
                                      true, stock, widget.item!.quantityLimit,
                                      getxSnackBar: true),
                                  isIncrement: true,
                                  fromSheet: true,
                                ),
                              ]),
                              const SizedBox(
                                  width: Dimensions.paddingSizeSmall),

                              Expanded(child: GetBuilder<CartController>(
                                  builder: (cartController) {
                                return CustomButton(
                                  width: ResponsiveHelper.isDesktop(context)
                                      ? MediaQuery.of(context).size.width / 2.0
                                      : null,
                                  /*buttonText: isCampaign ? 'order_now'.tr : isExistInCart ? 'already_added_in_cart'.tr : fromCart
                                          ? 'update_in_cart'.tr : 'add_to_cart'.tr,*/
                                  isLoading: cartController.isLoading,
                                  buttonText: (Get.find<SplashController>()
                                              .configModel!
                                              .moduleConfig!
                                              .module!
                                              .stock! &&
                                          stock! <= 0)
                                      ? 'out_of_stock'.tr
                                      : widget.isCampaign
                                          ? 'order_now'.tr
                                          : (widget.cart != null ||
                                                  itemController.cartIndex !=
                                                      -1)
                                              ? 'update_in_cart'.tr
                                              : 'add_to_cart'.tr,
                                  onPressed: (Get.find<SplashController>()
                                              .configModel!
                                              .moduleConfig!
                                              .module!
                                              .stock! &&
                                          stock! <= 0)
                                      ? null
                                      : () async {
                                          if (Get.find<ItemController>()
                                                  .isAvailable(widget.item!) &&
                                              Get.find<StoreController>()
                                                  .isOpenNow(
                                                      store ?? Store())) {
                                            String? invalid;
                                            if (_newVariation) {
                                              for (int index = 0;
                                                  index <
                                                      widget
                                                          .item!
                                                          .foodVariations!
                                                          .length;
                                                  index++) {
                                                if (!widget
                                                        .item!
                                                        .foodVariations![index]
                                                        .multiSelect! &&
                                                    widget
                                                        .item!
                                                        .foodVariations![index]
                                                        .required! &&
                                                    !itemController
                                                        .selectedVariations[
                                                            index]
                                                        .contains(true)) {
                                                  invalid =
                                                      '${'choose_a_variation_from'.tr} ${widget.item!.foodVariations![index].name}';
                                                  break;
                                                } else if (widget
                                                        .item!
                                                        .foodVariations![index]
                                                        .multiSelect! &&
                                                    (widget
                                                            .item!
                                                            .foodVariations![
                                                                index]
                                                            .required! ||
                                                        itemController
                                                            .selectedVariations[
                                                                index]
                                                            .contains(true)) &&
                                                    widget
                                                            .item!
                                                            .foodVariations![
                                                                index]
                                                            .min! >
                                                        itemController
                                                            .selectedVariationLength(
                                                                itemController
                                                                    .selectedVariations,
                                                                index)) {
                                                  invalid =
                                                      '${'select_minimum'.tr} ${widget.item!.foodVariations![index].min} '
                                                      '${'and_up_to'.tr} ${widget.item!.foodVariations![index].max} ${'options_from'.tr}'
                                                      ' ${widget.item!.foodVariations![index].name} ${'variation'.tr}';
                                                  break;
                                                }
                                              }
                                            }

                                            if (Get.find<SplashController>()
                                                    .moduleList !=
                                                null) {
                                              for (ModuleModel module in Get
                                                      .find<SplashController>()
                                                  .moduleList!) {
                                                if (module.id ==
                                                    widget.item!.moduleId) {
                                                  Get.find<SplashController>()
                                                      .setModule(module);
                                                  break;
                                                }
                                              }
                                            }

                                            if (invalid != null) {
                                              showCustomSnackBar(invalid,
                                                  getXSnackBar: true);
                                            } else {
                                              CartModel cartModel = CartModel(
                                                  null,
                                                  price,
                                                  priceWithDiscountAndAddons,
                                                  variation != null
                                                      ? [variation]
                                                      : [],
                                                  itemController
                                                      .selectedVariations,
                                                  (price! -
                                                      PriceConverter
                                                          .convertWithDiscount(
                                                              price,
                                                              discount,
                                                              discountType)!),
                                                  itemController.quantity,
                                                  addOnIdList,
                                                  addOnsList,
                                                  widget.isCampaign,
                                                  stock,
                                                  widget.item,
                                                  widget.item?.quantityLimit);

                                              List<OrderVariation> variations =
                                                  _getSelectedVariations(
                                                isFoodVariation:
                                                    Get.find<SplashController>()
                                                        .getModuleConfig(widget
                                                            .item!.moduleType)
                                                        .newVariation!,
                                                foodVariations: widget
                                                    .item!.foodVariations!,
                                                selectedVariations:
                                                    itemController
                                                        .selectedVariations,
                                              );
                                              List<int?> listOfAddOnId =
                                                  _getSelectedAddonIds(
                                                      addOnIdList: addOnIdList);
                                              List<int?> listOfAddOnQty =
                                                  _getSelectedAddonQtnList(
                                                      addOnIdList: addOnIdList);

                                              OnlineCart onlineCart = OnlineCart(
                                                  widget.cart?.id,
                                                  widget.isCampaign
                                                      ? null
                                                      : widget.item!.id,
                                                  widget.isCampaign
                                                      ? widget.item!.id
                                                      : null,
                                                  priceWithDiscountAndAddons
                                                      .toString(),
                                                  '',
                                                  variation != null
                                                      ? [variation]
                                                      : null,
                                                  Get.find<SplashController>()
                                                          .getModuleConfig(
                                                              widget.item!
                                                                  .moduleType)
                                                          .newVariation!
                                                      ? variations
                                                      : null,
                                                  itemController.quantity,
                                                  listOfAddOnId,
                                                  addOnsList,
                                                  listOfAddOnQty,
                                                  'Item');

                                              if (widget.isCampaign) {
                                                Get.toNamed(
                                                    RouteHelper
                                                        .getCheckoutRoute(
                                                            'campaign'),
                                                    arguments: CheckoutScreen(
                                                      storeId: null,
                                                      fromCart: false,
                                                      cartList: [cartModel],
                                                    ));
                                              } else {
                                                if (Get.find<CartController>()
                                                    .existAnotherStoreItem(
                                                  cartModel.item!.storeId,
                                                  Get.find<SplashController>()
                                                              .module !=
                                                          null
                                                      ? Get.find<
                                                              SplashController>()
                                                          .module!
                                                          .id
                                                      : Get.find<
                                                              SplashController>()
                                                          .cacheModule!
                                                          .id,
                                                )) {
                                                  Get.dialog(
                                                      Dialog(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    Dimensions
                                                                        .radiusDefault)),
                                                        insetPadding:
                                                            const EdgeInsets
                                                                .all(60),
                                                        clipBehavior: Clip
                                                            .antiAliasWithSaveLayer,
                                                        child: Padding(
                                                          padding: const EdgeInsets
                                                              .all(Dimensions
                                                                  .paddingSizeSmall),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              const SizedBox(
                                                                height: Dimensions
                                                                    .paddingSizeExtraSmall,
                                                              ),
                                                              Text(
                                                                  'replace_cart_item'
                                                                      .tr,
                                                                  style:
                                                                      robotoBold),
                                                              const SizedBox(
                                                                height: Dimensions
                                                                    .paddingSizeSmall,
                                                              ),
                                                              Text(
                                                                  Get.find<SplashController>()
                                                                          .configModel!
                                                                          .moduleConfig!
                                                                          .module!
                                                                          .showRestaurantText!
                                                                      ? 'if_you_continue'
                                                                          .tr
                                                                      : 'if_you_continue_without_another_store'
                                                                          .tr,
                                                                  style:
                                                                      robotoRegular),
                                                              const SizedBox(
                                                                height: Dimensions
                                                                    .paddingSizeLarge,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        CustomInkWell(
                                                                      onTap:
                                                                          () {
                                                                        Get.back();
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(Dimensions.radiusSmall),
                                                                          color: Theme.of(context)
                                                                              .primaryColor
                                                                              .withOpacity(0.2),
                                                                        ),
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            vertical:
                                                                                Dimensions.paddingSizeSmall),
                                                                        child:
                                                                            Text(
                                                                          'no'.tr,
                                                                          style:
                                                                              robotoRegular.copyWith(
                                                                            color:
                                                                                Theme.of(context).primaryColor,
                                                                          ),
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: Dimensions
                                                                        .paddingSizeLarge,
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        CustomInkWell(
                                                                      onTap:
                                                                          () {
                                                                        Get.back();
                                                                        Get.find<CartController>()
                                                                            .clearCartOnline()
                                                                            .then((success) async {
                                                                          if (success) {
                                                                            await Get.find<CartController>().addToCartOnline(onlineCart);
                                                                            Get.back();
                                                                            //showCartSnackBar();
                                                                          }
                                                                        });
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(Dimensions.radiusSmall),
                                                                          color:
                                                                              Theme.of(context).primaryColor,
                                                                        ),
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            vertical:
                                                                                Dimensions.paddingSizeSmall),
                                                                        child:
                                                                            Text(
                                                                          'replace'
                                                                              .tr,
                                                                          style:
                                                                              robotoRegular.copyWith(
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      /*ConfirmationDialog(
                                                      icon: Images.warning,
                                                      title:
                                                          'are_you_sure_to_reset'
                                                              .tr,
                                                      description: Get.find<
                                                                  SplashController>()
                                                              .configModel!
                                                              .moduleConfig!
                                                              .module!
                                                              .showRestaurantText!
                                                          ? 'if_you_continue'.tr
                                                          : 'if_you_continue_without_another_store'
                                                              .tr,
                                                      onYesPressed: () {
                                                        Get.back();
                                                        Get.find<
                                                                CartController>()
                                                            .clearCartOnline()
                                                            .then(
                                                                (success) async {
                                                          if (success) {
                                                            await Get.find<
                                                                    CartController>()
                                                                .addToCartOnline(
                                                                    onlineCart);
                                                            Get.back();
                                                            //showCartSnackBar();
                                                          }
                                                        });
                                                      },
                                                    ),*/
                                                      barrierDismissible:
                                                          false);
                                                } else {
                                                  if (widget.cart != null ||
                                                      itemController
                                                              .cartIndex !=
                                                          -1) {
                                                    await Get.find<
                                                            CartController>()
                                                        .updateCartOnline(
                                                            onlineCart)
                                                        .then((success) {
                                                      if (success) {
                                                        Get.back();
                                                      }
                                                    });
                                                  } else {
                                                    await Get.find<
                                                            CartController>()
                                                        .addToCartOnline(
                                                            onlineCart)
                                                        .then((success) {
                                                      if (success) {
                                                        Get.back();
                                                      }
                                                    });
                                                  }

                                                  //showCartSnackBar();
                                                }
                                              }
                                            }
                                          } else {
                                            _showNotAcceptingOrdersDialog(
                                                context);
                                          }
                                        },
                                );
                              })),
                            ]),
                          ),
                        ]),
                      ),
              ]),
              Positioned(
                top: 5,
                right: 10,
                child: InkWell(
                  onTap: () => Get.back(),
                  child: Container(
                    padding:
                        const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.3),
                            blurRadius: 5)
                      ],
                    ),
                    child: const Icon(Icons.close, size: 14),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  List<OrderVariation> _getSelectedVariations(
      {required bool isFoodVariation,
      required List<FoodVariation>? foodVariations,
      required List<List<bool?>> selectedVariations}) {
    List<OrderVariation> variations = [];
    if (isFoodVariation) {
      for (int i = 0; i < foodVariations!.length; i++) {
        if (selectedVariations[i].contains(true)) {
          variations.add(OrderVariation(
              name: foodVariations[i].name,
              values: OrderVariationValue(label: [])));
          for (int j = 0; j < foodVariations[i].variationValues!.length; j++) {
            if (selectedVariations[i][j]!) {
              variations[variations.length - 1]
                  .values!
                  .label!
                  .add(foodVariations[i].variationValues![j].level);
            }
          }
        }
      }
    }
    return variations;
  }

  List<int?> _getSelectedAddonIds({required List<AddOn> addOnIdList}) {
    List<int?> listOfAddOnId = [];
    for (var addOn in addOnIdList) {
      listOfAddOnId.add(addOn.id);
    }
    return listOfAddOnId;
  }

  List<int?> _getSelectedAddonQtnList({required List<AddOn> addOnIdList}) {
    List<int?> listOfAddOnQty = [];
    for (var addOn in addOnIdList) {
      listOfAddOnQty.add(addOn.quantity);
    }
    return listOfAddOnQty;
  }

  void _showNotAcceptingOrdersDialog(BuildContext context) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
        insetPadding: const EdgeInsets.all(80),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: Dimensions.paddingSizeSmall,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeExtraLarge),
              child: Text(
                'item_is_currently_unavailable'.tr,
                style: robotoBold,
                textAlign: TextAlign.center,
              ),
            ),
            if (Get.find<SplashController>().module?.moduleType.toString() ==
                AppConstants.food) ...[
              const SizedBox(
                height: Dimensions.paddingSizeSmall,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeExtraLarge),
                child: Text(
                  '${'will_be_available_between'.tr} ${DateConverter.convertTimeToTime(widget.item!.availableTimeStarts!)} - ${DateConverter.convertTimeToTime(widget.item!.availableTimeEnds!)}',
                  style: robotoRegular,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            const SizedBox(
              height: Dimensions.paddingSizeSmall,
            ),
            const Divider(
              height: 0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: CustomInkWell(
                      padding: const EdgeInsets.symmetric(
                          vertical: Dimensions.paddingSizeExtraSmall),
                      child: Text(
                        'okay'.tr,
                        style: robotoBold,
                        textAlign: TextAlign.center,
                      ),
                      onTap: () {
                        Get.back();
                      }),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

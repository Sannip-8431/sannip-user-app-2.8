// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sannip/common/widgets/custom_ink_well.dart';
import 'package:sannip/features/cart/controllers/cart_controller.dart';
import 'package:sannip/features/checkout/widgets/prescription_image_picker_widget.dart';
import 'package:sannip/features/coupon/controllers/coupon_controller.dart';
import 'package:sannip/features/splash/controllers/splash_controller.dart';
import 'package:sannip/features/profile/controllers/profile_controller.dart';
import 'package:sannip/common/models/config_model.dart';
import 'package:sannip/features/checkout/controllers/checkout_controller.dart';
import 'package:sannip/helper/auth_helper.dart';
import 'package:sannip/helper/price_converter.dart';
import 'package:sannip/helper/responsive_helper.dart';
import 'package:sannip/util/dimensions.dart';
import 'package:sannip/util/images.dart';
import 'package:sannip/util/styles.dart';
import 'package:sannip/features/checkout/widgets/condition_check_box.dart';
import 'package:sannip/features/checkout/widgets/coupon_section.dart';
import 'package:sannip/features/checkout/widgets/note_prescription_section.dart';
import 'package:sannip/features/checkout/widgets/partial_pay_view.dart';

class BottomSection extends StatelessWidget {
  final CheckoutController checkoutController;
  final double total;
  final Module module;
  final double subTotal;
  final double discount;
  final CouponController couponController;
  final bool taxIncluded;
  final double tax;
  final double deliveryCharge;
  final bool todayClosed;
  final bool tomorrowClosed;
  final double orderAmount;
  final double? maxCodOrderAmount;
  final int? storeId;
  final double? taxPercent;
  final double price;
  final double addOns;
  final Widget? checkoutButton;
  final bool isPrescriptionRequired;
  final double referralDiscount;

  BottomSection(
      {super.key,
      required this.checkoutController,
      required this.total,
      required this.module,
      required this.subTotal,
      required this.discount,
      required this.couponController,
      required this.taxIncluded,
      required this.tax,
      required this.deliveryCharge,
      required this.todayClosed,
      required this.tomorrowClosed,
      required this.orderAmount,
      this.maxCodOrderAmount,
      this.storeId,
      this.taxPercent,
      required this.price,
      required this.addOns,
      this.checkoutButton,
      required this.isPrescriptionRequired,
      required this.referralDiscount});

  bool isAdditionalChargeExpanded = false;

  @override
  Widget build(BuildContext context) {
    bool takeAway = checkoutController.orderType == 'take_away';
    bool isDesktop = ResponsiveHelper.isDesktop(context);
    bool isGuestLoggedIn = AuthHelper.isGuestLoggedIn();
    return Container(
      decoration: ResponsiveHelper.isDesktop(context)
          ? BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)
              ],
            )
          : null,
      padding: const EdgeInsets.symmetric(
          vertical: Dimensions.paddingSizeExtraSmall),
      child: Column(children: [
        isDesktop
            ? pricingView(context: context, takeAway: takeAway)
            : const SizedBox(),

        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

        /// Coupon
        isDesktop && !isGuestLoggedIn
            ? CouponSection(
                storeId: storeId,
                checkoutController: checkoutController,
                total: total,
                price: price,
                discount: discount,
                addOns: addOns,
                deliveryCharge: deliveryCharge,
              )
            : const SizedBox(),

        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).primaryColor.withOpacity(0.05),
                  blurRadius: 10)
            ],
          ),
          padding: const EdgeInsets.symmetric(
              vertical: Dimensions.paddingSizeDefault,
              horizontal: Dimensions.paddingSizeLarge),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ///Additional Note & prescription..
            if (isDesktop)
              NoteAndPrescriptionSection(
                  checkoutController: checkoutController, storeId: storeId),

            isDesktop && !isGuestLoggedIn
                ? PartialPayView(
                    totalPrice: total, isPrescription: storeId != null)
                : const SizedBox(),

            !isDesktop
                ? pricingView(context: context, takeAway: takeAway)
                : const SizedBox(),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            ///ToDo : Prescription Image Picker
            PrescriptionImagePickerWidget(
                checkoutController: checkoutController,
                storeId: storeId,
                isPrescriptionRequired: isPrescriptionRequired),

            const CheckoutCondition(),

            const SizedBox(height: Dimensions.paddingSizeLarge),
            ResponsiveHelper.isDesktop(context)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('total_amount'.tr,
                                    style: robotoMedium.copyWith(
                                        fontSize: Dimensions.fontSizeLarge,
                                        color: Theme.of(context).primaryColor)),
                                storeId == null
                                    ? const SizedBox()
                                    : Text(
                                        'Once_your_order_is_confirmed_you_will_receive'
                                            .tr,
                                        style: robotoRegular.copyWith(
                                          fontSize:
                                              Dimensions.fontSizeOverSmall,
                                          color:
                                              Theme.of(context).disabledColor,
                                        ),
                                      ),
                              ],
                            ),
                            storeId == null
                                ? const SizedBox()
                                : Text(
                                    'a_notification_with_your_bill_total'.tr,
                                    style: robotoRegular.copyWith(
                                      fontSize: Dimensions.fontSizeOverSmall,
                                      color: Theme.of(context).disabledColor,
                                    ),
                                  ),
                          ],
                        ),
                        PriceConverter.convertAnimationPrice(
                          checkoutController.viewTotalPrice,
                          textStyle: robotoMedium.copyWith(
                              fontSize: Dimensions.fontSizeLarge,
                              color: checkoutController.isPartialPay
                                  ? Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .color
                                  : Theme.of(context).primaryColor),
                        ),
                      ])
                : const SizedBox(),
          ]),
        ),

        ResponsiveHelper.isDesktop(context)
            ? Padding(
                padding:
                    const EdgeInsets.only(top: Dimensions.paddingSizeLarge),
                child: checkoutButton,
              )
            : const SizedBox(),
      ]),
    );
  }

  Widget pricingView({required BuildContext context, required bool takeAway}) {
    return Column(children: [
      ResponsiveHelper.isDesktop(context)
          ? Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeDefault,
                    vertical: Dimensions.paddingSizeSmall),
                child: Text('order_summary'.tr,
                    style: robotoBold.copyWith(
                        fontSize: Dimensions.fontSizeLarge)),
              ),
            )
          : const SizedBox(),
      Padding(
        padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.isDesktop(context)
                ? Dimensions.paddingSizeLarge
                : 0),
        child: Column(
          children: [
            if (storeId == null) ...[
              Row(
                children: [
                  Text('billing_information'.tr,
                      style: robotoMedium.copyWith(
                          fontSize: Dimensions.fontSizeLarge,
                          fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),
            ],
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    spreadRadius: 1,
                  )
                ],
              ),
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: Column(
                children: [
                  storeId == null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                              Text(
                                  module.addOn!
                                      ? 'subtotal'.tr
                                      : 'item_price'.tr,
                                  style: robotoMedium),
                              Text(PriceConverter.convertPrice(subTotal),
                                  style: robotoMedium,
                                  textDirection: TextDirection.ltr),
                            ])
                      : const SizedBox(),
                  if (discount != 0) ...[
                    SizedBox(
                        height:
                            storeId == null ? Dimensions.paddingSizeSmall : 0),
                    storeId == null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Text('sannip_discounts'.tr,
                                    style: robotoRegular),
                                Text(
                                    '(-) ${PriceConverter.convertPrice(discount)}',
                                    style: robotoRegular,
                                    textDirection: TextDirection.ltr),
                              ])
                        : const SizedBox(),
                  ],
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  (couponController.discount! > 0 ||
                          couponController.freeDelivery)
                      ? Column(children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('coupon_discount'.tr,
                                    style: robotoRegular),
                                (couponController.coupon != null &&
                                        couponController.coupon!.couponType ==
                                            'free_delivery')
                                    ? Text(
                                        'free_delivery'.tr,
                                        style: robotoRegular.copyWith(
                                            color:
                                                Theme.of(context).primaryColor),
                                      )
                                    : Text(
                                        '(-) ${PriceConverter.convertPrice(couponController.discount)}',
                                        style: robotoRegular,
                                        textDirection: TextDirection.ltr,
                                      ),
                              ]),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                        ])
                      : const SizedBox(),
                  referralDiscount > 0
                      ? Column(children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('referral_discount'.tr,
                                    style: robotoRegular),
                                Text(
                                  '(-) ${PriceConverter.convertPrice(referralDiscount)}',
                                  style: robotoRegular,
                                  textDirection: TextDirection.ltr,
                                ),
                              ]),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                        ])
                      : const SizedBox(),
                  /*storeId == null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                              Text(
                                  '${'vat_tax'.tr} ${taxIncluded ? 'tax_included'.tr : ''} ($taxPercent%)',
                                  style: robotoRegular),
                              Text(
                                  (taxIncluded ? '' : '(+) ') +
                                      PriceConverter.convertPrice(tax),
                                  style: robotoRegular,
                                  textDirection: TextDirection.ltr),
                            ])
                      : const SizedBox(),
                  SizedBox(
                      height:
                          storeId == null ? Dimensions.paddingSizeSmall : 0),*/
                  (!takeAway &&
                          Get.find<SplashController>()
                                  .configModel!
                                  .dmTipsStatus ==
                              1 &&
                          checkoutController.tips != 0.0)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('delivery_man_tips'.tr, style: robotoRegular),
                            Text(
                                '(+) ${PriceConverter.convertPrice(checkoutController.tips)}',
                                style: robotoRegular,
                                textDirection: TextDirection.ltr),
                          ],
                        )
                      : const SizedBox.shrink(),
                  SizedBox(
                      height: !takeAway &&
                              Get.find<SplashController>()
                                      .configModel!
                                      .dmTipsStatus ==
                                  1 &&
                              checkoutController.tips != 0.0
                          ? Dimensions.paddingSizeSmall
                          : 0.0),
                  (checkoutController.store!.extraPackagingStatus! &&
                          Get.find<CartController>().needExtraPackage)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('packaging_fee'.tr, style: robotoRegular),
                            Text(
                                '(+) ${PriceConverter.convertPrice(checkoutController.store!.extraPackagingAmount!)}',
                                style: robotoRegular,
                                textDirection: TextDirection.ltr),
                          ],
                        )
                      : const SizedBox.shrink(),
                  SizedBox(
                      height: checkoutController.store!.extraPackagingStatus! &&
                              Get.find<CartController>().needExtraPackage
                          ? Dimensions.paddingSizeSmall
                          : 0.0),
                  (AuthHelper.isGuestLoggedIn() &&
                          checkoutController.guestAddress == null)
                      ? const SizedBox()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                              Text('delivery_fee'.tr, style: robotoRegular),
                              checkoutController.distance == -1
                                  ? Text(
                                      'calculating'.tr,
                                      style: robotoRegular.copyWith(
                                          color: Colors.red),
                                    )
                                  : (deliveryCharge == 0 ||
                                          (couponController.coupon != null &&
                                              couponController
                                                      .coupon!.couponType ==
                                                  'free_delivery'))
                                      ? Text(
                                          'free'.tr,
                                          style: robotoMedium.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        )
                                      : Text(
                                          '(+) ${PriceConverter.convertPrice(deliveryCharge)}',
                                          style: robotoRegular,
                                          textDirection: TextDirection.ltr,
                                        ),
                            ]),
                  SizedBox(
                      height: Get.find<SplashController>()
                                  .configModel!
                                  .additionalChargeStatus! &&
                              !(AuthHelper.isGuestLoggedIn() &&
                                  checkoutController.guestAddress == null)
                          ? Dimensions.paddingSizeSmall
                          : 0),
                  Get.find<SplashController>()
                          .configModel!
                          .additionalChargeStatus!
                      ? StatefulBuilder(builder: (context, set) {
                          return Column(
                            children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                            Get.find<SplashController>()
                                                .configModel!
                                                .additionalChargeName!,
                                            style: robotoRegular),
                                        const SizedBox(
                                          width:
                                              Dimensions.paddingSizeExtraSmall,
                                        ),
                                        CustomInkWell(
                                          onTap: () {
                                            Get.dialog(
                                                additionalChargeDialog());
                                          },
                                          child: Image.asset(
                                            Images.infoIcon,
                                            height: 13,
                                            width: 13,
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        CustomInkWell(
                                            child: Icon(
                                                !isAdditionalChargeExpanded
                                                    ? Icons.expand_more
                                                    : Icons.expand_less),
                                            onTap: () {
                                              set(() {
                                                isAdditionalChargeExpanded =
                                                    !isAdditionalChargeExpanded;
                                              });
                                            }),
                                        const SizedBox(
                                          width:
                                              Dimensions.paddingSizeExtraSmall,
                                        ),
                                        Text(
                                          '(+) ${PriceConverter.convertPrice(Get.find<SplashController>().configModel!.additionCharge)}',
                                          style: robotoRegular,
                                          textDirection: TextDirection.ltr,
                                        ),
                                      ],
                                    ),
                                  ]),
                              if (isAdditionalChargeExpanded)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: Dimensions.paddingSizeSmall),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Platform Charges',
                                            style: robotoRegular.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeSmall)),
                                        Text(
                                          PriceConverter.convertPrice(
                                              Get.find<SplashController>()
                                                  .configModel!
                                                  .additionCharge),
                                          style: robotoMedium.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeSmall),
                                          textDirection: TextDirection.ltr,
                                        ),
                                      ]),
                                ),
                            ],
                          );
                        })
                      : const SizedBox(),
                  SizedBox(
                      height: checkoutController.isPartialPay
                          ? Dimensions.paddingSizeSmall
                          : 0),
                  checkoutController.isPartialPay
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                              Text('paid_by_wallet'.tr, style: robotoRegular),
                              Text(
                                  '(-) ${PriceConverter.convertPrice(Get.find<ProfileController>().userInfoModel!.walletBalance!)}',
                                  style: robotoRegular,
                                  textDirection: TextDirection.ltr),
                            ])
                      : const SizedBox(),
                  SizedBox(
                      height: checkoutController.isPartialPay
                          ? Dimensions.paddingSizeSmall
                          : 0),
                  checkoutController.isPartialPay
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                              Text(
                                'due_payment'.tr,
                                style: robotoMedium.copyWith(
                                    fontSize: Dimensions.fontSizeLarge,
                                    color: !ResponsiveHelper.isDesktop(context)
                                        ? Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .color
                                        : Theme.of(context).primaryColor),
                              ),
                              PriceConverter.convertAnimationPrice(
                                checkoutController.viewTotalPrice,
                                textStyle: robotoMedium.copyWith(
                                    fontSize: Dimensions.fontSizeLarge,
                                    color: !ResponsiveHelper.isDesktop(context)
                                        ? Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .color
                                        : Theme.of(context).primaryColor),
                              )
                            ])
                      : const SizedBox(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: Dimensions.paddingSizeExtraSmall),
                    child: Divider(
                        thickness: 1,
                        height: 6,
                        color: Theme.of(context).hintColor.withOpacity(0.5)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        /*horizontal: Dimensions.paddingSizeLarge,
                    vertical: Dimensions.paddingSizeExtraSmall*/
                        ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            checkoutController.isPartialPay
                                ? 'due_payment'.tr
                                : 'total_amount'.tr,
                            style: robotoMedium.copyWith(
                              fontSize: Dimensions.fontSizeLarge,
                            ),
                          ),
                          PriceConverter.convertAnimationPrice(
                            checkoutController.viewTotalPrice,
                            textStyle: robotoMedium.copyWith(
                              fontSize: Dimensions.fontSizeLarge,
                            ),
                          ),
                        ]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ]);
  }

  Widget additionalChargeDialog() {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
      insetPadding: const EdgeInsets.all(60),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: Dimensions.paddingSizeExtraSmall,
          ),
          Text(Get.find<SplashController>().configModel!.additionalChargeName!,
              style: robotoBold),
          const SizedBox(
            height: Dimensions.paddingSizeSmall,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeSmall),
            child:
                Text('additional_charges_description'.tr, style: robotoRegular),
          ),
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
    );
  }
}

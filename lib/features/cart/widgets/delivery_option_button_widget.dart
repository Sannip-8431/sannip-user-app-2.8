import 'package:sannip/features/cart/controllers/cart_controller.dart';
import 'package:sannip/features/cart/domain/models/cart_model.dart';
import 'package:sannip/features/checkout/widgets/time_slot_bottom_sheet.dart';
import 'package:sannip/features/splash/controllers/splash_controller.dart';
import 'package:sannip/features/checkout/controllers/checkout_controller.dart';
import 'package:sannip/helper/auth_helper.dart';
import 'package:sannip/helper/responsive_helper.dart';
import 'package:sannip/util/dimensions.dart';
import 'package:sannip/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/models/config_model.dart';

class DeliveryOptionButtonWidget extends StatefulWidget {
  final String value;
  final String title;
  final double? charge;
  final bool? isFree;
  final bool fromWeb;
  final double total;
  final bool? isDesignChange;
  final String? icon;
  final int? storeId;
  final List<CartModel?>? cartList;
  final bool? tomorrowClosed;
  final bool? todayClosed;
  final Module? module;

  const DeliveryOptionButtonWidget({
    super.key,
    required this.value,
    required this.title,
    required this.charge,
    required this.isFree,
    this.fromWeb = false,
    required this.total,
    this.isDesignChange,
    this.icon,
    this.storeId,
    this.cartList,
    this.tomorrowClosed,
    this.todayClosed,
    this.module,
  });

  @override
  State<DeliveryOptionButtonWidget> createState() =>
      _DeliveryOptionButtonWidgetState();
}

class _DeliveryOptionButtonWidgetState
    extends State<DeliveryOptionButtonWidget> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 200), () {
      Get.find<CheckoutController>().setOrderType(
          Get.find<SplashController>().configModel!.homeDeliveryStatus == 1 &&
                  Get.find<CheckoutController>().store!.delivery!
              ? 'delivery'
              : 'take_away',
          notify: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isGuestLoggedIn = AuthHelper.isGuestLoggedIn();
    return GetBuilder<CheckoutController>(
      builder: (checkoutController) {
        bool select = checkoutController.orderType == widget.value;
        return InkWell(
          onTap: () {
            checkoutController.setOrderType(widget.value);
            checkoutController.setInstruction(-1);

            if (checkoutController.orderType == 'take_away') {
              Get.find<CartController>().toggleExtraPackage(isSetTrue: true);
              if (checkoutController.isPartialPay) {
                double tips = 0;
                try {
                  tips = double.parse(checkoutController.tipController.text);
                } catch (_) {}
                checkoutController.checkBalanceStatus(
                    widget.total, widget.charge! + tips);
              }
            } else {
              Get.find<CartController>().toggleExtraPackage();
              if (checkoutController.isPartialPay) {
                checkoutController.changePartialPayment();
              } else {
                checkoutController.setPaymentMethod(-1);
              }
            }
          },
          child: widget.isDesignChange == true
              ? Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: (!isGuestLoggedIn &&
                                widget.storeId == null &&
                                checkoutController.store!.scheduleOrder! &&
                                widget.cartList!.isNotEmpty &&
                                widget.cartList![0]!.item!
                                        .availableDateStarts ==
                                    null &&
                                select)
                            ? const BorderRadius.only(
                                topLeft:
                                    Radius.circular(Dimensions.radiusSmall),
                                bottomLeft:
                                    Radius.circular(Dimensions.radiusSmall),
                              )
                            : BorderRadius.circular(Dimensions.radiusSmall),
                        color: select
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).disabledColor.withOpacity(0.3),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeExtraSmall,
                          vertical: Dimensions.paddingSizeExtraSmall),
                      child: Row(
                        children: [
                          if (widget.icon != null)
                            Image.asset(
                              widget.icon!,
                              height: 19,
                              width: 19,
                              color: select
                                  ? Colors.white
                                  : Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .color,
                            ),
                          const SizedBox(
                              width: Dimensions.paddingSizeExtraSmall),
                          Text(widget.title,
                              style: robotoMedium.copyWith(
                                  fontSize: Dimensions.fontSizeSmall,
                                  color: select
                                      ? Colors.white
                                      : Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .color)),
                        ],
                      ),
                    ),
                    if (!isGuestLoggedIn &&
                        widget.storeId == null &&
                        checkoutController.store!.scheduleOrder! &&
                        widget.cartList!.isNotEmpty &&
                        widget.cartList![0]!.item!.availableDateStarts ==
                            null &&
                        select)
                      InkWell(
                        onTap: () {
                          if (ResponsiveHelper.isDesktop(context)) {
                            showDialog(
                                context: context,
                                builder: (con) => Dialog(
                                      child: TimeSlotBottomSheet(
                                        tomorrowClosed:
                                            widget.tomorrowClosed ?? false,
                                        todayClosed:
                                            widget.todayClosed ?? false,
                                        module: widget.module,
                                      ),
                                    ));
                          } else {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (con) => TimeSlotBottomSheet(
                                tomorrowClosed: widget.tomorrowClosed ?? false,
                                todayClosed: widget.todayClosed ?? false,
                                module: widget.module,
                              ),
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.paddingSizeExtraSmall,
                              vertical: Dimensions.paddingSizeExtraSmall),
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topRight:
                                    Radius.circular(Dimensions.radiusSmall),
                                bottomRight:
                                    Radius.circular(Dimensions.radiusSmall),
                              ),
                              border: Border.all(
                                color: select
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context)
                                        .disabledColor
                                        .withOpacity(0.3),
                              )),
                          child: Row(
                            children: [
                              Text(
                                  checkoutController
                                              .preferableTime.isNotEmpty &&
                                          (checkoutController.preferableTime !=
                                                  'instance'.tr &&
                                              checkoutController
                                                      .preferableTime !=
                                                  'now'.tr)
                                      ? checkoutController.preferableTime
                                          .substring(0, 8)
                                      : 'now'.tr,
                                  style: robotoMedium.copyWith(
                                      fontSize: Dimensions.fontSizeSmall,
                                      color: select
                                          ? Theme.of(context).primaryColor
                                          : Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .color)),
                              Icon(Icons.expand_more,
                                  size: 15,
                                  color: select
                                      ? Theme.of(context).primaryColor
                                      : Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .color)
                            ],
                          ),
                        ),
                      )
                  ],
                )
              : Container(
                  decoration: BoxDecoration(
                      color: select
                          ? widget.fromWeb
                              ? Theme.of(context).primaryColor.withOpacity(0.05)
                              : Theme.of(context).cardColor
                          : Colors.transparent,
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusSmall),
                      border: Border.all(
                          color: select
                              ? Theme.of(context).primaryColor
                              : Colors.transparent),
                      boxShadow: [
                        BoxShadow(
                            color: select
                                ? Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.1)
                                : Colors.transparent,
                            blurRadius: 10)
                      ]),
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeSmall,
                      vertical: Dimensions.paddingSizeExtraSmall),
                  child: Row(
                    children: [
                      Radio(
                        value: widget.value,
                        groupValue: checkoutController.orderType,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onChanged: (String? value) {
                          checkoutController.setOrderType(value);
                        },
                        activeColor: Theme.of(context).primaryColor,
                        visualDensity:
                            const VisualDensity(horizontal: -3, vertical: -3),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeSmall),
                      Text(widget.title,
                          style: robotoMedium.copyWith(
                              color: select
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .color)),
                      const SizedBox(width: 5),
                    ],
                  ),
                ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:sannip/features/splash/controllers/splash_controller.dart';
import 'package:sannip/features/profile/controllers/profile_controller.dart';
import 'package:sannip/features/checkout/controllers/checkout_controller.dart';
import 'package:sannip/helper/auth_helper.dart';
import 'package:sannip/helper/price_converter.dart';
import 'package:sannip/helper/responsive_helper.dart';
import 'package:sannip/util/app_constants.dart';
import 'package:sannip/util/dimensions.dart';
import 'package:sannip/util/images.dart';
import 'package:sannip/util/styles.dart';
import 'package:sannip/common/widgets/custom_snackbar.dart';
import 'package:sannip/common/widgets/custom_text_field.dart';
import 'package:sannip/features/checkout/widgets/tips_widget.dart';

class DeliveryManTipsSection extends StatefulWidget {
  final bool takeAway;
  final JustTheController tooltipController3;
  final double totalPrice;
  final Function(double x) onTotalChange;
  final int? storeId;
  const DeliveryManTipsSection(
      {super.key,
      required this.takeAway,
      required this.tooltipController3,
      required this.totalPrice,
      required this.onTotalChange,
      this.storeId});

  @override
  State<DeliveryManTipsSection> createState() => _DeliveryManTipsSectionState();
}

class _DeliveryManTipsSectionState extends State<DeliveryManTipsSection> {
  bool canCheckSmall = false;

  @override
  Widget build(BuildContext context) {
    double total = widget.totalPrice;
    return GetBuilder<CheckoutController>(builder: (checkoutController) {
      return Column(
        children: [
          (!widget.takeAway &&
                  Get.find<SplashController>().configModel!.dmTipsStatus == 1)
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeDefault),
                      child: Row(children: [
                        Text('rider_tip'.tr, style: robotoMedium),
                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                        JustTheTooltip(
                          backgroundColor: Colors.black87,
                          controller: widget.tooltipController3,
                          preferredDirection: AxisDirection.right,
                          tailLength: 14,
                          tailBaseWidth: 20,
                          content: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                'it_s_a_great_way_to_show_your_appreciation_for_their_hard_work'
                                    .tr,
                                style: robotoRegular.copyWith(
                                    color: Colors.white)),
                          ),
                          child: InkWell(
                            onTap: () =>
                                widget.tooltipController3.showTooltip(),
                            // child: const Icon(Icons.info_outline),
                            child: Image.asset(
                              Images.infoIcon,
                              height: 13,
                              width: 13,
                            ),
                          ),
                        ),
                      ]),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius:
                            BorderRadius.circular(Dimensions.radiusDefault),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5,
                            spreadRadius: 1,
                          )
                          // BoxShadow(
                          //     color:
                          //         Theme.of(context).primaryColor.withOpacity(0.05),
                          //     blurRadius: 10)
                        ],
                      ),
                      margin: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeDefault),
                      padding:
                          const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('delivery_man_tip_description'.tr,
                                style: robotoRegular),
                            SizedBox(
                              height: (checkoutController.selectedTips ==
                                          AppConstants.tipsWithEmoji.length -
                                              1) &&
                                      checkoutController.canShowTipsField
                                  ? 0
                                  : ResponsiveHelper.isDesktop(context)
                                      ? 80
                                      : 52,
                              child: (checkoutController.selectedTips ==
                                          AppConstants.tipsWithEmoji.length -
                                              1) &&
                                      checkoutController.canShowTipsField
                                  ? const SizedBox()
                                  : ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      physics: const BouncingScrollPhysics(),
                                      itemCount:
                                          AppConstants.tipsWithEmoji.length,
                                      itemBuilder: (context, index) {
                                        return TipsWidget(
                                          title: AppConstants.tipsWithEmoji[index]
                                                      ["amount"] ==
                                                  '0'
                                              ? 'not_now'.tr
                                              : (index !=
                                                      AppConstants.tipsWithEmoji
                                                              .length -
                                                          1)
                                                  ? AppConstants.tipsWithEmoji[index]
                                                          ["emoji"] +
                                                      ' ' +
                                                      PriceConverter.convertPrice(
                                                          double.parse(AppConstants
                                                              .tipsWithEmoji[index]
                                                                  ["amount"]
                                                              .toString()),
                                                          forDM: true)
                                                  : AppConstants
                                                      .tipsWithEmoji[index]
                                                          ["amount"]
                                                      .toString()
                                                      .tr,
                                          isSelected:
                                              checkoutController.selectedTips ==
                                                  index,
                                          isTitleBold: true,
                                          isSuggested: index != 0 &&
                                              AppConstants.tipsWithEmoji[index]
                                                      ["amount"] ==
                                                  checkoutController
                                                      .mostDmTipAmount
                                                      .toString(),
                                          onTap: () async {
                                            total =
                                                total - checkoutController.tips;
                                            checkoutController
                                                .updateTips(index);
                                            if (checkoutController
                                                    .selectedTips !=
                                                AppConstants
                                                        .tipsWithEmoji.length -
                                                    1) {
                                              checkoutController.addTips(
                                                  double.parse(AppConstants
                                                          .tipsWithEmoji[index]
                                                      ["amount"]));
                                            }
                                            if (checkoutController
                                                    .selectedTips ==
                                                AppConstants
                                                        .tipsWithEmoji.length -
                                                    1) {
                                              checkoutController
                                                  .showTipsField();
                                            }
                                            if (checkoutController.tips !=
                                                0.0) {
                                              checkoutController
                                                      .tipController.text =
                                                  checkoutController.tips
                                                      .toString();
                                            } else {
                                              checkoutController
                                                  .tipController.text = '';
                                            }

                                            if (checkoutController
                                                    .isPartialPay ||
                                                checkoutController
                                                        .paymentMethodIndex ==
                                                    1) {
                                              checkoutController
                                                  .checkBalanceStatus(
                                                      (total +
                                                          checkoutController
                                                              .tips),
                                                      0);
                                            }
                                          },
                                        );
                                      },
                                    ),
                            ),
                            SizedBox(
                                height: (checkoutController.selectedTips ==
                                            AppConstants.tipsWithEmoji.length -
                                                1) &&
                                        checkoutController.canShowTipsField
                                    ? Dimensions.paddingSizeExtraSmall
                                    : 0),
                            checkoutController.selectedTips ==
                                    AppConstants.tipsWithEmoji.length - 1
                                ? const SizedBox()
                                : ListTile(
                                    onTap: () =>
                                        checkoutController.toggleDmTipSave(),
                                    leading: Checkbox(
                                      visualDensity: const VisualDensity(
                                          horizontal: -4, vertical: -4),
                                      activeColor:
                                          Theme.of(context).primaryColor,
                                      value: checkoutController.isDmTipSave,
                                      onChanged: (bool? isChecked) =>
                                          checkoutController.toggleDmTipSave(),
                                    ),
                                    title: Text('save_for_later'.tr,
                                        style: robotoMedium.copyWith(
                                            color: Theme.of(context)
                                                .primaryColor)),
                                    contentPadding: EdgeInsets.zero,
                                    visualDensity: const VisualDensity(
                                        horizontal: 0, vertical: -4),
                                    dense: true,
                                    horizontalTitleGap: 0,
                                  ),
                            SizedBox(
                                height: checkoutController.selectedTips ==
                                        AppConstants.tipsWithEmoji.length - 1
                                    ? Dimensions.paddingSizeDefault
                                    : 0),
                            checkoutController.selectedTips ==
                                    AppConstants.tipsWithEmoji.length - 1
                                ? Row(children: [
                                    Expanded(
                                      child: CustomTextField(
                                        titleText: 'enter_amount'.tr,
                                        controller:
                                            checkoutController.tipController,
                                        inputAction: TextInputAction.done,
                                        inputType: TextInputType.number,
                                        prefixIcon: Icons.currency_rupee_sharp,
                                        onChanged: (String value) async {
                                          if (value.isNotEmpty) {
                                            try {
                                              if (double.parse(value) >= 0) {
                                                if (AuthHelper.isLoggedIn()) {
                                                  total = total -
                                                      checkoutController.tips;
                                                  await checkoutController
                                                      .addTips(
                                                          double.parse(value));
                                                  total = total +
                                                      checkoutController.tips;
                                                  widget.onTotalChange(total);
                                                  if (Get.find<ProfileController>()
                                                              .userInfoModel!
                                                              .walletBalance! <
                                                          total &&
                                                      checkoutController
                                                              .paymentMethodIndex ==
                                                          1) {
                                                    checkoutController
                                                        .checkBalanceStatus(
                                                            total, 0);
                                                    canCheckSmall = true;
                                                  } else if (Get.find<
                                                                  ProfileController>()
                                                              .userInfoModel!
                                                              .walletBalance! >
                                                          total &&
                                                      canCheckSmall &&
                                                      checkoutController
                                                          .isPartialPay) {
                                                    checkoutController
                                                        .checkBalanceStatus(
                                                            total, 0);
                                                  }
                                                } else {
                                                  checkoutController.addTips(
                                                      double.parse(value));
                                                }
                                              } else {
                                                showCustomSnackBar(
                                                    'tips_can_not_be_negative'
                                                        .tr);
                                              }
                                            } catch (e) {
                                              showCustomSnackBar(
                                                  'invalid_input'.tr);
                                              checkoutController.addTips(0.0);
                                              checkoutController
                                                      .tipController.text =
                                                  checkoutController
                                                      .tipController.text
                                                      .substring(
                                                          0,
                                                          checkoutController
                                                                  .tipController
                                                                  .text
                                                                  .length -
                                                              1);
                                              checkoutController
                                                      .tipController.selection =
                                                  TextSelection.collapsed(
                                                      offset: checkoutController
                                                          .tipController
                                                          .text
                                                          .length);
                                            }
                                          } else {
                                            checkoutController.addTips(0.0);
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                        width: Dimensions.paddingSizeSmall),
                                    InkWell(
                                      onTap: () {
                                        checkoutController.updateTips(0);
                                        checkoutController.showTipsField();
                                        if (checkoutController.isPartialPay) {
                                          checkoutController
                                              .changePartialPayment();
                                        }
                                      },
                                      /*child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.5),
                                        ),
                                        padding: const EdgeInsets.all(
                                            Dimensions.paddingSizeSmall),
                                        child: const Icon(Icons.clear),
                                      ),*/
                                      child: Text('close'.tr,
                                          style: robotoMedium.copyWith(
                                              color: Theme.of(context)
                                                  .primaryColor)),
                                    ),
                                  ])
                                : const SizedBox(),
                          ]),
                    ),
                  ],
                )
              : const SizedBox.shrink(),
          SizedBox(
              height: (!widget.takeAway &&
                      widget.storeId == null &&
                      Get.find<SplashController>().configModel!.dmTipsStatus ==
                          1)
                  ? Dimensions.paddingSizeSmall
                  : 0),
        ],
      );
    });
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:sannip/features/language/controllers/language_controller.dart';
import 'package:sannip/features/splash/controllers/splash_controller.dart';
import 'package:sannip/features/profile/controllers/profile_controller.dart';
import 'package:sannip/helper/price_converter.dart';
import 'package:sannip/helper/responsive_helper.dart';
import 'package:sannip/util/dimensions.dart';
import 'package:sannip/util/styles.dart';
import 'package:sannip/features/wallet/widgets/add_fund_dialogue_widget.dart';

class WalletCardWidget extends StatelessWidget {
  final JustTheController tooltipController;
  const WalletCardWidget({super.key, required this.tooltipController});

  @override
  Widget build(BuildContext context) {
    bool isDesktop = ResponsiveHelper.isDesktop(context);
    return GetBuilder<ProfileController>(builder: (profileController) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isDesktop
              ? const SizedBox()
              : const SizedBox(height: Dimensions.paddingSizeSmall),
          Stack(children: [
            Container(
              padding: EdgeInsets.all(
                  isDesktop ? 35 : Dimensions.paddingSizeExtraLarge),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                color: Theme.of(context).primaryColor,
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('wallet_amount'.tr,
                        style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: Theme.of(context).cardColor)),
                    const SizedBox(height: Dimensions.paddingSizeSmall),
                    Row(children: [
                      Text(
                        PriceConverter.convertPrice(
                            profileController.userInfoModel!.walletBalance),
                        textDirection: TextDirection.ltr,
                        style: robotoBold.copyWith(
                            fontSize: Dimensions.fontSizeOverLarge,
                            color: Theme.of(context).cardColor),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeSmall),
                      Get.find<SplashController>()
                                  .configModel!
                                  .addFundStatus! &&
                              Get.find<SplashController>()
                                  .configModel!
                                  .digitalPayment!
                          ? JustTheTooltip(
                              backgroundColor: Colors.black87,
                              controller: tooltipController,
                              preferredDirection: AxisDirection.right,
                              tailLength: 14,
                              tailBaseWidth: 20,
                              content: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'if_you_want_to_add_fund_to_your_wallet_then_click_add_fund_button'
                                      .tr,
                                  style: robotoRegular.copyWith(
                                      color: Colors.white),
                                ),
                              ),
                              child: InkWell(
                                onTap: () => tooltipController.showTooltip(),
                                child: Icon(Icons.info_outline,
                                    color: Theme.of(context).cardColor),
                              ),
                            )
                          : const SizedBox(),
                    ]),
                  ]),
            ),
            Get.find<SplashController>().configModel!.addFundStatus! &&
                    Get.find<SplashController>().configModel!.digitalPayment!
                ? Positioned(
                    top: 30,
                    right: Get.find<LocalizationController>().isLtr ? 20 : null,
                    left: Get.find<LocalizationController>().isLtr ? null : 10,
                    child: InkWell(
                      onTap: () {
                        Get.dialog(
                          const Dialog(
                              backgroundColor: Colors.transparent,
                              surfaceTintColor: Colors.transparent,
                              child: SizedBox(
                                width: 500,
                                child: SingleChildScrollView(
                                    child: AddFundDialogueWidget()),
                              )),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).cardColor),
                        padding: const EdgeInsets.all(
                            Dimensions.paddingSizeExtraSmall),
                        child: const Icon(Icons.add),
                      ),
                    ),
                  )
                : const SizedBox(),
          ]),
          isDesktop
              ? const SizedBox()
              : const SizedBox(height: Dimensions.paddingSizeSmall),
          isDesktop
              ? const SizedBox(height: Dimensions.paddingSizeDefault)
              : const SizedBox(),
          isDesktop
              ? Text('how_to_use'.tr,
                  style:
                      robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge))
              : const SizedBox(),
          isDesktop
              ? const SizedBox(height: Dimensions.paddingSizeDefault)
              : const SizedBox(),
          !isDesktop ? const SizedBox() : const WalletStepper(),
        ],
      );
    });
  }
}

class WalletStepper extends StatelessWidget {
  const WalletStepper({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(
                    top: Dimensions.paddingSizeExtraSmall),
                height: 15,
                width: 15,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Theme.of(context).primaryColor, width: 2)),
              ),
              Expanded(
                child: VerticalDivider(
                  thickness: 3,
                  color: Theme.of(context).primaryColor.withOpacity(0.30),
                ),
              ),
              Container(
                height: 15,
                width: 15,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Theme.of(context).primaryColor, width: 2)),
              ),
              Expanded(
                child: VerticalDivider(
                  thickness: 3,
                  color: Theme.of(context).primaryColor.withOpacity(0.30),
                ),
              ),
              Container(
                height: 15,
                width: 15,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Theme.of(context).primaryColor, width: 2)),
              ),
              Expanded(
                child: VerticalDivider(
                  thickness: 3,
                  color: Theme.of(context).primaryColor.withOpacity(0.30),
                ),
              ),
              Container(
                height: 15,
                width: 15,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Theme.of(context).primaryColor, width: 2)),
              ),
            ],
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    'earn_money_to_your_wallet_by_completing_the_offer_challenged'
                        .tr,
                    style: robotoRegular),
                Text('convert_your_loyalty_points_into_wallet_money'.tr,
                    style: robotoRegular),
                Text(
                    'amin_also_reward_their_top_customers_with_wallet_money'.tr,
                    style: robotoRegular),
                Text('send_your_wallet_money_while_order'.tr,
                    style: robotoRegular),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

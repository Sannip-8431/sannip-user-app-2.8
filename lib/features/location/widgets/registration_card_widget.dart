import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sannip/features/splash/controllers/splash_controller.dart';
import 'package:sannip/util/dimensions.dart';
import 'package:sannip/util/images.dart';
import 'package:sannip/util/styles.dart';
import 'package:sannip/common/widgets/custom_button.dart';
import 'package:url_launcher/url_launcher_string.dart';

class RegistrationCardWidget extends StatelessWidget {
  final bool isStore;
  final SplashController splashController;
  const RegistrationCardWidget(
      {super.key, required this.isStore, required this.splashController});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        child: Opacity(
            opacity: 0.05,
            child: Image.asset(Images.landingBg,
                height: 200, width: context.width, fit: BoxFit.fill)),
      ),
      Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          color: Theme.of(context).primaryColor.withOpacity(0.05),
        ),
        child: Row(children: [
          Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isStore
                            ? splashController.landingModel!.joinSellerTitle ??
                                ''
                            : splashController
                                    .landingModel!.joinDeliveryManTitle ??
                                '',
                        style: robotoBold.copyWith(
                            fontSize: Dimensions.fontSizeExtraLarge),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: Dimensions.paddingSizeLarge),
                      Text(
                        isStore
                            ? splashController
                                    .landingModel!.joinSellerSubTitle ??
                                ''
                            : splashController
                                    .landingModel!.joinDeliveryManSubTitle ??
                                '',
                        style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeExtraSmall),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                      splashController.landingModel!.joinSellerButtonName !=
                                  null ||
                              splashController.landingModel!
                                      .joinDeliveryManButtonName !=
                                  null
                          ? CustomButton(
                              buttonText: isStore
                                  ? splashController
                                          .landingModel!.joinSellerButtonName ??
                                      ''
                                  : splashController.landingModel!
                                          .joinDeliveryManButtonName ??
                                      '',
                              fontSize: Dimensions.fontSizeSmall,
                              width: 100,
                              height: 40,
                              onPressed: () async {
                                String url = isStore
                                    ? splashController.landingModel!
                                            .joinSellerButtonUrl ??
                                        ''
                                    : splashController.landingModel!
                                            .joinDeliveryManButtonUrl ??
                                        '';
                                if (await canLaunchUrlString(url)) {
                                  launchUrlString(url);
                                }
                              },
                            )
                          : const SizedBox(),
                    ]),
              )),
          Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                child: Image.asset(
                    isStore
                        ? Images.landingStoreOpen
                        : Images.landingDeliveryMan,
                    height: 200,
                    width: 200),
              )),
        ]),
      ),
    ]);
  }
}

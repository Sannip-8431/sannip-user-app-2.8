import 'package:sannip/common/widgets/custom_ink_well.dart';
import 'package:sannip/features/cart/controllers/cart_controller.dart';
import 'package:sannip/features/profile/controllers/profile_controller.dart';
import 'package:sannip/features/favourite/controllers/favourite_controller.dart';
import 'package:sannip/features/menu/domain/models/menu_model.dart';
import 'package:sannip/features/auth/controllers/auth_controller.dart';
import 'package:sannip/features/auth/screens/sign_in_screen.dart';
import 'package:sannip/helper/auth_helper.dart';
import 'package:sannip/helper/responsive_helper.dart';
import 'package:sannip/helper/route_helper.dart';
import 'package:sannip/util/dimensions.dart';
import 'package:sannip/util/styles.dart';
import 'package:sannip/common/widgets/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MenuButtonWidget extends StatelessWidget {
  final MenuModel menu;
  final bool isProfile;
  final bool isLogout;
  const MenuButtonWidget(
      {super.key,
      required this.menu,
      required this.isProfile,
      required this.isLogout});

  @override
  Widget build(BuildContext context) {
    int count = ResponsiveHelper.isDesktop(context)
        ? 8
        : ResponsiveHelper.isTab(context)
            ? 6
            : 4;
    double size = ((context.width > Dimensions.webMaxWidth
                ? Dimensions.webMaxWidth
                : context.width) /
            count) -
        Dimensions.paddingSizeDefault;

    return InkWell(
      onTap: () async {
        if (isLogout) {
          Get.back();
          if (AuthHelper.isLoggedIn()) {
            Get.dialog(
                Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusDefault)),
                  insetPadding: const EdgeInsets.all(60),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          height: Dimensions.paddingSizeExtraSmall,
                        ),
                        Text('are_you_sure_to_logout'.tr, style: robotoBold),
                        const SizedBox(
                          height: Dimensions.paddingSizeLarge,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: CustomInkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.radiusExtraLarge),
                                    color: Colors.green,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical:
                                          Dimensions.paddingSizeExtraSmall),
                                  child: Text(
                                    'cancel'.tr.toUpperCase(),
                                    style: robotoRegular.copyWith(
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: Dimensions.paddingSizeLarge,
                            ),
                            Expanded(
                              child: CustomInkWell(
                                onTap: () {
                                  Get.find<ProfileController>().clearUserInfo();
                                  Get.find<AuthController>().clearSharedData();
                                  Get.find<AuthController>().socialLogout();
                                  Get.find<CartController>().clearCartList();
                                  Get.find<FavouriteController>()
                                      .removeFavourite();
                                  if (!ResponsiveHelper.isDesktop(context)) {
                                    Get.offAllNamed(RouteHelper.getSignInRoute(
                                        RouteHelper.splash));
                                  } else {
                                    Get.dialog(const SignInScreen(
                                        exitFromApp: true, backFromThis: true));
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.radiusExtraLarge),
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical:
                                          Dimensions.paddingSizeExtraSmall),
                                  child: Text(
                                    'logout'.tr.toUpperCase(),
                                    style: robotoRegular.copyWith(
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
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
                    icon: Images.support,
                    description: 'are_you_sure_to_logout'.tr,
                    isLogOut: true,
                    onYesPressed: () {
                      Get.find<ProfileController>().clearUserInfo();
                      Get.find<AuthController>().clearSharedData();
                      Get.find<AuthController>().socialLogout();
                      Get.find<CartController>().clearCartList();
                      Get.find<FavouriteController>().removeFavourite();
                      if (!ResponsiveHelper.isDesktop(context)) {
                        Get.offAllNamed(
                            RouteHelper.getSignInRoute(RouteHelper.splash));
                      } else {
                        Get.dialog(const SignInScreen(
                            exitFromApp: true, backFromThis: true));
                      }
                    }),*/
                useSafeArea: false);
          } else {
            if (!ResponsiveHelper.isDesktop(context)) {
              Get.find<FavouriteController>().removeFavourite();
              Get.toNamed(RouteHelper.getSignInRoute(RouteHelper.main));
            } else {
              Get.dialog(
                  const SignInScreen(exitFromApp: true, backFromThis: true));
            }
          }
        } else if (menu.route.startsWith('http')) {
          if (await canLaunchUrlString(menu.route)) {
            launchUrlString(menu.route, mode: LaunchMode.externalApplication);
          }
        } else {
          Get.offNamed(menu.route);
        }
      },
      child: Column(children: [
        Container(
          height: size - (size * 0.2),
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          margin: const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeSmall),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            color: isLogout
                ? AuthHelper.isLoggedIn()
                    ? Colors.red
                    : Colors.green
                : Theme.of(context).primaryColor,
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)
            ],
          ),
          alignment: Alignment.center,
          child: isProfile
              ? ProfileImageWidget(size: size)
              : Image.asset(menu.icon,
                  width: size, height: size, color: Colors.white),
        ),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
        Text(menu.title,
            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
            textAlign: TextAlign.center),
      ]),
    );
  }
}

class ProfileImageWidget extends StatelessWidget {
  final double size;
  const ProfileImageWidget({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(builder: (profileController) {
      return Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 2, color: Colors.white)),
        child: ClipOval(
          child: CustomImage(
            image: (profileController.userInfoModel != null &&
                    AuthHelper.isLoggedIn())
                ? profileController.userInfoModel!.imageFullUrl ?? ''
                : '',
            width: size,
            height: size,
            fit: BoxFit.cover,
          ),
        ),
      );
    });
  }
}

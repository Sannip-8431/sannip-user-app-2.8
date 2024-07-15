import 'package:sannip/common/widgets/custom_snackbar.dart';
import 'package:sannip/features/cart/controllers/cart_controller.dart';
import 'package:sannip/features/coupon/controllers/coupon_controller.dart';
import 'package:sannip/features/home/screens/home_screen.dart';
import 'package:sannip/features/splash/controllers/splash_controller.dart';
import 'package:sannip/helper/responsive_helper.dart';
import 'package:sannip/helper/route_helper.dart';
import 'package:sannip/util/dimensions.dart';
import 'package:sannip/util/styles.dart';
import 'package:sannip/common/widgets/cart_widget.dart';
import 'package:sannip/common/widgets/veg_filter_widget.dart';
import 'package:sannip/common/widgets/web_menu_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool backButton;
  final Function? onBackPressed;
  final bool showCart;
  final Function(String value)? onVegFilterTap;
  final String? type;
  final String? leadingIcon;
  const CustomAppBar(
      {super.key,
      required this.title,
      this.backButton = true,
      this.onBackPressed,
      this.showCart = false,
      this.leadingIcon,
      this.onVegFilterTap,
      this.type});

  @override
  Widget build(BuildContext context) {
    return ResponsiveHelper.isDesktop(context)
        ? const WebMenuBar()
        : AppBar(
            title: Text(title,
                style: robotoMedium.copyWith(
                    fontSize: Dimensions.fontSizeLarge,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.bodyLarge!.color)),
            centerTitle: true,
            leading: backButton
                ? IconButton(
                    icon: leadingIcon != null
                        ? Image.asset(leadingIcon!, height: 22, width: 22)
                        : const Icon(Icons.arrow_back_ios),
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                    onPressed: () => onBackPressed != null
                        ? onBackPressed!()
                        : Navigator.pop(context),
                  )
                : const SizedBox(),
            backgroundColor: Theme.of(context).cardColor,
            surfaceTintColor: Theme.of(context).cardColor,
            shadowColor: Theme.of(context).disabledColor.withOpacity(0.5),
            elevation: 2,
            actions: showCart || onVegFilterTap != null
                ? [
                    showCart
                        ? GetBuilder<CartController>(builder: (cartController) {
                            return IconButton(
                              // onPressed: () =>
                              //     Get.toNamed(RouteHelper.getCartRoute()),
                              onPressed: () {
                                if (!cartController
                                        .cartList.first.item!.scheduleOrder! &&
                                    cartController.availableList
                                        .contains(false)) {
                                  showCustomSnackBar(
                                      'one_or_more_product_unavailable'.tr);
                                } /*else if(AuthHelper.isGuestLoggedIn() && !Get.find<SplashController>().configModel!.guestCheckoutStatus!) {
                            showCustomSnackBar('currently_your_zone_have_no_permission_to_place_any_order'.tr);
                                              }*/
                                else {
                                  if (Get.find<SplashController>().module ==
                                      null) {
                                    int i = 0;
                                    for (i = 0;
                                        i <
                                            Get.find<SplashController>()
                                                .moduleList!
                                                .length;
                                        i++) {
                                      if (cartController
                                              .cartList[0].item!.moduleId ==
                                          Get.find<SplashController>()
                                              .moduleList![i]
                                              .id) {
                                        break;
                                      }
                                    }
                                    Get.find<SplashController>().setModule(
                                        Get.find<SplashController>()
                                            .moduleList![i]);
                                    HomeScreen.loadData(true);
                                  }
                                  Get.find<CouponController>()
                                      .removeCouponData(false);

                                  Get.toNamed(
                                      RouteHelper.getCheckoutRoute('cart'));
                                }
                              },
                              icon: CartWidget(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color,
                                  size: 25),
                            );
                          })
                        : const SizedBox(),
                    onVegFilterTap != null
                        ? VegFilterWidget(
                            type: type,
                            onSelected: onVegFilterTap,
                            fromAppBar: true,
                          )
                        : const SizedBox(),
                  ]
                : [const SizedBox()],
          );
  }

  @override
  Size get preferredSize => Size(Get.width, GetPlatform.isDesktop ? 100 : 50);
}

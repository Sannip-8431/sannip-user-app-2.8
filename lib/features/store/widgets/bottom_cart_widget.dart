import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sannip/common/widgets/custom_snackbar.dart';
import 'package:sannip/features/cart/controllers/cart_controller.dart';
import 'package:sannip/features/coupon/controllers/coupon_controller.dart';
import 'package:sannip/features/home/screens/home_screen.dart';
import 'package:sannip/features/splash/controllers/splash_controller.dart';
import 'package:sannip/helper/price_converter.dart';
import 'package:sannip/helper/route_helper.dart';
import 'package:sannip/util/dimensions.dart';
import 'package:sannip/util/styles.dart';
import 'package:sannip/common/widgets/custom_button.dart';

class BottomCartWidget extends StatelessWidget {
  const BottomCartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(builder: (cartController) {
      return InkWell(
        onTap: () {
          if (!cartController.cartList.first.item!.scheduleOrder! &&
              cartController.availableList.contains(false)) {
            showCustomSnackBar('one_or_more_product_unavailable'.tr);
          } /*else if(AuthHelper.isGuestLoggedIn() && !Get.find<SplashController>().configModel!.guestCheckoutStatus!) {
                    showCustomSnackBar('currently_your_zone_have_no_permission_to_place_any_order'.tr);
                  }*/
          else {
            if (Get.find<SplashController>().module == null) {
              int i = 0;
              for (i = 0;
                  i < Get.find<SplashController>().moduleList!.length;
                  i++) {
                if (cartController.cartList[0].item!.moduleId ==
                    Get.find<SplashController>().moduleList![i].id) {
                  break;
                }
              }
              Get.find<SplashController>()
                  .setModule(Get.find<SplashController>().moduleList![i]);
              HomeScreen.loadData(true);
            }
            Get.find<CouponController>().removeCouponData(false);

            Get.toNamed(RouteHelper.getCheckoutRoute('cart'));
          }
        },
        child: Container(
          height: GetPlatform.isIOS ? 100 : 70,
          width: Get.width,
          padding: const EdgeInsets.symmetric(
            horizontal: Dimensions
                .paddingSizeExtraLarge, /* vertical: Dimensions.PADDING_SIZE_SMALL*/
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            // boxShadow: [
            //   BoxShadow(
            //       color: const Color(0xFF2A2A2A).withOpacity(0.1),
            //       blurRadius: 10,
            //       offset: const Offset(0, -5))
            // ],
          ),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${cartController.cartList.length} ${'items'.tr}',
                      style: robotoMedium.copyWith(
                          color: Colors.white,
                          fontSize: Dimensions.fontSizeSmall)),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  Row(children: [
                    Text(
                      PriceConverter.convertPrice(
                          cartController.calculationCart()),
                      style: robotoMedium.copyWith(
                          fontSize: Dimensions.fontSizeLarge,
                          color: Colors.white),
                      textDirection: TextDirection.ltr,
                    ),
                    Text(
                      ' ${'total'.tr}',
                      style: robotoMedium.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          color: Colors.white),
                    ),
                  ]),
                ]),
            CustomButton(
              buttonText: 'view_cart'.tr,
              width: 130,
              height: 45,
              onPressed: () {
                if (!cartController.cartList.first.item!.scheduleOrder! &&
                    cartController.availableList.contains(false)) {
                  showCustomSnackBar('one_or_more_product_unavailable'.tr);
                } /*else if(AuthHelper.isGuestLoggedIn() && !Get.find<SplashController>().configModel!.guestCheckoutStatus!) {
                    showCustomSnackBar('currently_your_zone_have_no_permission_to_place_any_order'.tr);
                  }*/
                else {
                  if (Get.find<SplashController>().module == null) {
                    int i = 0;
                    for (i = 0;
                        i < Get.find<SplashController>().moduleList!.length;
                        i++) {
                      if (cartController.cartList[0].item!.moduleId ==
                          Get.find<SplashController>().moduleList![i].id) {
                        break;
                      }
                    }
                    Get.find<SplashController>()
                        .setModule(Get.find<SplashController>().moduleList![i]);
                    HomeScreen.loadData(true);
                  }
                  Get.find<CouponController>().removeCouponData(false);

                  Get.toNamed(RouteHelper.getCheckoutRoute('cart'));
                }
              },
            )
          ]),
        ),
      );
    });
  }
}

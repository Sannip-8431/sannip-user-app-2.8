import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sannip/common/widgets/custom_snackbar.dart';
import 'package:sannip/features/cart/controllers/cart_controller.dart';
import 'package:sannip/features/coupon/controllers/coupon_controller.dart';
import 'package:sannip/features/home/screens/home_screen.dart';
import 'package:sannip/features/splash/controllers/splash_controller.dart';
import 'package:sannip/helper/route_helper.dart';
import 'package:sannip/util/dimensions.dart';
import 'package:sannip/util/styles.dart';

class DetailsAppBarWidget extends StatefulWidget
    implements PreferredSizeWidget {
  const DetailsAppBarWidget({super.key});

  @override
  DetailsAppBarWidgetState createState() => DetailsAppBarWidgetState();

  @override
  Size get preferredSize => const Size(double.maxFinite, 50);
}

class DetailsAppBarWidgetState extends State<DetailsAppBarWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void shake() {
    controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> offsetAnimation = Tween(begin: 0.0, end: 15.0)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        }
      });

    return AppBar(
      leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: Theme.of(context).textTheme.bodyLarge!.color),
          onPressed: () => Navigator.pop(context)),
      backgroundColor: Theme.of(context).cardColor,
      elevation: 0,
      title: Text(
        'item_details'.tr,
        style: robotoMedium.copyWith(
            fontSize: Dimensions.fontSizeLarge,
            color: Theme.of(context).textTheme.bodyLarge!.color),
      ),
      centerTitle: true,
      actions: [
        AnimatedBuilder(
          animation: offsetAnimation,
          builder: (buildContext, child) {
            return Container(
              padding: EdgeInsets.only(
                  left: offsetAnimation.value + 15.0,
                  right: 15.0 - offsetAnimation.value),
              child: Stack(children: [
                GetBuilder<CartController>(builder: (cartController) {
                  return IconButton(
                    icon: Icon(Icons.shopping_cart,
                        color: Theme.of(context).primaryColor),
                    // onPressed: () {
                    //   Navigator.pushNamed(context, RouteHelper.getCartRoute());
                    // },
                    onPressed: () {
                      if (!cartController.cartList.first.item!.scheduleOrder! &&
                          cartController.availableList.contains(false)) {
                        showCustomSnackBar(
                            'one_or_more_product_unavailable'.tr);
                      } /*else if(AuthHelper.isGuestLoggedIn() && !Get.find<SplashController>().configModel!.guestCheckoutStatus!) {
                            showCustomSnackBar('currently_your_zone_have_no_permission_to_place_any_order'.tr);
                                              }*/
                      else {
                        if (Get.find<SplashController>().module == null) {
                          int i = 0;
                          for (i = 0;
                              i <
                                  Get.find<SplashController>()
                                      .moduleList!
                                      .length;
                              i++) {
                            if (cartController.cartList[0].item!.moduleId ==
                                Get.find<SplashController>()
                                    .moduleList![i]
                                    .id) {
                              break;
                            }
                          }
                          Get.find<SplashController>().setModule(
                              Get.find<SplashController>().moduleList![i]);
                          HomeScreen.loadData(true);
                        }
                        Get.find<CouponController>().removeCouponData(false);

                        Get.toNamed(RouteHelper.getCheckoutRoute('cart'));
                      }
                    },
                  );
                }),
                Positioned(
                  top: 5,
                  right: 5,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.red),
                    child:
                        GetBuilder<CartController>(builder: (cartController) {
                      return Text(
                        cartController.cartList.length.toString(),
                        style: robotoMedium.copyWith(
                            color: Colors.white, fontSize: 8),
                      );
                    }),
                  ),
                ),
              ]),
            );
          },
        )
      ],
    );
  }
}

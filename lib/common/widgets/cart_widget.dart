import 'package:lottie/lottie.dart';
import 'package:sannip/features/cart/controllers/cart_controller.dart';
import 'package:sannip/util/images.dart';
import 'package:sannip/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartWidget extends StatelessWidget {
  final Color? color;
  final double size;
  final bool fromStore;
  const CartWidget(
      {super.key,
      required this.color,
      required this.size,
      this.fromStore = false});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(builder: (cartController) {
      return cartController.cartList.isNotEmpty
          ? Stack(clipBehavior: Clip.none, children: [
              Lottie.asset(Images.lottieCart,
                  height: size + 32, width: size + 32),
              Positioned(
                top: 5,
                right: 5,
                child: Container(
                  height: size < 20 ? 10 : size / 2,
                  width: size < 20 ? 10 : size / 2,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: fromStore
                        ? Theme.of(context).cardColor
                        : Theme.of(context).colorScheme.error,
                    border: Border.all(
                        width: size < 20 ? 0.7 : 1,
                        color: fromStore
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).cardColor),
                  ),
                  child: Text(
                    cartController.cartList.length.toString(),
                    style: robotoRegular.copyWith(
                      fontSize: size < 20 ? size / 3 : size / 3.8,
                      color: fromStore
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).cardColor,
                    ),
                  ),
                ),
              )
            ])
          : Image.asset(Images.shoppingCart,
              height: size, width: size, color: color);
    });
  }
}

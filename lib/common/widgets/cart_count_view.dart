import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sannip/features/cart/controllers/cart_controller.dart';
import 'package:sannip/features/item/controllers/item_controller.dart';
import 'package:sannip/features/item/domain/models/item_model.dart';
import 'package:sannip/util/dimensions.dart';
import 'package:sannip/util/styles.dart';

class CartCountView extends StatelessWidget {
  final Item item;
  final Widget? child;
  const CartCountView({super.key, required this.item, this.child});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(builder: (cartController) {
      int cartQty = cartController.cartQuantity(item.id!);
      int cartIndex = cartController.isExistInCart(
          item.id, cartController.cartVariant(item.id!), false, null);
      return cartQty != 0
          ? Center(
              child: Container(
                width: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  color: Theme.of(context).cardColor,
                  border: Border.all(color: Theme.of(context).primaryColor),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12, blurRadius: 5, spreadRadius: 1)
                  ],
                ),
                // decoration: BoxDecoration(
                //   color: Theme.of(context).primaryColor,
                //   borderRadius:
                //       BorderRadius.circular(Dimensions.radiusExtraLarge),
                // ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: cartController.isLoading
                            ? null
                            : () {
                                if (cartController
                                        .cartList[cartIndex].quantity! >
                                    1) {
                                  cartController.setQuantity(
                                      false,
                                      cartIndex,
                                      cartController.cartList[cartIndex].stock,
                                      cartController.cartList[cartIndex].item!
                                          .quantityLimit);
                                } else {
                                  cartController.removeFromCart(cartIndex);
                                }
                              },
                        child: Padding(
                          padding: const EdgeInsets.all(
                              Dimensions.paddingSizeExtraSmall),
                          child: Icon(Icons.remove,
                              size: 18, color: Theme.of(context).primaryColor),
                        ),
                      ),
                      !cartController.isLoading
                          ? Text(
                              cartQty.toString(),
                              style: robotoMedium.copyWith(
                                  color: Theme.of(context).primaryColor),
                            )
                          : const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator()),
                      InkWell(
                        onTap: cartController.isLoading
                            ? null
                            : () {
                                cartController.setQuantity(
                                    true,
                                    cartIndex,
                                    cartController.cartList[cartIndex].stock,
                                    cartController
                                        .cartList[cartIndex].quantityLimit);
                              },
                        child: Padding(
                          padding: const EdgeInsets.all(
                              Dimensions.paddingSizeExtraSmall),
                          child: Icon(Icons.add,
                              size: 18, color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ]),
                /* child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: cartController.isLoading
                            ? null
                            : () {
                                if (cartController
                                        .cartList[cartIndex].quantity! >
                                    1) {
                                  cartController.setQuantity(
                                      false,
                                      cartIndex,
                                      cartController.cartList[cartIndex].stock,
                                      cartController.cartList[cartIndex].item!
                                          .quantityLimit);
                                } else {
                                  cartController.removeFromCart(cartIndex);
                                }
                              },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Theme.of(context).primaryColor),
                          ),
                          padding: const EdgeInsets.all(
                              Dimensions.paddingSizeExtraSmall),
                          child: Icon(
                            Icons.remove,
                            size: 16,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeSmall),
                        child: !cartController.isLoading
                            ? Text(
                                cartQty.toString(),
                                style: robotoMedium.copyWith(
                                    fontSize: Dimensions.fontSizeSmall,
                                    color: Theme.of(context).cardColor),
                              )
                            : SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                    color: Theme.of(context).cardColor)),
                      ),
                      InkWell(
                        onTap: cartController.isLoading
                            ? null
                            : () {
                                cartController.setQuantity(
                                    true,
                                    cartIndex,
                                    cartController.cartList[cartIndex].stock,
                                    cartController
                                        .cartList[cartIndex].quantityLimit);
                              },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Theme.of(context).primaryColor),
                          ),
                          padding: const EdgeInsets.all(
                              Dimensions.paddingSizeExtraSmall),
                          child: Icon(
                            Icons.add,
                            size: 16,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ]),*/
              ),
            )
          : InkWell(
              onTap: () {
                Get.find<ItemController>().itemDirectlyAddToCart(item, context);
              },
              child: child ??
                  Container(
                    height: 25,
                    width: 25,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).cardColor,
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5,
                            spreadRadius: 1)
                      ],
                    ),
                    child: Icon(Icons.add,
                        size: 20, color: Theme.of(context).primaryColor),
                  ),
            );
    });
  }

/*   DateTime parseTimeString(String timeString) {
    DateFormat timeFormat =
        DateFormat.Hms(); // Hms represents hours, minutes, and seconds.
    DateTime time = timeFormat.parse(timeString);

    // Set the parsed time to the current date
    DateTime now = DateTime.now();
    DateTime dateTime = DateTime(
        now.year, now.month, now.day, time.hour, time.minute, time.second);

    return dateTime;
  }

  void _showNotAcceptingOrdersDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          title: Text(
            'Currently not accepting orders',
            style: robotoRegular.copyWith(
                color: Theme.of(context).primaryColor, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.end,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'OK',
                style: robotoRegular.copyWith(
                    color: Theme.of(context).primaryColor, fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  } */
}

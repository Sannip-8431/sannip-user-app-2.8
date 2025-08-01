import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sannip/common/widgets/custom_ink_well.dart';
import 'package:sannip/features/cart/controllers/cart_controller.dart';
import 'package:sannip/features/store/controllers/store_controller.dart';
import 'package:sannip/helper/price_converter.dart';
import 'package:sannip/util/dimensions.dart';
import 'package:sannip/util/styles.dart';

class ExtraPackagingWidget extends StatelessWidget {
  final CartController cartController;
  final void Function(bool?)? onChanged;
  const ExtraPackagingWidget(
      {super.key, required this.cartController, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StoreController>(builder: (storeController) {
      return storeController.store?.extraPackagingStatus ?? false
          ? Container(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              margin: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              decoration: BoxDecoration(
                color: Theme.of(context).disabledColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              ),
              child: CustomInkWell(
                onTap: () {
                  cartController.toggleExtraPackage();
                  onChanged?.call(cartController.needExtraPackage);
                },
                child: Row(children: [
                  Checkbox(
                    activeColor: Theme.of(context).primaryColor,
                    visualDensity:
                        const VisualDensity(horizontal: -4, vertical: -4),
                    value: cartController.needExtraPackage,
                    onChanged: (bool? isChecked) {
                      cartController.toggleExtraPackage();
                      onChanged?.call(isChecked);
                    },
                  ),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                  Text('need_extra_packaging'.tr, style: robotoMedium),
                  const Spacer(),
                  Text(
                      PriceConverter.convertPrice(
                          storeController.store?.extraPackagingAmount),
                      style: robotoMedium),
                ]),
              ),
            )
          : const SizedBox();
    });
  }
}

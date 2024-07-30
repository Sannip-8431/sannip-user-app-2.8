import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sannip/features/checkout/controllers/checkout_controller.dart';
import 'package:sannip/util/app_constants.dart';
import 'package:sannip/util/dimensions.dart';
import 'package:sannip/util/styles.dart';

class DeliveryInstructionView extends StatefulWidget {
  const DeliveryInstructionView({super.key});

  @override
  State<DeliveryInstructionView> createState() =>
      _DeliveryInstructionViewState();
}

class _DeliveryInstructionViewState extends State<DeliveryInstructionView> {
  ExpansionTileController controller = ExpansionTileController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.05),
              blurRadius: 10)
        ],
      ),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeLarge,
          vertical: Dimensions.paddingSizeExtraSmall),
      child: GetBuilder<CheckoutController>(builder: (orderController) {
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              key: widget.key,
              controller: controller,
              title:
                  Text('add_more_delivery_instruction'.tr, style: robotoMedium),
              trailing: Icon(
                  orderController.isExpanded ? Icons.remove : Icons.add,
                  size: 18),
              tilePadding:
                  const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              onExpansionChanged: (value) =>
                  orderController.expandedUpdate(value),
              children: [
                SizedBox(
                  height: 80,
                  child: ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount:
                        AppConstants.deliveryInstructionListWithEmoji.length,
                    itemBuilder: (context, index) {
                      bool isSelected =
                          orderController.selectedInstruction == index;
                      return InkWell(
                        onTap: () {
                          orderController.setInstruction(index);
                          if (controller.isExpanded) {
                            controller.collapse();
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: isSelected
                                  ? Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.2)
                                  : Theme.of(context)
                                      .disabledColor
                                      .withOpacity(0.3),
                              borderRadius: BorderRadius.circular(
                                  Dimensions.radiusDefault),
                              border: Border.all(
                                color: isSelected
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context)
                                        .disabledColor
                                        .withOpacity(0.3),
                              )
                              // boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
                              ),
                          width: 95,
                          padding: const EdgeInsets.all(
                              Dimensions.paddingSizeExtraSmall),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  AppConstants
                                      .deliveryInstructionListWithEmoji[index]
                                          ["icon"]
                                      .toString(),
                                  height: 25,
                                  width: 30,
                                  color: isSelected
                                      ? Theme.of(context).primaryColor
                                      : Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.color,
                                ),
                                Expanded(
                                  child: Text(
                                    AppConstants
                                        .deliveryInstructionListWithEmoji[index]
                                            ["name"]
                                        .toString()
                                        .tr,
                                    style: robotoMedium.copyWith(
                                        fontSize: Dimensions.fontSizeSmall,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.color),
                                  ),
                                ),
                              ]),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(
                        width: Dimensions.paddingSizeLarge,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          orderController.selectedInstruction != -1
              ? Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: orderController.isExpanded
                          ? Dimensions.paddingSizeSmall
                          : 0),
                  child: Row(children: [
                    Text(
                      AppConstants.deliveryInstructionListWithEmoji[
                              orderController.selectedInstruction]["name"]
                          .toString()
                          .tr,
                      style: robotoRegular.copyWith(
                          color: Theme.of(context).primaryColor),
                    ),
                    InkWell(
                      onTap: () => orderController.setInstruction(-1),
                      child: const Icon(Icons.clear, size: 16),
                    ),
                  ]))
              : const SizedBox(),
        ]);
      }),
    );
  }
}

import 'package:sannip/util/dimensions.dart';
import 'package:sannip/features/order/widgets/custom_stepper_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sannip/util/images.dart';
import 'package:sannip/util/styles.dart';

class TrackingStepperWidget extends StatelessWidget {
  final String? status;
  final bool takeAway;
  const TrackingStepperWidget(
      {super.key, required this.status, required this.takeAway});

  @override
  Widget build(BuildContext context) {
    int state = -1;
    if (status == 'pending') {
      state = 0;
    } else if (status == 'accepted' || status == 'confirmed') {
      state = 1;
    } else if (status == 'processing') {
      state = 2;
    } else if (status == 'handover') {
      state = takeAway ? 3 : 2;
    } else if (status == 'picked_up') {
      state = 3;
    } else if (status == 'delivered') {
      state = 4;
    }

    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(Dimensions.radiusDefault),
            topRight: Radius.circular(Dimensions.radiusDefault)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: Text(
              orderStatus(state),
              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
            ),
          ),
          Row(children: [
            CustomStepperWidget(
              title: 'order_placed'.tr,
              isActive: state > -1,
              haveLeftBar: false,
              haveRightBar: true,
              rightActive: state > 0,
              iconPath: Images.orderPlacedIcon,
            ),
            CustomStepperWidget(
              title: 'order_confirmed'.tr,
              isActive: state > 0,
              haveLeftBar: true,
              haveRightBar: true,
              rightActive: state > 1,
              iconPath: Images.orderConfirmedIcon,
            ),
            CustomStepperWidget(
              title: 'preparing_item'.tr,
              isActive: state > 1,
              haveLeftBar: true,
              haveRightBar: true,
              rightActive: state > 2,
              iconPath: Images.preparingOrderIcon,
            ),
            CustomStepperWidget(
              title:
                  takeAway ? 'ready_for_handover'.tr : 'delivery_on_the_way'.tr,
              isActive: state > 2,
              haveLeftBar: true,
              haveRightBar: true,
              rightActive: state > 3,
              iconPath: takeAway
                  ? Images.checkoutTakeAwayIcon
                  : Images.checkoutDeliveryIcon,
              iconSize: takeAway ? 23 : 28,
            ),
            CustomStepperWidget(
              title: 'delivered'.tr,
              isActive: state > 3,
              haveLeftBar: true,
              haveRightBar: false,
              rightActive: state > 4,
              iconPath: Images.deliveredIcon,
            ),
          ]),
        ],
      ),
    );
  }

  String orderStatus(int status) {
    switch (status) {
      case -1:
        {
          return 'Pending';
        }
      case 0:
        {
          return 'order_placed'.tr;
        }
      case 1:
        {
          return 'order_confirmed'.tr;
        }
      case 2:
        {
          return 'preparing_item'.tr;
        }
      case 3:
        {
          return takeAway ? 'ready_for_handover'.tr : 'delivery_on_the_way'.tr;
        }
      case 4:
        {
          return 'delivered'.tr;
        }
      default:
        return 'Error';
    }
  }
}

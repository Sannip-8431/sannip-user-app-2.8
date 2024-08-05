import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sannip/common/widgets/custom_asset_image_widget.dart';
import 'package:sannip/common/widgets/custom_ink_well.dart';
import 'package:sannip/features/order/controllers/order_controller.dart';
import 'package:sannip/features/order/domain/models/order_model.dart';
import 'package:sannip/helper/route_helper.dart';
import 'package:sannip/util/app_constants.dart';
import 'package:sannip/util/dimensions.dart';
import 'package:sannip/util/images.dart';
import 'package:sannip/util/styles.dart';
import 'package:sannip/features/order/screens/order_details_screen.dart';

class RunningOrderViewWidget extends StatefulWidget {
  final List<OrderModel> reversOrder;
  final Function onOrderTap;
  const RunningOrderViewWidget(
      {super.key, required this.reversOrder, required this.onOrderTap});

  @override
  State<RunningOrderViewWidget> createState() => _RunningOrderViewWidgetState();
}

class _RunningOrderViewWidgetState extends State<RunningOrderViewWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderController>(builder: (orderController) {
      return Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Dimensions.paddingSizeExtraLarge),
            topRight: Radius.circular(Dimensions.paddingSizeExtraLarge),
          ),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)
          ],
        ),
        child: ClipPath(
          clipper: CustomShapeClipper(),
          child: Container(
            color: Theme.of(context).cardColor,
            width: MediaQuery.of(context).size.width,
            child: Column(children: [
              // Center(
              //   child: Container(
              //     margin: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
              //     height: 3,
              //     width: 40,
              //     decoration: BoxDecoration(
              //         color: Theme.of(context).highlightColor,
              //         borderRadius:
              //             BorderRadius.circular(Dimensions.paddingSizeExtraSmall)),
              //   ),
              // ),
              Row(
                children: [
                  Expanded(
                    child: CustomInkWell(
                        child: CustomAssetImageWidget(
                          isExpanded ? Images.downArrow : Images.upArrow,
                          fit: BoxFit.scaleDown,
                          height: 18,
                        ),
                        onTap: () {
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        }),
                  ),
                ],
              ),
              Container(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.6),
                height: !isExpanded ? 80 : widget.reversOrder.length * 75,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                    itemCount: widget.reversOrder.length,
                    shrinkWrap: true,
                    // physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      bool isFirstOrder = index == 0;

                      String? orderStatus =
                          widget.reversOrder[index].orderStatus;
                      int status = 0;

                      if (orderStatus == AppConstants.pending) {
                        status = 1;
                      } else if (orderStatus == AppConstants.accepted ||
                          orderStatus == AppConstants.processing ||
                          orderStatus == AppConstants.confirmed) {
                        status = 2;
                      } else if (orderStatus == AppConstants.handover ||
                          orderStatus == AppConstants.pickedUp) {
                        status = 3;
                      }

                      return InkWell(
                        onTap: () async {
                          await Get.toNamed(
                            RouteHelper.getOrderDetailsRoute(
                                widget.reversOrder[index].id),
                            arguments: OrderDetailsScreen(
                              orderId: widget.reversOrder[index].id,
                              orderModel: widget.reversOrder[index],
                            ),
                          );
                          if (orderController.showBottomSheet) {
                            orderController.showRunningOrders();
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                              bottom: Dimensions.paddingSizeExtraSmall,
                              top: Dimensions.paddingSizeSmall),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingSizeDefault),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Center(
                                    child: SizedBox(
                                      height:
                                          orderStatus == AppConstants.pending
                                              ? 50
                                              : 60,
                                      width: orderStatus == AppConstants.pending
                                          ? 50
                                          : 60,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.asset(
                                            status == 2
                                                ? orderStatus ==
                                                            AppConstants
                                                                .confirmed ||
                                                        orderStatus ==
                                                            AppConstants
                                                                .accepted
                                                    ? Images.confirmedGif
                                                    : Images.processingGif
                                                : status == 3
                                                    ? orderStatus ==
                                                            AppConstants
                                                                .handover
                                                        ? Images.handoverGif
                                                        : Images.onTheWayGif
                                                    : Images.pendingGif,
                                            height: 60,
                                            width: 60,
                                            fit: BoxFit.fill),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      width: isFirstOrder
                                          ? 0
                                          : Dimensions.paddingSizeSmall),
                                  Expanded(
                                    child: Column(
                                        mainAxisAlignment: isFirstOrder
                                            ? MainAxisAlignment.center
                                            : MainAxisAlignment.start,
                                        crossAxisAlignment: isFirstOrder
                                            ? CrossAxisAlignment.center
                                            : CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                              mainAxisAlignment: isFirstOrder
                                                  ? MainAxisAlignment.center
                                                  : MainAxisAlignment.start,
                                              children: [
                                                Text('${'your_order_is'.tr} ',
                                                    style: robotoBold.copyWith(
                                                        fontSize: Dimensions
                                                            .fontSizeDefault)),
                                                Text(
                                                    widget.reversOrder[index]
                                                        .orderStatus!.tr,
                                                    style: robotoBold.copyWith(
                                                        fontSize: Dimensions
                                                            .fontSizeDefault,
                                                        color: Theme.of(context)
                                                            .primaryColor)),
                                              ]),
                                          const SizedBox(
                                              height: Dimensions
                                                  .paddingSizeExtraSmall),
                                          Text(
                                            '${'order'.tr} #${widget.reversOrder[index].id}',
                                            style: robotoRegular.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeSmall),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          isFirstOrder
                                              ? SizedBox(
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: Dimensions
                                                            .paddingSizeDefault,
                                                        vertical: Dimensions
                                                            .paddingSizeSmall),
                                                    child: Row(children: [
                                                      Expanded(
                                                          child: trackView(
                                                              context,
                                                              status:
                                                                  status >= 1
                                                                      ? true
                                                                      : false)),
                                                      const SizedBox(
                                                          width: Dimensions
                                                              .paddingSizeExtraSmall),
                                                      Expanded(
                                                          child: trackView(
                                                              context,
                                                              status:
                                                                  status >= 2
                                                                      ? true
                                                                      : false)),
                                                      const SizedBox(
                                                          width: Dimensions
                                                              .paddingSizeExtraSmall),
                                                      Expanded(
                                                          child: trackView(
                                                              context,
                                                              status:
                                                                  status >= 3
                                                                      ? true
                                                                      : false)),
                                                      const SizedBox(
                                                          width: Dimensions
                                                              .paddingSizeExtraSmall),
                                                      Expanded(
                                                          child: trackView(
                                                              context,
                                                              status:
                                                                  status >= 4
                                                                      ? true
                                                                      : false)),
                                                    ]),
                                                  ),
                                                )
                                              : const SizedBox()
                                        ]),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(
                                        Dimensions.paddingSizeDefault),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.1),
                                        shape: BoxShape.circle),
                                    child: isFirstOrder
                                        ? !(widget.reversOrder.length < 2)
                                            ? InkWell(
                                                onTap: () =>
                                                    widget.onOrderTap(),
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                          '+${widget.reversOrder.length - 1}',
                                                          style: robotoBold.copyWith(
                                                              fontSize: Dimensions
                                                                  .fontSizeLarge,
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor)),
                                                      Text('more'.tr,
                                                          style: robotoBold.copyWith(
                                                              fontSize: Dimensions
                                                                  .fontSizeExtraSmall,
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor)),
                                                    ]),
                                              )
                                            : Icon(Icons.arrow_forward,
                                                size: 18,
                                                color: Theme.of(context)
                                                    .primaryColor)
                                        : Icon(Icons.arrow_forward,
                                            size: 18,
                                            color:
                                                Theme.of(context).primaryColor),
                                  ),
                                ]),
                          ),
                        ),
                      );
                    }),
              ),
            ]),
          ),
        ),
      );
    });
  }

  Widget trackView(BuildContext context, {required bool status}) {
    return Container(
        height: 5,
        decoration: BoxDecoration(
            color: status
                ? Theme.of(context).primaryColor
                : Theme.of(context).disabledColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault)));
  }
}

class CustomShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();

    // Define the radius for the top corners
    const double cornerRadius = Dimensions.paddingSizeExtraLarge;

    // Move to the starting point (top-left with rounded corner)
    path.moveTo(0, cornerRadius);
    path.quadraticBezierTo(0, 0, cornerRadius, 0);

    // Top horizontal line with a rounded top-right corner
    path.lineTo(size.width - cornerRadius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, cornerRadius);

    // Right vertical line
    path.lineTo(size.width, size.height);

    // Bottom horizontal line with the custom arc in the middle
    path.lineTo(size.width * 0.5 + 24, size.height);
    path.arcToPoint(
      Offset(size.width * 0.5 - 24, size.height),
      radius: const Radius.circular(30),
      clockwise: false,
    );
    path.lineTo(0, size.height);

    // Closing the path from bottom to top-left with rounded corner
    path.lineTo(0, cornerRadius);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

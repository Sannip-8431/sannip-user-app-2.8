import 'package:sannip/common/widgets/custom_ink_well.dart';
import 'package:sannip/features/order/controllers/order_controller.dart';
import 'package:sannip/features/order/domain/models/order_model.dart';
import 'package:sannip/features/order/widgets/order_shimmer_widget.dart';
import 'package:sannip/helper/date_converter.dart';
import 'package:sannip/helper/price_converter.dart';
import 'package:sannip/helper/responsive_helper.dart';
import 'package:sannip/helper/route_helper.dart';
import 'package:sannip/util/dimensions.dart';
import 'package:sannip/util/images.dart';
import 'package:sannip/util/styles.dart';
// import 'package:sannip/common/widgets/custom_image.dart';
import 'package:sannip/common/widgets/footer_view.dart';
import 'package:sannip/common/widgets/no_data_screen.dart';
import 'package:sannip/common/widgets/paginated_list_view.dart';
import 'package:sannip/features/order/screens/order_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderViewWidget extends StatelessWidget {
  final bool isRunning;
  const OrderViewWidget({super.key, required this.isRunning});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: GetBuilder<OrderController>(builder: (orderController) {
        PaginatedOrderModel? paginatedOrderModel;
        if (orderController.runningOrderModel != null &&
            orderController.historyOrderModel != null) {
          paginatedOrderModel = isRunning
              ? orderController.runningOrderModel
              : orderController.historyOrderModel;
        }

        return paginatedOrderModel != null
            ? paginatedOrderModel.orders!.isNotEmpty
                ? RefreshIndicator(
                    onRefresh: () async {
                      if (isRunning) {
                        await orderController.getRunningOrders(1,
                            isUpdate: true);
                      } else {
                        await orderController.getHistoryOrders(1,
                            isUpdate: true);
                      }
                    },
                    child: SingleChildScrollView(
                      controller: scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: FooterView(
                        child: SizedBox(
                          width: Dimensions.webMaxWidth,
                          child: Padding(
                            padding: EdgeInsets.only(
                                bottom: ResponsiveHelper.isDesktop(context)
                                    ? 0
                                    : 100),
                            child: PaginatedListView(
                              scrollController: scrollController,
                              onPaginate: (int? offset) {
                                if (isRunning) {
                                  orderController.getRunningOrders(offset!,
                                      isUpdate: true);
                                } else {
                                  orderController.getHistoryOrders(offset!,
                                      isUpdate: true);
                                }
                              },
                              totalSize: isRunning
                                  ? orderController.runningOrderModel!.totalSize
                                  : orderController
                                      .historyOrderModel!.totalSize,
                              offset: isRunning
                                  ? orderController.runningOrderModel!.offset
                                  : orderController.historyOrderModel!.offset,
                              itemView: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisSpacing:
                                      ResponsiveHelper.isDesktop(context)
                                          ? Dimensions.paddingSizeLarge
                                          : Dimensions.paddingSizeLarge,
                                  mainAxisSpacing:
                                      ResponsiveHelper.isDesktop(context)
                                          ? Dimensions.paddingSizeLarge
                                          : 0,
                                  // childAspectRatio: ResponsiveHelper.isDesktop(context) ? 5 : 4.5,
                                  mainAxisExtent:
                                      ResponsiveHelper.isDesktop(context)
                                          ? 130
                                          : 108,
                                  crossAxisCount:
                                      ResponsiveHelper.isMobile(context)
                                          ? 1
                                          : 2,
                                ),
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                padding: ResponsiveHelper.isDesktop(context)
                                    ? const EdgeInsets.symmetric(
                                        vertical: Dimensions.paddingSizeLarge)
                                    : const EdgeInsets.symmetric(
                                        vertical: Dimensions.paddingSizeSmall),
                                itemCount: paginatedOrderModel.orders!.length,
                                itemBuilder: (context, index) {
                                  bool isParcel = paginatedOrderModel!
                                          .orders![index].orderType ==
                                      'parcel';
                                  // bool isPrescription = paginatedOrderModel
                                  //     .orders![index].prescriptionOrder!;

                                  return Container(
                                    padding: ResponsiveHelper.isDesktop(context)
                                        ? const EdgeInsets.all(
                                            Dimensions.paddingSizeExtraSmall)
                                        : null,
                                    margin: ResponsiveHelper.isDesktop(context)
                                        ? const EdgeInsets.only(
                                            bottom: Dimensions
                                                .paddingSizeExtraSmall)
                                        : const EdgeInsets.symmetric(
                                            horizontal:
                                                Dimensions.paddingSizeSmall,
                                            vertical: Dimensions
                                                .paddingSizeExtraSmall),
                                    decoration: /* ResponsiveHelper.isDesktop(
                                            context)
                                        ? */
                                        BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.radiusSmall),
                                      border: Border.all(
                                          color: Theme.of(context).primaryColor,
                                          width: 0.15),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.1),
                                            spreadRadius: 1,
                                            blurRadius: 3),
                                      ],
                                    ),
                                    child: CustomInkWell(
                                      onTap: () {
                                        Get.toNamed(
                                          RouteHelper.getOrderDetailsRoute(
                                              paginatedOrderModel!
                                                  .orders![index].id),
                                          arguments: OrderDetailsScreen(
                                            orderId: paginatedOrderModel
                                                .orders![index].id,
                                            orderModel: paginatedOrderModel
                                                .orders![index],
                                          ),
                                        );
                                      },
                                      /*  padding: const EdgeInsets.symmetric(
                                          horizontal:
                                              Dimensions.paddingSizeSmall), */
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  /*  Stack(children: [
                                                Container(
                                                  height: ResponsiveHelper
                                                          .isDesktop(context)
                                                      ? 80
                                                      : 60,
                                                  width: ResponsiveHelper
                                                          .isDesktop(context)
                                                      ? 80
                                                      : 60,
                                                  alignment: Alignment.center,
                                                  decoration: isParcel
                                                      ? BoxDecoration(
                                                          borderRadius: BorderRadius
                                                              .circular(Dimensions
                                                                  .radiusSmall),
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColor
                                                              .withOpacity(0.2),
                                                        )
                                                      : null,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            Dimensions
                                                                .radiusSmall),
                                                    child: CustomImage(
                                                      image: isParcel
                                                          ? '${paginatedOrderModel.orders![index].parcelCategory != null ? paginatedOrderModel.orders![index].parcelCategory!.imageFullUrl : ''}'
                                                          : '${paginatedOrderModel.orders![index].store != null ? paginatedOrderModel.orders![index].store!.logoFullUrl : ''}',
                                                      height: isParcel
                                                          ? 35
                                                          : ResponsiveHelper
                                                                  .isDesktop(
                                                                      context)
                                                              ? 80
                                                              : 60,
                                                      width: isParcel
                                                          ? 35
                                                          : ResponsiveHelper
                                                                  .isDesktop(
                                                                      context)
                                                              ? 80
                                                              : 60,
                                                      fit: isParcel
                                                          ? null
                                                          : BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                isParcel
                                                    ? Positioned(
                                                        left: 0,
                                                        top: 10,
                                                        child: Container(
                                                          padding: const EdgeInsets
                                                              .symmetric(
                                                              horizontal: Dimensions
                                                                  .paddingSizeExtraSmall),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius: const BorderRadius
                                                                .horizontal(
                                                                right: Radius
                                                                    .circular(
                                                                        Dimensions
                                                                            .radiusSmall)),
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                          ),
                                                          child: Text(
                                                              'parcel'.tr,
                                                              style:
                                                                  robotoMedium
                                                                      .copyWith(
                                                                fontSize: Dimensions
                                                                    .fontSizeExtraSmall,
                                                                color: Colors
                                                                    .white,
                                                              )),
                                                        ))
                                                    : const SizedBox(),
                                                isPrescription
                                                    ? Positioned(
                                                        left: 0,
                                                        top: 10,
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      2),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius: const BorderRadius
                                                                .horizontal(
                                                                right: Radius
                                                                    .circular(
                                                                        Dimensions
                                                                            .radiusSmall)),
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                          ),
                                                          child: Text(
                                                              'prescription'.tr,
                                                              style:
                                                                  robotoMedium
                                                                      .copyWith(
                                                                fontSize: 10,
                                                                color: Colors
                                                                    .white,
                                                              )),
                                                        ))
                                                    : const SizedBox(),
                                              ]), */
                                                  /* const SizedBox(
                                                  width: Dimensions
                                                      .paddingSizeSmall), */
                                                  Expanded(
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: Dimensions
                                                              .paddingSizeSmall,
                                                          vertical: Dimensions
                                                                  .paddingSizeExtraSmall /
                                                              3),
                                                      child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(children: [
                                                              Text(
                                                                '${isParcel ? 'delivery_id'.tr : 'order_id'.tr}:',
                                                                style: robotoBold
                                                                    .copyWith(
                                                                        fontSize:
                                                                            Dimensions.fontSizeLarge),
                                                              ),
                                                              const SizedBox(
                                                                  width: Dimensions
                                                                          .paddingSizeExtraSmall /
                                                                      2),
                                                              Text(
                                                                  '#${paginatedOrderModel.orders![index].id}',
                                                                  style: robotoBold
                                                                      .copyWith(
                                                                          fontSize:
                                                                              Dimensions.fontSizeLarge)),
                                                            ]),
                                                            /* const SizedBox(
                                                            height: Dimensions
                                                                .paddingSizeSmall), */
                                                            /* ResponsiveHelper
                                                                    .isDesktop(
                                                                        context)
                                                                ? Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        bottom:
                                                                            Dimensions.paddingSizeSmall),
                                                                    child:
                                                                        Container(
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          horizontal: Dimensions
                                                                              .paddingSizeSmall,
                                                                          vertical:
                                                                              Dimensions.paddingSizeExtraSmall),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(Dimensions.radiusSmall),
                                                                        color: Theme.of(context)
                                                                            .primaryColor
                                                                            .withOpacity(0.1),
                                                                      ),
                                                                      child: Text(
                                                                          paginatedOrderModel
                                                                              .orders![
                                                                                  index]
                                                                              .orderStatus!
                                                                              .tr,
                                                                          style:
                                                                              robotoMedium.copyWith(
                                                                            fontSize:
                                                                                Dimensions.fontSizeExtraSmall,
                                                                            color:
                                                                                Theme.of(context).primaryColor,
                                                                          )),
                                                                    ),
                                                                  )
                                                                : const SizedBox(), */
                                                            Text(
                                                              DateConverter.dateTimeStringToDateTimeMonthFirstWithDay(
                                                                  paginatedOrderModel
                                                                      .orders![
                                                                          index]
                                                                      .createdAt!),
                                                              style: robotoRegular.copyWith(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .hintColor,
                                                                  fontSize:
                                                                      Dimensions
                                                                          .fontSizeSmall),
                                                            ),
                                                          ]),
                                                    ),
                                                  ),
                                                  /*  const SizedBox(
                                                      width: Dimensions
                                                          .paddingSizeSmall), */
                                                  /* Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        !ResponsiveHelper
                                                                .isDesktop(
                                                                    context)
                                                            ? Container(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        Dimensions
                                                                            .paddingSizeSmall,
                                                                    vertical:
                                                                        Dimensions
                                                                            .paddingSizeExtraSmall),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          Dimensions
                                                                              .radiusSmall),
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor
                                                                      .withOpacity(
                                                                          0.1),
                                                                ),
                                                                child: Text(
                                                                    paginatedOrderModel
                                                                        .orders![
                                                                            index]
                                                                        .orderStatus!
                                                                        .tr,
                                                                    style: robotoMedium
                                                                        .copyWith(
                                                                      fontSize:
                                                                          Dimensions
                                                                              .fontSizeExtraSmall,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColor,
                                                                    )),
                                                              )
                                                            : const SizedBox(),
                                                        const SizedBox(
                                                            height: Dimensions
                                                                .paddingSizeSmall),
                                                        isRunning
                                                            ? InkWell(
                                                                onTap: () => Get.toNamed(
                                                                    RouteHelper.getOrderTrackingRoute(
                                                                        paginatedOrderModel!
                                                                            .orders![index]
                                                                            .id,
                                                                        null)),
                                                                child:
                                                                    Container(
                                                                  padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          Dimensions
                                                                              .paddingSizeSmall,
                                                                      vertical: ResponsiveHelper.isDesktop(
                                                                              context)
                                                                          ? Dimensions
                                                                              .fontSizeSmall
                                                                          : Dimensions
                                                                              .paddingSizeExtraSmall),
                                                                  decoration: ResponsiveHelper
                                                                          .isDesktop(
                                                                              context)
                                                                      ? BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(Dimensions.radiusSmall),
                                                                          color:
                                                                              Theme.of(context).primaryColor,
                                                                        )
                                                                      : BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(Dimensions.radiusSmall),
                                                                          border: Border.all(
                                                                              width: 1,
                                                                              color: Theme.of(context).primaryColor),
                                                                        ),
                                                                  child: Row(
                                                                      children: [
                                                                        Image.asset(
                                                                            Images
                                                                                .tracking,
                                                                            height:
                                                                                15,
                                                                            width:
                                                                                15,
                                                                            color: ResponsiveHelper.isDesktop(context)
                                                                                ? Colors.white
                                                                                : Theme.of(context).primaryColor),
                                                                        const SizedBox(
                                                                            width:
                                                                                Dimensions.paddingSizeExtraSmall),
                                                                        Text(
                                                                            isParcel
                                                                                ? 'track_delivery'.tr
                                                                                : 'track_order'.tr,
                                                                            style: robotoMedium.copyWith(
                                                                              fontSize: Dimensions.fontSizeExtraSmall,
                                                                              color: ResponsiveHelper.isDesktop(context) ? Colors.white : Theme.of(context).primaryColor,
                                                                            )),
                                                                      ]),
                                                                ),
                                                              )
                                                            : Text(
                                                                '${paginatedOrderModel.orders![index].detailsCount} ${paginatedOrderModel.orders![index].detailsCount! > 1 ? 'items'.tr : 'item'.tr}',
                                                                style: robotoRegular
                                                                    .copyWith(
                                                                        fontSize:
                                                                            Dimensions.fontSizeExtraSmall),
                                                              ),
                                                      ]), */
                                                ]),
                                            /* !ResponsiveHelper.isDesktop(context)
                                                ? */
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: Dimensions
                                                            .paddingSizeSmall,
                                                        vertical: Dimensions
                                                            .paddingSizeExtraSmall),
                                                    decoration: BoxDecoration(
                                                      /*  borderRadius:
                                                                BorderRadius.circular(
                                                                    Dimensions
                                                                        .radiusSmall), */
                                                      color: Theme.of(context)
                                                          .primaryColor
                                                          .withOpacity(0.09),
                                                    ),
                                                    child: Text(
                                                        paginatedOrderModel
                                                                    .orders![
                                                                        index]
                                                                    .orderStatus
                                                                    ?.tr ==
                                                                'Handover'
                                                            ? 'your_order_has_been_handed_over'
                                                                .tr
                                                            : "${'your_order_is'.tr} ${paginatedOrderModel.orders![index].orderStatus!.tr}",
                                                        style: robotoMedium
                                                            .copyWith(
                                                          fontSize: Dimensions
                                                              .fontSizeExtraSmall,
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                        )),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets
                                                  .symmetric(
                                                  horizontal: Dimensions
                                                      .paddingSizeSmall,
                                                  vertical: Dimensions
                                                          .paddingSizeSmall /
                                                      4),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  PriceConverter
                                                      .convertAnimationPrice(
                                                    paginatedOrderModel
                                                        .orders![index]
                                                        .orderAmount,
                                                    textStyle:
                                                        robotoRegular.copyWith(
                                                            fontSize: Dimensions
                                                                .fontSizeLarge,
                                                            color: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyMedium!
                                                                .color),
                                                  ),
                                                  isRunning
                                                      ? InkWell(
                                                          onTap: () => Get.toNamed(
                                                              RouteHelper.getOrderTrackingRoute(
                                                                  paginatedOrderModel!
                                                                      .orders![
                                                                          index]
                                                                      .id,
                                                                  null)),
                                                          child: Container(
                                                            padding: const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    Dimensions
                                                                        .paddingSizeSmall,
                                                                vertical: Dimensions
                                                                    .paddingSizeExtraSmall),
                                                            /*   decoration: ResponsiveHelper
                                                                    .isDesktop(
                                                                        context)
                                                                ? BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            Dimensions
                                                                                .radiusSmall),
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor,
                                                                  )
                                                                : BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            Dimensions
                                                                                .radiusSmall),
                                                                    border: Border.all(
                                                                        width: 1,
                                                                        color: Theme.of(
                                                                                context)
                                                                            .primaryColor),
                                                                  ), */
                                                            child: Row(
                                                                children: [
                                                                  Image.asset(
                                                                      Images
                                                                          .tracking,
                                                                      height:
                                                                          15,
                                                                      width: 15,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColor),
                                                                  const SizedBox(
                                                                      width: Dimensions
                                                                          .paddingSizeExtraSmall),
                                                                  Text(
                                                                      isParcel
                                                                          ? 'track_delivery'
                                                                              .tr
                                                                          : 'track_order'
                                                                              .tr,
                                                                      style: robotoMedium
                                                                          .copyWith(
                                                                        fontSize:
                                                                            Dimensions.fontSizeExtraSmall,
                                                                        color: Theme.of(context)
                                                                            .primaryColor,
                                                                      )),
                                                                ]),
                                                          ),
                                                        )
                                                      : Text(
                                                          '${paginatedOrderModel.orders![index].detailsCount} ${paginatedOrderModel.orders![index].detailsCount! > 1 ? 'items'.tr : 'item'.tr}',
                                                          style: robotoRegular
                                                              .copyWith(
                                                                  fontSize:
                                                                      Dimensions
                                                                          .fontSizeSmall),
                                                        )
                                                ],
                                              ),
                                            ),
                                            /*  (index ==
                                                        paginatedOrderModel
                                                                .orders!
                                                                .length -
                                                            1 ||
                                                    ResponsiveHelper.isDesktop(
                                                        context))
                                                ? const SizedBox()
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 70),
                                                    child: Divider(
                                                      color: Theme.of(context)
                                                          .disabledColor,
                                                      height: Dimensions
                                                          .paddingSizeLarge,
                                                    ),
                                                  ), */
                                          ]),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : NoDataScreen(text: 'no_order_found'.tr, showFooter: true)
            : OrderShimmerWidget(orderController: orderController);
      }),
    );
  }
}

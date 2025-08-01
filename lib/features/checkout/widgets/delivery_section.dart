import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sannip/common/widgets/address_widget.dart';
import 'package:sannip/features/address/domain/models/address_model.dart';
import 'package:sannip/features/checkout/controllers/checkout_controller.dart';
import 'package:sannip/helper/auth_helper.dart';
import 'package:sannip/helper/responsive_helper.dart';
import 'package:sannip/helper/route_helper.dart';
import 'package:sannip/util/dimensions.dart';
import 'package:sannip/util/styles.dart';
import 'package:sannip/common/widgets/custom_dropdown.dart';
import 'package:sannip/common/widgets/custom_text_field.dart';
import 'package:sannip/features/checkout/widgets/guest_delivery_address.dart';

class DeliverySection extends StatelessWidget {
  final CheckoutController checkoutController;
  final List<AddressModel> address;
  final List<DropdownItem<int>> addressList;
  final TextEditingController guestNameTextEditingController;
  final TextEditingController guestNumberTextEditingController;
  final TextEditingController guestEmailController;
  final FocusNode guestNumberNode;
  final FocusNode guestEmailNode;
  const DeliverySection({
    super.key,
    required this.checkoutController,
    required this.address,
    required this.addressList,
    required this.guestNameTextEditingController,
    required this.guestNumberTextEditingController,
    required this.guestNumberNode,
    required this.guestEmailController,
    required this.guestEmailNode,
  });

  @override
  Widget build(BuildContext context) {
    bool isGuestLoggedIn = AuthHelper.isGuestLoggedIn();
    bool takeAway = (checkoutController.orderType == 'take_away');
    bool isDesktop = ResponsiveHelper.isDesktop(context);
    return Column(children: [
      isGuestLoggedIn
          ? GuestDeliveryAddress(
              checkoutController: checkoutController,
              guestNumberNode: guestNumberNode,
              guestNameTextEditingController: guestNameTextEditingController,
              guestNumberTextEditingController:
                  guestNumberTextEditingController,
              guestEmailController: guestEmailController,
              guestEmailNode: guestEmailNode,
            )
          : !takeAway
              ? Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    boxShadow: [
                      BoxShadow(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.05),
                          blurRadius: 10)
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeLarge),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: Dimensions.paddingSizeExtraSmall,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('deliver_to'.tr, style: robotoMedium),
                              InkWell(
                                onTap: () async {
                                  var address = await Get.toNamed(
                                      RouteHelper.getAddAddressRoute(
                                          true,
                                          false,
                                          checkoutController.store!.zoneId));
                                  if (address != null) {
                                    checkoutController.getDistanceInKM(
                                      LatLng(double.parse(address.latitude),
                                          double.parse(address.longitude)),
                                      LatLng(
                                          double.parse(checkoutController
                                              .store!.latitude!),
                                          double.parse(checkoutController
                                              .store!.longitude!)),
                                    );
                                    checkoutController.streetNumberController
                                        .text = address.streetNumber ?? '';
                                    checkoutController.houseController.text =
                                        address.house ?? '';
                                    checkoutController.floorController.text =
                                        address.floor ?? '';
                                  }
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.add,
                                      size: 20,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    const SizedBox(
                                      width: Dimensions.paddingSizeExtraSmall,
                                    ),
                                    Text('add_new'.tr,
                                        style: robotoMedium.copyWith(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize:
                                                Dimensions.fontSizeSmall)),
                                  ],
                                ),
                              ),
                            ]),
                        const SizedBox(
                          height: Dimensions.paddingSizeExtraSmall,
                        ),
                        isDesktop
                            ? Stack(children: [
                                Container(
                                  constraints:
                                      const BoxConstraints(minHeight: 90),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.radiusDefault),
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.1),
                                  ),
                                  child: Container(
                                    height: 45,
                                    padding: const EdgeInsets.symmetric(
                                      vertical:
                                          Dimensions.paddingSizeExtraSmall,
                                      horizontal:
                                          Dimensions.paddingSizeExtraSmall,
                                    ),
                                    child: AddressWidget(
                                      address: address[
                                          checkoutController.addressIndex!],
                                      fromAddress: false,
                                      fromCheckout: true,
                                    ),
                                  ),
                                ),
                                Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: PopupMenuButton(
                                        position: PopupMenuPosition.under,
                                        icon: const Icon(
                                            Icons.keyboard_arrow_down),
                                        onSelected: (value) {},
                                        itemBuilder: (context) => List.generate(
                                            address.length,
                                            (index) => PopupMenuItem(
                                                  child: InkWell(
                                                    onTap: () {
                                                      checkoutController
                                                          .getDistanceInKM(
                                                        LatLng(
                                                          double.parse(
                                                              address[index]
                                                                  .latitude!),
                                                          double.parse(
                                                              address[index]
                                                                  .longitude!),
                                                        ),
                                                        LatLng(
                                                            double.parse(
                                                                checkoutController
                                                                    .store!
                                                                    .latitude!),
                                                            double.parse(
                                                                checkoutController
                                                                    .store!
                                                                    .longitude!)),
                                                      );
                                                      checkoutController
                                                          .setAddressIndex(
                                                              index);
                                                      checkoutController
                                                          .streetNumberController
                                                          .text = address[
                                                                  checkoutController
                                                                      .addressIndex!]
                                                              .streetNumber ??
                                                          '';
                                                      checkoutController
                                                          .houseController
                                                          .text = address[
                                                                  checkoutController
                                                                      .addressIndex!]
                                                              .house ??
                                                          '';
                                                      checkoutController
                                                          .floorController
                                                          .text = address[
                                                                  checkoutController
                                                                      .addressIndex!]
                                                              .floor ??
                                                          '';
                                                      Navigator.pop(context);
                                                    },
                                                    child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            height: 20,
                                                            width: 20,
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(3),
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              border: Border.all(
                                                                  color: checkoutController
                                                                              .addressIndex ==
                                                                          index
                                                                      ? Theme.of(
                                                                              context)
                                                                          .primaryColor
                                                                      : Theme.of(
                                                                              context)
                                                                          .disabledColor),
                                                            ),
                                                            child: checkoutController
                                                                        .addressIndex ==
                                                                    index
                                                                ? Container(
                                                                    height: 15,
                                                                    width: 15,
                                                                    decoration: BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                        color: Theme.of(context)
                                                                            .primaryColor),
                                                                  )
                                                                : const SizedBox(),
                                                          ),
                                                          const SizedBox(
                                                              width: Dimensions
                                                                  .paddingSizeSmall),
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                    address[index]
                                                                        .addressType!
                                                                        .tr,
                                                                    style: robotoMedium.copyWith(
                                                                        fontSize:
                                                                            Dimensions.fontSizeSmall)),
                                                                const SizedBox(
                                                                    height: Dimensions
                                                                        .paddingSizeExtraSmall),
                                                                Text(
                                                                  address[index]
                                                                      .address!,
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: robotoRegular.copyWith(
                                                                      fontSize:
                                                                          Dimensions
                                                                              .fontSizeExtraSmall,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .disabledColor),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ]),
                                                  ),
                                                ))),
                                  ),
                                ),
                              ])
                            : Container(
                                constraints: BoxConstraints(
                                    minHeight:
                                        ResponsiveHelper.isDesktop(context)
                                            ? 90
                                            : 75),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radiusDefault),
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.1),
                                ),
                                child: CustomDropdown<int>(
                                  onChange: (int? value, int index) {
                                    checkoutController.getDistanceInKM(
                                      LatLng(
                                        double.parse(address[index].latitude!),
                                        double.parse(address[index].longitude!),
                                      ),
                                      LatLng(
                                          double.parse(checkoutController
                                              .store!.latitude!),
                                          double.parse(checkoutController
                                              .store!.longitude!)),
                                    );
                                    checkoutController.setAddressIndex(index);

                                    checkoutController.streetNumberController
                                        .text = address[checkoutController
                                                .addressIndex!]
                                            .streetNumber ??
                                        '';
                                    checkoutController.houseController.text =
                                        address[checkoutController
                                                    .addressIndex!]
                                                .house ??
                                            '';
                                    checkoutController.floorController.text =
                                        address[checkoutController
                                                    .addressIndex!]
                                                .floor ??
                                            '';
                                  },
                                  dropdownButtonStyle: DropdownButtonStyle(
                                    height: 45,
                                    padding: const EdgeInsets.symmetric(
                                      vertical:
                                          Dimensions.paddingSizeExtraSmall,
                                      horizontal:
                                          Dimensions.paddingSizeExtraSmall,
                                    ),
                                    primaryColor: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .color,
                                  ),
                                  dropdownStyle: DropdownStyle(
                                    elevation: 10,
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.radiusDefault),
                                    padding: const EdgeInsets.all(
                                        Dimensions.paddingSizeExtraSmall),
                                  ),
                                  items: addressList,
                                  child: AddressWidget(
                                    address: address[
                                        checkoutController.addressIndex!],
                                    fromAddress: false,
                                    fromCheckout: true,
                                  ),
                                ),
                              ),
                        if (isDesktop)
                          const SizedBox(height: Dimensions.paddingSizeLarge),
                        // !isDesktop
                        //     ? CustomTextField(
                        //         labelText: 'street_number'.tr,
                        //         titleText: 'write_street_number'.tr,
                        //         inputType: TextInputType.streetAddress,
                        //         focusNode: checkoutController.streetNode,
                        //         nextFocus: checkoutController.houseNode,
                        //         controller:
                        //             checkoutController.streetNumberController,
                        //       )
                        //     : const SizedBox(),
                        // SizedBox(
                        //     height:
                        //         !isDesktop ? Dimensions.paddingSizeLarge : 0),
                        Row(children: [
                          isDesktop
                              ? Expanded(
                                  child: CustomTextField(
                                    titleText: 'street_number'.tr,
                                    labelText: 'write_street_number'.tr,
                                    inputType: TextInputType.streetAddress,
                                    focusNode: checkoutController.streetNode,
                                    nextFocus: checkoutController.houseNode,
                                    controller: checkoutController
                                        .streetNumberController,
                                  ),
                                )
                              : const SizedBox(),
                          SizedBox(
                              width:
                                  isDesktop ? Dimensions.paddingSizeSmall : 0),

                          if (isDesktop)
                            Expanded(
                              child: CustomTextField(
                                titleText: 'write_house_number'.tr,
                                labelText: 'house'.tr,
                                inputType: TextInputType.text,
                                focusNode: checkoutController.houseNode,
                                nextFocus: checkoutController.floorNode,
                                controller: checkoutController.houseController,
                              ),
                            ),
                          if (isDesktop)
                            const SizedBox(width: Dimensions.paddingSizeSmall),

                          if (isDesktop)
                            Expanded(
                              child: CustomTextField(
                                titleText: 'write_floor_number'.tr,
                                labelText: 'floor'.tr,
                                inputType: TextInputType.text,
                                focusNode: checkoutController.floorNode,
                                inputAction: TextInputAction.done,
                                controller: checkoutController.floorController,
                              ),
                            ),
                          //const SizedBox(height: Dimensions.paddingSizeLarge),
                        ]),
                        if (isDesktop)
                          const SizedBox(height: Dimensions.paddingSizeLarge),
                      ]),
                )
              : const SizedBox(),
    ]);
  }
}

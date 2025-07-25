import 'package:sannip/common/widgets/custom_button.dart';
import 'package:sannip/features/address/controllers/address_controller.dart';
import 'package:sannip/features/address/widgets/address_confirmation_dialogue.dart';
import 'package:sannip/common/widgets/address_widget.dart';
import 'package:sannip/helper/auth_helper.dart';
import 'package:sannip/helper/responsive_helper.dart';
import 'package:sannip/helper/route_helper.dart';
import 'package:sannip/util/dimensions.dart';
import 'package:sannip/util/images.dart';
import 'package:sannip/util/styles.dart';
import 'package:sannip/common/widgets/custom_app_bar.dart';
import 'package:sannip/common/widgets/custom_snackbar.dart';
import 'package:sannip/common/widgets/footer_view.dart';
import 'package:sannip/common/widgets/menu_drawer.dart';
import 'package:sannip/common/widgets/no_data_screen.dart';
import 'package:sannip/common/widgets/not_logged_in_screen.dart';
import 'package:sannip/common/widgets/web_page_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressScreen extends StatefulWidget {
  final bool fromDashboard;
  const AddressScreen({super.key, this.fromDashboard = false});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    initCall();
  }

  void initCall() {
    if (AuthHelper.isLoggedIn()) {
      Get.find<AddressController>().getAddressList();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = AuthHelper.isLoggedIn();
    return GetBuilder<AddressController>(builder: (addressController) {
      return Scaffold(
        appBar: CustomAppBar(
            title: 'my_address'.tr,
            backButton: widget.fromDashboard ? false : true),
        endDrawer: const MenuDrawer(),
        endDrawerEnableOpenDragGesture: false,
        /*floatingActionButton: ResponsiveHelper.isDesktop(context) || !isLoggedIn
            ? null
            : (addressController.addressList != null &&
                    addressController.addressList!.isEmpty)
                ? null
                : FloatingActionButton(
                    backgroundColor: Theme.of(context).primaryColor,
                    onPressed: () => Get.toNamed(RouteHelper.getAddAddressRoute(
                        false, false, 0,
                        isNavbar: true)),
                    child: Icon(Icons.add, color: Theme.of(context).cardColor),
                  ),
        floatingActionButtonLocation: ResponsiveHelper.isDesktop(context)
            ? FloatingActionButtonLocation.centerFloat
            : null,*/
        body: Container(
          height: context.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              opacity: ResponsiveHelper.isDesktop(context) ? 1.0 : 0.5,
              image: AssetImage(ResponsiveHelper.isDesktop(context)
                  ? Images.addressCity
                  : Images.addressBackgroundImage),
              alignment: ResponsiveHelper.isDesktop(context)
                  ? Alignment.center
                  : Alignment.bottomCenter,
              fit: BoxFit.fitWidth,
            ),
          ),
          child: isLoggedIn
              ? RefreshIndicator(
                  onRefresh: () async {
                    await addressController.getAddressList();
                  },
                  child: SingleChildScrollView(
                    controller: scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        WebScreenTitleWidget(title: 'address'.tr),
                        Center(
                            child: FooterView(
                          child: SizedBox(
                            width: Dimensions.webMaxWidth,
                            child: Column(
                              children: [
                                ResponsiveHelper.isDesktop(context)
                                    ? const SizedBox(
                                        height: Dimensions.paddingSizeSmall)
                                    : const SizedBox(),
                                addressController.addressList != null
                                    ? addressController.addressList!.isNotEmpty
                                        ? ResponsiveHelper.isMobile(context)
                                            ? SingleChildScrollView(
                                                child: Column(
                                                  children: [
                                                    ListView.separated(
                                                        padding: const EdgeInsets
                                                            .symmetric(
                                                            vertical: Dimensions
                                                                .paddingSizeSmall),
                                                        shrinkWrap: true,
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        itemBuilder:
                                                            (context, index) {
                                                          return AddressWidget(
                                                            address:
                                                                addressController
                                                                        .addressList![
                                                                    index],
                                                            isChangeDesign:
                                                                true,
                                                            fromAddress: true,
                                                            onTap: () {
                                                              Get.toNamed(RouteHelper
                                                                  .getMapRoute(
                                                                      addressController
                                                                              .addressList![
                                                                          index],
                                                                      'address',
                                                                      false));
                                                            },
                                                            onEditPressed: () {
                                                              Get.toNamed(RouteHelper
                                                                  .getEditAddressRoute(
                                                                      addressController
                                                                              .addressList![
                                                                          index]));
                                                            },
                                                            onRemovePressed:
                                                                () {
                                                              if (Get
                                                                  .isSnackbarOpen) {
                                                                Get.back();
                                                              }
                                                              Get.dialog(
                                                                AddressConfirmDialogue(
                                                                    icon: Images
                                                                        .locationConfirm,
                                                                    title:
                                                                        'are_you_sure'
                                                                            .tr,
                                                                    description:
                                                                        'you_want_to_delete_this_location'
                                                                            .tr,
                                                                    onYesPressed:
                                                                        () {
                                                                      addressController
                                                                          .deleteUserAddressByID(
                                                                              addressController.addressList![index].id,
                                                                              index)
                                                                          .then((response) {
                                                                        Get.back();
                                                                        showCustomSnackBar(
                                                                            response
                                                                                .message,
                                                                            isError:
                                                                                !response.isSuccess);
                                                                      });
                                                                    }),
                                                              );
                                                            },
                                                          );
                                                        },
                                                        separatorBuilder:
                                                            (context, index) {
                                                          return const SizedBox(
                                                            height: Dimensions
                                                                .paddingSizeSmall,
                                                          );
                                                        },
                                                        itemCount:
                                                            addressController
                                                                .addressList!
                                                                .length),
                                                    const SizedBox(
                                                      height: Dimensions
                                                          .paddingSizeDefault,
                                                    ),
                                                    CustomButton(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.7,
                                                      radius: 100,
                                                      isBold: false,
                                                      buttonText:
                                                          'add_new_address'.tr,
                                                      onPressed: () => Get
                                                          .toNamed(RouteHelper
                                                              .getAddAddressRoute(
                                                                  false,
                                                                  false,
                                                                  0,
                                                                  isNavbar:
                                                                      true)),
                                                    )
                                                  ],
                                                ),
                                              )
                                            : Padding(
                                                padding: ResponsiveHelper
                                                        .isMobile(context)
                                                    ? const EdgeInsets.all(
                                                        Dimensions
                                                            .paddingSizeSmall)
                                                    : EdgeInsets.zero,
                                                child: GridView.builder(
                                                  gridDelegate:
                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisSpacing: Dimensions
                                                        .paddingSizeLarge,
                                                    mainAxisSpacing:
                                                        ResponsiveHelper
                                                                .isDesktop(
                                                                    context)
                                                            ? Dimensions
                                                                .paddingSizeLarge
                                                            : 0.01,
                                                    childAspectRatio:
                                                        ResponsiveHelper
                                                                .isDesktop(
                                                                    context)
                                                            ? 4
                                                            : 2.8,
                                                    crossAxisCount:
                                                        ResponsiveHelper
                                                                .isMobile(
                                                                    context)
                                                            ? 1
                                                            : 3,
                                                  ),
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemCount: ResponsiveHelper
                                                          .isDesktop(context)
                                                      ? (addressController
                                                              .addressList!
                                                              .length +
                                                          1)
                                                      : addressController
                                                          .addressList!.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return (ResponsiveHelper
                                                                .isDesktop(
                                                                    context) &&
                                                            (index ==
                                                                addressController
                                                                    .addressList!
                                                                    .length))
                                                        ? InkWell(
                                                            onTap: () => Get
                                                                .toNamed(RouteHelper
                                                                    .getAddAddressRoute(
                                                                        false,
                                                                        false,
                                                                        0)),
                                                            child: Container(
                                                                margin: const EdgeInsets
                                                                    .only(
                                                                    bottom: Dimensions
                                                                        .paddingSizeSmall),
                                                                padding: const EdgeInsets
                                                                    .all(
                                                                    Dimensions
                                                                        .paddingSizeSmall),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .cardColor,
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          Dimensions
                                                                              .radiusDefault),
                                                                  boxShadow: const [
                                                                    BoxShadow(
                                                                        color: Colors
                                                                            .black12,
                                                                        blurRadius:
                                                                            5,
                                                                        spreadRadius:
                                                                            1)
                                                                  ],
                                                                ),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Icon(
                                                                        Icons
                                                                            .add_circle_outline,
                                                                        color: Theme.of(context)
                                                                            .primaryColor),
                                                                    const SizedBox(
                                                                        height:
                                                                            Dimensions.paddingSizeSmall),
                                                                    Text(
                                                                        'add_new_address'
                                                                            .tr,
                                                                        style: robotoRegular.copyWith(
                                                                            color:
                                                                                Theme.of(context).primaryColor,
                                                                            fontSize: Dimensions.fontSizeSmall)),
                                                                  ],
                                                                )),
                                                          )
                                                        : AddressWidget(
                                                            address:
                                                                addressController
                                                                        .addressList![
                                                                    index],
                                                            isChangeDesign:
                                                                true,
                                                            fromAddress: true,
                                                            onTap: () {
                                                              Get.toNamed(RouteHelper
                                                                  .getMapRoute(
                                                                      addressController
                                                                              .addressList![
                                                                          index],
                                                                      'address',
                                                                      false));
                                                            },
                                                            onEditPressed: () {
                                                              Get.toNamed(RouteHelper
                                                                  .getEditAddressRoute(
                                                                      addressController
                                                                              .addressList![
                                                                          index]));
                                                            },
                                                            onRemovePressed:
                                                                () {
                                                              if (Get
                                                                  .isSnackbarOpen) {
                                                                Get.back();
                                                              }
                                                              Get.dialog(
                                                                AddressConfirmDialogue(
                                                                    icon: Images
                                                                        .locationConfirm,
                                                                    title:
                                                                        'are_you_sure'
                                                                            .tr,
                                                                    description:
                                                                        'you_want_to_delete_this_location'
                                                                            .tr,
                                                                    onYesPressed:
                                                                        () {
                                                                      addressController
                                                                          .deleteUserAddressByID(
                                                                              addressController.addressList![index].id,
                                                                              index)
                                                                          .then((response) {
                                                                        Get.back();
                                                                        showCustomSnackBar(
                                                                            response
                                                                                .message,
                                                                            isError:
                                                                                !response.isSuccess);
                                                                      });
                                                                    }),
                                                              );
                                                            },
                                                          );
                                                  },
                                                ),
                                              )
                                        : NoDataScreen(
                                            text: 'no_saved_address_found'.tr,
                                            fromAddress: true)
                                    : const Center(
                                        child: CircularProgressIndicator()),
                              ],
                            ),
                          ),
                        ))
                      ],
                    ),
                  ),
                )
              : NotLoggedInScreen(callBack: (value) {
                  initCall();
                  setState(() {});
                }),
        ),
        bottomNavigationBar: widget.fromDashboard
            ? Container(height: GetPlatform.isIOS ? 80 : 65)
            : const SizedBox(),
      );
    });
  }
}

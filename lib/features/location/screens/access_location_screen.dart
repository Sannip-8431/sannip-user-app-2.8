import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:sannip/common/widgets/address_widget.dart';
import 'package:sannip/features/location/controllers/location_controller.dart';
import 'package:sannip/features/address/controllers/address_controller.dart';
import 'package:sannip/features/address/domain/models/address_model.dart';
import 'package:sannip/features/location/domain/models/zone_response_model.dart';
import 'package:sannip/helper/address_helper.dart';
import 'package:sannip/helper/auth_helper.dart';
import 'package:sannip/helper/responsive_helper.dart';
import 'package:sannip/helper/route_helper.dart';
import 'package:sannip/util/dimensions.dart';
import 'package:sannip/util/images.dart';
import 'package:sannip/util/styles.dart';
import 'package:sannip/common/widgets/custom_app_bar.dart';
import 'package:sannip/common/widgets/custom_button.dart';
import 'package:sannip/common/widgets/custom_loader.dart';
import 'package:sannip/common/widgets/custom_snackbar.dart';
import 'package:sannip/common/widgets/footer_view.dart';
import 'package:sannip/common/widgets/menu_drawer.dart';
import 'package:sannip/common/widgets/no_data_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sannip/features/location/screens/pick_map_screen.dart';
import 'package:sannip/features/location/screens/web_landing_page.dart';

class AccessLocationScreen extends StatefulWidget {
  final bool fromSignUp;
  final bool fromHome;
  final String? route;
  const AccessLocationScreen(
      {super.key,
      required this.fromSignUp,
      required this.fromHome,
      required this.route});

  @override
  State<AccessLocationScreen> createState() => _AccessLocationScreenState();
}

class _AccessLocationScreenState extends State<AccessLocationScreen> {
  bool _canExit = GetPlatform.isWeb ? true : false;

  @override
  void initState() {
    super.initState();
    if (AuthHelper.isLoggedIn()) {
      Get.find<AddressController>().getAddressList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) async {
        if (_canExit) {
          if (GetPlatform.isAndroid) {
            SystemNavigator.pop();
          } else if (GetPlatform.isIOS) {
            exit(0);
          } else {
            Navigator.pushNamed(context, RouteHelper.getInitialRoute());
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('back_press_again_to_exit'.tr,
                style: const TextStyle(color: Colors.white)),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
            margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          ));
          _canExit = true;
          Timer(const Duration(seconds: 2), () {
            _canExit = false;
          });
        }
      },
      child: Scaffold(
        appBar:
            CustomAppBar(title: 'set_location'.tr, backButton: widget.fromHome),
        endDrawer: const MenuDrawer(),
        endDrawerEnableOpenDragGesture: false,
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
            child: GetBuilder<AddressController>(builder: (locationController) {
          bool isLoggedIn = AuthHelper.isLoggedIn();
          return (ResponsiveHelper.isDesktop(context) &&
                  AddressHelper.getUserAddressFromSharedPref() == null)
              ? WebLandingPage(
                  fromSignUp: widget.fromSignUp,
                  fromHome: widget.fromHome,
                  route: widget.route,
                )
              : isLoggedIn
                  ? Column(children: [
                      Expanded(
                          child: SingleChildScrollView(
                        child: FooterView(
                            child: Column(
                                mainAxisAlignment:
                                    (locationController.addressList != null &&
                                            locationController
                                                .addressList!.isNotEmpty)
                                        ? MainAxisAlignment.start
                                        : MainAxisAlignment.center,
                                children: [
                              locationController.addressList != null
                                  ? locationController.addressList!.isNotEmpty
                                      ? ListView.separated(
                                          padding: const EdgeInsets.symmetric(
                                              vertical:
                                                  Dimensions.paddingSizeSmall),
                                          separatorBuilder: (context, index) {
                                            return const SizedBox(
                                              height:
                                                  Dimensions.paddingSizeSmall,
                                            );
                                          },
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: locationController
                                              .addressList!.length,
                                          itemBuilder: (context, index) {
                                            return AddressWidget(
                                              isChangeDesign: true,
                                              address: locationController
                                                  .addressList![index],
                                              fromAddress: false,
                                              onTap: () {
                                                Get.dialog(const CustomLoader(),
                                                    barrierDismissible: false);
                                                AddressModel address =
                                                    locationController
                                                        .addressList![index];
                                                Get.find<LocationController>()
                                                    .saveAddressAndNavigate(
                                                  address,
                                                  widget.fromSignUp,
                                                  widget.route,
                                                  widget.route != null,
                                                  ResponsiveHelper.isDesktop(
                                                      context),
                                                );
                                              },
                                            );
                                          },
                                        )
                                      : NoDataScreen(
                                          text: 'no_saved_address_found'.tr)
                                  : const Center(
                                      child: CircularProgressIndicator()),
                              const SizedBox(
                                  height: Dimensions.paddingSizeLarge),
                              ResponsiveHelper.isDesktop(context)
                                  ? BottomButton(
                                      fromSignUp: widget.fromSignUp,
                                      route: widget.route)
                                  : const SizedBox(),
                            ])),
                      )),
                      ResponsiveHelper.isDesktop(context)
                          ? const SizedBox()
                          : Padding(
                              padding: const EdgeInsets.all(
                                  Dimensions.paddingSizeSmall),
                              child: BottomButton(
                                  fromSignUp: widget.fromSignUp,
                                  route: widget.route),
                            ),
                    ])
                  : FooterView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: Dimensions.paddingSizeExtraOverLarge,
                              left: Dimensions.paddingSizeDefault,
                            ),
                            child: Text('whats_your_location'.tr.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: robotoMedium.copyWith(
                                    fontSize: Dimensions.fontSizeOverLarge)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: Dimensions.paddingSizeSmall,
                              left: Dimensions.paddingSizeDefault,
                            ),
                            child: Text(
                              'we_need_your_location'.tr,
                              style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeLarge,
                                  color: Theme.of(context).disabledColor),
                            ),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeLarge),
                          Image.asset(
                            Images.locationImage,
                            height: Get.height * 0.53,
                            width: Get.width,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeLarge),
                          Padding(
                            padding: ResponsiveHelper.isWeb()
                                ? EdgeInsets.zero
                                : const EdgeInsets.symmetric(
                                    horizontal: Dimensions.paddingSizeLarge),
                            child: BottomButton(
                                fromSignUp: widget.fromSignUp,
                                route: widget.route),
                          ),
                        ]));
        })),
      ),
    );
  }
}

class BottomButton extends StatelessWidget {
  final bool fromSignUp;
  final String? route;
  const BottomButton(
      {super.key, required this.fromSignUp, required this.route});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
            width: 700,
            child: Column(children: [
              CustomButton(
                buttonText: 'user_current_location'.tr,
                onPressed: () async {
                  Get.find<LocationController>().checkPermission(() async {
                    Get.dialog(const CustomLoader(), barrierDismissible: false);
                    AddressModel address = await Get.find<LocationController>()
                        .getCurrentLocation(true);
                    ZoneResponseModel response =
                        await Get.find<LocationController>().getZone(
                            address.latitude, address.longitude, false);
                    if (response.isSuccess) {
                      Get.find<LocationController>().saveAddressAndNavigate(
                        address,
                        fromSignUp,
                        route,
                        route != null,
                        ResponsiveHelper.isDesktop(Get.context),
                      );
                    } else {
                      Get.back();
                      if (ResponsiveHelper.isDesktop(Get.context)) {
                        showGeneralDialog(
                            context: Get.context!,
                            pageBuilder: (_, __, ___) {
                              return SizedBox(
                                  height: 300,
                                  width: 300,
                                  child: PickMapScreen(
                                      fromSignUp: fromSignUp,
                                      canRoute: route != null,
                                      fromAddAddress: false,
                                      route:
                                          route ?? RouteHelper.accessLocation));
                            });
                      } else {
                        Get.toNamed(RouteHelper.getPickMapRoute(
                            route ?? RouteHelper.accessLocation,
                            route != null));
                        showCustomSnackBar(
                            'service_not_available_in_current_location'.tr);
                      }
                    }
                  });
                },
                icon: Icons.my_location,
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                        width: 1, color: Theme.of(context).primaryColor),
                    borderRadius:
                        BorderRadius.circular(Dimensions.radiusDefault),
                  ),
                  minimumSize: const Size(Dimensions.webMaxWidth, 50),
                  padding: EdgeInsets.zero,
                ),
                onPressed: () {
                  if (ResponsiveHelper.isDesktop(Get.context)) {
                    showGeneralDialog(
                        context: Get.context!,
                        pageBuilder: (_, __, ___) {
                          return SizedBox(
                              height: 300,
                              width: 300,
                              child: PickMapScreen(
                                  fromSignUp: fromSignUp,
                                  canRoute: route != null,
                                  fromAddAddress: false,
                                  route: route ?? RouteHelper.accessLocation));
                        });
                  } else {
                    Get.toNamed(RouteHelper.getPickMapRoute(
                      route ??
                          (fromSignUp
                              ? RouteHelper.signUp
                              : RouteHelper.accessLocation),
                      route != null,
                    ));
                  }
                },
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        right: Dimensions.paddingSizeExtraSmall),
                    child: Icon(Icons.map_outlined,
                        color: Theme.of(context).primaryColor),
                  ),
                  Text('enter_location_manually'.tr,
                      textAlign: TextAlign.center,
                      style: robotoBold.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontSize: Dimensions.fontSizeLarge,
                      )),
                ]),
              ),
            ])));
  }
}

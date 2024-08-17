import 'dart:async';
import 'dart:io';
import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:sannip/common/widgets/custom_snackbar.dart';
import 'package:sannip/features/cart/controllers/cart_controller.dart';
import 'package:sannip/features/coupon/controllers/coupon_controller.dart';
import 'package:sannip/features/dashboard/widgets/store_registration_success_bottom_sheet.dart';
import 'package:sannip/features/home/controllers/home_controller.dart';
import 'package:sannip/features/location/controllers/location_controller.dart';
import 'package:sannip/features/splash/controllers/splash_controller.dart';
import 'package:sannip/features/order/controllers/order_controller.dart';
import 'package:sannip/features/order/domain/models/order_model.dart';
import 'package:sannip/features/address/screens/address_screen.dart';
import 'package:sannip/features/auth/controllers/auth_controller.dart';
import 'package:sannip/features/dashboard/widgets/bottom_nav_item_widget.dart';
import 'package:sannip/features/parcel/controllers/parcel_controller.dart';
import 'package:sannip/helper/auth_helper.dart';
import 'package:sannip/helper/responsive_helper.dart';
import 'package:sannip/helper/route_helper.dart';
import 'package:sannip/util/dimensions.dart';
import 'package:sannip/util/images.dart';
import 'package:sannip/common/widgets/cart_widget.dart';
import 'package:sannip/common/widgets/custom_dialog.dart';
import 'package:sannip/features/checkout/widgets/congratulation_dialogue.dart';
import 'package:sannip/features/dashboard/widgets/address_bottom_sheet_widget.dart';
import 'package:sannip/features/dashboard/widgets/parcel_bottom_sheet_widget.dart';
import 'package:sannip/features/favourite/screens/favourite_screen.dart';
import 'package:sannip/features/home/screens/home_screen.dart';
import 'package:sannip/features/menu/screens/menu_screen.dart';
import 'package:sannip/features/order/screens/order_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/running_order_view_widget.dart';

class DashboardScreen extends StatefulWidget {
  final int pageIndex;
  final bool fromSplash;
  const DashboardScreen(
      {super.key, required this.pageIndex, this.fromSplash = false});

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  PageController? _pageController;
  int _pageIndex = 0;
  late List<Widget> _screens;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
  bool _canExit = GetPlatform.isWeb ? true : false;

  GlobalKey<ExpandableBottomSheetState> key = GlobalKey();

  late bool _isLogin;
  bool active = false;
  bool onlyOnce = true;

  @override
  void initState() {
    super.initState();

    _isLogin = AuthHelper.isLoggedIn();

    _showRegistrationSuccessBottomSheet();

    if (_isLogin) {
      if (Get.find<SplashController>().configModel!.loyaltyPointStatus == 1 &&
          Get.find<AuthController>().getEarningPint().isNotEmpty &&
          !ResponsiveHelper.isDesktop(Get.context)) {
        Future.delayed(const Duration(seconds: 1),
            () => showAnimatedDialog(context, const CongratulationDialogue()));
      }
      suggestAddressBottomSheet();
      Get.find<OrderController>().getRunningOrders(1, fromDashboard: true);
    }

    _pageIndex = widget.pageIndex;

    _pageController = PageController(initialPage: widget.pageIndex);

    _screens = [
      const HomeScreen(),
      const FavouriteScreen(),
      const SizedBox(),
      const OrderScreen(),
      const MenuScreen()
    ];

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {});
    });
  }

  _showRegistrationSuccessBottomSheet() {
    bool canShowBottomSheet =
        Get.find<HomeController>().getRegistrationSuccessfulSharedPref();
    if (canShowBottomSheet) {
      Future.delayed(const Duration(seconds: 1), () {
        ResponsiveHelper.isDesktop(context)
            ? Get.dialog(
                    const Dialog(child: StoreRegistrationSuccessBottomSheet()))
                .then((value) {
                Get.find<HomeController>()
                    .saveRegistrationSuccessfulSharedPref(false);
                Get.find<HomeController>()
                    .saveIsStoreRegistrationSharedPref(false);
                setState(() {});
              })
            : showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (con) => const StoreRegistrationSuccessBottomSheet(),
              ).then((value) {
                Get.find<HomeController>()
                    .saveRegistrationSuccessfulSharedPref(false);
                Get.find<HomeController>()
                    .saveIsStoreRegistrationSharedPref(false);
                setState(() {});
              });
      });
    }
  }

  Future<void> suggestAddressBottomSheet() async {
    active = await Get.find<LocationController>().checkLocationActive();
    if (widget.fromSplash &&
        Get.find<LocationController>().showLocationSuggestion &&
        active) {
      Future.delayed(const Duration(seconds: 1), () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (con) => const AddressBottomSheetWidget(),
        ).then((value) {
          Get.find<LocationController>().hideSuggestedLocation();
          setState(() {});
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    bool keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    return GetBuilder<SplashController>(builder: (splashController) {
      ///REMOVE BELOW CODE ONCE MULTIPLE MODULES ARE ACTIVATED
      ///COMMENT THiS FOR MULTIPLE MODULES
      /*if (splashController.moduleList?.isNotEmpty ?? false) {
        if (onlyOnce) {
          onlyOnce = false;
          for (ModuleModel k in splashController.moduleList ?? []) {
            if (k.moduleName?.toLowerCase() == 'food') {
              splashController.switchModule(0, true);
            }
          }
        }
      }*/
      return PopScope(
        canPop: false,
        onPopInvoked: (value) async {
          if (_pageIndex != 0) {
            _setPage(0);
          } else {
            if (!ResponsiveHelper.isDesktop(context) &&
                Get.find<SplashController>().module != null &&
                Get.find<SplashController>().configModel!.module == null) {
              Get.find<SplashController>().setModule(null);
            } else {
              if (_canExit) {
                if (GetPlatform.isAndroid) {
                  SystemNavigator.pop();
                } else if (GetPlatform.isIOS) {
                  exit(0);
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
            }
          }
        },
        child: GetBuilder<OrderController>(builder: (orderController) {
          List<OrderModel> runningOrder =
              orderController.runningOrderModel != null
                  ? orderController.runningOrderModel!.orders!
                  : [];

          List<OrderModel> reversOrder = List.from(runningOrder.reversed);

          return Scaffold(
            key: _scaffoldKey,
            body: Stack(children: [
              PageView.builder(
                controller: _pageController,
                itemCount: _screens.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return _screens[index];
                },
              ),
              ResponsiveHelper.isDesktop(context) || keyboardVisible
                  ? const SizedBox()
                  : Align(
                      alignment: Alignment.bottomCenter,
                      child: GetBuilder<SplashController>(
                          builder: (splashController) {
                        bool isParcel = splashController.module != null &&
                            splashController
                                .configModel!.moduleConfig!.module!.isParcel!;

                        _screens = [
                          const HomeScreen(),
                          isParcel
                              ? const AddressScreen(fromDashboard: true)
                              : const FavouriteScreen(),
                          const SizedBox(),
                          const OrderScreen(),
                          const MenuScreen()
                        ];
                        return Container(
                          width: size.width,
                          height: GetPlatform.isIOS ? 80 : 65,
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(Dimensions.radiusLarge)),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 5,
                                  spreadRadius: 1)
                            ],
                          ),
                          child: Stack(
                            children: [
                              Center(
                                heightFactor: 0.6,
                                child: ResponsiveHelper.isDesktop(context)
                                    ? null
                                    : (widget.fromSplash &&
                                            Get.find<LocationController>()
                                                .showLocationSuggestion &&
                                            active)
                                        ? null
                                        /*: (orderController.showBottomSheet &&
                                                orderController
                                                        .runningOrderModel !=
                                                    null &&
                                                orderController
                                                    .runningOrderModel!
                                                    .orders!
                                                    .isNotEmpty &&
                                                _isLogin)
                                            ? const SizedBox()*/
                                        : Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Theme.of(context)
                                                      .cardColor,
                                                  width: 5),
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              boxShadow: const [
                                                BoxShadow(
                                                    color: Colors.black12,
                                                    blurRadius: 5,
                                                    spreadRadius: 1)
                                              ],
                                            ),
                                            child: GetBuilder<CartController>(
                                                builder: (cartController) {
                                              return FloatingActionButton(
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .primaryColor,
                                                /* onPressed: () {
                                                        if (isParcel) {
                                                          showModalBottomSheet(
                                                            context: context,
                                                            isScrollControlled:
                                                                true,
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            builder: (con) =>
                                                                ParcelBottomSheetWidget(
                                                                    parcelCategoryList:
                                                                        Get.find<ParcelController>()
                                                                            .parcelCategoryList),
                                                          );
                                                        } else {
                                                          Get.toNamed(RouteHelper
                                                              .getCartRoute());
                                                        }
                                                      },*/
                                                onPressed: () {
                                                  if (orderController
                                                      .showBottomSheet) {
                                                    orderController
                                                        .showRunningOrders();
                                                  }
                                                  if (isParcel) {
                                                    showModalBottomSheet(
                                                      context: context,
                                                      isScrollControlled: true,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      builder: (con) =>
                                                          ParcelBottomSheetWidget(
                                                              parcelCategoryList:
                                                                  Get.find<
                                                                          ParcelController>()
                                                                      .parcelCategoryList),
                                                    );
                                                  } else {
                                                    if (!cartController
                                                            .cartList
                                                            .first
                                                            .item!
                                                            .scheduleOrder! &&
                                                        cartController
                                                            .availableList
                                                            .contains(false)) {
                                                      showCustomSnackBar(
                                                          'one_or_more_product_unavailable'
                                                              .tr);
                                                    } /*else if(AuthHelper.isGuestLoggedIn() && !Get.find<SplashController>().configModel!.guestCheckoutStatus!) {
                    showCustomSnackBar('currently_your_zone_have_no_permission_to_place_any_order'.tr);
                  }*/
                                                    else {
                                                      if (Get.find<
                                                                  SplashController>()
                                                              .module ==
                                                          null) {
                                                        int i = 0;
                                                        for (i = 0;
                                                            i <
                                                                Get.find<
                                                                        SplashController>()
                                                                    .moduleList!
                                                                    .length;
                                                            i++) {
                                                          if (cartController
                                                                  .cartList[0]
                                                                  .item!
                                                                  .moduleId ==
                                                              Get.find<
                                                                      SplashController>()
                                                                  .moduleList![
                                                                      i]
                                                                  .id) {
                                                            break;
                                                          }
                                                        }
                                                        Get.find<
                                                                SplashController>()
                                                            .setModule(Get.find<
                                                                    SplashController>()
                                                                .moduleList![i]);
                                                        HomeScreen.loadData(
                                                            true);
                                                      }
                                                      Get.find<
                                                              CouponController>()
                                                          .removeCouponData(
                                                              false);

                                                      Get.toNamed(RouteHelper
                                                          .getCheckoutRoute(
                                                              'cart'));
                                                    }
                                                  }
                                                },
                                                elevation: 0,
                                                child: isParcel
                                                    ? Icon(CupertinoIcons.add,
                                                        size: 34,
                                                        color: Theme.of(context)
                                                            .cardColor)
                                                    : CartWidget(
                                                        color: Theme.of(context)
                                                            .cardColor,
                                                        size: 22),
                                              );
                                            }),
                                          ),
                              ),
                              ResponsiveHelper.isDesktop(context)
                                  ? const SizedBox()
                                  : (widget.fromSplash &&
                                          Get.find<LocationController>()
                                              .showLocationSuggestion &&
                                          active)
                                      ? const SizedBox()
                                      /*: (orderController.showBottomSheet &&
                                              orderController
                                                      .runningOrderModel !=
                                                  null &&
                                              orderController.runningOrderModel!
                                                  .orders!.isNotEmpty &&
                                              _isLogin)
                                          ? const SizedBox()*/
                                      : Center(
                                          child: SizedBox(
                                            width: size.width,
                                            height: 80,
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  BottomNavItemWidget(
                                                    title: 'home'.tr,
                                                    selectedIcon:
                                                        Images.bottomHomeIcon,
                                                    unSelectedIcon:
                                                        Images.bottomHomeIcon,
                                                    isSelected: _pageIndex == 0,
                                                    onTap: () {
                                                      if (orderController
                                                          .showBottomSheet) {
                                                        orderController
                                                            .showRunningOrders();
                                                      }
                                                      _setPage(0);
                                                    },
                                                  ),
                                                  BottomNavItemWidget(
                                                    title: isParcel
                                                        ? 'address'.tr
                                                        : 'favourite'.tr,
                                                    selectedIcon: isParcel
                                                        ? Images.addressSelect
                                                        : Images
                                                            .bottomFavouriteIcon,
                                                    unSelectedIcon: isParcel
                                                        ? Images.addressUnselect
                                                        : Images
                                                            .bottomFavouriteIcon,
                                                    isSelected: _pageIndex == 1,
                                                    onTap: () {
                                                      if (orderController
                                                          .showBottomSheet) {
                                                        orderController
                                                            .showRunningOrders();
                                                      }
                                                      _setPage(1);
                                                    },
                                                  ),
                                                  Container(
                                                      width: size.width * 0.2),
                                                  BottomNavItemWidget(
                                                    title: 'orders'.tr,
                                                    selectedIcon:
                                                        Images.bottomOrderIcon,
                                                    unSelectedIcon:
                                                        Images.bottomOrderIcon,
                                                    isSelected: _pageIndex == 3,
                                                    onTap: () {
                                                      if (orderController
                                                          .showBottomSheet) {
                                                        orderController
                                                            .showRunningOrders();
                                                      }
                                                      _setPage(3);
                                                    },
                                                  ),
                                                  BottomNavItemWidget(
                                                    title: 'account'.tr,
                                                    selectedIcon: Images
                                                        .bottomAccountSelectedIcon,
                                                    unSelectedIcon: Images
                                                        .bottomAccountUnselectedIcon,
                                                    isSelected: _pageIndex == 4,
                                                    onTap: () {
                                                      if (orderController
                                                          .showBottomSheet) {
                                                        orderController
                                                            .showRunningOrders();
                                                      }
                                                      _setPage(4);
                                                    },
                                                  ),
                                                ]),
                                          ),
                                        ),
                            ],
                          ),
                        );
                      }),
                    ),
              (widget.fromSplash &&
                      Get.find<LocationController>().showLocationSuggestion &&
                      active &&
                      !ResponsiveHelper.isDesktop(context))
                  ? const SizedBox()
                  : (ResponsiveHelper.isDesktop(context) ||
                          !_isLogin ||
                          orderController.runningOrderModel == null ||
                          orderController.runningOrderModel!.orders!.isEmpty ||
                          !orderController.showBottomSheet)
                      ? const SizedBox()
                      : Positioned(
                          bottom: GetPlatform.isIOS ? 80 : 65,
                          child: Dismissible(
                            key: UniqueKey(),
                            onDismissed: (direction) {
                              if (orderController.showBottomSheet) {
                                orderController.showRunningOrders();
                              }
                            },
                            child: RunningOrderViewWidget(
                                reversOrder: reversOrder,
                                onOrderTap: () {
                                  _setPage(3);
                                  if (orderController.showBottomSheet) {
                                    orderController.showRunningOrders();
                                  }
                                }),
                          ))
            ]),
            /* body: ExpandableBottomSheet(
              background: Stack(children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: _screens.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return _screens[index];
                  },
                ),
                ResponsiveHelper.isDesktop(context) || keyboardVisible
                    ? const SizedBox()
                    : Align(
                        alignment: Alignment.bottomCenter,
                        child: GetBuilder<SplashController>(
                            builder: (splashController) {
                          bool isParcel = splashController.module != null &&
                              splashController
                                  .configModel!.moduleConfig!.module!.isParcel!;

                          _screens = [
                            const HomeScreen(),
                            isParcel
                                ? const AddressScreen(fromDashboard: true)
                                : const FavouriteScreen(),
                            const SizedBox(),
                            const OrderScreen(),
                            const MenuScreen()
                          ];
                          return Container(
                            width: size.width,
                            height: GetPlatform.isIOS ? 80 : 65,
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(Dimensions.radiusLarge)),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 5,
                                    spreadRadius: 1)
                              ],
                            ),
                            child: Stack(
                              children: [
                                Center(
                                  heightFactor: 0.6,
                                  child: ResponsiveHelper.isDesktop(context)
                                      ? null
                                      : (widget.fromSplash &&
                                              Get.find<LocationController>()
                                                  .showLocationSuggestion &&
                                              active)
                                          ? null
                                          : (orderController.showBottomSheet &&
                                                  orderController
                                                          .runningOrderModel !=
                                                      null &&
                                                  orderController
                                                      .runningOrderModel!
                                                      .orders!
                                                      .isNotEmpty &&
                                                  _isLogin)
                                              ? const SizedBox()
                                              : Container(
                                                  width: 60,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Theme.of(context)
                                                            .cardColor,
                                                        width: 5),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    boxShadow: const [
                                                      BoxShadow(
                                                          color: Colors.black12,
                                                          blurRadius: 5,
                                                          spreadRadius: 1)
                                                    ],
                                                  ),
                                                  child: GetBuilder<
                                                          CartController>(
                                                      builder:
                                                          (cartController) {
                                                    return FloatingActionButton(
                                                      backgroundColor:
                                                          Theme.of(context)
                                                              .primaryColor,
                                                      */ /* onPressed: () {
                                                        if (isParcel) {
                                                          showModalBottomSheet(
                                                            context: context,
                                                            isScrollControlled:
                                                                true,
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            builder: (con) =>
                                                                ParcelBottomSheetWidget(
                                                                    parcelCategoryList:
                                                                        Get.find<ParcelController>()
                                                                            .parcelCategoryList),
                                                          );
                                                        } else {
                                                          Get.toNamed(RouteHelper
                                                              .getCartRoute());
                                                        }
                                                      },*/ /*
                                                      onPressed: () {
                                                        if (isParcel) {
                                                          showModalBottomSheet(
                                                            context: context,
                                                            isScrollControlled:
                                                                true,
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            builder: (con) =>
                                                                ParcelBottomSheetWidget(
                                                                    parcelCategoryList:
                                                                        Get.find<ParcelController>()
                                                                            .parcelCategoryList),
                                                          );
                                                        } else {
                                                          if (!cartController
                                                                  .cartList
                                                                  .first
                                                                  .item!
                                                                  .scheduleOrder! &&
                                                              cartController
                                                                  .availableList
                                                                  .contains(
                                                                      false)) {
                                                            showCustomSnackBar(
                                                                'one_or_more_product_unavailable'
                                                                    .tr);
                                                          } */ /*else if(AuthHelper.isGuestLoggedIn() && !Get.find<SplashController>().configModel!.guestCheckoutStatus!) {
                    showCustomSnackBar('currently_your_zone_have_no_permission_to_place_any_order'.tr);
                  }*/ /*
                                                          else {
                                                            if (Get.find<
                                                                        SplashController>()
                                                                    .module ==
                                                                null) {
                                                              int i = 0;
                                                              for (i = 0;
                                                                  i <
                                                                      Get.find<
                                                                              SplashController>()
                                                                          .moduleList!
                                                                          .length;
                                                                  i++) {
                                                                if (cartController
                                                                        .cartList[
                                                                            0]
                                                                        .item!
                                                                        .moduleId ==
                                                                    Get.find<
                                                                            SplashController>()
                                                                        .moduleList![
                                                                            i]
                                                                        .id) {
                                                                  break;
                                                                }
                                                              }
                                                              Get.find<
                                                                      SplashController>()
                                                                  .setModule(Get
                                                                          .find<
                                                                              SplashController>()
                                                                      .moduleList![i]);
                                                              HomeScreen
                                                                  .loadData(
                                                                      true);
                                                            }
                                                            Get.find<
                                                                    CouponController>()
                                                                .removeCouponData(
                                                                    false);

                                                            Get.toNamed(RouteHelper
                                                                .getCheckoutRoute(
                                                                    'cart'));
                                                          }
                                                        }
                                                      },
                                                      elevation: 0,
                                                      child: isParcel
                                                          ? Icon(
                                                              CupertinoIcons
                                                                  .add,
                                                              size: 34,
                                                              color: Theme.of(
                                                                      context)
                                                                  .cardColor)
                                                          : CartWidget(
                                                              color: Theme.of(
                                                                      context)
                                                                  .cardColor,
                                                              size: 22),
                                                    );
                                                  }),
                                                ),
                                ),
                                ResponsiveHelper.isDesktop(context)
                                    ? const SizedBox()
                                    : (widget.fromSplash &&
                                            Get.find<LocationController>()
                                                .showLocationSuggestion &&
                                            active)
                                        ? const SizedBox()
                                        : (orderController.showBottomSheet &&
                                                orderController
                                                        .runningOrderModel !=
                                                    null &&
                                                orderController
                                                    .runningOrderModel!
                                                    .orders!
                                                    .isNotEmpty &&
                                                _isLogin)
                                            ? const SizedBox()
                                            : Center(
                                                child: SizedBox(
                                                  width: size.width,
                                                  height: 80,
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        BottomNavItemWidget(
                                                          title: 'home'.tr,
                                                          selectedIcon: Images
                                                              .bottomHomeIcon,
                                                          unSelectedIcon: Images
                                                              .bottomHomeIcon,
                                                          isSelected:
                                                              _pageIndex == 0,
                                                          onTap: () =>
                                                              _setPage(0),
                                                        ),
                                                        BottomNavItemWidget(
                                                          title: isParcel
                                                              ? 'address'.tr
                                                              : 'favourite'.tr,
                                                          selectedIcon: isParcel
                                                              ? Images
                                                                  .addressSelect
                                                              : Images
                                                                  .bottomFavouriteIcon,
                                                          unSelectedIcon: isParcel
                                                              ? Images
                                                                  .addressUnselect
                                                              : Images
                                                                  .bottomFavouriteIcon,
                                                          isSelected:
                                                              _pageIndex == 1,
                                                          onTap: () =>
                                                              _setPage(1),
                                                        ),
                                                        Container(
                                                            width: size.width *
                                                                0.2),
                                                        BottomNavItemWidget(
                                                          title: 'orders'.tr,
                                                          selectedIcon: Images
                                                              .bottomOrderIcon,
                                                          unSelectedIcon: Images
                                                              .bottomOrderIcon,
                                                          isSelected:
                                                              _pageIndex == 3,
                                                          onTap: () =>
                                                              _setPage(3),
                                                        ),
                                                        BottomNavItemWidget(
                                                          title: 'account'.tr,
                                                          selectedIcon: Images
                                                              .bottomAccountSelectedIcon,
                                                          unSelectedIcon: Images
                                                              .bottomAccountUnselectedIcon,
                                                          isSelected:
                                                              _pageIndex == 4,
                                                          onTap: () =>
                                                              _setPage(4),
                                                        ),
                                                      ]),
                                                ),
                                              ),
                              ],
                            ),
                          );
                        }),
                      ),
              ]),
              persistentContentHeight: (widget.fromSplash &&
                      Get.find<LocationController>().showLocationSuggestion &&
                      active)
                  ? 0
                  : 100,
              onIsContractedCallback: () {
                if (!orderController.showOneOrder) {
                  orderController.showOrders();
                }
              },
              onIsExtendedCallback: () {
                if (orderController.showOneOrder) {
                  orderController.showOrders();
                }
              },
              enableToggle: true,
              expandableContent: (widget.fromSplash &&
                      Get.find<LocationController>().showLocationSuggestion &&
                      active &&
                      !ResponsiveHelper.isDesktop(context))
                  ? const SizedBox()
                  : (ResponsiveHelper.isDesktop(context) ||
                          !_isLogin ||
                          orderController.runningOrderModel == null ||
                          orderController.runningOrderModel!.orders!.isEmpty ||
                          !orderController.showBottomSheet)
                      ? const SizedBox()
                      : Dismissible(
                          key: UniqueKey(),
                          onDismissed: (direction) {
                            if (orderController.showBottomSheet) {
                              orderController.showRunningOrders();
                            }
                          },
                          child: RunningOrderViewWidget(
                              reversOrder: reversOrder,
                              onOrderTap: () {
                                _setPage(3);
                                if (orderController.showBottomSheet) {
                                  orderController.showRunningOrders();
                                }
                              }),
                        ),
            ),*/
          );
        }),
      );
    });
  }

  void _setPage(int pageIndex) {
    setState(() {
      _pageController!.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
    });
  }

  Widget trackView(BuildContext context, {required bool status}) {
    return Container(
        height: 3,
        decoration: BoxDecoration(
            color: status
                ? Theme.of(context).primaryColor
                : Theme.of(context).disabledColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault)));
  }
}

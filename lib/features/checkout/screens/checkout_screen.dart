import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/foundation.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:sannip/common/widgets/address_widget.dart';
import 'package:sannip/common/widgets/item_widget.dart';
import 'package:sannip/common/widgets/no_data_screen.dart';
import 'package:sannip/common/widgets/web_constrained_box.dart';
import 'package:sannip/common/widgets/web_page_title_widget.dart';
import 'package:sannip/features/address/controllers/address_controller.dart';
import 'package:sannip/features/cart/controllers/cart_controller.dart';
import 'package:sannip/features/cart/screens/cart_screen.dart';
import 'package:sannip/features/cart/widgets/cart_item_widget.dart';
import 'package:sannip/features/cart/widgets/delivery_option_button_widget.dart';
import 'package:sannip/features/cart/widgets/extra_packaging_widget.dart';
import 'package:sannip/features/cart/widgets/not_available_bottom_sheet_widget.dart';
import 'package:sannip/features/cart/widgets/web_cart_items_widget.dart';
import 'package:sannip/features/cart/widgets/web_suggested_item_view_widget.dart';
import 'package:sannip/features/checkout/widgets/delivery_section.dart';
import 'package:sannip/features/checkout/widgets/note_prescription_section.dart';
import 'package:sannip/features/coupon/controllers/coupon_controller.dart';
import 'package:sannip/features/home/controllers/home_controller.dart';
import 'package:sannip/features/item/domain/models/item_model.dart';
import 'package:sannip/features/splash/controllers/splash_controller.dart';
import 'package:sannip/features/profile/controllers/profile_controller.dart';
import 'package:sannip/features/checkout/domain/models/place_order_body_model.dart';
import 'package:sannip/features/address/domain/models/address_model.dart';
import 'package:sannip/features/cart/domain/models/cart_model.dart';
import 'package:sannip/common/models/config_model.dart';
import 'package:sannip/features/location/domain/models/zone_response_model.dart';
import 'package:sannip/features/checkout/controllers/checkout_controller.dart';
import 'package:sannip/features/store/controllers/store_controller.dart';
import 'package:sannip/features/store/domain/models/store_model.dart';
import 'package:sannip/features/store/screens/store_screen.dart';
import 'package:sannip/helper/address_helper.dart';
import 'package:sannip/helper/auth_helper.dart';
import 'package:sannip/helper/date_converter.dart';
import 'package:sannip/helper/price_converter.dart';
import 'package:sannip/helper/responsive_helper.dart';
import 'package:sannip/helper/route_helper.dart';
import 'package:sannip/util/app_constants.dart';
import 'package:sannip/util/dimensions.dart';
import 'package:sannip/util/images.dart';
import 'package:sannip/util/styles.dart';
import 'package:sannip/common/widgets/custom_app_bar.dart';
import 'package:sannip/common/widgets/custom_button.dart';
import 'package:sannip/common/widgets/custom_dropdown.dart';
import 'package:sannip/common/widgets/custom_snackbar.dart';
import 'package:sannip/common/widgets/footer_view.dart';
import 'package:sannip/common/widgets/menu_drawer.dart';
import 'package:sannip/common/widgets/not_logged_in_screen.dart';
import 'package:sannip/features/checkout/widgets/checkout_screen_shimmer_view.dart';
import 'package:sannip/features/checkout/widgets/payment_method_bottom_sheet.dart';
import 'package:get/get.dart';
import 'package:sannip/features/checkout/widgets/bottom_section.dart';
import 'package:sannip/features/checkout/widgets/top_section.dart';
import 'package:flutter/material.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartModel?>? cartList;
  final bool fromCart;
  final int? storeId;
  const CheckoutScreen(
      {super.key,
      required this.fromCart,
      required this.cartList,
      required this.storeId});

  @override
  CheckoutScreenState createState() => CheckoutScreenState();
}

class CheckoutScreenState extends State<CheckoutScreen> {
  final ScrollController _scrollController = ScrollController();
  final JustTheController tooltipController1 = JustTheController();
  final JustTheController tooltipController2 = JustTheController();
  final JustTheController tooltipController3 = JustTheController();

  double? _taxPercent = 0;
  bool? _isCashOnDeliveryActive = false;
  bool? _isDigitalPaymentActive = false;
  bool _isOfflinePaymentActive = false;
  List<CartModel?>? _cartList;
  bool _isWalletActive = false;

  List<AddressModel> address = [];
  bool canCheckSmall = false;
  double? _payableAmount = 0;

  final TextEditingController guestContactPersonNameController =
      TextEditingController();
  final TextEditingController guestContactPersonNumberController =
      TextEditingController();
  final TextEditingController guestEmailController = TextEditingController();
  final FocusNode guestNumberNode = FocusNode();
  final FocusNode guestEmailNode = FocusNode();
  GlobalKey<ExpandableBottomSheetState> key = GlobalKey();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    initCall();
    // Future.delayed(const Duration(seconds: 3), () {
    //   _showCashBackMessage = true;
    // });
  }

  Future<void> initCall() async {
    bool isLoggedIn = AuthHelper.isLoggedIn();
    Get.find<CheckoutController>().setGuestAddress(null, isUpdate: false);
    Get.find<CheckoutController>().streetNumberController.text =
        AddressHelper.getUserAddressFromSharedPref()!.streetNumber ?? '';
    Get.find<CheckoutController>().houseController.text =
        AddressHelper.getUserAddressFromSharedPref()!.house ?? '';
    Get.find<CheckoutController>().floorController.text =
        AddressHelper.getUserAddressFromSharedPref()!.floor ?? '';
    Get.find<CheckoutController>().couponController.text = '';

    Get.find<CheckoutController>().getDmTipMostTapped();
    Get.find<CheckoutController>()
        .setPreferenceTimeForView('', isUpdate: false);

    Get.find<CheckoutController>().getOfflineMethodList();

    if (Get.find<CheckoutController>().isPartialPay) {
      Get.find<CheckoutController>().changePartialPayment(isUpdate: false);
    }

    if (isLoggedIn) {
      if (Get.find<ProfileController>().userInfoModel == null) {
        Get.find<ProfileController>().getUserInfo();
      }

      Get.find<CouponController>().getCouponList();

      if (Get.find<AddressController>().addressList == null) {
        Get.find<AddressController>().getAddressList();
      }
    }

    if (widget.storeId == null) {
      _cartList = [];
      if (GetPlatform.isWeb) {
        await Get.find<CartController>().getCartDataOnline();
      }
      widget.fromCart
          ? _cartList!.addAll(Get.find<CartController>().cartList)
          : _cartList!.addAll(widget.cartList!);
      if (_cartList != null && _cartList!.isNotEmpty) {
        Get.find<CheckoutController>()
            .initCheckoutData(_cartList![0]!.item!.storeId);
      }
    }
    if (widget.storeId != null) {
      Get.find<CheckoutController>().initCheckoutData(widget.storeId);
      Get.find<CouponController>().removeCouponData(false);
    }
    Get.find<CheckoutController>()
        .pickPrescriptionImage(isRemove: true, isCamera: false);
    _isWalletActive =
        Get.find<SplashController>().configModel!.customerWalletStatus == 1;
    Get.find<CheckoutController>().updateTips(
      Get.find<CheckoutController>().getSharedPrefDmTipIndex().isNotEmpty
          ? int.parse(Get.find<CheckoutController>().getSharedPrefDmTipIndex())
          : 0,
      notify: false,
    );
    Get.find<CheckoutController>().tipController.text =
        Get.find<CheckoutController>().selectedTips != -1
            ? AppConstants
                    .tipsWithEmoji[Get.find<CheckoutController>().selectedTips]
                ["amount"]
            : '';

    /// Cart screen changes
    if (Get.find<CartController>().cartList.isEmpty) {
      await Get.find<CartController>().getCartDataOnline();
    }
    if (Get.find<CartController>().cartList.isNotEmpty) {
      if (kDebugMode) {
        print(
            '----cart item : ${Get.find<CartController>().cartList[0].toJson()}');
      }
      if (Get.find<CartController>().addCutlery) {
        Get.find<CartController>().updateCutlery(willUpdate: false);
      }
      if (Get.find<CartController>().needExtraPackage) {
        Get.find<CartController>().toggleExtraPackage(willUpdate: false);
      }
      print('====here ====1 calling====');
      Get.find<CartController>().setAvailableIndex(-1, willUpdate: false);
      Get.find<StoreController>().getCartStoreSuggestedItemList(
          Get.find<CartController>().cartList[0].item!.storeId);
      Get.find<StoreController>().getStoreDetails(
          Store(
              id: Get.find<CartController>().cartList[0].item!.storeId,
              name: null),
          false,
          fromCart: true);
      Get.find<CartController>().calculationCart();
      showReferAndEarnSnackBar();
    }
  }

  @override
  void dispose() {
    super.dispose();

    guestContactPersonNameController.dispose();
    guestContactPersonNumberController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Module? module =
        Get.find<SplashController>().configModel!.moduleConfig!.module;
    bool guestCheckoutPermission = AuthHelper.isGuestLoggedIn() &&
        Get.find<SplashController>().configModel!.guestCheckoutStatus!;
    bool isLoggedIn = AuthHelper.isLoggedIn();

    return Scaffold(
      appBar: CustomAppBar(title: 'checkout'.tr),
      endDrawer: const MenuDrawer(),
      endDrawerEnableOpenDragGesture: false,
      body: guestCheckoutPermission || AuthHelper.isLoggedIn()
          ? GetBuilder<CheckoutController>(builder: (checkoutController) {
              List<DropdownItem<int>> addressList = _getDropdownAddressList(
                  context: context,
                  addressList: Get.find<AddressController>().addressList,
                  store: checkoutController.store);
              address = _getAddressList(
                  addressList: Get.find<AddressController>().addressList,
                  store: checkoutController.store);

              bool todayClosed = false;
              bool tomorrowClosed = false;
              Pivot? moduleData =
                  _getModuleData(store: checkoutController.store);
              _isCashOnDeliveryActive =
                  _checkCODActive(store: checkoutController.store);
              _isDigitalPaymentActive =
                  _checkDigitalPaymentActive(store: checkoutController.store);
              _isOfflinePaymentActive = Get.find<SplashController>()
                      .configModel!
                      .offlinePaymentStatus! &&
                  _checkZoneOfflinePaymentOnOff(
                      addressModel:
                          AddressHelper.getUserAddressFromSharedPref());
              if (checkoutController.store != null) {
                todayClosed = checkoutController.isStoreClosed(
                    true,
                    checkoutController.store!.active!,
                    checkoutController.store!.schedules);
                tomorrowClosed = checkoutController.isStoreClosed(
                    false,
                    checkoutController.store!.active!,
                    checkoutController.store!.schedules);
                _taxPercent = checkoutController.store!.tax;
              }
              return GetBuilder<CouponController>(builder: (couponController) {
                double? maxCodOrderAmount;

                if (moduleData != null) {
                  maxCodOrderAmount = moduleData.maximumCodOrderAmount;
                }
                double price = _calculatePrice(
                    store: checkoutController.store, cartList: _cartList);
                double addOns = _calculateAddonsPrice(
                    store: checkoutController.store, cartList: _cartList);
                double variations = _calculateVariationPrice(
                    store: checkoutController.store,
                    cartList: _cartList,
                    calculateWithoutDiscount: true);
                double? discount = _calculateDiscount(
                  store: checkoutController.store,
                  cartList: _cartList,
                  price: price,
                  addOns: addOns,
                );
                double couponDiscount =
                    PriceConverter.toFixed(couponController.discount!);
                bool taxIncluded =
                    Get.find<SplashController>().configModel!.taxIncluded == 1;

                double subTotal = _calculateSubTotal(
                    price: price,
                    addOns: addOns,
                    variations: variations,
                    cartList: _cartList);

                double referralDiscount = _calculateReferralDiscount(
                    subTotal, discount, couponDiscount);

                double orderAmount = _calculateOrderAmount(
                  price: price,
                  variations: variations,
                  discount: discount,
                  addOns: addOns,
                  couponDiscount: couponDiscount,
                  cartList: _cartList,
                  referralDiscount: referralDiscount,
                );

                double tax = _calculateTax(
                  taxIncluded: taxIncluded,
                  orderAmount: orderAmount,
                  taxPercent: _taxPercent,
                );
                double additionalCharge = Get.find<SplashController>()
                        .configModel!
                        .additionalChargeStatus!
                    ? Get.find<SplashController>().configModel!.additionCharge!
                    : 0;
                double originalCharge = _calculateOriginalDeliveryCharge(
                  store: checkoutController.store,
                  address: AddressHelper.getUserAddressFromSharedPref()!,
                  distance: checkoutController.distance,
                  extraCharge: checkoutController.extraCharge,
                );
                double deliveryCharge = _calculateDeliveryCharge(
                  store: checkoutController.store,
                  address: AddressHelper.getUserAddressFromSharedPref()!,
                  distance: checkoutController.distance,
                  extraCharge: checkoutController.extraCharge,
                  orderType: checkoutController.orderType!,
                  orderAmount: orderAmount,
                );

                double extraPackagingCharge =
                    _calculateExtraPackagingCharge(checkoutController);

                double total = _calculateTotal(
                  subTotal: subTotal,
                  deliveryCharge: deliveryCharge,
                  discount: discount,
                  couponDiscount: couponDiscount,
                  taxIncluded: taxIncluded,
                  tax: tax,
                  orderType: checkoutController.orderType!,
                  tips: checkoutController.tips,
                  additionalCharge: additionalCharge,
                  extraPackagingCharge: extraPackagingCharge,
                );

                bool isPrescriptionRequired = _checkPrescriptionRequired();

                total = total - referralDiscount;

                if (widget.storeId != null) {
                  checkoutController.setPaymentMethod(0, isUpdate: false);
                }
                checkoutController.setTotalAmount(total -
                    (checkoutController.isPartialPay
                        ? Get.find<ProfileController>()
                            .userInfoModel!
                            .walletBalance!
                        : 0));

                if (_payableAmount != checkoutController.viewTotalPrice &&
                    checkoutController.distance != null &&
                    isLoggedIn) {
                  _payableAmount = checkoutController.viewTotalPrice;
                  showCashBackSnackBar();
                }

                return (checkoutController.distance != null &&
                        checkoutController.store != null)
                    ? Column(
                        children: [
                          ResponsiveHelper.isDesktop(context)
                              ? Container(
                                  height: 64,
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.10),
                                  child: Center(
                                      child: Text('checkout'.tr,
                                          style: robotoMedium)),
                                )
                              : const SizedBox(),
                          Expanded(
                              child: SingleChildScrollView(
                            controller: _scrollController,
                            physics: const BouncingScrollPhysics(),
                            child: FooterView(
                                child: SizedBox(
                              width: Dimensions.webMaxWidth,
                              child: ResponsiveHelper.isDesktop(context)
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          top: Dimensions.paddingSizeLarge),
                                      child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                                flex: 6,
                                                child: TopSection(
                                                  checkoutController:
                                                      checkoutController,
                                                  charge: originalCharge,
                                                  deliveryCharge:
                                                      deliveryCharge,
                                                  addressList: addressList,
                                                  tomorrowClosed:
                                                      tomorrowClosed,
                                                  todayClosed: todayClosed,
                                                  module: module,
                                                  price: price,
                                                  discount: discount,
                                                  addOns: addOns,
                                                  address: address,
                                                  cartList: _cartList,
                                                  isCashOnDeliveryActive:
                                                      _isCashOnDeliveryActive!,
                                                  isDigitalPaymentActive:
                                                      _isDigitalPaymentActive!,
                                                  isWalletActive:
                                                      _isWalletActive,
                                                  storeId: widget.storeId,
                                                  total: total,
                                                  isOfflinePaymentActive:
                                                      _isOfflinePaymentActive,
                                                  guestNameTextEditingController:
                                                      guestContactPersonNameController,
                                                  guestNumberTextEditingController:
                                                      guestContactPersonNumberController,
                                                  guestNumberNode:
                                                      guestNumberNode,
                                                  guestEmailController:
                                                      guestEmailController,
                                                  guestEmailNode:
                                                      guestEmailNode,
                                                  tooltipController1:
                                                      tooltipController1,
                                                  tooltipController2:
                                                      tooltipController2,
                                                  dmTipsTooltipController:
                                                      tooltipController3,
                                                )),
                                            const SizedBox(
                                                width: Dimensions
                                                    .paddingSizeLarge),
                                            Expanded(
                                                flex: 4,
                                                child: BottomSection(
                                                  checkoutController:
                                                      checkoutController,
                                                  total: total,
                                                  module: module!,
                                                  subTotal: subTotal,
                                                  discount: discount,
                                                  couponController:
                                                      couponController,
                                                  taxIncluded: taxIncluded,
                                                  tax: tax,
                                                  deliveryCharge:
                                                      deliveryCharge,
                                                  todayClosed: todayClosed,
                                                  tomorrowClosed:
                                                      tomorrowClosed,
                                                  orderAmount: orderAmount,
                                                  maxCodOrderAmount:
                                                      maxCodOrderAmount,
                                                  storeId: widget.storeId,
                                                  taxPercent: _taxPercent,
                                                  price: price,
                                                  addOns: addOns,
                                                  isPrescriptionRequired:
                                                      isPrescriptionRequired,
                                                  checkoutButton:
                                                      _orderPlaceButton(
                                                    checkoutController,
                                                    todayClosed,
                                                    tomorrowClosed,
                                                    orderAmount,
                                                    deliveryCharge,
                                                    tax,
                                                    discount,
                                                    total,
                                                    maxCodOrderAmount,
                                                    isPrescriptionRequired,
                                                  ),
                                                  referralDiscount:
                                                      referralDiscount,
                                                )),
                                          ]),
                                    )
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                          GetBuilder<StoreController>(
                                              builder: (storeController) {
                                            return GetBuilder<CartController>(
                                                builder: (cartController) {
                                              return cartController
                                                      .cartList.isNotEmpty
                                                  ? Column(children: [
                                                      WebScreenTitleWidget(
                                                          title:
                                                              'cart_list'.tr),
                                                      SizedBox(
                                                        width: Dimensions
                                                            .webMaxWidth,
                                                        child: Column(
                                                            children: [
                                                              Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  ResponsiveHelper
                                                                          .isDesktop(
                                                                              context)
                                                                      ? WebCardItemsWidget(
                                                                          cartList:
                                                                              cartController.cartList)
                                                                      : Expanded(
                                                                          flex:
                                                                              7,
                                                                          child: Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                // delivery option
                                                                                Container(
                                                                                  decoration: BoxDecoration(
                                                                                    color: Theme.of(context).cardColor,
                                                                                    boxShadow: [
                                                                                      BoxShadow(color: Theme.of(context).primaryColor.withOpacity(0.05), blurRadius: 10)
                                                                                    ],
                                                                                  ),
                                                                                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
                                                                                  width: double.infinity,
                                                                                  child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Text('delivery_type'.tr, style: robotoMedium),
                                                                                      const SizedBox(height: Dimensions.paddingSizeSmall),
                                                                                      widget.storeId != null
                                                                                          ? DeliveryOptionButtonWidget(
                                                                                              value: 'delivery',
                                                                                              title: 'home_delivery'.tr,
                                                                                              charge: originalCharge,
                                                                                              isFree: checkoutController.store!.freeDelivery,
                                                                                              fromWeb: true,
                                                                                              total: total,
                                                                                              isDesignChange: true,
                                                                                              icon: Images.checkoutDeliveryIcon,
                                                                                              cartList: _cartList,
                                                                                              storeId: widget.storeId,
                                                                                              tomorrowClosed: tomorrowClosed,
                                                                                              todayClosed: tomorrowClosed,
                                                                                              module: module,
                                                                                            )
                                                                                          : SingleChildScrollView(
                                                                                              scrollDirection: Axis.horizontal,
                                                                                              child: Row(children: [
                                                                                                Get.find<SplashController>().configModel!.homeDeliveryStatus == 1 && checkoutController.store!.delivery!
                                                                                                    ? DeliveryOptionButtonWidget(
                                                                                                        value: 'delivery',
                                                                                                        title: 'home_delivery'.tr,
                                                                                                        charge: originalCharge,
                                                                                                        isFree: checkoutController.store!.freeDelivery,
                                                                                                        fromWeb: true,
                                                                                                        total: total,
                                                                                                        isDesignChange: true,
                                                                                                        icon: Images.checkoutDeliveryIcon,
                                                                                                        cartList: _cartList,
                                                                                                        storeId: widget.storeId,
                                                                                                        tomorrowClosed: tomorrowClosed,
                                                                                                        todayClosed: tomorrowClosed,
                                                                                                        module: module,
                                                                                                      )
                                                                                                    : const SizedBox(),
                                                                                                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                                                                                Get.find<SplashController>().configModel!.takeawayStatus == 1 && checkoutController.store!.takeAway!
                                                                                                    ? DeliveryOptionButtonWidget(
                                                                                                        value: 'take_away',
                                                                                                        title: 'take_away'.tr,
                                                                                                        charge: deliveryCharge,
                                                                                                        isFree: true,
                                                                                                        fromWeb: true,
                                                                                                        total: total,
                                                                                                        isDesignChange: true,
                                                                                                        icon: Images.checkoutTakeAwayIcon,
                                                                                                        cartList: _cartList,
                                                                                                        storeId: widget.storeId,
                                                                                                        tomorrowClosed: tomorrowClosed,
                                                                                                        todayClosed: tomorrowClosed,
                                                                                                        module: module,
                                                                                                      )
                                                                                                    : const SizedBox(),
                                                                                              ]),
                                                                                            ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                const SizedBox(height: Dimensions.paddingSizeSmall),
                                                                                WebConstrainedBox(
                                                                                  dataLength: cartController.cartList.length,
                                                                                  minLength: 5,
                                                                                  minHeight: 0.6,
                                                                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                                                    Padding(
                                                                                      padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
                                                                                      child: Text('your_orders'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, fontWeight: FontWeight.w600)),
                                                                                    ),
                                                                                    ListView.builder(
                                                                                      physics: const NeverScrollableScrollPhysics(),
                                                                                      shrinkWrap: true,
                                                                                      itemCount: cartController.cartList.length,
                                                                                      padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault),
                                                                                      itemBuilder: (context, index) {
                                                                                        return CartItemWidget(cart: cartController.cartList[index], cartIndex: index, addOns: cartController.addOnsList[index], isAvailable: cartController.availableList[index]);
                                                                                      },
                                                                                    ),
                                                                                    // const Divider(
                                                                                    //     thickness: 0.5,
                                                                                    //     height: 5),
                                                                                    Padding(
                                                                                      padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
                                                                                      child: InkWell(
                                                                                        onTap: () {
                                                                                          cartController.forcefullySetModule(cartController.cartList[0].item!.moduleId!);
                                                                                          Get.toNamed(
                                                                                            RouteHelper.getStoreRoute(id: cartController.cartList[0].item!.storeId, page: 'item'),
                                                                                            arguments: StoreScreen(store: Store(id: cartController.cartList[0].item!.storeId), fromModule: false),
                                                                                          );
                                                                                        },
                                                                                        child: Row(
                                                                                          children: [
                                                                                            Icon(Icons.add, color: Theme.of(context).primaryColor, size: 18),
                                                                                            const SizedBox(
                                                                                              width: Dimensions.paddingSizeExtraSmall,
                                                                                            ),
                                                                                            Text('add_more_items'.tr, style: robotoMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeSmall)),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    NoteAndPrescriptionSection(checkoutController: checkoutController, storeId: widget.storeId),
                                                                                    if (checkoutController.orderType == 'take_away')
                                                                                      ExtraPackagingWidget(
                                                                                        cartController: cartController,
                                                                                        onChanged: (val) {
                                                                                          setState(() {});
                                                                                        },
                                                                                      ),
                                                                                    !ResponsiveHelper.isDesktop(context) ? suggestedItemView(cartController.cartList) : const SizedBox(),
                                                                                  ]),
                                                                                ),
                                                                                const SizedBox(height: Dimensions.paddingSizeSmall),
                                                                                !ResponsiveHelper.isDesktop(context) ? pricingView(cartController, cartController.cartList[0].item!) : const SizedBox(),
                                                                              ]),
                                                                        ),
                                                                  ResponsiveHelper
                                                                          .isDesktop(
                                                                              context)
                                                                      ? const SizedBox(
                                                                          width:
                                                                              Dimensions.paddingSizeSmall)
                                                                      : const SizedBox(),
                                                                  ResponsiveHelper
                                                                          .isDesktop(
                                                                              context)
                                                                      ? Expanded(
                                                                          flex:
                                                                              4,
                                                                          child: pricingView(
                                                                              cartController,
                                                                              cartController.cartList[0].item!))
                                                                      : const SizedBox(),
                                                                ],
                                                              ),
                                                              ResponsiveHelper
                                                                      .isDesktop(
                                                                          context)
                                                                  ? WebSuggestedItemViewWidget(
                                                                      cartList:
                                                                          cartController
                                                                              .cartList)
                                                                  : const SizedBox(),
                                                            ]),
                                                      ),
                                                    ])
                                                  : const NoDataScreen(
                                                      isCart: true,
                                                      text: '',
                                                      showFooter: true);
                                            });
                                          }),
                                          TopSection(
                                            checkoutController:
                                                checkoutController,
                                            charge: originalCharge,
                                            deliveryCharge: deliveryCharge,
                                            addressList: addressList,
                                            tomorrowClosed: tomorrowClosed,
                                            todayClosed: todayClosed,
                                            module: module,
                                            price: price,
                                            discount: discount,
                                            addOns: addOns,
                                            address: address,
                                            cartList: _cartList,
                                            isCashOnDeliveryActive:
                                                _isCashOnDeliveryActive!,
                                            isDigitalPaymentActive:
                                                _isDigitalPaymentActive!,
                                            isWalletActive: _isWalletActive,
                                            storeId: widget.storeId,
                                            total: total,
                                            isOfflinePaymentActive:
                                                _isOfflinePaymentActive,
                                            guestNameTextEditingController:
                                                guestContactPersonNameController,
                                            guestNumberTextEditingController:
                                                guestContactPersonNumberController,
                                            guestNumberNode: guestNumberNode,
                                            guestEmailController:
                                                guestEmailController,
                                            guestEmailNode: guestEmailNode,
                                            tooltipController1:
                                                tooltipController1,
                                            tooltipController2:
                                                tooltipController2,
                                            dmTipsTooltipController:
                                                tooltipController3,
                                          ),
                                          BottomSection(
                                            checkoutController:
                                                checkoutController,
                                            total: total,
                                            module: module!,
                                            subTotal: subTotal,
                                            discount: discount,
                                            couponController: couponController,
                                            taxIncluded: taxIncluded,
                                            tax: tax,
                                            deliveryCharge: deliveryCharge,
                                            todayClosed: todayClosed,
                                            tomorrowClosed: tomorrowClosed,
                                            orderAmount: orderAmount,
                                            maxCodOrderAmount:
                                                maxCodOrderAmount,
                                            storeId: widget.storeId,
                                            taxPercent: _taxPercent,
                                            price: price,
                                            addOns: addOns,
                                            isPrescriptionRequired:
                                                isPrescriptionRequired,
                                            checkoutButton: _orderPlaceButton(
                                              checkoutController,
                                              todayClosed,
                                              tomorrowClosed,
                                              orderAmount,
                                              deliveryCharge,
                                              tax,
                                              discount,
                                              total,
                                              maxCodOrderAmount,
                                              isPrescriptionRequired,
                                            ),
                                            referralDiscount: referralDiscount,
                                          )
                                        ]),
                            )),
                          )),
                          ResponsiveHelper.isDesktop(context)
                              ? const SizedBox()
                              : Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.1),
                                          blurRadius: 10)
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      DeliverySection(
                                        checkoutController: checkoutController,
                                        address: address,
                                        addressList: addressList,
                                        guestNameTextEditingController:
                                            guestContactPersonNameController,
                                        guestNumberTextEditingController:
                                            guestContactPersonNumberController,
                                        guestNumberNode: guestNumberNode,
                                        guestEmailController:
                                            guestEmailController,
                                        guestEmailNode: guestEmailNode,
                                      ),
                                      // Padding(
                                      //   padding: const EdgeInsets.symmetric(
                                      //       horizontal:
                                      //           Dimensions.paddingSizeLarge,
                                      //       vertical: Dimensions
                                      //           .paddingSizeExtraSmall),
                                      //   child: Row(
                                      //       mainAxisAlignment:
                                      //           MainAxisAlignment.spaceBetween,
                                      //       children: [
                                      //         Text(
                                      //           checkoutController.isPartialPay
                                      //               ? 'due_payment'.tr
                                      //               : 'total_amount'.tr,
                                      //           style: robotoMedium.copyWith(
                                      //               fontSize: Dimensions
                                      //                   .fontSizeLarge,
                                      //               color: Theme.of(context)
                                      //                   .primaryColor),
                                      //         ),
                                      //         PriceConverter
                                      //             .convertAnimationPrice(
                                      //           checkoutController
                                      //               .viewTotalPrice,
                                      //           textStyle:
                                      //               robotoMedium.copyWith(
                                      //                   fontSize: Dimensions
                                      //                       .fontSizeLarge,
                                      //                   color: Theme.of(context)
                                      //                       .primaryColor),
                                      //         ),
                                      //       ]),
                                      // ),
                                      _orderPlaceButton(
                                        checkoutController,
                                        todayClosed,
                                        tomorrowClosed,
                                        orderAmount,
                                        deliveryCharge,
                                        tax,
                                        discount,
                                        total,
                                        maxCodOrderAmount,
                                        isPrescriptionRequired,
                                      ),
                                    ],
                                  ),
                                ),
                        ],
                      )
                    : const CheckoutScreenShimmerView();
              });
            })
          : NotLoggedInScreen(callBack: (value) {
              initCall();
              setState(() {});
            }),
    );
  }

  Widget _orderPlaceButton(
      CheckoutController checkoutController,
      bool todayClosed,
      bool tomorrowClosed,
      double orderAmount,
      double? deliveryCharge,
      double tax,
      double? discount,
      double total,
      double? maxCodOrderAmount,
      bool isPrescriptionRequired) {
    return Container(
      width: Dimensions.webMaxWidth,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(
          vertical: Dimensions.paddingSizeSmall,
          horizontal: Dimensions.paddingSizeLarge),
      child: SafeArea(
        child: CustomButton(
            isLoading: checkoutController.isLoading,
            buttonText: checkoutController.isPartialPay
                ? 'place_order'.tr
                : 'confirm_order'.tr,
            onPressed: checkoutController.acceptTerms
                ? () {
                    bool isAvailable = true;
                    DateTime scheduleStartDate = DateTime.now();
                    DateTime scheduleEndDate = DateTime.now();
                    bool isGuestLogIn = AuthHelper.isGuestLoggedIn();
                    if (checkoutController.timeSlots == null ||
                        checkoutController.timeSlots!.isEmpty) {
                      isAvailable = false;
                    } else {
                      DateTime date = checkoutController.selectedDateSlot == 0
                          ? DateTime.now()
                          : DateTime.now().add(const Duration(days: 1));
                      DateTime startTime = checkoutController
                          .timeSlots![checkoutController.selectedTimeSlot]
                          .startTime!;
                      DateTime endTime = checkoutController
                          .timeSlots![checkoutController.selectedTimeSlot]
                          .endTime!;
                      scheduleStartDate = DateTime(date.year, date.month,
                          date.day, startTime.hour, startTime.minute + 1);
                      scheduleEndDate = DateTime(date.year, date.month,
                          date.day, endTime.hour, endTime.minute + 1);
                      if (_cartList != null) {
                        for (CartModel? cart in _cartList!) {
                          if (!DateConverter.isAvailable(
                                cart!.item!.availableTimeStarts,
                                cart.item!.availableTimeEnds,
                                time: checkoutController.store!.scheduleOrder!
                                    ? scheduleStartDate
                                    : null,
                              ) &&
                              !DateConverter.isAvailable(
                                cart.item!.availableTimeStarts,
                                cart.item!.availableTimeEnds,
                                time: checkoutController.store!.scheduleOrder!
                                    ? scheduleEndDate
                                    : null,
                              )) {
                            isAvailable = false;
                            break;
                          }
                        }
                      }
                    }

                    if (isGuestLogIn &&
                        checkoutController.guestAddress == null &&
                        checkoutController.orderType != 'take_away') {
                      showCustomSnackBar(
                          'please_setup_your_delivery_address_first'.tr);
                    } else if (isGuestLogIn &&
                        checkoutController.orderType == 'take_away' &&
                        guestContactPersonNameController.text.isEmpty) {
                      showCustomSnackBar('please_enter_contact_person_name'.tr);
                    } else if (isGuestLogIn &&
                        checkoutController.orderType == 'take_away' &&
                        guestContactPersonNumberController.text.isEmpty) {
                      showCustomSnackBar(
                          'please_enter_contact_person_number'.tr);
                    } else if (isGuestLogIn &&
                        checkoutController.orderType == 'take_away' &&
                        guestEmailController.text.isEmpty) {
                      showCustomSnackBar(
                          'please_enter_contact_person_email'.tr);
                    } else if (isPrescriptionRequired &&
                        checkoutController.pickedPrescriptions.isEmpty) {
                      showCustomSnackBar(
                          'you_must_upload_prescription_for_this_order'.tr);
                    } else if (!_isCashOnDeliveryActive! &&
                        !_isDigitalPaymentActive! &&
                        !_isWalletActive) {
                      showCustomSnackBar('no_payment_method_is_enabled'.tr);
                    } else if (checkoutController.paymentMethodIndex == -1) {
                      if (ResponsiveHelper.isDesktop(context)) {
                        Get.dialog(Dialog(
                            backgroundColor: Colors.transparent,
                            child: PaymentMethodBottomSheet(
                              isCashOnDeliveryActive: _isCashOnDeliveryActive!,
                              isDigitalPaymentActive: _isDigitalPaymentActive!,
                              isWalletActive: _isWalletActive,
                              storeId: widget.storeId,
                              totalPrice: total,
                              isOfflinePaymentActive: _isOfflinePaymentActive,
                            )));
                      } else {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (con) => PaymentMethodBottomSheet(
                            isCashOnDeliveryActive: _isCashOnDeliveryActive!,
                            isDigitalPaymentActive: _isDigitalPaymentActive!,
                            isWalletActive: _isWalletActive,
                            storeId: widget.storeId,
                            totalPrice: total,
                            isOfflinePaymentActive: _isOfflinePaymentActive,
                          ),
                        );
                      }
                    } else if (orderAmount <
                            checkoutController.store!.minimumOrder! &&
                        widget.storeId == null) {
                      showCustomSnackBar(
                          '${'minimum_order_amount_is'.tr} ${checkoutController.store!.minimumOrder}');
                    } else if (checkoutController
                            .tipController.text.isNotEmpty &&
                        checkoutController.tipController.text != 'not_now' &&
                        double.parse(
                                checkoutController.tipController.text.trim()) <
                            0) {
                      showCustomSnackBar('tips_can_not_be_negative'.tr);
                    } else if ((checkoutController.selectedDateSlot == 0 &&
                            todayClosed) ||
                        (checkoutController.selectedDateSlot == 1 &&
                            tomorrowClosed)) {
                      showCustomSnackBar(Get.find<SplashController>()
                              .configModel!
                              .moduleConfig!
                              .module!
                              .showRestaurantText!
                          ? 'restaurant_is_closed'.tr
                          : 'store_is_closed'.tr);
                    } else if (checkoutController.paymentMethodIndex == 0 &&
                        _isCashOnDeliveryActive! &&
                        maxCodOrderAmount != null &&
                        maxCodOrderAmount != 0 &&
                        (total > maxCodOrderAmount) &&
                        widget.storeId == null) {
                      showCustomSnackBar(
                          '${'you_cant_order_more_then'.tr} ${PriceConverter.convertPrice(maxCodOrderAmount)} ${'in_cash_on_delivery'.tr}');
                    } else if (checkoutController.paymentMethodIndex != 0 &&
                        widget.storeId != null) {
                      showCustomSnackBar('payment_method_is_not_available'.tr);
                    } else if (checkoutController.timeSlots == null ||
                        checkoutController.timeSlots!.isEmpty) {
                      if (checkoutController.store!.scheduleOrder!) {
                        showCustomSnackBar('select_a_time'.tr);
                      } else {
                        showCustomSnackBar(Get.find<SplashController>()
                                .configModel!
                                .moduleConfig!
                                .module!
                                .showRestaurantText!
                            ? 'restaurant_is_closed'.tr
                            : 'store_is_closed'.tr);
                      }
                    } else if (!isAvailable) {
                      showCustomSnackBar(
                          'one_or_more_products_are_not_available_for_this_selected_time'
                              .tr);
                    } else if (checkoutController.orderType != 'take_away' &&
                        checkoutController.distance == -1 &&
                        deliveryCharge == -1) {
                      showCustomSnackBar('delivery_fee_not_set_yet'.tr);
                    } else if (widget.storeId != null &&
                        checkoutController.pickedPrescriptions.isEmpty) {
                      showCustomSnackBar(
                          'please_upload_your_prescription_images'.tr);
                    } else if (!checkoutController.acceptTerms) {
                      showCustomSnackBar(
                          'please_accept_privacy_policy_trams_conditions_refund_policy_first'
                              .tr);
                    } else {
                      AddressModel? finalAddress = isGuestLogIn
                          ? checkoutController.guestAddress
                          : address[checkoutController.addressIndex!];

                      if (isGuestLogIn &&
                          checkoutController.orderType == 'take_away') {
                        String number = checkoutController.countryDialCode! +
                            guestContactPersonNumberController.text;
                        finalAddress = AddressModel(
                          contactPersonName:
                              guestContactPersonNameController.text,
                          contactPersonNumber: number,
                          address: AddressHelper.getUserAddressFromSharedPref()!
                              .address!,
                          latitude:
                              AddressHelper.getUserAddressFromSharedPref()!
                                  .latitude,
                          longitude:
                              AddressHelper.getUserAddressFromSharedPref()!
                                  .longitude,
                          zoneId: AddressHelper.getUserAddressFromSharedPref()!
                              .zoneId,
                          email: guestEmailController.text,
                        );
                      }

                      if (!isGuestLogIn &&
                          finalAddress!.contactPersonNumber == 'null') {
                        finalAddress.contactPersonNumber =
                            Get.find<ProfileController>().userInfoModel!.phone;
                      }

                      if (widget.storeId == null) {
                        List<OnlineCart> carts = [];
                        for (int index = 0;
                            index < _cartList!.length;
                            index++) {
                          CartModel cart = _cartList![index]!;
                          List<int?> addOnIdList = [];
                          List<int?> addOnQtyList = [];
                          for (var addOn in cart.addOnIds!) {
                            addOnIdList.add(addOn.id);
                            addOnQtyList.add(addOn.quantity);
                          }

                          List<OrderVariation> variations = [];
                          if (Get.find<SplashController>()
                              .getModuleConfig(cart.item!.moduleType)
                              .newVariation!) {
                            for (int i = 0;
                                i < cart.item!.foodVariations!.length;
                                i++) {
                              if (cart.foodVariations![i].contains(true)) {
                                variations.add(OrderVariation(
                                    name: cart.item!.foodVariations![i].name,
                                    values: OrderVariationValue(label: [])));
                                for (int j = 0;
                                    j <
                                        cart.item!.foodVariations![i]
                                            .variationValues!.length;
                                    j++) {
                                  if (cart.foodVariations![i][j]!) {
                                    variations[variations.length - 1]
                                        .values!
                                        .label!
                                        .add(cart.item!.foodVariations![i]
                                            .variationValues![j].level);
                                  }
                                }
                              }
                            }
                          }
                          carts.add(OnlineCart(
                            cart.id,
                            cart.item!.id,
                            cart.isCampaign! ? cart.item!.id : null,
                            cart.discountedPrice.toString(),
                            '',
                            Get.find<SplashController>()
                                    .getModuleConfig(cart.item!.moduleType)
                                    .newVariation!
                                ? null
                                : cart.variation,
                            Get.find<SplashController>()
                                    .getModuleConfig(cart.item!.moduleType)
                                    .newVariation!
                                ? variations
                                : null,
                            cart.quantity,
                            addOnIdList,
                            cart.addOns,
                            addOnQtyList,
                            'Item',
                            itemType: !widget.fromCart
                                ? "AppModelsItemCampaign"
                                : null,
                          ));
                        }

                        PlaceOrderBodyModel placeOrderBody =
                            PlaceOrderBodyModel(
                          cart: carts,
                          couponDiscountAmount:
                              Get.find<CouponController>().discount,
                          distance: checkoutController.distance,
                          scheduleAt: !checkoutController.store!.scheduleOrder!
                              ? null
                              : (checkoutController.selectedDateSlot == 0 &&
                                      checkoutController.selectedTimeSlot == 0)
                                  ? null
                                  : DateConverter.dateToDateAndTime(
                                      scheduleEndDate),
                          orderAmount: total,
                          orderNote: checkoutController.noteController.text,
                          orderType: checkoutController.orderType,
                          paymentMethod: checkoutController
                                      .paymentMethodIndex ==
                                  0
                              ? 'cash_on_delivery'
                              : checkoutController.paymentMethodIndex == 1
                                  ? 'wallet'
                                  : checkoutController.paymentMethodIndex == 2
                                      ? 'digital_payment'
                                      : 'offline_payment',
                          couponCode:
                              (Get.find<CouponController>().discount! > 0 ||
                                      (Get.find<CouponController>().coupon !=
                                              null &&
                                          Get.find<CouponController>()
                                              .freeDelivery))
                                  ? Get.find<CouponController>().coupon!.code
                                  : null,
                          storeId: _cartList![0]!.item!.storeId,
                          address: finalAddress!.address,
                          latitude: finalAddress.latitude,
                          longitude: finalAddress.longitude,
                          senderZoneId: null,
                          addressType: finalAddress.addressType,
                          contactPersonName: finalAddress.contactPersonName ??
                              '${Get.find<ProfileController>().userInfoModel!.fName} '
                                  '${Get.find<ProfileController>().userInfoModel!.lName}',
                          contactPersonNumber:
                              finalAddress.contactPersonNumber ??
                                  Get.find<ProfileController>()
                                      .userInfoModel!
                                      .phone,
                          streetNumber: isGuestLogIn
                              ? finalAddress.streetNumber ?? ''
                              : checkoutController.streetNumberController.text
                                  .trim(),
                          house: isGuestLogIn
                              ? finalAddress.house ?? ''
                              : checkoutController.houseController.text.trim(),
                          floor: isGuestLogIn
                              ? finalAddress.floor ?? ''
                              : checkoutController.floorController.text.trim(),
                          discountAmount: discount,
                          taxAmount: tax,
                          receiverDetails: null,
                          parcelCategoryId: null,
                          chargePayer: null,
                          dmTips: (checkoutController.orderType ==
                                      'take_away' ||
                                  checkoutController.tipController.text ==
                                      'not_now')
                              ? ''
                              : checkoutController.tipController.text.trim(),
                          cutlery:
                              Get.find<CartController>().addCutlery ? 1 : 0,
                          unavailableItemNote:
                              Get.find<CartController>().notAvailableIndex != -1
                                  ? Get.find<CartController>().notAvailableList[
                                      Get.find<CartController>()
                                          .notAvailableIndex]
                                  : '',
                          deliveryInstruction:
                              checkoutController.selectedInstruction != -1
                                  ? AppConstants.deliveryInstructionList[
                                      checkoutController.selectedInstruction]
                                  : '',
                          partialPayment:
                              checkoutController.isPartialPay ? 1 : 0,
                          guestId: isGuestLogIn
                              ? int.parse(AuthHelper.getGuestId())
                              : 0,
                          isBuyNow: widget.fromCart ? 0 : 1,
                          guestEmail: isGuestLogIn ? finalAddress.email : null,
                          extraPackagingAmount: Get.find<CartController>()
                                  .needExtraPackage
                              ? checkoutController.store!.extraPackagingAmount
                              : 0,
                        );

                        if (checkoutController.paymentMethodIndex == 3) {
                          Get.toNamed(RouteHelper.getOfflinePaymentScreen(
                            placeOrderBody: placeOrderBody,
                            zoneId: checkoutController.store!.zoneId!,
                            total: checkoutController.viewTotalPrice!,
                            maxCodOrderAmount: maxCodOrderAmount,
                            fromCart: widget.fromCart,
                            isCodActive: _isCashOnDeliveryActive,
                            forParcel: false,
                          ));
                        } else {
                          checkoutController.placeOrder(
                              placeOrderBody,
                              checkoutController.store!.zoneId,
                              total,
                              maxCodOrderAmount,
                              widget.fromCart,
                              _isCashOnDeliveryActive!,
                              checkoutController.pickedPrescriptions);
                        }
                      } else {
                        checkoutController.placePrescriptionOrder(
                            widget.storeId,
                            checkoutController.store!.zoneId,
                            checkoutController.distance,
                            finalAddress!.address!,
                            finalAddress.longitude!,
                            finalAddress.latitude!,
                            checkoutController.noteController.text,
                            checkoutController.pickedPrescriptions,
                            (checkoutController.orderType == 'take_away' ||
                                    checkoutController.tipController.text ==
                                        'not_now')
                                ? ''
                                : checkoutController.tipController.text.trim(),
                            checkoutController.selectedInstruction != -1
                                ? AppConstants.deliveryInstructionList[
                                    checkoutController.selectedInstruction]
                                : '',
                            0,
                            0,
                            widget.fromCart,
                            _isCashOnDeliveryActive!);
                      }
                    }
                  }
                : null),
      ),
    );
  }

  List<DropdownItem<int>> _getDropdownAddressList(
      {required BuildContext context,
      required List<AddressModel>? addressList,
      required Store? store}) {
    List<DropdownItem<int>> dropDownAddressList = [];

    dropDownAddressList.add(DropdownItem<int>(
        value: 0,
        child: SizedBox(
          width: context.width > Dimensions.webMaxWidth
              ? Dimensions.webMaxWidth - 50
              : context.width - 50,
          child: AddressWidget(
            address: AddressHelper.getUserAddressFromSharedPref(),
            fromAddress: false,
            fromCheckout: true,
          ),
        )));

    if (addressList != null && store != null) {
      for (int index = 0; index < addressList.length; index++) {
        if (addressList[index].zoneIds!.contains(store.zoneId)) {
          dropDownAddressList.add(DropdownItem<int>(
              value: index + 1,
              child: SizedBox(
                width: context.width > Dimensions.webMaxWidth
                    ? Dimensions.webMaxWidth - 50
                    : context.width - 50,
                child: AddressWidget(
                  address: addressList[index],
                  fromAddress: false,
                  fromCheckout: true,
                ),
              )));
        }
      }
    }
    return dropDownAddressList;
  }

  List<AddressModel> _getAddressList(
      {required List<AddressModel>? addressList, required Store? store}) {
    List<AddressModel> address = [];

    address.add(AddressHelper.getUserAddressFromSharedPref()!);

    if (addressList != null && store != null) {
      for (int index = 0; index < addressList.length; index++) {
        if (addressList[index].zoneIds!.contains(store.zoneId)) {
          address.add(addressList[index]);
        }
      }
    }
    return address;
  }

  Pivot? _getModuleData({required Store? store}) {
    Pivot? moduleData;
    if (store != null) {
      for (ZoneData zData
          in AddressHelper.getUserAddressFromSharedPref()!.zoneData!) {
        for (Modules m in zData.modules!) {
          if (m.id == Get.find<SplashController>().module!.id &&
              m.pivot!.zoneId == store.zoneId) {
            moduleData = m.pivot;
            break;
          }
        }
      }
    }
    return moduleData;
  }

  bool _checkCODActive({required Store? store}) {
    bool isCashOnDeliveryActive = false;
    if (store != null) {
      for (ZoneData zData
          in AddressHelper.getUserAddressFromSharedPref()!.zoneData!) {
        if (zData.id == store.zoneId) {
          isCashOnDeliveryActive = zData.cashOnDelivery! &&
              Get.find<SplashController>().configModel!.cashOnDelivery!;
        }
      }
    }
    return isCashOnDeliveryActive;
  }

  bool _checkDigitalPaymentActive({required Store? store}) {
    bool isDigitalPaymentActive = false;
    if (store != null) {
      for (ZoneData zData
          in AddressHelper.getUserAddressFromSharedPref()!.zoneData!) {
        if (zData.id == store.zoneId) {
          isDigitalPaymentActive = zData.digitalPayment! &&
              Get.find<SplashController>().configModel!.digitalPayment!;
        }
      }
    }
    return isDigitalPaymentActive;
  }

  double _calculatePrice(
      {required Store? store, required List<CartModel?>? cartList}) {
    double price = 0;
    if (cartList != null) {
      for (var cartModel in cartList) {
        if (Get.find<SplashController>()
            .getModuleConfig(cartModel!.item!.moduleType)
            .newVariation!) {
          price = price + (cartModel.item!.price! * cartModel.quantity!);
        } else {
          price = _calculateVariationPrice(store: store, cartList: cartList);
        }
      }
    }
    return PriceConverter.toFixed(price);
  }

  double _calculateAddonsPrice(
      {required Store? store, required List<CartModel?>? cartList}) {
    double addOns = 0;
    if (store != null && cartList != null) {
      for (var cartModel in cartList) {
        List<AddOns> addOnList = [];
        for (var addOnId in cartModel!.addOnIds!) {
          for (AddOns addOns in cartModel.item!.addOns!) {
            if (addOns.id == addOnId.id) {
              addOnList.add(addOns);
              break;
            }
          }
        }
        for (int index = 0; index < addOnList.length; index++) {
          addOns = addOns +
              (addOnList[index].price! * cartModel.addOnIds![index].quantity!);
        }
      }
    }
    return PriceConverter.toFixed(addOns);
  }

  double _calculateVariationPrice(
      {required Store? store,
      required List<CartModel?>? cartList,
      bool calculateDiscount = false,
      bool calculateWithoutDiscount = false}) {
    double variationPrice = 0;
    double variationDiscount = 0;
    if (store != null && cartList != null) {
      for (var cartModel in cartList) {
        double? discount = cartModel!.item!.storeDiscount == 0
            ? cartModel.item!.discount
            : cartModel.item!.storeDiscount;
        String? discountType = cartModel.item!.storeDiscount == 0
            ? cartModel.item!.discountType
            : 'percent';

        if (Get.find<SplashController>()
            .getModuleConfig(cartModel.item!.moduleType)
            .newVariation!) {
          for (int index = 0;
              index < cartModel.item!.foodVariations!.length;
              index++) {
            for (int i = 0;
                i <
                    cartModel
                        .item!.foodVariations![index].variationValues!.length;
                i++) {
              if (cartModel.foodVariations![index][i]!) {
                variationPrice += (PriceConverter.convertWithDiscount(
                        cartModel.item!.foodVariations![index]
                            .variationValues![i].optionPrice!,
                        discount,
                        discountType,
                        isFoodVariation: true)! *
                    cartModel.quantity!);
                variationDiscount += (cartModel.item!.foodVariations![index]
                        .variationValues![i].optionPrice! *
                    cartModel.quantity!);
              }
            }
          }
        } else {
          String variationType = '';
          for (int i = 0; i < cartModel.variation!.length; i++) {
            variationType = cartModel.variation![i].type!;
          }

          if (cartModel.item!.variations!.isNotEmpty) {
            for (Variation variation in cartModel.item!.variations!) {
              if (variation.type == variationType) {
                variationPrice += (variation.price! * cartModel.quantity!);
                break;
              }
            }
          } else {
            variationDiscount += (PriceConverter.convertWithDiscount(
                    cartModel.item!.price!, discount, discountType)! *
                cartModel.quantity!);
            variationPrice += (cartModel.item!.price! * cartModel.quantity!);
          }
        }
      }
    }
    if (calculateDiscount) {
      return (variationDiscount - variationPrice);
    } else if (calculateWithoutDiscount) {
      return variationDiscount;
    } else {
      return variationPrice;
    }
  }

  double _calculateDiscount(
      {required Store? store,
      required List<CartModel?>? cartList,
      required double price,
      required double addOns}) {
    double discount = 0;
    if (store != null && cartList != null) {
      for (var cartModel in cartList) {
        double? dis = (store.discount != null &&
                    DateConverter.isAvailable(
                        store.discount!.startTime, store.discount!.endTime)) &&
                cartModel!.item!.flashSale != 1
            ? store.discount!.discount
            : cartModel!.item!.discount;
        String? disType = (store.discount != null &&
                    DateConverter.isAvailable(
                        store.discount!.startTime, store.discount!.endTime)) &&
                cartModel.item!.flashSale != 1
            ? 'percent'
            : cartModel.item!.discountType;
        if (Get.find<SplashController>()
            .getModuleConfig(cartModel.item!.moduleType)
            .newVariation!) {
          double d = ((cartModel.item!.price! -
                  PriceConverter.convertWithDiscount(
                      cartModel.item!.price!, dis, disType)!) *
              cartModel.quantity!);
          discount = discount + d;
          if (disType == 'percent' && discount != 0) {
            discount = discount +
                _calculateFoodVariationDiscount(cartModel: cartModel);
          }
        } else {
          String variationType = '';
          double variationPrice = 0;
          double variationWithoutDiscountPrice = 0;
          for (int i = 0; i < cartModel.variation!.length; i++) {
            variationType = cartModel.variation![i].type!;
          }
          if (cartModel.item!.variations!.isNotEmpty) {
            for (Variation variation in cartModel.item!.variations!) {
              if (variation.type == variationType) {
                variationPrice += (PriceConverter.convertWithDiscount(
                        variation.price!, dis, disType)! *
                    cartModel.quantity!);
                variationWithoutDiscountPrice +=
                    (variation.price! * cartModel.quantity!);
                break;
              }
            }
            discount =
                discount + (variationWithoutDiscountPrice - variationPrice);
          } else {
            double d = ((cartModel.item!.price! -
                    PriceConverter.convertWithDiscount(
                        cartModel.item!.price!, dis, disType)!) *
                cartModel.quantity!);
            discount = discount + d;
          }
        }
      }
    }

    if (store != null && store.discount != null) {
      if (store.discount!.maxDiscount != 0 &&
          store.discount!.maxDiscount! < discount) {
        discount = store.discount!.maxDiscount!;
      }
      if (store.discount!.minPurchase != 0 &&
          store.discount!.minPurchase! > (price + addOns)) {
        discount = 0;
      }
    }
    return PriceConverter.toFixed(discount);
  }

  double _calculateFoodVariationDiscount({required CartModel? cartModel}) {
    double variationPrice = 0;
    double variationDiscount = 0;
    if (cartModel != null) {
      double? discount = cartModel.item!.storeDiscount == 0
          ? cartModel.item!.discount
          : cartModel.item!.storeDiscount;
      String? discountType = cartModel.item!.storeDiscount == 0
          ? cartModel.item!.discountType
          : 'percent';
      for (int index = 0;
          index < cartModel.item!.foodVariations!.length;
          index++) {
        for (int i = 0;
            i < cartModel.item!.foodVariations![index].variationValues!.length;
            i++) {
          if (cartModel.foodVariations![index][i]!) {
            variationPrice += (PriceConverter.convertWithDiscount(
                    cartModel.item!.foodVariations![index].variationValues![i]
                        .optionPrice!,
                    discount,
                    discountType,
                    isFoodVariation: true)! *
                cartModel.quantity!);
            variationDiscount += (cartModel.item!.foodVariations![index]
                    .variationValues![i].optionPrice! *
                cartModel.quantity!);
          }
        }
      }
    }
    return (variationDiscount - variationPrice);
  }

  double _calculateOrderAmount(
      {required double price,
      required double variations,
      required double discount,
      required double addOns,
      required double couponDiscount,
      required List<CartModel?>? cartList,
      required double referralDiscount}) {
    double orderAmount = 0;
    double variationPrice = 0;
    if (cartList != null &&
        cartList.isNotEmpty &&
        Get.find<SplashController>()
            .getModuleConfig(cartList[0]?.item?.moduleType)
            .newVariation!) {
      variationPrice = variations;
    }
    orderAmount = (price + variationPrice - discount) +
        addOns -
        couponDiscount -
        referralDiscount;
    return PriceConverter.toFixed(orderAmount);
  }

  double _calculateTax(
      {required bool taxIncluded,
      required double orderAmount,
      required double? taxPercent}) {
    double tax = 0;
    if (taxIncluded) {
      tax = orderAmount * taxPercent! / (100 + taxPercent);
    } else {
      tax = PriceConverter.calculation(orderAmount, taxPercent, 'percent', 1);
    }
    return PriceConverter.toFixed(tax);
  }

  double _calculateSubTotal(
      {required double price,
      required double addOns,
      required double variations,
      required List<CartModel?>? cartList}) {
    double subTotal = 0;
    bool isFoodVariation = false;

    if (cartList != null && cartList.isNotEmpty) {
      isFoodVariation = Get.find<SplashController>()
          .getModuleConfig(cartList[0]!.item!.moduleType)
          .newVariation!;
    }
    if (isFoodVariation) {
      subTotal = price + addOns + variations;
    } else {
      subTotal = price;
    }

    return subTotal;
  }

  double _calculateOriginalDeliveryCharge(
      {required Store? store,
      required AddressModel address,
      required double? distance,
      required double? extraCharge}) {
    double deliveryCharge = -1;

    Pivot? moduleData;
    ZoneData? zoneData;
    if (store != null) {
      for (ZoneData zData in address.zoneData!) {
        for (Modules m in zData.modules!) {
          if (m.id == Get.find<SplashController>().module!.id &&
              m.pivot!.zoneId == store.zoneId) {
            moduleData = m.pivot;
            break;
          }
        }

        if (zData.id == store.zoneId) {
          zoneData = zData;
        }
      }
    }
    double perKmCharge = 0;
    double minimumCharge = 0;
    double? maximumCharge = 0;
    if (store != null &&
        distance != null &&
        distance != -1 &&
        store.selfDeliverySystem == 1) {
      perKmCharge = store.perKmShippingCharge!;
      minimumCharge = store.minimumShippingCharge!;
      maximumCharge = store.maximumShippingCharge;
    } else if (store != null &&
        distance != null &&
        distance != -1 &&
        moduleData != null) {
      perKmCharge = moduleData.perKmShippingCharge!;
      minimumCharge = moduleData.minimumShippingCharge!;
      maximumCharge = moduleData.maximumShippingCharge;
    }
    if (store != null && distance != null) {
      deliveryCharge = distance * perKmCharge;

      if (deliveryCharge < minimumCharge) {
        deliveryCharge = minimumCharge;
      } else if (maximumCharge != null && deliveryCharge > maximumCharge) {
        deliveryCharge = maximumCharge;
      }
    }

    if (store != null && store.selfDeliverySystem == 0 && extraCharge != null) {
      deliveryCharge = deliveryCharge + extraCharge;
    }

    if (store != null &&
        store.selfDeliverySystem == 0 &&
        zoneData!.increaseDeliveryFeeStatus == 1) {
      deliveryCharge = deliveryCharge +
          (deliveryCharge * (zoneData.increaseDeliveryFee! / 100));
    }

    return deliveryCharge;
  }

  double _calculateDeliveryCharge(
      {required Store? store,
      required AddressModel address,
      required double? distance,
      required double? extraCharge,
      required double orderAmount,
      required String orderType}) {
    double deliveryCharge = _calculateOriginalDeliveryCharge(
        store: store,
        address: address,
        distance: distance,
        extraCharge: extraCharge);

    if (orderType == 'take_away' ||
        (store != null && store.freeDelivery!) ||
        (Get.find<SplashController>().configModel!.freeDeliveryOver != null &&
            orderAmount >=
                Get.find<SplashController>().configModel!.freeDeliveryOver!) ||
        Get.find<CouponController>().freeDelivery ||
        (AuthHelper.isGuestLoggedIn() &&
            (Get.find<CheckoutController>().guestAddress == null &&
                Get.find<CheckoutController>().orderType != 'take_away'))) {
      deliveryCharge = 0;
    }

    return PriceConverter.toFixed(deliveryCharge);
  }

  double _calculateTotal({
    required double subTotal,
    required double deliveryCharge,
    required double discount,
    required double couponDiscount,
    required bool taxIncluded,
    required double tax,
    required String orderType,
    required double tips,
    required double additionalCharge,
    required double extraPackagingCharge,
  }) {
    return PriceConverter.toFixed(subTotal +
        deliveryCharge -
        discount -
        couponDiscount +
        (taxIncluded ? 0 : tax) +
        ((orderType != 'take_away' &&
                Get.find<SplashController>().configModel!.dmTipsStatus == 1)
            ? tips
            : 0) +
        additionalCharge +
        extraPackagingCharge);
  }

  bool _checkZoneOfflinePaymentOnOff({required AddressModel? addressModel}) {
    bool? status = false;
    ZoneData? zoneData;
    for (var data in addressModel!.zoneData!) {
      if (data.id == addressModel.zoneId) {
        zoneData = data;
        break;
      }
    }
    status = zoneData?.offlinePayment ?? false;
    return status;
  }

  bool _checkPrescriptionRequired() {
    if (widget.storeId == null &&
        Get.find<SplashController>()
            .configModel!
            .moduleConfig!
            .module!
            .orderAttachment!) {
      for (var cart in _cartList!) {
        if (cart!.item!.isPrescriptionRequired!) {
          return true;
        }
      }
    }
    return false;
  }

  double _calculateExtraPackagingCharge(CheckoutController checkoutController) {
    if ((checkoutController.store?.extraPackagingStatus ?? true) &&
        (Get.find<CartController>().needExtraPackage)) {
      return checkoutController.store?.extraPackagingAmount ?? 0;
    }
    return 0;
  }

  double _calculateReferralDiscount(
      double subTotal, double discount, double couponDiscount) {
    double referralDiscount = 0;
    if (Get.find<ProfileController>().userInfoModel != null &&
        Get.find<ProfileController>().userInfoModel!.isValidForDiscount!) {
      if (Get.find<ProfileController>().userInfoModel!.discountAmountType! ==
          "percentage") {
        referralDiscount =
            (Get.find<ProfileController>().userInfoModel!.discountAmount! /
                    100) *
                (subTotal - discount - couponDiscount);
      } else {
        referralDiscount =
            Get.find<ProfileController>().userInfoModel!.discountAmount!;
      }
    }
    return PriceConverter.toFixed(referralDiscount);
  }

  Future<void> showCashBackSnackBar() async {
    await Get.find<HomeController>().getCashBackData(_payableAmount!);
    double? cashBackAmount =
        Get.find<HomeController>().cashBackData?.cashbackAmount ?? 0;
    String? cashBackType =
        Get.find<HomeController>().cashBackData?.cashbackType ?? '';
    String text =
        '${'you_will_get'.tr} ${cashBackType == 'amount' ? PriceConverter.convertPrice(cashBackAmount) : '${cashBackAmount.toStringAsFixed(0)}%'} ${'cash_back_after_completing_order'.tr}';
    if (cashBackAmount > 0) {
      showCustomSnackBar(text, isError: false);
    }
  }

  Widget pricingView(CartController cartController, Item item) {
    return Container(
      decoration: ResponsiveHelper.isDesktop(context)
          ? BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(
                  ResponsiveHelper.isDesktop(context)
                      ? Dimensions.radiusDefault
                      : Dimensions.radiusSmall),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)
              ],
            )
          : null,
      child: GetBuilder<StoreController>(builder: (storeController) {
        return Column(children: [
          ResponsiveHelper.isDesktop(context)
              ? ExtraPackagingWidget(cartController: cartController)
              : const SizedBox(),

          ResponsiveHelper.isDesktop(context)
              ? Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeDefault,
                        vertical: Dimensions.paddingSizeSmall),
                    child: Text('order_summary'.tr,
                        style: robotoBold.copyWith(
                            fontSize: Dimensions.fontSizeLarge)),
                  ),
                )
              : const SizedBox(),

          !ResponsiveHelper.isDesktop(context) &&
                  Get.find<SplashController>()
                      .getModuleConfig(item.moduleType)
                      .newVariation! &&
                  (storeController.store != null &&
                      storeController.store!.cutlery!)
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeDefault,
                      vertical: Dimensions.paddingSizeSmall),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(Images.cutlery, height: 18, width: 18),
                            const SizedBox(
                                width: Dimensions.paddingSizeDefault),
                            Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('add_cutlery'.tr, style: robotoMedium),
                                    /*const SizedBox(
                                        height: Dimensions.paddingSizeExtraSmall),
                                    Text('do_not_have_cutlery'.tr,
                                        style: robotoRegular.copyWith(
                                            color: Theme.of(context).disabledColor,
                                            fontSize: Dimensions.fontSizeSmall)),*/
                                  ]),
                            ),
                            SizedBox(
                              width: 45.0,
                              child: AnimatedToggleSwitch<bool>.dual(
                                current: cartController.addCutlery,
                                first: true,
                                second: false,
                                // spacing: 90.0,
                                style: const ToggleStyle(
                                  borderColor: Colors.transparent,
                                ),
                                borderWidth: 0.0,
                                height: 26,
                                onChanged: (b) =>
                                    cartController.updateCutlery(),
                                styleBuilder: (b) => ToggleStyle(
                                  backgroundColor: b
                                      ? Theme.of(context).hintColor
                                      : Theme.of(context).primaryColor,
                                  indicatorColor: Colors.transparent,
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radiusSmall),
                                  indicatorBorderRadius: BorderRadius.circular(
                                      Dimensions.radiusSmall),
                                ),
                                iconBuilder: (value) => Container(
                                  width: 20.0,
                                  height: 20.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.radiusSmall),
                                      color: Colors.white),
                                ),
                              ),
                            ),
                            /*Transform.scale(
                              scale: 0.7,
                              child: CupertinoSwitch(
                                value: cartController.addCutlery,
                                activeColor: Theme.of(context).primaryColor,
                                onChanged: (bool? value) {
                                  cartController.updateCutlery();
                                },
                                trackColor: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.5),
                              ),
                            )*/
                          ]),
                      Text(
                          cartController.addCutlery
                              ? 'cutlery_selected_text'.tr
                              : 'cutlery_not_selected_text'.tr,
                          style: robotoRegular.copyWith(
                              color: Theme.of(context).disabledColor,
                              fontSize: Dimensions.fontSizeDefault)),
                    ],
                  ),
                )
              : const SizedBox(),

          ResponsiveHelper.isDesktop(context)
              ? const SizedBox()
              : Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: ResponsiveHelper.isDesktop(context)
                        ? null
                        : BorderRadius.circular(Dimensions.radiusDefault),
                    border: ResponsiveHelper.isDesktop(context)
                        ? Border.all(
                            color: Theme.of(context).primaryColor, width: 0.5)
                        : null,
                    boxShadow: !ResponsiveHelper.isMobile(context)
                        ? [const BoxShadow()]
                        : [
                            const BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5,
                              spreadRadius: 1,
                            )
                          ],
                  ),
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  margin: ResponsiveHelper.isDesktop(context)
                      ? const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeDefault,
                          vertical: Dimensions.paddingSizeSmall)
                      : const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeDefault,
                        ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {
                          if (ResponsiveHelper.isDesktop(context)) {
                            Get.dialog(const Dialog(
                                child: NotAvailableBottomSheetWidget()));
                          } else {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (con) =>
                                  const NotAvailableBottomSheetWidget(),
                            );
                          }
                        },
                        child: Row(children: [
                          Expanded(
                              child: Text('if_any_product_is_not_available'.tr,
                                  style: robotoMedium,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis)),
                          const Icon(Icons.arrow_forward_ios_sharp, size: 18),
                        ]),
                      ),
                      cartController.notAvailableIndex != -1
                          ? Row(children: [
                              Text(
                                  cartController
                                      .notAvailableList[
                                          cartController.notAvailableIndex]
                                      .tr,
                                  style: robotoMedium.copyWith(
                                      fontSize: Dimensions.fontSizeSmall,
                                      color: Theme.of(context).primaryColor)),
                              IconButton(
                                onPressed: () =>
                                    cartController.setAvailableIndex(-1),
                                icon: const Icon(Icons.clear, size: 18),
                              )
                            ])
                          : const SizedBox(),
                    ],
                  ),
                ),
          ResponsiveHelper.isDesktop(context)
              ? const SizedBox()
              : const SizedBox(height: Dimensions.paddingSizeSmall),

          // Total
          ResponsiveHelper.isDesktop(context)
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeDefault,
                      vertical: Dimensions.paddingSizeSmall),
                  child: Column(children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('item_price'.tr, style: robotoRegular),
                          PriceConverter.convertAnimationPrice(
                              cartController.itemPrice,
                              textStyle: robotoRegular),
                        ]),
                    SizedBox(
                        height: cartController.variationPrice > 0
                            ? Dimensions.paddingSizeSmall
                            : 0),
                    Get.find<SplashController>()
                                .getModuleConfig(item.moduleType)
                                .newVariation! &&
                            cartController.variationPrice > 0
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('variations'.tr, style: robotoRegular),
                              Text(
                                  '(+) ${PriceConverter.convertPrice(cartController.variationPrice)}',
                                  style: robotoRegular,
                                  textDirection: TextDirection.ltr),
                            ],
                          )
                        : const SizedBox(),
                    const SizedBox(height: Dimensions.paddingSizeSmall),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('discount'.tr, style: robotoRegular),
                          storeController.store != null
                              ? Row(children: [
                                  Text('(-)', style: robotoRegular),
                                  PriceConverter.convertAnimationPrice(
                                      cartController.itemDiscountPrice,
                                      textStyle: robotoRegular),
                                ])
                              : Text('calculating'.tr, style: robotoRegular),
                          // Text('(-) ${PriceConverter.convertPrice(cartController.itemDiscountPrice)}', style: robotoRegular, textDirection: TextDirection.ltr),
                        ]),
                    SizedBox(
                        height: Get.find<SplashController>()
                                .configModel!
                                .moduleConfig!
                                .module!
                                .addOn!
                            ? 10
                            : 0),
                    Get.find<SplashController>()
                            .configModel!
                            .moduleConfig!
                            .module!
                            .addOn!
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('addons'.tr, style: robotoRegular),
                              Text(
                                  '(+) ${PriceConverter.convertPrice(cartController.addOns)}',
                                  style: robotoRegular,
                                  textDirection: TextDirection.ltr),
                            ],
                          )
                        : const SizedBox(),
                  ]),
                )
              : const SizedBox(),

          ResponsiveHelper.isDesktop(context)
              ? CheckoutButton(
                  cartController: cartController,
                  availableList: cartController.availableList)
              : const SizedBox.shrink(),
        ]);
      }),
    );
  }

  Widget suggestedItemView(List<CartModel> cartList) {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).cardColor),
      width: double.infinity,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        GetBuilder<StoreController>(builder: (storeController) {
          List<Item>? suggestedItems;
          if (storeController.cartSuggestItemModel != null) {
            suggestedItems = [];
            List<int> cartIds = [];
            for (CartModel cartItem in cartList) {
              cartIds.add(cartItem.item!.id!);
            }
            for (Item item in storeController.cartSuggestItemModel!.items!) {
              if (!cartIds.contains(item.id)) {
                suggestedItems.add(item);
              }
            }
          }
          return storeController.cartSuggestItemModel != null &&
                  suggestedItems!.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: Dimensions.paddingSizeSmall),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeDefault,
                          vertical: Dimensions.paddingSizeExtraSmall),
                      child: Text('you_may_also_like'.tr,
                          style: robotoMedium.copyWith(
                              fontSize: Dimensions.fontSizeDefault)),
                    ),
                    SizedBox(
                      height: ResponsiveHelper.isDesktop(context) ? 160 : 130,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: suggestedItems.length,
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.only(
                            left: ResponsiveHelper.isDesktop(context)
                                ? Dimensions.paddingSizeExtraSmall
                                : Dimensions.paddingSizeDefault),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: ResponsiveHelper.isDesktop(context)
                                ? const EdgeInsets.symmetric(vertical: 20)
                                : const EdgeInsets.symmetric(vertical: 10),
                            child: Container(
                              width: ResponsiveHelper.isDesktop(context)
                                  ? 500
                                  : 300,
                              padding: const EdgeInsets.only(
                                  right: Dimensions.paddingSizeSmall,
                                  left: Dimensions.paddingSizeExtraSmall),
                              margin: const EdgeInsets.only(
                                  right: Dimensions.paddingSizeSmall),
                              child: ItemWidget(
                                isStore: false,
                                item: suggestedItems![index],
                                fromCartSuggestion: true,
                                store: null,
                                index: index,
                                length: null,
                                isCampaign: false,
                                inStore: true,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                )
              : const SizedBox();
        }),
      ]),
    );
  }

  Future<void> showReferAndEarnSnackBar() async {
    String text = 'your_referral_discount_added_on_your_first_order'.tr;
    if (Get.find<ProfileController>().userInfoModel != null &&
        Get.find<ProfileController>().userInfoModel!.isValidForDiscount!) {
      showCustomSnackBar(text, isError: false);
    }
  }
}

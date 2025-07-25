import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:sannip/features/banner/controllers/banner_controller.dart';
import 'package:sannip/features/brands/controllers/brands_controller.dart';
import 'package:sannip/features/home/controllers/home_controller.dart';
import 'package:sannip/features/home/widgets/cashback_logo_widget.dart';
import 'package:sannip/features/home/widgets/cashback_dialog_widget.dart';
import 'package:sannip/features/home/widgets/module_view.dart';
import 'package:sannip/features/home/widgets/refer_bottom_sheet_widget.dart';
import 'package:sannip/features/item/controllers/campaign_controller.dart';
import 'package:sannip/features/category/controllers/category_controller.dart';
import 'package:sannip/features/coupon/controllers/coupon_controller.dart';
import 'package:sannip/features/flash_sale/controllers/flash_sale_controller.dart';
import 'package:sannip/features/language/controllers/language_controller.dart';
import 'package:sannip/features/location/controllers/location_controller.dart';
import 'package:sannip/features/location/domain/models/zone_response_model.dart';
import 'package:sannip/features/notification/controllers/notification_controller.dart';
import 'package:sannip/features/item/controllers/item_controller.dart';
import 'package:sannip/features/search/widgets/search_field_widget.dart';
import 'package:sannip/features/store/controllers/store_controller.dart';
import 'package:sannip/features/splash/controllers/splash_controller.dart';
import 'package:sannip/features/profile/controllers/profile_controller.dart';
import 'package:sannip/features/address/controllers/address_controller.dart';
import 'package:sannip/features/home/screens/modules/food_home_screen.dart';
import 'package:sannip/features/home/screens/modules/grocery_home_screen.dart';
import 'package:sannip/features/home/screens/modules/pharmacy_home_screen.dart';
import 'package:sannip/features/home/screens/modules/shop_home_screen.dart';
import 'package:sannip/features/parcel/controllers/parcel_controller.dart';
import 'package:sannip/helper/address_helper.dart';
import 'package:sannip/helper/auth_helper.dart';
import 'package:sannip/helper/responsive_helper.dart';
import 'package:sannip/helper/route_helper.dart';
import 'package:sannip/util/app_constants.dart';
import 'package:sannip/util/dimensions.dart';
import 'package:sannip/util/images.dart';
import 'package:sannip/util/styles.dart';
import 'package:sannip/common/widgets/item_view.dart';
import 'package:sannip/common/widgets/menu_drawer.dart';
import 'package:sannip/common/widgets/paginated_list_view.dart';
import 'package:sannip/common/widgets/web_menu_bar.dart';
import 'package:sannip/features/home/screens/web_new_home_screen.dart';
import 'package:sannip/features/home/widgets/filter_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sannip/features/parcel/screens/parcel_category_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static Future<void> loadData(bool reload, {bool fromModule = false}) async {
    Get.find<LocationController>().syncZoneData();
    Get.find<FlashSaleController>().setEmptyFlashSale(fromModule: fromModule);
    if (Get.find<SplashController>().module != null &&
        !Get.find<SplashController>()
            .configModel!
            .moduleConfig!
            .module!
            .isParcel!) {
      Get.find<BannerController>().getBannerList(reload);
      if (Get.find<SplashController>().module!.moduleType.toString() ==
          AppConstants.grocery) {
        Get.find<FlashSaleController>().getFlashSale(reload, false);
      }
      if (Get.find<SplashController>().module!.moduleType.toString() ==
          AppConstants.ecommerce) {
        Get.find<ItemController>().getFeaturedCategoriesItemList(false, false);
        Get.find<FlashSaleController>().getFlashSale(reload, false);
        Get.find<BrandsController>().getBrandList();
      }
      Get.find<BannerController>().getPromotionalBannerList(reload);
      Get.find<ItemController>().getDiscountedItemList(reload, false, 'all');
      Get.find<CategoryController>().getCategoryList(reload);
      Get.find<StoreController>().getPopularStoreList(reload, 'all', false);
      Get.find<CampaignController>().getBasicCampaignList(reload);
      Get.find<CampaignController>().getItemCampaignList(reload);
      Get.find<ItemController>().getPopularItemList(reload, 'all', false);
      Get.find<StoreController>().getLatestStoreList(reload, 'all', false);
      Get.find<ItemController>().getReviewedItemList(reload, 'all', false);
      Get.find<ItemController>().getRecommendedItemList(reload, 'all', false);
      Get.find<StoreController>().getStoreList(1, reload);
      Get.find<StoreController>().getRecommendedStoreList();
    }
    if (AuthHelper.isLoggedIn()) {
      Get.find<StoreController>()
          .getVisitAgainStoreList(fromModule: fromModule);
      await Get.find<ProfileController>().getUserInfo();
      Get.find<NotificationController>().getNotificationList(reload);
      Get.find<CouponController>().getCouponList();
    }
    Get.find<SplashController>().getModules();
    if (Get.find<SplashController>().module == null &&
        Get.find<SplashController>().configModel!.module == null) {
      Get.find<BannerController>().getFeaturedBanner();
      Get.find<StoreController>().getFeaturedStoreList();
      if (AuthHelper.isLoggedIn()) {
        Get.find<AddressController>().getAddressList();
      }
    }
    if (Get.find<SplashController>().module != null &&
        Get.find<SplashController>()
            .configModel!
            .moduleConfig!
            .module!
            .isParcel!) {
      Get.find<ParcelController>().getParcelCategoryList();
    }
    if (Get.find<SplashController>().module != null &&
        Get.find<SplashController>().module!.moduleType.toString() ==
            AppConstants.pharmacy) {
      Get.find<ItemController>().getBasicMedicine(reload, false);
      Get.find<StoreController>().getFeaturedStoreList();
      await Get.find<ItemController>().getCommonConditions(false);
      if (Get.find<ItemController>().commonConditions!.isNotEmpty) {
        Get.find<ItemController>().getConditionsWiseItem(
            Get.find<ItemController>().commonConditions![0].id!, false);
      }
    }
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool _showAlert = true;
  String? _message;
  bool onlyOnce = true;

  @override
  void initState() {
    super.initState();
    HomeScreen.loadData(false).then((value) {
      Get.find<SplashController>().getReferBottomSheetStatus();

      if ((Get.find<ProfileController>().userInfoModel?.isValidForDiscount ??
              false) &&
          Get.find<SplashController>().showReferBottomSheet) {
        _showReferBottomSheet();
      }
    });

    if (!ResponsiveHelper.isWeb()) {
      Get.find<LocationController>().getZone(
          AddressHelper.getUserAddressFromSharedPref()!.latitude,
          AddressHelper.getUserAddressFromSharedPref()!.longitude,
          false,
          updateInAddress: true);
    }

    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (Get.find<HomeController>().showFavButton) {
          Get.find<HomeController>().changeFavVisibility();
          Future.delayed(const Duration(milliseconds: 800),
              () => Get.find<HomeController>().changeFavVisibility());
        }
      } else {
        if (Get.find<HomeController>().showFavButton) {
          Get.find<HomeController>().changeFavVisibility();
          Future.delayed(const Duration(milliseconds: 800),
              () => Get.find<HomeController>().changeFavVisibility());
        }
      }
    });
    ZoneData? zoneData;
    for (var data in AddressHelper.getUserAddressFromSharedPref()!.zoneData!) {
      if (data.id == AddressHelper.getUserAddressFromSharedPref()!.zoneId) {
        if (data.increaseDeliveryFeeStatus == 1 &&
            data.increaseDeliveryFeeMessage != null) {
          zoneData = data;
        }
      }
    }

    if (zoneData != null) {
      _showAlert = zoneData.increaseDeliveryFeeStatus == 1;
      _message = zoneData.increaseDeliveryFeeMessage;
    } else {
      _showAlert = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void _showReferBottomSheet() {
    ResponsiveHelper.isDesktop(context)
        ? Get.dialog(
            Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(Dimensions.radiusExtraLarge)),
              insetPadding: const EdgeInsets.all(22),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: const ReferBottomSheetWidget(),
            ),
            useSafeArea: false,
          ).then((value) =>
            Get.find<SplashController>().saveReferBottomSheetStatus(false))
        : showModalBottomSheet(
            isScrollControlled: true,
            useRootNavigator: true,
            context: Get.context!,
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Dimensions.radiusExtraLarge),
                  topRight: Radius.circular(Dimensions.radiusExtraLarge)),
            ),
            builder: (context) {
              return ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.8),
                child: const ReferBottomSheetWidget(),
              );
            },
          ).then((value) =>
            Get.find<SplashController>().saveReferBottomSheetStatus(false));
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(builder: (splashController) {
      bool showMobileModule = !ResponsiveHelper.isDesktop(context) &&
          splashController.module == null &&
          splashController.configModel!.module == null;
      bool isParcel = splashController.module != null &&
          splashController.configModel!.moduleConfig!.module!.isParcel!;
      bool isPharmacy = splashController.module != null &&
          splashController.module!.moduleType.toString() ==
              AppConstants.pharmacy;
      bool isFood = splashController.module != null &&
          splashController.module!.moduleType.toString() == AppConstants.food;
      bool isShop = splashController.module != null &&
          splashController.module!.moduleType.toString() ==
              AppConstants.ecommerce;
      bool isGrocery = splashController.module != null &&
          splashController.module!.moduleType.toString() ==
              AppConstants.grocery;

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

      return GetBuilder<HomeController>(builder: (homeController) {
        return Scaffold(
          appBar:
              ResponsiveHelper.isDesktop(context) ? const WebMenuBar() : null,
          endDrawer:
              ResponsiveHelper.isDesktop(context) ? const MenuDrawer() : null,
          endDrawerEnableOpenDragGesture: false,
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: isParcel
              ? const ParcelCategoryScreen()
              : SafeArea(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      splashController.setRefreshing(true);
                      if (Get.find<SplashController>().module != null) {
                        await Get.find<LocationController>().syncZoneData();
                        await Get.find<BannerController>().getBannerList(true);
                        if (isGrocery) {
                          await Get.find<FlashSaleController>()
                              .getFlashSale(true, true);
                        }
                        await Get.find<BannerController>()
                            .getPromotionalBannerList(true);
                        await Get.find<ItemController>()
                            .getDiscountedItemList(true, false, 'all');
                        await Get.find<CategoryController>()
                            .getCategoryList(true);
                        await Get.find<StoreController>()
                            .getPopularStoreList(true, 'all', false);
                        await Get.find<CampaignController>()
                            .getItemCampaignList(true);
                        Get.find<CampaignController>()
                            .getBasicCampaignList(true);
                        await Get.find<ItemController>()
                            .getPopularItemList(true, 'all', false);
                        await Get.find<StoreController>()
                            .getLatestStoreList(true, 'all', false);
                        await Get.find<ItemController>()
                            .getReviewedItemList(true, 'all', false);
                        await Get.find<StoreController>().getStoreList(1, true);
                        if (AuthHelper.isLoggedIn()) {
                          await Get.find<ProfileController>().getUserInfo();
                          await Get.find<NotificationController>()
                              .getNotificationList(true);
                          Get.find<CouponController>().getCouponList();
                        }
                        if (isPharmacy) {
                          Get.find<ItemController>()
                              .getBasicMedicine(true, true);
                          Get.find<ItemController>().getCommonConditions(true);
                        }
                        if (isShop) {
                          await Get.find<FlashSaleController>()
                              .getFlashSale(true, true);
                          Get.find<ItemController>()
                              .getFeaturedCategoriesItemList(true, true);
                          Get.find<BrandsController>().getBrandList();
                        }
                      } else {
                        await Get.find<BannerController>().getFeaturedBanner();
                        await Get.find<SplashController>().getModules();
                        if (AuthHelper.isLoggedIn()) {
                          await Get.find<AddressController>().getAddressList();
                        }
                        await Get.find<StoreController>()
                            .getFeaturedStoreList();
                      }
                      splashController.setRefreshing(false);
                    },
                    child: ResponsiveHelper.isDesktop(context)
                        ? WebNewHomeScreen(
                            scrollController: _scrollController,
                          )
                        : Stack(
                            children: [
                              if (_showAlert &&
                                  _message != null &&
                                  _message!.isNotEmpty &&
                                  !showMobileModule &&
                                  _scrollController.hasClients)
                                Positioned.fill(
                                  child:
                                      Background(controller: _scrollController),
                                ),
                              CustomScrollView(
                                controller: _scrollController,
                                physics: const AlwaysScrollableScrollPhysics(),
                                slivers: [
                                  /// App Bar
                                  SliverAppBar(
                                    floating: true,
                                    elevation: 0,
                                    automaticallyImplyLeading: false,
                                    surfaceTintColor:
                                        Theme.of(context).colorScheme.surface,
                                    backgroundColor:
                                        ResponsiveHelper.isDesktop(context)
                                            ? Colors.transparent
                                            // : Theme.of(context)
                                            //     .colorScheme.surface,
                                            : Colors.transparent,
                                    title: Center(
                                        child: Container(
                                      width: Dimensions.webMaxWidth,
                                      height: Get.find<LocalizationController>()
                                              .isLtr
                                          ? 60
                                          : 70,
                                      color: Colors.transparent,
                                      // Theme.of(context).colorScheme.surface,
                                      child: Row(children: [
                                        ///UNCOMMENT THiS FOR MULTIPLE MODULES
                                        (splashController.module != null &&
                                                splashController
                                                        .configModel!.module ==
                                                    null)

                                            ///This is set too false in order to set FOOD MODULE as default module
                                            /*false*/
                                            // ignore: dead_code
                                            ? InkWell(
                                                onTap: () => splashController
                                                    .removeModule(),
                                                child: Image.asset(
                                                    Images.moduleIcon,
                                                    height: 25,
                                                    width: 25,
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge!
                                                        .color),
                                              )
                                            : const SizedBox(),
                                        SizedBox(
                                            width: (splashController.module !=
                                                        null &&
                                                    splashController
                                                            .configModel!
                                                            .module ==
                                                        null)
                                                ? Dimensions.paddingSizeSmall
                                                : 0),
                                        Expanded(
                                            child: InkWell(
                                          onTap: () =>
                                              Get.find<LocationController>()
                                                  .navigateToLocationScreen(
                                                      'home'),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical:
                                                  Dimensions.paddingSizeSmall,
                                              horizontal: ResponsiveHelper
                                                      .isDesktop(context)
                                                  ? Dimensions.paddingSizeSmall
                                                  : 0,
                                            ),
                                            child:
                                                GetBuilder<LocationController>(
                                                    builder:
                                                        (locationController) {
                                              return Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      AddressHelper
                                                              .getUserAddressFromSharedPref()!
                                                          .addressType!
                                                          .tr,
                                                      style: robotoMedium.copyWith(
                                                          color:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyLarge!
                                                                  .color,
                                                          fontSize: Dimensions
                                                              .fontSizeDefault),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    Row(children: [
                                                      Flexible(
                                                        child: Text(
                                                          AddressHelper
                                                                  .getUserAddressFromSharedPref()!
                                                              .address!,
                                                          style: robotoRegular.copyWith(
                                                              color: Theme.of(
                                                                      context)
                                                                  .disabledColor,
                                                              fontSize: Dimensions
                                                                  .fontSizeSmall),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                      Icon(Icons.expand_more,
                                                          color: Theme.of(
                                                                  context)
                                                              .disabledColor,
                                                          size: 18),
                                                    ]),
                                                  ]);
                                            }),
                                          ),
                                        )),
                                        InkWell(
                                          child: GetBuilder<
                                                  NotificationController>(
                                              builder:
                                                  (notificationController) {
                                            return Stack(children: [
                                              Image.asset(
                                                Images.notificationIcon,
                                                height: 22,
                                                width: 22,
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .color,
                                              ),
                                              // Icon(CupertinoIcons.bell,
                                              //     size: 25,
                                              //     color: Theme.of(context)
                                              //         .textTheme
                                              //         .bodyLarge!
                                              //         .color),
                                              notificationController
                                                      .hasNotification
                                                  ? Positioned(
                                                      top: 0,
                                                      right: 0,
                                                      child: Container(
                                                        height: 10,
                                                        width: 10,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          shape:
                                                              BoxShape.circle,
                                                          border: Border.all(
                                                              width: 1,
                                                              color: Theme.of(
                                                                      context)
                                                                  .cardColor),
                                                        ),
                                                      ))
                                                  : const SizedBox(),
                                            ]);
                                          }),
                                          onTap: () => Get.toNamed(RouteHelper
                                              .getNotificationRoute()),
                                        ),
                                      ]),
                                    )),
                                  ),

                                  /// Search Button
                                  !showMobileModule
                                      ? SliverPersistentHeader(
                                          pinned: true,
                                          delegate: SliverDelegate(
                                              child: Center(
                                                  child: Container(
                                            height: 50,
                                            width: Dimensions.webMaxWidth,
                                            // color: Theme.of(context).colorScheme.background,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: Dimensions
                                                    .paddingSizeSmall),
                                            child: InkWell(
                                              onTap: () => Get.toNamed(
                                                  RouteHelper.getSearchRoute()),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: Dimensions
                                                            .paddingSizeSmall),
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 3),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  /* border: Border.all(
                                                  color: Theme.of(context)
                                                      .primaryColor
                                                      .withOpacity(0.2),
                                                  width: 1), */
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          Dimensions
                                                              .radiusDefault),
                                                  /*  boxShadow: const [
                                                BoxShadow(
                                                    color: Colors.black12,
                                                    blurRadius: 5,
                                                    spreadRadius: 1)
                                              ], */
                                                ),
                                                child: Row(children: [
                                                  Expanded(
                                                      child: Text(
                                                    Get.find<SplashController>()
                                                            .configModel!
                                                            .moduleConfig!
                                                            .module!
                                                            .showRestaurantText!
                                                        ? 'search_food_or_restaurant'
                                                            .tr
                                                        : 'search_item_or_store'
                                                            .tr,
                                                    style:
                                                        robotoRegular.copyWith(
                                                      fontSize: Dimensions
                                                          .fontSizeSmall,
                                                      color: Theme.of(context)
                                                          .hintColor,
                                                    ),
                                                  )),
                                                  const SizedBox(
                                                      width: Dimensions
                                                          .paddingSizeExtraSmall),
                                                  Icon(
                                                    CupertinoIcons.search,
                                                    size: 25,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                ]),
                                              ),
                                            ),
                                          ))),
                                        )
                                      : SliverPersistentHeader(
                                          pinned: true,
                                          delegate: SliverDelegate(
                                              child: Center(
                                                  child: Container(
                                            height: 48,
                                            width: Dimensions.webMaxWidth,
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 0, horizontal: 8),
                                            decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        Dimensions
                                                            .radiusDefault)),
                                            child: Row(children: [
                                              Expanded(
                                                  child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        Dimensions
                                                            .radiusDefault),
                                                child: SearchFieldWidget(
                                                  controller: _searchController,
                                                  hint:
                                                      "${'search'.tr} ${'store'.tr}",
                                                  filledColor: Colors.grey[200],
                                                  iconColor: Theme.of(context)
                                                      .primaryColor,
                                                  suffixIcon:
                                                      CupertinoIcons.search,
                                                  iconPressed: () {},
                                                  onSubmit: (text) {},
                                                  onChanged: (text) {},
                                                ),
                                              )),
                                            ]),
                                          )))),

                                  SliverToBoxAdapter(
                                    child: Center(
                                        child: SizedBox(
                                            width: Dimensions.webMaxWidth,
                                            child: !showMobileModule
                                                ? Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                        isGrocery
                                                            ? const GroceryHomeScreen()
                                                            : isPharmacy
                                                                ? const PharmacyHomeScreen()
                                                                : isFood
                                                                    ? const FoodHomeScreen()
                                                                    : isShop
                                                                        ? const ShopHomeScreen()
                                                                        : const SizedBox(),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  Get.find<LocalizationController>()
                                                                          .isLtr
                                                                      ? 10
                                                                      : 0,
                                                                  15,
                                                                  0,
                                                                  5),
                                                          child: GetBuilder<
                                                                  StoreController>(
                                                              builder:
                                                                  (storeController) {
                                                            return Row(
                                                                children: [
                                                                  Expanded(
                                                                      child:
                                                                          Padding(
                                                                    padding: EdgeInsets.only(
                                                                        right: Get.find<LocalizationController>().isLtr
                                                                            ? 0
                                                                            : 10),
                                                                    child: Text(
                                                                      '${storeController.storeModel?.totalSize ?? 0} ${Get.find<SplashController>().configModel!.moduleConfig!.module!.showRestaurantText! ? 'restaurants'.tr : 'stores'.tr}',
                                                                      style: robotoMedium.copyWith(
                                                                          fontSize:
                                                                              Dimensions.fontSizeLarge),
                                                                    ),
                                                                  )),
                                                                  FilterView(
                                                                      storeController:
                                                                          storeController),
                                                                ]);
                                                          }),
                                                        ),
                                                        GetBuilder<
                                                                StoreController>(
                                                            builder:
                                                                (storeController) {
                                                          return PaginatedListView(
                                                            scrollController:
                                                                _scrollController,
                                                            totalSize:
                                                                storeController
                                                                    .storeModel
                                                                    ?.totalSize,
                                                            offset:
                                                                storeController
                                                                    .storeModel
                                                                    ?.offset,
                                                            onPaginate: (int?
                                                                    offset) async =>
                                                                await storeController
                                                                    .getStoreList(
                                                                        offset!,
                                                                        false),
                                                            itemView: ItemsView(
                                                              isStore: true,
                                                              items: null,
                                                              isFoodOrGrocery:
                                                                  (isFood ||
                                                                      isGrocery ||
                                                                      isShop),
                                                              stores:
                                                                  storeController
                                                                      .storeModel
                                                                      ?.stores,
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                horizontal: ResponsiveHelper
                                                                        .isDesktop(
                                                                            context)
                                                                    ? Dimensions
                                                                        .paddingSizeExtraSmall
                                                                    : Dimensions
                                                                        .paddingSizeSmall,
                                                                vertical: ResponsiveHelper
                                                                        .isDesktop(
                                                                            context)
                                                                    ? Dimensions
                                                                        .paddingSizeExtraSmall
                                                                    : Dimensions
                                                                        .paddingSizeDefault,
                                                              ),
                                                            ),
                                                          );
                                                        }),
                                                        SizedBox(
                                                            height: ResponsiveHelper
                                                                    .isDesktop(
                                                                        context)
                                                                ? 0
                                                                : 40),
                                                      ])
                                                :

                                                ///UNCOMMENT THiS FOR MULTIPLE MODULES
                                                ValueListenableBuilder(
                                                    valueListenable:
                                                        _searchController,
                                                    builder: (context, val,
                                                        widgett) {
                                                      return ModuleView(
                                                        splashController:
                                                            splashController,
                                                        searchedText: val.text,
                                                      );
                                                    })
                                            // const SizedBox(),
                                            )),
                                  ),
                                  !showMobileModule
                                      ? SliverToBoxAdapter(
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Image.asset(
                                              Images.sannipTextLogo,
                                              // height: 70,
                                              width: 100,
                                              fit: BoxFit.contain,
                                              color:
                                                  Colors.grey.withOpacity(0.9),
                                            ),
                                          ),
                                        )
                                      : ResponsiveHelper.isDesktop(context)
                                          ? const SliverToBoxAdapter(
                                              child: SizedBox())
                                          : SliverToBoxAdapter(
                                              child: Container(
                                                alignment: Alignment.centerLeft,
                                                padding: const EdgeInsets.only(
                                                    left: Dimensions
                                                        .paddingSizeSmall),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Live\nit up!',
                                                      style:
                                                          robotoBlack.copyWith(
                                                              height: 0.8,
                                                              fontSize: 100,
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      0.9)),
                                                    ),
                                                    const SizedBox(
                                                      height: Dimensions
                                                          .paddingSizeDefault,
                                                    ),
                                                    Text(
                                                      'Crafted with ❤️ in Bailhongal, Karnataka',
                                                      style: robotoRegular.copyWith(
                                                          fontSize: Dimensions
                                                              .fontSizeDefault,
                                                          color: Colors.grey
                                                              .withOpacity(
                                                                  0.9)),
                                                    ),
                                                    const SizedBox(height: 30)
                                                  ],
                                                ),
                                              ),
                                            ),
                                  const SliverToBoxAdapter(
                                    child: SizedBox(height: 80),
                                  ),
                                ],
                              ),
                            ],
                          ),
                  ),
                ),
          floatingActionButton: AuthHelper.isLoggedIn() &&
                  homeController.cashBackOfferList != null &&
                  homeController.cashBackOfferList!.isNotEmpty
              ? homeController.showFavButton
                  ? Padding(
                      padding: EdgeInsets.only(
                          bottom: 50.0,
                          right: ResponsiveHelper.isDesktop(context) ? 50 : 0),
                      child: InkWell(
                        onTap: () => Get.dialog(const CashBackDialogWidget()),
                        child: const CashBackLogoWidget(),
                      ),
                    )
                  : null
              : null,
        );
      });
    });
  }

  String extractCityName(String address) {
    // Split the string by commas and return
    return address.split(',')[2].trim();
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;

  SliverDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 50 ||
        oldDelegate.minExtent != 50 ||
        child != oldDelegate.child;
  }
}

class Background extends StatefulWidget {
  const Background({
    super.key,
    required this.controller,
  });

  final ScrollController controller;
  @override
  State<Background> createState() => _BackgroundState();
}

class _BackgroundState extends State<Background> {
  bool isReady = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        isReady = true;
      });
    });
    widget.controller.addListener(_listener);
    super.initState();
  }

  void _listener() {
    setState(() {});
  }

  @override
  void dispose() {
    widget.controller.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Image(
      image: Image.asset(
        Images.rainGif,
      ).image,
      repeat: ImageRepeat.noRepeat,
      alignment: widget.controller.offset == 0.0
          ? Alignment.topCenter
          : Alignment(
              0,
              !isReady
                  ? 0
                  : -(widget.controller.offset + 300) /
                      MediaQuery.of(context).size.height *
                      3,
            ),
    );
  }
}

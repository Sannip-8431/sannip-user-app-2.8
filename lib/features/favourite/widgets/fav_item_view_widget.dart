import 'package:sannip/features/favourite/controllers/favourite_controller.dart';
import 'package:sannip/features/splash/controllers/splash_controller.dart';
import 'package:sannip/helper/responsive_helper.dart';
import 'package:sannip/util/dimensions.dart';
import 'package:sannip/common/widgets/footer_view.dart';
import 'package:sannip/common/widgets/item_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sannip/util/images.dart';
import 'package:sannip/util/styles.dart';

class FavItemViewWidget extends StatelessWidget {
  final bool isStore;
  final bool isSearch;
  const FavItemViewWidget(
      {super.key, required this.isStore, this.isSearch = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<FavouriteController>(builder: (favouriteController) {
        return RefreshIndicator(
          onRefresh: () async {
            await favouriteController.getFavouriteList();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: FooterView(
              child: SizedBox(
                width: Dimensions.webMaxWidth,
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: ResponsiveHelper.isDesktop(context) ? 0 : 80.0),
                  child: isStore
                      ? (favouriteController.wishStoreList?.isEmpty ??
                              false ||
                                  favouriteController.wishStoreList == null)
                          ? Column(
                              children: [
                                Image.asset(
                                  Images.noFavouriteImage,
                                ),
                                Text(
                                  Get.find<SplashController>()
                                          .configModel!
                                          .moduleConfig!
                                          .module!
                                          .showRestaurantText!
                                      ? 'no_restaurant_available'.tr
                                      : 'no_store_available'.tr,
                                  style: robotoMedium.copyWith(
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.0175,
                                      color: Theme.of(context).disabledColor),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            )
                          : ItemsView(
                              isStore: isStore,
                              items: favouriteController.wishItemList,
                              stores: favouriteController.wishStoreList,
                              noDataText: 'no_wish_data_found'.tr,
                              isFeatured: true,
                            )
                      : (favouriteController.wishItemList?.isEmpty ??
                              false || favouriteController.wishItemList == null)
                          ? Column(
                              children: [
                                Image.asset(
                                  Images.noFavouriteImage,
                                ),
                                Text(
                                  'no_item_available'.tr,
                                  style: robotoMedium.copyWith(
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.0175,
                                      color: Theme.of(context).disabledColor),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            )
                          : ItemsView(
                              isStore: isStore,
                              items: favouriteController.wishItemList,
                              stores: favouriteController.wishStoreList,
                              noDataText: 'no_wish_data_found'.tr,
                              isFeatured: true,
                            ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

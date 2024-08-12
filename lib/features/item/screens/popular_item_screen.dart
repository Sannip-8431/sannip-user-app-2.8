import 'package:sannip/features/item/controllers/item_controller.dart';
import 'package:sannip/features/splash/controllers/splash_controller.dart';
import 'package:sannip/util/app_constants.dart';
import 'package:sannip/util/dimensions.dart';
import 'package:sannip/common/widgets/custom_app_bar.dart';
import 'package:sannip/common/widgets/footer_view.dart';
import 'package:sannip/common/widgets/item_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sannip/common/widgets/menu_drawer.dart';
import 'package:sannip/common/widgets/web_page_title_widget.dart';

class PopularItemScreen extends StatefulWidget {
  final bool isPopular;
  final bool isSpecial;
  const PopularItemScreen(
      {super.key, required this.isPopular, required this.isSpecial});

  @override
  State<PopularItemScreen> createState() => _PopularItemScreenState();
}

class _PopularItemScreenState extends State<PopularItemScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    if (widget.isPopular) {
      Get.find<ItemController>().getPopularItemList(
          true, Get.find<ItemController>().popularType, false);
    } else if (widget.isSpecial) {
      Get.find<ItemController>().getDiscountedItemList(
          true, false, Get.find<ItemController>().discountedType);
    } else {
      Get.find<ItemController>().getReviewedItemList(
          true, Get.find<ItemController>().reviewType, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isShop = Get.find<SplashController>().module != null &&
        Get.find<SplashController>().module!.moduleType.toString() ==
            AppConstants.ecommerce;

    return GetBuilder<ItemController>(builder: (itemController) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: CustomAppBar(
          key: scaffoldKey,
          title: widget.isPopular
              ? isShop
                  ? 'trending_products'.tr
                  : 'trending_items'.tr
              : widget.isSpecial
                  ? 'amazing_deal'.tr
                  : 'top_rated_items'.tr,
          showCart: true,
          type: widget.isPopular
              ? itemController.popularType
              : widget.isSpecial
                  ? itemController.discountedType
                  : itemController.reviewType,
          onVegFilterTap: (String type) {
            if (widget.isPopular) {
              itemController.getPopularItemList(true, type, true);
            } else if (widget.isSpecial) {
              itemController.getDiscountedItemList(true, true, type);
            } else {
              itemController.getReviewedItemList(true, type, true);
            }
          },
        ),
        endDrawer: const MenuDrawer(),
        endDrawerEnableOpenDragGesture: false,
        body: SingleChildScrollView(
            child: FooterView(
                child: Column(
          children: [
            WebScreenTitleWidget(
              title: widget.isPopular
                  ? isShop
                      ? 'trending_products'.tr
                      : 'trending_items'.tr
                  : widget.isSpecial
                      ? 'amazing_deal'.tr
                      : 'top_rated_items'.tr,
            ),
            SizedBox(
              width: Dimensions.webMaxWidth,
              child: ItemsView(
                isStore: false,
                stores: null,
                items: widget.isPopular
                    ? itemController.popularItemList
                    : widget.isSpecial
                        ? itemController.discountedItemList
                        : itemController.reviewedItemList,
              ),
            ),
          ],
        ))),
      );
    });
  }
}

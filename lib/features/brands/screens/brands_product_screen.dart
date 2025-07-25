import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sannip/common/widgets/custom_app_bar.dart';
import 'package:sannip/common/widgets/footer_view.dart';
import 'package:sannip/common/widgets/item_view.dart';
import 'package:sannip/common/widgets/menu_drawer.dart';
import 'package:sannip/common/widgets/web_page_title_widget.dart';
import 'package:sannip/features/brands/controllers/brands_controller.dart';
import 'package:sannip/helper/responsive_helper.dart';
import 'package:sannip/util/dimensions.dart';

class BrandsItemScreen extends StatefulWidget {
  final int brandId;
  final String brandName;
  const BrandsItemScreen(
      {super.key, required this.brandId, required this.brandName});

  @override
  State<BrandsItemScreen> createState() => _BrandsItemScreenState();
}

class _BrandsItemScreenState extends State<BrandsItemScreen> {
  @override
  void initState() {
    Get.find<BrandsController>().getBrandItemList(widget.brandId, 1, false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = ResponsiveHelper.isDesktop(context);

    return Scaffold(
      appBar: CustomAppBar(title: widget.brandName),
      endDrawer: const MenuDrawer(),
      endDrawerEnableOpenDragGesture: false,
      body: GetBuilder<BrandsController>(builder: (brandsController) {
        return SingleChildScrollView(
          child: FooterView(
            child: Column(children: [
              WebScreenTitleWidget(title: widget.brandName),
              SizedBox(
                width: Dimensions.webMaxWidth,
                child: brandsController.brandItemModel != null
                    ? brandsController.brandItemModel!.items!.isNotEmpty
                        ? ItemsView(
                            isStore: false,
                            items: brandsController.brandItemModel!.items,
                            stores: null,
                            noDataText: 'no_brand_item_found'.tr,
                          )
                        : Center(
                            child: Padding(
                                padding: EdgeInsets.only(
                                    top: isDesktop
                                        ? context.height * 0.3
                                        : context.height * 0.4),
                                child: Text('no_brand_item_found'.tr)))
                    : const BrandItemScreenShimmer(),
              ),
            ]),
          ),
        );
      }),
    );
  }
}

class BrandItemScreenShimmer extends StatelessWidget {
  const BrandItemScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveHelper.isDesktop(context)
        ? GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisExtent: 150,
            ),
            itemCount: 12,
            itemBuilder: (context, index) {
              return Shimmer(
                duration: const Duration(seconds: 2),
                enabled: true,
                colorOpacity: 0.1,
                child: Container(
                  height: 100,
                  margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    color: Get.isDarkMode
                        ? Colors.white.withOpacity(0.05)
                        : Colors.grey[300],
                    borderRadius:
                        BorderRadius.circular(Dimensions.radiusDefault),
                    boxShadow: [
                      BoxShadow(
                          color: Get.isDarkMode
                              ? Colors.black12
                              : Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 1))
                    ],
                  ),
                  child: Row(children: [
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(Dimensions.radiusDefault),
                        color: Get.isDarkMode
                            ? Theme.of(context).disabledColor.withOpacity(0.2)
                            : Theme.of(context).cardColor,
                      ),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                height: 20,
                                width: double.maxFinite,
                                color: Get.isDarkMode
                                    ? Theme.of(context)
                                        .disabledColor
                                        .withOpacity(0.2)
                                    : Theme.of(context).cardColor),
                            const SizedBox(height: Dimensions.paddingSizeSmall),
                            Container(
                                height: 15,
                                width: double.maxFinite,
                                color: Get.isDarkMode
                                    ? Theme.of(context)
                                        .disabledColor
                                        .withOpacity(0.2)
                                    : Theme.of(context).cardColor),
                            const SizedBox(height: Dimensions.paddingSizeSmall),
                            Container(
                                height: 15,
                                width: double.maxFinite,
                                color: Get.isDarkMode
                                    ? Theme.of(context)
                                        .disabledColor
                                        .withOpacity(0.2)
                                    : Theme.of(context).cardColor),
                          ]),
                    ),
                  ]),
                ),
              );
            },
          )
        : ListView.builder(
            itemCount: 8,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Shimmer(
                duration: const Duration(seconds: 2),
                enabled: true,
                colorOpacity: 0.1,
                child: Container(
                  height: 100,
                  margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    color: Get.isDarkMode
                        ? Colors.white.withOpacity(0.05)
                        : Colors.grey[300],
                    borderRadius:
                        BorderRadius.circular(Dimensions.radiusDefault),
                    boxShadow: [
                      BoxShadow(
                          color: Get.isDarkMode
                              ? Colors.black12
                              : Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 1))
                    ],
                  ),
                  child: Row(children: [
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(Dimensions.radiusDefault),
                        color: Get.isDarkMode
                            ? Theme.of(context).disabledColor.withOpacity(0.2)
                            : Theme.of(context).cardColor,
                      ),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                height: 20,
                                width: double.maxFinite,
                                color: Get.isDarkMode
                                    ? Theme.of(context)
                                        .disabledColor
                                        .withOpacity(0.2)
                                    : Theme.of(context).cardColor),
                            const SizedBox(height: Dimensions.paddingSizeSmall),
                            Container(
                                height: 15,
                                width: double.maxFinite,
                                color: Get.isDarkMode
                                    ? Theme.of(context)
                                        .disabledColor
                                        .withOpacity(0.2)
                                    : Theme.of(context).cardColor),
                            const SizedBox(height: Dimensions.paddingSizeSmall),
                            Container(
                                height: 15,
                                width: double.maxFinite,
                                color: Get.isDarkMode
                                    ? Theme.of(context)
                                        .disabledColor
                                        .withOpacity(0.2)
                                    : Theme.of(context).cardColor),
                          ]),
                    ),
                  ]),
                ),
              );
            },
          );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sannip/features/item/controllers/item_controller.dart';
import 'package:sannip/features/item/domain/models/item_model.dart';
import 'package:sannip/helper/route_helper.dart';
import 'package:sannip/util/dimensions.dart';
import 'package:sannip/util/images.dart';
import 'package:sannip/common/widgets/title_widget.dart';
import 'package:sannip/common/widgets/card_design/item_card.dart';

class SpecialOfferView extends StatelessWidget {
  final bool isFood;
  final bool isShop;
  const SpecialOfferView(
      {super.key, required this.isFood, required this.isShop});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ItemController>(builder: (itemController) {
      List<Item>? discountedItemList = itemController.discountedItemList;

      return discountedItemList != null
          ? discountedItemList.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: Dimensions.paddingSizeDefault),
                  child: Container(
                    // decoration: const BoxDecoration(
                    //   image: DecorationImage(
                    //     image: AssetImage(Images.specialBGImage),
                    //     fit: BoxFit.cover,
                    //   ),
                    // ),
                    color: Theme.of(context).disabledColor.withOpacity(0.1),
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: Dimensions.paddingSizeDefault,
                            left: Dimensions.paddingSizeDefault,
                            right: Dimensions.paddingSizeDefault),
                        child: TitleWidget(
                          title: 'special_offer'.tr,
                          image: Images.discountOfferIcon,
                          onTap: () => Get.toNamed(
                              RouteHelper.getPopularItemRoute(false, true)),
                        ),
                      ),
                      SizedBox(
                        height: !isFood && !isShop ? 248 : 228,
                        width: Get.width,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.only(
                              left: Dimensions.paddingSizeDefault),
                          itemCount: discountedItemList.length,
                          itemBuilder: (context, index) {
                            return Get.find<ItemController>()
                                    .isAvailable(discountedItemList[index])
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: Dimensions.paddingSizeDefault,
                                        right: Dimensions.paddingSizeDefault,
                                        top: Dimensions.paddingSizeDefault),
                                    child: SpecialOfferItemCard(
                                        item: discountedItemList[index],
                                        isPopularItem: false,
                                        isFood: isFood,
                                        isShop: isShop),
                                  )
                                : const SizedBox();
                          },
                        ),
                      ),
                    ]),
                  ),
                )
              : const SizedBox()
          : const ItemShimmerView(
              isPopularItem: false,
              isDesignChange: true,
            );
    });
  }
}

class ItemShimmerView extends StatelessWidget {
  final bool isPopularItem;
  final bool isDesignChange;
  const ItemShimmerView(
      {super.key, required this.isPopularItem, this.isDesignChange = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
      child: Container(
        color: Theme.of(context).disabledColor.withOpacity(0.1),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(
                top: Dimensions.paddingSizeDefault,
                left: Dimensions.paddingSizeDefault,
                right: Dimensions.paddingSizeDefault),
            child: TitleWidget(
              title:
                  isPopularItem ? 'most_popular_items'.tr : 'special_offer'.tr,
              image: isPopularItem
                  ? Images.mostPopularIcon
                  : Images.discountOfferIcon,
            ),
          ),
          SizedBox(
            height: isDesignChange ? 225 : 285,
            width: Get.width,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              padding:
                  const EdgeInsets.only(left: Dimensions.paddingSizeDefault),
              itemCount: 6,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(
                      bottom: Dimensions.paddingSizeDefault,
                      right: Dimensions.paddingSizeDefault,
                      top: Dimensions.paddingSizeDefault),
                  child: Shimmer(
                    duration: const Duration(seconds: 2),
                    enabled: true,
                    child: Container(
                      height: isDesignChange ? 225 : 285,
                      width: isDesignChange ? 90 : 200,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius:
                            BorderRadius.circular(Dimensions.radiusLarge),
                      ),
                      child: Column(children: [
                        Container(
                          height: isDesignChange ? 70 : 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius:
                                BorderRadius.circular(Dimensions.radiusLarge),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.all(Dimensions.paddingSizeSmall),
                          child: Column(children: [
                            Container(
                              height: 20,
                              width: isDesignChange ? 50 : 100,
                              color: Colors.grey[300],
                            ),
                            const SizedBox(height: Dimensions.paddingSizeSmall),
                            Container(
                              height: 20,
                              width: isDesignChange ? 100 : 200,
                              color: Colors.grey[300],
                            ),
                            const SizedBox(height: Dimensions.paddingSizeSmall),
                            Container(
                              height: 20,
                              width: isDesignChange ? 50 : 100,
                              color: Colors.grey[300],
                            ),
                          ]),
                        ),
                      ]),
                    ),
                  ),
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}

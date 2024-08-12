import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sannip/features/splash/controllers/splash_controller.dart';
import 'package:sannip/util/app_constants.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sannip/common/widgets/custom_ink_well.dart';
import 'package:sannip/features/item/controllers/item_controller.dart';
import 'package:sannip/features/item/domain/models/item_model.dart';
import 'package:sannip/features/home/widgets/components/review_item_card_widget.dart';
import 'package:sannip/helper/route_helper.dart';
import 'package:sannip/util/dimensions.dart';
import 'package:sannip/common/widgets/title_widget.dart';

class BestReviewItemView extends StatefulWidget {
  const BestReviewItemView({super.key});

  @override
  State<BestReviewItemView> createState() => _BestReviewItemViewState();
}

class _BestReviewItemViewState extends State<BestReviewItemView> {
  ScrollController scrollController = ScrollController();
  bool isFood = Get.find<SplashController>().module != null &&
      Get.find<SplashController>().module!.moduleType.toString() ==
          AppConstants.food;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ItemController>(builder: (itemController) {
      List<Item>? reviewItemList = itemController.reviewedItemList;

      return Container(
        color: Colors.green.withOpacity(0.1),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: Dimensions.paddingSizeSmall,
                horizontal: Dimensions.paddingSizeDefault),
            child: TitleWidget(
              title: 'top_rated_items'.tr,
              onTap: () =>
                  Get.toNamed(RouteHelper.getPopularItemRoute(false, false)),
            ),
          ),
          SizedBox(
            height: !isFood ? 248 : 233,
            width: Get.width,
            child: reviewItemList != null
                ? ListView.builder(
                    controller: scrollController,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(
                        left: Dimensions.paddingSizeDefault),
                    itemCount: reviewItemList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: Dimensions.paddingSizeDefault,
                          right: Dimensions.paddingSizeDefault,
                        ),
                        child: CustomInkWell(
                          onTap: () => Get.find<ItemController>()
                              .navigateToItemPage(
                                  reviewItemList[index], context),
                          child: BestReviewItemCard(
                            item: itemController.reviewedItemList![index],
                          ),
                        ),
                      );
                    },
                  )
                : const BestReviewItemShimmer(),
          ),
        ]),
      );
    });
  }
}

class BestReviewItemShimmer extends StatelessWidget {
  const BestReviewItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault),
      itemCount: 8,
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
              width: 135,
              height: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                color: Colors.grey[300],
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Stack(children: [
                        Padding(
                          padding: const EdgeInsets.all(
                              Dimensions.paddingSizeExtraSmall),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                                Radius.circular(Dimensions.radiusSmall)),
                            child: Container(
                              color: Colors.grey[300],
                              width: 210,
                              height: 285,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Icon(Icons.favorite,
                              size: 20, color: Theme.of(context).cardColor),
                        ),
                      ]),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        height: 100,
                        width: double.infinity,
                        padding:
                            const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topLeft:
                                    Radius.circular(Dimensions.radiusDefault),
                                topRight:
                                    Radius.circular(Dimensions.radiusDefault)),
                            color: Theme.of(context).cardColor),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 100,
                                height: 10,
                                color: Colors.grey[300],
                              ),
                              const SizedBox(
                                  height: Dimensions.paddingSizeSmall),
                              Container(
                                width: 100,
                                height: 10,
                                color: Colors.grey[300],
                              ),
                              const SizedBox(
                                  height: Dimensions.paddingSizeSmall),
                              Container(
                                width: 100,
                                height: 10,
                                color: Colors.grey[300],
                              ),
                            ]),
                      ),
                    )
                  ]),
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sannip/helper/responsive_helper.dart';
import 'package:sannip/util/dimensions.dart';
import 'package:sannip/common/widgets/title_widget.dart';

class StoreDetailsScreenShimmerWidget extends StatelessWidget {
  const StoreDetailsScreenShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: ResponsiveHelper.isMobile(context)
          ? Column(children: [
              Shimmer(
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Theme.of(context).shadowColor,
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(Dimensions.radiusLarge)),
                  ),
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              Container(
                height: 110,
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                margin: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeDefault),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  border: Border.all(color: Theme.of(context).shadowColor),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusSmall),
                      child: Shimmer(
                        child: Container(
                          height: 90,
                          width: 90,
                          decoration: BoxDecoration(
                            color: Theme.of(context).shadowColor,
                            borderRadius:
                                BorderRadius.circular(Dimensions.radiusSmall),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeLarge),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(),
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(Dimensions.radiusSmall),
                            child: Shimmer(
                              child: Container(
                                height: 10,
                                width: 150,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).shadowColor,
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radiusSmall),
                                ),
                              ),
                            ),
                          ),
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(Dimensions.radiusSmall),
                            child: Shimmer(
                              child: Container(
                                height: 10,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).shadowColor,
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radiusSmall),
                                ),
                              ),
                            ),
                          ),
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(Dimensions.radiusSmall),
                            child: Shimmer(
                              child: Container(
                                height: 10,
                                width: 150,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).shadowColor,
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radiusSmall),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(),
                        ]),
                    const Spacer(),
                    Icon(Icons.favorite_border,
                        size: 25, color: Theme.of(context).shadowColor),
                    const SizedBox(width: Dimensions.paddingSizeSmall),
                    Icon(Icons.share,
                        size: 25, color: Theme.of(context).shadowColor),
                  ],
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),
              Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeDefault),
                padding: const EdgeInsets.symmetric(
                    vertical: Dimensions.paddingSizeLarge),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  border: Border.all(color: Theme.of(context).shadowColor),
                ),
                child: Column(children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(children: [
                          Icon(Icons.star,
                              color: Theme.of(context).shadowColor),
                          const SizedBox(
                              height: Dimensions.paddingSizeExtraSmall),
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(Dimensions.radiusSmall),
                            child: Shimmer(
                              child: Container(
                                height: 10,
                                width: 70,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).shadowColor,
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radiusSmall),
                                ),
                              ),
                            ),
                          ),
                        ]),
                        Column(children: [
                          Icon(Icons.location_on,
                              color: Theme.of(context).shadowColor),
                          const SizedBox(
                              height: Dimensions.paddingSizeExtraSmall),
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(Dimensions.radiusSmall),
                            child: Shimmer(
                              child: Container(
                                height: 10,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).shadowColor,
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radiusSmall),
                                ),
                              ),
                            ),
                          ),
                        ]),
                        Column(children: [
                          Icon(Icons.timer_rounded,
                              color: Theme.of(context).shadowColor),
                          const SizedBox(
                              height: Dimensions.paddingSizeExtraSmall),
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(Dimensions.radiusSmall),
                            child: Shimmer(
                              child: Container(
                                height: 10,
                                width: 70,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).shadowColor,
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radiusSmall),
                                ),
                              ),
                            ),
                          ),
                        ]),
                      ]),
                ]),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              ListView.builder(
                itemCount: 5,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        bottom: Dimensions.paddingSizeSmall),
                    child: Container(
                      height: 90,
                      padding:
                          const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      margin: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeDefault),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(Dimensions.radiusSmall),
                        border:
                            Border.all(color: Theme.of(context).shadowColor),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(Dimensions.radiusSmall),
                            child: Shimmer(
                              child: Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).shadowColor,
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radiusSmall),
                                ),
                              ),
                            ),
                          ),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const SizedBox(),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radiusSmall),
                                  child: Shimmer(
                                    child: Container(
                                      height: 10,
                                      width: 200,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).shadowColor,
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.radiusSmall),
                                      ),
                                    ),
                                  ),
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radiusSmall),
                                  child: Shimmer(
                                    child: Container(
                                      height: 10,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).shadowColor,
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.radiusSmall),
                                      ),
                                    ),
                                  ),
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radiusSmall),
                                  child: Shimmer(
                                    child: Container(
                                      height: 10,
                                      width: 200,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).shadowColor,
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.radiusSmall),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(),
                              ]),
                          Icon(Icons.favorite_border,
                              size: 25, color: Theme.of(context).shadowColor),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ])
          : Column(children: [
              Shimmer(
                duration: const Duration(seconds: 2),
                enabled: true,
                child: Container(
                  height: 250,
                  color: Colors.black54,
                  padding: const EdgeInsets.symmetric(
                      vertical: Dimensions.paddingSizeLarge),
                  child: Center(
                    child: SizedBox(
                      width: Dimensions.webMaxWidth,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 200,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(
                                    Dimensions.radiusLarge),
                              ),
                            ),
                          ),
                          const SizedBox(width: Dimensions.paddingSizeDefault),
                          Expanded(
                            child: Column(children: [
                              Shimmer(
                                duration: const Duration(seconds: 2),
                                enabled: true,
                                child: Container(
                                  height: 110,
                                  padding: const EdgeInsets.all(
                                      Dimensions.paddingSizeLarge),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 80,
                                        width: 80,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).cardColor,
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.radiusSmall),
                                        ),
                                      ),
                                      const SizedBox(
                                          width: Dimensions.paddingSizeLarge),
                                      Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 10,
                                              width: 150,
                                              decoration: BoxDecoration(
                                                color:
                                                    Theme.of(context).cardColor,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        Dimensions.radiusSmall),
                                              ),
                                            ),
                                            Container(
                                              height: 10,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                color:
                                                    Theme.of(context).cardColor,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        Dimensions.radiusSmall),
                                              ),
                                            ),
                                            Container(
                                              height: 10,
                                              width: 150,
                                              decoration: BoxDecoration(
                                                color:
                                                    Theme.of(context).cardColor,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        Dimensions.radiusSmall),
                                              ),
                                            ),
                                          ]),
                                      const Spacer(),
                                      const Icon(Icons.favorite_border,
                                          size: 25),
                                      const SizedBox(
                                          width: Dimensions.paddingSizeSmall),
                                      const Icon(Icons.share, size: 25),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                  height: Dimensions.paddingSizeSmall),
                              Shimmer(
                                duration: const Duration(seconds: 2),
                                enabled: true,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: Dimensions.paddingSizeLarge),
                                  child: Column(children: [
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Column(children: [
                                            Icon(Icons.star,
                                                color: Theme.of(context)
                                                    .primaryColor),
                                            const SizedBox(
                                                height: Dimensions
                                                    .paddingSizeExtraSmall),
                                            Container(
                                              height: 10,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                color:
                                                    Theme.of(context).cardColor,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        Dimensions.radiusSmall),
                                              ),
                                            ),
                                          ]),
                                          Column(children: [
                                            Icon(Icons.location_on,
                                                color: Theme.of(context)
                                                    .primaryColor),
                                            const SizedBox(
                                                height: Dimensions
                                                    .paddingSizeExtraSmall),
                                            Container(
                                              height: 10,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                color:
                                                    Theme.of(context).cardColor,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        Dimensions.radiusSmall),
                                              ),
                                            ),
                                          ]),
                                          Column(children: [
                                            Icon(Icons.timer_rounded,
                                                color: Theme.of(context)
                                                    .primaryColor),
                                            const SizedBox(
                                                height: Dimensions
                                                    .paddingSizeExtraSmall),
                                            Container(
                                              height: 10,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                color:
                                                    Theme.of(context).cardColor,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        Dimensions.radiusSmall),
                                              ),
                                            ),
                                          ]),
                                        ]),
                                  ]),
                                ),
                              ),
                            ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Shimmer(
                duration: const Duration(seconds: 2),
                enabled: true,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: Dimensions.paddingSizeLarge),
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  child: Center(
                    child: SizedBox(
                      width: Dimensions.webMaxWidth,
                      child: Stack(children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(
                                    Dimensions.paddingSizeSmall),
                                child: TitleWidget(
                                  title: 'recommended_items'.tr,
                                ),
                              ),
                              SizedBox(
                                height: 285,
                                width: Get.width,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.only(
                                      left: Dimensions.paddingSizeDefault),
                                  itemCount: 6,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: Dimensions.paddingSizeDefault,
                                          right: Dimensions.paddingSizeDefault,
                                          top: Dimensions.paddingSizeDefault),
                                      child: Container(
                                        height: 285,
                                        width: 200,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).cardColor,
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.radiusLarge),
                                        ),
                                        child: Column(children: [
                                          Container(
                                            height: 150,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimensions.radiusLarge),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(
                                                Dimensions.paddingSizeSmall),
                                            child: Column(children: [
                                              Container(
                                                height: 20,
                                                width: 100,
                                                color: Colors.grey[300],
                                              ),
                                              const SizedBox(
                                                  height: Dimensions
                                                      .paddingSizeSmall),
                                              Container(
                                                height: 20,
                                                width: 200,
                                                color: Colors.grey[300],
                                              ),
                                              const SizedBox(
                                                  height: Dimensions
                                                      .paddingSizeSmall),
                                              Container(
                                                height: 20,
                                                width: 100,
                                                color: Colors.grey[300],
                                              ),
                                            ]),
                                          ),
                                        ]),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ]),
                      ]),
                    ),
                  ),
                ),
              ),
              Center(
                child: SizedBox(
                  width: Dimensions.webMaxWidth,
                  height: 285,
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          ResponsiveHelper.isDesktop(context) ? 5 : 4,
                      crossAxisSpacing: Dimensions.paddingSizeDefault,
                      mainAxisSpacing: Dimensions.paddingSizeDefault,
                      mainAxisExtent: 285,
                    ),
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(
                        left: Dimensions.paddingSizeDefault),
                    itemCount: 5,
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
                            height: 285,
                            width: 200,
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius:
                                  BorderRadius.circular(Dimensions.radiusLarge),
                            ),
                            child: Column(children: [
                              Container(
                                height: 150,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radiusLarge),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(
                                    Dimensions.paddingSizeSmall),
                                child: Column(children: [
                                  Container(
                                    height: 20,
                                    width: 100,
                                    color: Colors.grey[300],
                                  ),
                                  const SizedBox(
                                      height: Dimensions.paddingSizeSmall),
                                  Container(
                                    height: 20,
                                    width: 200,
                                    color: Colors.grey[300],
                                  ),
                                  const SizedBox(
                                      height: Dimensions.paddingSizeSmall),
                                  Container(
                                    height: 20,
                                    width: 100,
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
              ),
            ]),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sannip/common/widgets/card_design/visit_again_card.dart';
import 'package:sannip/features/store/controllers/store_controller.dart';
import 'package:sannip/features/store/domain/models/store_model.dart';
import 'package:sannip/util/dimensions.dart';
import 'package:sannip/util/styles.dart';

class VisitAgainView extends StatefulWidget {
  final bool? fromFood;
  const VisitAgainView({super.key, this.fromFood = false});

  @override
  State<VisitAgainView> createState() => _VisitAgainViewState();
}

class _VisitAgainViewState extends State<VisitAgainView> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<StoreController>(builder: (storeController) {
      List<Store>? stores = storeController.visitAgainStoreList;

      return stores != null
          ? stores.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('try_once_more'.tr,
                            // widget.fromFood!
                            //     ? "wanna_try_again".tr
                            //     : "visit_again".tr,
                            style: robotoBold.copyWith()),
                        // const SizedBox(height: Dimensions.paddingSizeSmall),
                        // Text(
                        //   'get_your_recent_purchase_from_the_shop_you_recently_visited'
                        //       .tr,
                        //   style: robotoRegular.copyWith(
                        //       fontSize: Dimensions.fontSizeSmall),
                        // ),
                        // const SizedBox(height: Dimensions.paddingSizeSmall),
                        SizedBox(
                          height: 230,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: stores.length,
                            itemBuilder: (context, index) {
                              return VisitAgainCard(
                                  store: stores[index],
                                  fromFood: widget.fromFood!);
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const SizedBox(
                                width: Dimensions.paddingSizeDefault,
                              );
                            },
                          ),
                        ),
                      ]),
                )
              /*Padding(
                  padding: const EdgeInsets.only(
                      bottom: Dimensions.paddingSizeDefault),
                  child: Stack(clipBehavior: Clip.none, children: [
                    Container(
                      height: 150,
                      width: double.infinity,
                      color: Theme.of(context).primaryColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: Dimensions.paddingSizeSmall),
                      child: Column(children: [
                        Text(
                            widget.fromFood!
                                ? "wanna_try_again".tr
                                : "visit_again".tr,
                            style: robotoBold.copyWith(
                                color: Theme.of(context).cardColor)),
                        const SizedBox(height: Dimensions.paddingSizeSmall),
                        Text(
                          'get_your_recent_purchase_from_the_shop_you_recently_visited'
                              .tr,
                          style: robotoRegular.copyWith(
                              color: Theme.of(context).cardColor,
                              fontSize: Dimensions.fontSizeSmall),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),
                        CarouselSlider.builder(
                          itemCount: stores.length,
                          options: CarouselOptions(
                            aspectRatio: 2.0,
                            enlargeCenterPage: true,
                            disableCenter: true,
                          ),
                          itemBuilder:
                              (BuildContext context, int index, int realIndex) {
                            return VisitAgainCard(
                                store: stores[index],
                                fromFood: widget.fromFood!);
                          },
                        ),
                      ]),
                    ),
                    const Positioned(
                      top: 20,
                      left: 10,
                      child: TriangleWidget(),
                    ),
                    const Positioned(
                      top: 10,
                      right: 100,
                      child: TriangleWidget(),
                    ),
                  ]),
                )*/
              : const SizedBox()
          : const VisitAgainShimmerView();
    });
  }
}

class VisitAgainShimmerView extends StatelessWidget {
  const VisitAgainShimmerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
      child: Stack(clipBehavior: Clip.none, children: [
        // Container(
        //   height: 150,
        //   width: double.infinity,
        //   color: Theme.of(context).primaryColor,
        // ),
        Padding(
          padding: const EdgeInsets.only(
            top: Dimensions.paddingSizeSmall,
            left: Dimensions.paddingSizeDefault,
          ),
          child: Shimmer(
            duration: const Duration(seconds: 2),
            enabled: true,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                height: 10,
                width: 100,
                color: Colors.grey[300],
              ),
              // const SizedBox(height: Dimensions.paddingSizeSmall),
              // Container(
              //   height: 10,
              //   width: 200,
              //   color: Colors.grey[300],
              // ),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              SizedBox(
                height: 180,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 290,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(Dimensions.radiusDefault),
                        color: Colors.grey[300],
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      width: Dimensions.paddingSizeDefault,
                    );
                  },
                ),
              ),
              // CarouselSlider.builder(
              //   itemCount: 5,
              //   options: CarouselOptions(
              //     aspectRatio: 2.2,
              //     enlargeCenterPage: true,
              //     disableCenter: true,
              //   ),
              //   itemBuilder: (BuildContext context, int index, int realIndex) {
              //     return Container(
              //       decoration: BoxDecoration(
              //         borderRadius:
              //             BorderRadius.circular(Dimensions.radiusDefault),
              //         color: Colors.grey[300],
              //       ),
              //     );
              //   },
              // ),
            ]),
          ),
        ),
        // const Positioned(
        //   top: 20,
        //   left: 10,
        //   child: TriangleWidget(),
        // ),
        // const Positioned(
        //   top: 10,
        //   right: 100,
        //   child: TriangleWidget(),
        // ),
      ]),
    );
  }
}

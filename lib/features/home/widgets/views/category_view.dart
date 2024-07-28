// ignore_for_file: unused_local_variable

import 'package:sannip/common/widgets/title_widget.dart';
import 'package:sannip/features/category/controllers/category_controller.dart';
import 'package:sannip/features/language/controllers/language_controller.dart';
import 'package:sannip/features/splash/controllers/splash_controller.dart';
import 'package:sannip/helper/responsive_helper.dart';
import 'package:sannip/helper/route_helper.dart';
import 'package:sannip/util/app_constants.dart';
import 'package:sannip/util/dimensions.dart';
import 'package:sannip/util/styles.dart';
import 'package:sannip/common/widgets/custom_image.dart';
import 'package:sannip/features/home/widgets/category_pop_up.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:get/get.dart';

class CategoryView extends StatelessWidget {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();

    return GetBuilder<SplashController>(builder: (splashController) {
      bool isPharmacy = splashController.module != null &&
          splashController.module!.moduleType.toString() ==
              AppConstants.pharmacy;
      bool isFood = splashController.module != null &&
          splashController.module!.moduleType.toString() == AppConstants.food;
      bool isGrocery = splashController.module != null &&
          splashController.module!.moduleType.toString() ==
              AppConstants.grocery;

      return GetBuilder<CategoryController>(builder: (categoryController) {
        return (categoryController.categoryList != null &&
                categoryController.categoryList!.isEmpty)
            ? const SizedBox()
            : isPharmacy
                ? PharmacyCategoryView(categoryController: categoryController)
                : isFood
                    ? FoodCategoryView(categoryController: categoryController)
                    : Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: categoryController.categoryList != null
                                    ? Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical:
                                                    Dimensions.paddingSizeSmall,
                                                horizontal: Dimensions
                                                    .paddingSizeDefault),
                                            child: TitleWidget(
                                              title: isGrocery
                                                  ? 'categories'.tr
                                                  : 'shop_by_category'.tr,
                                              onTap: () => Get.toNamed(
                                                  RouteHelper
                                                      .getCategoryRoute()),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: Dimensions
                                                    .paddingSizeLarge),
                                            child: GridView.builder(
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 3,
                                                mainAxisSpacing:
                                                    Dimensions.paddingSizeSmall,
                                                crossAxisSpacing:
                                                    Dimensions.paddingSizeSmall,
                                                childAspectRatio: (1 / 1),
                                              ),
                                              padding: const EdgeInsets.all(
                                                  Dimensions.paddingSizeSmall),
                                              itemCount: categoryController
                                                  .categoryList!.length,
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding: const EdgeInsets
                                                      .only(
                                                      bottom: Dimensions
                                                          .paddingSizeDefault,
                                                      right: Dimensions
                                                          .paddingSizeSmall,
                                                      top: Dimensions
                                                          .paddingSizeExtraSmall),
                                                  child: InkWell(
                                                    onTap: () => Get.toNamed(
                                                        RouteHelper
                                                            .getCategoryItemRoute(
                                                      categoryController
                                                          .categoryList![index]
                                                          .id,
                                                      categoryController
                                                          .categoryList![index]
                                                          .name!,
                                                    )),
                                                    child: SizedBox(
                                                      height: 120,
                                                      child: Stack(
                                                        alignment:
                                                            AlignmentDirectional
                                                                .topCenter,
                                                        clipBehavior: Clip.none,
                                                        children: [
                                                          Container(
                                                            height: 80,
                                                            width: 100,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                      Dimensions
                                                                          .radiusDefault),
                                                              color: Colors.blue
                                                                  .withOpacity(
                                                                      0.2),
                                                            ),
                                                            child: Padding(
                                                              padding: EdgeInsets.only(
                                                                  right: index ==
                                                                          0
                                                                      ? Dimensions
                                                                          .paddingSizeExtraSmall
                                                                      : 0,
                                                                  bottom: Dimensions
                                                                      .paddingSizeExtraSmall),
                                                              child: Align(
                                                                alignment: Alignment
                                                                    .bottomCenter,
                                                                child: Text(
                                                                  categoryController
                                                                      .categoryList![
                                                                          index]
                                                                      .name!,
                                                                  style: robotoMedium
                                                                      .copyWith(
                                                                          fontSize:
                                                                              11),
                                                                  maxLines:
                                                                      Get.find<LocalizationController>()
                                                                              .isLtr
                                                                          ? 2
                                                                          : 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Positioned(
                                                            bottom: 60,
                                                            child: SizedBox(
                                                              height: 75,
                                                              width: 75,
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                        Dimensions
                                                                            .radiusSmall),
                                                                child:
                                                                    CustomImage(
                                                                  image:
                                                                      '${categoryController.categoryList![index].imageFullUrl}',
                                                                  height: 75,
                                                                  width: 75,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      )
                                    : CategoryShimmer(
                                        categoryController: categoryController,
                                        isGrocery: isGrocery),
                              ),
                              /* Expanded(
                                child: SizedBox(
                                  height: 158,
                                  child: categoryController.categoryList != null
                                      ? ListView.builder(
                                          controller: scrollController,
                                          itemCount: categoryController
                                                      .categoryList!.length >
                                                  10
                                              ? 10
                                              : categoryController
                                                  .categoryList!.length,
                                          padding: const EdgeInsets.only(
                                              left: Dimensions.paddingSizeSmall,
                                              top: Dimensions
                                                  .paddingSizeDefault),
                                          physics:
                                              const BouncingScrollPhysics(),
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: Dimensions
                                                      .paddingSizeDefault,
                                                  right: Dimensions
                                                      .paddingSizeSmall,
                                                  top: Dimensions
                                                      .paddingSizeDefault),
                                              child: InkWell(
                                                onTap: () {
                                                  if (index == 9 &&
                                                      categoryController
                                                              .categoryList!
                                                              .length >
                                                          10) {
                                                    Get.toNamed(RouteHelper
                                                        .getCategoryRoute());
                                                  } else {
                                                    Get.toNamed(RouteHelper
                                                        .getCategoryItemRoute(
                                                      categoryController
                                                          .categoryList![index]
                                                          .id,
                                                      categoryController
                                                          .categoryList![index]
                                                          .name!,
                                                    ));
                                                  }
                                                },
                                                child: SizedBox(
                                                  width: 80,
                                                  child: Column(children: [
                                                    SizedBox(
                                                      height: 75,
                                                      width: 75,
                                                      child: Stack(children: [
                                                        ClipRRect(
                                                          borderRadius: BorderRadius
                                                              .circular(Dimensions
                                                                  .radiusSmall),
                                                          child: CustomImage(
                                                            image:
                                                                '${categoryController.categoryList![index].imageFullUrl}',
                                                            height: 75,
                                                            width: 75,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                        (index == 9 &&
                                                                categoryController
                                                                        .categoryList!
                                                                        .length >
                                                                    10)
                                                            ? Positioned(
                                                                right: 0,
                                                                left: 0,
                                                                top: 0,
                                                                bottom: 0,
                                                                child:
                                                                    Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(Dimensions.radiusSmall),
                                                                          gradient:
                                                                              LinearGradient(
                                                                            begin:
                                                                                Alignment.topCenter,
                                                                            end:
                                                                                Alignment.bottomCenter,
                                                                            colors: [
                                                                              Theme.of(context).primaryColor.withOpacity(0.4),
                                                                              Theme.of(context).primaryColor.withOpacity(0.6),
                                                                              Theme.of(context).primaryColor.withOpacity(0.4),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            '+${categoryController.categoryList!.length - 10}',
                                                                            style:
                                                                                robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).cardColor),
                                                                            maxLines:
                                                                                2,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                          ),
                                                                        )),
                                                              )
                                                            : const SizedBox(),
                                                      ]),
                                                    ),
                                                    const SizedBox(
                                                        height: Dimensions
                                                            .paddingSizeExtraSmall),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          right: index == 0
                                                              ? Dimensions
                                                                  .paddingSizeExtraSmall
                                                              : 0),
                                                      child: Text(
                                                        (index == 9 &&
                                                                categoryController
                                                                        .categoryList!
                                                                        .length >
                                                                    10)
                                                            ? 'see_all'.tr
                                                            : categoryController
                                                                .categoryList![
                                                                    index]
                                                                .name!,
                                                        style: robotoMedium.copyWith(
                                                            fontSize: 11,
                                                            color: (index ==
                                                                        9 &&
                                                                    categoryController
                                                                            .categoryList!
                                                                            .length >
                                                                        10)
                                                                ? Theme.of(
                                                                        context)
                                                                    .primaryColor
                                                                : Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyMedium!
                                                                    .color),
                                                        maxLines: Get.find<
                                                                    LocalizationController>()
                                                                .isLtr
                                                            ? 2
                                                            : 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ]),
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                      : CategoryShimmer(
                                          categoryController:
                                              categoryController),
                                ),
                              ),*/
                              ResponsiveHelper.isMobile(context)
                                  ? const SizedBox()
                                  : categoryController.categoryList != null
                                      ? Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (con) => Dialog(
                                                        child: SizedBox(
                                                            height: 550,
                                                            width: 600,
                                                            child:
                                                                CategoryPopUp(
                                                              categoryController:
                                                                  categoryController,
                                                            ))));
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: Dimensions
                                                        .paddingSizeSmall),
                                                child: CircleAvatar(
                                                  radius: 35,
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .primaryColor,
                                                  child: Text('view_all'.tr,
                                                      style: TextStyle(
                                                          fontSize: Dimensions
                                                              .paddingSizeDefault,
                                                          color:
                                                              Theme.of(context)
                                                                  .cardColor)),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            )
                                          ],
                                        )
                                      : CategoryShimmer(
                                          categoryController:
                                              categoryController,
                                          isGrocery: isGrocery),
                            ],
                          ),
                        ],
                      );
      });
    });
  }
}

class PharmacyCategoryView extends StatelessWidget {
  final CategoryController categoryController;
  const PharmacyCategoryView({super.key, required this.categoryController});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
        height: 160,
        child: categoryController.categoryList != null
            ? ListView.builder(
                controller: scrollController,
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(
                    left: Dimensions.paddingSizeDefault,
                    top: Dimensions.paddingSizeDefault),
                itemCount: categoryController.categoryList!.length > 10
                    ? 10
                    : categoryController.categoryList!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        bottom: Dimensions.paddingSizeDefault,
                        right: Dimensions.paddingSizeSmall,
                        top: Dimensions.paddingSizeDefault),
                    child: InkWell(
                      onTap: () {
                        if (index == 9 &&
                            categoryController.categoryList!.length > 10) {
                          Get.toNamed(RouteHelper.getCategoryRoute());
                        } else {
                          Get.toNamed(RouteHelper.getCategoryItemRoute(
                            categoryController.categoryList![index].id,
                            categoryController.categoryList![index].name!,
                          ));
                        }
                      },
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusSmall),
                      child: Container(
                        width: 70,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(100),
                              topRight: Radius.circular(100)),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Theme.of(context).primaryColor.withOpacity(0.3),
                              Theme.of(context).cardColor.withOpacity(0.3),
                            ],
                          ),
                        ),
                        child: Column(children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(100),
                                    topRight: Radius.circular(100)),
                                child: CustomImage(
                                  image:
                                      '${categoryController.categoryList![index].imageFullUrl}',
                                  height: 60,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              (index == 9 &&
                                      categoryController.categoryList!.length >
                                          10)
                                  ? Positioned(
                                      right: 0,
                                      left: 0,
                                      top: 0,
                                      bottom: 0,
                                      child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(100),
                                                    topRight:
                                                        Radius.circular(100)),
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Theme.of(context)
                                                    .primaryColor
                                                    .withOpacity(0.4),
                                                Theme.of(context)
                                                    .primaryColor
                                                    .withOpacity(0.6),
                                                Theme.of(context)
                                                    .primaryColor
                                                    .withOpacity(0.4),
                                              ],
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '+${categoryController.categoryList!.length - 10}',
                                              style: robotoMedium.copyWith(
                                                  fontSize: Dimensions
                                                      .fontSizeExtraLarge,
                                                  color: Theme.of(context)
                                                      .cardColor),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                            ),
                                          )),
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          Expanded(
                              child: Text(
                            (index == 9 &&
                                    categoryController.categoryList!.length >
                                        10)
                                ? 'see_all'.tr
                                : categoryController.categoryList![index].name!,
                            style: robotoMedium.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                color: (index == 9 &&
                                        categoryController
                                                .categoryList!.length >
                                            10)
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .color),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          )),
                        ]),
                      ),
                    ),
                  );
                },
              )
            : PharmacyCategoryShimmer(categoryController: categoryController),
      ),
    ]);
  }
}

class FoodCategoryView extends StatelessWidget {
  final CategoryController categoryController;
  const FoodCategoryView({super.key, required this.categoryController});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    int number = ((categoryController.categoryList?.length ?? 0) / 2).ceil();
    return Stack(children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
          height: 290,
          child: categoryController.categoryList != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: Dimensions.paddingSizeSmall,
                          horizontal: Dimensions.paddingSizeDefault),
                      child: TitleWidget(
                        title: 'popular_cuisines'.tr,
                        onTap: () =>
                            Get.toNamed(RouteHelper.getCategoryRoute()),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Row(
                                children: List.generate(
                                    number,
                                    (index) => Padding(
                                          padding: const EdgeInsets.only(
                                              left:
                                                  Dimensions.paddingSizeDefault,
                                              bottom: Dimensions
                                                  .paddingSizeExtraSmall,
                                              right:
                                                  Dimensions.paddingSizeDefault,
                                              top: Dimensions
                                                  .paddingSizeExtraSmall),
                                          child: InkWell(
                                            onTap: () => Get.toNamed(RouteHelper
                                                .getCategoryItemRoute(
                                              categoryController
                                                  .categoryList![index].id,
                                              categoryController
                                                  .categoryList![index].name!,
                                            )),
                                            borderRadius: BorderRadius.circular(
                                                Dimensions.radiusSmall),
                                            child: SizedBox(
                                              width: 60,
                                              child: Column(children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(100)),
                                                  child: CustomImage(
                                                    image:
                                                        '${categoryController.categoryList![index].imageFullUrl}',
                                                    height: 60,
                                                    width: double.infinity,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                const SizedBox(
                                                    height: Dimensions
                                                        .paddingSizeSmall),
                                                Expanded(
                                                    child: Text(
                                                  categoryController
                                                      .categoryList![index]
                                                      .name!,
                                                  style: robotoMedium.copyWith(
                                                      fontSize: Dimensions
                                                          .fontSizeSmall,
                                                      color: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium!
                                                          .color),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.center,
                                                )),
                                              ]),
                                            ),
                                          ),
                                        )),
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: List.generate(
                                    (categoryController.categoryList?.length ??
                                            0) -
                                        number,
                                    (index) => Padding(
                                          padding: const EdgeInsets.only(
                                              left:
                                                  Dimensions.paddingSizeDefault,
                                              bottom: Dimensions
                                                  .paddingSizeExtraSmall,
                                              right:
                                                  Dimensions.paddingSizeDefault,
                                              top: Dimensions
                                                  .paddingSizeExtraSmall),
                                          child: InkWell(
                                            onTap: () => Get.toNamed(RouteHelper
                                                .getCategoryItemRoute(
                                              categoryController
                                                  .categoryList![index + number]
                                                  .id,
                                              categoryController
                                                  .categoryList![index + number]
                                                  .name!,
                                            )),
                                            borderRadius: BorderRadius.circular(
                                                Dimensions.radiusSmall),
                                            child: SizedBox(
                                              width: 60,
                                              child: Column(children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(100)),
                                                  child: CustomImage(
                                                    image:
                                                        '${categoryController.categoryList![index + number].imageFullUrl}',
                                                    height: 60,
                                                    width: double.infinity,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                const SizedBox(
                                                    height: Dimensions
                                                        .paddingSizeSmall),
                                                Expanded(
                                                    child: Text(
                                                  categoryController
                                                      .categoryList![
                                                          index + number]
                                                      .name!,
                                                  style: robotoMedium.copyWith(
                                                      fontSize: Dimensions
                                                          .fontSizeSmall,
                                                      color: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium!
                                                          .color),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.center,
                                                )),
                                              ]),
                                            ),
                                          ),
                                        )),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              /*  ? ListView.builder(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(
                      left: Dimensions.paddingSizeDefault,
                      top: Dimensions.paddingSizeDefault),
                  itemCount: categoryController.categoryList!.length > 10
                      ? 10
                      : categoryController.categoryList!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          bottom: Dimensions.paddingSizeDefault,
                          right: Dimensions.paddingSizeDefault,
                          top: Dimensions.paddingSizeDefault),
                      child: InkWell(
                        onTap: () {
                          if (index == 9 &&
                              categoryController.categoryList!.length > 10) {
                            Get.toNamed(RouteHelper.getCategoryRoute());
                          } else {
                            Get.toNamed(RouteHelper.getCategoryItemRoute(
                              categoryController.categoryList![index].id,
                              categoryController.categoryList![index].name!,
                            ));
                          }
                        },
                        borderRadius:
                            BorderRadius.circular(Dimensions.radiusSmall),
                        child: SizedBox(
                          width: 60,
                          child: Column(children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(100)),
                                  child: CustomImage(
                                    image:
                                        '${categoryController.categoryList![index].imageFullUrl}',
                                    height: 60,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                (index == 9 &&
                                        categoryController
                                                .categoryList!.length >
                                            10)
                                    ? Positioned(
                                        right: 0,
                                        left: 0,
                                        top: 0,
                                        bottom: 0,
                                        child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(100)),
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Theme.of(context)
                                                      .primaryColor
                                                      .withOpacity(0.4),
                                                  Theme.of(context)
                                                      .primaryColor
                                                      .withOpacity(0.6),
                                                  Theme.of(context)
                                                      .primaryColor
                                                      .withOpacity(0.4),
                                                ],
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                '+${categoryController.categoryList!.length - 10}',
                                                style: robotoMedium.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeExtraLarge,
                                                    color: Theme.of(context)
                                                        .cardColor),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.center,
                                              ),
                                            )),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                            const SizedBox(height: Dimensions.paddingSizeSmall),
                            Expanded(
                                child: Text(
                              (index == 9 &&
                                      categoryController.categoryList!.length >
                                          10)
                                  ? 'see_all'.tr
                                  : categoryController
                                          .categoryList![index].name ??
                                      '',
                              style: robotoMedium.copyWith(
                                  fontSize: Dimensions.fontSizeSmall,
                                  color: (index == 9 &&
                                          categoryController
                                                  .categoryList!.length >
                                              10)
                                      ? Theme.of(context).primaryColor
                                      : Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .color),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            )),
                          ]),
                        ),
                      ),
                    );
                  },
                )*/
              : FoodCategoryShimmer(categoryController: categoryController),
        ),
      ]),
    ]);
  }
}

class CategoryShimmer extends StatelessWidget {
  final CategoryController categoryController;
  final bool isGrocery;
  const CategoryShimmer(
      {super.key, required this.categoryController, required this.isGrocery});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ResponsiveHelper.isMobile(context)
            ? Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: Dimensions.paddingSizeSmall,
                    horizontal: Dimensions.paddingSizeDefault),
                child: TitleWidget(
                  title: isGrocery ? 'categories'.tr : 'shop_by_category'.tr,
                  onTap: () => Get.toNamed(RouteHelper.getCategoryRoute()),
                ),
              )
            : const SizedBox(),
        Padding(
          padding: const EdgeInsets.only(top: Dimensions.paddingSizeLarge),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: Dimensions.paddingSizeSmall,
              crossAxisSpacing: Dimensions.paddingSizeSmall,
              childAspectRatio: (1 / 1),
            ),
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            itemCount: 9,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(
                    bottom: Dimensions.paddingSizeDefault,
                    right: Dimensions.paddingSizeSmall,
                    top: Dimensions.paddingSizeExtraSmall),
                child: Shimmer(
                  duration: const Duration(seconds: 2),
                  enabled: true,
                  child: SizedBox(
                    height: 120,
                    child: Stack(
                      alignment: AlignmentDirectional.topCenter,
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: 80,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(Dimensions.radiusDefault),
                            color: Colors.grey[300]?.withOpacity(0.3),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                                right: index == 0
                                    ? Dimensions.paddingSizeExtraSmall
                                    : 0,
                                bottom: Dimensions.paddingSizeExtraSmall),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 10,
                                width: 50,
                                color: Colors.grey[300],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 60,
                          child: Container(
                              height: 75,
                              width: 75,
                              margin: EdgeInsets.only(
                                left: index == 0
                                    ? 0
                                    : Dimensions.paddingSizeExtraSmall,
                                right: Dimensions.paddingSizeExtraSmall,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    Dimensions.radiusSmall),
                                color: Colors.grey[300],
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
    /*return ListView.builder(
      itemCount: 8,
      padding: const EdgeInsets.only(
          left: Dimensions.paddingSizeSmall,
          top: Dimensions.paddingSizeDefault),
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 1, vertical: Dimensions.paddingSizeDefault),
          child: Shimmer(
            duration: const Duration(seconds: 2),
            enabled: true,
            child: SizedBox(
              width: 80,
              child: Column(children: [
                Container(
                    height: 75,
                    width: 75,
                    margin: EdgeInsets.only(
                      left: index == 0 ? 0 : Dimensions.paddingSizeExtraSmall,
                      right: Dimensions.paddingSizeExtraSmall,
                    ),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusSmall),
                      color: Colors.grey[300],
                    )),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                Padding(
                  padding: EdgeInsets.only(
                      right: index == 0 ? Dimensions.paddingSizeExtraSmall : 0),
                  child: Container(
                    height: 10,
                    width: 50,
                    color: Colors.grey[300],
                  ),
                ),
              ]),
            ),
          ),
        );
      },
    );*/
  }
}

class FoodCategoryShimmer extends StatelessWidget {
  final CategoryController categoryController;
  const FoodCategoryShimmer({super.key, required this.categoryController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              vertical: Dimensions.paddingSizeSmall,
              horizontal: Dimensions.paddingSizeDefault),
          child: TitleWidget(
            title: 'popular_cuisines'.tr,
            onTap: () => Get.toNamed(RouteHelper.getCategoryRoute()),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    children: List.generate(
                        6,
                        (index) => Padding(
                              padding: const EdgeInsets.only(
                                  bottom: Dimensions.paddingSizeDefault,
                                  left: Dimensions.paddingSizeDefault,
                                  top: Dimensions.paddingSizeDefault),
                              child: Shimmer(
                                duration: const Duration(seconds: 2),
                                enabled: true,
                                child: SizedBox(
                                  width: 60,
                                  child: Column(children: [
                                    Container(
                                        height: 60,
                                        width: double.infinity,
                                        margin: const EdgeInsets.only(
                                            bottom:
                                                Dimensions.paddingSizeSmall),
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(100)),
                                          color: Colors.grey[300],
                                        )),
                                    const SizedBox(
                                        height: Dimensions.paddingSizeSmall),
                                    Expanded(
                                      child: Container(
                                        height: 10,
                                        width: 50,
                                        color: Colors.grey[300],
                                      ),
                                    ),
                                  ]),
                                ),
                              ),
                            )),
                  ),
                ),
                Expanded(
                  child: Row(
                    children: List.generate(
                        6,
                        (index) => Padding(
                              padding: const EdgeInsets.only(
                                  bottom: Dimensions.paddingSizeDefault,
                                  left: Dimensions.paddingSizeDefault,
                                  top: Dimensions.paddingSizeDefault),
                              child: Shimmer(
                                duration: const Duration(seconds: 2),
                                enabled: true,
                                child: SizedBox(
                                  width: 60,
                                  child: Column(children: [
                                    Container(
                                        height: 60,
                                        width: double.infinity,
                                        margin: const EdgeInsets.only(
                                            bottom:
                                                Dimensions.paddingSizeSmall),
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(100)),
                                          color: Colors.grey[300],
                                        )),
                                    const SizedBox(
                                        height: Dimensions.paddingSizeSmall),
                                    Expanded(
                                      child: Container(
                                        height: 10,
                                        width: 50,
                                        color: Colors.grey[300],
                                      ),
                                    ),
                                  ]),
                                ),
                              ),
                            )),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
    /* return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      padding:
          const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
      itemCount: 8,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(
              bottom: Dimensions.paddingSizeDefault,
              left: Dimensions.paddingSizeDefault,
              top: Dimensions.paddingSizeDefault),
          child: Shimmer(
            duration: const Duration(seconds: 2),
            enabled: true,
            child: SizedBox(
              width: 60,
              child: Column(children: [
                Container(
                    height: 60,
                    width: double.infinity,
                    margin: const EdgeInsets.only(
                        bottom: Dimensions.paddingSizeSmall),
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(100)),
                      color: Colors.grey[300],
                    )),
                const SizedBox(height: Dimensions.paddingSizeSmall),
                Expanded(
                  child: Container(
                    height: 10,
                    width: 50,
                    color: Colors.grey[300],
                  ),
                ),
              ]),
            ),
          ),
        );
      },
    );*/
  }
}

class PharmacyCategoryShimmer extends StatelessWidget {
  final CategoryController categoryController;
  const PharmacyCategoryShimmer({super.key, required this.categoryController});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      padding:
          const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
      itemCount: 8,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(
              bottom: Dimensions.paddingSizeDefault,
              left: Dimensions.paddingSizeDefault,
              top: Dimensions.paddingSizeDefault),
          child: Shimmer(
            duration: const Duration(seconds: 2),
            enabled: true,
            child: Container(
              width: 70,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(100),
                    topRight: Radius.circular(100)),
              ),
              child: Column(children: [
                Container(
                    height: 60,
                    width: double.infinity,
                    margin: const EdgeInsets.only(
                        bottom: Dimensions.paddingSizeSmall),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(100),
                          topRight: Radius.circular(100)),
                      color: Colors.grey[300],
                    )),
                const SizedBox(height: Dimensions.paddingSizeSmall),
                Expanded(
                  child: Container(
                    height: 10,
                    width: 50,
                    color: Colors.grey[300],
                  ),
                ),
              ]),
            ),
          ),
        );
      },
    );
  }
}

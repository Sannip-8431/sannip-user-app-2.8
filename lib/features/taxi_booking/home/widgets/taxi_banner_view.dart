import 'package:carousel_slider/carousel_slider.dart';
import 'package:sannip/features/banner/controllers/banner_controller.dart';
import 'package:sannip/features/splash/controllers/splash_controller.dart';
import 'package:sannip/util/dimensions.dart';
import 'package:sannip/common/widgets/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class TaxiBannerView extends StatelessWidget {
  const TaxiBannerView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BannerController>(builder: (bannerController) {
      List<String?>? bannerList = bannerController.taxiBannerImageList;

      return (bannerList != null && bannerList.isEmpty)
          ? const SizedBox()
          : SizedBox(
              width: MediaQuery.of(context).size.width,
              height: GetPlatform.isDesktop ? 500 : 110,
              child: bannerList != null
                  ? Stack(
                      children: [
                        SizedBox(
                          height: 110,
                          width: context.width,
                          child: CarouselSlider.builder(
                            options: CarouselOptions(
                              autoPlay: true,
                              viewportFraction: 1,
                              autoPlayInterval: const Duration(seconds: 7),
                              onPageChanged: (index, reason) {
                                bannerController.setCurrentIndex(index, true);
                              },
                            ),
                            itemCount:
                                bannerList.isEmpty ? 1 : bannerList.length,
                            itemBuilder: (context, index, _) {
                              return InkWell(
                                onTap: () async {},
                                child: Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.radiusSmall),
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 5,
                                            spreadRadius: 1)
                                      ],
                                    ),
                                    width: 500,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.radiusSmall),
                                      child: GetBuilder<SplashController>(
                                          builder: (splashController) {
                                        return CustomImage(
                                          image: '${bannerList[index]}',
                                          fit: BoxFit.cover,
                                        );
                                      }),
                                    )),
                              );
                            },
                          ),
                        ),
                        Positioned(
                          bottom: 5,
                          right: 0,
                          left: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: bannerList.map((bnr) {
                              int index = bannerList.indexOf(bnr);
                              return TabPageSelectorIndicator(
                                backgroundColor:
                                    index == bannerController.currentIndex
                                        ? Theme.of(context).primaryColor
                                        : Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.5),
                                borderColor:
                                    Theme.of(context).colorScheme.surface,
                                size: index == bannerController.currentIndex
                                    ? 10
                                    : 7,
                              );
                            }).toList(),
                          ),
                        )
                      ],
                    )
                  : Shimmer(
                      duration: const Duration(seconds: 2),
                      enabled: bannerList == null,
                      child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(Dimensions.radiusSmall),
                            color: Colors.grey[300],
                          )),
                    ),
            );
    });
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sannip/common/widgets/custom_image.dart';
import 'package:sannip/features/item/controllers/campaign_controller.dart';
import 'package:sannip/features/item/controllers/item_controller.dart';
import 'package:sannip/features/item/domain/models/item_model.dart';
import 'package:sannip/util/dimensions.dart';
import 'package:sannip/util/styles.dart';

class JustForYouGridView extends StatefulWidget {
  const JustForYouGridView({super.key});

  @override
  State<JustForYouGridView> createState() => _JustForYouGridViewState();
}

class _JustForYouGridViewState extends State<JustForYouGridView> {
  int currentIndex = 0;
  List<Item> itemCampaignList = [];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CampaignController>(builder: (campaignController) {
      if (campaignController.itemCampaignList != null) {
        itemCampaignList = [];
        if (campaignController.itemCampaignList!.length == 1) {
          for (int i = 0; i < 3; i++) {
            itemCampaignList.add(campaignController.itemCampaignList![0]);
          }
        } else if (campaignController.itemCampaignList!.length == 2) {
          for (int i = 0; i < 3; i++) {
            itemCampaignList.add(campaignController.itemCampaignList![i % 2]);
          }
        } else {
          itemCampaignList.addAll(campaignController.itemCampaignList!);
        }
      }

      return campaignController.itemCampaignList != null
          ? itemCampaignList.isNotEmpty
              ? SizedBox(
                  height: 385,
                  width: MediaQuery.of(context).size.width,
                  child: PageView.builder(
                      controller: PageController(),
                      itemCount: itemCampaignList.length,
                      itemBuilder: ((context, index) {
                        return GridView.builder(
                            key: UniqueKey(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 0.98,
                              crossAxisCount: 2,
                            ),
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.only(
                                left: Dimensions.paddingSizeExtraSmall),
                            itemCount: itemCampaignList.length,
                            itemBuilder: (context, index) {
                              return Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 3),
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 5,
                                            spreadRadius: 1)
                                      ],
                                      border: Border.all(
                                          color: Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.1)),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(
                                              Dimensions.radiusDefault))),
                                  child: InkWell(
                                    onTap: () => Get.find<ItemController>()
                                        .navigateToItemPage(
                                            itemCampaignList[index], context,
                                            isCampaign: true),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(
                                              Dimensions.paddingSizeSmall),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                  itemCampaignList[index]
                                                          .name ??
                                                      '',
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.center,
                                                  style: robotoMedium.copyWith(
                                                      fontSize: Dimensions
                                                          .fontSizeLarge)),
                                              Container(
                                                constraints:
                                                    const BoxConstraints(
                                                        maxWidth: 150),
                                                padding: const EdgeInsets
                                                    .symmetric(
                                                    horizontal: Dimensions
                                                        .paddingSizeExtraSmall,
                                                    vertical: 2),
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    begin:
                                                        Alignment.centerRight,
                                                    end: Alignment.centerLeft,
                                                    colors: [
                                                      Colors.transparent,
                                                      Theme.of(context)
                                                          .primaryColor
                                                          .withOpacity(0.3)
                                                    ],
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          Dimensions
                                                              .radiusSmall),
                                                ),
                                                child: Text(
                                                    itemCampaignList[index]
                                                            .storeName ??
                                                        '',
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style:
                                                        robotoRegular.copyWith(
                                                            fontSize: Dimensions
                                                                .fontSizeSmall)),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Flexible(
                                          child: SizedBox(
                                            width: Get.width,
                                            // height: 100,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimensions.radiusDefault),
                                              child: CustomImage(
                                                image:
                                                    '${itemCampaignList[index].imageFullUrl}',
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ));
                            });
                      })),
                )
              : const SizedBox.shrink()
          : const SizedBox();
    });
  }
}

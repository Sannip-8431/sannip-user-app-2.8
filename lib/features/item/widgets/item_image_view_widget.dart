import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sannip/features/item/controllers/item_controller.dart';
import 'package:sannip/features/item/domain/models/item_model.dart';
import 'package:sannip/helper/responsive_helper.dart';
import 'package:sannip/helper/route_helper.dart';
import 'package:sannip/util/dimensions.dart';
import 'package:sannip/common/widgets/custom_image.dart';

class ItemImageViewWidget extends StatelessWidget {
  final Item? item;
  final double? height;
  final BoxFit? fit;
  ItemImageViewWidget({super.key, required this.item, this.height, this.fit});

  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    List<String?> imageList = [];
    imageList.add(item!.imageFullUrl);
    imageList.addAll(item!.imagesFullUrl!);

    return GetBuilder<ItemController>(builder: (itemController) {
      return Column(mainAxisSize: MainAxisSize.min, children: [
        InkWell(
          onTap: () => Navigator.of(context).pushNamed(
            RouteHelper.getItemImagesRoute(item!),
            arguments: ItemImageViewWidget(item: item),
          ),
          child: Stack(children: [
            SizedBox(
              height: ResponsiveHelper.isDesktop(context)
                  ? 350
                  : height ?? MediaQuery.of(context).size.width * 0.7,
              child: PageView.builder(
                controller: _controller,
                itemCount: imageList.length,
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CustomImage(
                      fit: fit,
                      image: '${imageList[index]}',
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                    ),
                  );
                },
                onPageChanged: (index) {
                  itemController.setImageSliderIndex(index);
                },
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Padding(
                padding:
                    const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _indicators(context, itemController, imageList),
                ),
              ),
            ),
          ]),
        ),
      ]);
    });
  }

  List<Widget> _indicators(BuildContext context, ItemController itemController,
      List<String?> imageList) {
    List<Widget> indicators = [];
    for (int index = 0; index < imageList.length; index++) {
      indicators.add(TabPageSelectorIndicator(
        backgroundColor: index == itemController.imageSliderIndex
            ? Theme.of(context).primaryColor
            : Colors.white,
        borderColor: Colors.white,
        size: 10,
      ));
    }
    return indicators;
  }
}

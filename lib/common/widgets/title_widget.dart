import 'package:sannip/features/splash/controllers/splash_controller.dart';
import 'package:sannip/helper/responsive_helper.dart';
import 'package:sannip/util/app_constants.dart';
import 'package:sannip/util/dimensions.dart';
import 'package:sannip/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TitleWidget extends StatelessWidget {
  final String title;
  final Function? onTap;
  final String? image;
  const TitleWidget({super.key, required this.title, this.onTap, this.image});

  @override
  Widget build(BuildContext context) {
    bool isFood = Get.find<SplashController>().module != null &&
        Get.find<SplashController>().module!.moduleType.toString() ==
            AppConstants.food;

    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(
        children: [
          Text(title,
              style: robotoBold.copyWith(
                  fontSize: ResponsiveHelper.isDesktop(context)
                      ? Dimensions.fontSizeLarge
                      : Dimensions.fontSizeLarge)),
          const SizedBox(width: Dimensions.paddingSizeSmall),
          image != null
              ? Image.asset(image!, height: 20, width: 20)
              : const SizedBox(),
        ],
      ),
      (onTap != null)
          ? InkWell(
              onTap: onTap as void Function()?,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                child: Text(
                  !isFood ? 'view_more'.tr : 'see_all'.tr,
                  style: robotoMedium.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            )
          : const SizedBox(),
    ]);
  }
}

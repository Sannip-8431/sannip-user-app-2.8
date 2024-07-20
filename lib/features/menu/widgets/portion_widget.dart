import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sannip/util/dimensions.dart';
import 'package:sannip/util/styles.dart';

class PortionWidget extends StatelessWidget {
  final String icon;
  final String title;
  final bool hideDivider;
  final String route;
  final String? suffix;
  const PortionWidget(
      {super.key,
      required this.icon,
      required this.title,
      required this.route,
      this.hideDivider = false,
      this.suffix});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed(route),
      child: Column(children: [
        Row(children: [
          Image.asset(
            icon,
            height: 22,
            width: 22,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault)),
              if (suffix != null)
                Text(suffix!,
                    style: robotoMedium.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                        fontWeight: FontWeight.bold),
                    textDirection: TextDirection.ltr),
            ],
          )),
          /*suffix != null
              ? Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.error,
                    borderRadius:
                        BorderRadius.circular(Dimensions.radiusDefault),
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: Dimensions.paddingSizeExtraSmall,
                      horizontal: Dimensions.paddingSizeSmall),
                  child: Text(suffix!,
                      style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          color: Colors.white),
                      textDirection: TextDirection.ltr),
                )
              : const SizedBox(),*/
        ]),
        const Divider(
          height: 34,
        )
        // hideDivider ? const SizedBox() : const Divider()
      ]),
    );
  }
}

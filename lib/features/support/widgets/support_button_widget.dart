import 'package:sannip/util/dimensions.dart';
import 'package:sannip/util/styles.dart';
import 'package:flutter/material.dart';

class SupportButtonWidget extends StatelessWidget {
  // final IconData icon;
  final String title;
  final String? info;
  final Color color;
  final Function onTap;
  final String iconImage;
  const SupportButtonWidget({
    super.key,
    // required this.icon,
    required this.title,
    required this.info,
    required this.color,
    required this.onTap,
    required this.iconImage,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap as void Function()?,
      child: Container(
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          color: Theme.of(context).cardColor,
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)
          ],
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset(iconImage, height: 25, width: 25, color: color),
          // Container(
          //   height: 40,
          //   width: 40,
          //   decoration: BoxDecoration(
          //     shape: BoxShape.circle,
          //     color: color.withOpacity(0.2),
          //   ),
          //   child: Icon(icon, color: color, size: 20),
          // ),
          const SizedBox(width: Dimensions.paddingSizeSmall),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(title,
                    style: robotoMedium.copyWith(
                        fontSize: Dimensions.fontSizeSmall, color: color)),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                Text(info!,
                    style: robotoRegular,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ])),
        ]),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sannip/util/dimensions.dart';
import 'package:sannip/util/styles.dart';
import 'package:sannip/common/widgets/custom_image.dart';

class LandingCardWidget extends StatelessWidget {
  final String icon;
  final String? imageBaseUrlType;
  final String title;
  const LandingCardWidget(
      {super.key,
      required this.icon,
      required this.title,
      this.imageBaseUrlType});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        color: Theme.of(context).primaryColor.withOpacity(0.05),
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        CustomImage(
          image: icon,
          height: 45,
          width: 45,
        ),
        const SizedBox(height: Dimensions.paddingSizeDefault),
        Text(title,
            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
            textAlign: TextAlign.center),
      ]),
    );
  }
}

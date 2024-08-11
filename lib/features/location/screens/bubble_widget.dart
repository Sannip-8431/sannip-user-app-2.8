import 'package:flutter/material.dart';
import 'package:sannip/util/dimensions.dart';
import 'package:sannip/util/images.dart';
import 'package:sannip/util/styles.dart';

class MapLocationBubbleWidget extends StatelessWidget {
  const MapLocationBubbleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipPath(
          clipper: SpeechBubbleClipper(),
          child: Container(
            color: Colors.black,
            padding: const EdgeInsets.only(
                bottom: Dimensions.paddingSizeDefault + 2,
                left: Dimensions.paddingSizeSmall,
                top: Dimensions.paddingSizeSmall / 2,
                right: Dimensions.paddingSizeSmall),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Order will be delivered here",
                  style: robotoMedium.copyWith(
                    color: Colors.white,
                  ),
                ),
                Text(
                  "Place the pin accurately on the map",
                  style: robotoRegular.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 2),
        Image.asset(Images.locationPin, height: 50, width: 50),
        const SizedBox(height: 112),
      ],
    );
  }
}

class SpeechBubbleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const double radius = 8.0;
    const double pointerWidth = 20.0;
    const double pointerHeight = 15.0;

    Path path = Path()
      ..moveTo(radius, 0)
      ..lineTo(size.width - radius, 0)
      ..arcToPoint(
        Offset(size.width, radius),
        radius: const Radius.circular(radius),
      )
      ..lineTo(size.width, size.height - radius - pointerHeight)
      ..arcToPoint(
        Offset(size.width - radius, size.height - pointerHeight),
        radius: const Radius.circular(radius),
      )
      ..lineTo(size.width / 2 + pointerWidth / 2, size.height - pointerHeight)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width / 2 - pointerWidth / 2, size.height - pointerHeight)
      ..lineTo(radius, size.height - pointerHeight)
      ..arcToPoint(
        Offset(0, size.height - radius - pointerHeight),
        radius: const Radius.circular(radius),
      )
      ..lineTo(0, radius)
      ..arcToPoint(
        const Offset(radius, 0),
        radius: const Radius.circular(radius),
      )
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

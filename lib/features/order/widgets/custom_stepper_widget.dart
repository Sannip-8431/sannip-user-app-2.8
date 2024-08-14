import 'package:sannip/util/dimensions.dart';
import 'package:sannip/util/styles.dart';
import 'package:flutter/material.dart';

class CustomStepperWidget extends StatelessWidget {
  final bool isActive;
  final bool haveLeftBar;
  final bool haveRightBar;
  final String title;
  final bool rightActive;
  final String? iconPath;
  final double? iconSize;
  const CustomStepperWidget(
      {super.key,
      required this.title,
      required this.isActive,
      required this.haveLeftBar,
      required this.haveRightBar,
      required this.rightActive,
      this.iconPath,
      this.iconSize});

  @override
  Widget build(BuildContext context) {
    Color color = isActive
        ? Theme.of(context).primaryColor
        : Theme.of(context).disabledColor;
    Color right = rightActive
        ? Theme.of(context).primaryColor
        : Theme.of(context).disabledColor;

    return Expanded(
      child: Column(children: [
        Row(children: [
          Expanded(
              child: haveLeftBar
                  ? Divider(color: color, thickness: 2)
                  : const SizedBox()),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3),
            child: iconPath != null
                ? Image.asset(
                    iconPath!,
                    color: color,
                    height: iconSize ?? 28,
                    width: iconSize ?? 28,
                  )
                : Icon(isActive ? Icons.check_circle : Icons.blur_circular,
                    color: color, size: isActive ? 25 : 15),
          ),
          Expanded(
              child: haveRightBar
                  ? Divider(color: right, thickness: 2)
                  : const SizedBox()),
        ]),
        Text(
          '$title\n',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: robotoMedium.copyWith(
              color: color, fontSize: Dimensions.fontSizeExtraSmall),
        ),
      ]),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:sannip/util/dimensions.dart';
import 'package:sannip/util/styles.dart';

class ExpandableText extends StatefulWidget {
  const ExpandableText(this.text, {super.key, this.textStyle});
  final String text;
  final TextStyle? textStyle;

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  String? firstHalf;
  String? secondHalf;
  bool flag = true;

  @override
  void initState() {
    super.initState();

    if (widget.text.length >= 125) {
      firstHalf = widget.text.substring(0, 125);
      secondHalf = widget.text.substring(125, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return secondHalf!.isEmpty
        ? Text(
            widget.text,
            style: widget.textStyle ??
                robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                  color: Theme.of(context).hintColor,
                ),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              flag
                  ? Padding(
                      padding: const EdgeInsets.only(right: 3.0),
                      child: Text(
                        "${firstHalf!}...",
                        style: widget.textStyle ??
                            robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeLarge,
                              color: Theme.of(context).hintColor,
                            ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(right: 3.0),
                      child: Text(
                        (firstHalf! + secondHalf!),
                        style: widget.textStyle ??
                            robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeLarge,
                              color: Theme.of(context).hintColor,
                            ),
                      ),
                    ),
              InkWell(
                onTap: () {
                  setState(() {
                    flag = !flag;
                  });
                },
                child: Text(
                  !flag ? 'read_less'.tr : 'read_more'.tr,
                  style: robotoMedium.copyWith(
                    fontSize: Dimensions.fontSizeLarge,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          );
  }
}

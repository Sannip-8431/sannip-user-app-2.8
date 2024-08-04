import 'package:flutter/material.dart';
import 'package:sannip/util/dimensions.dart';
import 'package:sannip/util/styles.dart';
import 'package:sannip/util/common_extenstions.dart';

class DeliveryDetailsWidget extends StatelessWidget {
  final bool from;
  final String? address;
  final String? stroeName;
  final String? addressType;

  const DeliveryDetailsWidget(
      {super.key,
      this.from = true,
      this.address,
      this.stroeName,
      this.addressType});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      /*  Icon(from ? Icons.store : Icons.location_on,
          size: 28, color: from ? Colors.blue : Theme.of(context).primaryColor),
      const SizedBox(width: Dimensions.paddingSizeSmall), */
      Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
            from
                ? stroeName?.toCapitalized() ?? 'From'
                : addressType?.toCapitalized() ?? 'To',
            style: robotoMedium),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
        Text(
          address ?? '',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: robotoRegular.copyWith(color: Theme.of(context).disabledColor),
        )
      ])),
    ]);
  }
}

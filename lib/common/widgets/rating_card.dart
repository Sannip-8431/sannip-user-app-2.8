import 'package:flutter/material.dart';
import 'package:sannip/util/dimensions.dart';
import 'package:sannip/util/styles.dart';

class RatingCard extends StatelessWidget {
  final double? rating;

  const RatingCard({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).primaryColor,
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Circular border
      ),
      child: Container(
        width: 50,
        height: 28,
        padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
        alignment: Alignment.center,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.star,
              color: Colors.white,
              size: Dimensions.paddingSizeDefault,
            ),
            const SizedBox(width: 2),
            Text(
              rating == 0.0 ? "0" : rating?.toStringAsFixed(1) ?? '0',
              style: robotoMedium.copyWith(
                  fontSize: Dimensions.fontSizeSmall, color: Colors.white),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

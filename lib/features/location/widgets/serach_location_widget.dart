import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sannip/features/location/widgets/location_search_dialog_widget.dart';
import 'package:sannip/features/parcel/controllers/parcel_controller.dart';
import 'package:sannip/util/dimensions.dart';
import 'package:sannip/util/styles.dart';

class SearchLocationWidget extends StatelessWidget {
  final GoogleMapController? mapController;
  final String? pickedAddress;
  final bool? isEnabled;
  final bool? isPickedUp;
  final bool? fromDialog;
  final String? hint;
  const SearchLocationWidget(
      {super.key,
      required this.mapController,
      required this.pickedAddress,
      required this.isEnabled,
      this.isPickedUp,
      this.hint,
      this.fromDialog = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.dialog(LocationSearchDialogWidget(
            mapController: mapController, isPickedUp: isPickedUp));
        if (isEnabled != null) {
          Get.find<ParcelController>().setIsPickedUp(isPickedUp, true);
        }
      },
      child: Container(
        height: 50,
        padding:
            const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          boxShadow: [
            BoxShadow(
                blurRadius: 1,
                spreadRadius: 1,
                color: Theme.of(context).hintColor.withOpacity(0.5))
          ],
          border: isEnabled != null
              ? Border.all(
                  color: fromDialog!
                      ? Theme.of(context).disabledColor
                      : isEnabled!
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).disabledColor,
                  width: isEnabled! ? 2 : 1,
                )
              : Border.all(
                  color: Theme.of(context).disabledColor,
                  width: 1,
                ),
        ),
        child: Row(children: [
          (/*!fromDialog! &&*/ pickedAddress != null &&
                  pickedAddress!.isNotEmpty)
              ? Icon(
                  Icons.location_on,
                  size: 25,
                  color: (isEnabled == null || isEnabled!)
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).disabledColor,
                )
              : Text('search_location'.tr,
                  style: robotoRegular.copyWith(
                      color: Theme.of(context).disabledColor)),
          const SizedBox(width: Dimensions.paddingSizeExtraSmall),
          Expanded(
            child: (pickedAddress != null && pickedAddress!.isNotEmpty)
                ? Text(
                    pickedAddress!,
                    style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeLarge),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                : Text(
                    hint ?? '',
                    style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeLarge,
                        color: Theme.of(context).hintColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),
          Icon(Icons.search,
              size: 25,
              color: fromDialog!
                  ? Theme.of(context).disabledColor
                  : Theme.of(context).textTheme.bodyLarge!.color),
        ]),
      ),
    );
  }
}

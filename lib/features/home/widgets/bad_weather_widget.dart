import 'package:flutter/material.dart';
import 'package:sannip/features/location/domain/models/zone_response_model.dart';
import 'package:sannip/helper/address_helper.dart';
import 'package:sannip/helper/responsive_helper.dart';
import 'package:sannip/util/dimensions.dart';
import 'package:sannip/util/images.dart';
import 'package:sannip/util/styles.dart';

class BadWeatherWidget extends StatefulWidget {
  final bool inParcel;
  const BadWeatherWidget({super.key, this.inParcel = false});

  @override
  State<BadWeatherWidget> createState() => _BadWeatherWidgetState();
}

class _BadWeatherWidgetState extends State<BadWeatherWidget> {
  bool _showAlert = true;
  String? _message;
  @override
  void initState() {
    super.initState();

    ZoneData? zoneData;
    for (var data in AddressHelper.getUserAddressFromSharedPref()!.zoneData!) {
      if (data.id == AddressHelper.getUserAddressFromSharedPref()!.zoneId) {
        if (data.increaseDeliveryFeeStatus == 1 &&
            data.increaseDeliveryFeeMessage != null) {
          zoneData = data;
        }
      }
    }

    if (zoneData != null) {
      _showAlert = zoneData.increaseDeliveryFeeStatus == 1;
      _message = zoneData.increaseDeliveryFeeMessage;
    } else {
      _showAlert = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _showAlert && _message != null && _message!.isNotEmpty
        ? Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12, blurRadius: 5, spreadRadius: 1)
                ]),
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeDefault,
                vertical: Dimensions.paddingSizeSmall),
            margin: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.isDesktop(context)
                    ? 0
                    : widget.inParcel
                        ? 0
                        : Dimensions.paddingSizeLarge,
                vertical: Dimensions.paddingSizeLarge),
            child: Row(
              children: [
                Image.asset(Images.weather, height: 50, width: 50),
                const SizedBox(width: Dimensions.paddingSizeSmall),
                Expanded(
                    child: Text(
                  _message!,
                  style: robotoMedium.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      color: Colors.black),
                )),
              ],
            ),
          )
        : const SizedBox();
  }
}

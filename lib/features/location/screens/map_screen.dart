import 'package:sannip/features/address/domain/models/address_model.dart';
import 'package:sannip/helper/marker_helper.dart';
import 'package:sannip/util/dimensions.dart';
import 'package:sannip/util/images.dart';
import 'package:sannip/util/styles.dart';
import 'package:sannip/common/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';

import 'package:sannip/common/widgets/menu_drawer.dart';
import 'package:sannip/features/order/widgets/address_details_widget.dart';

class MapScreen extends StatefulWidget {
  final AddressModel address;
  final bool fromStore;
  final bool isFood;
  const MapScreen(
      {super.key,
      required this.address,
      this.fromStore = false,
      this.isFood = false});

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  late LatLng _latLng;
  Set<Marker> _markers = {};
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();

    _latLng = LatLng(double.parse(widget.address.latitude!),
        double.parse(widget.address.longitude!));
    _setMarker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'location'.tr),
      endDrawer: const MenuDrawer(),
      endDrawerEnableOpenDragGesture: false,
      body: Center(
        child: SizedBox(
          width: Dimensions.webMaxWidth,
          child: Stack(children: [
            GoogleMap(
              cloudMapId: "2daff71eef425386",
              initialCameraPosition: CameraPosition(target: _latLng, zoom: 16),
              minMaxZoomPreference: const MinMaxZoomPreference(0, 30),
              zoomGesturesEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              indoorViewEnabled: true,
              markers: _markers,
              onMapCreated: (controller) => _mapController = controller,
            ),
            Positioned(
              left: Dimensions.paddingSizeLarge,
              right: Dimensions.paddingSizeLarge,
              bottom: Dimensions.paddingSizeLarge,
              child: InkWell(
                onTap: () {
                  if (_mapController != null) {
                    _mapController!.animateCamera(
                        CameraUpdate.newCameraPosition(
                            CameraPosition(target: _latLng, zoom: 17)));
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    color: Theme.of(context).cardColor,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey[300]!,
                          spreadRadius: 3,
                          blurRadius: 10)
                    ],
                  ),
                  child: widget.fromStore
                      ? Text(
                          widget.address.address!,
                          style: robotoMedium,
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Icon(
                                widget.address.addressType == 'home'
                                    ? Icons.home_outlined
                                    : widget.address.addressType == 'office'
                                        ? Icons.work_outline
                                        : Icons.location_on,
                                size: 30,
                                color: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(
                                  width: Dimensions.paddingSizeSmall),
                              Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(widget.address.addressType!.tr,
                                          style: robotoRegular.copyWith(
                                            fontSize: Dimensions.fontSizeSmall,
                                            color:
                                                Theme.of(context).disabledColor,
                                          )),
                                      const SizedBox(
                                          height:
                                              Dimensions.paddingSizeExtraSmall),
                                      AddressDetailsWidget(
                                          addressDetails: widget.address),
                                    ]),
                              ),
                            ]),
                            const SizedBox(height: Dimensions.paddingSizeSmall),
                            Text('- ${widget.address.contactPersonName}',
                                style: robotoMedium.copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: Dimensions.fontSizeLarge,
                                )),
                            Text('- ${widget.address.contactPersonNumber}',
                                style: robotoRegular),
                          ],
                        ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  void _setMarker() async {
    BitmapDescriptor markerIcon =
        await MarkerHelper.convertAssetToBitmapDescriptor(
      width: widget.isFood ? 100 : 150,
      imagePath: widget.fromStore
          ? widget.isFood
              ? Images.restaurantMarker
              : Images.markerStore
          : Images.locationMarker,
    );

    _markers = <Marker>{};
    _markers.add(Marker(
      markerId: const MarkerId('marker'),
      position: _latLng,
      icon: markerIcon,
    ));

    setState(() {});
  }
}

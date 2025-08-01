import 'dart:async';
import 'dart:collection';

import 'package:sannip/features/location/controllers/location_controller.dart';
import 'package:sannip/features/splash/controllers/splash_controller.dart';
import 'package:sannip/features/notification/domain/models/notification_body_model.dart';
import 'package:sannip/features/address/domain/models/address_model.dart';
import 'package:sannip/features/chat/domain/models/conversation_model.dart';
import 'package:sannip/features/order/controllers/order_controller.dart';
import 'package:sannip/features/order/domain/models/order_model.dart';
import 'package:sannip/features/store/domain/models/store_model.dart';
import 'package:sannip/helper/address_helper.dart';
import 'package:sannip/helper/marker_helper.dart';
import 'package:sannip/helper/responsive_helper.dart';
import 'package:sannip/helper/route_helper.dart';
import 'package:sannip/util/dimensions.dart';
import 'package:sannip/util/images.dart';
import 'package:sannip/common/widgets/custom_app_bar.dart';
import 'package:sannip/common/widgets/menu_drawer.dart';
import 'package:sannip/features/order/widgets/track_details_view_widget.dart';
import 'package:sannip/features/order/widgets/tracking_stepper_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderTrackingScreen extends StatefulWidget {
  final String? orderID;
  final String? contactNumber;
  const OrderTrackingScreen(
      {super.key, required this.orderID, this.contactNumber});

  @override
  OrderTrackingScreenState createState() => OrderTrackingScreenState();
}

class OrderTrackingScreenState extends State<OrderTrackingScreen> {
  GoogleMapController? _controller;
  bool _isLoading = true;
  Set<Marker> _markers = HashSet<Marker>();
  Timer? _timer;
  bool showChatPermission = true;

  void _loadData() async {
    await Get.find<OrderController>().trackOrder(widget.orderID, null, true,
        contactNumber: widget.contactNumber);
    await Get.find<LocationController>().getCurrentLocation(true,
        notify: false,
        defaultLatLng: LatLng(
          double.parse(AddressHelper.getUserAddressFromSharedPref()!.latitude!),
          double.parse(
              AddressHelper.getUserAddressFromSharedPref()!.longitude!),
        ));
  }

  void _startApiCall() {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      Get.find<OrderController>().timerTrackOrder(widget.orderID.toString(),
          contactNumber: widget.contactNumber);
    });
  }

  @override
  void initState() {
    super.initState();

    _loadData();
    _startApiCall();
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'order_tracking'.tr),
      endDrawer: const MenuDrawer(),
      endDrawerEnableOpenDragGesture: false,
      body: GetBuilder<OrderController>(builder: (orderController) {
        OrderModel? track;
        if (orderController.trackModel != null) {
          track = orderController.trackModel;

          if (track!.store!.storeBusinessModel == 'commission') {
            showChatPermission = true;
          } else if (track.store!.storeSubscription != null &&
              track.store!.storeBusinessModel == 'subscription') {
            showChatPermission = track.store!.storeSubscription!.chat == 1;
          } else {
            showChatPermission = false;
          }
        }

        return track != null
            ? Center(
                child: SizedBox(
                    width: Dimensions.webMaxWidth,
                    child: Stack(children: [
                      GoogleMap(
                        cloudMapId: "2daff71eef425386",
                        initialCameraPosition: CameraPosition(
                            target: LatLng(
                              double.parse(track.deliveryAddress!.latitude!),
                              double.parse(track.deliveryAddress!.longitude!),
                            ),
                            zoom: 16),
                        minMaxZoomPreference: const MinMaxZoomPreference(0, 30),
                        zoomControlsEnabled: false,
                        markers: _markers,
                        onMapCreated: (GoogleMapController controller) {
                          _controller = controller;
                          _isLoading = false;
                          setMarker(
                            track!.orderType == 'parcel'
                                ? Store(
                                    latitude: track.receiverDetails!.latitude,
                                    longitude: track.receiverDetails!.longitude,
                                    address: track.receiverDetails!.address,
                                    name: track
                                        .receiverDetails!.contactPersonName)
                                : track.store,
                            track.deliveryMan,
                            track.orderType == 'take_away'
                                ? Get.find<LocationController>()
                                            .position
                                            .latitude ==
                                        0
                                    ? track.deliveryAddress
                                    : AddressModel(
                                        latitude: Get.find<LocationController>()
                                            .position
                                            .latitude
                                            .toString(),
                                        longitude:
                                            Get.find<LocationController>()
                                                .position
                                                .longitude
                                                .toString(),
                                        address: Get.find<LocationController>()
                                            .address,
                                      )
                                : track.deliveryAddress,
                            track.orderType == 'take_away',
                            track.orderType == 'parcel',
                            track.moduleType == 'food',
                          );
                        },
                      ),
                      _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : const SizedBox(),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: TrackingStepperWidget(
                            status: track.orderStatus,
                            takeAway: track.orderType == 'take_away'),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: TrackDetailsViewWidget(
                            status: track.orderStatus,
                            track: track,
                            showChatPermission: showChatPermission,
                            callback: () async {
                              _timer?.cancel();
                              await Get.toNamed(RouteHelper.getChatRoute(
                                notificationBody: NotificationBodyModel(
                                    deliverymanId: track!.deliveryMan!.id,
                                    orderId: int.parse(widget.orderID!)),
                                user: User(
                                    id: track.deliveryMan!.id,
                                    fName: track.deliveryMan!.fName,
                                    lName: track.deliveryMan!.lName,
                                    imageFullUrl:
                                        track.deliveryMan!.imageFullUrl),
                              ));
                              _startApiCall();
                            }),
                      ),
                    ])))
            : const Center(child: CircularProgressIndicator());
      }),
    );
  }

  void setMarker(
      Store? store,
      DeliveryMan? deliveryMan,
      AddressModel? addressModel,
      bool takeAway,
      bool parcel,
      bool isRestaurant) async {
    try {
      BitmapDescriptor restaurantImageData =
          await MarkerHelper.convertAssetToBitmapDescriptor(
        width: (isRestaurant || parcel) ? 100 : 150,
        imagePath: parcel
            ? Images.userMarker
            : isRestaurant
                ? Images.restaurantMarker
                : Images.markerStore,
      );

      BitmapDescriptor deliveryBoyImageData =
          await MarkerHelper.convertAssetToBitmapDescriptor(
        width: 100,
        imagePath: Images.deliveryManMarker,
      );
      BitmapDescriptor destinationImageData =
          await MarkerHelper.convertAssetToBitmapDescriptor(
        width: 100,
        imagePath: takeAway ? Images.myLocationMarker : Images.userMarker,
      );

      // Animate to coordinate
      LatLngBounds? bounds;
      double rotation = 0;
      if (_controller != null) {
        if (double.parse(addressModel!.latitude!) <
            double.parse(store!.latitude!)) {
          bounds = LatLngBounds(
            southwest: LatLng(double.parse(addressModel.latitude!),
                double.parse(addressModel.longitude!)),
            northeast: LatLng(
                double.parse(store.latitude!), double.parse(store.longitude!)),
          );
          rotation = 0;
        } else {
          bounds = LatLngBounds(
            southwest: LatLng(
                double.parse(store.latitude!), double.parse(store.longitude!)),
            northeast: LatLng(double.parse(addressModel.latitude!),
                double.parse(addressModel.longitude!)),
          );
          rotation = 180;
        }
      }
      LatLng centerBounds = LatLng(
        (bounds!.northeast.latitude + bounds.southwest.latitude) / 2,
        (bounds.northeast.longitude + bounds.southwest.longitude) / 2,
      );

      _controller!.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: centerBounds, zoom: GetPlatform.isWeb ? 10 : 17)));
      if (!ResponsiveHelper.isWeb()) {
        zoomToFit(_controller, bounds, centerBounds,
            padding: GetPlatform.isWeb ? 15 : 3);
      }

      /// user for normal order , but sender for parcel order
      _markers = HashSet<Marker>();
      addressModel != null
          ? _markers.add(Marker(
              markerId: const MarkerId('destination'),
              position: LatLng(double.parse(addressModel.latitude!),
                  double.parse(addressModel.longitude!)),
              infoWindow: InfoWindow(
                title: parcel ? 'Sender' : 'Destination',
                snippet: addressModel.address,
              ),
              icon: destinationImageData,
            ))
          : const SizedBox();

      ///store for normal order , but receiver for parcel order
      store != null
          ? _markers.add(Marker(
              markerId: const MarkerId('store'),
              position: LatLng(double.parse(store.latitude!),
                  double.parse(store.longitude!)),
              infoWindow: InfoWindow(
                title: parcel
                    ? 'Receiver'
                    : Get.find<SplashController>()
                            .configModel!
                            .moduleConfig!
                            .module!
                            .showRestaurantText!
                        ? 'store'.tr
                        : 'store'.tr,
                snippet: store.address,
              ),
              icon: restaurantImageData,
            ))
          : const SizedBox();

      deliveryMan != null
          ? _markers.add(Marker(
              markerId: const MarkerId('delivery_boy'),
              position: LatLng(double.parse(deliveryMan.lat ?? '0'),
                  double.parse(deliveryMan.lng ?? '0')),
              infoWindow: InfoWindow(
                title: 'delivery_man'.tr,
                snippet: deliveryMan.location,
              ),
              rotation: rotation,
              icon: deliveryBoyImageData,
            ))
          : const SizedBox();
    } catch (_) {}
    setState(() {});
  }

  Future<void> zoomToFit(GoogleMapController? controller, LatLngBounds? bounds,
      LatLng centerBounds,
      {double padding = 0.5}) async {
    bool keepZoomingOut = true;

    while (keepZoomingOut) {
      final LatLngBounds screenBounds = await controller!.getVisibleRegion();
      if (fits(bounds!, screenBounds)) {
        keepZoomingOut = false;
        final double zoomLevel = await controller.getZoomLevel() - padding;
        controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: centerBounds,
          zoom: zoomLevel,
        )));
        break;
      } else {
        // Zooming out by 0.1 zoom level per iteration
        final double zoomLevel = await controller.getZoomLevel() - 0.1;
        controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: centerBounds,
          zoom: zoomLevel,
        )));
      }
    }
  }

  bool fits(LatLngBounds fitBounds, LatLngBounds screenBounds) {
    final bool northEastLatitudeCheck =
        screenBounds.northeast.latitude >= fitBounds.northeast.latitude;
    final bool northEastLongitudeCheck =
        screenBounds.northeast.longitude >= fitBounds.northeast.longitude;

    final bool southWestLatitudeCheck =
        screenBounds.southwest.latitude <= fitBounds.southwest.latitude;
    final bool southWestLongitudeCheck =
        screenBounds.southwest.longitude <= fitBounds.southwest.longitude;

    return northEastLatitudeCheck &&
        northEastLongitudeCheck &&
        southWestLatitudeCheck &&
        southWestLongitudeCheck;
  }
}

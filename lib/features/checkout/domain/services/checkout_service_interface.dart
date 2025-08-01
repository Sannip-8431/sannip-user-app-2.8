import 'package:get/get_connect/http/src/response/response.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sannip/api/api_client.dart';
import 'package:sannip/features/store/domain/models/store_model.dart';
import 'package:sannip/features/payment/domain/models/offline_method_model.dart';
import 'package:sannip/features/checkout/domain/models/place_order_body_model.dart';
import 'package:sannip/features/checkout/domain/models/timeslote_model.dart';

abstract class CheckoutServiceInterface {
  Future<List<OfflineMethodModel>?> getOfflineMethodList();
  Future<int> getDmTipMostTapped();
  String getSharedPrefDmTipIndex();
  Future<bool> saveSharedPrefDmTipIndex(String index);
  Future<List<TimeSlotModel>?> initializeTimeSlot(
      Store store, int? scheduleOrderSlotDuration);
  List<TimeSlotModel>? validateTimeSlot(List<TimeSlotModel> slots,
      int dateIndex, int? interval, bool? orderPlaceToScheduleInterval);
  Future<Response> getDistanceInMeter(
      LatLng originLatLng, LatLng destinationLatLng);
  Future<double> getExtraCharge(double? distance);
  Future<Response> placeOrder(
      PlaceOrderBodyModel orderBody, List<MultipartBody> orderAttachment);
  Future<Response> placePrescriptionOrder(
      int? storeId,
      double? distance,
      String address,
      String longitude,
      String latitude,
      String note,
      List<MultipartBody> orderAttachment,
      String dmTips,
      String deliveryInstruction);
}

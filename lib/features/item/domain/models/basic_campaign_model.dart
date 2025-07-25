import 'package:sannip/features/store/domain/models/store_model.dart';

class BasicCampaignModel {
  int? id;
  String? title;
  String? imageFullUrl;
  String? description;
  String? availableDateStarts;
  String? availableDateEnds;
  String? startTime;
  String? endTime;
  List<Store>? store;

  BasicCampaignModel({
    this.id,
    this.title,
    this.imageFullUrl,
    this.description,
    this.availableDateStarts,
    this.availableDateEnds,
    this.startTime,
    this.endTime,
    this.store,
  });

  BasicCampaignModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    imageFullUrl = json['image_full_url'];
    description = json['description'];
    availableDateStarts = json['available_date_starts'];
    availableDateEnds = json['available_date_ends'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    if (json['stores'] != null) {
      store = [];
      json['stores'].forEach((v) {
        store!.add(Store.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['image_full_url'] = imageFullUrl;
    data['description'] = description;
    data['available_date_starts'] = availableDateStarts;
    data['available_date_ends'] = availableDateEnds;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    if (store != null) {
      data['stores'] = store!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

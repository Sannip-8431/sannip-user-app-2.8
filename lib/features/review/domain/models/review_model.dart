class ReviewModel {
  int? id;
  String? comment;
  int? rating;
  String? itemName;
  String? itemImageFullUrl;
  String? customerName;
  String? createdAt;
  String? updatedAt;
  String? reply;

  ReviewModel({
    this.id,
    this.comment,
    this.rating,
    this.itemName,
    this.itemImageFullUrl,
    this.customerName,
    this.createdAt,
    this.updatedAt,
    this.reply,
  });

  ReviewModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    comment = json['comment'];
    rating = json['rating'];
    itemName = json['item_name'];
    itemImageFullUrl = json['item_image_full_url'];
    customerName = json['customer_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    reply = json['reply'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['comment'] = comment;
    data['rating'] = rating;
    data['item_name'] = itemName;
    data['item_image_full_url'] = itemImageFullUrl;
    data['customer_name'] = customerName;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['reply'] = reply;
    return data;
  }
}

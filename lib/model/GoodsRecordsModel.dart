
import 'GoodModel.dart';

class GoodsRecordsModel {
  GoodsRecordsModel({
      this.data,});

  GoodsRecordsModel.fromJson(dynamic json) {
    if (json['records'] != null) {
      data = [];
      json['records'].forEach((v) {
        data?.add(GoodModel.fromJson(v));
      });
    }
  }

  List<GoodModel>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}
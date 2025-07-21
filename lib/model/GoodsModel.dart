
import 'GoodModel.dart';

class GoodsModel {
  GoodsModel({
      this.data,});

  GoodsModel.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
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

import 'GoodModel.dart';

class GoodsBreadModel {
  GoodsBreadModel({
      this.data,});

  GoodsBreadModel.fromJson(dynamic json) {
    if (json['psItemKinds'] != null) {
      data = [];
      json['psItemKinds'].forEach((v) {
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
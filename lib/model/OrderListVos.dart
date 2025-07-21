
import 'OrderListVo.dart';

class OrderListVos {
  OrderListVos({
      this.data,});

  OrderListVos.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(OrderListVo.fromJson(v));
      });
    }
  }

  List<OrderListVo>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}
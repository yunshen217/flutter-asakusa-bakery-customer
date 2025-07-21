
import 'ItemKindVo.dart';

class ItemKindVos {
  ItemKindVos({
      this.data,});

ItemKindVos.fromJson(dynamic json) {
  final dynamic dataJson = json['data'];
  if (dataJson != null) {
    data = []; // 初始化列表
    
    if (dataJson is List) { 
      // 处理 List 类型
      for (var item in dataJson) {
        data?.add(ItemKindVo.fromJson(item));
      }
    } else if (dataJson is Map<String, dynamic>) { 
      // 处理 Map 类型
      // 若需要提取 Map 的 value 作为列表项
      dataJson['itemKindList'].forEach((v) {
        data?.add(ItemKindVo.fromJson(v));
      });
    }
  }
}

  List<ItemKindVo>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}
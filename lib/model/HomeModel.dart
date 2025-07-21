import 'Records.dart';

class HomeModel {
  HomeModel({
    this.records,
    this.total,
    this.size,
    this.current,
    this.orders,
    this.optimizeCountSql,
    this.searchCount,
    this.maxLimit,
    this.countId,
    this.pages,
  });

  HomeModel.fromJson(dynamic json) {
    if (json['records'] != null) {
      records = [];
      json['records'].forEach((v) {
        records?.add(Records.fromJson(v));
      });
    }
    total = json['total'];
    size = json['size'];
    current = json['current'];
    optimizeCountSql = json['optimizeCountSql'];
    searchCount = json['searchCount'];
    maxLimit = json['maxLimit'];
    countId = json['countId'];
    pages = json['pages'];
  }

  List<Records>? records;
  num? total;
  num? size;
  num? current;
  List<dynamic>? orders;
  bool? optimizeCountSql;
  bool? searchCount;
  dynamic maxLimit;
  dynamic countId;
  num? pages;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (records != null) {
      map['records'] = records?.map((v) => v.toJson()).toList();
    }
    map['total'] = total;
    map['size'] = size;
    map['current'] = current;
    if (orders != null) {
      map['orders'] = orders?.map((v) => v.toJson()).toList();
    }
    map['optimizeCountSql'] = optimizeCountSql;
    map['searchCount'] = searchCount;
    map['maxLimit'] = maxLimit;
    map['countId'] = countId;
    map['pages'] = pages;
    return map;
  }
}

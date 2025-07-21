class PointModel {
  PointModel({
      this.point, 
      this.pointHistoryList,});

  PointModel.fromJson(dynamic json) {
    point = json['point'];
    if (json['pointHistoryList'] != null) {
      pointHistoryList = [];
      json['pointHistoryList'].forEach((v) {
        pointHistoryList?.add(PointHistoryList.fromJson(v));
      });
    }
  }
  num? point;
  List<PointHistoryList>? pointHistoryList;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['point'] = point;
    if (pointHistoryList != null) {
      map['pointHistoryList'] = pointHistoryList?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class PointHistoryList {
  PointHistoryList({
      this.id, 
      this.createBy, 
      this.createTime, 
      this.updateBy, 
      this.updateTime, 
      this.delFlag, 
      this.customerId, 
      this.description, 
      this.type, 
      this.point,});

  PointHistoryList.fromJson(dynamic json) {
    id = json['id'];
    createBy = json['createBy'];
    createTime = json['createTime'];
    updateBy = json['updateBy'];
    updateTime = json['updateTime'];
    delFlag = json['delFlag'];
    customerId = json['customerId'];
    description = json['description'];
    type = json['type'];
    point = json['point'];
  }
  String? id;
  String? createBy;
  String? createTime;
  dynamic updateBy;
  String? updateTime;
  String? delFlag;
  String? customerId;
  String? description;
  String? type;
  num? point;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['createBy'] = createBy;
    map['createTime'] = createTime;
    map['updateBy'] = updateBy;
    map['updateTime'] = updateTime;
    map['delFlag'] = delFlag;
    map['customerId'] = customerId;
    map['description'] = description;
    map['type'] = type;
    map['point'] = point;
    return map;
  }

}
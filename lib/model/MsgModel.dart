class MsgModel {
  MsgModel({
      this.data,});

  MsgModel.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
  }
  List<Data>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Data {
  Data({
      this.id, 
      this.createBy, 
      this.createTime, 
      this.updateBy, 
      this.updateTime, 
      this.delFlag, 
      this.messageType, 
      this.businessId, 
      this.title, 
      this.message, 
      this.readFlag, 
      this.receiverId, 
      this.senderId,});

  Data.fromJson(dynamic json) {
    id = json['id'];
    createBy = json['createBy'];
    createTime = json['createTime'];
    updateBy = json['updateBy'];
    updateTime = json['updateTime'];
    delFlag = json['delFlag'];
    messageType = json['messageType'];
    businessId = json['businessId'];
    title = json['title'];
    message = json['message'];
    readFlag = json['readFlag'];
    receiverId = json['receiverId'];
    senderId = json['senderId'];
    orderStatus = json['orderStatus'];
  }
  String? id;
  dynamic createBy;
  String? createTime;
  dynamic updateBy;
  dynamic updateTime;
  String? delFlag;
  String? messageType;
  String? businessId;
  dynamic title;
  String? message;
  String? readFlag;
  String? receiverId;
  String? senderId;
  String? orderStatus;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['createBy'] = createBy;
    map['createTime'] = createTime;
    map['updateBy'] = updateBy;
    map['updateTime'] = updateTime;
    map['delFlag'] = delFlag;
    map['messageType'] = messageType;
    map['businessId'] = businessId;
    map['title'] = title;
    map['message'] = message;
    map['readFlag'] = readFlag;
    map['receiverId'] = receiverId;
    map['senderId'] = senderId;
    map['orderStatus'] = orderStatus;
    return map;
  }

}
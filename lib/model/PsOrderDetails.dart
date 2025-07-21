class PsOrderDetails {
  PsOrderDetails({
      this.id, 
      this.createBy, 
      this.createTime, 
      this.updateBy, 
      this.updateTime, 
      this.delFlag, 
      this.orderId, 
      this.itemPrice, 
      this.taxRate, 
      this.taxDeductionAmount, 
      this.appointmentTime, 
      this.itemId, 
      this.itemCount, 
      this.filePath, 
      this.itemName, 
      this.itemKindName,});

  PsOrderDetails.fromJson(dynamic json) {
    id = json['id'];
    createBy = json['createBy'];
    createTime = json['createTime'];
    updateBy = json['updateBy'];
    updateTime = json['updateTime'];
    delFlag = json['delFlag'];
    orderId = json['orderId'];
    itemPrice = json['itemPrice'];
    taxRate = json['taxRate'];
    taxDeductionAmount = json['taxDeductionAmount'];
    appointmentTime = json['appointmentTime'];
    itemId = json['itemId'];
    itemCount = json['itemCount'];
    filePath = json['filePath'];
    itemName = json['itemName'];
    itemKindName = json['itemKindName'];
  }
  String? id;
  String? createBy;
  String? createTime;
  dynamic updateBy;
  dynamic updateTime;
  String? delFlag;
  String? orderId;
  num? itemPrice;
  num? taxRate;
  dynamic taxDeductionAmount;
  String? appointmentTime;
  String? itemId;
  num? itemCount;
  String? filePath;
  String? itemName;
  dynamic itemKindName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['createBy'] = createBy;
    map['createTime'] = createTime;
    map['updateBy'] = updateBy;
    map['updateTime'] = updateTime;
    map['delFlag'] = delFlag;
    map['orderId'] = orderId;
    map['itemPrice'] = itemPrice;
    map['taxRate'] = taxRate;
    map['taxDeductionAmount'] = taxDeductionAmount;
    map['appointmentTime'] = appointmentTime;
    map['itemId'] = itemId;
    map['itemCount'] = itemCount;
    map['filePath'] = filePath;
    map['itemName'] = itemName;
    map['itemKindName'] = itemKindName;
    return map;
  }

}
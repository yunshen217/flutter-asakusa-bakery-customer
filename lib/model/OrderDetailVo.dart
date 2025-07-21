class OrderDetailVo {
  OrderDetailVo({
      this.itemName, 
      this.itemCount, 
      this.itemPrice, 
      this.filePath
    });

  OrderDetailVo.fromJson(dynamic json) {
    itemName = json['itemName'];
    itemCount = json['itemCount']??0;
    itemPrice = json['itemPrice']??0;
    filePath = json['filePath'];
  }
  String? itemName;
  num? itemCount;
  num? itemPrice;
  dynamic filePath;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['itemName'] = itemName;
    map['itemCount'] = itemCount;
    map['itemPrice'] = itemPrice;
    map['filePath'] = filePath;
    return map;
  }
}
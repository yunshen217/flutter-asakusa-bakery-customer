class GoodModel {
  GoodModel({
    this.id,
    this.itemName,
    this.itemKindId,
    this.price,
    this.timePeriodId,
    this.filePath,
    required this.totalInventoryCount,
    this.itemCount,
    this.merchantId,
    this.disFlag
  });

  GoodModel.fromJson(dynamic json) {
    id = json['id'];
    itemName = json['itemName'];
    itemKindId = json['itemKindId'];
    price = json['price'] ?? 0;
    filePath = json['filePath'] ?? json['fieldPath'];
    totalInventoryCount = json['totalInventoryCount'] ?? 0;
    timePeriodId = json['timePeriodId'] ?? 0;
    itemCount = json['itemCount'] ?? 0;
    merchantId = json['merchantId'];
    disFlag = json['disFlag'];
  }

  String? id;
  String? itemName;
  String? itemKindId;
  num? price;
  String? filePath;
  num totalInventoryCount = 0;
  num? timePeriodId;
  String? merchantId;
  String? disFlag;

  num? itemCount = 0;
  
  bool select = false;

  // String getState() {
  //   if (orderStatus == "0") {
  //     return "キャンセル";
  //   } else if (orderStatus == "1") {
  //     return "支払待ち";
  //   } else if (orderStatus == "2") {
  //     return "注文確定";
  //   } else if (orderStatus == "3") {
  //     return "製作中";
  //   } else if (orderStatus == "4") {
  //     return "焼き上り";
  //   } else if (orderStatus == "5") {
  //     return "出荷済";
  //   }
  //   return "受取済";
  // }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['itemName'] = itemName;
    map['itemKindId'] = itemKindId;
    map['price'] = price;
    map['filePath'] = filePath;
    map['totalInventoryCount'] = totalInventoryCount;
    map['timePeriodId'] = timePeriodId;
    map['itemCount'] = itemCount;
    map['merchantId'] = merchantId;
    map['disFlag'] = disFlag;
    return map;
  }
}

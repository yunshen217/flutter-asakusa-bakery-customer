class OrderListVo {
  OrderListVo({
      this.id, 
      this.orderStatus, 
      this.sumPrice, 
      this.isSend,
      this.merchantName,
      this.filePath,
      this.appointmentTime
    });

  OrderListVo.fromJson(dynamic json) {
    id = json['id'];
    orderStatus = json['orderStatus'];
    sumPrice = json['sumPrice']??0;
    isSend = json['isSend']??0;
    merchantName = json['merchantName']??"";
    filePath = json['filePath']??"";
    appointmentTime = json['appointmentTime']??"";
  }
  String? id;
  String? orderStatus;
  num? sumPrice;
  num? isSend;
  String? merchantName;
  String? filePath;
  String? appointmentTime;

  String getState() {
    if (orderStatus == "0") {
      return "キャンセル";
    } else if (orderStatus == "1") {
      return "支払待ち";
    } else if (orderStatus == "2") {
      return "注文確定";
    } else if (orderStatus == "3") {
      return "製作中";
    } else if (orderStatus == "4") {
      return "焼き上り";
    } else if (orderStatus == "5") {
      return "出荷済";
    }
    return "受取済";
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['orderStatus'] = orderStatus;
    map['sumPrice'] = sumPrice;
    map['filePath'] = filePath;
    map['isSend'] = isSend;
    map['merchantName'] = merchantName;
    map['appointmentTime'] = appointmentTime;
    return map;
  }
}
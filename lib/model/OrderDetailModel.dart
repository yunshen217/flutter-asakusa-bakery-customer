import 'OrderDetailVo.dart';

class OrderDetailModel {
  OrderDetailModel(
      {this.orderNo,
      this.orderStatus,
      this.isSend,
      this.sendName,
      this.phoneNumber,
      this.postcode,
      this.municipalities,
      this.streetAddress,
      this.building,
      this.remark,
      this.paymentChannel,
      this.paymentStatus,
      this.pickupNo,
      this.sendNo,
      this.prefectures,
      this.merchantName,
      this.psOrderDetails,
      this.sendTime,
      this.orderDate,
      this.deliveryCharge,
      this.refrigerationFee,
      this.usedPoint,
      this.earnedPoint});

  OrderDetailModel.fromJson(dynamic json) {
    orderNo = json['orderNo'];
    orderStatus = json['orderStatus'] ?? "0";
    isSend = json['isSend'];
    sendName = json['sendName'];
    phoneNumber = json['phoneNumber'];
    postcode = json['postcode'];
    prefectures = json['prefectures'];
    municipalities = json['municipalities'];
    streetAddress = json['streetAddress'];
    building = json['building'];
    remark = json['remark'];
    paymentChannel = json['paymentChannel'];
    paymentStatus = json['paymentStatus'];
    pickupNo = json['pickupNo'] ?? "";
    sendNo = json['sendNo'];
    merchantName = json['merchantName'];
    longitudeLatitude = json['longitudeLatitude'];
    if (json['psOrderDetails'] != null) {
      psOrderDetails = [];
      json['psOrderDetails'].forEach((v) {
        psOrderDetails?.add(OrderDetailVo.fromJson(v));
      });
    }
    sendTime = json['sendTime'] ?? "";
    orderDate = json['orderDate'];
    deliveryCharge = json['deliveryCharge'];
    refrigerationFee = json['refrigerationFee'];
    usedPoint = json['usedPoint'];
    earnedPoint = json['earnedPoint'];
  }

  double? get getLatitude => double.parse(longitudeLatitude!.split(",")[1]);

  double? get getLongitude => double.parse(longitudeLatitude!.split(",")[0]);

  num getTotalItemPrice() {
    num sum = 0;
    for (var item in psOrderDetails!) {
      sum += (item.itemPrice! * item.itemCount!);
    }
    return sum;
  }

  sendStartTime() {
    if (sendTime != null && sendTime!.isNotEmpty) {
      return sendTime!.split(" ")[0];
    }
    return "";
  }

  sendEndTime() {
    if (sendTime != null && sendTime!.isNotEmpty) {
      return sendTime!.split(" ")[1];
    }
    return "";
  }

  payState() {
    switch (paymentStatus) {
      case "0":
        return "未払い";
      case "1":
        return "支払済";
      case "2":
        return "支払キャンセル";
      case "3":
        return "返金済";
      case "4":
        return "支払エラー";
    }
    return "";
  }

  payWay() {
    switch (paymentChannel) {
      case "1":
        return "PayPay";
      case "4":
        return "クレジットカード";
      case "20":
        return "その他(支払待ち)";
      case "21":
        return "その他(PayPay)";
      case "22":
        return "その他(銀行振込)";
      case "23":
        return "その他(店頭払い)";
      case "24":
        return "その他";
      case "25":
        return "その他(WeChat)";
      case "26":
        return "その他(AliPay)";
    }
    return "その他-その他";
  }

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

  String? orderNo;
  String? orderStatus;
  String? merchantName;
  num? isSend;
  dynamic sendName;
  String? phoneNumber;
  dynamic postcode;
  dynamic prefectures;
  dynamic municipalities;
  dynamic streetAddress;
  dynamic building;
  String? remark;
  String? paymentChannel;
  String? paymentStatus;
  String? longitudeLatitude;
  String? pickupNo;
  dynamic sendNo;
  List<OrderDetailVo>? psOrderDetails;
  String? sendTime;
  String? orderDate;
  num? deliveryCharge;
  num? refrigerationFee;
  num? usedPoint;
  num? earnedPoint;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['orderNo'] = orderNo;
    map['orderStatus'] = orderStatus;
    map['isSend'] = isSend;
    map['sendName'] = sendName;
    map['phoneNumber'] = phoneNumber;
    map['postcode'] = postcode;
    map['prefectures'] = prefectures;
    map['municipalities'] = municipalities;
    map['streetAddress'] = streetAddress;
    map['building'] = building;
    map['remark'] = remark;
    map['longitudeLatitude'] = longitudeLatitude;
    map['paymentChannel'] = paymentChannel;
    map['paymentStatus'] = paymentStatus;
    map['pickupNo'] = pickupNo;
    map['sendNo'] = sendNo;
    map['prefectures'] = prefectures;
    map['merchantName'] = merchantName;
    if (psOrderDetails != null) {
      map['psOrderDetails'] = psOrderDetails?.map((v) => v.toJson()).toList();
    }
    map['sendTime'] = sendTime;
    map['orderDate'] = orderDate;
    map['deliveryCharge'] = deliveryCharge;
    map['refrigerationFee'] = refrigerationFee;
    map['usedPoint'] = usedPoint;
    map['earnedPoint'] = earnedPoint;
    return map;
  }
}

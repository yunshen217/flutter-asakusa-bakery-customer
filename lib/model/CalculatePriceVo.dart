class CalculatePriceVo {
  CalculatePriceVo({
      this.totalAmount, 
      this.deliveryCharge, 
      this.refrigerationFee
    });

  CalculatePriceVo.fromJson(dynamic json) {
    totalAmount = json['totalAmount'];
    deliveryCharge = json['deliveryCharge'];
    refrigerationFee = json['refrigerationFee'];
  }
  num? totalAmount;
  num? deliveryCharge;
  num? refrigerationFee;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['totalAmount'] = totalAmount;
    map['deliveryCharge'] = deliveryCharge;
    map['refrigerationFee'] = refrigerationFee;
    return map;
  }

  num getTotalPrice() {
    return (totalAmount ?? 0) + (deliveryCharge ?? 0) + (refrigerationFee ?? 0);
  }
}
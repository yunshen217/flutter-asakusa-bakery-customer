class CreditCardModel {
  CreditCardModel({
      this.cardId,
      this.cardNumber,
      this.cardExpire,
      this.cardholderName,
      this.defaultCard
      });

  CreditCardModel.fromJson(dynamic json) {
    cardId = json['cardId'];
    cardNumber = json['cardNumber']??"";
    cardExpire = json['cardExpire']??"";
    cardholderName = json['cardholderName']??"";
    defaultCard = json['defaultCard']??"";
  }
  String? cardId;
  String? cardNumber;
  String? cardExpire;
  String? cardholderName;
  String? defaultCard;
  

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['cardId'] = cardId;
    map['cardNumber'] = cardNumber;
    map['cardExpire'] = cardExpire;
    map['cardholderName'] = cardholderName;
    map['defaultCard'] = defaultCard;
   
    return map;
  }

}
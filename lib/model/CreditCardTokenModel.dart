class CreditCardTokenModel {
  CreditCardTokenModel({
    this.token,
    this.tokenExpireDate,
    this.cardNumber,
    this.prefecturesCode,
    this.status,
    this.code,
    this.message
  });

  CreditCardTokenModel.fromJson(dynamic json) {
    token = json['token'];
    tokenExpireDate = json['token_expire_date'];
    cardNumber = json['req_card_number'] ;
    status = json['status'];
    code = json['code'];
    message = json['message'];

  }

  String? token;
  String? tokenExpireDate;
  String? cardNumber;
  dynamic prefecturesCode;
  String? status;
  String? code;
  String? message;
}

import 'package:shopping_client/model/CreditCardModel.dart';

class CreditCardsModel {
  CreditCardsModel({
    this.data,
  });

  CreditCardsModel.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(CreditCardModel.fromJson(v));
      });
    }
  }

  List<CreditCardModel>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

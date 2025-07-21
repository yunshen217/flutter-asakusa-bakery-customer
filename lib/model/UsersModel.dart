
import 'package:shopping_client/model/UserModel.dart';

class UsersModel {
  UsersModel({
    this.data,
  });

  UsersModel.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(UserModel.fromJson(v));
      });
    }
  }

  List<UserModel>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

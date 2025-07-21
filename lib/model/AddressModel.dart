class AddressModel {
  AddressModel({
    this.data,
  });

  AddressModel.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
  }

  List<Data>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Data {
  Data({
    this.id,
    this.nickName,
    this.postcode,
    this.prefecturesCode,
    this.municipalities,
    this.streetAddress,
    this.building,
    this.telephoneNo,
    this.defaultFlag,
    this.prefecturesCodeName
  });

  Data.fromJson(dynamic json) {
    id = json['id'];
    nickName = json['nickName'];
    postcode = json['postcode'];
    prefecturesCode = json['prefecturesCode'] ?? "";
    municipalities = json['municipalities'];
    streetAddress = json['streetAddress'];
    building = json['building'];
    telephoneNo = json['telephoneNo'];
    defaultFlag = json['defaultFlag'];
    prefecturesCodeName = json['prefecturesCodeName']??"";
  }

  String? id;
  String? nickName;
  String? postcode;
  dynamic prefecturesCode;
  String? municipalities;
  String? streetAddress;
  String? building;
  String? telephoneNo;
  String? defaultFlag;
  dynamic prefecturesCodeName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['nickName'] = nickName;
    map['postcode'] = postcode;
    map['prefecturesCode'] = prefecturesCode;
    map['municipalities'] = municipalities;
    map['streetAddress'] = streetAddress;
    map['building'] = building;
    map['telephoneNo'] = telephoneNo;
    map['defaultFlag'] = defaultFlag;
    map['prefecturesCodeName'] = prefecturesCodeName;
    return map;
  }
}

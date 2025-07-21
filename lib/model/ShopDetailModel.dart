class ShopDetailModel {
  ShopDetailModel({
    this.id,
    this.merchantName,
    this.merchantDescription,
    this.phoneNumber,
    this.longitudeLatitude,
    this.businessHoursBegin,
    this.businessHoursEnd,
    this.fixedHoliday,
    this.prefecturesCodeName,
    this.municipalities,
    this.streetAddress,
    this.building,
    this.snsType1,
    this.snsType2,
    this.snsType3,
    this.snsType4,
    this.snsLink1,
    this.snsLink2,
    this.snsLink3,
    this.snsLink4,
    this.storeHomepageLink,
    this.customerOrderLimit,
    this.headFilePath,
    this.banFilePathList,
  });

  ShopDetailModel.fromJson(dynamic json) {
    id = json['id'];
    merchantName = json['merchantName'];
    merchantDescription = json['merchantDescription'] ?? "";
    phoneNumber = json['phoneNumber'] ?? "";
    longitudeLatitude = json['longitudeLatitude'] ?? "118.12,32.23";
    businessHoursBegin = json['businessHoursBegin'] ?? "";
    businessHoursEnd = json['businessHoursEnd'] ?? "";

    fixedHoliday = json['fixedHoliday'] != null ? json['fixedHoliday'].cast<String>() : [];
    eatingArea = json['eatingArea'];
    municipalities = json['municipalities'] ?? "";
    streetAddress = json['streetAddress'] ?? "";
    building = json['building'] ?? "";
    snsType1 = json['snsType1'] ?? "";
    snsType2 = json['snsType2'] ?? "";
    snsType3 = json['snsType3'] ?? "";
    snsType4 = json['snsType4'] ?? "";
    snsLink1 = json['snsLink1'] ?? "";
    snsLink2 = json['snsLink2'] ?? "";
    snsLink3 = json['snsLink3'] ?? "";
    snsLink4 = json['snsLink4'] ?? "";
    storeHomepageLink = json['storeHomepageLink'];
    tradeLawInfoLink = json['tradeLawInfoLink'];
    customerOrderLimit = json['customerOrderLimit'];
    banFilePathList = json['banFilePathList'] != null ? json['banFilePathList'].cast<String>() : [];
    prefecturesCodeName = json['prefecturesCodeName'] ?? "";
  }

  double? get getLatitude => double.parse(longitudeLatitude!.split(",")[1]);

  double? get getLongitude => double.parse(longitudeLatitude!.split(",")[0]);

  String? id;
  String? merchantName;
  String? merchantDescription;
  String? phoneNumber;
  String? longitudeLatitude = "118°12,32°23";
  String? prefecturesCodeName;
  String? businessHoursBegin;
  String? businessHoursEnd;
  List<String>? fixedHoliday;
  String? eatingArea;
  String? municipalities;
  String? streetAddress;
  String? building;
  String? snsType1;
  String? snsType2;
  String? snsType3;
  String? snsType4;
  String? snsLink1;
  String? snsLink2;
  String? snsLink3;
  String? snsLink4;
  String? storeHomepageLink;
  String? tradeLawInfoLink;
  dynamic customerOrderLimit;
  dynamic headFilePath;
  List<String>? banFilePathList = [];



  String get getAddress => prefecturesCodeName! + municipalities! + streetAddress!;

  String get getEatingArea => eatingArea == "0" ? "イートインスペースなし" : "イートインスペースあり";

  String beginTime() {
    if (businessHoursBegin!.isEmpty) {
      return "未設定";
    }
    return businessHoursBegin!.substring(0, 5);
  }

  String endTime() {
    if (businessHoursEnd!.isEmpty) {
      return "未設定";
    }
    return businessHoursEnd!.substring(0, 5);
  }

  String? getHoliday() {
    String holiday = "";
    fixedHoliday!.forEach((e) {
      switch (e) {
        case "1":
          holiday += "月曜日 ";
          break;
        case "2":
          holiday += "火曜日 ";
          break;
        case "3":
          holiday += "水曜日 ";
          break;
        case "4":
          holiday += "木曜日 ";
          break;
        case "5":
          holiday += "金曜日 ";
          break;
        case "6":
          holiday += "土曜日 ";
          break;
        case "7":
          holiday += "日曜日 ";
          break;
        default:
          holiday += "";
          break;
      }
    });
    return holiday;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['merchantName'] = merchantName;
    map['merchantDescription'] = merchantDescription;
    map['phoneNumber'] = phoneNumber;
    map['longitudeLatitude'] = longitudeLatitude;
    map['businessHoursBegin'] = businessHoursBegin;
    map['businessHoursEnd'] = businessHoursEnd;

    map['fixedHoliday'] = fixedHoliday;
    map['eatingArea'] = eatingArea;
    map['municipalities'] = municipalities;
    map['streetAddress'] = streetAddress;
    map['building'] = building;
    map['snsType1'] = snsType1;
    map['snsType2'] = snsType2;
    map['snsType3'] = snsType3;
    map['snsType4'] = snsType4;
    map['snsLink1'] = snsLink1;
    map['snsLink2'] = snsLink2;
    map['snsLink3'] = snsLink3;
    map['snsLink4'] = snsLink4;
    map['storeHomepageLink'] = storeHomepageLink;
    map['tradeLawInfoLink'] = tradeLawInfoLink;
    map['customerOrderLimit'] = customerOrderLimit;
    map['banFilePathList'] = banFilePathList;
    map['prefecturesCodeName'] = prefecturesCodeName;
    return map;
  }
}

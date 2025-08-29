
class CustomerMerchantsModelRecords {
/*
{
  "id": 0,
  "merchantName": "",
  "latitude": 0,
  "longitude": 0,
  "distance": 0,
  "filePath": "",
  "customerOrderLimit": 0,
  "merchantDescription": ""
} 
*/

  String? id;
  String? merchantName;
  String? latitude;
  String? longitude;
  String? distance;
  String? filePath;
  String? customerOrderLimit;
  String? merchantDescription;

  CustomerMerchantsModelRecords({
    this.id,
    this.merchantName,
    this.latitude,
    this.longitude,
    this.distance,
    this.filePath,
    this.customerOrderLimit,
    this.merchantDescription,
  });
  CustomerMerchantsModelRecords.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString() ?? '';
    merchantName = json['merchantName']?.toString();
    latitude = json['latitude']?.toString() ?? '';
    longitude = json['longitude']?.toString() ?? '';
    distance = json['distance']?.toString() ?? '';
    filePath = json['filePath']?.toString();
    customerOrderLimit = json['customerOrderLimit']?.toString() ?? '';
    merchantDescription = json['merchantDescription']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['merchantName'] = merchantName;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['distance'] = distance;
    data['filePath'] = filePath;
    data['customerOrderLimit'] = customerOrderLimit;
    data['merchantDescription'] = merchantDescription;
    return data;
  }
}

class CustomerMerchantsModel {
/*
{
  "current": 0,
  "size": 0,
  "total": 0,
  "records": [
    {
      "id": 0,
      "merchantName": "",
      "latitude": 0,
      "longitude": 0,
      "distance": 0,
      "filePath": "",
      "customerOrderLimit": 0,
      "merchantDescription": ""
    }
  ],
  "pages": 0
} 
*/

  int? current;
  int? size;
  int? total;
  List<CustomerMerchantsModelRecords?>? records;
  int? pages;

  CustomerMerchantsModel({
    this.current,
    this.size,
    this.total,
    this.records,
    this.pages,
  });
  CustomerMerchantsModel.fromJson(Map<String, dynamic> json) {
    current = int.tryParse(json['current']?.toString() ?? '');
    size = int.tryParse(json['size']?.toString() ?? '');
    total = int.tryParse(json['total']?.toString() ?? '');
  if (json['records'] != null && (json['records'] is List)) {
  final v = json['records'];
  final arr0 = <CustomerMerchantsModelRecords>[];
  v.forEach((v) {
  arr0.add(CustomerMerchantsModelRecords.fromJson(v));
  });
    records = arr0;
    }
    pages = int.tryParse(json['pages']?.toString() ?? '');
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['current'] = current;
    data['size'] = size;
    data['total'] = total;
    if (records != null) {
      final v = records;
      final arr0 = [];
  v!.forEach((v) {
  arr0.add(v!.toJson());
  });
      data['records'] = arr0;
    }
    data['pages'] = pages;
    return data;
  }
}

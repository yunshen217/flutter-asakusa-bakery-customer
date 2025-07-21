class BaseModel {
  int? code;
  dynamic pc;
  dynamic data;
  String? message;
  String? uuid;
  String? img;
  dynamic status;

  BaseModel({this.code, this.pc, this.data, this.message, this.status});

  BaseModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    img = json['img'];
    pc = json['pc'];
    data = json['data'] ?? {};
    message = json['msg'];
    uuid = json['uuid'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['pc'] = pc;
    data['data'] = this.data;
    data['msg'] = message;
    data['img'] = img;
    data['uuid'] = uuid;
    data['status'] = status;
    return data;
  }
}

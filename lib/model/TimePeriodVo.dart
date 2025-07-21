
class TimePeriodVo {
  TimePeriodVo({
     this.id, 
     this.label
    });

  TimePeriodVo.fromJson(dynamic json) {
    id = json['id'];
    label = json['label'];
  }
  String? id;
  String? label;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['label'] = label;
    return map;
  }
}

class ItemKindVo {
  ItemKindVo({
     this.id, 
     this.kindName
    });

  ItemKindVo.fromJson(dynamic json) {
    id = json['id'];
    kindName = json['kindName'];
  }
  String? id;
  String? kindName;
  bool select = false;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['kindName'] = kindName;
    return map;
  }
}
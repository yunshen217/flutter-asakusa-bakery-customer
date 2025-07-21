
class ItemDetailVo {
  ItemDetailVo({
     this.itemName, 
     this.price,
     this.description,
     this.ingredients,
     this.allergenList,
     this.filePathList
    });

  ItemDetailVo.fromJson(dynamic json) {
    itemName = json['itemName'];
    price = json['price'];
    description = json['description'];
    ingredients = json['ingredients'];
    allergenList = json['allergenList'];
    filePathList = json['filePathList'];
  }
  String? itemName;
  num? price;
  String? description;
  String? ingredients;
  dynamic filePathList;
  dynamic allergenList;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['itemName'] = itemName;
    map['price'] = price;
    map['description'] = description;
    map['ingredients'] = ingredients;
    map['allergenList'] = allergenList;
    map['filePathList'] = filePathList;
    return map;
  }
}

import 'base_model.dart';


class BaseJsonRes  {
  BaseModel? info;
  String error;

  BaseJsonRes.fromJson(Map<String, dynamic> json)
      : info = BaseModel.fromJson(json),
        error = "";

  BaseJsonRes.withError(String errorValue) : error = errorValue;
}


import 'package:flutter/material.dart';

import '../model/UserModel.dart';
import 'constant.dart';
import 'package:sp_util/sp_util.dart';

///全局变量
class Global {
  Global._();

  //全局TOKEN
  static String get token => SpUtil.getString(Constant.TOKEN, defValue: "")!;

  static putToken(token) => SpUtil.putString(Constant.TOKEN, token)!;

  //全局实体   start
  static UserModel? get userInfo => SpUtil.getObj(Constant.USER_MODEL, (v) => UserModel.fromJson(v),
      defValue: UserModel(userName: "ログイン", userId: ""));

  static Future<void> putUserInfo(dynamic user) async {
  try {
    print("开始保存用户信息...");
    bool success = await SpUtil.putObject(Constant.USER_MODEL, user) ?? false;
    if (success) {
      print("用户信息保存成功: ${user}");
    } else {
      print("用户信息保存失败");
    }
  } catch (e) {
    print("保存用户信息失败: $e");
  }
}

  //语言 END
  //全局context
  static BuildContext? context;

  //全局初始化 缓存
  static Future init() async {
    await SpUtil.getInstance();
  }

  //清除保存记录
  static Future clear() async {
    await SpUtil.remove(Constant.TOKEN);
    await SpUtil.remove(Constant.USER_MODEL);
    if (SpUtil.haveKey(Constant.TOKEN)!) await SpUtil.remove(Constant.TOKEN);
  }
}

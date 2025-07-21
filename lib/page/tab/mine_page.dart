import 'package:flutter/material.dart';
import 'package:shopping_client/common/constant.dart';
import 'package:shopping_client/common/custom_widget.dart';
import 'package:shopping_client/repository/repository.dart';

import '../../common/Global.dart';
import '../../common/InitEventBus.dart';
import '../../common/custom_color.dart';
import '../../routes/Routes.dart';

///我的界面
class MinePage extends StatefulWidget {
  const MinePage({Key? key}) : super(key: key);

  @override
  _MinePageState createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  String name = "ログイン";

  @override
  void initState() {
    getUserInfo();
    EventBusUtil.listen((e) {
      if (e == Constant.FLAG) {
        getUserInfo();
      }
    });
    super.initState();
  }

  getUserInfo() {
    backEndRepository.doGet(Constant.customerInfoDetail, successRequest: (res) {
      res['data']['nickName']==null ? name = "氏名未設定" : name = res['data']['nickName'];
      setState(() {});
    });
  }

  void goPageWithCheck(BuildContext context, String routeName) {
  if (_isLogin()) {
    Routes.goPage(context, routeName);
  } else {
    customWidget.showCustomSingleBtnDialog(context,
          confirm: () => Routes.goPage(context, "/LoginPage"));
  }
}

bool _isLogin() {
  return Global.userInfo!.accessToken != null;
}


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                  height: 150.0,
                  width: double.infinity,
                  alignment: Alignment.centerRight,
                  child: customWidget.setAssetsImg("icon_setting_top_right.png",
                      width: 120, height: 70, margin: const EdgeInsets.only(top: 80, right: 40)),
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [CustomColor.white, CustomColor.pinkFe]))),
              customWidget.setText(name,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  margin: const EdgeInsets.only(top: 90, left: 20)),
            ],
          ),
          Container(
              margin: const EdgeInsets.all(15),
              decoration:
                  BoxDecoration(color: CustomColor.white, borderRadius: BorderRadius.circular(10)),
              child: Column(children: [
                ListTile(
                    trailing: const Icon(Icons.chevron_right),
                    contentPadding: const EdgeInsets.only(right: 15, left: 15),
                    title: customWidget.setText("アカウント設定", fontWeight: FontWeight.bold),
                    leading: const Icon(Icons.settings, color: CustomColor.black_3),
                    onTap: () => goPageWithCheck(context, "/SettingPage")),
                Container(
                    height: 1,
                    color: CustomColor.grayE,
                    margin: const EdgeInsets.only(left: 15, right: 15)),
                ListTile(
                    trailing: const Icon(Icons.chevron_right),
                    contentPadding: const EdgeInsets.only(right: 15, left: 15),
                    title: customWidget.setText("配送先", fontWeight: FontWeight.bold),
                    leading: customWidget.setAssetsImg("icon_mine_three.png"),
                    onTap: () => goPageWithCheck(context, "/ChooseAddressPage")),
                Container(
                    height: 1,
                    color: CustomColor.grayE,
                    margin: const EdgeInsets.only(left: 15, right: 15)),
                ListTile(
                    trailing: const Icon(Icons.chevron_right),
                    contentPadding: const EdgeInsets.only(right: 15, left: 15),
                    title: customWidget.setText("クレジットカード`", fontWeight: FontWeight.bold),
                    leading: customWidget.setAssetsImg("icon_credit_card.png"),
                    onTap: () => goPageWithCheck(context, "/CreditCardListPage")),
                Container(
                    height: 1,
                    color: CustomColor.grayE,
                    margin: const EdgeInsets.only(left: 15, right: 15)),
                ListTile(
                    trailing: const Icon(Icons.chevron_right),
                    contentPadding: const EdgeInsets.only(right: 15, left: 15),
                    title: customWidget.setText("ポイント", fontWeight: FontWeight.bold),
                    leading: customWidget.setAssetsImg("icon_point.png"),
                    onTap: () => goPageWithCheck(context, "/PointPage")),
                Container(
                    height: 1,
                    color: CustomColor.grayE,
                    margin: const EdgeInsets.only(left: 15, right: 15)),
                ListTile(
                    trailing: const Icon(Icons.chevron_right),
                    title: customWidget.setText("退会", fontWeight: FontWeight.bold),
                    contentPadding: const EdgeInsets.only(right: 15, left: 15),
                    leading: customWidget.setAssetsImg("icon_mine_two.png"),
                    onTap: (){
                      if (_isLogin()) {
                      customWidget.showCustomDialog(
                          context,
                          title: "退会確認",
                          content:
                              "これまで当アプリをご利用いただき、誠にありがとうございました。\n退会すると、以下の情報がすべて削除されます：\n・アカウントに関連するすべてのデータ©\n・購入履歴やポイント\n・保存したお気に入りアイテム\n・その他のすべてのアカウント関連情報退会後は、\n\n同じメールアドレスで新規登録する必要があります本当に退会しますか？",
                          confirmTitle: "退会する",
                          confirm: () {
                            backEndRepository.doDel(Constant.deleteCustomerAccount,
                                successRequest: (res) {
                              customWidget.toastShow(res['msg']);
                              Global.clear();
                              Routes.goPage(context, "/LoginPage");
                            });
                          },
                        );
                    } else {}
                    } 
                    ),
                Container(
                    height: 1,
                    color: CustomColor.grayE,
                    margin: const EdgeInsets.only(left: 15, right: 15)),
                ListTile(
                    trailing: const Icon(Icons.chevron_right),
                    title: customWidget.setText("パスワードの変更", fontWeight: FontWeight.bold),
                    contentPadding: const EdgeInsets.only(right: 15, left: 15),
                    leading: const Icon(Icons.verified_user_rounded, color: CustomColor.black_3),
                    onTap: () => goPageWithCheck(context, "/ChangePwPage")),
                Container(
                    height: 1,
                    color: CustomColor.grayE,
                    margin: const EdgeInsets.only(left: 15, right: 15)),
                ListTile(
                    trailing: const Icon(Icons.chevron_right),
                    title: customWidget.setText("ログアウト", fontWeight: FontWeight.bold),
                    contentPadding: const EdgeInsets.only(right: 15, left: 15),
                    leading: customWidget.setAssetsImg("icon_mine_one.png"),
                    onTap: () => customWidget.showCustomDialog(context,
                            isChild: true, title: "ログアウトします", confirm: () {
                          Global.clear();
                          Routes.goPage(context, "/LoginPage");
                        })),
                // ListTile(
                //     trailing: const Icon(Icons.chevron_right),
                //     title: customWidget.setText("离心机", fontWeight: FontWeight.bold),
                //     contentPadding: const EdgeInsets.only(right: 15, left: 15),
                //     leading: customWidget.setAssetsImg("icon_mine_one.png"),
                //     onTap: () => Routes.goPage(context, "/B"))
              ]))
        ],
      ),
    );
  }
// @override
// void dispose() {
//   EventBusUtil.getInstance().destroy();
//   super.dispose();
// }
}

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:shopping_client/repository/repository.dart';

import '../../common/constant.dart';
import '../../common/custom_color.dart';
import '../../common/custom_widget.dart';
import '../../common/utils.dart';
import '../../routes/Routes.dart';
import '../../view/BaseScaffold.dart';

class ForgetPage extends StatefulWidget {
  final Map map;

  const ForgetPage(this.map, {super.key});

  @override
  State<ForgetPage> createState() => _ForgetPageState();
}

class _ForgetPageState extends State<ForgetPage> {
  TextEditingController? accountController = TextEditingController();

  @override
  void initState() {
    accountController?.text = widget.map[Constant.FLAG];
    super.initState();
  }

  @override
  void dispose() {
    accountController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: customWidget.setAppBar(
          title: "パスフ-ドを忘れた場合",
          bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(height: 1, width: double.infinity, color: CustomColor.grayF5))),
      backgroundColor: CustomColor.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customWidget.setText("ご登録済のメールアドレスを入力してください。新しいパスワードはご登録のメールアドレスに送信されます。",
              margin: const EdgeInsets.all(15)),
          customWidget.setTextFieldForLogin(accountController,
              icon: "icon_msg.png",
              autofocus: true,
              hintText: "ユーザーIDを入力してください",
              keyboardType: TextInputType.emailAddress,
              margin: const EdgeInsets.only(left: 15, right: 15, bottom: 10)),
          customWidget.setCupertinoButton("送信",
              minimumSize: utils.getScreenSize.width,
              margin: const EdgeInsets.only(left: 15, right: 15, top: 30), onPressed: () {
            if (isAccountPass()) {
              backEndRepository.doPost(Constant.resetAccountPassword,
                  params: {"email": accountController?.text}, successRequest: (e) {
                customWidget.toastShow("操作が成功しました");
                Routes.finishPage(context: context);
              });
            }
          })
        ],
      ),
    );
  }

  isAccountPass() {
    if (!utils.isEmail(accountController!.text.toString().trim())) {
      customWidget.toastShow("メールアドレスが不正です", notifyType: NotifyType.warning);
      return false;
    }
    return true;
  }
}

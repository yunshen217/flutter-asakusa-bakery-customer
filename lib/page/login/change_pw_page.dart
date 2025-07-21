import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:shopping_client/common/constant.dart';
import 'package:shopping_client/common/custom_color.dart';
import 'package:shopping_client/common/custom_widget.dart';
import 'package:shopping_client/repository/repository.dart';
import 'package:shopping_client/view/BaseScaffold.dart';

import '../../common/utils.dart';
import '../../routes/Routes.dart';

class ChangePwPage extends StatefulWidget {
  const ChangePwPage({super.key});

  @override
  State<ChangePwPage> createState() => _ChangePwPageState();
}

class _ChangePwPageState extends State<ChangePwPage> {
  TextEditingController? pwController = TextEditingController();
  TextEditingController? newPwController = TextEditingController();
  TextEditingController? againPwController = TextEditingController();
  RxBool pwObscureText = false.obs;
  RxBool newPwObscureText = false.obs;
  RxBool againPwObscureText = false.obs;

  @override
  void dispose() {
    pwController?.dispose();
    newPwController?.dispose();
    againPwController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        appBar: customWidget.setAppBar(
            title: "パスワードの変更",
            bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1),
                child: Container(height: 1, width: double.infinity, color: CustomColor.grayF5))),
        backgroundColor: CustomColor.white,
        body: SingleChildScrollView(
            child: Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customWidget.setText("現在のパスワード",
                        fontWeight: FontWeight.w400,
                        margin: const EdgeInsets.only(bottom: 10, top: 10, left: 15, right: 15)),
                    customWidget.setTextField(pwController,
                        hintText: "現在のパスワード",
                        obscureText: !pwObscureText.value,
                        keyboardType: TextInputType.visiblePassword,
                        isShow: true,
                        suffixIcon: IconButton(
                            icon: Icon(pwObscureText.value
                                ? CupertinoIcons.eye
                                : CupertinoIcons.eye_slash),
                            onPressed: () => pwObscureText.value = !pwObscureText.value),
                        margin: const EdgeInsets.only(left: 15, right: 15)),
                    customWidget.setText("新しいパスワード",
                        fontWeight: FontWeight.w400,
                        margin: const EdgeInsets.only(bottom: 10, top: 10, left: 15, right: 15)),
                    customWidget.setTextField(newPwController,
                        hintText: "新しいパスワード",
                        obscureText: !newPwObscureText.value,
                        keyboardType: TextInputType.visiblePassword,
                        isShow: true,
                        suffixIcon: IconButton(
                            icon: Icon(newPwObscureText.value
                                ? CupertinoIcons.eye
                                : CupertinoIcons.eye_slash),
                            onPressed: () => newPwObscureText.value = !newPwObscureText.value),
                        margin: const EdgeInsets.only(left: 15, right: 15)),
                    customWidget.setText("確認パスワード",
                        fontWeight: FontWeight.w400,
                        margin: const EdgeInsets.only(bottom: 10, top: 10, left: 15, right: 15)),
                    customWidget.setTextField(againPwController,
                        hintText: "新しいパスワード",
                        keyboardType: TextInputType.visiblePassword,
                        isShow: true,
                        obscureText: !againPwObscureText.value,
                        suffixIcon: IconButton(
                            icon: Icon(againPwObscureText.value
                                ? CupertinoIcons.eye
                                : CupertinoIcons.eye_slash),
                            onPressed: () => againPwObscureText.value = !againPwObscureText.value),
                        margin: const EdgeInsets.only(left: 15, right: 15, bottom: 10)),
                    customWidget.setText("パスワード規則：8-16桁半角英数字の組合せ保存",
                        color: CustomColor.grayC5,
                        fontSize: 12,
                        margin: const EdgeInsets.only(left: 15, bottom: 30)),
                    customWidget.setCupertinoButton("確定",
                        minimumSize: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 15), onPressed: () {
                      if (!utils.isPw(pwController!.text.trim()) ||
                          !utils.isPw(newPwController!.text.trim()) ||
                          !utils.isPw(againPwController!.text.trim())) {
                        customWidget.toastShow("パスワードフォーマットエラー", notifyType: NotifyType.warning);
                        return;
                      }
                      if (newPwController!.text != againPwController!.text) {
                        customWidget.toastShow("確認用パスワード不一致", notifyType: NotifyType.warning);
                        return;
                      }
                      backEndRepository.doPut(Constant.resetPassword, params: {
                        "password": newPwController!.text.trim(),
                        "repeatPassword": againPwController!.text.trim(),
                        "oldPassword": pwController!.text.trim()
                      }, successRequest: (res) {
                        Routes.finishPage(context: context);
                        customWidget.toastShow("パスワード変更しました");
                      });
                    })
                  ],
                ))));
  }
}

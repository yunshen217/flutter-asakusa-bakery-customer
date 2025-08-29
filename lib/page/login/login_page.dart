import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:shopping_client/common/Global.dart';
import 'package:shopping_client/common/InitEventBus.dart';
import 'package:shopping_client/common/constant.dart';
import 'package:shopping_client/common/custom_color.dart';
import 'package:shopping_client/common/custom_widget.dart';
import 'package:shopping_client/main.dart';
import 'package:shopping_client/repository/repository.dart';
import 'package:shopping_client/view/BaseScaffold.dart';
import 'dart:async';
import '../../common/utils.dart';
import '../../routes/Routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  List<Tab> tabs = [const Tab(text: "ログインする"), const Tab(text: "登録する")];

  ///
  ///
  ///568581117@qq.com
  /// 9Qv4DIhp
  /// text: "97272442@qq.com"
  /// text: "ezkEFG85"
  TextEditingController? accountController = TextEditingController();
  TextEditingController? pwController = TextEditingController();
  TextEditingController? verifyController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Timer? _timer;
  int _secondsRemaining = 60;
  TabController? _tabController;
  RxBool obscureText = true.obs;

  @override
  void initState() {
    _tabController = TabController(length: tabs.length, vsync: this);
    accountController!.text = "1534501335@qq.com";
    pwController!.text = "AX98Yn5tHBgyBcW";
    super.initState();
  }

  @override
  void dispose() {
    accountController?.dispose();
    pwController?.dispose();
    verifyController?.dispose();
    _tabController?.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        backgroundColor: CustomColor.white,
        // onBack: () => exit(0),
        body: Stack(
          children: [
            customWidget.setAssetsImg("icon_login_bg.png",
                width: utils.getScreenSize.width, height: 400),
            Container(
                height: 80,
                margin: const EdgeInsets.only(top: 350),
                decoration: const BoxDecoration(
                    color: CustomColor.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(35), topLeft: Radius.circular(35)))),
            SingleChildScrollView(
                child: AutofillGroup(
                    child: Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.disabled,
                        child: Column(children: [
                          customWidget.setCard(
                              height: _tabController?.index == 0 ? 340 : 355,
                              margin: const EdgeInsets.only(top: 220, left: 30, right: 30),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                                TabBar(
                                    controller: _tabController,
                                    overlayColor: WidgetStateProperty.resolveWith(
                                        (states) => Colors.transparent),
                                    indicatorSize: TabBarIndicatorSize.tab,
                                    labelColor: CustomColor.redE8,
                                    labelStyle: customWidget.setTextStyle(fontSize: 15),
                                    dividerHeight: 2.0,
                                    indicatorColor: CustomColor.redE8,
                                    unselectedLabelStyle: customWidget.setTextStyle(
                                        fontSize: 15, fontWeight: FontWeight.normal),
                                    unselectedLabelColor: CustomColor.black_3,
                                    tabs: tabs,
                                    onTap: (e) => setState(() => _tabController?.animateTo(e))),
                                customWidget.setTextFieldForLogin(accountController,
                                    icon: "icon_msg.png",
                                    autofocus: true,
                                    autofillHints: [AutofillHints.email],
                                    hintText: _tabController?.index == 0
                                        ? "ユーザーIDを入力してください"
                                        : "メールアドレスを入力してください",
                                    keyboardType: TextInputType.emailAddress,
                                    margin: const EdgeInsets.only(top: 30, bottom: 10)),
                                Obx(() => customWidget.setTextFieldForLogin(pwController,
                                    maxLength: 16,
                                    autofillHints: [AutofillHints.password],
                                    hintText: _tabController?.index == 0
                                        ? "パスワードを入力してください（8-16桁半角英数字の組合せ）"
                                        : "パスワード（8-16桁半角英数字の組合せ）",
                                    icon: "icon_pw.png",
                                    suffix: IconButton(
                                        onPressed: () => obscureText.value = !obscureText.value,
                                        icon: !obscureText.value
                                            ? const Icon(CupertinoIcons.eye)
                                            : const Icon(CupertinoIcons.eye_slash,
                                                color: CustomColor.grayC5)),
                                    obscureText: obscureText.value)),
                                Visibility(
                                    visible: _tabController?.index == 1,
                                    child: customWidget.setTextFieldForLogin(verifyController,
                                        maxLength: 6,
                                        icon: "icon_verify.png",
                                        keyboardType: TextInputType.number,
                                        hintText: "認証コードの入力",
                                        suffix: customWidget.setCupertinoButton(text(),
                                            minimumSize: 70,
                                            fontSize: 12.0,
                                            margin: const EdgeInsets.only(
                                                right: 5, top: 10, bottom: 10),
                                            onPressed: _secondsRemaining == 60
                                                ? () => _cutDownTime()
                                                : null),
                                        margin: const EdgeInsets.only(top: 10))),
                                Visibility(
                                    visible: _tabController?.index == 0,
                                    child: InkWell(
                                        child: customWidget.setText("パスワードを忘れた場合",
                                            margin: const EdgeInsets.only(top: 10, bottom: 15)),
                                        onTap: () => Routes.goPage(context, "/ForgetPage", param: {
                                              Constant.FLAG: accountController?.text.trim()
                                            }))),
                                    customWidget.setCupertinoButton(
                                        _tabController?.index == 0
                                            ? "ログイン"
                                            : "完了",
                                        minimumSize:
                                            utils.getScreenSize.width - 100,
                                        margin: const EdgeInsets.only(top: 10),
                                        onPressed: () async {
                                      ///登陆
                                      if (_tabController?.index == 0) {
                                        if (isLogin()) {
                                          if (Global.token.isEmpty) {
                                            try {
                                              // 添加async/await等待设备令牌获取完成
                                              await getDeviceToken();

                                              // 添加上下文有效性检查
                                              if (!context.mounted) return;
                                            } catch (e) {
                                              print("获取设备令牌失败: $e");
                                              if (context.mounted) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                      content:
                                                          Text('デバイストークン獲得失敗')),
                                                );
                                              }
                                              return;
                                            }
                                          }
                                      backEndRepository.doPost(Constant.login, params: {
                                        "email": accountController!.text,
                                        "password": pwController!.text,
                                        "deviceToken": Global.token
                                      }, successRequest: (res) {
                                         print("登录成功返回的数据: $res");
                                        _formKey.currentState?.save();
                                        TextInput.finishAutofillContext();
                                        Global.putUserInfo(res['data']);
                                        Routes.finishPage(context: context);
                                        EventBusUtil.fire(Constant.FLAG);
                                        EventBusUtil.fire(Constant.REFRESH_O);
                                      });
                                    }
                                  } else {
                                    ///注册
                                    if (isRegister()) {
                                      backEndRepository.doPost(Constant.register, params: {
                                        "email": accountController!.text,
                                        "password": pwController!.text,
                                        "code": verifyController!.text
                                      }, successRequest: (res) {
                                        if (_tabController?.index == 1) {
                                          _tabController?.animateTo(0,
                                              duration: const Duration(milliseconds: 300));
                                          setState(() {});
                                        }
                                      });
                                    }
                                  }
                                }),
                              ])),
                          InkWell(
                              child: customWidget.setText("スキップ",
                                  fontSize: 15,
                                  padding: const EdgeInsets.only(top: 100, bottom: 15)),
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () {
                                Routes.finishPage(context: context);
                              })
                        ]))))
          ],
        ));
  }

  text() {
    if (_secondsRemaining == 60) {
      return "送信";
    } else {
      return "${_secondsRemaining}s";
    }
  }

  _cutDownTime() {
    if (isAccountPass()) {
      backEndRepository.doPost(Constant.sendEmailCode, params: {"email": accountController?.text},
          successRequest: (res) {
        if (_secondsRemaining == 60) {
          _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
            if (_secondsRemaining < 1) {
              timer.cancel();
              _secondsRemaining = 60;
            } else {
              _secondsRemaining = _secondsRemaining - 1;
            }
            setState(() {});
          });
        }
      });
    }
  }

  isAccountPass() {
    if (!utils.isEmail(accountController!.text.toString().trim())) {
      customWidget.toastShow("メールアドレスが不正です", notifyType: NotifyType.warning);
      return false;
    }
    return true;
  }

  isRegister() {
    if (accountController!.text.trim().isEmpty) {
      customWidget.toastShow("ユーザーIDを入力してください", notifyType: NotifyType.warning);
      return false;
    } else if (!utils.isPw(pwController!.text.trim())) {
      customWidget.toastShow("パスワードフォーマットエラー", notifyType: NotifyType.warning);
      return false;
    }
    else if (!utils.isEmail(accountController!.text.toString().trim())) {
      customWidget.toastShow("メールアドレスが不正です", notifyType: NotifyType.warning);
      return false;
    }
    // else if (verifyController?.text.length != 4 || verifyController?.text.length != 6) {
    //   customWidget.toastShow("認証コードを入力してください", notifyType: NotifyType.warning);
    //   return false;
    // }
    return true;
  }

  isLogin() {
    if (accountController!.text.trim().isEmpty) {
      customWidget.toastShow("ユーザーIDを入力してください", notifyType: NotifyType.warning);
      return false;
    } else if (!utils.isPw(pwController!.text.trim())) {
      customWidget.toastShow("パスワードフォーマットエラー", notifyType: NotifyType.warning);
      return false;
    } else if (!utils.isEmail(accountController!.text.toString().trim())) {
      customWidget.toastShow("メールアドレスが不正です", notifyType: NotifyType.warning);
      return false;
    }
    return true;
  }
}

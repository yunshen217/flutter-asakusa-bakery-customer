import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:shopping_client/common/constant.dart';
import 'package:shopping_client/common/custom_color.dart';
import 'package:shopping_client/common/custom_widget.dart';
import 'package:shopping_client/repository/repository.dart';
import 'package:shopping_client/view/BaseScaffold.dart';

import '../../common/InitEventBus.dart';
import '../../routes/Routes.dart';
import '../../view/CustomFloatingActionButtonLocation.dart';

class CreditCardPage extends StatefulWidget {
  final Map map;

  const CreditCardPage(this.map, {super.key});

  @override
  State<CreditCardPage> createState() => _CreditCardPageState();
}

class _CreditCardPageState extends State<CreditCardPage> {
  final TextEditingController cardController = TextEditingController();
  final TextEditingController expYearController = TextEditingController();
  final TextEditingController expMonthController = TextEditingController();
  final TextEditingController cscController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  String tokenApiKey = "";

  RxBool isSwitch = false.obs;

  @override
  void initState() {
    // if (widget.map.isNotEmpty) {
    //   nameController.text = widget.map[Constant.FLAG].nickName;
    //   phoneController.text = widget.map[Constant.FLAG].telephoneNo;
    //   postController.text = widget.map[Constant.FLAG].postcode;
    //   cityController.text = widget.map[Constant.FLAG].municipalities;
    //   countryController.text = widget.map[Constant.FLAG].streetAddress;
    //   houseController.text = widget.map[Constant.FLAG].building;
    //   proviceController.text = widget.map[Constant.FLAG].prefecturesCodeName;
    //   isSwitch.value = widget.map[Constant.FLAG].defaultFlag == "1";
    // }
    backEndRepository.doGet(Constant.creditCardApiKey, successRequest: (res) {
      tokenApiKey = res["msg"];
    });
    super.initState();
  }

  @override
  void dispose() {
    cardController.dispose();
    expYearController.dispose();
    expMonthController.dispose();
    cscController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        resizeToAvoidBottomInset: true,
        appBar: customWidget.setAppBar(
            title: 'クレジットカード情報を登録',
            bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1),
                child: Container(height: 1, width: double.infinity, color: CustomColor.grayF5))),
        backgroundColor: CustomColor.white,
        body: SingleChildScrollView(
          reverse: true, // 键盘弹出时自动把底部露出来
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    customWidget.setText("カード番号",
                        fontWeight: FontWeight.w400, margin: const EdgeInsets.only(bottom: 10)),
                    Container(
                        margin: const EdgeInsets.only(bottom: 10, left: 10),
                        decoration: BoxDecoration(
                            color: CustomColor.redE8, borderRadius: BorderRadius.circular(5.0)),
                        child: customWidget.setText("必須",
                            fontSize: 10,
                            color: CustomColor.white,
                            padding: const EdgeInsets.only(left: 5, right: 5)))
                  ],
                ),
                customWidget.setTextField(cardController, hintText: "カード番号", keyboardType: TextInputType.number),
                Row(
                  children: [
                    customWidget.setText("有効期限",
                        fontWeight: FontWeight.w400,
                        margin: const EdgeInsets.only(bottom: 10, top: 10)),
                    Container(
                        margin: const EdgeInsets.only(bottom: 10, left: 10, top: 10),
                        decoration: BoxDecoration(
                            color: CustomColor.redE8, borderRadius: BorderRadius.circular(5.0)),
                        child: customWidget.setText("必須",
                            fontSize: 10,
                            color: CustomColor.white,
                            padding: const EdgeInsets.only(left: 5, right: 5)))
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: customWidget.setTextField(expMonthController,
                          hintText: "月", keyboardType: TextInputType.number, maxLength:2),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('/'),
                    ),
                    Expanded(
                      flex: 1,
                      child: customWidget.setTextField(expYearController,
                          hintText: "年", keyboardType: TextInputType.number, maxLength:2),
                    ),
                  ],
                ),
                Row(
                  children: [
                    customWidget.setText("セキュリティコード",
                        fontWeight: FontWeight.w400,
                        margin: const EdgeInsets.only(bottom: 10, top: 10)),
                    Container(
                        margin: const EdgeInsets.only(bottom: 10, left: 10, top: 10),
                        decoration: BoxDecoration(
                            color: CustomColor.redE8, borderRadius: BorderRadius.circular(5.0)),
                        child: customWidget.setText("必須",
                            fontSize: 10,
                            color: CustomColor.white,
                            padding: const EdgeInsets.only(left: 5, right: 5)))
                  ],
                ),
                customWidget.setTextField(cscController, hintText: "セキュリティコード", keyboardType: TextInputType.number),
                Row(
                  children: [
                    customWidget.setText("名義人",
                        fontWeight: FontWeight.w400,
                        margin: const EdgeInsets.only(bottom: 10, top: 10)),
                    Container(
                        margin:
                            const EdgeInsets.only(bottom: 5, left: 10, top: 10),
                        decoration: BoxDecoration(
                            color: CustomColor.redE8,
                            borderRadius: BorderRadius.circular(5.0)),
                        child: customWidget.setText("必須",
                            fontSize: 10,
                            color: CustomColor.white,
                            padding: const EdgeInsets.only(left: 5, right: 5)))
                  ],
                ),
                customWidget.setTextField(
                  nameController,
                  hintText: "名義人",
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Z\s]')), // 仅允许半角英文字母
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // 保持左对齐
                    children: [
                      customWidget.setText("対応クレジットカード",
                          fontWeight: FontWeight.w400,
                          margin: const EdgeInsets.only(bottom: 10)),
                      SizedBox(
                        width: double.infinity, // 与输入框同宽
                        height: 40, // 适当高度
                        child: Image.asset(
                          'assets/creditcard_logo.png',
                          fit: BoxFit.contain, // 保持比例
                          alignment: Alignment.centerLeft, // 左对齐
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
        floatingActionButtonLocation:
            CustomFloatingActionButtonLocation(FloatingActionButtonLocation.centerDocked, 0, 35),
        floatingActionButton: Container(
            height: 100.0,
            width: double.infinity,
            padding: const EdgeInsets.only(left: 15, right: 15),
            decoration: const BoxDecoration(color: CustomColor.white, boxShadow: [
              BoxShadow(
                  color: CustomColor.grayF5,
                  offset: Offset(-5, -5),
                  blurRadius: 5,
                  spreadRadius: 2.0)
            ]),
            child: customWidget.setCupertinoButton("登録",
                margin: const EdgeInsets.only(bottom: 50, top: 10),
                minimumSize: 150, onPressed: () {
              if (cardController.text.trim().isEmpty ||
                  expYearController.text.trim().isEmpty ||
                  expMonthController.text.trim().isEmpty ||
                  cscController.text.trim().isEmpty ||
                  nameController.text.trim().isEmpty) {
                customWidget.toastShow("必須項目を入力して<ださい", notifyType: NotifyType.warning);
              } else {
                String formattedExpiry = "${expMonthController.text.padLeft(2, '0')}/${expYearController.text.padLeft(2, '0')}";
                var map = {
                  "card_number": cardController.text.trim(),
                  "card_expire": formattedExpiry,
                  "security_code": cscController.text.trim(),
                  "cardholder_name": nameController.text.trim(),
                  "lang": "ja",
                  "token_api_key":tokenApiKey
                };
                print(map);
                backEndRepository.doPost(Constant.getCreditCardToken, params: map,
                    successRequest: (res) {
                      var cmap = {"token":res['token']};
                  backEndRepository.doPost(Constant.creditCard, params: cmap,
                    successRequest: (res) {
                      customWidget.toastShow("クレジットカード登録しました");
                      EventBusUtil.fire(Constant.FLAG);
                  Routes.finishPage(context: context);
                });
                }, 
                errorRequest: (error, stackTrace, msg) {
                  customWidget.toastShow(msg);
                },);
              }
            })));
  }

}

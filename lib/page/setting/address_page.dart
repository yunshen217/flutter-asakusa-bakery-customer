import 'package:flutter/material.dart';
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

///地址信息//配送先情報の選択
class AddressPage extends StatefulWidget {
  final Map map;

  const AddressPage(this.map, {super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController postController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController proviceController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController houseController = TextEditingController();

  RxBool isSwitch = false.obs;
  String prefecturesCode = "";
  bool isExist = false;

  @override
  void initState() {
    if (widget.map.isNotEmpty) {
      nameController.text = widget.map[Constant.FLAG].nickName;
      phoneController.text = widget.map[Constant.FLAG].telephoneNo;
      postController.text = widget.map[Constant.FLAG].postcode;
      cityController.text = widget.map[Constant.FLAG].municipalities;
      countryController.text = widget.map[Constant.FLAG].streetAddress;
      houseController.text = widget.map[Constant.FLAG].building;
      proviceController.text = widget.map[Constant.FLAG].prefecturesCodeName;
      isSwitch.value = widget.map[Constant.FLAG].defaultFlag == "1";
      prefecturesCode = widget.map[Constant.FLAG].prefecturesCode;
      isExist = true;
    }
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    postController.dispose();
    cityController.dispose();
    countryController.dispose();
    houseController.dispose();
    proviceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        resizeToAvoidBottomInset: true,
        appBar: customWidget.setAppBar(
            title: '配送先情報を登録',
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
                    customWidget.setText("氏名",
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
                customWidget.setTextField(nameController, hintText: "氏名"),
                Row(
                  children: [
                    customWidget.setText("郵便番号（ハイフンなし）",
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
                customWidget.setTextField(postController,
                    hintText: "郵便番号（ハイフンなし）", keyboardType: TextInputType.number, onChanged: (e) {
                  if (e.length == 7) {
                    backEndRepository.doGet(Constant.getInfoByPostcode + e, successRequest: (res) {
                      proviceController.text = res['data']['prefectures'];
                      cityController.text = res['data']['municipalities'];
                      prefecturesCode  = res['data']['prefecturesCode'];
                      setState(() {});
                    });
                  }
                }),
                Row(
                  children: [
                    customWidget.setText("住所",
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
                customWidget.setTextField(proviceController, hintText: "都道府県", enabled: false),
                customWidget.setTextField(cityController, hintText: "市区町村", enabled: false),
                customWidget.setTextField(countryController, hintText: "番地"),
                customWidget.setTextField(houseController, hintText: "建物名・部屋番号", maxLength: 32),
                Row(
                  children: [
                    customWidget.setText("電話番号（ハイフンなし）",
                        fontWeight: FontWeight.w400,
                        margin: const EdgeInsets.only(bottom: 10, top: 10)),
                    Container(
                        margin: const EdgeInsets.only(bottom: 5, left: 10, top: 10),
                        decoration: BoxDecoration(
                            color: CustomColor.redE8, borderRadius: BorderRadius.circular(5.0)),
                        child: customWidget.setText("必須",
                            fontSize: 10,
                            color: CustomColor.white,
                            padding: const EdgeInsets.only(left: 5, right: 5)))
                  ],
                ),
                customWidget.setTextField(phoneController,
                    keyboardType: TextInputType.number, hintText: "入力してください"),
                ListTile(
                    contentPadding: EdgeInsets.zero,
                    minTileHeight: 50,
                    title: customWidget.setText("既定の住所に設定", fontWeight: FontWeight.w500),
                    subtitle: customWidget.setText("注意：注文すると優先的にその住所が使用されます",
                        fontSize: 12, color: CustomColor.grayC5),
                    trailing: Obx(() => Switch(
                        activeColor: CustomColor.white,
                        inactiveTrackColor: CustomColor.white,
                        inactiveThumbColor: CustomColor.grayC5,
                        activeTrackColor: CustomColor.redE8,
                        onChanged: (e) => isSwitch.value = !isSwitch.value,
                        value: isSwitch.value))),
                customWidget.setText("お店の方からご注文内容についてご連絡する場合  がございます",
                    fontWeight: FontWeight.w500,
                    maxLines: 2,
                    color: CustomColor.redE8,
                    margin: const EdgeInsets.only(bottom: 100, top: 10)),
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
            child: customWidget.setCupertinoButton(isExist ? "更新" : "登録",
                margin: const EdgeInsets.only(bottom: 50, top: 10),
                minimumSize: 150, onPressed: () {
              if (nameController.text.trim().isEmpty ||
                  phoneController.text.trim().isEmpty ||
                  postController.text.trim().isEmpty ||
                  cityController.text.trim().isEmpty ||
                  proviceController.text.trim().isEmpty ||
                  countryController.text.trim().isEmpty) {
                customWidget.toastShow("必須項目を入力して<ださい", notifyType: NotifyType.warning);
              } else {
                var map = {
                  "id": widget.map[Constant.FLAG] != null ? widget.map[Constant.FLAG].id : "",
                  "nickName": nameController.text.trim(),
                  "telephoneNo": phoneController.text.trim(),
                  "postcode": postController.text.trim(),
                  "municipalities": cityController.text.trim(),
                  "streetAddress": countryController.text.trim(),
                  "building": houseController.text.trim(),
                  "prefecturesCode": prefecturesCode,
                  "defaultFlag": isSwitch.value ? "1" : "0"
                };
                print(map);
                if (isExist) {
                  backEndRepository.doPut(Constant.editCustomerAddress,
                      params: map, successRequest: (res) {
                    succeed(res, context);
                  });
                } else {
                  backEndRepository.doPost(Constant.editCustomerAddress,
                      params: map, successRequest: (res) {
                    succeed(res, context);
                  });
                }
              }
            })));
  }

  void succeed(res, BuildContext context) {
    customWidget.toastShow(res['msg']);
    EventBusUtil.fire(Constant.FLAG);
    Routes.finishPage(context: context);
  }
}

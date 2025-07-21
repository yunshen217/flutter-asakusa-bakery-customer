import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pickers/time_picker/model/pduration.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:shopping_client/common/InitEventBus.dart';
import 'package:shopping_client/common/utils.dart';
import 'package:shopping_client/model/GoodModel.dart';
import 'package:shopping_client/model/UserModel.dart';
import 'package:shopping_client/repository/repository.dart';

import '../../common/Global.dart';
import '../../common/constant.dart';
import '../../common/custom_color.dart';
import '../../common/custom_widget.dart';
import '../../model/GoodsModel.dart';
import '../../model/TimePeriodVo.dart';
import '../../routes/Routes.dart';
import '../../view/BaseScaffold.dart';
import '../../view/CustomFloatingActionButtonLocation.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  RxList type = ["店頭受取", "郵送"].obs;
  RxList time = [].obs;
  var sex = ["男", "女"];
  final RxString _sex = "".obs;
  final RxString _birthday = "".obs;
  final RxString _postType = "".obs;
  final RxString _time = "".obs;
  List<TimePeriodVo>? data;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((e) => SmartDialog.showLoading());
    backEndRepository.doGet(Constant.customerInfoDetail, successRequest: (res) {
      UserModel userModel = UserModel.fromJson(res['data']);
      nameController.text = userModel.nickName!;
      phoneController.text = userModel.phoneNumber!;
      emailController.text = userModel.email!;
      _sex.value = userModel.sex!;
      _birthday.value = userModel.birthday!;
      if (userModel.defaultSendFlag != "-1") {
        _postType.value = type[int.parse(userModel.defaultSendFlag!)];
      }
      getTime(userModel.defaultTimePeriod!);
    });
    super.initState();
  }

  void getTime(String flag) {
    backEndRepository.doPost(Constant.queryPsTimePeriod, params: {
      "periodKind": type.indexWhere((e) => e == _postType.value) + 1
    }, successRequest: (res) {
      List<dynamic> dataList = res['data'];
      data = dataList.map((e) => TimePeriodVo.fromJson(e)).toList();
      time.clear();
      data!.forEach((e) => time.add(e.label));
      if (flag.isNotEmpty) {
        final index = data!.indexWhere((e) => e.id == flag);
        if (index != -1) {
          _time.value = data![index].label!;
        } else {
          _time.value = "";
        }
      }
      SmartDialog.dismiss();
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        appBar: customWidget.setAppBar(
            title: 'アカウントの設定',
            bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1),
                child: Container(
                    height: 1,
                    width: double.infinity,
                    color: CustomColor.grayF5))),
        backgroundColor: CustomColor.white,
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    customWidget.setText("氏名",
                        fontWeight: FontWeight.w400,
                        margin: const EdgeInsets.only(bottom: 10)),
                    Container(
                        margin: const EdgeInsets.only(bottom: 10, left: 10),
                        decoration: BoxDecoration(
                            color: CustomColor.redE8,
                            borderRadius: BorderRadius.circular(5.0)),
                        child: customWidget.setText("必須",
                            fontSize: 10,
                            color: CustomColor.white,
                            padding: const EdgeInsets.only(left: 5, right: 5)))
                  ],
                ),
                customWidget.setTextField(nameController, hintText: "氏名"),
                customWidget.setText("性別",
                    fontWeight: FontWeight.w400,
                    margin: const EdgeInsets.only(bottom: 10)),
                Obx(() => ListTile(
                    contentPadding: const EdgeInsets.only(left: 15, right: 10),
                    minTileHeight: 45,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    tileColor: CustomColor.grayF5,
                    trailing: const Icon(Icons.arrow_drop_down_outlined,
                        color: CustomColor.redE8),
                    leading: customWidget.setText(_sex.value),
                    onTap: () => customWidget.showPicker(context, sex,
                        selectData: _sex.value,
                        onConfirm: (e, pos) => _sex.value = e))),
                customWidget.setText("誕生日",
                    fontWeight: FontWeight.w400,
                    margin: const EdgeInsets.only(bottom: 10, top: 10)),
                Obx(() => ListTile(
                    contentPadding: const EdgeInsets.only(left: 15, right: 10),
                    minTileHeight: 45,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    tileColor: CustomColor.grayF5,
                    trailing: const Icon(Icons.arrow_drop_down_outlined,
                        color: CustomColor.redE8),
                    leading: customWidget.setText(_birthday.value),
                    onTap: () => customWidget.showMyDatePicker(context,
                        selectDate:
                            PDuration.parse(DateTime.parse(_birthday.value)),
                        confirm: (v) => _birthday.value = v))),
                customWidget.setText("メールアドレス",
                    fontWeight: FontWeight.w400,
                    margin: const EdgeInsets.only(bottom: 10, top: 10)),
                customWidget.setTextField(
                  emailController,
                  hintText: "メールアドレス",
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Z0-9@._-]')) // 最大长度限制
                  ],
                ),
                Row(
                  children: [
                    customWidget.setText("電話番号",
                        fontWeight: FontWeight.w400,
                        margin: const EdgeInsets.only(bottom: 10)),
                    Container(
                        margin: const EdgeInsets.only(bottom: 10, left: 10),
                        decoration: BoxDecoration(
                            color: CustomColor.redE8,
                            borderRadius: BorderRadius.circular(5.0)),
                        child: customWidget.setText("必須",
                            fontSize: 10,
                            color: CustomColor.white,
                            padding: const EdgeInsets.only(left: 5, right: 5)))
                  ],
                ),
                customWidget.setTextField(phoneController,
                    hintText: "電話番号",
                    keyboardType: TextInputType.number,
                    maxLength: 11),
                customWidget.setText("お店の方からご注文内容についてご連絡する場合がございます",
                    maxLines: 2,
                    fontWeight: FontWeight.w400,
                    color: CustomColor.redE8,
                    margin: const EdgeInsets.only(bottom: 10)),
                customWidget.setText("デフォルト受取方式",
                    fontWeight: FontWeight.w400,
                    margin: const EdgeInsets.only(bottom: 10)),
                Obx(() => ListTile(
                    contentPadding: const EdgeInsets.only(left: 15, right: 10),
                    minTileHeight: 45,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    tileColor: CustomColor.grayF5,
                    trailing: const Icon(Icons.arrow_drop_down_outlined,
                        color: CustomColor.redE8),
                    leading: customWidget.setText(_postType.value),
                    onTap: () => customWidget.showPicker(context, type,
                            selectData: _postType.value, onConfirm: (e, pos) {
                          _postType.value = e;
                          _time.value = "";
                          getTime("");
                        }))),
                customWidget.setText("デフォルト受取時間",
                    fontWeight: FontWeight.w400,
                    margin: const EdgeInsets.only(bottom: 10, top: 10)),
                Obx(() => ListTile(
                    contentPadding: const EdgeInsets.only(left: 15, right: 10),
                    minTileHeight: 45,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    tileColor: CustomColor.grayF5,
                    trailing: const Icon(Icons.arrow_drop_down_outlined,
                        color: CustomColor.redE8),
                    leading: customWidget.setText(_time.value),
                    onTap: () => customWidget.showPicker(context, time,
                        selectData: _time.value,
                        onConfirm: (e, pos) => _time.value = e))),
                const SizedBox(height: 150)
              ],
            )),
        floatingActionButtonLocation: CustomFloatingActionButtonLocation(
            FloatingActionButtonLocation.centerDocked, 0, 35),
        floatingActionButton: Container(
            height: 100.0,
            width: double.infinity,
            padding: const EdgeInsets.only(left: 15, right: 15),
            decoration:
                const BoxDecoration(color: CustomColor.white, boxShadow: [
              BoxShadow(
                  color: CustomColor.grayF5,
                  offset: Offset(-5, -5),
                  blurRadius: 5,
                  spreadRadius: 2.0)
            ]),
            child: customWidget.setCupertinoButton("登録する",
                margin: const EdgeInsets.only(bottom: 50, top: 10),
                minimumSize: 150, onPressed: () {
              if (phoneController.text.trim().isEmpty) {
                customWidget.toastShow("電話番号を入力して<ださい",
                    notifyType: NotifyType.warning);
                return false;
              } else if (nameController.text.trim().isEmpty) {
                customWidget.toastShow("氏名を入力して<ださい",
                    notifyType: NotifyType.warning);
                return false;
              }
              int? defaultSendFlag =
                  type.indexWhere((e) => e == _postType.value) == -1
                      ? null
                      : type.indexWhere((e) => e == _postType.value);
              var param = {
                "nickName": nameController.text.trim(),
                "email": emailController.text.trim(),
                "phoneNumber": phoneController.text.trim(),
                "sex": _sex.value,
                "birthday": _birthday.value,
                "defaultSendFlag": defaultSendFlag,
                "defaultTimePeriod": _time.isNotEmpty
                    ? data![data!.indexWhere((e) => e.label == _time.value)].id
                    : null,
              };
              print(param);
              backEndRepository.doPut(Constant.editCustomerInfo, params: param,
                  successRequest: (res) {
                //param['userId'] = Global.userInfo!.userId!;
                //param['defaultSend'] = _postType.value;
                //param['defaultTime'] = _time.value;
                //Global.putUserInfo(param);
                customWidget.toastShow("更新成功");
                EventBusUtil.fire(Constant.FLAG);
                Routes.finishPage(context: context);
              });
            })));
  }
}

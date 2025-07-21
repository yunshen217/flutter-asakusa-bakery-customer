import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:shopping_client/common/custom_widget.dart';
import 'package:shopping_client/model/OrderDetailModel.dart';
import 'package:shopping_client/view/BaseScaffold.dart';
import '../../common/InitEventBus.dart';

import '../../adapter/order_pay_adapter.dart';
import '../../common/Global.dart';
import '../../common/constant.dart';
import '../../common/custom_color.dart';
import '../../common/utils.dart';
import '../../model/AddressModel.dart';
import '../../model/GoodModel.dart';
import '../../model/TimePeriodVo.dart';
import '../../model/UserModel.dart';
import '../../model/CalculatePriceVo.dart';
import '../../repository/repository.dart';
import '../../routes/Routes.dart';
import '../../view/CustomRadioCheckbox.dart';
import '../../model/CreditCardModel.dart';
import '../../model/CreditCardsModel.dart';

///支付
class OrderPayPage extends StatefulWidget {
  final Map map;

  const OrderPayPage(this.map, {super.key});

  @override
  State<OrderPayPage> createState() => _OrderPayPageState();
}

class _OrderPayPageState extends State<OrderPayPage> {
  List<GoodModel>? data;
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController pointController = TextEditingController();
  RxList type = ["店頭受取", "郵送"].obs;
  RxList post = ["常温", "冷凍", "冷蔵"].obs;
  final RxString _postType = "".obs;
  RxBool isCheck = true.obs;
  final RxString _time = "".obs;
  final RxString _timeId = "".obs;
  RxList time = [].obs;
  RxList timeIdlist = [].obs;
  List<TimePeriodVo> timeList = [];
  RxString groupValue = "常温".obs;
  var dempData = [];
  Data? address;
  CalculatePriceVo? priceModel;
  UserModel? userModel;
  final RxString selectedValue = ''.obs;
  String pointValue = "利用しない";
  bool isUsePointChecked = false;
  final RxList<CreditCardModel> creditCards = <CreditCardModel>[].obs;
  final RxString selectedCardId = ''.obs;
  final RxString selectedCardNumber = ''.obs;
  final RxString selectedCardExp = ''.obs;
  String disFlag = "0";

  DateTime? _lastClickTime;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((e) => SmartDialog.showLoading());
widget.map[Constant.FLAG]
    .forEach((e) => dempData.add({"itemId": e.id, "count": e.itemCount}));
    data = widget.map[Constant.FLAG] ?? [];
    for (GoodModel obj in data!) {
      var currentDisFlag = obj.disFlag ?? "0";
      if (currentDisFlag == "1") {
        disFlag = "1";
        groupValue.value = "冷凍";
        break;
      }
      if (currentDisFlag == "2") {
        disFlag = "2";
        groupValue.value = "冷蔵";
      }
    }

    backEndRepository.doGet(Constant.psCustomerAddressList,
        successRequest: (res) {
      List<Data>? addresses = AddressModel.fromJson(res).data;
      if (addresses!.isNotEmpty) {
        if (addresses[0].defaultFlag == "1") {
          address = addresses[0];
        }
      }

      ///接口写的一级棒 tmd
      backEndRepository.doGet(Constant.customerInfoDetail,
          successRequest: (res) {
        userModel = UserModel.fromJson(res['data']);
        _postType.value = type[int.parse(userModel!.defaultSendFlag!)];
        if (_postType.value == "店頭受取") {
          phoneController.text = "${userModel!.phoneNumber}";
          _time.value = "引取時間帯を指定";
        } else {
          _time.value = "配達時間帯を指定";
          phoneController.text = address == null ? "" : address!.telephoneNo!;
        }
        setState(() {});
        getTime(userModel!.defaultTimePeriod ?? "");
        getPrice();
      });
    });
    _fetchCreditCards(); 
    EventBusUtil.listen((e) {
      if (e == Constant.FLAG) {
        _fetchCreditCards(); 
      }
    });
    Routes.addPage(context);
    super.initState();
  }

  void getPrice() {
    backEndRepository.doPost(Constant.calculatePrice, params: {
      "distributionMode": post.indexWhere((e) => e == groupValue.value),
      "isSend": type.indexWhere((e) => e == _postType.value),
      "merchantId": widget.map['merchantId'],
      "itemPriceList": dempData,
      "orderAddressId": address == null ? "" : address!.id
    }, successRequest: (res) {
      priceModel = CalculatePriceVo.fromJson(res['data']);
      setState(() {});
      SmartDialog.dismiss();
    });
  }

  @override
  void dispose() {
    phoneController.dispose();
    noteController.dispose();
    Routes.removePage(context);
    super.dispose();
  }

  void _handlePointInput(String e) {
    final total = priceModel!.getTotalPrice();
    final maxAllowed = (userModel!.point! > total) ? total : userModel!.point!;
    final input = int.tryParse(e) ?? 0;
    pointController.text = input > maxAllowed ? "$maxAllowed" : e;
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: customWidget.setAppBar(title: "ご注文内容のご確認"),
      backgroundColor: CustomColor.white,
      body: Column(
        children: [
          buildContainer(top: 0),
          Container(
              color: CustomColor.white,
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Column(children: [
                customWidget.setCardForHeight(
                    margin: const EdgeInsets.only(bottom: 15),
                    padding: const EdgeInsets.only(left: 15, right: 10),
                    child: Row(children: [
                      customWidget.setText("受取方式",
                          color: CustomColor.white,
                          fontWeight: FontWeight.w800),
                      const Spacer(),
                      Obx(() => customWidget.setText(_postType.value,
                          color: CustomColor.white,
                          fontWeight: FontWeight.w800)),
                      const Icon(Icons.arrow_drop_down_sharp,
                          color: CustomColor.white)
                    ]),
                    onTap: () => customWidget.showPicker(context, type,
                            selectData: _postType.value, onConfirm: (e, pos) {
                          _postType.value = e;
                          if (_postType.value == "店頭受取") {
                            _time.value = "引取時間帯を指定";
                            phoneController.text = userModel!.phoneNumber!;
                          } else {
                            _time.value = "配達時間帯を指定";
                            if (address != null) {
                              phoneController.text = address!.telephoneNo!;
                            } else {
                              phoneController.text = "";
                            }
                          }
                          _timeId.value = "";
                          getTime("");
                          getPrice();
                        })),
                customWidget.setCardForHeight(
                    padding: const EdgeInsets.only(left: 15, right: 10),
                    child: Row(children: [
                      customWidget.setText("時間の選択",
                          color: CustomColor.white,
                          fontWeight: FontWeight.w800),
                      const Spacer(),
                      Obx(() => customWidget.setText(_time.value,
                          color: CustomColor.white,
                          fontWeight: FontWeight.w800)),
                      const Icon(Icons.arrow_drop_down_sharp,
                          color: CustomColor.white)
                    ]),
                    onTap: () {
                      if (_postType.value.isEmpty) {
                        customWidget.toastShow("受取方法を選択してください",
                            notifyType: NotifyType.warning);
                      } else if (time.isNotEmpty) {
                        customWidget.showPicker(context, time,
                            selectData: _time.value, onConfirm: (e, v) {
                          _time.value = e;
                          _timeId.value = timeList
                              .firstWhere((element) => element.label == e)
                              .id!;
                        });
                      }
                    }),
                Obx(() => Visibility(
                    visible: _postType.value == "郵送",
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: post
                            .map((e) => RadioMenuButton<String>(
                                value: e,
                                groupValue: groupValue.value,
                                child: customWidget.setText(e),
                                style: ButtonStyle(
                                  iconColor: MaterialStateProperty.resolveWith(
                                      (states) {
                                    if (states
                                        .contains(MaterialState.selected)) {
                                      return CustomColor.redE8;
                                    }
                                    return Colors.grey;
                                  }),
                                ),
                                onChanged: (e) {
                                  if (disFlag == "1" && e.toString() != "冷凍") {
                                    customWidget.toastShow("冷凍必須の商品があります",
                        notifyType: NotifyType.warning);
                                    return;
                                  }
                                  if (disFlag == "2" && e.toString() == "常温") {
                                    customWidget.toastShow("クール便必須の商品があります",
                        notifyType: NotifyType.warning);
                                    return;
                                  }
                                  groupValue.value = e.toString();
                                  getPrice();
                                }))
                            .toList()))),
              ])),
          Obx(() => buildContainer(
              top: _postType.value == "郵送" ? 0 : 10,
              bottom: _postType.value == "郵送" ? 0 : 10)),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => Visibility(
                    visible: _postType.value == "郵送",
                    child: ListTile(
                        tileColor: CustomColor.white,
                        trailing: const Icon(Icons.chevron_right_outlined),
                        contentPadding:
                            const EdgeInsets.only(right: 15, left: 15),
                        title: customWidget.setText(
                            address == null
                                ? "配送先を設定してください"
                                : "${address!.nickName}\t${address!.telephoneNo}",
                            color: address == null
                                ? CustomColor.redE8
                                : CustomColor.black_3),
                        subtitle: address == null
                            ? null
                            : customWidget.setText(
                                "${address!.prefecturesCodeName!}${address!.municipalities!}${address!.streetAddress!}${address!.building!}",
                                color: CustomColor.gray_9),
                        leading: null,
                        onTap: () => Routes.goPageForResult(
                                context, "/ChooseAddressPage",
                                param: {Constant.FLAG: Constant.ID}, then: (e) {
                              if (e != null) {
                                address = e;
                                phoneController.text = e.telephoneNo;
                                getPrice();
                                setState(() {});
                              }
                            })))),
                ListView.builder(
                    itemCount: widget.map[Constant.FLAG].length,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (_, index) =>
                        OrderPayAdapter(widget.map[Constant.FLAG][index])),
                buildContainer(top: 0),
                if (priceModel != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customWidget.setText(
                          "商品代金（税込）：${priceModel!.totalAmount}円",
                          margin: const EdgeInsets.only(left: 15)),
                      Obx(() => Visibility(
                          visible: _postType.value == "郵送",
                          child: customWidget.setText(
                              "配送料（税込）：${priceModel!.deliveryCharge ?? 0}円",
                              margin:
                                  const EdgeInsets.only(top: 5, left: 15)))),
                      Obx(() => Visibility(
                          visible: (groupValue.value == "冷凍" ||
                                  groupValue.value == "冷蔵") &&
                              _postType.value == "郵送",
                          child: customWidget.setText(
                              "クール料（税込）：${priceModel!.refrigerationFee ?? 0}円",
                              margin:
                                  const EdgeInsets.only(top: 5, left: 15)))),
                      customWidget.setText(
                          "利用するpt：${pointController.text.isEmpty ? "0" : pointController.text}円",
                          margin: const EdgeInsets.only(top: 5, left: 15)),
                      customWidget.setText(
                          "合計金額：${priceModel!.totalAmount! + (priceModel!.deliveryCharge ?? 0) + (priceModel!.refrigerationFee ?? 0)}円",
                          fontWeight: FontWeight.bold,
                          margin: const EdgeInsets.only(top: 5, left: 15)),
                    ],
                  ),
                buildContainer(),
                Row(
                  children: [
                    customWidget.setText("連絡が取れるお電話番号(八イフンなし)",
                        fontWeight: FontWeight.bold,
                        margin: const EdgeInsets.only(left: 15, right: 5)),
                    Container(
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
                    keyboardType: TextInputType.number,
                    hintText: "入力してください",
                    margin: const EdgeInsets.only(
                        left: 15, right: 15, top: 15, bottom: 5)),
                customWidget.setText("※お店の方が、注文内容に関してご連絡差し上げることがあります",
                    fontSize: 12,
                    maxLines: 2,
                    color: CustomColor.redE8,
                    margin: const EdgeInsets.only(left: 15, right: 15)),
                InkWell(
                    child: Row(children: [
                      Obx(() => Checkbox(
                          value: isCheck.value,
                          activeColor: CustomColor.redE8,
                          onChanged: (e) => isCheck.value = !isCheck.value)),
                      customWidget.setText("注文情報をデフォルトとして保存",
                          color: CustomColor.gray_6)
                    ]),
                    onTap: () => isCheck.value = !isCheck.value),
                Row(
                  children: [
                    customWidget.setText("商品受取時の要望をお店に伝える",
                        fontWeight: FontWeight.bold,
                        margin: const EdgeInsets.only(left: 15, right: 5)),
                    Container(
                        decoration: BoxDecoration(
                            color: CustomColor.gray_9,
                            borderRadius: BorderRadius.circular(5.0)),
                        child: customWidget.setText("任意",
                            fontSize: 12,
                            color: CustomColor.white,
                            padding: const EdgeInsets.only(left: 5, right: 5)))
                  ],
                ),
                customWidget.setText("不十分な点がございましたらご了承ください",
                    fontSize: 12,
                    color: CustomColor.gray_6,
                    margin: const EdgeInsets.only(left: 15, right: 5, top: 10)),
                customWidget.setTextField(noteController,
                    keyboardType: TextInputType.text,
                    maxLength: 100,
                    maxLines: 5,
                    height: 100,
                    top: 5,
                    counter: false,
                    hintText: "入力してください",
                    margin:
                        const EdgeInsets.only(left: 15, right: 15, top: 15)),
                buildContainer(),
                customWidget.setText("支払い方法",
                    fontWeight: FontWeight.bold,
                    margin: const EdgeInsets.only(left: 15)),
                CustomRadioCheckbox(
                    value: 'paypay',
                    groupValue: selectedValue.value,
                    onChanged: (value) =>
                        setState(() => selectedValue.value = value.toString())),
                // 支付方法选择区域
                CustomRadioCheckbox(
                    value: 'クレジットカード',
                    groupValue: selectedValue.value,
                    onChanged: (value) => setState(() {
                          selectedValue.value = value.toString();
                          if (value == "クレジットカード") {
                            _fetchCreditCards(); // 触发获取信用卡
                          }
                        })),
                // 信用卡选择下拉框
                Obx(() => Visibility(
                      visible: (selectedValue.value == "クレジットカード") && creditCards!.isNotEmpty,
                      child: Column(
                        children: [
                          if (creditCards == null || creditCards!.isEmpty)
                            customWidget.setText(
                              "登録したクレジットカードありません",
                              color: CustomColor.redE8,
                              margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
                            ),
                          customWidget.setCardForHeight(
                            margin: EdgeInsets.only(left: 15, right: 15, top: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: customWidget.setText(
                                    textAlign: TextAlign.center,
                                    selectedCardNumber.value.isEmpty
                                        ? "カードを選択"
                                    : (selectedCardNumber.value + " " + selectedCardExp.value),
                                    color: CustomColor.white
                                  ),
                                ),
                                Icon(Icons.arrow_drop_down),
                              ],
                            ),
                            onTap: () => _showCreditCardPicker(),
                          ),
                          customWidget.setCardForHeight(
                            margin:
                                EdgeInsets.only(left: 15, right: 15, top: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: customWidget.setText("カード登録",
                                      textAlign: TextAlign.center,
                                      color: Colors.white),
                                )
                              ],
                            ),
                            onTap: () =>
                                Routes.goPage(context, "/CreditCardPage"),
                          ),
                        ],
                      ),
                    )),
                Obx(() => Visibility(
                      visible: (selectedValue.value == "クレジットカード") &&
                          creditCards!.isEmpty,
                      child: Column(
                        children: [
                          customWidget.setText("登録されたクレジットカードありません",
                              fontSize: 12,
                              maxLines: 2,
                              color: CustomColor.redE8),
                          customWidget.setCardForHeight(
                            margin:
                                EdgeInsets.only(left: 15, right: 15, top: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: customWidget.setText("カード登録",
                                      textAlign: TextAlign.center,
                                      color: Colors.white),
                                )
                              ],
                            ),
                            onTap: () =>
                                Routes.goPage(context, "/CreditCardPage"),
                          ),
                        ],
                      ),
                    )),
                if (userModel != null)
                  Visibility(
                      visible: userModel!.payFlag != "0",
                      child: Column(
                        children: [
                          CustomRadioCheckbox(
                              value: 'その他',
                              groupValue: selectedValue.value,
                              onChanged: (value) => setState(
                                  () => selectedValue.value = value.toString())),
                          customWidget.setText("※ 「その他」を選択した場合、店舗は個別にご連絡いたします",
                              fontSize: 12,
                              maxLines: 2,
                              color: CustomColor.redE8,
                              margin:
                                  const EdgeInsets.only(left: 15, right: 15))
                        ],
                      )),
                customWidget.setText("ポイント利用",
                    fontWeight: FontWeight.bold,
                    margin: const EdgeInsets.only(left: 15, top: 10)),
                if (userModel != null && priceModel != null)
                  CustomRadioCheckbox(
                      value: '利用する     利用可能ポイント：${userModel!.point ?? 0}',
                      groupValue: pointValue,
                      onChanged: (value) => setState(() {
                            if ((userModel!.point ?? 0) > 0) {
                              pointValue = value.toString();
                              isUsePointChecked = true;
                            }
                          })),
                Visibility(
                    visible: isUsePointChecked,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                            child: customWidget.setTextFieldForOtherForClear(
                                pointController,
                                keyboardType: TextInputType.number,
                                onChanged: _handlePointInput,
                                margin: const EdgeInsets.only(left: 45)),
                            width: 120,
                            height: 35),
                        customWidget.setText("ptを利用する",
                            color: CustomColor.gray_6,
                            margin: const EdgeInsets.only(bottom: 10, left: 10))
                      ],
                    )),
                CustomRadioCheckbox(
                    value: '利用しない',
                    groupValue: pointValue,
                    onChanged: (value) => setState(() {
                          pointValue = value.toString();
                          isUsePointChecked = false;
                          pointController.clear();
                        })),
                buildContainer(bottom: 15),
                customWidget.setCupertinoButton("注文を確定",
                    minimumSize: utils.getScreenSize.width,
                    margin: const EdgeInsets.only(left: 15, right: 15),
                    onPressed: () {
                  if (phoneController.text.trim().isEmpty) {
                    customWidget.toastShow("電話番号を入力してください",
                        notifyType: NotifyType.warning);
                    return;
                  } else if (_time.value == "引取時間帯を指定" ||
                      _time.value == "配達時間帯を指定" ||
                      _time.value.isEmpty) {
                    customWidget.toastShow("時間を選択してください",
                        notifyType: NotifyType.warning);
                    return;
                  } else if (_postType.value.isEmpty) {
                    customWidget.toastShow("受取方法を選択してください",
                        notifyType: NotifyType.warning);
                    return;
                  } else if (address == null &&
                      type.indexWhere((e) => e == _postType.value) == 1) {
                    customWidget.toastShow("既定の住所を設定してください",
                        notifyType: NotifyType.warning);
                    return;
                  } else if (selectedValue.isEmpty) {
                    customWidget.toastShow("支払い方法を選択してください",
                        notifyType: NotifyType.warning);
                    return;
                  } else if (selectedCardId.isEmpty && selectedValue.value == "クレジットカード") {
                    customWidget.toastShow("クレジットカードを選択してください",
                        notifyType: NotifyType.warning);
                    return;
                  }
                  final now = DateTime.now();
                  var usedPoint =
                      pointController.text.isEmpty ? "0" : pointController.text;
                  var paymentChannel;
                  if (selectedValue.value == "paypay") {
                    paymentChannel = "1";
                  } else if (selectedValue.value == "クレジットカード") {
                    paymentChannel = "4";
                  } else {
                    paymentChannel = "20";
                  }
                  var price = priceModel!.getTotalPrice();
                  bool skipPay = false;
                  if (int.parse(usedPoint) == price) {
                    skipPay = true;
                    paymentChannel = "3";
                  }
                  if (_lastClickTime == null ||
                      now.difference(_lastClickTime!) >
                          const Duration(milliseconds: 500)) {
                    backEndRepository.doPost(Constant.submitOrder, params: {
                      "telephone": phoneController.text.trim(),
                      "remark": noteController.text.trim(),
                      "appointmentTime": widget.map[Constant.ID],
                      "distributionMode":
                          post.indexWhere((e) => e == groupValue.value),
                      "isSend": type.indexWhere((e) => e == _postType.value),
                      "merchantId": widget.map['merchantId'],
                      "orderType":
                          widget.map[Constant.ID] == utils.getCurrentDate()
                              ? 0
                              : 1,
                      "timePeriodId": _timeId.value,
                      "orderDetailDTOS": dempData,
                      "orderAddressId": address != null ? address!.id : "",
                      "usedPoint": usedPoint,
                      "saveDefaultFlag": isCheck.value ? "1" : "0",
                      "paymentChannel": paymentChannel
                    }, successRequest: (res) {
                      if (res['msg'] != null) {
                        customWidget.toastShow(res['msg']);
                      }
                      String payOrderId = res['data'];
                      if (selectedValue.value == "paypay" && !skipPay) {
                        backEndRepository.doPost(Constant.payMoney,
                            params: {"orderId": payOrderId}, successRequest: (res) {
                          ///支付等待页面
                          Routes.goPageAndFinish(context, "/OrderPayWaitPage",
                              param: {Constant.ID: payOrderId});
                          utils.launchInBrowserView(res['data']['authStartUrl']);
                        });
                      } else if (selectedValue.value == "クレジットカード" && !skipPay) {
                        backEndRepository.doPost(Constant.creditCardPay,
                            params: {"orderId": payOrderId, "cardId":selectedCardId.value}, successRequest: (res) {
                          ///支付等待ページ
                          Routes.goPageAndFinish(context, "/OrderPayWaitPage",
                              param: {Constant.ID: payOrderId});
                          utils.launchInBrowserView(res['data']['authStartUrl']);
                        });
                      }else {
                        Routes.goPage(context, "/OrderDetailPage",
                            param: {Constant.ID: payOrderId});
                      }
                    });
                    _lastClickTime = now;
                  }
                }),
                customWidget.setText("注文完了後は、キャンセルできませんので予めご了承ください",
                    fontSize: 12,
                    color: CustomColor.redE8,
                    maxLines: 2,
                    margin: const EdgeInsets.only(
                        left: 15, right: 15, top: 15, bottom: 30)),
              ],
            ),
          ))
        ],
      ),
    );
  }

  void getTime(defaultId) {
    backEndRepository.doPost(Constant.queryPsTimePeriod, params: {
      "periodKind": type.indexWhere((e) => e == _postType.value) + 1,
      "merchantId": widget.map['merchantId']
    }, successRequest: (res) {
      List<dynamic> dataList = res['data'];

      timeList = dataList.map((e) => TimePeriodVo.fromJson(e)).toList();

      time.clear();
      if (_postType.value == "店頭受取") {
        bool isTime = (widget.map[Constant.FLAG] as List<GoodModel>)
            .any((e) => e.timePeriodId != 0);
        if (isTime) {
          GoodModel goodModel = (widget.map[Constant.FLAG] as List<GoodModel>)
              .reduce((value, element) =>
                  (element.timePeriodId ?? 0) > (element.timePeriodId ?? 0)
                      ? value
                      : element);
          timeList.forEach((e) {
            if (goodModel.timePeriodId! < int.parse(e.id ?? "0")) {
              time.add(e.label);
              timeIdlist.add(e.id);
            }
          });
          //time.removeLast();
        } else {
          timeList.forEach((e) => time.add(e.label ?? ""));
          timeList.forEach((e) => timeIdlist.add(e.id ?? ""));
        }
      } else {
        timeList.forEach((e) => time.add(e.label));
        timeList.forEach((e) => timeIdlist.add(e.id ?? ""));
      }
      if (defaultId.isNotEmpty && timeIdlist.any((e) => e == defaultId)) {
        //_time.value = data!.indexWhere((e) => e.id == flag).label!;
        _time.value =
            timeList.firstWhere((element) => element.id == defaultId).label!;
        _timeId.value =
            timeList.firstWhere((element) => element.id == defaultId).id!;
      }
      setState(() {});
    });
  }

void _fetchCreditCards() {
  backEndRepository.doGet(Constant.creditCard, successRequest: (res) {
    if (res['data'] is List) {
      final List<dynamic> dataList = res['data'];
      final List<CreditCardModel> cards = dataList
          .map((item) => CreditCardModel.fromJson(item as Map<String, dynamic>))
          .toList();

      creditCards?.assignAll(cards); // 更新 RxList
    } else {
      creditCards?.clear(); // 如果不是列表就清空
    }

    // 设置默认信用卡
    if (creditCards != null && creditCards!.isNotEmpty) {
      final defaultCard = creditCards!.firstWhere(
        (card) => card.defaultCard == "1",
        orElse: () => creditCards!.first,
      );
      selectedCardId.value = defaultCard.cardId ?? "";
      selectedCardNumber.value = defaultCard.cardNumber ?? "";
      selectedCardExp.value = defaultCard.cardExpire ?? "";
    }
  });
}

void _showCreditCardPicker() {
  customWidget.showPicker(
    context,
    creditCards!.map((card) => 
      "${card.cardNumber}"
    ).toList(),
    selectData: (selectedCardNumber.value + "  " + selectedCardExp.value),
    
    onConfirm: (displayText, index) {
      final card = creditCards![index];
      selectedCardId.value = card.cardId!;
      selectedCardNumber.value = card.cardNumber ?? "";
      selectedCardExp.value = card.cardExpire ?? "";
    },
  );
}
  Container buildContainer({double top = 10.0, double bottom = 10.0}) {
    return Container(
        color: CustomColor.grayF5,
        height: 5,
        margin: EdgeInsets.only(bottom: bottom, top: top));
  }
}

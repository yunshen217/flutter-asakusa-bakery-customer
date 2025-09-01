import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:shopping_client/common/constant.dart';
import 'package:shopping_client/view/BaseScaffold.dart';

import '../../adapter/goods_cart_adapter.dart';
import '../../adapter/goods_list_adapter.dart';
import '../../common/Global.dart';
import '../../common/custom_color.dart';
import '../../common/custom_widget.dart';
import '../../common/utils.dart';
import '../../model/GoodModel.dart';
import '../../model/GoodsModel.dart';
import '../../model/ItemKindVo.dart';
import '../../model/ItemKindVos.dart';
import '../../repository/repository.dart';
import '../../routes/Routes.dart';
import '../../view/CustomFloatingActionButtonLocation.dart';
import '../../view/calendar/calendar_widget.dart';
import '../../view/shop_car/add_to_cart_animation.dart';
import 'dart:io';

class SubGoodsPage extends StatefulWidget {
  final Map map;

  const SubGoodsPage(this.map, {super.key});

  @override
  State<SubGoodsPage> createState() => _SubGoodsPageState();
}

class _SubGoodsPageState extends State<SubGoodsPage>
    with AutomaticKeepAliveClientMixin {
  String _type = "パン種類で絞る";
  int itemKindId = 0;
  var maxPrice = 0;
  final RxString flag = "".obs;
  List<GoodModel>? mData = [];
  List<GoodModel>? tempData = [];
  List<String>? items = [];
  List<String>? kindIdList = [];
  GlobalKey<CartIconKey> cartKey = GlobalKey<CartIconKey>();
  late Function(GlobalKey) runAddToCartAnimation;
  var _cartQuantityItems = 0;
  List<GoodModel>? datas;
  List<ItemKindVo>? itemKindModel;
  final RxString _date = utils.formatDate(utils.getCurrentDate()).obs;
  String _dateCopy = utils.formatDate(utils.getCurrentDate());
  RxBool isCheck = false.obs;
  int customerOrderLimit = 0;
  @override
  bool get wantKeepAlive => true;

  // final RxString _tempDate = utils.formatDate(utils.getCurrentDate()).obs;
  // 休息日
  RxList<String> mDates = <String>[].obs;
  // 订满日
  RxList<String> mOrderDates = <String>[].obs;
  // 不可预约日
  RxList<String> unableDays = <String>[].obs;

  List restWeekDay = [];

  @override
  void initState() {
    Future.delayed(Duration.zero).then((e) => SmartDialog.showLoading());

    // backEndRepository.doGet(
    //     "${Constant.getFirstAvailableDay}${widget.map[Constant.FLAG]}/first",
    //     successRequest: (res) {
    //   _date.value = res['data'];
    //   minMonth = int.parse(_date.value.substring(5, 7));
    //   maxMonth = int.parse(_date.value.substring(5, 7)) + 1;
    //   getData([], _date.value);
    // });
    getWeek();
    maxPrice = widget.map['customerOrderLimit'];
    backEndRepository
        .doGet("${Constant.psItemKindList}${widget.map[Constant.FLAG]}/kinds",
            successRequest: (res) {
      items!.clear();
      items!.add("すべて");
      kindIdList!.clear();
      kindIdList!.add("0");
      itemKindModel = ItemKindVos.fromJson(res).data;
      for (var e in itemKindModel!) {
        items!.add(e.kindName!);
        kindIdList!.add(e.id!);
      }
    });
    super.initState();
  }

  getWeek() {
    backEndRepository
        .doGet('${Constant.getRestWeekDay}/${widget.map[Constant.FLAG]}',
            successRequest: (res) {
      setState(() {
        final raw = res['data']["firstDay"];
        _date.value = raw;
        _dateCopy = String.fromCharCodes(raw.runes);
        restWeekDay = res["data"]["calendarList"] ?? "";
      });
      getData([], _date.value);
    });
  }

  void getData(var list, date) {
    backEndRepository.doPost(Constant.psItemList, params: {
      "id": widget.map[Constant.FLAG],
      "appointmentDate": date,
      "kindIdList": list
    }, successRequest: (res) {
      mData = GoodsModel.fromJson(res).data;
      getcancelData(_date.value.substring(0, 4), _date.value.substring(5, 7));
      tempData = mData;
      price.value = 0;
      if (cartKey.currentState != null) {
        _cartQuantityItems = 0;
        cartKey.currentState!.runCartAnimation("0");
      }
      setState(() {});
      SmartDialog.dismiss();
    });
  }

  String trimLeadingZero(String src) => (int.tryParse(src) ?? 0).toString();

  getcancelData(String dataYear, String dataMonth) async {
    Map cancelDataMap = {};
    if (restWeekDay.isNotEmpty) {
      for (var data in restWeekDay) {
        if ((data["month"] ?? 0) == int.tryParse(dataMonth) &&
            '${data["year"] ?? 0}' == dataYear) {
          cancelDataMap = data;
        }
      }
    }
    List<String> mDatesData = [];
    List<String> mOrderDatesList = [];
    List<String> unableDaysData = [];
    if (cancelDataMap.isNotEmpty) {
      if (cancelDataMap["restDays"].length != 0) {
        cancelDataMap["restDays"]
            .forEach((e) => mDatesData.add(int.parse(e.toString()).toString()));
      }
      if (cancelDataMap["stopDays"].length != 0) {
        cancelDataMap["stopDays"].forEach(
            (e) => mOrderDatesList.add(int.parse(e.toString()).toString()));
      }
      if (cancelDataMap["unableDays"].length != 0) {
        cancelDataMap["unableDays"].forEach(
            (e) => unableDaysData.add(int.parse(e.toString()).toString()));
      }
    }
    mDates.value = mDatesData;
    mOrderDates.value = mOrderDatesList;
    unableDays.value = unableDaysData;
  }

  @override
  Widget build(BuildContext context) {
    return AddToCartAnimation(
        cartKey: cartKey,
        dragAnimation:
            const DragToCartAnimationOptions(curve: Curves.easeInToLinear),
        jumpAnimation: const JumpAnimationOptions(),
        createAddToCartAnimation: (runAddToCartAnimation) {
          this.runAddToCartAnimation = runAddToCartAnimation;
        },
        child: BaseScaffold(
            floatingActionButtonLocation: CustomFloatingActionButtonLocation(
                FloatingActionButtonLocation.endFloat, 0, 35),
            body: Column(
              children: [
                Container(
                    margin: const EdgeInsets.only(top: 5, bottom: 5),
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    color: CustomColor.white,
                    child: Column(
                      children: [
                        customWidget.setCardForHeight(
                            margin: const EdgeInsets.only(
                                left: 15, right: 15, bottom: 15),
                            padding: const EdgeInsets.only(left: 15, right: 10),
                            child: Row(children: [
                              customWidget.setText("予約日（製造日）",
                                  fontSize: 13,
                                  color: CustomColor.white,
                                  fontWeight: FontWeight.bold),
                              const Spacer(),
                              Obx(() => customWidget.setText(_date.value,
                                  fontSize: 13,
                                  color: CustomColor.white,
                                  fontWeight: FontWeight.bold)),
                              const Icon(Icons.arrow_drop_down_sharp,
                                  color: CustomColor.white)
                            ]),
                            onTap: () {
                              // getcancelData("${restWeekDay[0]["year"]}", "${restWeekDay[0]["month"]}");
                              showCalendar();
                            }),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            customWidget.setCardForHeight(
                                width: (utils.getScreenSize.width - 35) / 2,
                                margin: const EdgeInsets.only(left: 15),
                                padding: const EdgeInsets.only(left: 14.4),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      customWidget.setText("在庫ありのみ表示",
                                          fontSize: 13,
                                          color: CustomColor.white,
                                          fontWeight: FontWeight.bold),
                                      Transform.scale(
                                        scale: 0.7,
                                        child: Obx(() => Checkbox(
                                            value: isCheck.value,
                                            side: MaterialStateBorderSide
                                                .resolveWith((states) {
                                              if (states.contains(
                                                  MaterialState.selected)) {
                                                return const BorderSide(
                                                    color: Colors.white,
                                                    width: 2);
                                              }
                                              return const BorderSide(
                                                  color: Colors.white,
                                                  width: 2);
                                            }),
                                            materialTapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                            activeColor: CustomColor.redE8,
                                            onChanged: (e) {
                                              isCheck.value = !isCheck.value;
                                              updateDatas();
                                            })),
                                      ),
                                    ]),
                                onTap: () {
                                  isCheck.value = !isCheck.value;
                                  updateDatas();
                                }),
                            customWidget.setCardForHeight(
                                width: (utils.getScreenSize.width - 35) / 2,
                                margin: const EdgeInsets.only(right: 15),
                                padding:
                                    const EdgeInsets.only(left: 15, right: 10),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      customWidget.setText(_type,
                                          fontSize: 13,
                                          color: CustomColor.white,
                                          fontWeight: FontWeight.bold),
                                      const Icon(Icons.arrow_drop_down_sharp,
                                          color: CustomColor.white)
                                    ]),
                                onTap: () => customWidget.showPicker(
                                        context,
                                        selectData: _type,
                                        items, onConfirm: (e, v) {
                                      _type = e;
                                      itemKindId = int.parse(kindIdList![v]);
                                      if (v == 0) {
                                        if (isCheck.value) {
                                          mData = tempData!
                                              .where((e) =>
                                                  e.totalInventoryCount > 0)
                                              .toList();
                                        } else {
                                          mData = tempData;
                                        }
                                      } else {
                                        mData = tempData!
                                            .where((e) =>
                                                e.itemKindId == kindIdList![v])
                                            .where((e) => isCheck.value
                                                ? e.totalInventoryCount > 0
                                                : e.totalInventoryCount >= 0)
                                            .toList();
                                      }
                                      setState(() {});
                                    })),
                          ],
                        )
                      ],
                    )),
                Expanded(
                    child: Container(
                  padding: const EdgeInsets.only(top: 15),
                  color: CustomColor.white,
                  child: mData!.isEmpty
                      ? Center(
                          child: customWidget.setAssetsImg("no_data_2.png",
                              width: 160, height: 135))
                      : ListView.separated(
                          itemCount: mData!.length,
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          separatorBuilder: (context, index) => Container(
                              height: 1,
                              color: CustomColor.grayE,
                              margin:
                                  const EdgeInsets.only(top: 15, bottom: 15)),
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, bottom: 100),
                          itemBuilder: (BuildContext context, int index) =>
                              GoodsListAdapter(mData![index],
                                  mData: tempData,
                                  index: index,
                                  maxPrice: widget.map['customerOrderLimit'],
                                  onTab: (e) => listClick(e, 0),
                                  decreaseOnTab: () => onTab(),
                                  counterCallback: (e) {
                                    mData![index].itemCount = e;
                                    int pos = tempData!.indexWhere(
                                        (e) => e.id == mData![index].id);
                                    tempData![pos].itemCount = e;
                                    setState(() {});
                                  })),
                )),
                Container(
                    height: Platform.isIOS ? 90.0 : 70.0,
                    padding: EdgeInsets.only(
                        left: 15, right: 15, bottom: Platform.isIOS ? 20 : 0),
                    alignment: Alignment.topCenter,
                    decoration: const BoxDecoration(
                        color: CustomColor.white,
                        boxShadow: [
                          BoxShadow(
                              color: CustomColor.grayF5,
                              offset: Offset(-5, -5),
                              blurRadius: 5,
                              spreadRadius: 2.0)
                        ]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Builder(
                            builder: (context) => Obx(() => AddToCartIcon(
                                key: cartKey,
                                price: price.value,
                                icon: const Icon(Icons.shopping_cart),
                                badgeOptions: const BadgeOptions(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white),
                                onTap: () => buildModalBottomSheet(context)))),
                        customWidget.setCupertinoButton("レジに進む（税込)",
                            height: 40, minimumSize: 150, onPressed: () {
                          if (_cartQuantityItems == 0) {
                            customWidget.toastShow("購入数量を選択してください",
                                notifyType: NotifyType.warning);
                            return;
                          } else if (Global.userInfo!.refreshToken == null) {
                            customWidget.showCustomSingleBtnDialog(context,
                                confirm: () =>
                                    Routes.goPage(context, "/LoginPage"));
                            return;
                          }
                          if (SmartDialog.checkExist(tag: "goods")) {
                            SmartDialog.dismiss(
                                tag: "goods", status: SmartStatus.attach);
                          }
                          Routes.goPage(context, "/OrderPayPage", param: {
                            Constant.FLAG: tempData!
                                .where((e) => e.itemCount! > 0)
                                .toList(),
                            "merchantId": widget.map[Constant.FLAG],
                            Constant.ID: _date.value
                          });
                        })
                      ],
                    ))
              ],
            )));
  }

  void updateDatas() {
    if (isCheck.value) {
      if (itemKindId == 0) {
        mData = tempData!.where((e) => e.totalInventoryCount > 0).toList();
      } else {
        mData = tempData!
            .where((e) => e.totalInventoryCount > 0)
            .where((e) => e.itemKindId == '$itemKindId')
            .toList();
      }
    } else {
      if (itemKindId == 0) {
        mData = tempData!.where((e) => e.totalInventoryCount >= 0).toList();
      } else {
        mData = tempData!
            .where((e) => e.totalInventoryCount >= 0)
            .where((e) => e.itemKindId == '$itemKindId')
            .toList();
      }
    }
    setState(() {});
  }

  RxDouble price = 0.0.obs;

  void listClick(GlobalKey widgetKey, int flag) async {
    _cartQuantityItems = ++_cartQuantityItems;
    if (flag == 0) {
      await runAddToCartAnimation(widgetKey);
    }

    await cartKey.currentState!
        .runCartAnimation((_cartQuantityItems).toString());

    List<GoodModel>? data = tempData?.where((e) => e.itemCount! > 0).toList();
    price.value = 0;
    if (data!.isNotEmpty) {
      for (var e in data) {
        price.value += e.price! * e.itemCount!;
      }
    }
    setState(() {});
  }

  void onTab() async {
    _cartQuantityItems = --_cartQuantityItems;
    await cartKey.currentState!
        .runCartAnimation((_cartQuantityItems).toString());
    price.value = 0;
    if (tempData!.isNotEmpty) {
      for (var e in tempData!) {
        price.value += e.price! * e.itemCount!;
      }
    }
    setState(() {});
  }

  showCalendar() {
    customWidget.showCustomNoTitleDialog(context, confirm: () {
      _date.value = _dateCopy;
      getData([], _date.value);
    }, child: StatefulBuilder(builder: (_, state) {
      return SizedBox(
          height: 390,
          width: utils.getScreenSize.width,
          child: Obx(() => CustomCalendarViewer(
              key: UniqueKey(),
              initDate: _dateCopy,
              calendarType: CustomCalendarType.date,
              calendarStyle: CustomCalendarStyle.normal,
              animateDirection: CustomCalendarAnimatedDirection.horizontal,
              movingArrowSize: 15,
              local: "jp",
              showCurrentDayBorder: true,
              mDates: mDates.toSet().toList(),
              mOrderDates: mOrderDates.value,
              unableDays: unableDays.value,
              minMonth: restWeekDay[0]["month"] ?? 0,
              maxMonth: restWeekDay[1]["month"] ?? 0,
              spaceBetweenMovingArrow: 40,
              closedDatesColor: Colors.white.withOpacity(0.7),
              showHeader: true,
              daysMargin:
                  const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
              showBorderAfterDayHeader: false,
              headerAlignment: MainAxisAlignment.spaceEvenly,
              calendarStartDay: CustomCalendarStartDay.sunday,
              activeColor: CustomColor.redE8,
              currentDayBorder: Border.all(color: Colors.transparent),
              duration: const Duration(milliseconds: 200),
              //onDatesUpdated: (date) => [Date(date: DateTime.parse(_date.value))],
              onChange: (year, month) {
                if(_date.value.substring(0, 4)==year&& int.parse(_date.value.substring(5, 7))==int.parse(month)){
                  _dateCopy = _date.value;
                }else{
                  _dateCopy = utils.formatDate(
                    DateTime(int.parse(year), int.parse(month)).toString());
                }
                getcancelData(year, month);
              },
              onDayTapped: (date) {
                setState(() => _dateCopy = date.toString().substring(0, 10));
              })));
    }));
  }

  void buildModalBottomSheet(context) {
    if (SmartDialog.checkExist(tag: "goods")) {
      SmartDialog.dismiss(tag: "goods", status: SmartStatus.attach);
      return;
    }
    var cart = tempData!.where((e) => e.itemCount! > 0).toList();
    SmartDialog.showAttach(
        targetContext: context,
        tag: "goods",
        alignment: Alignment.topCenter,
        maskIgnoreArea: Rect.fromLTRB(0, 0, 0, utils.edgeInsets.bottom + 100),
        builder: (_) => StatefulBuilder(builder: (_, state) {
              return Container(
                height: 350,
                width: utils.getScreenSize.width,
                decoration: const BoxDecoration(
                    color: CustomColor.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15))),
                child: Column(
                  children: [
                    customWidget.setText('選んだ商品',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        margin: const EdgeInsets.only(top: 15, bottom: 15)),
                    Expanded(
                        child: cart.isEmpty
                            ? Center(
                                child: customWidget.setAssetsImg(
                                    "no_data_2.png",
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.contain))
                            : ListView.separated(
                                itemCount: cart.length,
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                separatorBuilder: (context, index) => Container(
                                    height: 1,
                                    color: CustomColor.grayE,
                                    margin: const EdgeInsets.only(
                                        top: 15, bottom: 15)),
                                padding:
                                    const EdgeInsets.only(left: 15, right: 15),
                                itemBuilder: (BuildContext context, int index) {
                                  return GoodsCartAdapter(cart[index],
                                      onTab: (e) => listClick(e, 1),
                                      mData: tempData,
                                      index: index,
                                      maxPrice:
                                          widget.map['customerOrderLimit'],
                                      counterCallback: (e) {
                                        tempData![tempData!.indexWhere(
                                                (i) => i.id == cart[index].id)]
                                            .itemCount = e;
                                        cart[index].itemCount = e;
                                        cart = tempData!
                                            .where((e) => e.itemCount! > 0)
                                            .toList();
                                        updateDatas();
                                        state(() {});
                                        setState(() {});
                                      },
                                      decreaseOnTab: () {
                                        onTab();
                                        state(() {});
                                      });
                                }))
                  ],
                ),
              );
            }));
  }
}

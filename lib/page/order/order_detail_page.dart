import 'package:flutter/material.dart';
import 'package:shopping_client/common/custom_color.dart';
import 'package:shopping_client/common/custom_widget.dart';
import 'package:shopping_client/common/utils.dart';
import 'package:shopping_client/repository/repository.dart';
import 'package:shopping_client/view/BaseScaffold.dart';

import '../../adapter/order_detail_adapter.dart';
import '../../common/constant.dart';
import '../../model/OrderDetailModel.dart';
import '../../routes/Routes.dart';
import '../../view/CustomFloatingActionButtonLocation.dart';

class OrderDetailPage extends StatefulWidget {
  final Map map;

  const OrderDetailPage(this.map, {super.key});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  OrderDetailModel? orderDetailModel;

  @override
  void initState() {
    backEndRepository.doGet("${Constant.orderDetail}${widget.map[Constant.ID]}",
        successRequest: (res) {
      orderDetailModel = OrderDetailModel.fromJson(res['data']);
      setState(() {});
    });
    Routes.addPage(context);
    super.initState();
  }

  @override
  void dispose() {
    Routes.removePage(context);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: widget.map[Constant.TITLE] != null,

        ///订单界面进
        child: Scaffold(
          appBar: customWidget.setAppBar(
              isLeftShow: false,
              leading: BackButton(onPressed: () {
                Routes.finishPage(context: context);
                Routes.finishPage(context: context);
                Routes.finishPage(context: context);
              }),
              title: "オーダー",
              bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(1),
                  child: Container(
                      height: 1,
                      width: double.infinity,
                      color: CustomColor.grayF5))),
          backgroundColor: CustomColor.white,
          body: SingleChildScrollView(
            child: orderDetailModel == null
                ? const SizedBox()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Visibility(
                          visible:
                              int.parse(orderDetailModel!.orderStatus!) > 1,
                          child: Container(
                              margin: const EdgeInsets.only(
                                  left: 0, right: 0, top: 15),
                              width: utils.getScreenSize.width,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, right: 15),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Image.asset(
                                            int.parse(orderDetailModel!
                                                        .orderStatus!) >=
                                                    2
                                                ? "assets/icon_order_one_red.png"
                                                : "assets/icon_order_one_gray.png",
                                            width: 40,
                                            height: 40,
                                          ),
                                          buildLine(int.parse(orderDetailModel!
                                                      .orderStatus!) >=
                                                  3
                                              ? CustomColor.redE8
                                              : CustomColor.gray_9),
                                          Image.asset(
                                            int.parse(orderDetailModel!
                                                        .orderStatus!) >=
                                                    3
                                                ? "assets/icon_order_two_red.png"
                                                : "assets/icon_order_two_gray.png",
                                            width: 40,
                                            height: 40,
                                          ),
                                          buildLine(int.parse(orderDetailModel!
                                                      .orderStatus!) >=
                                                  4
                                              ? CustomColor.redE8
                                              : CustomColor.gray_9),
                                          Image.asset(
                                            int.parse(orderDetailModel!
                                                        .orderStatus!) >=
                                                    4
                                                ? "assets/icon_order_three_red.png"
                                                : "assets/icon_order_three_gray.png",
                                            width: 40,
                                            height: 40,
                                          ),
                                          buildLine(int.parse(orderDetailModel!
                                                      .orderStatus!) >=
                                                  5
                                              ? CustomColor.redE8
                                              : CustomColor.gray_9),
                                          Image.asset(
                                            int.parse(orderDetailModel!
                                                        .orderStatus!) >=
                                                    5
                                                ? "assets/icon_order_four_red.png"
                                                : "assets/icon_order_four_gray.png",
                                            width: 40,
                                            height: 40,
                                          ),
                                          buildLine(int.parse(orderDetailModel!
                                                      .orderStatus!) >=
                                                  6
                                              ? CustomColor.redE8
                                              : CustomColor.gray_9),
                                          Image.asset(
                                            int.parse(orderDetailModel!
                                                        .orderStatus!) >=
                                                    6
                                                ? "assets/icon_order_five_red.png"
                                                : "assets/icon_order_five_gray.png",
                                            width: 40,
                                            height: 40,
                                          )
                                        ],
                                      )),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5),
                                          child: SizedBox(
                                              width: 60,
                                              height: 30,
                                              child: Text("注文確定",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: int.parse(
                                                                  orderDetailModel!
                                                                      .orderStatus!) >=
                                                              2
                                                          ? CustomColor.black_3
                                                          : CustomColor
                                                              .gray_9)))),
                                      Padding(
                                          padding: EdgeInsets.only(
                                              left: (MediaQuery.of(context)
                                                              .size
                                                              .width -
                                                          30 -
                                                          40 * 5) /
                                                      4 -
                                                  20),
                                          child: SizedBox(
                                              width: 60,
                                              height: 30,
                                              child: Text("製作中",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: int.parse(
                                                                  orderDetailModel!
                                                                      .orderStatus!) >=
                                                              2
                                                          ? CustomColor.black_3
                                                          : CustomColor
                                                              .gray_9)))),
                                      Padding(
                                          padding: EdgeInsets.only(
                                              left: (MediaQuery.of(context)
                                                              .size
                                                              .width -
                                                          30 -
                                                          40 * 5) /
                                                      4 -
                                                  20),
                                          child: SizedBox(
                                              width: 60,
                                              height: 30,
                                              child: Text("焼き上り",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: int.parse(
                                                                  orderDetailModel!
                                                                      .orderStatus!) >=
                                                              2
                                                          ? CustomColor.black_3
                                                          : CustomColor
                                                              .gray_9)))),
                                      Padding(
                                          padding: EdgeInsets.only(
                                              left: (MediaQuery.of(context)
                                                              .size
                                                              .width -
                                                          30 -
                                                          40 * 5) /
                                                      4 -
                                                  20),
                                          child: SizedBox(
                                              width: 60,
                                              height: 30,
                                              child: Text("出荷済",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: int.parse(
                                                                  orderDetailModel!
                                                                      .orderStatus!) >=
                                                              2
                                                          ? CustomColor.black_3
                                                          : CustomColor
                                                              .gray_9)))),
                                      Padding(
                                          padding: EdgeInsets.only(
                                              left: (MediaQuery.of(context)
                                                              .size
                                                              .width -
                                                          30 -
                                                          40 * 5) /
                                                      4 -
                                                  20),
                                          child: SizedBox(
                                              width: 60,
                                              height: 30,
                                              child: Text("受取済",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: int.parse(
                                                                  orderDetailModel!
                                                                      .orderStatus!) >=
                                                              2
                                                          ? CustomColor.black_3
                                                          : CustomColor
                                                              .gray_9))))
                                    ],
                                  )
                                ],
                              ))),
                      Visibility(
                          visible: orderDetailModel!.orderStatus == "0",
                          child: customWidget.setText(
                              "申し訳ありません、この注文はキャンセルされました",
                              fontSize: 12,
                              color: CustomColor.redE8,
                              margin: const EdgeInsets.only(
                                  left: 15, right: 15, top: 15))),
                      Visibility(
                          visible: orderDetailModel!.isSend == 0,
                          child: customWidget.setRichText(
                              "受取時間：", "${orderDetailModel?.sendTime}",
                              color: CustomColor.gray_9,
                              subFontWeight: FontWeight.bold,
                              margin: const EdgeInsets.only(
                                  left: 15, right: 15, top: 10))),
                      Visibility(
                          visible: orderDetailModel!.isSend == 1,
                          child: ListTile(
                              leading: null,
                              contentPadding: EdgeInsets.zero,
                              minVerticalPadding: 0.0,
                              minTileHeight: 30,
                              title: customWidget.setRichText("製造日：",
                                  "${orderDetailModel?.sendStartTime()}",
                                  color: CustomColor.gray_9,
                                  subFontWeight: FontWeight.bold,
                                  margin: const EdgeInsets.only(
                                      left: 15, right: 15, top: 15)),
                              subtitle: customWidget.setRichText(
                                  "配達時間：", "${orderDetailModel?.sendEndTime()}",
                                  color: CustomColor.gray_9,
                                  subFontWeight: FontWeight.bold,
                                  margin: const EdgeInsets.only(
                                      left: 15, right: 15)))),
                      Container(
                          height: 5,
                          width: double.infinity,
                          color: CustomColor.grayF5,
                          margin: const EdgeInsets.only(top: 15, bottom: 15)),
                      Row(children: [
                        customWidget.setAssetsImg("icon_order_name.png",
                            margin: const EdgeInsets.only(left: 15, right: 5)),
                        customWidget.setText(orderDetailModel!.merchantName!,
                            margin: const EdgeInsets.only(right: 10)),
                        InkWell(
                            child: Card(
                                color: CustomColor.redE8,
                                child: customWidget.setText("マップ",
                                    color: CustomColor.white,
                                    fontSize: 12,
                                    margin: const EdgeInsets.only(
                                        left: 10, right: 10))),
                            onTap: () => utils.launchInBrowserView(
                                "https://www.google.com/maps/search/?api=1&query=${orderDetailModel!.getLongitude!},${orderDetailModel!.getLatitude!}"))
                      ]),
                      customWidget.setRichText(
                          "注文時間：", orderDetailModel?.orderDate,
                          color: CustomColor.gray_9,
                          margin: const EdgeInsets.only(
                              left: 15, right: 15, top: 15, bottom: 5)),
                      customWidget.setRichText(
                          "注文番号：", orderDetailModel?.orderNo,
                          color: CustomColor.gray_9,
                          margin: const EdgeInsets.only(
                              left: 15, right: 15, bottom: 5)),
                      customWidget.setRichText(
                          "支払方法：", orderDetailModel?.payWay(),
                          color: CustomColor.gray_9,
                          margin: const EdgeInsets.only(
                              left: 15, right: 15, bottom: 5)),
                      customWidget.setRichText(
                          "支払状況：", orderDetailModel?.payState(),
                          color: CustomColor.gray_9,
                          margin: const EdgeInsets.only(
                              left: 15, right: 15, bottom: 5)),
                      Visibility(
                          visible: orderDetailModel!.pickupNo!.isNotEmpty,
                          child: customWidget.setRichText(
                              "受取番号：", orderDetailModel?.pickupNo,
                              color: CustomColor.gray_9,
                              subFontSize: 14,
                              subFontWeight: FontWeight.bold,
                              margin: const EdgeInsets.only(
                                  left: 15, right: 15, bottom: 5))),
                      customWidget.setRichText("ご要望：", orderDetailModel?.remark,
                          color: CustomColor.gray_9,
                          margin: const EdgeInsets.only(
                              left: 15, right: 15, bottom: 5)),
                      if (orderDetailModel?.municipalities != null &&
                          orderDetailModel?.streetAddress != null &&
                          orderDetailModel?.building != null)
                        Visibility(
                            visible: orderDetailModel!.isSend == 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    height: 5,
                                    width: double.infinity,
                                    color: CustomColor.grayF5,
                                    margin: const EdgeInsets.only(top: 15)),
                                customWidget.setRichText(
                                    "郵便番号：", orderDetailModel?.postcode,
                                    color: CustomColor.gray_9,
                                    margin: const EdgeInsets.only(
                                        left: 15,
                                        right: 15,
                                        top: 15,
                                        bottom: 5)),
                                customWidget.setRichText(
                                    "配達先：",
                                    // orderDetailModel?.prefectures +
                                    //     orderDetailModel?.municipalities +
                                    //     orderDetailModel?.streetAddress +
                                    //     orderDetailModel?.building,
                                    (orderDetailModel!.prefectures??"") +
                                        (orderDetailModel!.municipalities??"") +
                                        (orderDetailModel!.streetAddress??"") +
                                        (orderDetailModel!.building??""),
                                    color: CustomColor.gray_9,
                                    margin: const EdgeInsets.only(
                                        left: 15, right: 15, bottom: 5)),
                                customWidget.setRichText(
                                    "連絡先：", orderDetailModel?.phoneNumber,
                                    color: CustomColor.gray_9,
                                    margin: const EdgeInsets.only(
                                        left: 15, right: 15, bottom: 5)),
                                customWidget.setRichText(
                                    "宛先：", orderDetailModel?.sendName,
                                    color: CustomColor.gray_9,
                                    margin: const EdgeInsets.only(
                                        left: 15, right: 15, bottom: 5)),
                              ],
                            )),
                      Container(
                          height: 5,
                          width: double.infinity,
                          color: CustomColor.grayF5,
                          margin: const EdgeInsets.only(top: 15, bottom: 15)),
                      customWidget.setText("詳細",
                          fontWeight: FontWeight.bold,
                          margin: const EdgeInsets.only(left: 15)),
                      ListView.separated(
                          itemCount: orderDetailModel!.psOrderDetails!.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(15),
                          separatorBuilder: (context, index) => Container(
                              height: 1,
                              color: CustomColor.grayE,
                              margin:
                                  const EdgeInsets.only(top: 15, bottom: 15)),
                          itemBuilder: (_, index) => OrderDetailAdapter(
                              orderDetailModel!.psOrderDetails![index])),
                      Container(
                          height: 5,
                          width: double.infinity,
                          color: CustomColor.grayF5,
                          margin: const EdgeInsets.only(top: 15, bottom: 15)),
                      Container(
                          alignment: Alignment.centerRight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              customWidget.setText(
                                  "商品代金（税込）：${orderDetailModel!.getTotalItemPrice()}円",
                                  fontWeight: FontWeight.bold,
                                  color: CustomColor.gray_9,
                                  fontSize: 12,
                                  margin: const EdgeInsets.only(
                                      right: 15, bottom: 5)),
                              customWidget.setText(
                                  "配送料（税込）：${orderDetailModel!.deliveryCharge ?? 0}円",
                                  fontWeight: FontWeight.bold,
                                  color: CustomColor.gray_9,
                                  fontSize: 12,
                                  margin: const EdgeInsets.only(
                                      right: 15, bottom: 5)),
                              customWidget.setText(
                                  "クール料（税込）：${orderDetailModel!.refrigerationFee ?? 0}円",
                                  fontWeight: FontWeight.bold,
                                  color: CustomColor.gray_9,
                                  fontSize: 12,
                                  margin: const EdgeInsets.only(
                                      right: 15, bottom: 5)),
                              customWidget.setText(
                                  "ポイント利用：${orderDetailModel!.usedPoint ?? 0}円",
                                  fontWeight: FontWeight.bold,
                                  color: CustomColor.gray_9,
                                  fontSize: 12,
                                  margin: const EdgeInsets.only(
                                      right: 15, bottom: 5)),
                              customWidget.setText(
                                  "今回獲得ポイント：${orderDetailModel!.earnedPoint ?? 0}円",
                                  fontWeight: FontWeight.bold,
                                  color: CustomColor.gray_9,
                                  fontSize: 12,
                                  margin: const EdgeInsets.only(
                                      right: 15, bottom: 5)),
                              customWidget.setText(
                                  "合計金額：${orderDetailModel!.getTotalItemPrice() + (orderDetailModel!.deliveryCharge ?? 0) + (orderDetailModel!.refrigerationFee ?? 0) - (orderDetailModel!.usedPoint ?? 0)}円",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  margin: const EdgeInsets.only(
                                      right: 15, bottom: 130)),
                            ],
                          ))
                    ],
                  ),
          ),
          // floatingActionButtonLocation:
          //     CustomFloatingActionButtonLocation(FloatingActionButtonLocation.centerDocked, 0, 35),
          // floatingActionButton: Container(
          //     height: 100.0,
          //     width: double.infinity,
          //     decoration: const BoxDecoration(color: CustomColor.white, boxShadow: [
          //       BoxShadow(
          //           color: CustomColor.grayF5,
          //           offset: Offset(-5, -5),
          //           blurRadius: 5,
          //           spreadRadius: 2.0)
          //     ]),
          //     child: customWidget.setCupertinoButton("チャツト",
          //         margin: const EdgeInsets.only(top: 10, bottom: 50, left: 15, right: 15),
          //         onPressed: () => Routes.goPage(context, "/ChatPage",
          //             param: {Constant.ID: orderDetailModel!.psOrderDetails!.first.orderId})))
        ));
  }

  buildSetTopImgBottomText(icon, text, color, {margin = EdgeInsets.zero}) {
    return customWidget.setAssetsImg(icon,
        height: 35, width: 35, margin: margin);
  }

  Expanded buildLine(color) {
    return Expanded(
        child: Container(
            color: color, height: 2, margin: const EdgeInsets.only(top: 20)));
  }
}

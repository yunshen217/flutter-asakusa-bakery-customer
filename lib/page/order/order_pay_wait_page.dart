/*
 * @Author: liuchen 1246158996@qq.com
 * @Date: 2025-03-10 22:28:47
 * @LastEditors: liuchen 1246158996@qq.com
 * @LastEditTime: 2025-03-15 12:21:06
 * @FilePath: /bakery_user/lib/page/order/order_pay_wait.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shopping_client/common/custom_widget.dart';
import 'package:shopping_client/view/BaseScaffold.dart';
import '../../common/custom_color.dart';
import 'package:shopping_client/common/constant.dart';
import '../../repository/repository.dart';
import '../../routes/Routes.dart';
import 'package:shopping_client/common/custom_widget.dart';
import '../../model/OrderDetailModel.dart';

class OrderPayWaitPage extends StatefulWidget {
  final Map map;

  const OrderPayWaitPage(this.map, {super.key});

  @override
  State<OrderPayWaitPage> createState() => _OrderPayWaitPageState();
}

class _OrderPayWaitPageState extends State<OrderPayWaitPage>
    with WidgetsBindingObserver {
  OrderDetailModel? orderDetailModel;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // 注册观察者
    WidgetsBinding.instance.addObserver(this);

    // 设置延迟 300 秒后执行回调函数
    timeStart();
  }

  @override
  void dispose() {
    // 取消注册观察者，防止内存泄漏
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        // 应用回到前台
        backEndRepository.doGet("${Constant.orderDetail}${widget.map[Constant.ID]}", successRequest: (res) {
          orderDetailModel = OrderDetailModel.fromJson(res['data']);
          if (orderDetailModel!.paymentStatus == "1" ||
              orderDetailModel!.paymentStatus == "2") {
            // 支払い済み　or　キャンセル
            Routes.finishPage(context: context);
            Routes.goPageAndFinish(context, "/OrderDetailPage",
                param: {Constant.ID: widget.map[Constant.ID]});
          } else {
            // 未払い
          }
        });
        break;
      case AppLifecycleState.inactive:
        // 应用处于非活动状态
        break;
      case AppLifecycleState.paused:
        // 应用进入后台
        break;
      case AppLifecycleState.detached:
        // 应用与窗口分离
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false, // 阻止返回操作
        child: BaseScaffold(
          appBar: AppBar(
              leading: const SizedBox.shrink(),
              title: const SizedBox.shrink(),
              actions: [
                InkWell(
                    child: IconButton(
                        onPressed: () {
                          showCustomAlert(context);
                        },
                        icon: const Icon(Icons.close)))
              ]),
          backgroundColor: CustomColor.white,
          body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(height: 1.0, color: CustomColor.grayE), // 下划线颜色
            const SizedBox(height: 70),
            const Padding(
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 5),
                child: Text("決済サービスを開き、お支払いを完了してください",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: CustomColor.black_3))),
            const Padding(
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 5),
                child: Text("決済後に必ずこのアプリを開いてください。",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: CustomColor.gray_9))),
            const Padding(
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 5),
                child: Text("※決済できない場合、一度この画面を閉じてください。",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: CustomColor.gray_9)))
          ]),
        ));
  }

  void showCustomAlert(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // 点击背景不关闭对话框
      builder: (BuildContext context) {
        return Stack(
          children: [
            // 半透明背景
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            // 自定义弹层内容
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width - 40,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '現在の注文をキャンセルしてもいいですか？',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF333333),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'この画面を閉じると注文はキャンセルされます。よろしいですか？',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF999999),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                        width: MediaQuery.of(context).size.width - 80,
                        child: TextButton(
                            onPressed: () {
                              backEndRepository.doPut(
                                  "${Constant.orderCancle}${widget.map[Constant.ID]}/cancel",
                                  successRequest: (res) {
                                Routes.finishPage(context: context);
                                Routes.goPageAndFinish(
                                    context, "/OrderDetailPage", param: {
                                  Constant.ID: widget.map[Constant.ID]
                                });
                              });
                            },
                            style: TextButton.styleFrom(
                                backgroundColor: const Color(0xFFE84F43),
                                foregroundColor: const Color(0xFF333333),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(8), // 设置圆角
                                ),
                                textStyle: const TextStyle(
                                    fontSize: 14, color: Color(0xFF333333))),
                            child: const Text("はい"))),
                    SizedBox(
                        width: MediaQuery.of(context).size.width - 80,
                        child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: TextButton.styleFrom(
                                backgroundColor: const Color(0xFFFFFFFF),
                                foregroundColor: const Color(0xFF333333),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(8), // 设置圆角
                                ),
                                side: const BorderSide(
                                  color: CustomColor.grayE0, // 边框颜色
                                  width: 1, // 边框粗细
                                ),
                                textStyle: const TextStyle(
                                    fontSize: 14, color: Color(0xFF333333))),
                            child: const Text("いいえ"))),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// 倒计时300秒
  void timeStart() {
    Timer(const Duration(seconds: 300), () {
      Routes.finishPage(context: context);
      Routes.goPageAndFinish(context, "/OrderDetailPage",
          param: {Constant.ID: widget.map[Constant.ID]});
    });
  }
}

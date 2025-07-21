import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_client/common/custom_color.dart';
import 'package:shopping_client/common/custom_widget.dart';
import 'package:shopping_client/repository/repository.dart';

import '../common/InitEventBus.dart';
import '../common/constant.dart';
import '../model/CreditCardModel.dart';

class CreditCardAdapter extends StatelessWidget {
  final CreditCardModel info;

  const CreditCardAdapter(this.info, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      color: CustomColor.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customWidget.setText(info.cardNumber!,
                  fontWeight: FontWeight.bold, margin: const EdgeInsets.only(bottom: 5)),
              customWidget.setText("有効期限：${info.cardExpire!}"),
              customWidget.setText("名義人：${info.cardholderName!}"),
            ],
          ),
          Column(
            children: [
              Row(
                children: [
                  InkWell(
                      child: Opacity(
                          opacity: 1,
                          child: customWidget.setAssetsImg("icon_del_2.png",
                              margin: const EdgeInsets.only(right: 15), width: 30, height: 30)),
                      onTap: () => customWidget.showCustomDialog(Get.context,
                          isChild: true,
                          title: "カード情報削除しますか",
                          confirm: () => backEndRepository.doDel(Constant.creditCard + "/" + info.cardId!,
                              successRequest: (res) => EventBusUtil.fire(Constant.FLAG)))),
                ],
              ),
              Visibility(
                  visible: info.defaultCard == '1',
                  child: customWidget.setText("デフォルト",
                      color: CustomColor.redE8, margin: const EdgeInsets.only(top: 10))
                  ),
              Visibility(
                visible: info.defaultCard != '1',
                child: InkWell(
                  child: customWidget.setText(
                    "デフォルトにする",
                    fontSize: 12,
                    color: CustomColor.redE8,
                    margin: const EdgeInsets.only(top: 10),
                  ),
                  onTap: () {
                    // 调用设置默认卡的接口
                    backEndRepository.doPut(
                      "${Constant.defaultCreditCard}/${info.cardId}",
                      params: {},
                      successRequest: (res) {
                        customWidget.toastShow("デフォルトカードを更新しました");
                        EventBusUtil.fire(Constant.FLAG); // 刷新页面
                      },
                      errorRequest: (error, stackTrace, msg) {
                        customWidget.toastShow(msg);
                      },
                    );
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

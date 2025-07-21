import 'package:flutter/material.dart';
import 'package:shopping_client/common/custom_color.dart';

import '../common/constant.dart';
import '../common/custom_widget.dart';
import '../model/GoodModel.dart';

class BreadListAdapter extends StatelessWidget {
  final flag;
  final dynamic info;

  const BreadListAdapter(this.flag, this.info, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      if (info.filePath != null) customWidget.loadImg(Constant.picture_url + info.filePath!),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        customWidget.setText(flag == Constant.FLAG_TWO ? info.itemName : info.merchantName,
            margin: const EdgeInsets.only(left: 10), fontWeight: FontWeight.w500),
        customWidget.setText(
            "¥ ${flag == Constant.FLAG_TWO ? info.price : info.sumPrice}${flag == Constant.FLAG_THREE ? "" : "/個"}",
            margin: const EdgeInsets.only(left: 10, top: 10),
            fontWeight: FontWeight.w700),
        if (flag == Constant.FLAG_THREE && info.appointmentTime != null)
          Visibility(
              visible: flag == Constant.FLAG_THREE,
              child: customWidget.setText(
                  "${info.isSend == 0 ? "引取:" : "配達:"}${info.appointmentTime!}",
                  fontSize: 12,
                  margin: const EdgeInsets.only(left: 10, top: 10)))
      ]),
      const Spacer(),
      Visibility(
          visible: flag == Constant.FLAG_THREE,
          child: customWidget.setText(flag == Constant.FLAG_THREE ? info.getState() : "",
              maxLines: 2,
              color: flag == Constant.FLAG_THREE && info.orderStatus == "0" ? CustomColor.redE8 : CustomColor.gray_6,
              fontSize: 12))
    ]);
  }
}

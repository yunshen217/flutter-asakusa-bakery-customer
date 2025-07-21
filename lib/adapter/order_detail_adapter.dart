import 'package:flutter/material.dart';

import '../common/constant.dart';
import '../common/custom_color.dart';
import '../common/custom_widget.dart';
import '../model/OrderDetailVo.dart';

class OrderDetailAdapter extends StatelessWidget {
  final OrderDetailVo info;

  const OrderDetailAdapter(this.info, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      customWidget.loadImg(Constant.picture_url + (info.filePath ?? "")),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        customWidget.setText(info.itemName!,
            margin: const EdgeInsets.only(left: 10), fontWeight: FontWeight.w500),
        customWidget.setText("¥${info.itemPrice}",
            margin: const EdgeInsets.only(left: 10, top: 10), fontWeight: FontWeight.w700),
        customWidget.setText("x${info.itemCount!}",
            fontSize: 12, margin: const EdgeInsets.only(left: 10, top: 10))
      ]),
    ]);
  }
}

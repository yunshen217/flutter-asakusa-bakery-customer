import 'package:flutter/material.dart';
import 'package:shopping_client/common/custom_color.dart';
import 'package:shopping_client/common/custom_widget.dart';

import '../common/constant.dart';
import '../model/GoodModel.dart';

class OrderPayAdapter extends StatelessWidget {
  final GoodModel info;

  const OrderPayAdapter(this.info, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
      height: 80,
      child: Row(
        children: [
          customWidget.loadImg(Constant.picture_url + info.filePath!),
          Column(
           crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customWidget.setText(info.itemName!,
                  margin: const EdgeInsets.only(left: 10, top: 5), fontWeight: FontWeight.bold),
              customWidget.setText("¥${info.price}",
                  margin: const EdgeInsets.only(left: 10), fontWeight: FontWeight.w500),
              customWidget.setText("x${info.itemCount}",
                  margin: const EdgeInsets.only(left: 10, bottom: 5), color: CustomColor.gray_6),
            ],
          )
        ],
      ),
    );
  }
}

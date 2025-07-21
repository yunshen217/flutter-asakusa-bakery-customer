import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping_client/common/custom_color.dart';
import 'package:shopping_client/common/custom_widget.dart';
import 'package:shopping_client/common/utils.dart';

import '../model/GoodModel.dart';

class ChatAdapter extends StatelessWidget {
  final dynamic info;

  const ChatAdapter(this.info, {super.key});

  @override
  Widget build(BuildContext context) {
    return info.businessType != "2"
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customWidget.setAssetsImg("icon_setting_top_left.png",
                  width: 45, height: 45, margin: const EdgeInsets.only(left: 15, right: 10)),
              Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(15),
                  width: utils.getScreenSize.width - 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10), color: CustomColor.grayF5),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    customWidget.setText(info.remark!, maxLines: 10, fontWeight: FontWeight.w500),
                    customWidget.setText(info.createTime!,
                        fontSize: 12, margin: const EdgeInsets.only(top: 5))
                  ]))
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(15),
                  width: utils.getScreenSize.width - 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10), color: CustomColor.grayF5),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    customWidget.setText(info.remark!, maxLines: 10, fontWeight: FontWeight.w500),
                    customWidget.setText(info.createTime!,
                        fontSize: 12, margin: const EdgeInsets.only(top: 5))
                  ])),
              customWidget.setAssetsImg("icon_setting_top_left.png",
                  width: 45, height: 45, margin: const EdgeInsets.only(left: 15, right: 10)),
            ],
          );
  }
}

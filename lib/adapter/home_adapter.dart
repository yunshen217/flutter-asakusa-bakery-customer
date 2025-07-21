import 'package:flutter/material.dart';
import 'package:shopping_client/common/constant.dart';
import 'package:shopping_client/common/custom_color.dart';
import 'package:shopping_client/common/custom_widget.dart';

import '../model/Records.dart';

class HomeAdapter extends StatelessWidget {
  final Records info;

  const HomeAdapter(this.info, {super.key});

  @override
  Widget build(BuildContext context) {
    return customWidget.setCard(
        margin: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15),
        height: 100,
        padding: const EdgeInsets.all(10),
        dy: 1.0,
        dx: 0.0,
        boxShadowColor: CustomColor.grayE,
        blurRadius: 1.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customWidget.loadImg(Constant.picture_url + info.filePath!),
            customWidget.setText(info.merchantName!,
                margin: const EdgeInsets.only(left: 10), fontWeight: FontWeight.bold)
          ],
        ));
  }
}

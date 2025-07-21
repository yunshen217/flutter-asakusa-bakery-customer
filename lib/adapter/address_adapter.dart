import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_client/common/custom_color.dart';
import 'package:shopping_client/common/custom_widget.dart';
import 'package:shopping_client/model/AddressModel.dart';
import 'package:shopping_client/repository/repository.dart';

import '../common/InitEventBus.dart';
import '../common/constant.dart';
import '../common/utils.dart';
import '../model/UserModel.dart';
import '../routes/Routes.dart';

class AddressAdapter extends StatelessWidget {
  final Data info;

  const AddressAdapter(this.info, {super.key});

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
              customWidget.setText(info.nickName!,
                  fontWeight: FontWeight.bold, margin: const EdgeInsets.only(bottom: 5)),
              customWidget.setText("郵便番号：${info.postcode!}"),
              customWidget.setText("電話番号：${info.telephoneNo!}"),
              SizedBox(
                  child: customWidget.setText(
                      "住所：${info.prefecturesCodeName!}${info.municipalities!}${info.streetAddress!}${info.building!}",
                      maxLines: 3),
                  width: utils.getScreenSize.width - 150),
            ],
          ),
          Column(
            children: [
              Row(
                children: [
                  InkWell(
                      child: Opacity(
                          opacity: info.defaultFlag == '0' ? 1 : 0,
                          child: customWidget.setAssetsImg("icon_del_2.png",
                              margin: const EdgeInsets.only(right: 15), width: 30, height: 30)),
                      onTap: () => customWidget.showCustomDialog(Get.context,
                          isChild: true,
                          title: "削除するかどうか",
                          confirm: () => backEndRepository.doDel(Constant.deleteAddress + info.id!,
                              successRequest: (res) => EventBusUtil.fire(Constant.FLAG)))),
                  InkWell(
                      child: customWidget.setAssetsImg("icon_address_edit_2.png",
                          width: 30, height: 30),
                      onTap: () =>
                          Routes.goPage(context, "/AddressPage", param: {Constant.FLAG: info})),
                ],
              ),
              Visibility(
                  visible: info.defaultFlag == '1',
                  child: customWidget.setText("デフォルト",
                      color: CustomColor.redE8, margin: const EdgeInsets.only(top: 10)))
            ],
          )
        ],
      ),
    );
  }
}

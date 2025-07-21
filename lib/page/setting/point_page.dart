import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping_client/common/custom_color.dart';
import 'package:shopping_client/common/custom_widget.dart';
import 'package:shopping_client/repository/repository.dart';
import 'package:shopping_client/view/BaseScaffold.dart';

import '../../common/constant.dart';
import '../../common/utils.dart';
import '../../model/point_model.dart';

class PointPage extends StatefulWidget {
  const PointPage({super.key});

  @override
  State<PointPage> createState() => _PointPageState();
}

class _PointPageState extends State<PointPage> {
  PointModel? pointModel;

  @override
  void initState() {
    backEndRepository.doGet(Constant.getPoint, successRequest: (res) {
      pointModel = PointModel.fromJson(res['data']);
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        appBar: customWidget.setAppBar(title: "ポイント履歴"),
        backgroundColor: CustomColor.white,
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: pointModel == null
              ? Container()
              : Column(
                  children: [
                    ListTile(
                        tileColor: CustomColor.pinkFe70,
                        minTileHeight: 40,
                        title: Center(
                            child: customWidget.setText("ポイント残高${pointModel!.point}pt",
                                fontWeight: FontWeight.w500))),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        customWidget.setText("日時",
                            margin: const EdgeInsets.only(left: 40, top: 10)),
                        customWidget.setText("ポイント",
                            margin: const EdgeInsets.only(right: 20, top: 10)),
                      ],
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: pointModel!.pointHistoryList!.length,
                        itemBuilder: (context, index) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              customWidget.setText(
                                  utils
                                      .formatDate(pointModel!.pointHistoryList![index].createTime!),
                                  margin: const EdgeInsets.only(top: 10, left: 15)),
                              Expanded(
                                  child: customWidget.setText(
                                      pointModel!.pointHistoryList![index].description!
                                          .replaceAll("", "\u200B"),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      margin: const EdgeInsets.only(top: 10, left: 15))),
                              SizedBox(
                                  width: 100,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      customWidget.setText(
                                          pointModel!.pointHistoryList![index].type == "1"
                                              ? "+${pointModel!.pointHistoryList![index].point}pt"
                                              : "-${pointModel!.pointHistoryList![index].point}pt",
                                          margin: const EdgeInsets.only(top: 10),
                                          fontWeight: FontWeight.bold,
                                          color: pointModel!.pointHistoryList![index].type == "1"
                                              ? CustomColor.black_3
                                              : CustomColor.redE8),
                                    ],
                                  )),
                            ],
                          );
                        }),
                  ],
                ),
        ));
  }
}

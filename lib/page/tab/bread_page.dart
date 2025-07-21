import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:shopping_client/common/constant.dart';
import 'package:shopping_client/common/custom_widget.dart';
import 'package:shopping_client/common/utils.dart';
import 'package:shopping_client/routes/Routes.dart';
import 'package:shopping_client/view/BaseScaffold.dart';
import '../../adapter/bread_list_adapter.dart';
import '../../common/custom_color.dart';
import '../../model/GoodModel.dart';
import '../../model/GoodsBreadModel.dart';
import '../../model/GoodsModel.dart';
import '../../model/ItemKindVos.dart';
import '../../model/ItemKindVo.dart';
import '../../repository/repository.dart';

///面包界面
class BreadPage extends StatefulWidget {
  const BreadPage({Key? key}) : super(key: key);

  @override
  _BreadPageState createState() => _BreadPageState();
}

class _BreadPageState extends State<BreadPage> {
  final TextEditingController maxController = TextEditingController(text: null);
  final TextEditingController minController = TextEditingController();
  final TextEditingController lastController = TextEditingController();

  List<ItemKindVo>? items = [];
  List<GoodModel>? mData = [];
  List<String>? kindIdList = [];

  @override
  void initState() {
    backEndRepository.doGet(Constant.getSearchParam, successRequest: (res) {
      items = ItemKindVos.fromJson(res).data;
    });
    getData();
    super.initState();
  }

  void getData() {
    if (items!.isNotEmpty) {
      kindIdList!.clear();
      items!.where((e) => e.select).toList().forEach((e) {
        kindIdList!.add(e.id!);
      });
    }

    backEndRepository.doPost(Constant.allPsItemList, params: {
      "itemName": lastController.text.trim(),
      "startPrice": minController.text.trim(),
      "endPrice": maxController.text.trim(),
      "kindIdList": kindIdList
    }, successRequest: (res) {
      mData = GoodsModel.fromJson(res).data;
      setState(() {});
    });
  }

  @override
  void dispose() {
    maxController.dispose();
    minController.dispose();
    lastController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        backgroundColor: CustomColor.white,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
            actions: [
              Builder(
                  builder: (context) =>  InkWell(
                      child: customWidget.setAssetsImg("icon_filter.png",
                          padding: const EdgeInsets.all(15)),
                      onTap: () {
                        if (SmartDialog.checkExist(tag: "bread")) {
                          SmartDialog.dismiss(tag: "bread", status: SmartStatus.attach);
                          return;
                        }
                        attachDialog(context);
                      }))
            ],
            bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1),
                child: Container(height: 5, width: double.infinity, color: CustomColor.grayF5))),
        body: mData!.isEmpty
            ? CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                      child: Center(
                          child:
                              customWidget.setAssetsImg("no_data_2.png", width: 160, height: 135)))
                ],
              )
            : ListView.separated(
                itemCount: mData!.length,
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(15),
                separatorBuilder: (context, index) => Container(
                    height: 1,
                    color: CustomColor.grayE,
                    margin: const EdgeInsets.only(top: 15, bottom: 15)),
                itemBuilder: (_, index) => InkWell(
                    highlightColor: Colors.white,
                    child: BreadListAdapter(Constant.FLAG_TWO, mData![index]),
                    onTap: () => Routes.goPage(context, "/GoodsDetailPage", param: {
                          Constant.TITLE: mData![index].itemName,
                          Constant.ID: mData![index].id,
                          Constant.ID_2: mData![index].merchantId,
                          Constant.FLAG: Constant.FLAG_ONE
                        }))));
  }

  attachDialog(context) {
    SmartDialog.showAttach(
      targetContext: context,
      tag: "bread",
      alignment: Alignment.bottomCenter,
      maskIgnoreArea: Rect.fromLTRB(0, utils.edgeInsets.top + kToolbarHeight, 0, 0),
      builder: (_) => Container(
        width: utils.getScreenSize.width,
        decoration: const BoxDecoration(
            color: CustomColor.white,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            customWidget.setText("単価（税抜）",
                fontWeight: FontWeight.bold,
                margin: const EdgeInsets.only(left: 15, right: 15, bottom: 10)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                    child: customWidget.setTextField(minController,
                        keyboardType: TextInputType.number,
                        height: 50,
                        margin: const EdgeInsets.only(left: 15)),
                    width: utils.getScreenSize.width / 2 - 15),
                customWidget.setText("~", margin: const EdgeInsets.only(bottom: 5)),
                SizedBox(
                    child: customWidget.setTextField(maxController,
                        keyboardType: TextInputType.number,
                        height: 50,
                        margin: const EdgeInsets.only(right: 15)),
                    width: utils.getScreenSize.width / 2 - 15),
              ],
            ),
            customWidget.setText("パンの種類",
                fontWeight: FontWeight.bold, margin: const EdgeInsets.only(left: 15, right: 15)),
            StatefulBuilder(builder: (_, state) {
              return Container(
                  margin: const EdgeInsets.only(left: 15, right: 15),
                  child: Wrap(
                    spacing: 5.0,
                    runSpacing: -4.0,
                    children: items!
                        .map(
                          (e) => InkWell(
                              child: Chip(
                                  label: customWidget.setText(e.kindName!,
                                      fontSize: 12,
                                      color: e.select ? CustomColor.white : CustomColor.redE8,
                                      fontWeight: FontWeight.w700),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: const BorderSide(color: CustomColor.redE8)),
                                  backgroundColor:
                                      e.select ? CustomColor.redE8 : CustomColor.white),
                              onTap: () {
                                e.select = !e.select;
                                state(() {});
                              }),
                        )
                        .toList(),
                  ));
            }),
            customWidget.setText("キーワード",
                fontWeight: FontWeight.bold,
                margin: const EdgeInsets.only(left: 15, right: 15, bottom: 10)),
            customWidget.setTextField(lastController,
                height: 50,
                hintText: 'キーワードを入力してください',
                margin: const EdgeInsets.only(right: 15, left: 15)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                customWidget.setCupertinoButton("キャンセル",
                    margin: const EdgeInsets.only(left: 15, top: 10, bottom: 15),
                    minimumSize: utils.getScreenSize.width / 2 - 30,
                    color: CustomColor.grayC5,
                    textColor: CustomColor.black_3,
                    onPressed: () => SmartDialog.dismiss(tag: "bread", status: SmartStatus.attach)),
                customWidget.setCupertinoButton("検索",
                    margin: const EdgeInsets.only(right: 15, top: 10, bottom: 15),
                    minimumSize: utils.getScreenSize.width / 2 - 30, onPressed: () {
                  getData();
                  SmartDialog.dismiss(tag: "bread", status: SmartStatus.attach);
                }),
              ],
            )
          ],
        )),
      ),
    );
  }
}

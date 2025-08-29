import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:shopping_client/common/constant.dart';
import 'package:shopping_client/common/custom_widget.dart';
import 'package:shopping_client/common/utils.dart';
import 'package:shopping_client/view/BaseScaffold.dart';

import '../../common/custom_color.dart';
import '../../model/ItemDetailVo.dart';
import '../../model/ShopDetailModel.dart';
import '../../repository/repository.dart';
import '../../routes/Routes.dart';
import '../../view/CustomFloatingActionButtonLocation.dart';

class GoodsDetailPage extends StatefulWidget {
  final Map map;

  const GoodsDetailPage(this.map, {super.key});

  @override
  State<GoodsDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<GoodsDetailPage> {
  ItemDetailVo? shopDetailModel;

  @override
  void initState() {
    backEndRepository.doGet(Constant.psItemDetail + widget.map[Constant.ID],
        successRequest: (res) {
      shopDetailModel = ItemDetailVo.fromJson(res['data']);
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        appBar: customWidget.setAppBar(title: widget.map[Constant.TITLE]),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: shopDetailModel == null
                ? Container()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          height: 350,
                          child: Swiper(
                              itemBuilder: (context, index) {
                                return Image.network(
                                    "${Constant.picture_url}${shopDetailModel!.filePathList![index]}",
                                    fit: BoxFit.cover);
                              },
                              autoplay: true,
                              itemCount: shopDetailModel!.filePathList!.length,
                              containerHeight: 100,
                              scrollDirection: Axis.horizontal,
                              pagination: const SwiperPagination(
                                  alignment: Alignment.bottomCenter,
                                  builder: SwiperPagination.dots))),
                      customWidget.setText("${shopDetailModel!.itemName}",
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          margin: const EdgeInsets.only(left: 15, right: 15, top: 15)),
                      Container(
                          margin: const EdgeInsets.only(left: 15),
                          child: customWidget.setRichText("¥ ${shopDetailModel!.price}(税込)", "/個",
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Container(
                          color: CustomColor.grayF5,
                          height: 1,
                          margin: const EdgeInsets.only(bottom: 10, top: 10)),
                      customWidget.setText("${shopDetailModel!.description}",
                          maxLines: 3, margin: const EdgeInsets.only(left: 15, right: 15)),
                      Container(
                          color: CustomColor.grayF5,
                          height: 5,
                          margin: const EdgeInsets.only(top: 10)),
                      customWidget.setText("原材料名",
                          fontWeight: FontWeight.bold,
                          margin: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 15)),
                      customWidget.setTextOverflow("${shopDetailModel!.ingredients ?? ""}",
                          margin: const EdgeInsets.only(left: 15, right: 15)),
                      Container(
                          color: CustomColor.grayF5,
                          height: 5,
                          margin: const EdgeInsets.only(top: 10)),
                      customWidget.setText("アレルゲン情報（特定8品目）",
                          fontWeight: FontWeight.bold,
                          margin: const EdgeInsets.only(left: 15, right: 15, top: 10)),
                      Container(
                        padding: const EdgeInsets.all(15),
                        margin: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 120),
                        decoration: BoxDecoration(
                            border: Border.all(color: CustomColor.grayC5, width: 1),
                            borderRadius: BorderRadius.circular(5)),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                customWidget.setTopImgBottomText(
                                    icon: shopDetailModel!.allergenList!.contains("1")
                                        ? "icon_one_yellow.png"
                                        : "icon_one_gray.png",
                                    iconSize: 40,
                                    text: "小麦",
                                    margin: EdgeInsets.zero),
                                customWidget.setTopImgBottomText(
                                    icon: shopDetailModel!.allergenList!.contains("2")
                                        ? "icon_two_yellow.png"
                                        : "icon_two_gray.png",
                                    iconSize: 40,
                                    text: "卵",
                                    margin: EdgeInsets.zero),
                                customWidget.setTopImgBottomText(
                                    icon: shopDetailModel!.allergenList!.contains("3")
                                        ? "icon_three_yellow.png"
                                        : "icon_three_gray.png",
                                    iconSize: 40,
                                    text: "乳",
                                    margin: EdgeInsets.zero),
                                customWidget.setTopImgBottomText(
                                    icon: shopDetailModel!.allergenList!.contains("4")
                                        ? "icon_four_yellow.png"
                                        : "icon_four_gray.png",
                                    iconSize: 40,
                                    text: "エビ匹",
                                    margin: EdgeInsets.zero),

                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                customWidget.setTopImgBottomText(
                                    icon: shopDetailModel!.allergenList!.contains("5")
                                        ? "icon_five_yellow.png"
                                        : "icon_five_gray.png",
                                    iconSize: 40,
                                    text: "力二匹",
                                    margin: EdgeInsets.zero),
                                customWidget.setTopImgBottomText(
                                    icon: shopDetailModel!.allergenList!.contains("6")
                                        ? "icon_six_yellow.png"
                                        : "icon_six_gray.png",
                                    iconSize: 40,
                                    text: "そば",
                                    margin: const EdgeInsets.only(left: 0, right: 0, top: 15)),
                                customWidget.setTopImgBottomText(
                                    icon: shopDetailModel!.allergenList!.contains("7")
                                        ? "icon_seven_yellow.png"
                                        : "icon_seven_gray.png",
                                    iconSize: 40,
                                    text: "落花生",
                                    margin: const EdgeInsets.only(left: 0, right: 0, top: 15)),
                                customWidget.setTopImgBottomText(
                                    icon: shopDetailModel!.allergenList!.contains("8")
                                        ? "icon_eight_yellow.png"
                                        : "icon_eight_gray.png",
                                    iconSize: 40,
                                    text: "くるみ",
                                    margin: const EdgeInsets.only(left: 0, right: 0, top: 15)),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  )),
        floatingActionButtonLocation:
            CustomFloatingActionButtonLocation(FloatingActionButtonLocation.centerDocked, 0, 35),
        floatingActionButton: widget.map[Constant.FLAG] == Constant.FLAG_ONE
            ? InkWell(
                child: Container(
                    height: 100.0,
                    width: double.infinity,
                    alignment: Alignment.topCenter,
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    decoration: const BoxDecoration(color: CustomColor.white, boxShadow: [
                      BoxShadow(
                          color: CustomColor.grayF5,
                          offset: Offset(-5, -5),
                          blurRadius: 5,
                          spreadRadius: 2.0)
                    ]),
                    child: customWidget.setText("店舗で購入する>>",
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        margin: const EdgeInsets.only(top: 20))),
                onTap: () async {
                  try {
                    final id = widget.map[Constant.ID_2];
                    final res = await backEndRepository
                        .doGetAsync("${Constant.psMerchantDetail}$id");

                    final shopDetailModel =
                        ShopDetailModel.fromJson(res['data']);

                    if (context.mounted) {
                      Routes.goPage(context, "/GoodsListPage", param: {
                        Constant.FLAG: id,
                        'shopDetailModel': shopDetailModel
                      });
                    }
                  } catch (e) {
                    print("加载失败: $e");
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('加载失败，请稍后再试')),
                      );
                    }
                  }
                })
            : const SizedBox(height: 0, width: 0));
  }
}

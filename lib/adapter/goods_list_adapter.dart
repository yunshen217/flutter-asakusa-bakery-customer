import 'package:flutter/material.dart';
import 'package:shopping_client/common/custom_color.dart';
import 'package:shopping_client/view/item_count.dart';

import '../common/constant.dart';
import '../common/custom_widget.dart';
import '../common/utils.dart';
import '../model/GoodModel.dart';
import '../routes/Routes.dart';
import '../view/AddToCartCounterButton.dart';
import '../view/shop_car/add_to_cart_icon.dart';

class GoodsListAdapter extends StatefulWidget {
  GlobalKey? key;
  var onTab;
  var decreaseOnTab;
  GoodModel info;
  Function(int)? counterCallback;
  List<GoodModel>? mData;
  num? maxPrice;
  int? index;

  GoodsListAdapter(this.info,
      {this.key,
      this.onTab,
      this.decreaseOnTab,
      this.counterCallback,
      this.mData,
      this.maxPrice,
      this.index});

  @override
  State<GoodsListAdapter> createState() => _GoodsListAdapterState();
}

class _GoodsListAdapterState extends State<GoodsListAdapter> {
  final GlobalKey widgetKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
            child: customWidget.loadImg(Constant.picture_url + widget.info.filePath!,
                height: 100, width: 100, key: widgetKey),
            onTap: () => Routes.goPage(context, "/GoodsDetailPage",
                param: {Constant.TITLE: widget.info.itemName, Constant.ID: widget.info.id})),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customWidget.setText(widget.info.itemName!,
                        fontWeight: FontWeight.bold,
                        margin: const EdgeInsets.only(bottom: 5, left: 10)),
                    customWidget.setRichText("¥ ${widget.info.price}(税込)", "/個",
                        fontWeight: FontWeight.w500, margin: const EdgeInsets.only(left: 10)),
                    customWidget.setText("ストック：${widget.info.totalInventoryCount}",
                        fontSize: 12,
                        color: CustomColor.gray_6,
                        margin: const EdgeInsets.only(top: 5, left: 10)),
                  ],
                ),
                onTap: () => Routes.goPage(context, "/GoodsDetailPage",
                    param: {Constant.TITLE: widget.info.itemName, Constant.ID: widget.info.id})),
            Container(
                width: utils.getScreenSize.width - 130,
                alignment: Alignment.centerRight,
                child: AddToCartCounterButton(
                    initNumber: widget.info.itemCount!,
                    maxNumber: widget.info.totalInventoryCount.toInt(),
                    maxPrice: widget.maxPrice,
                    mData: widget.mData,
                    index: widget.index,
                    increaseCallback: () => widget.onTab(widgetKey),
                    decreaseCallback: () => widget.decreaseOnTab(),
                    counterCallback: (int count) => widget.counterCallback!(count),
                    backgroundColor: CustomColor.grayE,
                    buttonFillColor: CustomColor.redE8,
                    buttonIconColor: Colors.white))
          ],
        )
      ],
    );
  }
}

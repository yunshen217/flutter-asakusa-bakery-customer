import 'package:flutter/material.dart';
import 'package:shopping_client/common/custom_color.dart';
import 'package:shopping_client/view/item_count.dart';

import '../common/constant.dart';
import '../common/custom_widget.dart';
import '../common/utils.dart';
import '../model/GoodModel.dart';
import '../view/AddToCartCounterButton.dart';
import '../view/shop_car/add_to_cart_icon.dart';

class GoodsCartAdapter extends StatefulWidget {
  GlobalKey? key;
  var onTab;
  var decreaseOnTab;
  GoodModel info;
  Function(int)? counterCallback;
  List<GoodModel>? mData;
  num? maxPrice;
  int? index;

  GoodsCartAdapter(this.info,
      {this.key,
      this.onTab,
      this.decreaseOnTab,
      this.counterCallback,
      this.mData,
      this.maxPrice,
      this.index});

  @override
  State<GoodsCartAdapter> createState() => _GoodsListAdapterState();
}

class _GoodsListAdapterState extends State<GoodsCartAdapter> {
  final GlobalKey widgetKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customWidget.loadImg(Constant.picture_url + widget.info.filePath!, key: widgetKey),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customWidget.setText(widget.info.itemName!,
                fontWeight: FontWeight.bold, margin: const EdgeInsets.only(bottom: 5, left: 10)),
            customWidget.setRichText("¥ ${widget.info.price}(税込)", "/個",
                fontWeight: FontWeight.w500, margin: const EdgeInsets.only(left: 10)),
            Container(
                width: utils.getScreenSize.width - 110,
                alignment: Alignment.centerRight,
                child: AddToCartCounterButton(
                    initNumber: widget.info.itemCount!,
                    maxNumber: widget.info.totalInventoryCount.toInt(),
                    maxPrice: widget.maxPrice,
                    minNumber: 0,
                    index: widget.index!,
                    mData: widget.mData,
                    increaseCallback: () => widget.onTab(widgetKey),
                    decreaseCallback: () => widget.decreaseOnTab(),
                    counterCallback: (count) => widget.counterCallback!(count),
                    backgroundColor: CustomColor.grayE,
                    buttonFillColor: CustomColor.redE8,
                    buttonIconColor: Colors.white))
          ],
        )
      ],
    );
  }
}

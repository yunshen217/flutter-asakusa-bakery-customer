import 'package:flutter/material.dart';
import 'package:shopping_client/page/order/sub_goods_page.dart';
import 'package:shopping_client/page/order/sub_shop_page.dart';
import 'package:shopping_client/view/BaseScaffold.dart';
import '../../model/ShopDetailModel.dart';
import '../../common/constant.dart';
import '../../common/custom_widget.dart';
import '../../routes/Routes.dart';

///商品列表
class GoodsListPage extends StatefulWidget {
  final Map map;

  const GoodsListPage(this.map, {super.key});

  @override
  State<GoodsListPage> createState() => _GoodsListPageState();
}

class _GoodsListPageState extends State<GoodsListPage> {
  List<Tab> tabs = [const Tab(text: "商品"), const Tab(text: "店舖情報")];
  ShopDetailModel? shopDetailModel;

  @override
  void initState() {
    Routes.addPage(context);
    shopDetailModel = widget.map['shopDetailModel'];
    super.initState();
  }

  @override
  void dispose() {
    Routes.removePage(context);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (shopDetailModel == null) {
    return const Center(child: CircularProgressIndicator());
  }
    return DefaultTabController(
        length: tabs.length,
        child: BaseScaffold(
            appBar: customWidget.setAppBar(
                isTitle: false, titleChild: customWidget.setTabBar(tabs, onTab: (e) {})),
            body: TabBarView(children: [
              SubGoodsPage({Constant.FLAG: widget.map[Constant.FLAG],'customerOrderLimit': shopDetailModel!.customerOrderLimit?? 0}),
              SubShopPage({Constant.FLAG: widget.map[Constant.FLAG],'shopDetailModel':shopDetailModel})
            ])));
  }
}

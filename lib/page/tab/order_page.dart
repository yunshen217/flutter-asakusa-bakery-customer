import 'package:flutter/material.dart';
import 'package:shopping_client/common/InitEventBus.dart';
import 'package:shopping_client/common/custom_widget.dart';
import 'package:shopping_client/repository/repository.dart';
import 'package:shopping_client/view/BaseScaffold.dart';

import '../../adapter/bread_list_adapter.dart';
import '../../common/constant.dart';
import '../../common/custom_color.dart';
import '../../model/OrderListVo.dart';
import '../../routes/Routes.dart';

///订单界面
class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  List<Tab> tabs = [const Tab(text: "過去三ヶ月"), const Tab(text: "すべて")];
  int pageSize = Constant.FLAG_TEN;
  final ScrollController _scrollController = ScrollController();
  var param;
  List<OrderListVo>? homeModels = [];

  @override
  void initState() {
    getData(0);
    EventBusUtil.listen((e) {
      if (e == Constant.REFRESH_O) {
        getData(0);
      }
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        pageSize += Constant.FLAG_TEN;
        getData(0);
      }
    });
    super.initState();
  }

  void getData(tag) {
    if (tag == 0) {
      param = {"pageNum": Constant.FLAG_ONE, "pageSize": pageSize, "timeScope": tag};//过去三个月
    } else {
      param = {"pageNum": Constant.FLAG_ONE, "pageSize": pageSize};//全部
    }
    backEndRepository.doPost(Constant.orderList, params: param, successRequest: (res) {
      homeModels = (res['data']['records'] as List)
    .map((e) => OrderListVo.fromJson(e))
    .toList();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: tabs.length,
        child: BaseScaffold(
            backgroundColor: CustomColor.white,
            appBar: customWidget.setAppBar(
                isLeftShow: false,
                centerTitle: false,
                title: "オーダー",
                bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(50),
                    child: Column(
                      children: [
                        Container(height: 1, width: double.infinity, color: CustomColor.grayF5),
                        Container(
                            height: 50,
                            color: CustomColor.white,
                            alignment: Alignment.centerLeft,
                            child: Container(
                                margin: const EdgeInsets.only(top: 8, bottom: 8, left: 15),
                                width: 200,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(11),
                                    border: Border.all(color: CustomColor.redE8, width: 1)),
                                child: customWidget.setTabBar(tabs,
                                    indicatorPadding: EdgeInsets.zero,
                                    fontSize: 12,
                                    borderRadius: 10,
                                    unselectedLabelColor: CustomColor.redE8,
                                    onTab: (e) => getData(e)))),
                        Container(height: 5, width: double.infinity, color: CustomColor.grayF5)
                      ],
                    ))),
            body: RefreshIndicator(
                color: CustomColor.redE8,
                onRefresh: () async => getData(0),
                child: homeModels!.isEmpty
                    ? CustomScrollView(
                        slivers: [
                          SliverFillRemaining(
                              child: Center(
                                  child: customWidget.setAssetsImg("no_data_2.png",
                                      width: 160, height: 135)))
                        ],
                      )
                    : ListView.separated(
                        itemCount: homeModels!.length,
                        shrinkWrap: true,
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(15),
                        separatorBuilder: (context, index) => Container(
                            height: 1,
                            color: CustomColor.grayE,
                            margin: const EdgeInsets.only(top: 15, bottom: 15)),
                        itemBuilder: (_, index) {
                          if (homeModels!.isEmpty) {
                            return const SizedBox();
                          }
                          return InkWell(
                              child: BreadListAdapter(Constant.FLAG_THREE, homeModels![index]),
                              onTap: () => Routes.goPage(context, "/OrderDetailPage", param: {
                                    Constant.ID: homeModels![index].id,
                                    Constant.TITLE: Constant.FLAG
                                  }));
                        }))));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
